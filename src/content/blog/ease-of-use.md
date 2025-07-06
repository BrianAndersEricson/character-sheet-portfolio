---
title: "Ease of use"
date: 2025-07-03
excerpt: "The path of least resistance is a heck of a thing... Sometimes you have to carve that path."
draft: false
---

The path of least resistance is a heck of a thing... Sometimes you have to carve that path.
I know the premise sounds ridiculous. If you're going down the path of least resistance, there should be... no resistance. But bear with me for a moment.

I'm observing the way that the world is changing with the introduction of AI, and it's causing me to reflect a lot on the process by which I learned to use computers in the first place. When I was about 9 years old, my dad decided to purchase myself and my sisters each our own computer. This would have been sometime around 2001.

This was a big decision on his part, it was a huge commitment. He went to a local PC shop, run by a small family, and they built us these very standard beige box PCs. My oldest sister's had a disk drive. I still remember us setting it up, hooking up the speakers the first night and listening to [Like Humans Do](https://www.youtube.com/watch?v=xMeivIkwf_I) which was included with Windows XP at the time.

My dad giving me the autonomy to have a desktop computer connected to the internet at 9 years old, not long after Windwos XP had come out was... Well, maybe not the best idea but I think I was too excited to play games to get into too much trouble on the internet. Eventually... Maybe 2003? He brought home a copy of Everquest and I had to learn about the premise of moderation. I have always struggled with the premise of moderation, especially in regards to hobbies.

Everquest was a rough one for me to play, because there was this functionally infinite timesuck of game to play, and my parents soon decided maybe I was not mature enough to play online games. But, it greatly accelerated my ability to read, and type. I believe that was around the same year that the Lord of Rings: Fellowship of the Ring movie came out which in a roundabout way introduced me to The Wheel of Time series (more on this in another post later, as I'm re-reading that series now.)
Either way, the following years were filled with sleepless nights of playing Everquest until my parents told me I would be in **Trouble** if I didn't shut down the computer, at which point I would stay huddled under my desk with a flashlight reading the Wheel of Time until the birds started chirping and then I'd quickly go to sleep only to wake up for school a few hours later.

What does this have to do with learning about computers, the path of least resistance, any of it? Well, around 2007, right around my birthday, [The Elder Scrolls IV: Oblivion](https://en.wikipedia.org/wiki/The_Elder_Scrolls_IV:_Oblivion) came out and I was deeply obsessed with wanting to play it, but my 6 year old PC did not have adequate graphics capabilities. A close friend of mine from school who was advanced well beyond his years in the ways of computing pointed out that the PC had a PCIe slot... I could just upgrade the system with a new GPU. My uncle, for my birthday, drove down and took my dad and I to a Circuit City in the area, where they bought me a new mouse... a Logitech MX518.

It's hard to communicate how transformative these life events were, introducing me to fantasy, getting me interested in tinkering with and fixing my own computer. My introduction to Everquest later lead to my current job, as the Director who hired me was a big fan of Everquest and had played a lot in college. My love of Fantasy carried into playing Magic: the Gathering and Dungeons and Dragons, and later Pathfinder, and then breaking into the indie RPG scene starting with Fate, eventually writing my own...

I've traveled pretty far from my initial point. Which is, at least for me, that the path of least resistance is the one that holds the most points of interest for me. It's those little decisions to tie things to fantasy, to find passion in a project, to take the time to write a bash script to automate the process of triggering a new blog post and upload it to my Github repository for this website, etc... These things that are seemingly far more work, the idea of spending hours engineering a solution to save minutes. Those moments in my life turned out to be the most pivotal and it worries me that AI will rob people of those moments, to be able to just plug in "Hey write me a script for such and such" and to not be able to even *read* the script, to understand what it's doing or why it's doing it, to not have the curiosity to do so... I think for me, the best way to use AI, has been to cause myself more of a headache by asking it to do things far outside the scope of what it was designed to do and then deciding "is this project really important to me? If it is I need to understand it completely" and poring over it and writing my own bash scripts and figuring it out until I can do it myself.

Anyway, this post comes with a small bash script that I threw together to update the progress blocks on the main profile of the site, it just looks for the json files in the src/data directory, lets you open one in nvim (my editor of choice), and once you write changes to the file prompts you to add and commit (and push if you so choose) those changes to the Github directory, this added work of writing this script has made it so that I'm far more likely to update my actual portfolio page, which will encourage me to write more blog posts as I finish projects, add them to the portfolio, and eventually remove them from the portfolio to archive them as blog posts. At least that's the workflow I'm considering right now, we'll see how it pans out.

```bash
#!/bin/bash

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
```

Thanks for taking the time to read my ramblings, be well.
# - Brian
