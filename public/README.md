# Public Directory

This directory contains static files that are served directly by the Node.js server without processing. These files are accessible to anyone visiting your website.

## Directory Structure

```
public/
├── images/        # Static images, logos, icons
├── tutorial/      # Tutorial documentation and assets
└── LICENSE        # License information for public assets
```

## Usage

Files in this directory are served at the root URL of your website. For example:
- `public/images/logo.png` is accessible at `http://your-site.com/images/logo.png`
- `public/tutorial/index.html` is accessible at `http://your-site.com/tutorial/index.html`

## Guidelines

### Do's
- ✅ Store static assets like images, CSS, and client-side JavaScript
- ✅ Keep documentation and tutorial files
- ✅ Use proper file organization (images in images/, docs in tutorial/, etc.)
- ✅ Optimize images and other assets for web delivery
- ✅ Include necessary attribution and license files

### Don'ts
- ❌ Store sensitive configuration files
- ❌ Place server-side code here
- ❌ Include large binary files or datasets
- ❌ Store temporary or generated files

## Security Notes

Remember that all files in this directory are publicly accessible. Never store:
- Credentials or API keys
- Internal documentation
- Source code
- Personal or sensitive information

## Asset Management

When adding new assets:
1. Use meaningful file names
2. Organize files in appropriate subdirectories
3. Optimize for web delivery
4. Update documentation if needed
5. Include attribution when required

## Performance Tips

- Compress images appropriately
- Use modern image formats (WebP with fallbacks)
- Consider using a CDN for large files
- Implement proper caching headers
- Minify CSS and JavaScript files 