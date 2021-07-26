# Design Document
If you're not going to go whole hog creating flow charts (I never do), then it's a good idea to, at the very least, write some stuff down about a project before diving into it. I generally write my designs down on paper and later transpose them to the computer, but I thought for this project I'd just do here in this Markdown file from the start, as this game is "just" a game similar to the frigate fleet system from No Man's Sky, which is of course, already *designed*. I am making this game as a way to practice data, memory, and file management in QBasic.  


### Overview
- The player commands a group of Galactic Union star ships, sending them out on missions according to those made available by his regional command.  
- Up to five people can play the game, one at a time, using one of the five profiles. This allows the players to have an effect on each other by way of their own effects on the star systems.  
- There are five different ship types, each with a particular focus and set of upgrades.  
- Missions require fuel. In return they provide trade goods and money.  
- Money is used to buy fuel and ships.  
- Trade goods are automatically utilized by missions and are required to complete repairs to the fleet.  
- Ships level up as they are sent on missions, gaining five positive traits when they are fully leveled. May acquire negative traits while leveling, but they will eventually be replaced by positive traits.  
- You lose the game by running out of money to pay for fuel or by destroying all of your ships, at which point the Galactic Union will fire you. To completely run out of money, you will have to sell all of your trade goods and all but your last ship back to the Galactic Union and still not have enough money in the bank to buy fuel for the easiest missions.  
- You win the game by reaching Rank 5, but you can keep playing as long as you'd like, provided you don't end up running out of money or destroying all of your ships.  


### Game Screens
- Intro: An image and credits
- Select Profile: Four blank profiles at the start. Player selects one and either moves to the New Profile or the Fleet View screen.  
- New Profile: Get the player name, choose the difficulty level (easy, normal, hard).  
- Fleet View (F5): A list of all the ships in the fleet, five at a time. Scrolling with the arrow keys shuffles the visible ships. Tab/Enter are used to select a ship. Selection moves to the Ship Details screen.  
- Ship Details: Shows the ships upgrades and allows for repairing or dismissing the ship back to the organization's main fleet (in exchange for money, depending on the ship's condition). Recruiting, leveling, and dismissing ships is a good way to gain reputation and earn money!
- Mission Browser (F6): A list of 5 available mission. Tab/Enter selected. Selecting a mission opens the Assignment screen.  
- Assignment: Essentially a spreadsheet of the ships in the fleet, where the player can Tab/Enter select up to five ships per mission. The window displays the fuel cost, mission duration, and other stats as the player adds/removes ships. Esc returns to the Mission Browser window. Tab/Enter selection of the Commit button begins the mission.  
- Debriefing (F4): A list of the ships that have completed missions and are waiting to be debriefed. Tab/Enter selecting displays the outcome of the mission, updating the fleet stats.  
- Star Chart (F8): A list of the known star systems and the data the player has gathered about them. Numerical data is converted to descriptive words, such as "Combat 177" translating to "Conflict Level: Extreme".  
- Help (F1): Helpful stuff, eh.  
- Pause/Quit (Esc): Save and exit the game or just pause it.  
- Recruitment:  Allows the player to enable the automatic recruitment of new ships during missions.  
- Local Trade: Allows the player to buy and sell goods in their home system. This allows the player to have a direct impact on their home system, increasing prosperity and decreasing conflict as the needs of the system are met.  


### Data Management
- I am hoping to make use of the fact that this is a game designed to be run only in DOSBox on a modern machine with fast file storage.  
- Data stored in CSV format, organized by directory and numerical file names. For example, star systems and ships will look like 123.CSV and will all contain the same organization of data (per type), thereby making it easy to generate and select them.  
- As few arrays as possible will be loaded into memory at any given time, instead relying on the combination small datasets and speedy modern disks/drives to move data into RAM only when it's being used or modified.  
- Believe it or not, this is actually how we were taught to manage data with QBasic 1.1 back in the early 1990s. Though it was for instructional purposes and never intended to handle a large amount of data. Our poor 1.44MB floppy disks and 386 PCs required a certain amount of patience!  


### Data Structure

**Player**  
PROFILE1-4 Directory, PLAYER.CSV:  
- pName, STR  
- pRank, INT, 1-5, R1=0 XP, R2=5K XP, R3=10K XP, R4=18K XP, R5=32K XP.
- pHome, INT, 1-100, The player's home star system, where all missions start/end.
- pMoney, LONG INT, 0-2 billion  
- pXP, INT, 1-32000

PROFILE1-4/Directory, INV.CSV:
- pInventory, ARRAY 71, INT 0-500, Fuel + a value for each of the 70 goods.  

**Ships**  
- PROFILE1-4 Directory, SHIP1-30.CSV  
- Custom Type
- Level, INT, 1-5  
- Experience, INT, 1-1000  
- Fitness, INT, 1-1000
- Damage Reduction, INT, 0-25  
- Fuel Usage, INT, 2-15  
- Speed, INT 0-25
- Combat , INT, 0-40  
- Exploration, INT, 0-40  
- Industry, INT, 0-40  
- Trade, INT, 0-40  
- Trait1-5, INT, 0-70 

