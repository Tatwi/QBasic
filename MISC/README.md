## Misc Directory  
Various things I puttered with. Here is a description by file name.  

### Directories  

**/ARCHIVE**  
A collection of the assignments and other programs I created in high school between 1992 and 1997. They're here because, amazingly, I still had them on disk! It's kind of neat to see what we were doing back then. This was grade 10 and 11. I didn't take the grade 12 and 13 classes, where they worked with Pascal, because I was interested in other things at the time. Funny enough, I took grade 13 chemistry two semesters in a row, because I enjoyed it so much the first time. And wouldn't you know it, that left me one English credit short of graduating, so I had to take grade 13 English in summer school! Whoops! Man, that teacher sure hated the assignments I handed in typed on my Underwood manual typewriter (on green paper with white "White-Out" corrections lol...). She wouldn't accept hand written essays, but we didn't have a computer at home and we weren't able to use the computers at the school in the summer, so that was the best I could do at the time. Ah my life, so full of *weird* was it...  

**/COMMON**  
The Screen Mode 7 framework I am creating as the basis for my text mode games. It's designed to enhance the chunky 40x25 ASCII characters using 16 color sprites that are loaded from pain text CSV files.

**/RUNMAN**  
Testing sprite animation using a 4 frame 8x8 running man. 

**/SPRITE1**
A demonstration on how to create and use a sprite that is loaded from a comma separated data file.

### Files  

**ASCCOLR.BAS**  
Working with character mode only in Screen 0, I wanted to combine the integer values for ASCII characters with the desired colour values into a single variable (for use in arrays and CSV files for ASCII art images). This is a quick test of the thought process.

**BNCYCRC.BAS**  
A bouncing circle, animated by drawing red circles from left to right and drawing over them with black circles (very inefficient). Nothing serious, just playing with the draw functions.

**BNCYCRC2.BAS**  
A bouncy circle that makes use of screen memory page flipping to smooth out the animation.

**CLRS.BAS**  
Dsiplays the 16 colours used by QBasic in screen modes 0 and 7.

**MOVE#.BAS**  
Playing with the movement of an object and redrawing the screen.

**THEBEST.BAS**  
Flickering "stars" I made to test the speed of QBasic on my Compaq Deskpro 4000 running DOS 7 (Windows 98SE) on a Pentium 233MMX. This program runs so fast on the real Pentium CPU that I can't quite match it using DOSBox using the 2GHz Intel Celeron 3450 in my laptop, even with it set to 200,000 cycles per second. Normally I run DOSBox at 5,000 cycles, so that's quite the difference speed and it still comes up short.

**WRPARRY.BAS**  
I was having a hard time printing out the values of an array starting at an arbitrary point, where I printed X before and X after the starting point. So I made this program to break the problem down to its essence. QBasic's array indexes starting at 1 rather 0 makes this a little harder than in other languages. But I'm no math genius, so perhaps a PEBKAC. :)  