## GAME2 Design Document
If you're not going to go whole hog creating flow charts (I never do), then it's a good idea to, at the very least, write some stuff down about a project before diving into it. I generally write my designs down on paper and later transpose them to the computer, but I thought for this project I'd just do here in this Markdown file from the start, as this game is just a recreation of the frigate fleet system from No Man's Sky that I am making as a way to practice data and memory management in QBasic. 


### Overview
- The player commands a group of starships, sending them out on missions according to those made available by his organization.  
- There are five different ship types, each with a particular focus and set of upgrades.  
- Missions require fuel. In return they provide trade goods and money.  
- Money is used to buy fuel and ships.  
- Trade goods are utilized by missions and required to complete repairs to the fleet.  


### Design Issues
- After sending out one's fleet in No Man's Sky, presumably the player will either wander off into some other activity in the game or log out for several hours to do real life stuff. Given that in the game I am making there won't be any other activities, I will need to find an enjoyable alternative to this design.  


### Game Screens
- Intro: An image and credits
- Select Profile: Four blank profiles at the start. Player selects one and either moves to the New Profile or the Fleet View screen.  
- New Profile: Get the player name, choose the difficulty level (easy, normal, hard).  
- Fleet View (F5): A list of all the ships in the fleet, five at a time. Scrolling with the arrow keys shuffles the visible ships. Tab/Enter are used to select a ship. Selection shows the ships upgrades and allows for repairing or dismissing the ship back to the organization's main fleet (it's deleted from the game, but the player gets some money depending on the ship's condition).  
- Mission Browser (F6): A list of 5 available mission. Tab/Enter selected. Selecting a mission opens the Assignment screen.  
- Assignment: Essentially a spreadsheet of the ships in the fleet, where the player can Tab/Enter select up to five ships per mission. The window displays the fuel cost, mission duration, and other stats as the player adds/removes ships. Esc returns to the Mission Browser window. Tab/Enter selection of the Commit button begins the mission.  
- Debriefing (F4): A list of the ships that have completed missions and are waiting to be debriefed. Tab/Enter selecting displays the outcome of the mission, updating the fleet stats.
- Travel (F7): A list of friendly systems the player can travel to for the purpose of purchasing fuel and new ships.  
- Trade - Buy (F8): Fuel, trade goods, and four ships, depending on the system. Initially randomly generated, but stored in a file for later use.  
- Trade - Sell (F9): A selection of resources in the player's possession that are valuable in the current system. Tab/Enter selection, answer quantity question (All/Half/Quarter), hopefully avoiding input overflow crashing!  
- Help (F1): Helpful stuff, eh.  
- Pause/Quit (Esc): Save and exit the game or just pause it.  

### Data Management
- I am hoping to make use of the fact that this is a game designed to be run only in DOSBox on a modern machine with fast file storage.  
- Data stored in CSV format, organized by directory and numerical file names. For example, star systems and ships will look like 123.CSV and will all contain the same organization of data (per type), thereby making it easy to generate and select them.  
- As few arrays as possible will be loaded into memory at any given time, instead relying on the combination small datasets and speedy modern disks/drives to move data into RAM only when it's being used or modified.  
- Believe it or not, this is actually how we were taught to manage data with QBasic 1.1 back in the early 1990s. Though it was for instructional purposes and never intended to handle a large amount of data. Our poor 1.44MB floppy disks and 386 PCs required a certain amount of patience!  

### Ship Stats

### Ship Upgrades 

### Ship Leveling

### Ship Condition

### Star System Stats

### Trade Goods