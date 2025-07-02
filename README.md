# Character Sheet Portfolio

A unique portfolio website designed like a D&D character sheet, built with Astro for lightning-fast performance and easy content management.

![Character Sheet Portfolio Preview](https://via.placeholder.com/800x400/f8f6f0/2a2520?text=Character+Sheet+Portfolio)

## Features

- Character sheet inspired design with authentic RPG aesthetics
- Dark/light theme toggle with persistent user preference
- Typing animation for the name field on page load
- Fully responsive design that works on all devices
- Markdown blog support with automatic excerpts
- Image support for profile photos and project screenshots
- Optional URLs for projects, books, and music
- Static site generation for blazing fast performance
- Easy content management via JSON files
- Auto-deployment to GitHub Pages

## Quick Start

1. **Use this template**
   ```bash
   git clone https://github.com/YOUR_USERNAME/character-sheet-portfolio.git
   cd character-sheet-portfolio
   npm install
   ```

2. **Start development**
   ```bash
   npm run dev
   ```

3. **Customize your content** (see [Content Management](#content-management) below)

4. **Deploy** (see [Deployment](#deployment) below)

## Project Structure

```
character-sheet-portfolio/
├── src/
│   ├── content/                 # Blog posts and content collections
│   │   ├── blog/               # Your blog posts (.md files)
│   │   │   ├── rust-journey.md
│   │   │   └── shipped-feature.md
│   │   └── config.ts           # Content schema configuration
│   ├── data/                   # Content data (JSON files)
│   │   ├── profile.json        # Your personal info and photo
│   │   ├── projects.json       # Current projects and work
│   │   ├── books.json          # Books you're reading
│   │   ├── music.json          # Podcasts/music you're listening to
│   │   ├── learning.json       # Skills you're learning
│   │   └── links.json          # Social media and contact links
│   ├── layouts/
│   │   └── Layout.astro        # Main layout with all styling
│   └── pages/
│       ├── blog/               # Blog-related pages
│       │   ├── index.astro     # Blog post listing
│       │   └── [...slug].astro # Individual blog post pages
│       └── index.astro         # Homepage with character sheet
├── public/                     # Static assets
│   ├── favicon.svg
│   └── profile-photo.jpg       # Your profile photo goes here
└── .github/workflows/          # Auto-deployment configuration
    └── deploy.yml
```

## Content Management

### Personal Information (`src/data/profile.json`)

```json
{
  "name": "Your Name Here",
  "title": "Developer • Designer • Creator",
  "photo": "/profile-photo.jpg",  // Path to image in public/ folder OR emoji
  "currently": "Building things that matter",
  "focus": "Full Stack Development", 
  "experience": "5+ years"
}
```

**Photo options:**
- **Image file**: Put image in `public/` folder, reference as `/filename.jpg`
- **Emoji**: Use any emoji like "📸" or "👨‍💻"

### Projects (`src/data/projects.json`)

```json
[
  {
    "title": "Project Name",
    "url": "https://github.com/username/project",  // Optional
    "description": "Tech stack or project description",
    "status": "In Progress - 75% Complete"
  }
]
```

**URL field is optional** - omit it for private/internal projects.

### Books (`src/data/books.json`)

```json
[
  {
    "title": "Book Title",
    "author": "Author Name",
    "progress": "Chapter 5 of 12",
    "url": "https://goodreads.com/book/..."  // Optional
  }
]
```

### Music/Podcasts (`src/data/music.json`)

```json
[
  {
    "title": "Podcast/Album Name",
    "description": "Brief description",
    "url": "https://spotify.com/..."  // Optional
  }
]
```

### Learning (`src/data/learning.json`)

Simple array of skills you're currently learning:
```json
[
  "Rust programming language",
  "WebAssembly fundamentals",
  "Advanced TypeScript patterns"
]
```

### Social Links (`src/data/links.json`)

```json
[
  {
    "title": "GitHub",
    "url": "https://github.com/yourusername"
  },
  {
    "title": "Email", 
    "url": "mailto:your.email@example.com"
  }
]
```

## Blog Posts

Create new blog posts in `src/content/blog/` as markdown files:

```markdown
---
title: "Your Post Title"
date: 2024-12-16
excerpt: "Brief description that appears on the homepage"
draft: false  # Set to true to hide the post
---

Your content here with full **markdown** support!

## Subheadings work
- Lists work
- `Code snippets` work
- [Links](https://example.com) work
```

**Blog posts automatically:**
- Show up on the homepage (3 most recent)
- Generate individual pages at `/blog/post-slug`
- Support all markdown features
- Include prev/next navigation

## Customization

### Colors and Styling

All styles are in `src/layouts/Layout.astro`. Key variables to customize:

```css
:root {
  --bg-color: #f8f6f0;        /* Background color */
  --text-color: #2a2520;      /* Main text color */
  --line-color: #4a453f;      /* Border colors */
  --accent-color: #6b6b6b;    /* Links and accents */
}
```

### Profile Photo Size

In `Layout.astro`, find `.photo-placeholder`:
```css
.photo-placeholder {
  width: 150px;    /* Change both values */
  height: 150px;   /* to make photo bigger/smaller */
}
```

### Grid Layout

The character sheet uses CSS Grid. To modify the layout, edit the grid areas in `Layout.astro`:
```css
.main-content {
  grid-template-areas:
    "profile projects"
    "learning projects" 
    "reading listening"
    "notes notes"
    "connect connect";
}
```

### Theme Toggle

The theme toggle is automatic. Users' preferences are saved in localStorage and persist between visits.

## Deployment

### GitHub Pages (Recommended)

1. **Enable GitHub Pages:**
   - Go to repository Settings → Pages
   - Set Source to "GitHub Actions"

2. **Update site URL** in `astro.config.mjs`:
   ```javascript
   export default defineConfig({
     site: 'https://YOUR_USERNAME.github.io',
     base: '/YOUR_REPO_NAME',
   });
   ```

3. **Push to main branch** - auto-deploys in ~2 minutes!

### Other Platforms

**Netlify:** 
- Connect your GitHub repo
- Build command: `npm run build`
- Publish directory: `dist`

**Vercel:**
- Import your GitHub repo
- Framework preset: Astro
- Auto-deploys on push

## Development

```bash
# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Type check
npm run astro check
```

## Responsive Design

The character sheet automatically adapts to mobile devices:
- **Desktop:** 2-column grid layout
- **Mobile:** Single column, stacked sections
- **Tablet:** Responsive grid that adapts to screen size

## Advanced Configuration

### Adding New Sections

1. **Add data file** in `src/data/`
2. **Import it** in `src/pages/index.astro`
3. **Add grid area** in the CSS
4. **Create the section** in the HTML

### Custom Domain

1. Add `CNAME` file to `public/` folder with your domain
2. Update `site` in `astro.config.mjs`
3. Configure DNS to point to GitHub Pages

### Analytics

Add analytics by including the script in `Layout.astro`'s `<head>` section.

## Contributing

Feel free to submit issues and pull requests! Areas for improvement:
- Additional themes
- More layout options
- Enhanced mobile experience
- Additional content types

## License

MIT License - feel free to use this template for your own portfolio!

---

**Built with [Astro](https://astro.build/) • Designed for developers, by developers**
