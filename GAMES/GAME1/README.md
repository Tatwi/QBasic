# GAME1

Simple character graphics based game where the player must collect all the hearts before the play area fills in with obstructions. 40x25 resolution, because the characters are more square than in 80x25 mode, making it easier to tell where the player is in relation to the obstacles. 

### Status
- Playable, but I'm still working on additional functionality and polish.

### How to Play
- Choose a character colour (that works for your eyes).
- Choose the difficulty level.
- Move around the level to collect all the hearts.
- W A S D: Move the character.
- Arrow Keys: Drop a bomb to blow up an adjacent wall.
- ESC Key: Quit the level or game.

### About
I started working on this in spring 2020. It had been a long time since I had used QBasic and I was never very advanced with it. Having since created games like RocketTux using Javascript frameworks, Loop Dipole in Blender Game Engine (Python), and game mods such as Legend of Hondo in Lua and C++, it was interesting to make a game within the limitations of QBasic and DOSBox. In fact, I have yet to finish or have given up on those other projects, because the amount of work involved in them is so great that I often find it more stressful than fun work on them (which is not so great *for a hobby*). QBasic and character graphics are a lot less demanding on one's times. Sure, I would love to have a real Commodore PET 4032 with a green CRT and BASIC 4 for the full and stylish retro effect, but honestly QBasic resonates more with me personally. Yes, the first computer I learned to program was a Commodore 64C in the late 1980s, but DOS and QBasic on a old machine running Windows 98 SE really *hits me in the feels*, because it takes me back to a time where I was young and the world was still full of wonder.

I've used Git to track the four versions of the program made before I created this Git repository. If you check the history of GAME.BAS, you will see that I was refreshing the whole screen each time the character moved, because that's how things are done in modern systems. Doing this in QBasic though was woefully slow and it forced me to answer the question, "If refreshing the whole screen is slow, how do I make a game without refreshing the screen?". The answer was simple enough: Don't redraw the whole damned screen, just the characters that actually need to be updated!

Another thing I did which was not necessary in this use case was I based the level on a tilemap design, where I tracked the contents of each screen character using an array. This is a waste of memory, because the screen memory already *is* this array and there are built in functions to manipulate it. I didn't think of this at the time I created the game. That said, the design I have created would is useful in cases where one would want to clear the screen during the paused (or some other) state and then redraw it, as the character values from the screen memory would need to be stored in an array so they can be redrawn later. I suppose it all fits into RAM and has a purpose, so it's not truly a waste, just perhaps not the best way to do it.
