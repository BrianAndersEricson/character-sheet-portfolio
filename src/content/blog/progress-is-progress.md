---
title: "Progress is progress"
date: 2025-07-22
excerpt: "Sidequests are kind of how I got here, not what I'd call getting distracted."
draft: false
---

Sidequests are kind of how I got here, not what I'd call getting distracted.

This post will come to you in a few parts, an update on my last post (dotfiles), a bit about a book I just finished (New Spring), a little bit about my homelab (Proxmox, Containers, etc..), and a little bit about what I'm working on now.

## Part 1 - [The Dotfiles.](https://github.com/BrianAndersEricson/dotfiles)
As noted on my previous entry, I've been working on some scripts to handle my dotfiles... I'm... Not happy with how they've turned out, but you can find them in my dotfiles directory on Github.

What I am happy with:
1. My github-setup.sh script has been delightful, it gets me rolling on a new terminal/setup very quickly and easily setting up an SSH key and changing over my dotfiles directory so I can update and keep things synced between my devices with (relative) ease. No complaints there.
2. Oh wow that was a short list huh, OK well... I ended up breaking it into three separate scripts as noted in the previous post, because I just couldn't get a cohesive all-in-one solution to work cleanly, I just didn't understand symlinks well enough and I ended up... Well... I'll leave that for the conclusion.

What I'm less happy with: 
1. The package-installer script, I can't seem to get the logic down to properly have it install the most up to date version of neovim, and being a person who swaps between Ubuntu and Arch based distros semi-regularly, I'd really like the OS detection and package-handling mechanism to work better than it does. I find I'm having to manually install a handful of utilities that could be grabbed by the package manager (Eza, and Zoxide being the big two.) That said, it does a great job on the vast majority of things including starship.
2. The Symlink script... Holy moly. I've tried simplifying it, I've tried complicating it. I think this one is tough because sometimes I'm installing into a headless environment where all I'm using is a terminal... and sometimes I'm absolutely ruining the dotfiles on my laptop and my Hyprland install just implodes because I accidentally forgot to include logic against symlinking out the entire .config folder and just wiping out all my existing configs... I've since incorporated backups into it.

