//Credits Mysterion352
//Commissioned by MichaelK__

state("pseudoregalia-Win64-Shipping")
{
    byte key1: 0x06496640, 0x1B8, 0x0339;                           //Empty Bailey Key
    byte key2: 0x06496640, 0x1B8, 0x033A;                           //Underbelly Key
    byte key3: 0x06496640, 0x1B8, 0x033B;                           //Tower Key
    byte key4: 0x06496640, 0x1B8, 0x033C;                           //Sansa Keep Key
    byte key5: 0x06496640, 0x1B8, 0x0488;                           //Twilight Key
    byte DB: 0x6496640, 0x1B8, 0x1D8, 0x8;                          //1 when picking up dream breaker, 0 when not
    byte empathy: 0x6496640, 0x1B8, 0x1D8, 0x134;                   //Increases by 1 when picking up Empathy
    byte GG: 0x6496640, 0x1B8, 0x1D8, 0x148;                        //Increases by 1 when picking up Good Grace
    byte CM: 0x6496640, 0x1B8, 0x1D8, 0x184;                        //Increases by 1 when picking up Clear Mind
    byte menuStart: 0x645D318;                                      //Ingame 1; Menu 0
    int bossPhase: 0x06496640, 0x30, 0xE8, 0x2A8, 0x764;    	    //1 when the boss is dead, 0 when the boss isnt dead, null when boss isnt available
    int keyItem: 0x06496640, 0x1B8, 0x470;                          //Use settings as reference
    int silverKeys: 0x06496640, 0x1B8, 0x1C8;                       //Incrementing value of collected silver keys
    int healthUpgrades: 0x06496640, 0x1B8, 0x260;                   //1 when collecting the first upgrade, 2 on the 2nd. 0 when fully upgraded
    long FGUID: 0x06496640, 0x30, 0x210;                            //5185712904977434514 in menu
    double finalBossHP: 0x06496640, 0x30, 0xE8, 0x2A8, 0x638, 0xA8; //1500 when entering the bossfight; 0 when dead
    string40 area: 0x06496640, 0x1B8, 0x2A0, 0x0;                   //Use the Tuples as reference
}

