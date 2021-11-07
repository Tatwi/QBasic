# Resource Stats
All stats have values ranging from 0 to 100, where 100 denotes perfect effectiveness or the highest possible quality/value.  

## Physical Properties:
- DN: Density (Thin or tightly woven? Porosity. Titanium vs. Steel)
- FL: Flexibility
- LU: Lustre
- MA: Malleability
- PU: Purity
- SR: Shock Resistance (How brittle, easily cracked)
- DR: Decay Resistance (Chemical corrosion and physical wear)

## Magical Properties:
- VU: Virtue (Does good stuff)
- CR: Corruption (Does bad stuff)
- EF: Fire
- EE: Earth
- EW: Water
- EA: Air


# Resource Types
Each resource has its own strengths and weaknesses. When a new game is started, five variations of each resource type are generated. See the spreadsheet resource_properties.ods for a breakdown of the min and max stats per resource type. Each type has been assigned a reference number 1 through 41 and each has 5 sub-types numbered 1 through 5.  

## Sub-Types
1. Random stats
2. Random stats
3. Balanced Virtue and Corruption (50 +/- 5)
4. Virtuous (85 VU min, 20 CR max)
5. Corrupt (85 CR min, 20 VU max)

## Metal:

1. Copper
2. Tin
3. Bronze
4. Iron
5. Steel
6. Titanium
7. Gold

## Gemstone:
8. Garnet
9. Amethyst
10. Aquamarine
11. Diamond
12. Emerald
13. Pearl
14. Ruby
15. Peridot
16. Sapphire
17. Opal
18. Topaz
19. Tanzanite

## Animal:
20. Bone
21. Horn
22. Hide
23. Sinew

## Wood:
24. Apple
25. Ash
26. Birch
27. Elm
28. Lilac
29. Mahogany
30. Maple
31. Oak
32. Cedar
33. Pine
34. Redwood
35. Spruce
36. Yew

## Other:
37. Fibre
38. Oil
39. Pitch
40. Rubber
41. Water


# Resource Generation
The default values used by the game are stored in plain text data files in the GEN\RES\ directory like so,  

GEN\RES\NAMER.DAT - List of prefixes(30), roots(50), and suffixes(20) to make random words  
GEN\RES\NAMEV.DAT - Virtuous names  
GEN\RES\NAMEC.DAT - Corrupt names  
GEN\RES\#\MIN.DAT - Max resource values  
GEN\RES\#\MAX.DAT - Min resource values  

I used BASH script resFileMaker.sh, rp_min.csv, and rp_max.csv to create the initial database files from the source spreadsheet, resource_properties.ods. These files are included with this documentation for reference.  

Once generated for a new game, resource stats remain constant. The naming algorithm uses NAME*.DAT to generate a leading name for resources. This is mainly for "flavor", helping each play through be a little different than the last, and to make it easier for the player to see the difference between resources of the same type. The min and max values set the ranges used when generating resources. And the names of the types are stored in the MIN.DAT and MAX.DAT files and are referenced when needed.  

Generated resources are stored in the RES folder of the active profile. For example, SAVE\1\RES\34\5.DAT would be a corrupt type of Pine, which might be named *Ugly Pine*.  

The values inside MIN.DAT, MAX.DAT and the generated resources correspond to the stat values in this order:  
NAME, DN, FL, LU, MA, PU, SR, DR, VU, CR, EF, EE, EW, EA  

Generated resource files are the same with the exception that the name is unique (Blah Copper rather than just Copper). This standardizations helps when accessing the data.  


# Resource Access
There simply isn't enough available RAM in QBasic to store all of the resource data in RAM at all times. Consequently, I've used numbered text files to make a simple relational database to store this information. I am intentionally using sequential access files, as they are plain text that is easily read humans and easily managed by Git and humans a like. As such, values are accessed by way of a FOR loop that reads all values in a file up to and including the one that was requested. Clearly this isn't as efficient as using a random access record file, but all of these data files are very small and the access time is so low that in practice the difference doesn't matter.  

## Access Function Logic Flow
- Open the desired file
- Read the name into a variable (to advance passed it)
- Read values into a variable until the desired resource has been reached
- Close the file
- Return the resource value

This same logic is used to reference values in the data files throughout the game in general, with modifications based on the data types.  


# Item Stats
For simplicity, every item has the same stats, but they are not used by all items. Where a value is 0, the stat is not in use.  

## All Stats:
- Health
- Mana
- Damage Value
- Damage Type
- Armor Value
- Encumbrance
- Durability
- Precision
- Damage Resistance Type (Always 5%, cumulative)
- Magical Effect
- Dollar Value

## Weapons:
- Damage Value
- Damage Type
- Encumbrance
- Durability
- Precision
- Damage Resistance Type
- Magical Effect
- Dollar Value

## Armor:
- Health
- Mana
- Armor Value
- Encumbrance
- Durability
- Damage Resistance Type
- Magical Effect
- Dollar Value

## Tools:
- Durability
- Precision
- Damage Resistance Type
- Magical Effect
- Dollar Value

## Accessories
- These can contain any combination of four stats as well as a dollar value.