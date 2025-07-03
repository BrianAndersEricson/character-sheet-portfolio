---
title: "Testing the post-script"
date: 2025-07-03
excerpt: "No, not postscript... a script... for easily making new posts."
draft: false
---

# Bash script for a dummy

We're basically seeing if this bash script works to make a quick and easy post in less than 5 minutes, and if the github automation works to get it up and live.

Script in the code block below (this gives us a chance to see how the code blocks look and if I need to adjust that... Yes I should have tested that before.)

Note that this script would be a little weirdly recursive, so I had to remove the code block sample from the template in the script... If you use the bash script yourself for some reason feel free to add a code block to it for your sample document.

```bash
#!/bin/bash

# Colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Fancy header
echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║${WHITE}                    ✨ New Blog Post Creator ✨                   ${PURPLE}║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if we're in the right directory
if [ ! -d "src/content/blog" ]; then
    echo -e "${RED}❌ Error: src/content/blog directory not found!${NC}"
    echo -e "${YELLOW}   Make sure you're running this from your project root.${NC}"
    exit 1
fi

# Get post title
echo -e "${CYAN}📝 What's the title of your new post?${NC}"
read -p "   Title: " title

if [ -z "$title" ]; then
    echo -e "${RED}❌ Title cannot be empty!${NC}"
    exit 1
fi

# Get excerpt
echo ""
echo -e "${CYAN}📖 Write a brief excerpt (optional):${NC}"
read -p "   Excerpt: " excerpt

# Ask if it's a draft
echo ""
echo -e "${CYAN}🚀 Is this a draft?${NC}"
echo -e "${WHITE}   [y/N] (default: No)${NC}"
read -p "   Draft: " draft_input

# Process draft input
case "$draft_input" in
    [Yy]* ) draft="true";;
    * ) draft="false";;
esac

# Create filename from title
filename=$(echo "$title" | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/[^a-z0-9]/-/g' | \
    sed 's/--*/-/g' | \
    sed 's/^-\|-$//g')

# Add .md extension
filename="${filename}.md"
filepath="src/content/blog/${filename}"

# Check if file already exists
if [ -f "$filepath" ]; then
    echo -e "${RED}❌ File already exists: ${filepath}${NC}"
    echo -e "${YELLOW}   Please choose a different title.${NC}"
    exit 1
fi

# Get current date
current_date=$(date +"%Y-%m-%d")

# Create the blog post template
echo -e "${BLUE}📄 Creating blog post template...${NC}"

cat > "$filepath" << EOF
---
title: "$title"
date: $current_date
EOF

# Add excerpt if provided
if [ ! -z "$excerpt" ]; then
    echo "excerpt: \"$excerpt\"" >> "$filepath"
fi

# Add draft status
echo "draft: $draft" >> "$filepath"

cat >> "$filepath" << 'EOF'
---

# Your Content Here

Write your amazing blog post content here! You can use:

## Markdown Features

- **Bold text**
- *Italic text*
- [Links](https://example.com)
- `Inline code`


> Blockquotes for important notes

## Getting Started

Just start writing below this line and delete this template content when you're ready.

---

Happy writing! 🚀
EOF

echo -e "${GREEN}✅ Created: ${filepath}${NC}"
echo ""

# Show file info
echo -e "${PURPLE}📊 Post Details:${NC}"
echo -e "${WHITE}   Title:    ${title}${NC}"
echo -e "${WHITE}   File:     ${filename}${NC}"
echo -e "${WHITE}   Date:     ${current_date}${NC}"
echo -e "${WHITE}   Draft:    ${draft}${NC}"
if [ ! -z "$excerpt" ]; then
    echo -e "${WHITE}   Excerpt:  ${excerpt}${NC}"
fi
echo ""

# Open in nvim
echo -e "${BLUE}🚀 Opening in nvim...${NC}"
echo -e "${YELLOW}   Save and exit when you're done writing!${NC}"
echo ""

# Open nvim and wait for it to close
nvim "$filepath"

# Check if user actually saved (file has more content than template)
if [ ! -f "$filepath" ]; then
    echo -e "${RED}❌ File was deleted. Aborting.${NC}"
    exit 1
fi

# Ask if user wants to commit and push
echo ""
echo -e "${CYAN}🔄 Finished editing! What would you like to do?${NC}"
echo -e "${WHITE}   [1] Git add, commit, and push${NC}"
echo -e "${WHITE}   [2] Just git add and commit (no push)${NC}"
echo -e "${WHITE}   [3] Do nothing (manual git later)${NC}"
read -p "   Choice [1-3]: " git_choice

case "$git_choice" in
    1)
        echo -e "${BLUE}📤 Adding, committing, and pushing...${NC}"
        
        # Add the file
        git add "$filepath"
        
        # Create commit message
        commit_msg="Add new blog post: $title"
        
        # Commit
        git commit -m "$commit_msg"
        
        # Push
        git push origin main
        
        echo -e "${GREEN}✅ Successfully pushed to main branch!${NC}"
        echo -e "${CYAN}🌐 Your post will be live soon at bericson.com${NC}"
        ;;
    2)
        echo -e "${BLUE}💾 Adding and committing...${NC}"
        
        # Add the file
        git add "$filepath"
        
        # Create commit message
        commit_msg="Add new blog post: $title"
        
        # Commit
        git commit -m "$commit_msg"
        
        echo -e "${GREEN}✅ Committed! Push when ready with: git push origin main${NC}"
        ;;
    3)
        echo -e "${YELLOW}⏸️  No git actions taken. File saved at: ${filepath}${NC}"
        ;;
    *)
        echo -e "${YELLOW}⏸️  Invalid choice. No git actions taken.${NC}"
        ;;
esac

echo ""
echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║${GREEN}                     🎉 All done! Happy blogging! 🎉                  ${PURPLE}║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Show next steps if it's a draft
if [ "$draft" = "true" ]; then
    echo -e "${YELLOW}💡 Tip: This post is marked as a draft and won't appear on your site.${NC}"
    echo -e "${YELLOW}   Set 'draft: false' in the frontmatter when ready to publish!${NC}"
    echo ""
fi
```
# - Brian









