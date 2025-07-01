# COBOL on Wheelchair Tutorial

Welcome to COBOL on Wheelchair (CoW), a micro web framework that brings modern web development features to COBOL! This tutorial will guide you through setting up and using the framework.

## Prerequisites

- [GNU COBOL](https://sourceforge.net/projects/open-cobol/) (`sudo apt-get install open-cobol`)
- Node.js 18 or higher
- Git (for installation)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/azac/cobol-on-wheelchair
cd cobol-on-wheelchair
```

2. Install dependencies and compile:
```bash
npm install
npm run build
```

3. Start the server:
```bash
# Development mode with hot reload
npm run dev

# Production mode
npm start
```

### Docker Installation

For containerized deployment:
```bash
# Build the image
docker build -t cobol-on-wheelchair .

# Run the container
docker run -p 3000:3000 cobol-on-wheelchair

# For development (with local file mounting)
docker run -p 3000:3000 -v $(pwd):/app cobol-on-wheelchair npm run dev
```

## Project Structure

```
/
├── controllers/    # COBOL logic for handling requests
├── views/         # Template files (.cow extension)
├── config.cbl     # Route definitions
├── server.js      # Node.js server
└── package.json   # Node.js dependencies and scripts
```

## Development Workflow

The development server (npm run dev) provides:
- Automatic recompilation of COBOL files on changes
- Hot reload of the Node.js server
- Immediate feedback in the console
- Static file serving from the `public` directory

## Routing

Routes are defined in `config.cbl`. Each route has three components:
- Pattern: The URL pattern with optional variables
- Method: The HTTP method (GET, POST, PUT, PATCH, DELETE)
- Controller: The COBOL program to handle the request

### Basic Routes

```cobol
*> Simple route
move "/"                    to routing-pattern(1).
move "GET"                  to routing-method(1).
move "indexweb"             to routing-destiny(1).

*> Route with variables
move "/user/%id"            to routing-pattern(2).
move "GET"                  to routing-method(2).
move "showuser"             to routing-destiny(2).
```

### HTTP Methods

CoW supports all standard HTTP methods:
```cobol
*> POST endpoint
move "/submit"              to routing-pattern(3).
move "POST"                 to routing-method(3).
move "handlesubmit"         to routing-destiny(3).

*> PUT endpoint
move "/update/%id"          to routing-pattern(4).
move "PUT"                  to routing-method(4).
move "updateitem"           to routing-destiny(4).
```

## Controllers

Controllers are COBOL programs that handle requests. They receive path variables and request data.

### Basic Controller

```cobol
identification division.
program-id. helloworld.

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

01 http-request-data.
    05 method                   pic x(10).
    05 query-params.
        10 param-count         pic 9(4).
        10 params occurs 50 times.
            15 param-name      pic x(100).
            15 param-value     pic x(1024).
    05 body-params.
        10 body-param-count    pic 9(4).
        10 body-params occurs 50 times.
            15 body-param-name  pic x(100).
            15 body-param-value pic x(1024).

procedure division using path-values http-request-data.
    move "username" to COW-varname(1).
    move "World" to COW-varvalue(1).
    move "S" to COW-var-type(1).
    
    call 'cowtemplateplus' using the-vars "hello.cow".
    goback.
end program helloworld.
```

## Templates

CoW provides a powerful template engine with various features:

### Basic Variable Substitution

```html
<h1>Hello, {{username}}!</h1>
```

### Conditional Rendering

```html
{{#if logged_in}}
    <p>Welcome back, {{username}}!</p>
{{#else}}
    <p>Please log in.</p>
{{/if}}
```

### Loops/Iteration

```html
<ul>
    {{#each items}}
        <li>{{name}}: ${{price}}</li>
    {{/each}}
</ul>
```

### Working with Arrays

In your controller:
```cobol
*> Define array
move "items" to COW-varname(1).
move "A" to COW-var-type(1).
move 2 to COW-array-size(1).

*> Set array items
move "items[0].name" to COW-varname(2).
move "Item 1" to COW-varvalue(2).
move "S" to COW-var-type(2).

move "items[1].name" to COW-varname(3).
move "Item 2" to COW-varvalue(3).
move "S" to COW-var-type(3).
```

### HTML Safety

All variables are automatically HTML-escaped to prevent XSS attacks. Special characters (`<`, `>`, `&`, `"`, `'`) are properly encoded.

## Form Handling

### HTML Form
```html
<form action="/submit" method="POST">
    <input type="text" name="username" required>
    <input type="email" name="email" required>
    <button type="submit">Submit</button>
</form>
```

### Processing Form Data
```cobol
*> In your controller
perform varying i from 1 by 1 until i > body-param-count
    if body-param-name(i) = "username"
        move body-param-value(i) to username
    end-if
    if body-param-name(i) = "email"
        move body-param-value(i) to email
    end-if
end-perform
```

## Complete Example

Check out the advanced example at `/advanced` which demonstrates:
- Conditional rendering
- Array iteration
- Form handling
- HTML safety
- Styling

## Best Practices

1. **Security**
   - Always validate user input
   - Use HTML escaping (automatic in templates)
   - Don't expose sensitive information in URLs

2. **Organization**
   - Keep controllers focused and small
   - Use meaningful route names
   - Comment your code
   - Use consistent naming conventions

3. **Development**
   - Use the development server with hot reload
   - Test your routes thoroughly
   - Keep backups of your COBOL source files
   - Monitor the Node.js server logs

## Troubleshooting

Common issues and solutions:

1. **Server Won't Start**
   - Check Node.js version (18+ required)
   - Verify all dependencies are installed
   - Ensure COBOL compilation succeeded
   - Check port 3000 is available

2. **404 Not Found**
   - Check route definitions in config.cbl
   - Verify the path in the browser
   - Check if the controller exists

3. **Template Issues**
   - Verify variable names match exactly
   - Check for missing closing tags
   - Ensure proper nesting of conditionals

## Questions?

For support or questions:
- Email: adrian.zandberg@gmail.com
- GitHub Issues: [Create an issue](https://github.com/azac/cobol-on-wheelchair/issues)

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for:
- Bug fixes
- New features
- Documentation improvements
- Example code

Remember to delete all .cbl files after final compilation for security.
