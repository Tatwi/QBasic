# My QBasic Adventures

I enjoy simplicity. Of all the ways I have programmed since the late 1980s, Microsoft QBasic 1.1 is my favourite. I enjoy the inherent limitations and delightful end user experience of the IDE. Truly, it's a system that achieves its goals in a comprehensive, compact, and efficient manner.  

As far as hobbies go, programming is inexpensive and accessible, but it isn't always fun to wade through the complexities of modern systems. Sometimes it's nice to just hop on the computer and complete something functional in a sitting, where the beauty is in the process rather than the graphical fidelity. So that's where my QBasic endeavours land, somewhere between puzzling through a game of Sudoku and aping a Bob Ross painting on a lazy Sunday afternoon....  


## Project Overview

- Intentionally only using the Micosoft QBasic 1.1 IDE, because this is a nostalgia driven retro computing project!
- Primarily making ASCII character and simple graphical games.
- May do some green-only Commodore PET style games.
- Screen 0, 80x25 / 40x25 text only with page flipping.
- Screen 7, 320x200px / 40x25 with page flipping.
- Designed to run well in DOSBox that has been tuned to perform about the same as the Intel 386SX 33HMz based systems we had in school.


## Project Files

Each sub directory has it own README file that describes the files within in greater detail. I figured that was handy way to organize things... :)

**/GAMES**  
- **GAME1:** Collect all the hearts and escape the caves before the tunnels collapse and you run out of bombs. This game is effectively my own general purpose character graphics "game engine", a foundation I can build upon in future projects.

**/BENCHES**  
- My attempt to help people run QBasic 1.1 at the same speed on different hardware, real and emulated.

**/MISC**  
- Various BASIC programs that I created for testing/learning/fun.
- Includes an archive of some of the stuff I did in school in the early 1990s.

**/NOTES**
- Information and observations related to my modern use of QBasic.


## Disclaimer

The only real "retro PC" I have to test these programs with is my Pentium 233MMX based Compaq Deskpro 4000, which is actually *too fast* for QBasic. Consequently, I am uncertain how well these programs will run using real 386 and 486 computers. That said, I have done a considerable amount of testing using PCem and I am confident my QBasic software will perform acceptably on 386 and slower 486 compatible PCs.

If you have some old machines and you feel like testing some things for me, please see the [BENCHES](/BENCHES) directory. Your contributions, both documentation and benchmark programs, are welcome!


## My System Setup

While I do have a way more powerful desktop computer, I prefer using my low power laptop for pretty much everything that isn't playing 3D games. Hence the modest specs you will see below. The laptop is fast enough to emulate an Intel 486DX/66 system, but doing so causes high CPU usage even in a minimal Linux environment. However, emulating an Intel 386SX/33 system keeps the CPU usage between 20-35% on a single core and 8-15% on the remaining 3 cores. With this in mind, the min specs to run QBasic as 386SX/33 in DOSBox probably fall in the range of a Raspberry Pi 3B or a PC using a dual core AMD Athlon 64 CPU or better.  

- Lenovo Ideapad 100e 81CY
- Celeron N3450 1.1-2.1GHz Quad Core CPU, 4GB LPDD4 2133MHz RAM
- DOSBox 0.74-2 in Devuan 3 64 Bit

**DOSBox Config:**  
- Need to use OpenGL in Linux to maintain the original aspect ratio and zoom in full screen.
- Only my changes to the default config file are listed below.  

[sdl]<br>
fullresolution=desktop<br>
windowresolution=original<br>
output=opengl<br>

[cpu]<br>
core=normal<br>
cputype=386<br>
cycles=5000<br>

[autoexec]<br>
mount C /PATH/TO/MY/DOS/STUFF/<br>
SET PATH=Z:\;C:\EXE;<br>
C:<br>

## Copyright

Creative Commons CC0 1.0 Universal. See the LICENSE file for more details.