## Common Directory

This is the Screen Mode 7 framework I am creating as the basis for my text mode games. It's designed to enhance the chunky 40x25 ASCII characters using 16 color sprites that are loaded from pain text CSV files. It's essentially a collection of subroutines and demonstrations of how they are used.


**COMMON.BAS**  
This is the main file.   When I am ready to use it in a game, I'll copy the file and modify it to be the new game.

**CSVMAKER.BAS**  
A text mode tool for creating, loading, saving, image data in CSV format. The data can be used to make sprites or to color character graphics. I made this tool so I can easily create small sprites for use in Screen Mode 7 programs - anything bigger than 16x16 is a little tedious, but it still works fine.

- Max size 64x32. 
- Arrow keys to move the cursor. Spacebar to paint a "pixel".
- 16 foreground colors plus their blinking versions.
- Blinking color values (16-31) only work when the image data is used to color character graphics. When loaded into sprites, Screen 7 treats color values higher than 15 as white.

**NAME.CSV Files**  
These are color images saved in comma separated value format.   
