# Why Benchmark QBasic 1.1?

Let's be real here, the world doesn't need more computer games and I am certainly not going to be making any ground breaking or amazing programs, so why would I bother going to the trouble of determining how fast QBasic 1.1 runs?  

_Consistency_  

The reality is that programs written in QBasic have wildly different performance characteristics depending on the hardware they are running on and the manner in which they are run. For instance, the massive performance improvement granted by running a program in QuickBasic 4.5 rather than in QBasic 1.1 can outright break the intended functionality of a program that was designed for QBasic 1.1. Similarly, running a program that was designed for a 16MHz 386 CPU on a 66MHz 486 CPU can make the program too fast to use. Consequently, it's important for both programmer and the end user to know how the program is _supposed_ to perform.  

With this in mind, I have attempted to determine the appropriate settings for DOSBox, by using benchmarks to see how fast did QBasic 1.1 really ran on the computers similar to those we used in school between 1991 and 1993.  


# Target System Specs

**386DX 33MHz to 486SX 25MHz**  

I didn't have my own computer until I started college in 1998. Well, I was given an obsolete Commodore 64 in 1996, which was a very nice gesture that I sincerely appreciated, but it proved to be completely useless to me; without a printer nor the money to buy one, I typed my assignments at school or on our Underwood manual typewriter at home.

I first learned to program BASIC in seventh grade (1990-1991) on the Commodore 64 that we had in the class room. The school upgraded to PCs running MS-DOS the next year and that's when I was introduced to QBasic (and when I _learned_ WordPerfect 5.1!). We continued to use QBasic when I moved on to high school for grade 9.

While I enjoyed programming in the way one might enjoy doing crossword puzzles, I wasn't a "computer nerd" nor was I particularly interested in computers at that time. Then, as today, I wouldn't want to program my occupation. Anyway, the only thing I know about the PCs we used back then is that they were PCs! However, I think it's fair to assume the computers I used for QBasic were most likely 25-40MHz 386 based machines.  

Also to be considered is that unlike the full QuickBasic suite, QBasic 1.1 is unable to make use of a Math Co-Processor (floating point unit / FPU). Additionally, it is limited to 160KB of RAM.  

Are there times it would be useful to have a faster CPU for one's program? Sure, I suppose. But really, my use case is about doing what produces an authentic feeling of nostalgia rather than trying to hack the Gibson at 88 MPH, ya know?


# Test Systems

I initially started this testing about a year ago, in the spring of 2020. Since then I have noticed some inconsistencies and discovered some important information. I'll lay this out in point form in no particular order,  

- Even when not compiled, programs run much faster in QuickBasic 4.5 than they do in QBasic.  
- A Pentium 233MMX CPU is way too fast for old style QBasic programs, without intentionally slowing down the program.  
- DOSBox and PCem appear to execute the same portions of QBasic code with different results.
- Different version of PCem (15, 16, 17) give different results when running programs on the same emulated hardware configuration.  
- An emulated Pentium 233MMX is 30% faster in QBasic than my real Pentium 233MMX based Compaq Deskpro 4000 system.  

Those last two points are what bothers me, as the oldest PC I have to test with is the Deskpro 4000. This leaves me to rely on questionably accurate PC emulation and wildly out of spec hardware for my benchmark results. Ideally, I would just fire up a real 386DX33 and do some testing, but I have to work with the hardware I have available.  

**Compaq Deskpro**
- Intel Pentium 233MMX CPU @ 233MHz
- 32MB SDRAM
- 2MB S3 Virge/GX SVGA graphic card
- MS-DOS 7.1 (Windows 98 SE in DOS Mode)

**Desktop PC**
- AMD FX-8320 CPU @ 4GHz
- 24GB DDR3 1600MHz RAM
- 6GB Nvidia GTX1660 video card
- Devuan 3 Linux (Kernel 4.19, MATE desktop, Nvidia proprietary driver)
- DOSBox 0.74-2 (Debian repository)
- PCEm 17 (compiled)


# DOSBox Configuration

- CPU Core: Normal
- CPU Type: 386
- CPU Cycles: 5000
- Video Card: svga_s3


# PCem Configurations