Conclusion:
Well, if you want to check the dotfiles repo on my github they are [here for the viewing](https://github.com/BrianAndersEricson/dotfiles/blob/main/symlink.sh). At the end of the day... They could be WAY worse, and they generally work. I will continue to make updates to them and I'm planning on rebuilding my laptop configuration... Soonish. I've learned a lot and I'd like to document the process better for myself this next time instead of working on it from 23:00 - 02:00 in some sort of sleep deprived fever dream.

## Part 2 - [New Spring](https://www.goodreads.com/book/show/187065.New_Spring)
It is no secret to those in my life that New Spring is one of my favorite Wheel of Time books. This would be my 15th read-through of the book, the start of many lovely full-series reads. Around my... fourth or fifth readthrough of the Wheel of Time series (something I have done a total of 14 times and counting,) I changed the way I read the series. Starting with the prequel, normally intended to be read somewhere between books 7 and 9, instead of book 1 (Eye of the World). I also, controversially, began recommending new readers also start with New Spring.

I will now defend my thesis, that it is better to start with New Spring.

Typically, the reason to start with Eye of the World is, well, that's where the main storyline starts. That said, I personally find that New Spring is far more indicative of the quality of the story you're going to be experiencing. By the time he wrote New Spring, Jordan had a chance to solve the pacing of the story and really solidify the soul of his setting, The Westlands. If you start with Eye of the World, you will be drawn into the minds of our three initial protagonists, part of an ensemble cast, in questioning the motives of everyone around them. The New Spring method changes that, it paints certain characters in a much more sympathetic light. In addition it sets up some foreshadowing for what would otherwise be a surprise twist or mystery... I personally love finding (and experiencing the delivery of) foreshadowing.

That said, every person will have their own experience with reading the Wheel of Time, I know that mine is different every time I do a re-read. There's a reason I've done it 14 times, and am working on my 15th now. It's a world I love to get lost in.

I will leave this section with a line from New Spring, an echo of this title of this post. "The only way was forward, whatever lay at the end."

## Part 3 - The Homelab
I will, at some point, need to do a full post solely dedicated to my homelab. I had let it languish for a while, focusing on sidequests as it were. A programming class in boot.dev, a book club, volunteering, certifications, a website I wanted to launch, rescuing my mother's cookbook collection from fading into obscurity, my second part time job, continuing education for my main job, eating, sleeping, finding out what's wrong with my shoulder... You know, typing all this out... All those side quests seem just as important if not more important than my homelab... Huh, as it turns out, life is a series of sidequests distracting from other sidequests isn't it?

Either way, my homelab wasn't causing me any issues, it was running fine. My media collection had been cleanly ripped and stored onto the HDDs, the HDD health was fine when I was manually checking it, I would catch it if a VM or a container crashed for some reason or another, I was... keeping up with updated for the most part. You know, it was working. But it could be working better.

So, some rapidfire changes I've made over the last month or so:
1. Cleaned up unused Docker containers.
2. Added some new Docker containers.
3. Configured Tailscale with my docker VM to more cleanly utilize aforemention tools when I'm not at home.
4. Removed unnecessary VMs, moved services hosted on additional VMs to dockers or containers on the Proxmox host itself.
5. Built a dashboard with Glance to monitor device status, maintain a quick reference for information I repeatedly check throughout the day, and a quick to-do list that I can refer to easily.
6. Cleaned up my dev environment, separating from an SSH instance hosted on my proxmox server to instead create the "easy rollout" script mentioned above, that is not quite so easy... I actually don't know if this was the right move, I may revisit this if I can find someone to consult with about pros and cons of these methods.
7. Purchased and installed a battery backup unit.
8. Adjusted device load and finished cleaning up VM overhead.
9. Built in redundancy for important services and configured a detection method for power outages to safely power off my host.

Anywho, I reduced the active overhead on the homelab by like, 30%? While rolling out four or five new services and securing and automating a lot of the updates and o ther processes. So now my homelab can break itself instead of me breaking it :^)

## Part 4 - The rest of it.
I don't know, wasnt that stuff that I typed there enough? Whatever, I'm still working on the Fables 3 Playtest writing. I finished up the character origins and consolidating the character fortunes, so the new flow making a character is Determine your lucky token > Roll for your Fortune and record your traits > Roll for your origin and record your skills > Build your abilities > Choose your loadout and describe your character. It gives you a lot more lore about the setting and you'll have a very fleshed out character with a culture and a star sign as well as the numerical bits associated. I'm actually really proud of it and will likely be releasing Playtest 3 online for more wide distribution and testing.

I need to get it all layed out and clean up my draft text of those aforemention Origins and Fortunes.

This weekend I have a Hackathon coming up with the folks at Boot.dev, I have a big project coming up with my part time job this week and weekend as well that is time sensitive and has been in the works for a bit too... Plus a lot more things I want to rebuild the structure of in my homelab AND rebuilding my laptop... and deciding as mentioned above, do I actually want a centralized SSH setup for my development work, or should I focus on an easily rolled out/scripted setup? So much to consider.

## Part 5 - You weren't expecting that were you?
I had to tie it back to the beginning premise. At the end of the day, every thing that I do is impacting what I will continue to do in the future, the people I spend time with, who I talk to, what I talk to them about. All these side quests add up and shape a person. I'm happy with how I'm spending time for the most part, although I have a handful of complaints. I'd like to get to the gym more, I'd like to spend more time talking to and doing things with family, I'd like to give myself more time to rest and relax. But I'm making progress and... You know what, maybe progress is overrated too, maybe we don't need to worry about it so much. The nature of time and reality is that it will inevitably keep ticking past no matter what progress we make. Do the things that make you happy, pursue what makes you feel good and what you think will make you feel good in the long term. You'll figure out the rest on the way.

Best wishes, thanks for reading.
# - Brian