startup
{
    vars.itemIDSettings = new List<String>()
    {"Indignation", "Slide", "Solar Wind", "Air Kick - Sun Greaves", "Plunge", "Cling", "Bright Soul - Ascendant Light", "Strikebreak", "Soul Cutter", "Clear Mind", "Empathy",
    "Good Graces", "Martial Power", "Pilgrimage", "Aerial Finesse", "Heliiacal Power", "Professionalism"};

    vars.itemIDs = new List<int>()
    {8, 2, 9, 1, 3, 4, 5, 11, 6, 19, 15, 16, 17, 14, 13, 12, 20};

    vars.areaSettings = new List<String>()
    {"Dilapidated Dungeon > Castle Sansa", "Dilapidated Dungeon > The Underbelly", "Dilapidated Dungeon > Twilight Theatre", "Castle Sansa > Dilapidated Dungeon",
    "Castle Sansa > Empty Bailey", "Castle Sansa > Sansa Keep (2)", "Castle Sansa > Listless Library", "Castle Sansa > Twilight Theatre (2)", "Listless Library > Castle Sansa",
    "Empty Bailey > Castle Sansa", "Empty Bailey > The Underbelly", "Empty Bailey > Tower Remains", "Empty Bailey > Twilight Theatre", "Sansa Keep > Castle Sansa (2)",
    "Sansa Keep > The Underbelly", "Sansa Keep > Twilight Theatre", "The Underbelly > Dilapidated Dungeon", "The Underbelly > Empty Bailey", "The Underbelly > Sansa Keep ",
    "Twilight Theatre > Dilapidated Dungeon", "Twilight Theatre > Castle Sansa (2)", "Twilight Theatre > Empty Bailey", "Twilight Theatre > Sansa Keep",
    "Tower Remains > Empty Bailey", "Tower Remains > Final Boss Arena", "Final Boss Arena > Tower Remains"};

    vars.majorKeySettings = new List<String>()
    {"Empty Bailey Key", "Underbelly Key", "Tower Key", "Sansa Keep Key", "Twilight Key"};

    vars.completedSplits = new List<int>();
    vars.LastSplitDebug = "None";

    //vars.areaSplitsSettings = new List<String>()
    //{"Dungeon", "Castle Sansa", "Sansa Keep", "Empty Bailey", "Listless Library", "The Underbelly", "Tower Remains", "Twilight Theatre", "Princess Chambers"};

    settings.Add("Golden Keys");
    settings.CurrentDefaultParent = "Golden Keys";
    for (int i = 0; i <= 4; i++){
        settings.Add("" + vars.majorKeySettings[i].ToString(), true, "" +vars.majorKeySettings[i].ToString());
    }
    settings.CurrentDefaultParent = null;
    //settings.Add("Silver Keys");
    settings.Add("Health Upgrades");
    settings.Add("Item Splits");
    settings.CurrentDefaultParent = "Item Splits";
    settings.Add("db", true, "Dream Breaker");
    settings.CurrentDefaultParent = null;
    settings.Add("Sub Splits");
    for(int i = 0; i <= 16; i++){
        if(i <= 8){
            settings.CurrentDefaultParent = "Item Splits";
        }
        if(i >= 9){
            settings.CurrentDefaultParent = "Sub Splits";
        }
        settings.Add("" + vars.itemIDs[i].ToString(), true, "" + vars.itemIDSettings[i].ToString());
    }
    settings.CurrentDefaultParent = null;
    settings.Add("Area Splits");
    settings.CurrentDefaultParent = "Area Splits";
    for(int i = 0; i < 26; i++){
        settings.Add("A" + i, true, "" + vars.areaSettings[i].ToString());
    }
    settings.SetToolTip("A5", "The (2) shows that the mentioned area has to 2 possible entry points for the same area from the previous area");
    settings.SetToolTip("A7", "The (2) shows that the mentioned area has to 2 possible entry points for the same area from the previous area");
    settings.SetToolTip("A13", "The (2) shows that the mentioned area has to 2 possible entry points for the same area from the previous area");
    settings.SetToolTip("A20", "The (2) shows that the mentioned area has to 2 possible entry points for the same area from the previous area");
}

init
{
    vars.healthUG = 0;
    //vars.firstSilverKey = 0;
    vars.empathy = 0;
    vars.gg = 0;
    vars.cm = 0;
    vars.dbPickUp = 0;
    vars.empty = 0;
    vars.underbelly = 0;
    vars.tower = 0;
    vars.sansa = 0;
    vars.twilight = 0;

    vars.areaSplit = new List<Tuple<String, String, int>>(){
        Tuple.Create("ZONE_Dungeon", "ZONE_LowerCastle", 0),
        Tuple.Create("ZONE_Dungeon", "Zone_Caves", 1),
        Tuple.Create("ZONE_Dungeon", "Zone_Theatre", 2),
        Tuple.Create("ZONE_LowerCastle", "ZONE_Dungeon", 3),
        Tuple.Create("ZONE_LowerCastle", "ZONE_Exterior", 4),
        Tuple.Create("ZONE_LowerCastle", "Zone_Upper", 5),
        Tuple.Create("ZONE_LowerCastle", "Zone_Library", 6),
        Tuple.Create("ZONE_LowerCastle", "Zone_Theatre", 7),
        Tuple.Create("Zone_Library", "ZONE_LowerCastle", 8),
        Tuple.Create("ZONE_Exterior", "ZONE_LowerCastle", 9),
        Tuple.Create("ZONE_Exterior", "Zone_Caves", 10),
        Tuple.Create("ZONE_Exterior", "Zone_Tower", 11),
        Tuple.Create("ZONE_Exterior", "Zone_Theatre", 12),
        Tuple.Create("Zone_Upper", "ZONE_LowerCastle", 13),
        Tuple.Create("Zone_Upper", "Zone_Caves", 14),
        Tuple.Create("Zone_Upper", "Zone_Theatre", 15),
        Tuple.Create("Zone_Caves", "ZONE_Dungeon", 16),
        Tuple.Create("Zone_Caves", "ZONE_Exterior", 17),
        Tuple.Create("Zone_Caves", "Zone_Upper", 18),
        Tuple.Create("Zone_Theatre", "ZONE_Dungeon", 19),
        Tuple.Create("Zone_Theatre", "ZONE_LowerCastle", 20),
        Tuple.Create("Zone_Theatre", "ZONE_Exterior", 21),
        Tuple.Create("Zone_Theatre", "Zone_Upper", 22),
        Tuple.Create("Zone_Tower", "ZONE_Exterior", 23),
        Tuple.Create("Zone_Tower", "Zone_PrincessChamber", 24),
        Tuple.Create("Zone_PrincessChamber", "Zone_Tower", 25),
    };
}

