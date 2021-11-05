# Resource Stats
All stats have values ranging from 1 to 100, where 100 denotes perfect effectiveness or the highest possible quality/value.  

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
Each resource has its own strengths and weaknesses. When a new game is started, five variations of each resource type are generated. See the spreadsheet resource_properties.ods for a breakdown of the min and max stats per resource type. Each type has been assigned a reference number 1 through 42 and each has 5 sub-types numbered 1 through 5.  

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
7. Aluminum
8. Gold

## Gemstone:
9. Garnet
10. Amethyst
11. Aquamarine
12. Diamond
13. Emerald
14. Pearl
15. Ruby
16. Peridot
17. Sapphire
18. Opal
19. Topaz
20. Tanzanite

## Animal:
21. Bone
22. Horn
23. Hide
24. Sinew

## Wood:
25. Apple
26. Ash
27. Birch
28. Elm
29. Lilac
30. Mahogany
31. Maple
32. Oak
33. Cedar
34. Pine
35. Redwood
36. Spruce
37. Yew

## Other:
38. Fibre
39. Oil
40. Pitch
41. Rubber
42. Water


# Resource Generation
The default values used by the game are stored in plain text data files in the GEN\RES\ directory like so,  

GEN\RES\#\MIN.DAT - Max resource values  
GEN\RES\#\MAX.DAT - Min resource values  
GEN\RES\#\NAMER1.DAT - 10 Random names  
GEN\RES\#\NAMER2.DAT - 10 Different random names  
GEN\RES\#\NAMEB.DAT - 10 name for balanced resources  
GEN\RES\#\NAMEV.DAT - 10 name for virtuous resources  
GEN\RES\#\NAMEC.DAT - 10 name for corrupt resources  

Once generated for a new game, resource stats remain constant. The naming algorithm picks a number from 1 to 10 and then selects the name at that number in the file related to resource that is being generated at the time. This is mainly for "flavor", helping each play through be a little different than the last. The min and max values set the ranges used when generating resources. And the names of the types are stored in the MIN.DAT and MAX.DAT files and are referenced when needed.  

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