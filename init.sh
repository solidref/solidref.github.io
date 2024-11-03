#!/bin/bash

# Check if Hugo is installed
if ! command -v hugo &> /dev/null
then
    echo "Hugo is not installed. Installing Hugo..."
    # Install Hugo (assuming Linux; modify for other OS as needed)
    sudo apt-get update
    sudo apt-get install -y hugo
    echo "Hugo installed."
else
    echo "Hugo is already installed."
fi

# Initialize a new Hugo project
PROJECT_NAME="."
echo "Initializing Hugo project..."
hugo new site $PROJECT_NAME
cd $PROJECT_NAME || exit

# Add hugo-book theme as a Git submodule
echo "Adding hugo-book theme..."
git init
git submodule add https://github.com/alex-shpak/hugo-book themes/hugo-book

# Configure Hugo to use hugo-book theme
echo "Configuring Hugo (config.toml)..."
cat <<EOL > config.toml
baseURL = "http://localhost:1313/"
languageCode = "en-us"
title = "Clean Code & Design Patterns Comparison Site"
theme = "hugo-book"
enableRobotsTXT = true

[params]
    bookToC = true # Enables table of contents
    bookSearch = true # Enables search
    bookCollapseSection = true # Collapses sections by default

[menu]
  [[menu.main]]
    name = "Clean Code"
    url = "/clean-code/"
    weight = 1
  [[menu.main]]
    name = "Coding Principles"
    url = "/coding-principles/"
    weight = 2
  [[menu.main]]
    name = "Design Patterns"
    url = "/design-patterns/"
    weight = 3
EOL

# Create sample content structure with placeholder files
echo "Creating content structure..."

# Clean Code
mkdir -p content/clean-code
echo -e "---\ntitle: 'Clean Code Principles'\ndraft: false\n---\n\n# Clean Code" > content/clean-code/_index.md

# Coding Principles
mkdir -p content/coding-principles
echo -e "---\ntitle: 'Coding Principles'\ndraft: false\n---\n\n# Coding Principles" > content/coding-principles/_index.md

# Design Patterns
mkdir -p content/design-patterns
echo -e "---\ntitle: 'Design Patterns'\ndraft: false\n---\n\n# Design Patterns" > content/design-patterns/_index.md

# Create SOLID principles under Coding Principles
SOLID_DIR="content/coding-principles/solid"
mkdir -p $SOLID_DIR
for principle in single-responsibility open-closed liskov-substitution interface-segregation dependency-inversion
do
    echo -e "---\ntitle: '$(echo $principle | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g') Principle'\ndraft: false\n---" > $SOLID_DIR/$principle.md
done

# Create Design Patterns
DESIGN_PATTERNS_DIR="content/design-patterns"
for pattern in abstract-factory builder factory-method prototype singleton adapter bridge composite decorator facade flyweight proxy chain-of-responsibility command iterator mediator memento observer state strategy template-method visitor
do
    echo -e "---\ntitle: '$(echo $pattern | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g') Pattern'\ndraft: false\n---" > $DESIGN_PATTERNS_DIR/$pattern.md
done

echo "All files and structure created successfully! 🎉"
echo "To start the server, run: 'hugo server -D'"