start
{
    if(current.menuStart == 1 && old.menuStart == 0){
        return true;
    }
}

split
{
    if(settings["Golden Keys"]){
        if(current.key1 == 1 && old.key1 == 0 && vars.empty == 0 && settings["Empty Bailey Key"]){
            vars.empty = 1;
            vars.LastSplitDebug = "Empty Bailey Key";
            return true;
        }

        if(current.key2 == 1 && old.key2 == 0 && vars.underbelly == 0 && settings["Underbelly Key"]){
            vars.underbelly = 1;
            vars.LastSplitDebug = "Underbelly Key";
            return true;
        }

        if(current.key3 == 1 && old.key3 == 0 && vars.tower == 0 && settings["Tower Key"]){
            vars.tower = 1;
            vars.LastSplitDebug = "Tower Key";
            return true;
        }

        if(current.key4 == 1 && old.key4 == 0 && vars.sansa == 0 && settings["Sansa Keep Key"]){
            vars.sansa = 1;
            vars.LastSplitDebug = "Sansa Keep Key";
            return true;
        }

        if(current.key5 == 1 && old.key5 == 0 && vars.twilight == 0 && settings["Twilight Key"]){
            vars.twilight = 1;
            vars.LastSplitDebug = "Twilight Key";
            return true;
        }
    }
    /*
    if(settings["Silver Keys"]){
        if(current.silverKeys > old.silverKeys && current.area == old.area && vars.firstSilverKey == 1 && old.silverKeys != 0){
            return true;
        }

        if(current.silverKeys > old.silverKeys && vars.firstSilverKey == 0){
            vars.firstSilverKey = 1;
            return true;
        }

        if(current.silverKeys == 0 && old.silverKeys == 1 && current.area == old.area){
            vars.firstSilverKey = 0;
        }
    }*/

    if(settings["Health Upgrades"]){
        if(current.healthUpgrades > old.healthUpgrades && current.area == old.area && old.healthUpgrades != 0){
            vars.LastSplitDebug = "Health Upgrade: " + current.healthUpgrades.ToString();
            return true;
        }
        if(current.healthUpgrades > old.healthUpgrades && current.area == old.area && vars.healthUG == 0){
            vars.healthUG = 1;
            vars.LastSplitDebug = "First Health Upgrade: " + current.healthUpgrades.ToString();
            return true;
        }
    }

    if(settings["Item Splits"] || settings["Sub Splits"]){
        if(settings[current.keyItem.ToString()] && !vars.completedSplits.Contains(current.keyItem) && current.keyItem != 19 && current.keyItem != 15 && current.keyItem != 16){
            vars.completedSplits.Add(current.keyItem);
            vars.LastSplitDebug = "Item Splits: " + vars.itemIDSettings[vars.itemIDs.IndexOf(current.keyItem)].ToString();
            return true;
        }
        if(settings["db"] && current.DB == 1 && old.DB == 0 && current.area == old.area && vars.dbPickUp == 0){
            vars.dbPickUp = 1;
            vars.LastSplitDebug = "Item Splits: Dream Breaker";
            return true;
        }
        if((current.empathy > old.empathy && vars.empathy == 1 && old.empathy != 0 || current.GG > old.GG && vars.gg == 1 && old.GG != 0 || current.CM > old.CM && vars.cm == 1 && old.CM != 0) &&
         settings[current.keyItem.ToString()]){
            vars.LastSplitDebug = "Item Splits: " + vars.itemIDSettings[vars.itemIDs.IndexOf(current.keyItem)].ToString();
            return true;
        }

        if(current.empathy > old.empathy && vars.empathy == 0 && settings[current.keyItem.ToString()]){
            vars.empathy = 1;
            vars.LastSplitDebug = "Item Splits: First Empathy";
            return true;
        }

        if(current.GG > old.GG && vars.gg == 0 && settings[current.keyItem.ToString()]){
            vars.gg = 1;
            vars.LastSplitDebug = "Item Splits: First Good Graces";
            return true;
        }

        if(current.CM > old.CM && vars.cm == 0 && settings[current.keyItem.ToString()]){
            vars.cm = 1;
            vars.LastSplitDebug = "Item Splits: First Clear Mind";
            return true;
        }
    }

    if(settings["Area Splits"]){
        for(int i = 0; i < 26; i++){
            if(settings["A" + i] && vars.areaSplit.Contains(Tuple.Create(Convert.ToString(old.area), Convert.ToString(current.area), i))){
                vars.LastSplitDebug = "Area Splits: " + vars.areaSettings[i].ToString();
                return true;
            }
        }
    }

    //Final Split
    if(current.area == "Zone_PrincessChamber" && current.finalBossHP <= 0 && current.bossPhase == 1){
        vars.LastSplitDebug = "Final Boss";
        return true;
    }
}

