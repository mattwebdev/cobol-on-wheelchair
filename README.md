# COBOL on Wheelchair

A micro web-framework for COBOL that proves old dogs can learn new tricks! 🦿

## Features

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
  - Basic variable substitution (`{{variable}}`)
  - HTML template support
  - Clean separation of logic and presentation

## Prerequisites

* [GNU Cobol](https://sourceforge.net/projects/open-cobol/) (`sudo apt-get install open-cobol`)
* Apache web server with CGI support
* Basic understanding of COBOL (or a sense of adventure!)
* OR Docker for containerized setup

## Installation

### Standard Installation

```bash
# Clone the repository
git clone https://github.com/azac/cobol-on-wheelchair/
cd cobol-on-wheelchair

# Compile the framework
./downhill.sh
```

### Docker Installation

The framework includes Docker support for easy setup and deployment:

```bash
# Build the Docker image
docker build -t cobol-on-wheelchair .

# Run the container
docker run -p 8080:80 cobol-on-wheelchair

# The application will be available at http://localhost:8080
```

For development, you can mount your local directory:

```bash
docker run -p 8080:80 -v $(pwd):/cow cobol-on-wheelchair
```

## Apache Configuration

The framework comes with a default `.htaccess` file for Apache:

```apache
DirectoryIndex the.cow
Options +ExecCGI
AddHandler cgi-script .cow
RewriteEngine on
RewriteCond %{REQUEST_FILENAME} !-d
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule   ^(.*)$  the.cow/$1 [L]
```

## Project Structure

```
/
├── controllers/    # COBOL logic for handling requests
├── views/         # Template files (.cow extension)
├── config.cbl     # Route definitions
├── cow.cbl        # Framework core
├── Dockerfile     # Docker configuration
└── downhill.sh    # Compilation script
```

## Quick Start

1. Define a route in `config.cbl`:
```cobol
move "/hello/%name"    to routing-pattern(1).
move "GET"             to routing-method(1).
move "sayhello"        to routing-destiny(1).
```

2. Create a controller in `controllers/sayhello.cbl`:
```cobol
move "username" to COW-varname(1).
move COW-query-value(1) to COW-varvalue(1).
call 'cowtemplate' using the-vars "hello.cow".
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

## Security Note

This is a proof-of-concept framework. While it's fun and educational, it's not recommended for production use without additional security measures.

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## Questions?

Contact: adrian.zandberg@gmail.com

## License

[Include your license information here]
