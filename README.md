# SOLID.ref

This repository contains the source code for a Hugo-generated website dedicated to clean code practices, coding principles, and design patterns across multiple programming languages. The site is structured to allow users to easily compare content across two to four languages and provides a built-in search feature to navigate topics quickly.

## Table of Contents

1. [Project Overview](#project-overview)
2. [File Structure](#file-structure)
3. [Installation & Setup](#installation--setup)
4. [Content Organization](#content-organization)
5. [Comparison Functionality](#comparison-functionality)
6. [Search Engine](#search-engine)
7. [Contributing](#contributing)

---

### Project Overview

This site covers:

- **Clean Code** principles and best practices
- **Coding Principles**, both generic and language-specific
- **Design Patterns**, including language-specific variations

Users can compare these topics across multiple programming languages, providing insights into the similarities and unique aspects of each language’s approach.

### File Structure

```
├── content/                    # Content for the site, organized by topic and language
│   ├── clean-code/             # Clean Code practices by language
│   │   ├── generic.md          # Language-agnostic clean code principles
│   │   └── <language>/         # Language-specific clean code practices (Java, Python, Go, etc.)
│   │       └── clean-code.md
│   ├── coding-principles/      # General and language-specific coding principles
│   │   ├── generic.md
│   │   └── <language>/
│   │       └── principles.md
│   └── design-patterns/        # Design patterns by language
│       ├── generic.md
│       └── <language>/
│           └── patterns.md
├── layouts/                    # Custom Hugo layouts for enhanced comparison and UI
│   └── partials/               # Custom components, e.g., comparison tables
├── assets/                     # Static assets (CSS, JavaScript for search and interactivity)
├── static/                     # Static files served as-is (images, etc.)
├── config.toml                 # Hugo configuration file
└── README.md                   # Project documentation
```

### Installation & Setup

To run the project locally:

1. **Install Hugo**:

   - [Download Hugo](https://gohugo.io/getting-started/installing/) and follow the installation guide.

2. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/clean-code-comparison-site.git
   cd clean-code-comparison-site
   ```

3. **Run the development server**:
   ```bash
   hugo server -D
   ```
   Open `http://localhost:1313` to view the site locally.

### Content Organization

Each topic—**Clean Code**, **Coding Principles**, and **Design Patterns**—is broken down by language for easy access and comparison. Content is organized as follows:

- **Generic Content**: Content common across languages is stored in a top-level markdown file (e.g., `generic.md`) within each topic folder.
- **Language-Specific Content**: Each language (e.g., `Java`, `Python`, `Go`) has its own folder with dedicated markdown files for each topic, enabling detailed language-specific discussions.

### Comparison Functionality

To provide a seamless comparison experience:

- **Dynamic Comparison Tables**: We use Hugo’s layout templates to create custom shortcodes that allow users to view clean code practices, coding principles, or design patterns side-by-side across selected languages.
- **Comparison Page Structure**:
  - Users can choose two to four languages for side-by-side comparisons.
  - A dynamic table displays key aspects across selected languages, facilitating quick comparison.
- **Folder Structure**: The clear folder organization helps automatically populate comparison tables for each topic, drawing language-specific content into these tables.

### Search Engine

To improve navigation, we’ll implement a lightweight search solution. Options include:

- **JavaScript-Based Search** (e.g., Lunr.js or Fuse.js):
  - Add `Fuse.js` to the `assets/` directory and create a search functionality in JavaScript.
  - Generate a JSON index file of site content during the Hugo build process.
  - JavaScript code enables client-side searching, matching terms with content and displaying results in real-time.
- **Integration Steps**:
  1.  **Add a JSON Content Generator**: Configure Hugo to output a JSON file with searchable content, including titles, summaries, and tags.
  2.  **Build Search UI**: In the `layouts/partials/` directory, create a search component with an input field and a display area for results.
  3.  **Connect Search Logic**: Use Fuse.js to match search queries to JSON content and display relevant links and excerpts on the page.

### Contributing

Contributions are welcome! Please fork this repository and submit pull requests to suggest changes or add new content for languages and principles.

**Guidelines**:

1. **Content Standards**: Follow existing formats and structures for consistency.
2. **Code Examples**: Ensure code examples are concise and accurate.
3. **Markdown Formatting**: Use proper markdown formatting and headers to maintain readability.
4. **Testing**: Run `hugo server -D` to preview changes locally.
