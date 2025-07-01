# COBOL on Wheelchair 🦿

> A modern web framework that brings COBOL into the 21st century

COBOL on Wheelchair (CoW) combines the reliability of COBOL with modern web development practices. It features a Node.js-based server, hot reloading, and a powerful template engine.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js Version](https://img.shields.io/badge/node-%3E%3D18.0.0-brightgreen)](https://nodejs.org)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/azac/cobol-on-wheelchair/pulls)

## Quick Start

```bash
# Install GnuCOBOL first (see Prerequisites below)

# Get the code
git clone https://github.com/azac/cobol-on-wheelchair/
cd cobol-on-wheelchair

# Install and run
npm install
npm run dev

# Visit http://localhost:3000 🚀
```

## Features

### 🚀 Modern Development Experience
- Hot reloading of COBOL files
- Automatic recompilation
- Node.js-based server
- Docker support
- Static file serving

### 🛣️ Powerful Routing
- Path variables (`/user/%id`)
- Full HTTP method support
- Query string parsing
- Form data handling

### 🎨 Template Engine
- Conditional rendering (`{{#if}}`)
- Loops (`{{#each}}`)
- HTML escaping
- Array support
- Clean syntax

## Prerequisites

### Windows
1. Install [GnuCOBOL](https://sourceforge.net/projects/gnucobol/files/gnucobol/)
   ```powershell
   # Add to PATH (usually):
   C:\GnuCOBOL\bin
   ```
2. Install [Node.js](https://nodejs.org/) (v18+)
3. Optional: Docker Desktop

### Linux/macOS
```bash
# Ubuntu/Debian
sudo apt-get install open-cobol

# macOS
brew install gnu-cobol

# Then install Node.js v18+
```

## Project Structure

```
cobol-on-wheelchair/
├── src/                # Source code
│   ├── core/          # Framework core
│   ├── templates/     # Template engine
│   ├── controllers/   # Request handlers
│   └── views/         # Templates
├── public/            # Static files
├── bin/              # Compiled output
└── server.js         # Node.js server
```

## Development

### Local Development
```bash
# Start dev server with hot reload
npm run dev

# Build only
npm run build

# Production
npm start
```

### Docker Development
```bash
# Build
docker build -t cobol-on-wheelchair .

# Run with hot reload
docker run -p 3000:3000 -v ${PWD}:/app cobol-on-wheelchair npm run dev
```

## Creating Routes

1. Define route in `src/core/config.cbl`:
```cobol
move "/hello/%name" to routing-pattern(1).
move "GET"          to routing-method(1).
move "sayhello"     to routing-destiny(1).
```

2. Create controller in `src/controllers/sayhello.cbl`:
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

procedure division using path-values.
    move "username" to COW-varname(1).
    move path-query-value(1) to COW-varvalue(1).
    move "S" to COW-var-type(1).
    call 'cowtemplateplus' using the-vars "hello.cow".
    goback.
end program sayhello.
```

3. Create template in `src/views/hello.cow`:
```html
<html>
  <body>
    <h1>Hello, {{username}}!</h1>
  </body>
</html>
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `cobc: command not found` | Ensure GnuCOBOL is installed and in PATH |
| Build fails | Run `npm run clean && npm run build` |
| Docker issues | Check Docker Desktop is running |
| Port in use | Change port in server.js or stop other services |

## Examples

- Basic routing: `/`
- Path variables: `/showname/Adrian`
- Calculator: `/showsum/22/11`
- Form handling: `/form`
- Advanced templates: `/advanced`

## Documentation

- [Public Assets](public/README.md)
- [Binary Output](bin/README.md)
- [Tutorial](public/tutorial/index.md)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -am 'Add something amazing'`)
4. Push to the branch (`git push origin feature/amazing`)
5. Create a Pull Request

## Support

- 📫 Email: adrian.zandberg@gmail.com
- 🐛 Issues: [GitHub Issues](https://github.com/azac/cobol-on-wheelchair/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/azac/cobol-on-wheelchair/discussions)

## License

MIT © [Adrian Zandberg](LICENSE)
