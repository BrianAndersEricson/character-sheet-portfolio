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
echo -e "${PURPLE}║${WHITE}                   ✨ New Blog Post Creator ✨                ${PURPLE}║${NC}"
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

# Add excerpt to frontmatter if provided
if [ ! -z "$excerpt" ]; then
    echo "excerpt: \"$excerpt\"" >> "$filepath"
fi

# Add draft status
echo "draft: $draft" >> "$filepath"

# Begin content
echo "---" >> "$filepath"
echo "" >> "$filepath"

if [ ! -z "$excerpt" ]; then
    echo "$excerpt" >> "$filepath"
    echo "" >> "$filepath"
fi

echo "<!-- Start your post content below -->" >> "$filepath"
echo "" >> "$filepath"

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

nvim "$filepath"

# Check if user actually saved (file still exists)
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
        git add "$filepath"
        commit_msg="Add new blog post: $title"
        git commit -m "$commit_msg"
        git push origin main
        echo -e "${GREEN}✅ Successfully pushed to main branch!${NC}"
        echo -e "${CYAN}🌐 Your post will be live soon at bericson.com${NC}"
        ;;
    2)
        echo -e "${BLUE}💾 Adding and committing...${NC}"
        git add "$filepath"
        commit_msg="Add new blog post: $title"
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
echo -e "${PURPLE}║${GREEN}                     🎉 All done! Happy blogging! 🎉               ${PURPLE}║${NC}"
echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Show next steps if it's a draft
if [ "$draft" = "true" ]; then
    echo -e "${YELLOW}💡 Tip: This post is marked as a draft and won't appear on your site.${NC}"
    echo -e "${YELLOW}   Set 'draft: false' in the frontmatter when ready to publish!${NC}"
    echo ""
fi

