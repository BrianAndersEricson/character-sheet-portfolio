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
echo -e "${PURPLE}Data File Editor${NC}"
echo -e "${PURPLE}=================${NC}"
echo ""

# Check if we're in the right directory
if [ ! -d "src/data" ]; then
    echo -e "${RED}❌ Error: src/data directory not found!${NC}"
    echo -e "${YELLOW}   Make sure you're running this from your project root.${NC}"
    exit 1
fi

# Get list of data files
data_files=($(find src/data -name "*.json" -type f | sort))

if [ ${#data_files[@]} -eq 0 ]; then
    echo -e "${RED}❌ No JSON files found in src/data directory!${NC}"
    exit 1
fi

echo -e "${CYAN}Available data files:${NC}"
echo ""

# Create array of display names
declare -a display_names
for file in "${data_files[@]}"; do
    basename=$(basename "$file" .json)
    case "$basename" in
        "profile") display_names+=("Profile Information");;
        "projects") display_names+=("Current Projects");;
        "books") display_names+=("Currently Reading");;
        "music") display_names+=("Current Playlist");;
        "learning") display_names+=("What I'm Learning");;
        "links") display_names+=("Social Links");;
        *) display_names+=("$basename");;
    esac
done

# Function to show menu with vim-style navigation
show_menu() {
    local selected=$1
    local total=${#data_files[@]}
    
    # Clear screen and show header
    clear
    echo -e "${PURPLE}Data File Editor${NC}"
    echo -e "${PURPLE}=================${NC}"
    echo ""
    echo -e "${CYAN}Use j/k or ↑/↓ to navigate, Enter to select, q to quit${NC}"
    echo ""
    
    for i in "${!data_files[@]}"; do
        if [ $i -eq $selected ]; then
            echo -e "${WHITE}→ ${display_names[$i]}${NC}"
        else
            echo -e "  ${display_names[$i]}"
        fi
    done
    
    echo ""
    echo -e "${YELLOW}Selected: ${data_files[$selected]##*/}${NC}"
}

# Interactive menu selection
selected=0
total=${#data_files[@]}

while true; do
    show_menu $selected
    
    # Read single character
    read -n 1 -s key
    
    case "$key" in
        # Up arrow, k, or K
        $'\033')
            read -n 2 -s rest
            if [[ "$rest" = "[A" ]]; then
                ((selected--))
                if [ $selected -lt 0 ]; then
                    selected=$((total - 1))
                fi
            elif [[ "$rest" = "[B" ]]; then
                ((selected++))
                if [ $selected -ge $total ]; then
                    selected=0
                fi
            fi
            ;;
        'k'|'K')
            ((selected--))
            if [ $selected -lt 0 ]; then
                selected=$((total - 1))
            fi
            ;;
        'j'|'J')
            ((selected++))
            if [ $selected -ge $total ]; then
                selected=0
            fi
            ;;
        'q'|'Q')
            echo -e "${YELLOW}Goodbye!${NC}"
            exit 0
            ;;
        '')  # Enter key
            break
            ;;
    esac
done

# Get selected file
selected_file="${data_files[$selected]}"
file_basename=$(basename "$selected_file" .json)
display_name="${display_names[$selected]}"

# Clear screen and show selection
clear
echo -e "${PURPLE}Data File Editor${NC}"
echo -e "${PURPLE}=================${NC}"
echo ""

echo -e "${GREEN}Selected: ${display_name}${NC}"
echo -e "${WHITE}   File: ${selected_file}${NC}"
echo ""

# Show file info
echo -e "${PURPLE}File Details:${NC}"
echo -e "${WHITE}   Path:     ${selected_file}${NC}"
echo -e "${WHITE}   Size:     $(du -h "$selected_file" | cut -f1)${NC}"
echo -e "${WHITE}   Modified: $(date -r "$selected_file" '+%Y-%m-%d %H:%M:%S')${NC}"
echo ""

# Create backup before editing
backup_file="${selected_file}.backup.$(date +%s)"
cp "$selected_file" "$backup_file"
echo -e "${BLUE}Created backup: ${backup_file}${NC}"
echo ""

