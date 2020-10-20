## Com80x43 Directory

I was thinking that it would be neat to make an ASCII art game that works on a similar principle to the frigate mission system in No Man's Sky. Basically, in that game you have a bunch of real 3D ships that you send on imaginary missions and wait for them to return. Given that all of the (important) game play is just number crunching, it would work well as ASCII art game. I could have used Screen Mode 7 or 13, but I though that Screen 0 has some huge benefits for this type of game:  

- A large 80x43 text window. 
- Square shaped characters that line up well.
- Blinking colors work for easily highlighting things.  

So, I will be filling this directory up with all the parts I need to make that game.

**COMMON.BAS**  
This is the main file. It's setup as a tech demo. When I am ready to use it in a game, I'll copy the file and modify it to be the new game. I would say that the most important aspect of the program is how I worked out a way to (relatively) quickly draw the whole 80x43 screen, as QBasic strangely splits this over two screen pages (3440 total charcters split at 2048 + 1392). See the PrintScreen subroutine for more details. Note that this screen drawing setup only appears to work when running the game inside QBasic 1.1 IDE.  

**IMGMAKER.BAS**  
A simple ASCII art creation program that I made by converting my sprite editor to use my ASCII image file format.  

**SP1.IMG**  
Data for an ASCII image used for testing.
