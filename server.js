const express = require('express');
const { spawn } = require('child_process');
const bodyParser = require('body-parser');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static('public'));

// Environment setup for COBOL process
const cobolEnv = {
    ...process.env,
    PATH: `${process.env.PATH}:${path.resolve(__dirname)}`,
    DYLD_LIBRARY_PATH: process.env.DYLD_LIBRARY_PATH || '',
    LD_LIBRARY_PATH: process.env.LD_LIBRARY_PATH || ''
};

// Function to execute COBOL program
async function executeCow(req) {
    return new Promise((resolve, reject) => {
        // Set up environment variables that CGI would normally provide
        const env = {
            ...cobolEnv,
            REQUEST_METHOD: req.method,
            QUERY_STRING: new URLSearchParams(req.query).toString(),
            CONTENT_LENGTH: req.headers['content-length'] || '0',
            CONTENT_TYPE: req.headers['content-type'] || '',
            HTTP_ACCEPT: req.headers.accept || '*/*',
            HTTP_USER_AGENT: req.headers['user-agent'] || '',
            PATH_INFO: req.path,
            REMOTE_ADDR: req.ip,
            SERVER_NAME: req.hostname,
            SERVER_PORT: port.toString(),
            SERVER_PROTOCOL: 'HTTP/1.1'
        };

        // Spawn the COBOL program
        const cow = spawn('./the.cow', [], { env });
        let output = '';
        let error = '';

        // Handle POST/PUT data
        if (['POST', 'PUT', 'PATCH'].includes(req.method)) {
            const bodyData = new URLSearchParams(req.body).toString();
            cow.stdin.write(bodyData);
            cow.stdin.end();
        }

        // Collect output
        cow.stdout.on('data', (data) => {
            output += data.toString();
        });

        cow.stderr.on('data', (data) => {
            error += data.toString();
        });

        // Handle process completion
        cow.on('close', (code) => {
            if (code !== 0) {
                console.error('COBOL process error:', error);
                reject(new Error(`COBOL process exited with code ${code}`));
                return;
            }

            // Parse the CGI response
            const [headers, ...body] = output.split('\n\n');
            const responseHeaders = {};
            headers.split('\n').forEach(header => {
                const [key, value] = header.split(': ');
                if (key && value) {
                    responseHeaders[key.toLowerCase()] = value;
                }
            });

            resolve({
                headers: responseHeaders,
                body: body.join('\n\n')
            });
        });
    });
}

// Main request handler
app.all('*', async (req, res) => {
    try {
        const response = await executeCow(req);
        
        // Set response headers
        Object.entries(response.headers).forEach(([key, value]) => {
            res.set(key, value);
        });

        // Send response
        res.send(response.body);
    } catch (error) {
        console.error('Error handling request:', error);
        res.status(500).send('Internal Server Error');
    }
});

// Start server
app.listen(port, () => {
    console.log(`COBOL on Wheelchair (Node.js) running on port ${port}`);
}); 