**Traits**  
- TRAITS Directory, read only  
- Files 1.CSV to 70.CSV, values < 35 are detrimental traits.
- Each file contains INT, INT, STR for Stat type, value, and description.  

**Trade Goods**  
- GOODS Directory, read only  
- Files 1.CSV to 71.CSV  
- Each file contains STR, INT for item name and average value.  

**Star Systems**
- SYSTEMS Directory, read/write  
- Shared between player profiles, such that activity by one player effects the others.  
- Files1-100.CSV where each file contains the following data.  
- Economy Type, INT, 0-7, where 0 is uninhabited.  
- Economy Quality, INT, 0-5
- Combat, INT, 10-200  
- Exploration, INT, 10-200  
- Industry, INT, 10-200  
- Trade, INT, 10-200  
- X,Y,Z, INT, INT, INT, 1-100, Light Year position relative to the Galactic Union home system.  
- Goods1-10, INT, INT, pairs for type/value, where 1 = fuel and others are randomly selected when the system is created. Types 2-6 are for sale, while 7-10 are desired.  

**Missions**  
- mStatus, INT ARRAY 5, 0-2, for ready/away/returned  

PROFILE1-4/MISSIONS/1-5 Directory, SETUP.CSV:  
- Files generated with status=0, and no data for endTime and ships1-5. Once the player accpets the mission, the status, endTime, and ships1-5 values are updated/added.  
- status, INT, 0-2  
- endTime, LONG INT, 0-86400  
- type, INT, 1-4  
- difficulty, INT, 10-200, overall.  
- distance, INT, 1-3200, sum of the distanced between each star system on the route.  
- ship1-5, INT, 0-30, where 0 is no ship assigned for that slot.  
- encounters1-16, INT, 1-5000, where 0 is no encounter, else is the star system. 

PROFILE1-4/MISSIONS/1-5 Directory, INV.CSV:  
- Mission inventory, auto selected.

PROFILE1-4/MISSIONS/1-5/RESULTS Directory, 1-16.CSV:  
- Files are the results of each encounter during the mission. There can be up to 16 files.  
- type, INT, 1-4  
- difficulty, INT, 10-200  
- success, INT, -1/0  
- shipXP1-5, INT, 0-100  
- shipDamage1-5, INT, 0-100  
- money, INT, -1000-32000  
- itemUsed, INT, 0-70, where 0 is no item used.  
- itemObtained, INT, 0-70, where 0 is no item gained.  


### Missions
- The player is presented up to five missions at a time, each randomly generated based on the total stats of the player's ships.  
- The player may reject a mission and have it replaced by another once every so often, depending on their rank and at a monetary cost.  
- One to five ships are assigned per mission.  
- Each mission is comprised of a number of encounters, most of which will be specific to the roll of the mission. The player is shown only roll of the mission and the star systems which will be visited. This information, combined with the star chart screen, should help the player assign the best ships for the job.  
- Inventory items (trade goods include weaponry and other "power-up" type things) are automatically taken by ships before they depart on a mission.  
- Missions require between 4 and 16 minutes to complete, however the results are calculated and saved immediately after they are accepted.  

### Ship Recruitment
- On the Recruitment screen, the player can enable the recruitment of new vessels according to their desired criteria. If enabled, each encounter has a 50% chance to generate a candidate based upon the statistics of the system they are in. If the candidate meets the criteria, they are recruited into the fleet.  


### Program File Flow
QBasic is able to seamlessly move from one program file to another and when combined with saving/loading data from text files (which is near instant on modern hardware), it allows a person to make a program that is larger than the 160KB limit of the QBasic 1.1 IDE. Here is how I intend to use this feature for the game.  

**GAME.BAS**  
- This is file that the player will run to start the game.  
- Displays the intro sequence.  
- Selects the player's profile. If this is a new profile, it generates the randomized data for a new player. Also allows for deleting profiles.  
- Loads MAIN.BAS.  

**MAIN.BAS**  
- This is the majority of the game, comprising all of the content the player interacts with.  
- Reads value in AP.DAT to set active profile, 1 to 5, and loads the appropriate data.  
- Periodically runs UPDATE.BAS.  

**UPDATE.BAS**  
- Generates between 8 to 16 random events in random system, and 0 to 4 events in the player's home system, displaying the events to the player in the form of a news ticker.  
- The events are weighted towards the existing stats of a system, so the player may see high conflict system become a low conflict system after a decisive battle or a colony may emerge in an uninhabited system, and so on.  

**BUILDER.BAS**  
- This is a tool that allows the user to generate a new universe in the SYSTEMS directory, backing up the existing one before hand.  
- By default it will generate 100 system, but it can be set to generate up to 500 systems. having too many systems means the player will likely never encounter most of them, as they are simply too far away from their home system. However, having more systems will likely reduce the impact players will have on each other, unless they happen to live very close to each other.  


### Design Issues
- After sending out one's fleet in No Man's Sky, presumably the player will either wander off into some other activity in the game or log out for several hours to do real life stuff. Given that in the game I am making there won't be any other activities, I will need to find an enjoyable alternative to this design. **SOLVED:** *I've decided to make the game turn based, such that each time the player assigns a mission, the game will update the universe. This update runs another program which prints out an activity log on the screen for the player, which they must allow to complete before continuing to play.*  

