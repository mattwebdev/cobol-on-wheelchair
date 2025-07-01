# COBOL on Wheelchair

A micro web-framework for COBOL that proves old dogs can learn new tricks! 🦿

## Features

- **Modern Server Architecture**
  - Node.js-based server with hot reloading
  - Development mode with automatic COBOL compilation
  - Static file serving
  - Production-ready deployment options

- **Routing System**
  - Path-based routing with variable support (`/user/%id`)
  - HTTP method support (GET, POST, PUT, PATCH, DELETE)
  - Method-specific route handling

- **Request Handling**
  - Path variables extraction
  - Query string parsing (`?key=value`)
  - Form data processing (POST/PUT/PATCH)
  - URL-decoded parameter support

- **Template Engine**
  - Conditional rendering (`{{#if}}`)
  - Loop support (`{{#each}}`)
  - Variable substitution (`{{variable}}`)
  - HTML escaping for security
  - Array support
  - Clean separation of logic and presentation

## Prerequisites

### Linux/macOS
* [GNU Cobol](https://sourceforge.net/projects/open-cobol/) (`sudo apt-get install open-cobol`)
* Node.js 18 or higher
* Basic understanding of COBOL (or a sense of adventure!)

### Windows
* [GnuCOBOL for Windows](https://sourceforge.net/projects/gnucobol/files/gnucobol/)
  - Download and run the installer (e.g., `GnuCOBOL-3.1.2-64bit-MinGW-setup.exe`)
  - Add GnuCOBOL's bin directory to your PATH (usually `C:\GnuCOBOL\bin`)
* Node.js 18 or higher from [nodejs.org](https://nodejs.org/)
* Windows Terminal or PowerShell
* Docker Desktop (optional, for containerized setup)

## Installation

### Standard Installation

```bash
# Clone the repository
git clone https://github.com/azac/cobol-on-wheelchair/
cd cobol-on-wheelchair

# Install dependencies and compile
npm install
npm run build

# Start development server with hot reload
npm run dev

# OR start production server
npm start

# The application will be available at http://localhost:3000
```

### Docker Installation

The framework includes Docker support for easy setup and deployment:

```bash
# Ensure Docker Desktop is running first!

# Build the Docker image
docker build -t cobol-on-wheelchair .

# Run the container
docker run -p 3000:3000 cobol-on-wheelchair

# For development with hot reload and local file mounting
# On Windows PowerShell:
docker run -p 3000:3000 -v ${PWD}:/app cobol-on-wheelchair npm run dev
# On Windows CMD:
docker run -p 3000:3000 -v %cd%:/app cobol-on-wheelchair npm run dev
# On Linux/macOS:
docker run -p 3000:3000 -v $(pwd):/app cobol-on-wheelchair npm run dev
```

## Development Features

- Hot reloading of COBOL files
- Automatic recompilation on changes
- Development server with live feedback
- Static file serving from `public` directory
- Comprehensive error reporting

## Project Structure

```
/
├── controllers/    # COBOL logic for handling requests
├── engine/        # Template engine components
│   ├── cowtemplate.cbl     # Basic template engine
│   └── cowtemplateplus.cbl # Enhanced template engine with conditionals and loops
├── views/         # Template files (.cow extension)
├── config.cbl     # Route definitions
├── cow.cbl        # Core framework
├── httphandler.cbl # HTTP request handler
├── server.js      # Node.js server
├── package.json   # Node.js dependencies and scripts
└── Dockerfile     # Docker configuration
```

## Troubleshooting

### Common Issues

1. **COBOL Compiler Not Found**
   - **Windows**: Ensure GnuCOBOL is installed and added to PATH
   - **Linux**: Install with `sudo apt-get install open-cobol`
   - **macOS**: Install with Homebrew: `brew install gnu-cobol`

2. **Build Fails**
   - Check if `cobc` is available in your terminal/command prompt
   - Ensure all .cbl files are in their correct directories
   - Try running `npm run clean` before `npm run build`

3. **Docker Issues**
   - Ensure Docker Desktop is running
   - On Windows, use PowerShell or CMD with correct volume mount syntax
   - Check Docker Desktop settings if volume mounting fails

4. **Server Won't Start**
   - Verify Node.js version (18+ required)
   - Check if port 3000 is available
   - Ensure COBOL compilation succeeded
   - Look for the compiled `the.cow` binary

## Quick Start

1. Define a route in `config.cbl`:
```cobol
move "/hello/%name"    to routing-pattern(1).
move "GET"             to routing-method(1).
move "sayhello"        to routing-destiny(1).
```

2. Create a controller in `controllers/sayhello.cbl`:
```cobol
identification division.
program-id. sayhello.

data division.
working-storage section.
01 the-vars.
   03 COW-vars occurs 99 times.
      05 COW-varname    pic x(99).
      05 COW-varvalue   pic x(99).
      05 COW-var-type   pic x(1).

linkage section.
01 path-values.
   05 path-query-values occurs 10 times.
      10 path-query-value-name  pic x(90).
      10 path-query-value       pic x(90).

procedure division using path-values.
    move "username" to COW-varname(1).
    move path-query-value(1) to COW-varvalue(1).
    move "S" to COW-var-type(1).
    
    call 'cowtemplateplus' using the-vars "hello.cow".
    goback.
end program sayhello.
```

3. Create a template in `views/hello.cow`:
```html
<html>
    <body>
        <h1>Hello, {{username}}!</h1>
    </body>
</html>
```

## Examples

The framework includes several examples:
- Basic routing (`/`)
- Path variables (`/showname/Adrian`)
- Calculator with path params (`/showsum/22/11`)
- Form handling with POST (`/form`)
- Advanced template features (`/advanced`)

## Security Features

- Automatic HTML escaping in templates
- Request validation
- Secure static file serving
- Production-ready server configuration

While this is still primarily an educational framework, security best practices are followed where possible.

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## Questions?

Contact: adrian.zandberg@gmail.com

## License

MIT License

Copyright (c) 2024 Adrian Zandberg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
