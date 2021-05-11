## Com80x43 Directory

I was thinking that it would be neat to make an ASCII art game that works on a similar principle to the frigate mission system in No Man's Sky. Basically, in that game you have a bunch of real 3D ships that you send on imaginary missions and wait for them to return. Given that all of the (important) game play is just number crunching, it would work well as ASCII art game. I could have used Screen Mode 7 or 13, but I though that Screen 0 has some huge benefits for this type of game:  

- A large 80x43 text window. 
- Square shaped characters that line up well.
- Blinking colors work for easily highlighting things.  

So, I will be filling this directory up with all the parts I need to make that game.

**80X43.BAS**  
This is a tech demo that appears to only work in the QBasic 1.1 IDE when running in DOSBox. I worked out a novel way to a back buffer to (relatively) quickly draw the whole 80x43 screen, using only BASIC command. QBasic strangely splits the output over two screen pages (3440 total characters split at 2048 + 1392). See the PrintScreen subroutine for more details.  

**IMAGEMAKER.BAS**  
I moved this ASCII art image creation tool to an easier to find location in this repository, /TOOLS/IMAGEMAKER.  

**ASCII.CSV**  
Data file for the scrolling characters in the IMGMAKER.BAS program. I organized the ASCII characters a little better for drawing and removed the invalid characters.  

**ASCITEST.BAS**  
This is a test program where I worked out the logic for the scrolling toolbar. I often break out parts of programs in to separate files in the TMP directory so I can focus on just that one problem. I thought maybe it would be helpful to put this one here for reference.  

**SP1.IMG**  
Data for an ASCII image used for testing.