reset
{
    if(current.FGUID == 5185712904977434514){
        return true;
    }
}

update{
    if(timer.CurrentPhase == TimerPhase.NotRunning){
        vars.completedSplits.Clear();
        vars.healthUG = 0;
        vars.empathy = 0;
        vars.gg = 0;
        vars.cm = 0;
        //vars.firstSilverKey = 0;
        vars.dbPickUp = 0;
        vars.empty = 0;
        vars.underbelly = 0;
        vars.tower = 0;
        vars.sansa = 0;
        vars.twilight = 0;
        vars.LastSplitDebug = "None";
    }

    //print("This is area: " + current.keyItem);
}

onStart
{
    // This makes sure the timer always starts at 0.00
    timer.IsGameTimePaused = true;

    // This makes sure the variables are setup accordingly when starting from an old save
    vars.completedSplits.Clear();
    vars.completedSplits.Add(current.keyItem);
    vars.healthUG = current.healthUpgrades >= 1 ? 1 : 0;
    vars.empathy = current.empathy >= 1 ? 1 : 0;
    vars.gg = current.GG >= 1 ? 1 : 0;
    vars.cm = current.CM >= 1 ? 1 : 0;
    //vars.firstSilverKey = current.silverKeys >= 1 ? 1 : 0;
    vars.dbPickUp = current.DB >= 1 ? 1 : 0;
    vars.empty = current.key1 >= 1 ? 1 : 0;
    vars.underbelly = current.key2 >= 1 ? 1 : 0;
    vars.tower = current.key3 >= 1 ? 1 : 0;
    vars.sansa = current.key4 >= 1 ? 1 : 0;
    vars.twilight = current.key5 >= 1 ? 1 : 0;
}

exit
{
    //pauses timer if the game crashes
	timer.IsGameTimePaused = true;
}
