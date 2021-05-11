# Tools

Here are the various BASIC programs that I made to support the creation of other programs.  

## Image Maker
**/IMGMAKER/IMGMAKER.BAS**  
An ASCII art creation program that I made by converting and upgrading my simple sprite editor. It saves its images as plain text in CSV format files. The data format is simple: 731255 = (7) (31) (255) = (BG Color) (FG Color) (ASCII Code). I decided to use plain text files primarily because they work better with Git, but also because disk storage space isn't a problem for files of this size (25KB max) in today's world. Images can be as small as 4x4 characters and as large as 80x40 characters. There are several example images in the the IMGMAKER directory.  

<img src="../IMG/imgmaker.png" width="640" height="400" title="ASCII Image Maker"/>  