All configurations used MS-DOS 6.22 with 2MB RAM. No additional FPU was used (as QBasic 1.1 doesn't make use of it - I tested to confirm).  

**386SX**  
- Intel 386SX 16MHz 
- Intel 386SX 33MHz
- Motherboard: AMA-932J
- Video: Built-in

**386DX**  
- Intel 386DX 33MHz
- AMD Am386DX 40MHz
- Motherboard: ECS 386/32
- Video: Cirrus Logic CL-GD5428

**486**  
- Intel 486SX 25MHz
- Intel 486DX 66MHz
- Motherboard: Award SiS 496/497
- Video: Cirrus Logic CL-GD5428

**Pentium**
- Intel Pentium 75MHz
- Intel Pentium MMX 233MHz
- Motherboard: Shuttle HOT-557
- Video: Cirrus Logic CL-GD5428


# The Tests

I created a benchmark program, BENCHES.BAS, that tests various aspects of using QBasic, because I felt it was a good way to see where performance differs between DOSBox and various PCem configurations. Initially I had only looked at results from my SPEED.BAS program, but its limited tasks hide the performance differences that are found when using other routines.  

BENCHES.BAS has twelve tests. Each test repeats a specific task a number of times. The TIMER function is used to determine how many seconds were required to complete a test.

I tuned the program using my real Pentium 233MHz system to provide a baseline for real world performance. Unfortunately, the incredible speed of this CPU forced me to add many more iterations of each test than what would be required on even a 486DX2 66MHz system. I had to ensure that QBasic was able to accurately measure the elapsed time, as the TIMER function only has a resolution of approx 0.005 seconds.  

The total time to complete all tasks (calculated by adding the individual results together) is used to compare the test subject's performance to that of the real Pentium 233MHz CPU.  

**Tests:**  
- Floating Point Math
- Integer Math
- Math IF/ELSE Logic
- String IF/ELSE Logic
- String Select Case Logic
- Integer Array Sort
- Sequential Character Print Rate
- Sequential Character Fill Rate (LOCATE)
- Random Character Fill Rate (LOCATE)
- Random Character FR, Random Color
- Sequential Pixel Fill Rate
- Sequential Pixel Fill Rate, Random Color


# Test Results

See the benches_results.ods spreadsheet.


# Results Summary

Based on the results from PCem, DOSBox at 5000 cycles is roughly equivalent to an AMD 386DX running at 40MHz. That's about half as fast as 486SX 25MHz and about 15% faster than a 386DX 33MHz.  

The PCem version 17 emulated Pentium 233MMX CPU is 30% _faster_ than my real Pentium 233MMX CPU. That's a substantial margin of error, but the emulated CPU being faster than the real one is consistent with my findings using PCem versions 15, 16, and 17. As such, in the absence of a real 386 or 486 machine, I think the tuning of DOSBox to 5000 cycles is accurate enough.  

That said, looking at the the results of DOSBox and its closest performing PCem emulated CPU, while also considering the results of upgrading a PCem 386 from 33MHz to 40MHz, it's clear that DOSBox does not accurately emulate all aspects of a 386 CPU. See following points,  

**Upgrading the 386 CPU:**  
- 33MHz to 40MHz is a 17.5% increase in clock speed.
- Provided an 11-13% improvement in all test, except the Sequential Character Print Rate test which only improved by 7.5%.

**40MHz 386 Vs. DOSBox:**  
- Overall, DOSBox was only 5.31% faster.
- The Integer Math test was almost identical.
- **DOSBox was 42% faster at the Sequential Character Print Rate test!**
- DOSBox was 17.86% faster at the Sequential Character Fill Rate test.
- DOSBox was 10% faster at the Sequential Pixel Fill Rate, yet only 3.38 faster at the Sequential Pixel Fill Rate, Random Color test (only difference is the latter includes use of the random number function).
-The other 7 tests show consistent improvements in a small range between 4.54 and 6.19%.

Clearly DOSBox has _significantly unusual performance_ when it comes to drawing to the screen. It is safe to assume that this is caused by intentional optimizations to DOSBox that are geared towards producing the highest frame rates in games, as DOSBox was purposely designed to run _DOS games_ rather than general DOS software. 


# Conclusion

Having played with QBasic over the last year in many configurations, it was obvious to me that something was strange when using DOSBox. However, for both myself and the general public, DOSBox is much easier and more convenient to install, configure, and use than PCem or a real 386 computer. With this in mind, I have decided that all of my programs are designed to be used in DOSBox 0.74 running at 5000 cycles. They will probably run about the same on using a real 40MHz 386 based computer.
