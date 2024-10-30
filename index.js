const express = require('express')
const puppeteer = require('puppeteer')
const pdf = require('html-pdf')
const path = require('path')
const app = express()
const port = 8080

// Set EJS as the templating engine
app.set('view engine', 'ejs')
app.set('views', path.join(__dirname, 'views'))

app.get('/', (req, res) => {
  res.send('Hello World! xyz')
})

app.get('/generate-pdf-puppeteer', async (req, res) => {
  const browser = await puppeteer.launch({
    // executablePath: '/usr/bin/chromium-browser',
    headless: "raw",
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-gpu',
        '--single-process',
        '--no-zygote'
      ]
  })
  
  const page = await browser.newPage()

  // Variables to pass to the EJS template
  const title = 'Custom PDF Document'
  const message = 'This PDF is generated from HTML and CSS using Puppeteer with dynamic content.'

  // Render the EJS template to HTML
  const htmlContent = await new Promise((resolve, reject) => {
    app.render('template', { title, message }, (err, html) => {
      if (err) reject(err)
      else resolve(html)
    })
  })

  await page.setContent(htmlContent)
  const pdfBuffer = await page.pdf({ format: 'A4' })

  await browser.close()

    res.setHeader('Content-type', 'application/pdf')
  res.send(Buffer.from(pdfBuffer))
})

app.get('/generate-pdf-html-pdf', (req, res) => {
    // Variables to pass to the EJS template
    const title = 'Custom PDF Document'
    const message = 'This PDF is generated from HTML and CSS using html-pdf with dynamic content.'
  
    // Render the EJS template to HTML
    app.render('template', { title, message }, (err, html) => {
      if (err) {
        return res.status(500).send('Error rendering PDF template')
      }
  
      // Generate PDF from HTML
      pdf.create(html).toBuffer((err, buffer) => {
        if (err) {
          return res.status(500).send('Error generating PDF')
        }
  
        // Set headers to display the PDF in the browser
        res.setHeader('Content-type', 'application/pdf')
        //res.setHeader('Content-disposition', 'inline; filename="customized.pdf"')
        res.send(buffer)
      })
    })
  })

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})