# Open in nvim
echo -e "${BLUE}Opening ${file_basename}.json in nvim...${NC}"
echo -e "${YELLOW}   Save and exit when you're done editing!${NC}"
echo -e "${YELLOW}   Tip: Use :set syntax=json for syntax highlighting${NC}"
echo ""

# Wait a moment then open nvim
sleep 1
nvim "$selected_file"

# Check if file was modified
if [ ! -f "$selected_file" ]; then
    echo -e "${RED}File was deleted! Restoring from backup...${NC}"
    mv "$backup_file" "$selected_file"
    exit 1
fi

# Check if file was actually changed
if cmp -s "$selected_file" "$backup_file"; then
    echo -e "${YELLOW}No changes detected. Cleaning up backup...${NC}"
    rm "$backup_file"
    echo -e "${CYAN}All done!${NC}"
    exit 0
fi

echo ""
echo -e "${GREEN}File edited successfully!${NC}"

# Validate JSON
if ! python3 -m json.tool "$selected_file" > /dev/null 2>&1; then
    echo -e "${RED}Invalid JSON detected! Would you like to fix it?${NC}"
    echo -e "${YELLOW}   [y] Re-open in nvim${NC}"
    echo -e "${YELLOW}   [r] Restore from backup${NC}"
    echo -e "${YELLOW}   [i] Ignore and continue${NC}"
    read -p "   Choice [y/r/i]: " json_choice
    
    case "$json_choice" in
        [Yy]*)
            echo -e "${BLUE}Re-opening for fixes...${NC}"
            nvim "$selected_file"
            ;;
        [Rr]*)
            echo -e "${YELLOW}Restoring from backup...${NC}"
            mv "$backup_file" "$selected_file"
            echo -e "${GREEN}File restored!${NC}"
            exit 0
            ;;
        *)
            echo -e "${YELLOW}Continuing with potentially invalid JSON...${NC}"
            ;;
    esac
fi

# Clean up backup
rm "$backup_file"

# Ask about git actions
echo ""
echo -e "${CYAN}File updated! What would you like to do?${NC}"
echo -e "${WHITE}   [1] Git add, commit, and push${NC}"
echo -e "${WHITE}   [2] Just git add and commit (no push)${NC}"
echo -e "${WHITE}   [3] Do nothing (manual git later)${NC}"
read -p "   Choice [1-3]: " git_choice

# Create appropriate commit message
case "$file_basename" in
    "profile") commit_msg="Update profile information";;
    "projects") commit_msg="Update current projects";;
    "books") commit_msg="Update currently reading list";;
    "music") commit_msg="Update current playlist";;
    "learning") commit_msg="Update learning list";;
    "links") commit_msg="Update social links";;
    *) commit_msg="Update ${file_basename} data";;
esac

case "$git_choice" in
    1)
        echo -e "${BLUE}Adding, committing, and pushing...${NC}"
        
        git add "$selected_file"
        git commit -m "$commit_msg"
        git push origin main
        
        echo -e "${GREEN}Successfully pushed to main branch!${NC}"
        echo -e "${CYAN}Changes will be live soon at bericson.com${NC}"
        ;;
    2)
        echo -e "${BLUE}Adding and committing...${NC}"
        
        git add "$selected_file"
        git commit -m "$commit_msg"
        
        echo -e "${GREEN}Committed! Push when ready with: git push origin main${NC}"
        ;;
    3)
        echo -e "${YELLOW}No git actions taken. File saved at: ${selected_file}${NC}"
        ;;
    *)
        echo -e "${YELLOW}Invalid choice. No git actions taken.${NC}"
        ;;
esac

echo ""
echo -e "${PURPLE}All done! Site updated!${NC}"
echo -e "${PURPLE}========================${NC}"
echo ""

# Show what was changed
echo -e "${CYAN}Summary:${NC}"
echo -e "${WHITE}   Edited: ${display_name}${NC}"
echo -e "${WHITE}   Committed: ${commit_msg}${NC}"
if [ "$git_choice" = "1" ]; then
    echo -e "${WHITE}   Deployed: Changes pushed to live site${NC}"
fi
echo ""
