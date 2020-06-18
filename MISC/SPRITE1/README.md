## Sprite Demo  

This is a demonstration on how to create and use a sprite that is loaded from a comma separated data file. This isn't the fastest or simplest way to load sprites, but does allow the sprite data files to be plain text data, which is Git friendly.  

The MYPUT subroutine that displays the sprite is based on an example by [Ted Felix](http://tedfelix.com/qbasic/sprites.html).  

When using the MYPUT subroutine an 8x8 sprite moves reasonably smoothly at my standard 5,000 DOSBox cycles. However, jumping up to a 16x16 sprite causes the movement of the sprite to lag behind the input. While this problem can be mitigated by increasing the DOSBox cycles to 10,000, that's more like emulating a 486DX/25 system rather than a 386SX/33. Of course, it runs smoothly on my real Pentium 233MMX computer, because it's total over-kill for QBasic.
  
I think the lesson here is that using PSET to draw the sprite using two nested for loops in BASIC is too inefficient for practical use. The intended benefit of this drawing method was to prevent the sprite from disappearing when it was moved partly off the edge of the screen, which is what happens when using PUT(x,y), MyArray%. The built in PUT function is much faster, because it draws to the screen using a loop written in Assembly language.  
  
Given the slowness of MYPUT, I added a alternate mode to the demo that switches out to using the normal PUT. Press M to toggle the modes. There's not much difference with an 8x8 sprite, but there's a huge difference with the 16x16 sprite - using normal PUT is actually playable!  
  
Another thing to note about this demo is how I went about creating the alternate sprites. I took the 2 dimensional arrays that I read in from the plain text files, printed them onto the hidden active screen, then used GET to capture them into PUT compatible one dimensional arrays.
  
CSV (and DATA) files are human readable and work well with Git, where as files stored in direct memory format using BSAVE/BLOAD do not. However, direct memory format files load faster and are easier to use in QBasic syntax. I have updated the demo to use the direct memory format files for the alt mode sprites (SPR3.BSV, SPR4.BSV). The files were created in the "MakeAltSprites" GOSUB, which I then commented out so that I could use the much simpler "LoadAltSprites" GOSUB. There's a huge difference in efficiency between the two methods!
