const express = require('express');
const puppeteer = require('puppeteer');

const app = express();
app.use(express.json({ limit: '50mb' }));

const PORT = process.env.PORT || process.env.PDF_SERVICE_PORT || 3456;

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.post('/convert', async (req, res) => {
  const { html_url, html } = req.body;

  if (!html_url && !html) {
    return res.status(400).json({ error: 'Either html_url or html is required' });
  }

  let browser;
  try {
    browser = await puppeteer.launch({
      args: ['--no-sandbox', '--disable-setuid-sandbox'],
    });

    const page = await browser.newPage();

    if (html_url) {
      await page.goto(html_url, { waitUntil: 'networkidle0', timeout: 30000 });
    } else {
      await page.setContent(html, { waitUntil: 'networkidle0', timeout: 30000 });
    }

    // Wait for Google Fonts to fully render
    await new Promise(resolve => setTimeout(resolve, 2000));

    const pdf = await page.pdf({
      format: 'Letter',
      printBackground: true,
      margin: { top: '0', right: '0', bottom: '0', left: '0' },
    });

    res.set('Content-Type', 'application/pdf');
    res.set('Content-Disposition', 'attachment; filename="ebook.pdf"');
    res.send(pdf);

  } catch (err) {
    console.error('PDF conversion error:', err);
    res.status(500).json({ error: err.message });
  } finally {
    if (browser) await browser.close();
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Cipher Studio PDF Service listening on 0.0.0.0:${PORT}`);
});
