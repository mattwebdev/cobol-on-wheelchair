const express = require('express');
const bodyParser = require('body-parser');
const { spawn } = require('child_process');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static('public'));

// Helper function to run COBOL program
function runCobolProgram(args = []) {
  return new Promise((resolve, reject) => {
    const cobolProcess = spawn(path.join(__dirname, 'bin', 'the.cow'), args);
    let output = '';
    let error = '';

    cobolProcess.stdout.on('data', (data) => {
      output += data.toString();
    });

    cobolProcess.stderr.on('data', (data) => {
      error += data.toString();
    });

    cobolProcess.on('close', (code) => {
      if (code !== 0) {
        console.error('COBOL process error:', error);
        reject(new Error(`COBOL process exited with code ${code}\n${error}`));
      } else {
        resolve(output);
      }
    });

    cobolProcess.on('error', (err) => {
      console.error('Failed to start COBOL process:', err);
      reject(err);
    });
  });
}

// Route handler
app.all('*', async (req, res) => {
  try {
    // Pass request information to COBOL program
    const args = [
      req.path,
      req.method,
      JSON.stringify(req.query),
      JSON.stringify(req.body)
    ];

    const output = await runCobolProgram(args);
    
    // Parse COBOL output
    const [statusCode, contentType, ...contentParts] = output.split('\n');
    const content = contentParts.join('\n');

    res.status(parseInt(statusCode, 10))
       .type(contentType)
       .send(content);
  } catch (error) {
    console.error('Error handling request:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Start server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
  console.log('Press Ctrl+C to stop');
}); 