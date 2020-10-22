# Benchmarking

I learned how to use QBasic on a 386 of some kind in high school. As such, that's the level of processing power that I wish to use today as well. Unfortunately, I don't own a real 386 computer so I don't have a baseline of performance by which to tune DOSBox. I do have a Pentium 233MMX system, but it's actually faster in QBasic than what I am able emulate on my modern laptop and is thus much faster than a 386 too.  

To determine the appropriate DOSBox speed, I ran the SPEED.BAS program on 18 different configurations of PCem. I also used DOSBox and DOSBox-X. All testing was completed using an Intel Celeron N3450 CPU. I also added my real Pentium 233MMX system for comparison. The program fills the screen with randomly coloured pixels. My testing method isn't super accurate or scientific, but it is consistent within +/- 0.5 seconds.

### My Conclusion

It makes the most sense to run QBasic 1.1 in plain old DOSBox, because it runs well and the "DOS files" are in reality just files within the normal host system. Consequently, it's trivial to use modern tools, such as Git, along side the QBasic IDE. The only issue with DOSBox that I have read about is that it can mess up floating point math in some circumstances. If you encounter this problem, use DOSBox-X instead - there's nothing wrong with DOSBox-X, it's just more complex than what's required for emulating a 386 for use with QBasic, especially when considering that it performs identically to DOSBox.

PCem is really cool, but file management between the host and guest is such a pain that it's not worth using in this case. Also, it really needs a more powerful CPU than the low-power / low-watt mobile Intel CPU I am using in my laptop. I imagine any 2 Core / 4 thread Intel i3 desktop CPU will be sufficient to emulate an AMD K6-2/500 or lower CPU, which would be crazy fast for QBasic (and even faster when compiling one's programs with QuickBasic 4.5).  

 I suppose it all depends on what's important to you personally. For me I value the portability, battery back up, and overall convenience offered by my laptop more than the raw processing power offered by my desktop computer. Really, if I were to use a fast desktop for QBasic, I'd just use my Compaq Deskpro 4000, because it has half the power consumption of my modern desktop while being just as fast.


### Procedure

1. Load SPEED.BAS into QBasic 1.1.
2. Open the stop watch program on a smartphone.
3. Press F5 on the computer and Start on the stop watch simultaneously.
4. Press stop on the stop watch the instant the computer screen says "Press any key...".
5. Record the time in seconds, rounding down to the nearest second to compensate for human reaction time.


### Results

I did this testing using my Intel Celeron N3450 based laptop, but due to its low power design the CPU was maxed out in single core performance when testing the faster CPUs with PCem. The host system CPU bottleneck didn't appear to effect the testing results, but it sure did make the guest OS terrible to use in most cases, due to typing input lag. The guest OS for PCem was a DOS 6.22 boot disk image. Interestingly, in PCem the Cyrix MII-333 and the Intel Pentium 233MMX were able to produce the fastest emulated results, yet neither systems displayed any input lag nor they max out the host CPU's single core performance.

See the table below or the speed_results.ods file.

**CPU Type**|**Seconds**|**System**
:-----:|:-----:|:-----:
Intel Pentium 233MMX|10|Real Hardware
486 Normal @ 4866 Cycles|84|DOSBox Windows
386 Normal @ 5000 Cycles|81|DOSBox Linux
386 Normal @ 5000 Cycles|81|DOSBox-X Linux
486 Normal @ 18,000 Cycles|23|DOSBox-X Linux
Intel 386DX/33|72|PCem Windows
Intel 386SX/33|92|PCem Windows
Intel 486DX/33|39|PCem Windows
Intel 486SX/25|52|PCem Windows
Intel 486SX/33|39|PCem Windows
Intel Pentium OverDrive/83|10|PCem Windows
Cyrix 5x86/133|11|PCem Windows
AMD 486SX/40|32|PCem Windows
Cyrix 486DX2/50|26|PCem Windows
Intel Pentium 75|11|PCem Windows
Intel Pentium 233MMX|10|PCem Windows
Cyrix MII-333|11|PCem Windows
AMD K6-2/500|11|PCem Windows
Cyrix 486DRx2/66|30|PCem Windows
Intel 486DX4/100|23|PCem Windows 


### Additional Results

I have been playing with character graphics in screen mode 0 for a while, because I really like the whole early era of computing, with BASIC and character graphics. And this lead me to wonder what effect processor speed would have on the fill rate of characters using just BASIC commands.  

**8050FILL.BAS**  
I added the results for this testing as comments in the benchmark program itself. However, in summary I would say:  

- PCem emulation of the Pentium CPU is way faster than the real hardware. The emulated P233MMX was almost twice as fast as my real one. Even the emulated P166 was faster than my real P233MMX. There's obviously some issue with the emulation.  

- The PCem 386DX 33MHz and DOSBox at 5000 cycles with the 386 core are very close to each other, so I think that's probably pretty close to how a real 386DX 33MHz would preform.

- For the purpose of emulating the feel of using a period correct PC for QBasic, which for me would have been a 386 at high school, DOSBox on my laptop is the best use my electricity and DOSBox in general is *good enough* for me. As I mentioned above, it's immensely helpful to be able to use the native file system of the computer rather than juggling disk images just to use QBasic and Git/GitHub.  


### System Configuration

**Hardware**  
- Lenovo Ideapad 100e 81CY laptop
- CPU: Intel Celeron N3450 (Quad Core 1.1-2.1GHz)
- 4GB LPDDR4 2133MHz RAM
- 128GB EMMC storage

**DOSBox**  
- Windows 10 Pro / DOSBox 0.74-3
- Devuan 3 Linux / DOSBox 0.74-2

**PCem**  
- Windows 10 / PCem v16
- BIOS ROMs: https://github.com/BaRRaKudaRain/PCem-ROMs

**DOSBox-X**  
- Devuan 3 Linux
- Compiled 0.83.3 SDL1


### Bonus Notes

Here are some power usage numbers while running SPEED.BAS in QBasic on my various systems, tested at the power outlet using a watt meter.

**Modern Desktop**  
- 160W
- AMD FX 8320 locked at 4GHz
- 24GB 1600MHz DDR3 RAM
- Nvidia GTS 1660
- 1TB Western Digital 7200 RPM hard drive
- SK Hynix and OCZ SATA solid state drives
- BenQ GW2470 Monitor
- Windows 10 / DOSBox

**Lenovo 100e Laptop**  
- 10W using the built in screen
- 26W using the BenQ GW2470 Monitor!
- Fully charged
- Devuan Linux / DOSox

**Compaq Deskpro 4000** 
- 86W using Acer 15" CRT
- 53W using Dell 15" LCD 
- Pentium 233MMX
- S3Virge GX 4MB
- Soundblaster 16 ISA
- 1GB Compact Flash IDE storage
- DOS 7
