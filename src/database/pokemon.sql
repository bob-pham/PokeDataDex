-- This script creates all tables for the Pokemon Go journal application

-- Drop all tables to reset data and to avoid error when creating tables
DROP TABLE Team CASCADE CONSTRAINTS;
DROP TABLE MascotColour CASCADE CONSTRAINTS;
DROP TABLE Player CASCADE CONSTRAINTS;
DROP TABLE PlayerXPLevel CASCADE CONSTRAINTS;
DROP TABLE Item CASCADE CONSTRAINTS;
DROP TABLE ItemEffectType CASCADE CONSTRAINTS;
DROP TABLE ItemTypeUses CASCADE CONSTRAINTS;
DROP TABLE Mission CASCADE CONSTRAINTS;
DROP TABLE MissionEventNameXP CASCADE CONSTRAINTS;
DROP TABLE Location CASCADE CONSTRAINTS;
DROP TABLE BiomeAttackBonus CASCADE CONSTRAINTS;
DROP TABLE Gym CASCADE CONSTRAINTS;
DROP TABLE Pokestop CASCADE CONSTRAINTS;
DROP TABLE Egg CASCADE CONSTRAINTS;
DROP TABLE EggSpecies CASCADE CONSTRAINTS;
DROP TABLE Pokemon CASCADE CONSTRAINTS;
DROP TABLE PokemonSpeciesCP CASCADE CONSTRAINTS;
DROP TABLE PokemonSpeciesTypes CASCADE CONSTRAINTS;
DROP TABLE NPC CASCADE CONSTRAINTS;
DROP TABLE RoleCanBattle CASCADE CONSTRAINTS;
DROP TABLE PlayerOwnsItem CASCADE CONSTRAINTS;
DROP TABLE PlayerCompletedMission CASCADE CONSTRAINTS;
DROP TABLE Battle CASCADE CONSTRAINTS;
DROP TABLE LeagueMaxCP CASCADE CONSTRAINTS;
DROP TABLE PlayerCapturedPokemon CASCADE CONSTRAINTS;
DROP TABLE PlayerCapturedEgg CASCADE CONSTRAINTS;
DROP TABLE PlayerVisitedPokestop CASCADE CONSTRAINTS;
DROP TABLE NPCAppearedAtPokestop CASCADE CONSTRAINTS;
DROP TABLE NPCSighting CASCADE CONSTRAINTS;
DROP TABLE NPCSightingEventName CASCADE CONSTRAINTS;

-- Create all tables

CREATE TABLE MascotColour (
     Mascot CHAR(20) PRIMARY KEY,
     Colour CHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Team(
      Name CHAR(8) PRIMARY KEY,
      Mascot CHAR(20) NOT NULL UNIQUE,
      FOREIGN KEY (Mascot)
           REFERENCES MascotColour(Mascot)
           ON DELETE CASCADE
);

CREATE TABLE PlayerXPLevel(
    XP INTEGER PRIMARY KEY,
    PlayerLevel INTEGER NOT NULL
);

CREATE TABLE Player(
    Username CHAR(15) PRIMARY KEY,
    XP INTEGER NOT NULL,
    TeamName CHAR(8) NOT NULL,
    FOREIGN KEY (TeamName)
        REFERENCES Team(Name)
        ON DELETE CASCADE,
    FOREIGN KEY (XP)
        REFERENCES PlayerXPLevel(XP)
        ON DELETE CASCADE
);

CREATE TABLE ItemTypeUses(
    Type CHAR(20) PRIMARY KEY,
    Uses INTEGER
);

CREATE TABLE ItemEffectType(
    Effect CHAR(100) PRIMARY KEY,
    Type CHAR(20) NOT NULL,
    FOREIGN KEY (Type)
        REFERENCES ItemTypeUses(Type)
        ON DELETE CASCADE
);

CREATE TABLE Item(
    Name CHAR(30) PRIMARY KEY,
    Cost INTEGER,
    Effect CHAR(100),
    FOREIGN KEY (Effect)
        REFERENCES ItemEffectType(Effect)
        ON DELETE CASCADE
);

CREATE TABLE MissionEventNameXP(
    EventName CHAR(50) PRIMARY KEY,
    XP INTEGER NOT NULL
);

CREATE TABLE Mission(
    Name CHAR(50) PRIMARY KEY,
    EventName CHAR(50),
    FOREIGN KEY (EventName)
        REFERENCES MissionEventNameXP(EventName)
        ON DELETE CASCADE
);

CREATE TABLE BiomeAttackBonus(
    Biome CHAR(20) PRIMARY KEY,
    AttackBonus CHAR(20) NOT NULL
);

CREATE TABLE Location(
    Country CHAR(50),
    PostalCode CHAR(10),
    Name CHAR(50) DEFAULT 'Unknown',
    Biome CHAR(20) NOT NULL,
    PRIMARY KEY (Country, PostalCode, Name),
    FOREIGN KEY (Biome)
        REFERENCES BiomeAttackBonus(Biome)
        ON DELETE CASCADE
);

CREATE TABLE Gym(
    Country CHAR(50),
    PostalCode CHAR(10),
    Name CHAR(50),
    BadgeName CHAR(30) NOT NULL UNIQUE,
    SponsorName CHAR(50),
    PRIMARY KEY (Country, PostalCode, Name),
    FOREIGN KEY (Country, PostalCode, Name)
        REFERENCES Location(Country, PostalCode, Name)
        ON DELETE CASCADE
);

CREATE TABLE Pokestop(
    Country CHAR(50),
    PostalCode CHAR(10),
    Name CHAR(50),
    Rating INTEGER,
    SponsorName CHAR(50),
    PRIMARY KEY (Country, PostalCode, Name),
    FOREIGN KEY (Country, PostalCode, Name)
        REFERENCES Location(Country, PostalCode, Name)
        ON DELETE CASCADE
);

CREATE TABLE EggSpecies(
    SpeciesName CHAR(20) PRIMARY KEY,
    Type1 CHAR(10) NOT NULL,
    Type2 CHAR(10),
    Distance INTEGER NOT NULL
);

CREATE TABLE Egg(
    ID INTEGER PRIMARY KEY,
    SpeciesName CHAR(20) NOT NULL,
    FOREIGN KEY (SpeciesName)
        REFERENCES EggSpecies(SpeciesName)
        ON DELETE CASCADE
);


CREATE TABLE PokemonSpeciesTypes(
    SpeciesName CHAR(20) PRIMARY KEY,
    Type1 CHAR(10) NOT NULL,
    Type2 CHAR(10)
);

CREATE TABLE PokemonSpeciesCP(
    SpeciesName CHAR(20),
    CP INTEGER,
    HP INTEGER NOT NULL,
    Attack INTEGER NOT NULL,
    PRIMARY KEY (SpeciesName, CP),
    FOREIGN KEY (SpeciesName)
        REFERENCES PokemonSpeciesTypes(SpeciesName)
        ON DELETE CASCADE
);

CREATE TABLE Pokemon(
    ID INTEGER PRIMARY KEY,
    SpeciesName CHAR(20) NOT NULL,
    CP INTEGER NOT NULL,
    Distance INTEGER,
    Nickname CHAR(15),
    GymCountry CHAR(50),
    GymPostalCode CHAR(10),
    GymName CHAR(50),
    StationedAtDate DATE,
    FoundCountry CHAR(50),
    FoundPostalCode CHAR(10),
    FoundName CHAR(50),
    FOREIGN KEY (GymCountry, GymPostalCode, GymName)
        REFERENCES Gym(Country, PostalCode, Name)
        ON DELETE CASCADE,
    FOREIGN KEY (FoundCountry, FoundPostalCode, FoundName)
        REFERENCES Location(Country, PostalCode, Name)
        ON DELETE CASCADE,
    FOREIGN KEY (SpeciesName)
        REFERENCES PokemonSpeciesTypes(SpeciesName)
        ON DELETE CASCADE,
    FOREIGN KEY (SpeciesName, CP)
        REFERENCES PokemonSpeciesCP(SpeciesName, CP)
        ON DELETE CASCADE
);

CREATE TABLE RoleCanBattle(
    Role CHAR(20) PRIMARY KEY,
    CanBattle NUMBER(1) DEFAULT 0 NOT NULL CHECK (CanBattle IN (0, 1))
);

CREATE TABLE NPC(
    Name CHAR(20) PRIMARY KEY,
    Role CHAR(20) NOT NULL,
    FOREIGN KEY (Role)
        REFERENCES RoleCanBattle(Role)
        ON DELETE CASCADE
);

CREATE TABLE PlayerOwnsItem(
    PlayerUsername CHAR(15),
    ItemName CHAR(30),
    Quantity INTEGER NOT NULL,
    PRIMARY KEY (PlayerUsername, ItemName),
    FOREIGN KEY (PlayerUsername)
        REFERENCES Player(Username)
        ON DELETE CASCADE,
    FOREIGN KEY (ItemName)
        REFERENCES Item(Name)
        ON DELETE CASCADE
);

CREATE TABLE PlayerCompletedMission(
    PlayerUsername CHAR(15),
    MissionName CHAR(50),
    CompletedDate DATE NOT NULL,
    PRIMARY KEY (PlayerUsername, MissionName),
    FOREIGN KEY (PlayerUsername)
        REFERENCES Player(Username)
        ON DELETE CASCADE,
    FOREIGN KEY (MissionName)
        REFERENCES Mission(Name)
        ON DELETE CASCADE
);

CREATE TABLE LeagueMaxCP(
    League CHAR(20) PRIMARY KEY,
    MaxCP INTEGER
);

CREATE TABLE Battle(
    DateOccurred DATE,
    PlayerUsername1 CHAR(15),
    PlayerUsername2 CHAR(15),
    League CHAR(20),
    Time INTEGER NOT NULL,
    PRIMARY KEY (DateOccurred, PlayerUsername1, PlayerUsername2),
    FOREIGN KEY (PlayerUsername1)
        REFERENCES Player(Username)
        ON DELETE CASCADE,
   FOREIGN KEY (PlayerUsername2)
        REFERENCES Player(Username)
        ON DELETE CASCADE,
    FOREIGN KEY (League)
        REFERENCES LeagueMaxCP(League)
        ON DELETE CASCADE
);

CREATE TABLE PlayerCapturedPokemon(
    PlayerUsername CHAR(15),
    SpeciesID INTEGER,
    CapturedDate DATE NOT NULL,
    PRIMARY KEY (PlayerUsername, SpeciesID),
    FOREIGN KEY (PlayerUsername)
        REFERENCES Player(Username)
        ON DELETE CASCADE,
    FOREIGN KEY (SpeciesID)
        REFERENCES Pokemon(ID)
        ON DELETE CASCADE
);

CREATE TABLE PlayerCapturedEgg(
    PlayerUsername CHAR(15),
    SpeciesID INTEGER,
    CapturedDate DATE NOT NULL,
    PRIMARY KEY (PlayerUsername, SpeciesID),
    FOREIGN KEY (PlayerUsername)
        REFERENCES Player(Username)
        ON DELETE CASCADE,
    FOREIGN KEY (SpeciesID)
        REFERENCES Egg(ID)
        ON DELETE CASCADE
);


CREATE TABLE PlayerVisitedPokestop(
    PlayerUsername CHAR(15),
    PokestopCountry CHAR(50),
    PokestopPostalCode CHAR(10),
    PokestopName CHAR(50),
    VisitedDate DATE NOT NULL,
    PRIMARY KEY (PlayerUsername, PokestopCountry, PokestopPostalCode, PokestopName),
    FOREIGN KEY (PlayerUsername)
        REFERENCES Player(Username)
        ON DELETE CASCADE,
    FOREIGN KEY (PokestopCountry, PokestopPostalCode, PokestopName)
        REFERENCES Pokestop(Country, PostalCode, Name)
        ON DELETE CASCADE
);

CREATE TABLE NPCAppearedAtPokestop(
    NPCName CHAR(20),
    PokestopCountry CHAR(50),
    PokestopPostalCode CHAR(10),
    PokestopName CHAR(50),
    PRIMARY KEY (NPCName, PokestopCountry, PokestopPostalCode, PokestopName),
    FOREIGN KEY (NPCName)
        REFERENCES NPC(Name)
        ON DELETE CASCADE,
    FOREIGN KEY (PokestopCountry, PokestopPostalCode, PokestopName)
        REFERENCES Pokestop(Country, PostalCode, Name)
        ON DELETE CASCADE
);

CREATE TABLE NPCSightingEventName(
    EventName CHAR(50) PRIMARY KEY,
    XP INTEGER NOT NULL,
    Duration INTEGER
);

CREATE TABLE NPCSighting(
    NPCName CHAR(20),
    PokestopCountry CHAR(50),
    PokestopPostalCode CHAR(10),
    PokestopName CHAR(50),
    SightingDate DATE,
    EventName CHAR(50),
    PRIMARY KEY (NPCName, PokestopCountry, PokestopPostalCode, PokestopName, SightingDate),
    FOREIGN KEY (NPCName, PokestopCountry, PokestopPostalCode, PokestopName)
        REFERENCES NPCAppearedAtPokestop(NPCName, PokestopCountry, PokestopPostalCode, PokestopName)
        ON DELETE CASCADE,
    FOREIGN KEY (EventName)
        REFERENCES NPCSightingEventName(EventName)
        ON DELETE CASCADE
);

-- Populate Tables with data

INSERT ALL
 INTO MascotColour(Mascot, Colour) VALUES ('Moltres', 'Red')
 INTO MascotColour(Mascot, Colour) VALUES ('Articuno', 'Blue')
 INTO MascotColour(Mascot, Colour) VALUES ('Zapdos', 'Yellow')
 INTO MascotColour(Mascot, Colour) VALUES ('Kyogre', 'Sapphire')
 INTO MascotColour(Mascot, Colour) VALUES ('Groudon', 'Crimson')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO Team(Name, Mascot) VALUES ('Valor', 'Moltres')
 INTO Team(Name, Mascot) VALUES ('Mystic', 'Articuno')
 INTO Team(Name, Mascot) VALUES ('Instinct', 'Zapdos')
 INTO Team(Name, Mascot) VALUES ('Aqua', 'Kyogre')
 INTO Team(Name, Mascot) VALUES ('Magma', 'Groudon')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO PlayerXPLevel(XP, PlayerLevel) VALUES (6000, 6)
 INTO PlayerXPLevel(XP, PlayerLevel) VALUES (30000, 30)
 INTO PlayerXPLevel(XP, PlayerLevel) VALUES (40000, 40)
 INTO PlayerXPLevel(XP, PlayerLevel) VALUES (304, 1)
 INTO PlayerXPLevel(XP, PlayerLevel) VALUES (404, 1)
SELECT 1 FROM DUAL;

INSERT ALL
 INTO Player(Username, XP, TeamName) VALUES ('Steph4n', 6000, 'Valor')
 INTO Player(Username, XP, TeamName) VALUES ('J@son', 30000, 'Mystic')
 INTO Player(Username, XP, TeamName) VALUES ('B0b', 40000, 'Instinct')
 INTO Player(Username, XP, TeamName) VALUES ('Greg0r', 40000, 'Instinct')
 INTO Player(Username, XP, TeamName) VALUES ('N0rm', 40000, 'Mystic')
 INTO Player(Username, XP, TeamName) VALUES ('Go4t', 6000, 'Valor')
 INTO Player(Username, XP, TeamName) VALUES ('J3ssica', 304, 'Aqua')
 INTO Player(Username, XP, TeamName) VALUES ('R4ch3l', 404, 'Magma')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO ItemTypeUses(Type, Uses) VALUES ('Ball', 20)
 INTO ItemTypeUses(Type, Uses) VALUES ('Buff', 1)
 INTO ItemTypeUses(Type, Uses) VALUES ('Egg Incubator', 5)
 INTO ItemTypeUses(Type, Uses) VALUES ('Raid Items', 1)
 INTO ItemTypeUses(Type, Uses) VALUES ('Lure', 1)
SELECT 1 FROM DUAL;

INSERT ALL
 INTO ItemEffectType(Effect, Type) VALUES ('Catches Pokemon', 'Ball')
 INTO ItemEffectType(Effect, Type) VALUES ('Attracts Pokemon', 'Buff')
 INTO ItemEffectType(Effect, Type) VALUES ('Hatches Eggs', 'Egg Incubator')
 INTO ItemEffectType(Effect, Type) VALUES ('Raid Entry Ticket', 'Raid Items')
 INTO ItemEffectType(Effect, Type) VALUES ('Lures Pokemon', 'Lure')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO Item(Name, Cost, Effect) VALUES ('PokeBall', 100, 'Catches Pokemon')
 INTO Item(Name, Cost, Effect) VALUES ('Incense', 40, 'Attracts Pokemon')
 INTO Item(Name, Cost, Effect) VALUES ('Incubator', 150, 'Hatches Eggs')
 INTO Item(Name, Cost, Effect) VALUES ('Raid Pass', 100, 'Raid Entry Ticket')
 INTO Item(Name, Cost, Effect) VALUES ('Lure Module', 100, 'Lures Pokemon')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO MissionEventNameXP(EventName, XP) VALUES ('Default', 600)
 INTO MissionEventNameXP(EventName, XP) VALUES ('Halloween 2018', 1080)
 INTO MissionEventNameXP(EventName, XP) VALUES ('GO Fest 2023 Fascinating Facets', 2023)
 INTO MissionEventNameXP(EventName, XP) VALUES ('All-in-One', 5100)
 INTO MissionEventNameXP(EventName, XP) VALUES ('City Safari 2023', 2023)
SELECT 1 FROM DUAL;

INSERT ALL
 INTO Mission(Name, EventName) VALUES ('Catch 10 Pokemon', 'Default')
 INTO Mission(Name, EventName) VALUES ('A Spooky Message 2018', 'Halloween 2018')
 INTO Mission(Name, EventName) VALUES ('Go Fest 1st Part', 'GO Fest 2023 Fascinating Facets')
 INTO Mission(Name, EventName) VALUES ('All-in-One 151 1st Part', 'All-in-One')
 INTO Mission(Name, EventName) VALUES ('City Safari:Seoul 2023', 'City Safari 2023')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO BiomeAttackBonus(Biome, AttackBonus) VALUES ('Nature', 'Grass')
 INTO BiomeAttackBonus(Biome, AttackBonus) VALUES ('Water', 'Water')
 INTO BiomeAttackBonus(Biome, AttackBonus) VALUES ('Snow', 'Ice')
 INTO BiomeAttackBonus(Biome, AttackBonus) VALUES ('Toxic', 'Poison')
 INTO BiomeAttackBonus(Biome, AttackBonus) VALUES ('Mountain', 'Ground')
 INTO BiomeAttackBonus(Biome, AttackBonus) VALUES ('Enchanted', 'Fairy')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO Location(Country, PostalCode, Name, Biome) VALUES ('Canada', 'V6T 1Z4', 'UBC Science', 'Nature')
 INTO Location(Country, PostalCode, Name, Biome) VALUES ('Canada', 'K1A 0A6', 'House of Commons', 'Water')
 INTO Location(Country, PostalCode, Name, Biome) VALUES ('Canada', 'V0N 1B4', 'Blackcomb Guest Services', 'Snow')
 INTO Location(Country, PostalCode, Name, Biome) VALUES ('USA', 'NM 87111', 'White Residence', 'Toxic')
 INTO Location(Country, PostalCode, Name, Biome) VALUES ('France', '75001', 'Louvre Museum', 'Nature')
 INTO Location(Country, PostalCode, Name, Biome) VALUES ('Australia', '2000', 'Sydney Opera House', 'Water')
 INTO Location(Country, PostalCode, Name, Biome) VALUES ('Brazil', '71020-970', 'Christ the Redeemer', 'Mountain')
 INTO Location(Country, PostalCode, Name, Biome) VALUES ('Japan', '100-0001', 'Shibuya Crossing', 'Nature')
 INTO Location(Country, PostalCode, Name, Biome) VALUES ('UK', 'SW1A 1BQ', 'Buckingham Palace', 'Enchanted')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Canada', 'V6T 1Z4', 'UBC Science', 'ICICS Building', 'UBC')
 INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Canada', 'K1A 0A6', 'House of Commons', 'House of Commons CAN', 'Gov Of Canada')
 INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Canada', 'V0N 1B4', 'Blackcomb Guest Services', 'GuestServicesBlckcmb' ,'Whistler')
 INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('USA', 'NM 87111', 'White Residence', 'TheOneWhoKnocks', 'Heisenberg')
 INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Brazil', '71020-970', 'Christ the Redeemer', 'The Redeemer', 'Church')
 INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Japan', '100-0001', 'Shibuya Crossing', 'Shibuya', 'Shibuya')
 INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('UK', 'SW1A 1BQ', 'Buckingham Palace', 'BuckinghamPalace', 'Royal Family')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Canada', 'V6T 1Z4', 'UBC Science', 0, 'Starbucks')
 INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Canada', 'K1A 0A6', 'House of Commons', 7, 'Gov Of Canada')
 INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Canada', 'V0N 1B4', 'Blackcomb Guest Services', 7, 'Whistler')
 INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('USA', 'NM 87111', 'White Residence', 10, 'Heisenberg')
 INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('France', '75001', 'Louvre Museum', 8, 'Louvre Staff')
 INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Australia', '2000', 'Sydney Opera House', 9, 'Kangaroos')
 INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('UK', 'SW1A 1BQ', 'Buckingham Palace', 9, 'Royal Family')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO EggSpecies(SpeciesName, Type1, Type2, Distance) VALUES ('MagiKarp', 'Water', NULL, 2)
 INTO EggSpecies(SpeciesName, Type1, Type2, Distance) VALUES ('Machop', 'Fighting', NULL, 5)
 INTO EggSpecies(SpeciesName, Type1, Type2, Distance) VALUES ('Meowth', 'Normal', NULL, 7)
 INTO EggSpecies(SpeciesName, Type1, Type2, Distance) VALUES ('Deino', 'Dark', 'Dragon', 10)
 INTO EggSpecies(SpeciesName, Type1, Type2, Distance) VALUES ('Larvitar', 'Rock', 'Ground', 12)
SELECT 1 FROM DUAL;

INSERT ALL
 INTO Egg(ID, SpeciesName) VALUES (0001, 'MagiKarp')
 INTO Egg(ID, SpeciesName) VALUES (0002, 'Machop')
 INTO Egg(ID, SpeciesName) VALUES (0003, 'Meowth')
 INTO Egg(ID, SpeciesName) VALUES (0004, 'Deino')
 INTO Egg(ID, SpeciesName) VALUES (0005, 'Larvitar')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Slaking', 'Normal', NULL)
 INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Vaporeon', 'Water', NULL)
 INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Dialga', 'Steel', 'Dragon')
 INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Abomasnow', 'Grass', 'Ice')
 INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Regirock', 'Rock', NULL)
SELECT 1 FROM DUAL;

INSERT ALL
 INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Slaking', 3804, 218, 3)
 INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Vaporeon', 2616, 215, 2)
 INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Dialga', 2242, 131, 3)
 INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Abomasnow', 1803, 154, 2)
 INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Regirock', 1319, 105, 1)
SELECT 1 FROM DUAL;

INSERT ALL
 INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (0006, 'Slaking', 3804, 114, NULL, 'Canada', 'V6T 1Z4', 'UBC Science', TO_DATE('19-Oct-2023', 'DD-Mon-YY'), 'Canada', 'V0N 1B4', 'Blackcomb Guest Services')
 INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (0007, 'Vaporeon', 2616, 0, 'Squidward', NULL, NULL, NULL, NULL, 'Canada', 'V6T 1Z4', 'UBC Science')
 INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (0008, 'Dialga', 2242, 0, NULL, NULL, NULL, NULL, NULL, 'Canada', 'K1A 0A6', 'House of Commons')
 INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (0009, 'Abomasnow', 1803, 1, 'ObamaSnow', 'Canada', 'K1A 0A6','House of Commons', TO_DATE('11-Sep-2022', 'DD-Mon-YY'), 'Canada', 'K1A 0A6', 'House of Commons')
 INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (0010, 'Regirock', 1319, 3, 'Dwayne', 'Canada', 'V0N 1B4', 'Blackcomb Guest Services', TO_DATE('04-Nov-2023', 'DD-Mon-YY'), 'USA', 'NM 87111', 'White Residence')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO RoleCanBattle(Role, CanBattle) VALUES ('Team Leader', 0)
 INTO RoleCanBattle(Role, CanBattle) VALUES ('Professor', 0)
 INTO RoleCanBattle(Role, CanBattle) VALUES ('Team Rocket Leader', 1)
 INTO RoleCanBattle(Role, CanBattle) VALUES ('Team Rocket Grunt', 1)
 INTO RoleCanBattle(Role, CanBattle) VALUES ('Team Rocket Balloon', 1)
SELECT 1 FROM DUAL;

INSERT ALL
 INTO NPC(Name, Role) VALUES ('Cadela', 'Team Leader')
 INTO NPC(Name, Role) VALUES ('Professor Oak', 'Professor')
 INTO NPC(Name, Role) VALUES ('Arlo', 'Team Rocket Leader')
 INTO NPC(Name, Role) VALUES ('Male Grunt', 'Team Rocket Grunt')
 INTO NPC(Name, Role) VALUES ('Balloon Grunt', 'Team Rocket Balloon')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Steph4n', 'Lure Module', 1)
 INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('J@son', 'PokeBall', 20)
 INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('B0b', 'PokeBall', 10)
 INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('B0b', 'Lure Module', 5)
 INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Greg0r', 'PokeBall', 100)
 INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('N0rm', 'PokeBall', 420)
 INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Go4t', 'Lure Module', 23)
 INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('B0b', 'Raid Pass', 2)
SELECT 1 FROM DUAL;

INSERT ALL
 INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('B0b', 'Catch 10 Pokemon', TO_DATE('11-Sep-2018', 'DD-Mon-YY'))
 INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('B0b', 'All-in-One 151 1st Part', TO_DATE('20-Feb-2021', 'DD-Mon-YY'))
 INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('J@son', 'Catch 10 Pokemon', TO_DATE('01-Oct-2018', 'DD-Mon-YY'))
 INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Steph4n', 'Catch 10 Pokemon', TO_DATE('19-Oct-2023', 'DD-Mon-YY'))
 INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('J3ssica', 'Go Fest 1st Part', TO_DATE('22-Aug-2023', 'DD-Mon-YY'))
SELECT 1 FROM DUAL;

INSERT ALL
 INTO LeagueMaxCP(League, MaxCP) VALUES ('Great League', 1500)
 INTO LeagueMaxCP(League, MaxCP) VALUES ('Ultra League', 2500)
 INTO LeagueMaxCP(League, MaxCP) VALUES ('Master League', 9999)
 INTO LeagueMaxCP(League, MaxCP) VALUES ('Training', 1500)
 INTO LeagueMaxCP(League, MaxCP) VALUES ('Friendly', 2500)
SELECT 1 FROM DUAL;

INSERT ALL
 INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES (TO_DATE('19-Oct-2023', 'DD-Mon-YY'), 'B0b', 'J@son', 'Great League', 5)
 INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES (TO_DATE('18-Oct-2023', 'DD-Mon-YY'), 'B0b', 'J3ssica', 'Ultra League', 4)
 INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES (TO_DATE('18-Oct-2023', 'DD-Mon-YY'), 'J@son', 'Steph4n', 'Master League', 5)
 INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES (TO_DATE('05-Jan-2022', 'DD-Mon-YY'), 'J3ssica', 'R4ch3l', 'Training', 10)
 INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES (TO_DATE('05-Oct-2022', 'DD-Mon-YY'), 'N0rm', 'J3ssica', 'Ultra League', 3)
 INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES (TO_DATE('18-Jan-2023', 'DD-Mon-YY'), 'J@son', 'Greg0r', 'Master League', 1)
 INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES (TO_DATE('05-Jan-2021', 'DD-Mon-YY'), 'Go4t', 'R4ch3l', 'Training', 10)
 INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES (TO_DATE('10-May-2018', 'DD-Mon-YY'), 'B0b', 'J@son', 'Friendly', 1)
SELECT 1 FROM DUAL;

INSERT ALL
 INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('B0b', 0008, TO_DATE('23-Mar-2019', 'DD-Mon-YY'))
 INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('J@son', 0010, TO_DATE('04-Apr-2019', 'DD-Mon-YY'))
 INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Steph4n', 0007, TO_DATE('14-Nov-2021', 'DD-Mon-YY'))
 INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('J3ssica', 0009, TO_DATE('26-Feb-2019', 'DD-Mon-YY'))
 INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('R4ch3l',  0006, TO_DATE('18-Jun-2019', 'DD-Mon-YY'))
SELECT 1 FROM DUAL;

INSERT ALL
 INTO PlayerCapturedEgg(PlayerUsername, SpeciesID, CapturedDate) VALUES ('B0b', 0001, TO_DATE('23-Apr-2020', 'DD-Mon-YY'))
 INTO PlayerCapturedEgg(PlayerUsername, SpeciesID, CapturedDate) VALUES ('J@son', 0002, TO_DATE('05-May-2021', 'DD-Mon-YY'))
 INTO PlayerCapturedEgg(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Steph4n', 0003, TO_DATE('14-Dec-2021', 'DD-Mon-YY'))
 INTO PlayerCapturedEgg(PlayerUsername, SpeciesID, CapturedDate) VALUES ('N0rm', 0004, TO_DATE('21-Jan-2023', 'DD-Mon-YY'))
 INTO PlayerCapturedEgg(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Greg0r', 0005, TO_DATE('18-Aug-2022', 'DD-Mon-YY'))
SELECT 1 FROM DUAL;
 
INSERT ALL
 INTO PlayerVisitedPokestop(PlayerUsername, PokestopCountry, PokestopPostalCode, PokestopName, VisitedDate) VALUES ('B0b', 'USA', 'NM 87111', 'White Residence', TO_DATE('02-Dec-2022', 'DD-Mon-YY'))
 INTO PlayerVisitedPokestop(PlayerUsername, PokestopCountry, PokestopPostalCode, PokestopName, VisitedDate) VALUES ('J@son', 'USA', 'NM 87111', 'White Residence', TO_DATE('06-Sep-2023', 'DD-Mon-YY'))
 INTO PlayerVisitedPokestop(PlayerUsername, PokestopCountry, PokestopPostalCode, PokestopName, VisitedDate) VALUES ('Steph4n', 'Canada', 'K1A 0A6', 'House of Commons', TO_DATE('05-Apr-2020', 'DD-Mon-YY'))
 INTO PlayerVisitedPokestop(PlayerUsername, PokestopCountry, PokestopPostalCode, PokestopName, VisitedDate) VALUES ('J3ssica', 'Canada', 'V6T 1Z4', 'UBC Science', TO_DATE('19-Oct-2023', 'DD-Mon-YY'))
 INTO PlayerVisitedPokestop(PlayerUsername, PokestopCountry, PokestopPostalCode, PokestopName, VisitedDate) VALUES ('R4ch3l', 'UK', 'SW1A 1BQ', 'Buckingham Palace', TO_DATE('01-Jan-2019', 'DD-Mon-YY'))
SELECT 1 FROM DUAL;

INSERT ALL
 INTO NPCAppearedAtPokestop(NPCName, PokestopCountry, PokestopPostalCode, PokestopName) VALUES ('Male Grunt', 'Canada', 'V6T 1Z4', 'UBC Science')
 INTO NPCAppearedAtPokestop(NPCName, PokestopCountry, PokestopPostalCode, PokestopName) VALUES ('Male Grunt', 'Canada', 'K1A 0A6', 'House of Commons')
 INTO NPCAppearedAtPokestop(NPCName, PokestopCountry, PokestopPostalCode, PokestopName) VALUES ('Arlo', 'Canada', 'V0N 1B4', 'Blackcomb Guest Services')
 INTO NPCAppearedAtPokestop(NPCName, PokestopCountry, PokestopPostalCode, PokestopName) VALUES ('Balloon Grunt', 'USA', 'NM 87111', 'White Residence')
 INTO NPCAppearedAtPokestop(NPCName, PokestopCountry, PokestopPostalCode, PokestopName) VALUES ('Professor Oak', 'UK', 'SW1A 1BQ', 'Buckingham Palace')
SELECT 1 FROM DUAL;

INSERT ALL
 INTO NPCSightingEventName(EventName, XP, Duration) VALUES ('Default', 100, 60)
 INTO NPCSightingEventName(EventName, XP, Duration) VALUES ('Halloween 2018', 1000, 48)
 INTO NPCSightingEventName(EventName, XP, Duration) VALUES ('Go Fest 2023 Fascinating Facets', 2023, 48)
 INTO NPCSightingEventName(EventName, XP, Duration) VALUES ('All-in-One 151', 250, 48)
 INTO NPCSightingEventName(EventName, XP, Duration) VALUES ('City Safari 2023', 2023, 48)
SELECT 1 FROM DUAL;

INSERT ALL
 INTO NPCSighting(NPCName, PokestopCountry, PokestopPostalCode, PokestopName, SightingDate, EventName) VALUES ('Male Grunt', 'Canada', 'V6T 1Z4', 'UBC Science', TO_DATE('11-Oct-2023', 'DD-Mon-YY'), 'Default')
 INTO NPCSighting(NPCName, PokestopCountry, PokestopPostalCode, PokestopName, SightingDate, EventName) VALUES ('Male Grunt', 'Canada', 'K1A 0A6', 'House of Commons', TO_DATE('30-Oct-2018', 'DD-Mon-YY'), 'Halloween 2018')
 INTO NPCSighting(NPCName, PokestopCountry, PokestopPostalCode, PokestopName, SightingDate, EventName) VALUES ('Arlo', 'Canada', 'V0N 1B4', 'Blackcomb Guest Services', TO_DATE('22-Jul-2023', 'DD-Mon-YY'), 'Go Fest 2023 Fascinating Facets')
 INTO NPCSighting(NPCName, PokestopCountry, PokestopPostalCode, PokestopName, SightingDate, EventName) VALUES ('Balloon Grunt', 'USA', 'NM 87111', 'White Residence', TO_DATE('20-Feb-2021', 'DD-Mon-YY'), 'All-in-One 151')
 INTO NPCSighting(NPCName, PokestopCountry, PokestopPostalCode, PokestopName, SightingDate, EventName) VALUES ('Professor Oak', 'UK', 'SW1A 1BQ', 'Buckingham Palace', TO_DATE('04-Nov-2023', 'DD-Mon-YY'), 'City Safari 2023')
SELECT 1 FROM DUAL;

INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Evolution Requiremen', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Pokeball', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Stardust Boost', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Food', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Revive', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Inventory Upgrade', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Battle', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Potion', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Raid Ticket', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Incubator', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Friend Gift Box', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Move Reroll', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Incense', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Camera', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Xp Boost', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Disk', 1);
INSERT INTO ItemTypeUses(Type, Uses) VALUES ('Candy', 1);
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Evolution Requirement', 'Evolution Requiremen');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Pokeball', 'Pokeball');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Stardust Boost', 'Stardust Boost');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Food', 'Food');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Revive', 'Revive');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Inventory Upgrade', 'Inventory Upgrade');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Battle', 'Battle');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Potion', 'Potion');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Raid Ticket', 'Raid Ticket');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Incubator', 'Incubator');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Friend Gift Box', 'Friend Gift Box');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Move Reroll', 'Move Reroll');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Incense', 'Incense');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Camera', 'Camera');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Xp Boost', 'Xp Boost');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Disk', 'Disk');
INSERT INTO ItemEffectType(Effect, Type) VALUES ('Candy', 'Candy');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Metal Coat', 100, 'Evolution Requirement');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Great Ball', 1000, 'Pokeball');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Kings Rock', 600, 'Evolution Requirement');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Star Piece', 800, 'Stardust Boost');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Pinap Berry', 1000, 'Food');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Max Revive', 600, 'Revive');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Item Storage Upgrade', 900, 'Inventory Upgrade');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Razz Berry', 800, 'Food');
INSERT INTO Item(Name, Cost, Effect) VALUES ('X Attack', 100, 'Battle');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Max Potion', 200, 'Potion');
INSERT INTO Item(Name, Cost, Effect) VALUES ('X Defense', 900, 'Battle');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Up Grade', 1000, 'Evolution Requirement');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Free Raid Ticket', 400, 'Raid Ticket');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Incubator Basic', 1000, 'Incubator');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Super Potion', 200, 'Potion');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Pokemon Storage Upgrade', 300, 'Inventory Upgrade');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Golden Razz Berry', 700, 'Food');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Sun Stone', 600, 'Evolution Requirement');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Dragon Scale', 900, 'Evolution Requirement');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Ultra Ball', 100, 'Pokeball');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Master Ball', 200, 'Pokeball');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Friend Gift Box', 100, 'Friend Gift Box');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Move Reroll Special Attack', 500, 'Move Reroll');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Wepar Berry', 800, 'Food');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Incense Beluga Box', 200, 'Incense');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Nanab Berry', 400, 'Food');
INSERT INTO Item(Name, Cost, Effect) VALUES ('X Miracle', 400, 'Battle');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Hyper Potion', 300, 'Potion');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Premier Ball', 500, 'Pokeball');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Paid Raid Ticket', 100, 'Raid Ticket');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Special Camera', 1000, 'Camera');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Lucky Egg', 200, 'Xp Boost');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Revive', 800, 'Revive');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Potion', 300, 'Potion');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Troy Disk', 1000, 'Disk');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Gen4 Evolution Stone', 900, 'Evolution Requirement');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Bluk Berry', 900, 'Food');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Incubator Super', 500, 'Incubator');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Golden Pinap Berry', 100, 'Food');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Move Reroll Fast Attack', 400, 'Move Reroll');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Poke Ball', 900, 'Pokeball');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Legendary Raid Ticket', 500, 'Raid Ticket');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Incubator Basic Unlimited', 200, 'Incubator');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Incense Ordinary', 800, 'Incense');
INSERT INTO Item(Name, Cost, Effect) VALUES ('Rare Candy', 300, 'Candy');
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (70281, 265);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (93187, 305);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (26971, 164);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (13264, 115);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (36693, 191);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (14143, 118);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (55499, 235);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (73688, 271);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (3933, 62);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (4393, 66);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (81450, 285);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (13059, 114);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (90577, 300);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (80505, 283);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (59611, 244);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (83303, 288);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (97324, 311);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (3320, 57);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (24540, 156);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (68932, 262);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (38099, 195);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (6424, 80);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (90540, 300);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (61292, 247);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (45657, 213);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (94085, 306);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (59650, 244);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (54499, 233);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (6213, 78);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (386, 19);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (12681, 112);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (92969, 304);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (26353, 162);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (56484, 237);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (39421, 198);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (80475, 283);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (12623, 112);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (2344, 48);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (75948, 275);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (12532, 111);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (56043, 236);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (13227, 115);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (85999, 293);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (18899, 137);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (45103, 212);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (27323, 165);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (31974, 178);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (76179, 276);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (25928, 161);
INSERT INTO PlayerXPLevel(XP, PlayerLevel) VALUES (85719, 292);
INSERT INTO Player(Username, XP, TeamName) VALUES ('Gillian.McDermo', 70281, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Vincenzo98', 93187, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Adella.Mraz', 26971, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Kattie_OKon18', 13264, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Edyth20', 36693, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Earl90', 14143, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Makayla67', 55499, 'Valor');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Stan_Fadel4', 73688, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Carlos14', 3933, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Flavie24', 4393, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Vivianne_Hegman', 81450, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Catherine46', 13059, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Elenora_Parisia', 90577, 'Valor');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Ron65', 80505, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Jerry29', 59611, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Tamara_Rau33', 83303, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Rosendo_Schultz', 97324, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Jamal7', 3320, 'Valor');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Elva.Mertz97', 24540, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Isac76', 68932, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Cristopher_Bart', 38099, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Sigurd.Welch27', 6424, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Hiram.Bergstrom', 90540, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Effie.Marks', 61292, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Markus6', 45657, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Dayne.Jenkins', 94085, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Gerard39', 59650, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Golden70', 54499, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Maye_Lynch', 6213, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Gunner.Herman', 386, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Berry_Simonis72', 12681, 'Valor');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Katlynn37', 92969, 'Valor');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Larue.Quitzon', 26353, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Susana.OReilly-', 56484, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Samara52', 39421, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Corene57', 80475, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Roselyn_Cronin', 12623, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Victoria.Pacoch', 2344, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Lonnie.Torp16', 75948, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Lizzie_Conn', 12532, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Christop96', 56043, 'Valor');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Flossie.Kub19', 13227, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Ruthie.Bode', 85999, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Andreanne.Mertz', 18899, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Kay.Tromp-Homen', 45103, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Bella.Stark', 27323, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Maudie.Stark51', 31974, 'Mystic');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Raheem.Emmerich', 76179, 'Valor');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Curtis.Smith', 25928, 'Instinct');
INSERT INTO Player(Username, XP, TeamName) VALUES ('Federico.Smitha', 85719, 'Valor');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Bosnia and Herzegovina', '90387', '18942 Crist Mill', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Anguilla', '34775-9673', '49437 Kathryne Track', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Uzbekistan', '73377-8929', '1395 Christopher Loaf', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Malawi', '49316-9658', '2486 Krystal Shoals', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Virgin Islands, U.S.', '74124', '7306 Cecilia Rapids', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Micronesia', '50883', '60860 Prosacco Trail', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Tonga', '94889-6656', '1019 Zieme Ville', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Bahrain', '49574', '899 Wolff Port', 'Mountain');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Botswana', '77678-0096', '1126 Huels Skyway', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Bulgaria', '22198', '8550 West Freeway', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Cape Verde', '27584-1550', '256 Bergnaum Wells', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Bahrain', '89178-6697', '7540 Lakin Fords', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Iraq', '00921', '7575 McClure Bridge', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Pakistan', '10344-1554', '236 Neha Key', 'Mountain');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Chile', '16376-3884', '510 Hilll Stravenue', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Mauritius', '70174-5423', '5273 Hintz Route', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Isle of Man', '62001-7965', '2734 Armstrong Mall', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Estonia', '50942', '908 Hilpert Stravenue', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Vanuatu', '40244', '2528 Luigi Turnpike', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Sudan', '15408', '74142 Streich Centers', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Oman', '45853', '9750 Terrance Spur', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Palestine', '36792-9885', '935 Keely Path', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('British Indian Ocean Territory (Chagos Archipelago', '85461', '5712 Mathias Run', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Kazakhstan', '54392-4681', '112 Kuvalis Summit', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Congo', '97692', '9717 Rasheed Valley', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Zambia', '27459', '5269 Stroman Drives', 'Mountain');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Andorra', '69573-0583', '2182 Gene Rest', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Belarus', '41257', '23577 Madge Ridges', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Macao', '23563-3886', '53917 Adriana Road', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Svalbard and Jan Mayen Islands', '29368-4708', '118 Yundt Skyway', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Pitcairn Islands', '16413-9328', '86004 Wade Lock', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Montenegro', '06370', '291 Shany Greens', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Turkey', '44809-0757', '4486 Franey Forge', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Singapore', '48037-6326', '3999 Muller Harbors', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Croatia', '77181', '929 Considine Valleys', 'Mountain');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Vietnam', '78306-0726', '600 Fiona Well', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Mongolia', '17976', '948 Leone Mountains', 'Mountain');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('New Caledonia', '55555-7465', '3360 Sadye Cliff', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Bonaire, Sint Eustatius and Saba', '01583-8324', '86644 Swaniawski Common', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Sint Maarten', '22794-3261', '783 Zulauf Dale', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Slovenia', '33934-4163', '772 Cruickshank Pines', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Honduras', '11178', '389 Weissnat Ridges', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('French Polynesia', '21683-8762', '812 Block Overpass', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Moldova', '79274', '187 Kyla Center', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Haiti', '18854', '88033 Carmella Flat', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Guatemala', '23149-1102', '872 Jaskolski Wells', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Uruguay', '39619', '9663 Mante Burg', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Netherlands', '28593-1879', '888 Shanon Streets', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Monaco', '76685', '31046 Trantow Common', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Falkland Islands (Malvinas)', '94609', '6695 Marilyne Villages', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Denmark', '58811', '9849 Hassan Crossing', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Brazil', '95637-7254', '4729 Pouros Courts', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Luxembourg', '66494', '52174 Gottlieb Greens', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Portugal', '83709', '605 Luettgen Union', 'Mountain');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Aruba', '48628-3197', '1937 Hagenes Well', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Trinidad and Tobago', '80014', '280 Madilyn Square', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Netherlands', '80483', '2754 Jeremy Ports', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Bolivia', '64168', '745 Heidenreich Knoll', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Heard Island and McDonald Islands', '21710', '72590 Gutmann Walks', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Syrian Arab Republic', '29369-4507', '303 Addison Hollow', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Mauritius', '43211-0406', '3960 Millie Parks', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Cote dIvoire', '47234', '866 Wiza Trace', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Nicaragua', '94402-6413', '9071 Stokes Rue', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Lesotho', '42497-6872', '659 McCullough Greens', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('United Arab Emirates', '19729', '71441 Gislason Glens', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Slovenia', '78168', '75547 Reina Knoll', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Norway', '13491-9537', '8177 Adrien Forges', 'Mountain');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Philippines', '28517-7388', '176 Elmer Underpass', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Seychelles', '74923-7030', '17701 Gene Points', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Cook Islands', '04525-0179', '620 Boehm Overpass', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Cambodia', '21642', '173 Emmerich Flat', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Slovakia', '34977-6374', '132 Dorthy Street', 'Mountain');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Jamaica', '45931-8982', '5060 Paige Grove', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('American Samoa', '04437-5145', '537 Wisozk Cape', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Saint Barthelemy', '82469-2908', '290 Estrella Greens', 'Snow');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Haiti', '11128-2859', '4897 Don Flat', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Malaysia', '70168', '6608 Altenwerth Courts', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Kyrgyz Republic', '75543-1932', '67516 Boehm Lakes', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Vanuatu', '77911', '91704 Hermiston Mission', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Palau', '36605-5921', '628 Wehner Oval', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('American Samoa', '98415', '846 Robel Crest', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Niue', '84131-8716', '2350 Giovani Rue', 'Mountain');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Trinidad and Tobago', '11593', '28581 George Roads', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Belize', '16635-1741', '1729 Kertzmann Unions', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Togo', '43711', '246 Aletha Lights', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Israel', '07244-6902', '427 Esta Field', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Somalia', '85332-2519', '796 Weissnat Extension', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Cocos (Keeling) Islands', '00559-1593', '4883 OHara Plains', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Saint Martin', '33825-1207', '43791 Adolph Centers', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Republic of Korea', '62484', '911 Molly Flats', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Fiji', '15458-6099', '694 Sunny Shores', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Yemen', '79936-4877', '82523 Kaylin Land', 'Water');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Moldova', '75983', '57013 Judge Knolls', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Turkmenistan', '49881', '3190 Hyatt Brooks', 'Mountain');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Isle of Man', '16638-0829', '555 Adriel Expressway', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Grenada', '93559', '93280 Wunsch Mountains', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Jersey', '12271', '9171 Gusikowski Burg', 'Nature');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Cayman Islands', '20862', '92866 Esta Views', 'Toxic');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('South Africa', '57106', '981 Adolph Glen', 'Enchanted');
INSERT INTO Location(Country, PostalCode, Name, Biome) VALUES ('Ecuador', '33777', '61213 Tromp Mount', 'Enchanted');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Anguilla', '34775-9673', '49437 Kathryne Track', 'New Mexico', 'New Mexico');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Malawi', '49316-9658', '2486 Krystal Shoals', 'Oregon', 'Oregon');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Micronesia', '50883', '60860 Prosacco Trail', 'Utah', 'Utah');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Tonga', '94889-6656', '1019 Zieme Ville', 'Arkansas', 'Arkansas');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Bahrain', '49574', '899 Wolff Port', 'Wyoming', 'Wyoming');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Cape Verde', '27584-1550', '256 Bergnaum Wells', 'Arizona', 'Arizona');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Bahrain', '89178-6697', '7540 Lakin Fords', 'Alaska', 'Alaska');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Oman', '45853', '9750 Terrance Spur', 'Tennessee', 'Tennessee');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Macao', '23563-3886', '53917 Adriana Road', 'Missouri', 'Missouri');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Montenegro', '06370', '291 Shany Greens', 'South Dakota', 'South Dakota');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Sint Maarten', '22794-3261', '783 Zulauf Dale', 'Georgia', 'Georgia');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Uruguay', '39619', '9663 Mante Burg', 'Nevada', 'Nevada');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Netherlands', '28593-1879', '888 Shanon Streets', 'Idaho', 'Idaho');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Falkland Islands (Malvinas)', '94609', '6695 Marilyne Villages', 'Nebraska', 'Nebraska');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Luxembourg', '66494', '52174 Gottlieb Greens', 'Connecticut', 'Connecticut');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Portugal', '83709', '605 Luettgen Union', 'Texas', 'Texas');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Netherlands', '80483', '2754 Jeremy Ports', 'Kentucky', 'Kentucky');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Mauritius', '43211-0406', '3960 Millie Parks', 'Indiana', 'Indiana');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Cote dIvoire', '47234', '866 Wiza Trace', 'New York', 'New York');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Nicaragua', '94402-6413', '9071 Stokes Rue', 'Virginia', 'Virginia');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Lesotho', '42497-6872', '659 McCullough Greens', 'New Hampshire', 'New Hampshire');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Slovakia', '34977-6374', '132 Dorthy Street', 'Alabama', 'Alabama');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Haiti', '11128-2859', '4897 Don Flat', 'Louisiana', 'Louisiana');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Vanuatu', '77911', '91704 Hermiston Mission', 'Florida', 'Florida');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Trinidad and Tobago', '11593', '28581 George Roads', 'North Carolina', 'North Carolina');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Cocos (Keeling) Islands', '00559-1593', '4883 OHara Plains', 'Minnesota', 'Minnesota');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Republic of Korea', '62484', '911 Molly Flats', 'Michigan', 'Michigan');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Fiji', '15458-6099', '694 Sunny Shores', 'West Virginia', 'West Virginia');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Grenada', '93559', '93280 Wunsch Mountains', 'New Jersey', 'New Jersey');
INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName) VALUES ('Jersey', '12271', '9171 Gusikowski Burg', 'Maine', 'Maine');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Bosnia and Herzegovina', '90387', '18942 Crist Mill', 5, 'Oregon');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Malawi', '49316-9658', '2486 Krystal Shoals', 5, 'Oregon');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Virgin Islands, U.S.', '74124', '7306 Cecilia Rapids', 1, 'Connecticut');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Tonga', '94889-6656', '1019 Zieme Ville', 2, 'Arkansas');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Bulgaria', '22198', '8550 West Freeway', 3, 'Colorado');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Cape Verde', '27584-1550', '256 Bergnaum Wells', 5, 'Arizona');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Bahrain', '89178-6697', '7540 Lakin Fords', 9, 'Alaska');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Iraq', '00921', '7575 McClure Bridge', 5, 'Louisiana');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Chile', '16376-3884', '510 Hilll Stravenue', 2, 'Alaska');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Mauritius', '70174-5423', '5273 Hintz Route', 7, 'Wisconsin');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Estonia', '50942', '908 Hilpert Stravenue', 8, 'Utah');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Palestine', '36792-9885', '935 Keely Path', 2, 'Kansas');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('British Indian Ocean Territory (Chagos Archipelago', '85461', '5712 Mathias Run', 9, 'Kentucky');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Kazakhstan', '54392-4681', '112 Kuvalis Summit', 5, 'Minnesota');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Andorra', '69573-0583', '2182 Gene Rest', 3, 'Connecticut');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Pitcairn Islands', '16413-9328', '86004 Wade Lock', 10, 'New Hampshire');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Montenegro', '06370', '291 Shany Greens', 6, 'South Dakota');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Vietnam', '78306-0726', '600 Fiona Well', 3, 'South Dakota');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Mongolia', '17976', '948 Leone Mountains', 9, 'New Mexico');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Bonaire, Sint Eustatius and Saba', '01583-8324', '86644 Swaniawski Common', 10, 'Iowa');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Sint Maarten', '22794-3261', '783 Zulauf Dale', 6, 'Georgia');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Moldova', '79274', '187 Kyla Center', 10, 'New York');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Guatemala', '23149-1102', '872 Jaskolski Wells', 5, 'South Dakota');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Monaco', '76685', '31046 Trantow Common', 4, 'Oregon');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Denmark', '58811', '9849 Hassan Crossing', 7, 'Alaska');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Brazil', '95637-7254', '4729 Pouros Courts', 1, 'Arkansas');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Aruba', '48628-3197', '1937 Hagenes Well', 1, 'Minnesota');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Trinidad and Tobago', '80014', '280 Madilyn Square', 10, 'North Carolina');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Netherlands', '80483', '2754 Jeremy Ports', 4, 'Kentucky');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Bolivia', '64168', '745 Heidenreich Knoll', 8, 'Minnesota');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Syrian Arab Republic', '29369-4507', '303 Addison Hollow', 4, 'South Carolina');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Mauritius', '43211-0406', '3960 Millie Parks', 2, 'Indiana');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Nicaragua', '94402-6413', '9071 Stokes Rue', 5, 'Virginia');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Lesotho', '42497-6872', '659 McCullough Greens', 2, 'New Hampshire');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('United Arab Emirates', '19729', '71441 Gislason Glens', 10, 'Massachusetts');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Slovenia', '78168', '75547 Reina Knoll', 6, 'New Mexico');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Norway', '13491-9537', '8177 Adrien Forges', 9, 'Wyoming');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Philippines', '28517-7388', '176 Elmer Underpass', 2, 'Missouri');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Seychelles', '74923-7030', '17701 Gene Points', 3, 'Tennessee');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Slovakia', '34977-6374', '132 Dorthy Street', 5, 'Alabama');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Malaysia', '70168', '6608 Altenwerth Courts', 9, 'Michigan');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Kyrgyz Republic', '75543-1932', '67516 Boehm Lakes', 1, 'Idaho');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('American Samoa', '98415', '846 Robel Crest', 2, 'Vermont');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Trinidad and Tobago', '11593', '28581 George Roads', 7, 'North Carolina');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Belize', '16635-1741', '1729 Kertzmann Unions', 3, 'Connecticut');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Israel', '07244-6902', '427 Esta Field', 7, 'Rhode Island');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Somalia', '85332-2519', '796 Weissnat Extension', 3, 'Alaska');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Cocos (Keeling) Islands', '00559-1593', '4883 OHara Plains', 3, 'Minnesota');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Saint Martin', '33825-1207', '43791 Adolph Centers', 5, 'Kansas');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Fiji', '15458-6099', '694 Sunny Shores', 6, 'West Virginia');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Yemen', '79936-4877', '82523 Kaylin Land', 4, 'Nebraska');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Turkmenistan', '49881', '3190 Hyatt Brooks', 2, 'Wyoming');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Isle of Man', '16638-0829', '555 Adriel Expressway', 7, 'Texas');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Grenada', '93559', '93280 Wunsch Mountains', 3, 'New Jersey');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Jersey', '12271', '9171 Gusikowski Burg', 4, 'Maine');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Cayman Islands', '20862', '92866 Esta Views', 3, 'New York');
INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName) VALUES ('Ecuador', '33777', '61213 Tromp Mount', 10, 'Michigan');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Gastrodon East Sea', 'Water', 'Ground');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Shellos East Sea', 'Water', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Nidoran', 'Poison', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Persian', 'Normal', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Ralts', 'Psychic', 'Fairy');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Weepinbell', 'Grass', 'Poison');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Venonat', 'Bug', 'Poison');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Arceus Dark', 'Dark', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Smoochum', 'Ice', 'Psychic');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Dodrio', 'Normal', 'Flying');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Magnemite', 'Electric', 'Steel');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Trapinch', 'Ground', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Mamoswine', 'Ice', 'Ground');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Lotad', 'Water', 'Grass');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Togepi', 'Fairy', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Clefairy', 'Fairy', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Treecko', 'Grass', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Sneasel', 'Dark', 'Ice');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Sableye', 'Dark', 'Ghost');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Ursaring', 'Normal', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Shaymin Land', 'Grass', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Chimchar', 'Fire', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Sandshrew Alola', 'Ice', 'Steel');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Deoxys Defense', 'Psychic', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Quilava', 'Fire', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Dusclops', 'Ghost', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Azelf', 'Psychic', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Drowzee', 'Psychic', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Lombre', 'Water', 'Grass');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Golduck', 'Water', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Marill', 'Water', 'Fairy');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Sceptile', 'Grass', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Typhlosion', 'Fire', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Banette', 'Ghost', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Tentacruel', 'Water', 'Poison');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Gulpin', 'Poison', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Paras', 'Bug', 'Grass');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Tangrowth', 'Grass', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Giratina', 'Ghost', 'Dragon');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Totodile', 'Water', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Kingler', 'Water', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Torkoal', 'Fire', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Hitmontop', 'Fighting', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Magikarp', 'Water', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Jigglypuff', 'Normal', 'Fairy');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Cacturne', 'Grass', 'Dark');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Tauros', 'Normal', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Lairon', 'Steel', 'Rock');
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Turtwig', 'Grass', NULL);
INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2) VALUES ('Zubat', 'Poison', 'Flying');
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Gastrodon East Sea', 249, 24, 2);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Shellos East Sea', 7972, 797, 79);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Shellos East Sea', 5241, 524, 52);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Shellos East Sea', 2504, 250, 25);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Shellos East Sea', 3850, 385, 38);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Shellos East Sea', 7469, 746, 74);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Shellos East Sea', 2777, 277, 27);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Shellos East Sea', 3167, 316, 31);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Shellos East Sea', 564, 56, 5);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Shellos East Sea', 3448, 344, 34);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Nidoran', 1352, 135, 13);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Nidoran', 7454, 745, 74);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Persian', 1721, 172, 17);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Persian', 2531, 253, 25);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Persian', 1880, 188, 18);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Persian', 5213, 521, 52);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Persian', 322, 32, 3);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Persian', 7450, 745, 74);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Persian', 2194, 219, 21);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Persian', 3883, 388, 38);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Persian', 1761, 176, 17);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Persian', 6617, 661, 66);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Ralts', 5139, 513, 51);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Ralts', 1221, 122, 12);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Weepinbell', 1207, 120, 12);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Weepinbell', 2870, 287, 28);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Venonat', 6528, 652, 65);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Venonat', 4755, 475, 47);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Venonat', 1005, 100, 10);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Venonat', 2092, 209, 20);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Arceus Dark', 5059, 505, 50);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Arceus Dark', 4080, 408, 40);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Arceus Dark', 3984, 398, 39);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Arceus Dark', 5280, 528, 52);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Arceus Dark', 6888, 688, 68);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Arceus Dark', 953, 95, 9);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Arceus Dark', 7631, 763, 76);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Arceus Dark', 773, 77, 7);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Arceus Dark', 3235, 323, 32);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Smoochum', 3521, 352, 35);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Smoochum', 5450, 545, 54);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Smoochum', 5830, 583, 58);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Smoochum', 3197, 319, 31);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Smoochum', 7830, 783, 78);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Dodrio', 6578, 657, 65);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Dodrio', 358, 35, 3);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Dodrio', 3896, 389, 38);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Dodrio', 915, 91, 9);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Dodrio', 316, 31, 3);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Dodrio', 5668, 566, 56);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Dodrio', 3426, 342, 34);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Dodrio', 726, 72, 7);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Dodrio', 6253, 625, 62);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Magnemite', 3787, 378, 37);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Magnemite', 1631, 163, 16);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Trapinch', 7976, 797, 79);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Trapinch', 5198, 519, 51);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Mamoswine', 3381, 338, 33);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Mamoswine', 2952, 295, 29);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Mamoswine', 2983, 298, 29);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Mamoswine', 63, 6, 1);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Mamoswine', 343, 34, 3);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lotad', 4273, 427, 42);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Togepi', 349, 34, 3);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Togepi', 583, 58, 5);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Togepi', 481, 48, 4);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Clefairy', 82, 8, 1);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Clefairy', 2665, 266, 26);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Clefairy', 6899, 689, 68);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Clefairy', 4069, 406, 40);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Clefairy', 5126, 512, 51);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Treecko', 7804, 780, 78);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Treecko', 3537, 353, 35);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Treecko', 962, 96, 9);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Treecko', 4088, 408, 40);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Treecko', 6931, 693, 69);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sneasel', 1944, 194, 19);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sneasel', 1083, 108, 10);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sneasel', 789, 78, 7);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sneasel', 7625, 762, 76);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sneasel', 6312, 631, 63);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sneasel', 1597, 159, 15);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sneasel', 3791, 379, 37);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sableye', 6648, 664, 66);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sableye', 1111, 111, 11);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sableye', 2707, 270, 27);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Ursaring', 5568, 556, 55);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Ursaring', 815, 81, 8);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Ursaring', 4629, 462, 46);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Shaymin Land', 5856, 585, 58);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Chimchar', 3967, 396, 39);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Chimchar', 7033, 703, 70);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Chimchar', 7199, 719, 71);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Chimchar', 7408, 740, 74);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Chimchar', 3975, 397, 39);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Chimchar', 7980, 798, 79);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sandshrew Alola', 5736, 573, 57);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sandshrew Alola', 1817, 181, 18);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Deoxys Defense', 6195, 619, 61);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Deoxys Defense', 162, 16, 1);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Deoxys Defense', 5476, 547, 54);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Deoxys Defense', 6626, 662, 66);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Deoxys Defense', 5771, 577, 57);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Quilava', 2951, 295, 29);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Quilava', 1830, 183, 18);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Quilava', 5136, 513, 51);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Quilava', 3823, 382, 38);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Quilava', 5113, 511, 51);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Quilava', 4775, 477, 47);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Quilava', 1243, 124, 12);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Quilava', 782, 78, 7);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Dusclops', 2620, 262, 26);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Azelf', 7175, 717, 71);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Azelf', 7412, 741, 74);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Azelf', 7292, 729, 72);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Azelf', 3009, 300, 30);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Azelf', 5862, 586, 58);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Drowzee', 901, 90, 9);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Drowzee', 1450, 145, 14);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Drowzee', 62, 6, 1);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Drowzee', 5833, 583, 58);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Drowzee', 3424, 342, 34);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Drowzee', 5285, 528, 52);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Drowzee', 6717, 671, 67);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Drowzee', 3128, 312, 31);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Drowzee', 4684, 468, 46);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lombre', 2091, 209, 20);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lombre', 3794, 379, 37);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lombre', 6375, 637, 63);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lombre', 1149, 114, 11);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lombre', 991, 99, 9);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lombre', 3844, 384, 38);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lombre', 5135, 513, 51);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Golduck', 7009, 700, 70);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Golduck', 6087, 608, 60);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Marill', 5703, 570, 57);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Marill', 4527, 452, 45);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Marill', 4762, 476, 47);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sceptile', 2467, 246, 24);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sceptile', 3655, 365, 36);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sceptile', 3436, 343, 34);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sceptile', 7952, 795, 79);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sceptile', 2356, 235, 23);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sceptile', 153, 15, 1);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sceptile', 7090, 709, 70);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sceptile', 4408, 440, 44);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sceptile', 2877, 287, 28);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Sceptile', 5388, 538, 53);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Typhlosion', 1992, 199, 19);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Typhlosion', 2325, 232, 23);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Typhlosion', 6906, 690, 69);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Typhlosion', 3588, 358, 35);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Typhlosion', 8000, 800, 80);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Typhlosion', 2334, 233, 23);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Banette', 3157, 315, 31);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tentacruel', 4051, 405, 40);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tentacruel', 6587, 658, 65);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tentacruel', 7131, 713, 71);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tentacruel', 5224, 522, 52);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tentacruel', 349, 34, 3);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tentacruel', 1299, 129, 12);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Gulpin', 1186, 118, 11);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Paras', 2388, 238, 23);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Paras', 1504, 150, 15);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Paras', 6191, 619, 61);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Paras', 1208, 120, 12);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Paras', 4003, 400, 40);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Paras', 3200, 320, 32);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tangrowth', 1534, 153, 15);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tangrowth', 4192, 419, 41);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tangrowth', 3867, 386, 38);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tangrowth', 36, 3, 1);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tangrowth', 1227, 122, 12);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tangrowth', 6671, 667, 66);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tangrowth', 2509, 250, 25);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tangrowth', 3420, 342, 34);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tangrowth', 3222, 322, 32);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Giratina', 77, 7, 1);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Giratina', 4573, 457, 45);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Giratina', 733, 73, 7);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Giratina', 5766, 576, 57);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Giratina', 1251, 125, 12);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Giratina', 2039, 203, 20);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Giratina', 2278, 227, 22);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Giratina', 827, 82, 8);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Giratina', 6790, 679, 67);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Giratina', 6479, 647, 64);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Totodile', 1607, 160, 16);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Totodile', 3300, 330, 33);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Totodile', 6289, 628, 62);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Totodile', 6143, 614, 61);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Totodile', 6121, 612, 61);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Totodile', 1059, 105, 10);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Totodile', 3691, 369, 36);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Kingler', 6698, 669, 66);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Kingler', 3394, 339, 33);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Kingler', 6454, 645, 64);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Kingler', 4425, 442, 44);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Kingler', 3886, 388, 38);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Torkoal', 1653, 165, 16);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Torkoal', 3684, 368, 36);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Torkoal', 1127, 112, 11);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Torkoal', 6722, 672, 67);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Torkoal', 6832, 683, 68);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Torkoal', 5647, 564, 56);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Torkoal', 7506, 750, 75);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Torkoal', 7273, 727, 72);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Hitmontop', 2036, 203, 20);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Magikarp', 7140, 714, 71);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Magikarp', 3468, 346, 34);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Magikarp', 898, 89, 8);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Magikarp', 5694, 569, 56);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Magikarp', 5379, 537, 53);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Magikarp', 4762, 476, 47);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Magikarp', 1494, 149, 14);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Magikarp', 7816, 781, 78);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Magikarp', 7120, 712, 71);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Magikarp', 2431, 243, 24);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Jigglypuff', 884, 88, 8);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Jigglypuff', 1510, 151, 15);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Cacturne', 4941, 494, 49);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Cacturne', 3367, 336, 33);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Cacturne', 1592, 159, 15);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Cacturne', 5782, 578, 57);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Cacturne', 5542, 554, 55);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Cacturne', 5261, 526, 52);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Cacturne', 7118, 711, 71);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Cacturne', 4804, 480, 48);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Cacturne', 5483, 548, 54);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Cacturne', 5311, 531, 53);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tauros', 3379, 337, 33);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tauros', 3463, 346, 34);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tauros', 5785, 578, 57);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tauros', 2301, 230, 23);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tauros', 2880, 288, 28);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tauros', 3576, 357, 35);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tauros', 6909, 690, 69);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Tauros', 4368, 436, 43);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lairon', 7018, 701, 70);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lairon', 2389, 238, 23);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lairon', 1180, 118, 11);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lairon', 5702, 570, 57);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lairon', 7471, 747, 74);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Lairon', 2026, 202, 20);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Turtwig', 1485, 148, 14);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Turtwig', 1208, 120, 12);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Turtwig', 2833, 283, 28);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Turtwig', 5088, 508, 50);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Zubat', 1398, 139, 13);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Zubat', 7877, 787, 78);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Zubat', 3491, 349, 34);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Zubat', 4256, 425, 42);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Zubat', 3400, 340, 34);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Zubat', 7408, 740, 74);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Zubat', 5280, 528, 52);
INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack) VALUES ('Zubat', 5612, 561, 56);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (601, 'Gastrodon East Sea', 249, 14, NULL, NULL, NULL, NULL, NULL, 'Haiti', '18854', '88033 Carmella Flat');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (155, 'Shellos East Sea', 5241, 194, NULL, NULL, NULL, NULL, NULL, 'Bahrain', '89178-6697', '7540 Lakin Fords');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (505, 'Shellos East Sea', 2504, 536, 'Shellos E', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (978, 'Shellos East Sea', 7469, 915, NULL, 'Fiji', '15458-6099', '694 Sunny Shores', '10-Aug-16', 'Oman', '45853', '9750 Terrance Spur');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (452, 'Shellos East Sea', 2777, 92, NULL, 'Vanuatu', '77911', '91704 Hermiston Mission', '15-Sep-19', 'Slovenia', '78168', '75547 Reina Knoll');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (20, 'Shellos East Sea', 3167, 428, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (915, 'Shellos East Sea', 564, 221, 'Shello', 'Luxembourg', '66494', '52174 Gottlieb Greens', '19-Aug-23', 'Haiti', '18854', '88033 Carmella Flat');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (133, 'Nidoran', 1352, 164, '', 'Netherlands', '80483', '2754 Jeremy Ports', '27-Jun-23', 'Portugal', '83709', '605 Luettgen Union');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (752, 'Nidoran', 7454, 658, NULL, 'Sint Maarten', '22794-3261', '783 Zulauf Dale', '07-Nov-22', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (364, 'Persian', 1721, 101, NULL, 'Falkland Islands (Malvinas)', '94609', '6695 Marilyne Villages', '26-May-21', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (423, 'Persian', 2531, 779, NULL, 'Cape Verde', '27584-1550', '256 Bergnaum Wells', '18-Jun-20', 'New Caledonia', '55555-7465', '3360 Sadye Cliff');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (562, 'Persian', 1880, 327, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (661, 'Persian', 5213, 644, NULL, NULL, NULL, NULL, NULL, 'Lesotho', '42497-6872', '659 McCullough Greens');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (291, 'Persian', 322, 617, NULL, 'Tonga', '94889-6656', '1019 Zieme Ville', '13-Aug-18', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (214, 'Persian', 2194, 61, '', 'Grenada', '93559', '93280 Wunsch Mountains', '07-Jul-23', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (727, 'Persian', 3883, 208, NULL, NULL, NULL, NULL, NULL, 'Estonia', '50942', '908 Hilpert Stravenue');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (453, 'Persian', 1761, 246, 'P', 'Sint Maarten', '22794-3261', '783 Zulauf Dale', '28-Nov-21', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (317, 'Ralts', 5139, 764, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (81, 'Weepinbell', 2870, 699, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (584, 'Venonat', 4755, 257, '', NULL, NULL, NULL, NULL, 'United Arab Emirates', '19729', '71441 Gislason Glens');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (360, 'Venonat', 1005, 696, NULL, 'Cote dIvoire', '47234', '866 Wiza Trace', '12-Jun-16', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (536, 'Venonat', 2092, 353, NULL, 'Haiti', '11128-2859', '4897 Don Flat', '27-Nov-16', 'Anguilla', '34775-9673', '49437 Kathryne Track');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (466, 'Arceus Dark', 5059, 196, NULL, NULL, NULL, NULL, NULL, 'Haiti', '11128-2859', '4897 Don Flat');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (248, 'Arceus Dark', 3984, 453, 'Ar', NULL, NULL, NULL, NULL, 'Lesotho', '42497-6872', '659 McCullough Greens');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (881, 'Arceus Dark', 5280, 446, 'A', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (154, 'Arceus Dark', 6888, 871, NULL, 'Mauritius', '43211-0406', '3960 Millie Parks', '14-Dec-21', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (267, 'Arceus Dark', 953, 218, 'A', 'Micronesia', '50883', '60860 Prosacco Trail', '04-Jul-16', 'Israel', '07244-6902', '427 Esta Field');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (409, 'Arceus Dark', 7631, 710, '', 'Cocos (Keeling) Islands', '00559-1593', '4883 OHara Plains', '29-Sep-20', 'Congo', '97692', '9717 Rasheed Valley');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (450, 'Arceus Dark', 773, 882, 'Arc', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (210, 'Smoochum', 3521, 421, '', 'Fiji', '15458-6099', '694 Sunny Shores', '30-May-19', 'Monaco', '76685', '31046 Trantow Common');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (367, 'Smoochum', 5830, 805, 'S', 'Grenada', '93559', '93280 Wunsch Mountains', '14-Jun-22', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (530, 'Smoochum', 3197, 178, NULL, 'Haiti', '11128-2859', '4897 Don Flat', '19-Nov-17', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (747, 'Dodrio', 6578, 621, NULL, 'Lesotho', '42497-6872', '659 McCullough Greens', '03-Mar-21', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (520, 'Dodrio', 358, 780, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (73, 'Dodrio', 915, 999, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (762, 'Dodrio', 5668, 736, 'D', 'Haiti', '11128-2859', '4897 Don Flat', '05-Sep-20', 'Niue', '84131-8716', '2350 Giovani Rue');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (433, 'Dodrio', 3426, 633, NULL, 'Vanuatu', '77911', '91704 Hermiston Mission', '01-Nov-18', 'Isle of Man', '16638-0829', '555 Adriel Expressway');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (694, 'Dodrio', 726, 966, 'D', NULL, NULL, NULL, NULL, 'Fiji', '15458-6099', '694 Sunny Shores');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (173, 'Dodrio', 6253, 638, NULL, 'Bahrain', '89178-6697', '7540 Lakin Fords', '06-Jun-19', 'Slovakia', '34977-6374', '132 Dorthy Street');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (713, 'Magnemite', 3787, 619, NULL, NULL, NULL, NULL, NULL, 'Singapore', '48037-6326', '3999 Muller Harbors');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (984, 'Trapinch', 7976, 337, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (982, 'Trapinch', 5198, 775, NULL, NULL, NULL, NULL, NULL, 'Virgin Islands, U.S.', '74124', '7306 Cecilia Rapids');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (444, 'Mamoswine', 3381, 585, 'Mam', 'Portugal', '83709', '605 Luettgen Union', '25-Oct-23', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (603, 'Mamoswine', 2952, 819, NULL, 'Portugal', '83709', '605 Luettgen Union', '07-Dec-21', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (567, 'Mamoswine', 2983, 341, 'Ma', 'Vanuatu', '77911', '91704 Hermiston Mission', '12-Aug-20', 'Anguilla', '34775-9673', '49437 Kathryne Track');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (357, 'Mamoswine', 343, 45, 'Ma', NULL, NULL, NULL, NULL, 'Cocos (Keeling) Islands', '00559-1593', '4883 OHara Plains');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (457, 'Lotad', 4273, 140, '', 'Montenegro', '06370', '291 Shany Greens', '30-Jan-21', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (636, 'Togepi', 349, 548, 'T', NULL, NULL, NULL, NULL, 'Botswana', '77678-0096', '1126 Huels Skyway');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (922, 'Togepi', 583, 265, '', 'Cocos (Keeling) Islands', '00559-1593', '4883 OHara Plains', '23-Jul-17', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (872, 'Togepi', 481, 475, 'T', NULL, NULL, NULL, NULL, 'Cambodia', '21642', '173 Emmerich Flat');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (940, 'Clefairy', 82, 754, 'Cl', 'Fiji', '15458-6099', '694 Sunny Shores', '08-May-17', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (157, 'Clefairy', 2665, 366, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (141, 'Clefairy', 6899, 986, '', 'Micronesia', '50883', '60860 Prosacco Trail', '30-Jan-16', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (609, 'Clefairy', 4069, 84, '', 'Sint Maarten', '22794-3261', '783 Zulauf Dale', '11-Sep-17', 'Bulgaria', '22198', '8550 West Freeway');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (14, 'Treecko', 7804, 969, '', NULL, NULL, NULL, NULL, 'French Polynesia', '21683-8762', '812 Block Overpass');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (946, 'Treecko', 962, 368, NULL, NULL, NULL, NULL, NULL, 'Macao', '23563-3886', '53917 Adriana Road');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (961, 'Treecko', 4088, 706, 'T', 'Micronesia', '50883', '60860 Prosacco Trail', '06-Apr-22', 'Netherlands', '80483', '2754 Jeremy Ports');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (127, 'Treecko', 6931, 381, NULL, NULL, NULL, NULL, NULL, 'Cambodia', '21642', '173 Emmerich Flat');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (814, 'Sneasel', 1944, 191, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (110, 'Sneasel', 789, 767, 'S', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (757, 'Sneasel', 7625, 615, '', 'Micronesia', '50883', '60860 Prosacco Trail', '19-Oct-23', 'Netherlands', '80483', '2754 Jeremy Ports');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (458, 'Sneasel', 6312, 711, NULL, NULL, NULL, NULL, NULL, 'Fiji', '15458-6099', '694 Sunny Shores');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (442, 'Sneasel', 1597, 843, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (777, 'Sneasel', 3791, 180, 'S', 'Bahrain', '89178-6697', '7540 Lakin Fords', '09-Dec-22', 'Portugal', '83709', '605 Luettgen Union');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (690, 'Sableye', 1111, 402, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (789, 'Sableye', 2707, 327, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (924, 'Ursaring', 5568, 443, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (832, 'Ursaring', 815, 262, 'Ur', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (255, 'Ursaring', 4629, 218, NULL, NULL, NULL, NULL, NULL, 'Fiji', '15458-6099', '694 Sunny Shores');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (53, 'Shaymin Land', 5856, 151, 'Shay', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (932, 'Chimchar', 3967, 835, '', NULL, NULL, NULL, NULL, 'Pitcairn Islands', '16413-9328', '86004 Wade Lock');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (879, 'Chimchar', 7199, 105, 'Ch', 'Luxembourg', '66494', '52174 Gottlieb Greens', '22-Nov-18', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (705, 'Chimchar', 7408, 543, 'C', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (844, 'Chimchar', 3975, 520, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (882, 'Chimchar', 7980, 460, NULL, 'Montenegro', '06370', '291 Shany Greens', '04-Jul-16', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (1000, 'Sandshrew Alola', 5736, 64, 'Sand', NULL, NULL, NULL, NULL, 'Togo', '43711', '246 Aletha Lights');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (144, 'Sandshrew Alola', 1817, 994, 'Sandsh', 'Cote dIvoire', '47234', '866 Wiza Trace', '06-Oct-19', 'Trinidad and Tobago', '80014', '280 Madilyn Square');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (271, 'Deoxys Defense', 5476, 676, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (837, 'Deoxys Defense', 6626, 724, 'Deoxys', NULL, NULL, NULL, NULL, 'Turkmenistan', '49881', '3190 Hyatt Brooks');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (769, 'Deoxys Defense', 5771, 81, NULL, 'Tonga', '94889-6656', '1019 Zieme Ville', '10-Aug-23', 'Uzbekistan', '73377-8929', '1395 Christopher Loaf');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (326, 'Quilava', 1830, 832, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (131, 'Quilava', 3823, 655, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (586, 'Quilava', 5113, 747, '', 'Haiti', '11128-2859', '4897 Don Flat', '29-Oct-17', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (956, 'Quilava', 4775, 919, NULL, 'Grenada', '93559', '93280 Wunsch Mountains', '27-Jul-23', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (577, 'Quilava', 1243, 125, '', NULL, NULL, NULL, NULL, 'Bulgaria', '22198', '8550 West Freeway');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (756, 'Quilava', 782, 768, 'Q', NULL, NULL, NULL, NULL, 'British Indian Ocean Territory (Chagos Archipelago', '85461', '5712 Mathias Run');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (332, 'Azelf', 7175, 247, NULL, 'Jersey', '12271', '9171 Gusikowski Burg', '07-Jun-16', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (512, 'Azelf', 7412, 993, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (454, 'Azelf', 7292, 842, NULL, 'Jersey', '12271', '9171 Gusikowski Burg', '31-Jul-20', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (500, 'Azelf', 3009, 564, '', 'Haiti', '11128-2859', '4897 Don Flat', '24-Sep-23', 'Bolivia', '64168', '745 Heidenreich Knoll');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (628, 'Drowzee', 1450, 858, NULL, NULL, NULL, NULL, NULL, 'Oman', '45853', '9750 Terrance Spur');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (824, 'Drowzee', 62, 777, 'D', NULL, NULL, NULL, NULL, 'Moldova', '75983', '57013 Judge Knolls');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (435, 'Drowzee', 5833, 867, '', 'Cape Verde', '27584-1550', '256 Bergnaum Wells', '05-Aug-16', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (836, 'Drowzee', 3424, 637, 'D', 'Micronesia', '50883', '60860 Prosacco Trail', '16-Jun-22', 'Palestine', '36792-9885', '935 Keely Path');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (26, 'Drowzee', 6717, 938, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (183, 'Drowzee', 3128, 390, '', 'Portugal', '83709', '605 Luettgen Union', '05-Apr-19', 'Monaco', '76685', '31046 Trantow Common');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (765, 'Drowzee', 4684, 254, NULL, 'Cocos (Keeling) Islands', '00559-1593', '4883 OHara Plains', '11-Oct-21', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (85, 'Lombre', 2091, 652, 'L', 'Malawi', '49316-9658', '2486 Krystal Shoals', '16-Feb-21', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (511, 'Lombre', 3794, 656, NULL, 'Luxembourg', '66494', '52174 Gottlieb Greens', '14-Feb-22', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (825, 'Lombre', 6375, 886, 'L', NULL, NULL, NULL, NULL, 'Luxembourg', '66494', '52174 Gottlieb Greens');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (674, 'Lombre', 1149, 57, NULL, NULL, NULL, NULL, NULL, 'Uzbekistan', '73377-8929', '1395 Christopher Loaf');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (897, 'Lombre', 991, 290, 'L', 'Jersey', '12271', '9171 Gusikowski Burg', '09-Apr-23', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (198, 'Lombre', 3844, 836, NULL, 'Portugal', '83709', '605 Luettgen Union', '24-Oct-19', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (139, 'Golduck', 7009, 618, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (497, 'Golduck', 6087, 895, NULL, 'Luxembourg', '66494', '52174 Gottlieb Greens', '08-Mar-21', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (829, 'Marill', 5703, 285, NULL, NULL, NULL, NULL, NULL, 'Singapore', '48037-6326', '3999 Muller Harbors');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (281, 'Marill', 4527, 523, '', 'Sint Maarten', '22794-3261', '783 Zulauf Dale', '22-Feb-22', 'American Samoa', '98415', '846 Robel Crest');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (539, 'Marill', 4762, 359, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (664, 'Sceptile', 7952, 992, 'Sc', 'Portugal', '83709', '605 Luettgen Union', '08-Sep-22', 'Nicaragua', '94402-6413', '9071 Stokes Rue');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (865, 'Sceptile', 153, 56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (181, 'Sceptile', 7090, 692, NULL, NULL, NULL, NULL, NULL, 'Kyrgyz Republic', '75543-1932', '67516 Boehm Lakes');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (345, 'Sceptile', 4408, 647, 'S', NULL, NULL, NULL, NULL, 'Anguilla', '34775-9673', '49437 Kathryne Track');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (794, 'Sceptile', 2877, 322, 'S', 'Lesotho', '42497-6872', '659 McCullough Greens', '24-May-17', 'South Africa', '57106', '981 Adolph Glen');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (221, 'Sceptile', 5388, 86, NULL, 'Luxembourg', '66494', '52174 Gottlieb Greens', '20-Jun-19', 'Tonga', '94889-6656', '1019 Zieme Ville');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (283, 'Typhlosion', 1992, 361, '', 'Slovakia', '34977-6374', '132 Dorthy Street', '16-Jan-19', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (724, 'Typhlosion', 2325, 781, 'T', NULL, NULL, NULL, NULL, 'Iraq', '00921', '7575 McClure Bridge');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (658, 'Typhlosion', 3588, 864, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (90, 'Typhlosion', 8000, 218, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (971, 'Typhlosion', 2334, 883, 'Typ', NULL, NULL, NULL, NULL, 'Belarus', '41257', '23577 Madge Ridges');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (927, 'Banette', 3157, 114, NULL, 'Nicaragua', '94402-6413', '9071 Stokes Rue', '21-Apr-21', 'Belize', '16635-1741', '1729 Kertzmann Unions');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (867, 'Tentacruel', 4051, 208, 'Tent', 'Trinidad and Tobago', '11593', '28581 George Roads', '22-Feb-20', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (420, 'Tentacruel', 6587, 544, 'Ten', 'Netherlands', '80483', '2754 Jeremy Ports', '18-Jun-17', 'Anguilla', '34775-9673', '49437 Kathryne Track');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (566, 'Tentacruel', 7131, 799, 'Ten', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (223, 'Tentacruel', 349, 390, 'Tent', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (383, 'Gulpin', 1186, 43, '', 'Malawi', '49316-9658', '2486 Krystal Shoals', '29-Mar-17', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (802, 'Paras', 2388, 166, 'P', NULL, NULL, NULL, NULL, 'Haiti', '11128-2859', '4897 Don Flat');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (48, 'Paras', 1504, 494, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (25, 'Paras', 6191, 617, 'P', 'Fiji', '15458-6099', '694 Sunny Shores', '06-Sep-21', 'Montenegro', '06370', '291 Shany Greens');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (902, 'Paras', 1208, 989, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (760, 'Paras', 4003, 522, '', NULL, NULL, NULL, NULL, 'Honduras', '11178', '389 Weissnat Ridges');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (217, 'Paras', 3200, 509, NULL, NULL, NULL, NULL, NULL, 'American Samoa', '04437-5145', '537 Wisozk Cape');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (413, 'Tangrowth', 1534, 529, '', 'Republic of Korea', '62484', '911 Molly Flats', '13-Nov-20', 'Pakistan', '10344-1554', '236 Neha Key');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (42, 'Tangrowth', 4192, 264, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (509, 'Tangrowth', 3867, 653, NULL, 'Falkland Islands (Malvinas)', '94609', '6695 Marilyne Villages', '25-Aug-21', 'Bosnia and Herzegovina', '90387', '18942 Crist Mill');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (875, 'Tangrowth', 36, 498, NULL, NULL, NULL, NULL, NULL, 'Sudan', '15408', '74142 Streich Centers');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (693, 'Tangrowth', 1227, 11, NULL, 'Jersey', '12271', '9171 Gusikowski Burg', '09-Dec-18', 'Montenegro', '06370', '291 Shany Greens');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (682, 'Tangrowth', 6671, 525, NULL, NULL, NULL, NULL, NULL, 'Uzbekistan', '73377-8929', '1395 Christopher Loaf');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (382, 'Tangrowth', 2509, 368, NULL, 'Macao', '23563-3886', '53917 Adriana Road', '29-Dec-20', 'Syrian Arab Republic', '29369-4507', '303 Addison Hollow');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (100, 'Tangrowth', 3420, 552, NULL, NULL, NULL, NULL, NULL, 'Andorra', '69573-0583', '2182 Gene Rest');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (67, 'Tangrowth', 3222, 3, NULL, NULL, NULL, NULL, NULL, 'American Samoa', '04437-5145', '537 Wisozk Cape');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (474, 'Giratina', 77, 124, NULL, NULL, NULL, NULL, NULL, 'Chile', '16376-3884', '510 Hilll Stravenue');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (862, 'Giratina', 733, 931, 'Gi', NULL, NULL, NULL, NULL, 'Luxembourg', '66494', '52174 Gottlieb Greens');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (109, 'Giratina', 2039, 691, 'G', 'Cape Verde', '27584-1550', '256 Bergnaum Wells', '06-Jun-18', 'American Samoa', '98415', '846 Robel Crest');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (544, 'Giratina', 2278, 476, NULL, 'Mauritius', '43211-0406', '3960 Millie Parks', '09-Aug-21', 'Nicaragua', '94402-6413', '9071 Stokes Rue');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (786, 'Giratina', 6790, 78, NULL, 'Malawi', '49316-9658', '2486 Krystal Shoals', '10-Dec-17', 'Singapore', '48037-6326', '3999 Muller Harbors');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (823, 'Giratina', 6479, 364, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (414, 'Totodile', 1607, 133, 'T', NULL, NULL, NULL, NULL, 'Singapore', '48037-6326', '3999 Muller Harbors');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (282, 'Totodile', 3300, 981, NULL, 'Uruguay', '39619', '9663 Mante Burg', '20-Mar-17', 'Vanuatu', '77911', '91704 Hermiston Mission');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (629, 'Totodile', 6289, 869, NULL, NULL, NULL, NULL, NULL, 'Falkland Islands (Malvinas)', '94609', '6695 Marilyne Villages');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (263, 'Totodile', 6143, 317, NULL, NULL, NULL, NULL, NULL, 'Seychelles', '74923-7030', '17701 Gene Points');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (464, 'Totodile', 6121, 405, NULL, 'Malawi', '49316-9658', '2486 Krystal Shoals', '08-Dec-17', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (427, 'Totodile', 1059, 4, 'T', NULL, NULL, NULL, NULL, 'Netherlands', '28593-1879', '888 Shanon Streets');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (306, 'Totodile', 3691, 731, '', NULL, NULL, NULL, NULL, 'Mauritius', '43211-0406', '3960 Millie Parks');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (493, 'Kingler', 6698, 550, NULL, NULL, NULL, NULL, NULL, 'Uzbekistan', '73377-8929', '1395 Christopher Loaf');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (261, 'Kingler', 3394, 31, 'K', 'Sint Maarten', '22794-3261', '783 Zulauf Dale', '20-May-20', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (652, 'Kingler', 6454, 961, NULL, 'Grenada', '93559', '93280 Wunsch Mountains', '12-Nov-21', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (623, 'Kingler', 3886, 714, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (645, 'Torkoal', 3684, 158, NULL, NULL, NULL, NULL, NULL, 'Montenegro', '06370', '291 Shany Greens');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (816, 'Torkoal', 1127, 237, 'T', NULL, NULL, NULL, NULL, 'South Africa', '57106', '981 Adolph Glen');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (303, 'Torkoal', 6722, 39, 'T', 'Sint Maarten', '22794-3261', '783 Zulauf Dale', '31-Jan-17', 'Portugal', '83709', '605 Luettgen Union');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (292, 'Torkoal', 6832, 548, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (670, 'Torkoal', 5647, 46, 'T', NULL, NULL, NULL, NULL, 'Turkey', '44809-0757', '4486 Franey Forge');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (679, 'Torkoal', 7506, 42, '', 'Macao', '23563-3886', '53917 Adriana Road', '23-Apr-20', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (565, 'Hitmontop', 2036, 310, NULL, 'Republic of Korea', '62484', '911 Molly Flats', '02-Nov-22', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (699, 'Magikarp', 7140, 962, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (362, 'Magikarp', 3468, 316, NULL, 'Tonga', '94889-6656', '1019 Zieme Ville', '03-Nov-16', 'Malawi', '49316-9658', '2486 Krystal Shoals');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (712, 'Magikarp', 898, 271, NULL, NULL, NULL, NULL, NULL, 'Pitcairn Islands', '16413-9328', '86004 Wade Lock');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (558, 'Magikarp', 5694, 892, NULL, 'Micronesia', '50883', '60860 Prosacco Trail', '21-Apr-17', 'Bahrain', '89178-6697', '7540 Lakin Fords');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (77, 'Magikarp', 5379, 71, 'Ma', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (240, 'Magikarp', 4762, 862, 'M', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (854, 'Magikarp', 7816, 52, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (721, 'Magikarp', 7120, 905, NULL, NULL, NULL, NULL, NULL, 'Haiti', '18854', '88033 Carmella Flat');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (80, 'Magikarp', 2431, 588, 'M', NULL, NULL, NULL, NULL, 'United Arab Emirates', '19729', '71441 Gislason Glens');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (54, 'Jigglypuff', 884, 790, NULL, 'Slovakia', '34977-6374', '132 Dorthy Street', '26-Apr-22', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (675, 'Cacturne', 4941, 220, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (446, 'Cacturne', 3367, 324, 'C', 'Grenada', '93559', '93280 Wunsch Mountains', '15-Jun-22', 'Botswana', '77678-0096', '1126 Huels Skyway');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (766, 'Cacturne', 1592, 75, '', NULL, NULL, NULL, NULL, 'Saint Martin', '33825-1207', '43791 Adolph Centers');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (428, 'Cacturne', 5782, 578, NULL, 'Tonga', '94889-6656', '1019 Zieme Ville', '31-Mar-23', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (563, 'Cacturne', 5261, 880, NULL, 'Lesotho', '42497-6872', '659 McCullough Greens', '01-Jul-16', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (681, 'Cacturne', 7118, 237, '', NULL, NULL, NULL, NULL, 'Cook Islands', '04525-0179', '620 Boehm Overpass');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (926, 'Cacturne', 4804, 18, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (483, 'Cacturne', 5311, 578, 'Ca', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (963, 'Tauros', 3379, 469, 'T', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (677, 'Tauros', 3463, 943, NULL, NULL, NULL, NULL, NULL, 'Virgin Islands, U.S.', '74124', '7306 Cecilia Rapids');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (230, 'Tauros', 5785, 574, NULL, 'Vanuatu', '77911', '91704 Hermiston Mission', '26-Sep-23', 'Togo', '43711', '246 Aletha Lights');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (608, 'Tauros', 3576, 986, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (468, 'Tauros', 6909, 239, NULL, NULL, NULL, NULL, NULL, 'Turkey', '44809-0757', '4486 Franey Forge');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (723, 'Tauros', 4368, 608, 'T', NULL, NULL, NULL, NULL, 'Mauritius', '70174-5423', '5273 Hintz Route');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (448, 'Lairon', 7018, 317, 'L', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (403, 'Lairon', 2389, 196, '', 'Luxembourg', '66494', '52174 Gottlieb Greens', '17-Aug-17', 'Cocos (Keeling) Islands', '00559-1593', '4883 OHara Plains');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (296, 'Lairon', 1180, 330, NULL, 'Lesotho', '42497-6872', '659 McCullough Greens', '12-Sep-16', 'Uruguay', '39619', '9663 Mante Burg');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (107, 'Lairon', 5702, 101, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (820, 'Lairon', 7471, 354, 'L', 'Fiji', '15458-6099', '694 Sunny Shores', '17-Jul-19', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (573, 'Lairon', 2026, 621, NULL, 'Anguilla', '34775-9673', '49437 Kathryne Track', '12-Feb-21', 'French Polynesia', '21683-8762', '812 Block Overpass');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (685, 'Turtwig', 1208, 853, 'T', NULL, NULL, NULL, NULL, 'Ecuador', '33777', '61213 Tromp Mount');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (697, 'Turtwig', 2833, 275, 'T', NULL, NULL, NULL, NULL, 'Republic of Korea', '62484', '911 Molly Flats');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (279, 'Turtwig', 5088, 267, '', NULL, NULL, NULL, NULL, 'Yemen', '79936-4877', '82523 Kaylin Land');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (58, 'Zubat', 1398, 236, NULL, NULL, NULL, NULL, NULL, 'Cayman Islands', '20862', '92866 Esta Views');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (615, 'Zubat', 3491, 584, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (613, 'Zubat', 3400, 438, 'Z', 'Bahrain', '49574', '899 Wolff Port', '30-May-18', NULL, NULL, NULL);
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (907, 'Zubat', 7408, 553, NULL, 'Trinidad and Tobago', '11593', '28581 George Roads', '26-Oct-16', 'Botswana', '77678-0096', '1126 Huels Skyway');
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName) VALUES (714, 'Zubat', 5280, 69, '', 'Cape Verde', '27584-1550', '256 Bergnaum Wells', '11-Jul-17', NULL, NULL, NULL);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('25-May-20', 'Stan_Fadel4', 'Federico.Smitha', 'Ultra League', 6);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('14-Oct-23', 'Rosendo_Schultz', 'Markus6', 'Ultra League', 8);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('26-Dec-20', 'Golden70', 'Earl90', 'Master League', 6);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('06-Apr-20', 'Stan_Fadel4', 'Andreanne.Mertz', 'Master League', 8);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('03-Jan-18', 'Isac76', 'Elenora_Parisia', 'Great League', 1);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('27-Sep-16', 'Jerry29', 'Markus6', 'Master League', 7);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('10-Jan-18', 'Larue.Quitzon', 'Catherine46', 'Great League', 9);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('22-Jun-22', 'Berry_Simonis72', 'Sigurd.Welch27', 'Ultra League', 2);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('28-Mar-18', 'Andreanne.Mertz', 'Effie.Marks', 'Ultra League', 4);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('27-Apr-23', 'Christop96', 'Bella.Stark', 'Master League', 5);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('11-Oct-16', 'Dayne.Jenkins', 'Effie.Marks', 'Great League', 10);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('28-Jul-18', 'Corene57', 'Effie.Marks', 'Master League', 9);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('20-Nov-18', 'Gerard39', 'Vincenzo98', 'Master League', 4);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('22-Oct-22', 'Roselyn_Cronin', 'Berry_Simonis72', 'Great League', 1);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('28-Apr-21', 'Raheem.Emmerich', 'Stan_Fadel4', 'Great League', 10);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('17-Oct-19', 'Gunner.Herman', 'Earl90', 'Ultra League', 6);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('31-Jan-16', 'Roselyn_Cronin', 'Elva.Mertz97', 'Great League', 4);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('19-Mar-17', 'Effie.Marks', 'Victoria.Pacoch', 'Great League', 3);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('07-Oct-19', 'Edyth20', 'Larue.Quitzon', 'Great League', 5);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('11-Nov-21', 'Catherine46', 'Samara52', 'Ultra League', 9);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('08-Aug-21', 'Elenora_Parisia', 'Cristopher_Bart', 'Ultra League', 1);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('23-Nov-17', 'Susana.OReilly-', 'Ron65', 'Great League', 4);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('13-Sep-22', 'Vincenzo98', 'Kattie_OKon18', 'Master League', 4);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('30-May-21', 'Edyth20', 'Adella.Mraz', 'Great League', 3);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('01-Sep-22', 'Samara52', 'Vincenzo98', 'Master League', 2);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('30-Apr-17', 'Gerard39', 'Victoria.Pacoch', 'Master League', 8);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('21-Dec-22', 'Dayne.Jenkins', 'Lizzie_Conn', 'Master League', 9);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('15-Jun-22', 'Elva.Mertz97', 'Effie.Marks', 'Master League', 4);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('20-Aug-17', 'Gillian.McDermo', 'Berry_Simonis72', 'Master League', 9);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('10-Sep-17', 'Elenora_Parisia', 'Jerry29', 'Master League', 9);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('26-Apr-21', 'Stan_Fadel4', 'Lizzie_Conn', 'Great League', 5);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('19-Oct-18', 'Lizzie_Conn', 'Roselyn_Cronin', 'Great League', 4);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('24-Oct-19', 'Kay.Tromp-Homen', 'Jamal7', 'Master League', 7);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('01-Aug-16', 'Earl90', 'Flossie.Kub19', 'Master League', 5);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('10-Nov-18', 'Gunner.Herman', 'Jerry29', 'Ultra League', 8);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('08-Aug-20', 'Flavie24', 'Kay.Tromp-Homen', 'Ultra League', 9);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('30-Mar-22', 'Maye_Lynch', 'Isac76', 'Great League', 1);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('05-Jul-20', 'Ruthie.Bode', 'Gerard39', 'Ultra League', 1);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('11-Mar-23', 'Federico.Smitha', 'Vincenzo98', 'Ultra League', 6);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('12-Dec-21', 'Ruthie.Bode', 'Makayla67', 'Great League', 2);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('21-Oct-21', 'Stan_Fadel4', 'Lonnie.Torp16', 'Great League', 3);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('18-Dec-16', 'Corene57', 'Ruthie.Bode', 'Great League', 4);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('19-Jan-17', 'Catherine46', 'Larue.Quitzon', 'Ultra League', 3);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('18-Dec-21', 'Kattie_OKon18', 'Tamara_Rau33', 'Great League', 7);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('29-Sep-19', 'Gillian.McDermo', 'Ron65', 'Great League', 2);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('30-Nov-21', 'Rosendo_Schultz', 'Cristopher_Bart', 'Great League', 4);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('27-Feb-19', 'Ron65', 'Christop96', 'Great League', 9);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('11-Jan-17', 'Victoria.Pacoch', 'Andreanne.Mertz', 'Ultra League', 7);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('08-Oct-19', 'Jamal7', 'Christop96', 'Ultra League', 8);
INSERT INTO Battle(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time) VALUES ('25-Mar-21', 'Christop96', 'Ruthie.Bode', 'Great League', 7);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('December2019CommunityDayabonusfortheendofyear2020,', 100);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforApril2020CommunityDayfea', 600);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforMay2020CommunityDayfeatu', 1500);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('UnreleasedSpecialResearchforJune2020CommunityDayfe', 800);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforJuly2020CommunityDayfeat', 1300);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforAugust2020CommunityDayfe', 500);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforSeptember2020CommunityDa', 900);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforOctober2020CommunityDayf', 700);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforNovember2020CommunityDay', 1100);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforDecember2020CommunityDay', 100);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforJanuary2021CommunityDayf', 800);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforFebruary2021CommunityDay', 1400);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforMarch2021CommunityDayfea', 1200);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforApril2021CommunityDayfea', 200);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforMay2021CommunityDayfeatu', 1400);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforJune2021CommunityDayfeat', 200);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforJuly2021CommunityDayfeat', 800);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforAugust2021CommunityDayfe', 100);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforSeptember2021CommunityDa', 900);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforOctober2021CommunityDayf', 1500);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforNovember2021CommunityDay', 1300);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforDecember2021CommunityDay', 400);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforJanuary2022CommunityDayf', 200);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforCommunityDayClassic:Back', 1300);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforFebruary2022CommunityDay', 1100);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforMarch2022CommunityDayfea', 200);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforCommunityDayClassic:Memo', 1200);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforApril2022CommunityDayfea', 700);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforMay2022CommunityDayfeatu', 200);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforJune2022CommunityDayfeat', 300);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforJuly2022CommunityDayfeat', 900);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforAugust2022CommunityDayfe', 300);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforSeptember2022CommunityDa', 200);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforOctober2022CommunityDayf', 300);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforCommunityDayClassic:Drea', 300);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforNovember2022CommunityDay', 1400);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforDecember2022CommunityDay', 800);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforJanuary2023CommunityDayf', 1200);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforCommunityDayClassic:Loun', 900);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforFebruary2023CommunityDay', 800);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforMarch2023CommunityDayfea', 1500);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforApril2023CommunityDayfea', 700);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforApril2023CommunityDayCla', 1400);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforMay2023CommunityDayfeatu', 1000);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforJune2023CommunityDayfeat', 900);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforJuly2023CommunityDayClas', 300);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforJuly2023CommunityDayfeat', 1500);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforAugust2023CommunityDayfe', 1300);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforSeptember2023CommunityDa', 900);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforOctober2023CommunityDayf', 500);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('TicketedSpecialResearchforNovember2023CommunityDay', 1200);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('ResearchforTrainersreachinglevel43', 800);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('ResearchforTrainersreachinglevel45', 400);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('ResearchforTrainersreachinglevel48', 600);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('ResearchforTrainersreachinglevel50', 1300);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('Halloween2018and2019', 1500);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('Halloween2020', 800);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('Halloween2021', 1100);
INSERT INTO MissionEventNameXP(EventName, XP) VALUES ('Halloween2022', 1000);
INSERT INTO Mission(Name, EventName) VALUES ('Celebrate 2019', 'December2019CommunityDayabonusfortheendofyear2020,');
INSERT INTO Mission(Name, EventName) VALUES ('Investigating Illusions', 'TicketedSpecialResearchforApril2020CommunityDayfea');
INSERT INTO Mission(Name, EventName) VALUES ('Seeing Double', 'TicketedSpecialResearchforMay2020CommunityDayfeatu');
INSERT INTO Mission(Name, EventName) VALUES ('A Hairy Situation', 'UnreleasedSpecialResearchforJune2020CommunityDayfe');
INSERT INTO Mission(Name, EventName) VALUES ('The Great Gastly', 'TicketedSpecialResearchforJuly2020CommunityDayfeat');
INSERT INTO Mission(Name, EventName) VALUES ('Making a Splash', 'TicketedSpecialResearchforAugust2020CommunityDayfe');
INSERT INTO Mission(Name, EventName) VALUES ('Decoding Porygon', 'TicketedSpecialResearchforSeptember2020CommunityDa');
INSERT INTO Mission(Name, EventName) VALUES ('A Tale of Tails', 'TicketedSpecialResearchforOctober2020CommunityDayf');
INSERT INTO Mission(Name, EventName) VALUES ('Electric for Electabuzz', 'TicketedSpecialResearchforNovember2020CommunityDay');
INSERT INTO Mission(Name, EventName) VALUES ('No Match for Magmar', 'TicketedSpecialResearchforNovember2020CommunityDay');
INSERT INTO Mission(Name, EventName) VALUES ('December Community Day', 'TicketedSpecialResearchforDecember2020CommunityDay');
INSERT INTO Mission(Name, EventName) VALUES ('Straight to the Top Machop!', 'TicketedSpecialResearchforJanuary2021CommunityDayf');
INSERT INTO Mission(Name, EventName) VALUES ('Stop and Smell the Roselia', 'TicketedSpecialResearchforFebruary2021CommunityDay');
INSERT INTO Mission(Name, EventName) VALUES ('The Bravest Bird', 'TicketedSpecialResearchforMarch2021CommunityDayfea');
INSERT INTO Mission(Name, EventName) VALUES ('Snivy in the Sunshine', 'TicketedSpecialResearchforApril2021CommunityDayfea');
INSERT INTO Mission(Name, EventName) VALUES ('Cotton-Winged Bird', 'TicketedSpecialResearchforMay2021CommunityDayfeatu');
INSERT INTO Mission(Name, EventName) VALUES ('Just a Nibble', 'TicketedSpecialResearchforJune2021CommunityDayfeat');
INSERT INTO Mission(Name, EventName) VALUES ('Roasted Berries', 'TicketedSpecialResearchforJuly2021CommunityDayfeat');
INSERT INTO Mission(Name, EventName) VALUES ('What You Choose to Be', 'TicketedSpecialResearchforAugust2021CommunityDayfe');
INSERT INTO Mission(Name, EventName) VALUES ('From Scalchops to Seamitars', 'TicketedSpecialResearchforSeptember2021CommunityDa');
INSERT INTO Mission(Name, EventName) VALUES ('Nothin Dull About Duskull', 'TicketedSpecialResearchforOctober2021CommunityDayf');
INSERT INTO Mission(Name, EventName) VALUES ('Flash Spark, and Gleam', 'TicketedSpecialResearchforNovember2021CommunityDay');
INSERT INTO Mission(Name, EventName) VALUES ('December Community Day 2021', 'TicketedSpecialResearchforDecember2021CommunityDay');
INSERT INTO Mission(Name, EventName) VALUES ('The Spheal Deal', 'TicketedSpecialResearchforJanuary2022CommunityDayf');
INSERT INTO Mission(Name, EventName) VALUES ('Bulbasaur Community Day Classic', 'TicketedSpecialResearchforCommunityDayClassic:Back');
INSERT INTO Mission(Name, EventName) VALUES ('A Hop Skip, and Jump Away', 'TicketedSpecialResearchforFebruary2022CommunityDay');
INSERT INTO Mission(Name, EventName) VALUES ('Gritty and Glacial', 'TicketedSpecialResearchforMarch2022CommunityDayfea');
INSERT INTO Mission(Name, EventName) VALUES ('Mudkip Community Day Classic', 'TicketedSpecialResearchforCommunityDayClassic:Memo');
INSERT INTO Mission(Name, EventName) VALUES ('Strong Stuff', 'TicketedSpecialResearchforApril2022CommunityDayfea');
INSERT INTO Mission(Name, EventName) VALUES ('A Rocky Road', 'TicketedSpecialResearchforMay2022CommunityDayfeatu');
INSERT INTO Mission(Name, EventName) VALUES ('Field Notes: Deino', 'TicketedSpecialResearchforJune2022CommunityDayfeat');
INSERT INTO Mission(Name, EventName) VALUES ('Field Notes: Starly', 'TicketedSpecialResearchforJuly2022CommunityDayfeat');
INSERT INTO Mission(Name, EventName) VALUES ('Field Notes: Galarian Zigzagoon', 'TicketedSpecialResearchforAugust2022CommunityDayfe');
INSERT INTO Mission(Name, EventName) VALUES ('Rock n Roll', 'TicketedSpecialResearchforSeptember2022CommunityDa');
INSERT INTO Mission(Name, EventName) VALUES ('Field Notes: Trick of the Light', 'TicketedSpecialResearchforOctober2022CommunityDayf');
INSERT INTO Mission(Name, EventName) VALUES ('Dratini Community Day Classic', 'TicketedSpecialResearchforCommunityDayClassic:Drea');
INSERT INTO Mission(Name, EventName) VALUES ('Sweet Snacks', 'TicketedSpecialResearchforNovember2022CommunityDay');
INSERT INTO Mission(Name, EventName) VALUES ('December Community Day 2022', 'TicketedSpecialResearchforDecember2022CommunityDay');
INSERT INTO Mission(Name, EventName) VALUES ('Quality Quills', 'TicketedSpecialResearchforJanuary2023CommunityDayf');
INSERT INTO Mission(Name, EventName) VALUES ('Larvitar Community Day Classic', 'TicketedSpecialResearchforCommunityDayClassic:Loun');
INSERT INTO Mission(Name, EventName) VALUES ('Abundant Noise', 'TicketedSpecialResearchforFebruary2023CommunityDay');
INSERT INTO Mission(Name, EventName) VALUES ('Field Notes: Slow and Slower', 'TicketedSpecialResearchforMarch2023CommunityDayfea');
INSERT INTO Mission(Name, EventName) VALUES ('Spreading Cheer', 'TicketedSpecialResearchforApril2023CommunityDayfea');
INSERT INTO Mission(Name, EventName) VALUES ('Swinub Community Day Classic', 'TicketedSpecialResearchforApril2023CommunityDayCla');
INSERT INTO Mission(Name, EventName) VALUES ('Fur and Flames', 'TicketedSpecialResearchforMay2023CommunityDayfeatu');
INSERT INTO Mission(Name, EventName) VALUES ('Keeping Sharp', 'TicketedSpecialResearchforJune2023CommunityDayfeat');
INSERT INTO Mission(Name, EventName) VALUES ('Squirtle Community Day Classic', 'TicketedSpecialResearchforJuly2023CommunityDayClas');
INSERT INTO Mission(Name, EventName) VALUES ('Slippery Swirls', 'TicketedSpecialResearchforJuly2023CommunityDayfeat');
INSERT INTO Mission(Name, EventName) VALUES ('A Bubbly Disposition', 'TicketedSpecialResearchforAugust2023CommunityDayfe');
INSERT INTO Mission(Name, EventName) VALUES ('Community Day Classic: Charmander', 'TicketedSpecialResearchforSeptember2023CommunityDa');
INSERT INTO Mission(Name, EventName) VALUES ('Plugging Along', 'TicketedSpecialResearchforSeptember2023CommunityDa');
INSERT INTO Mission(Name, EventName) VALUES ('Muscle Memories', 'TicketedSpecialResearchforOctober2023CommunityDayf');
INSERT INTO Mission(Name, EventName) VALUES ('A Muddy Buddy', 'TicketedSpecialResearchforNovember2023CommunityDay');
INSERT INTO Mission(Name, EventName) VALUES ('Level 43 Challenge', 'ResearchforTrainersreachinglevel43');
INSERT INTO Mission(Name, EventName) VALUES ('Level 45 Challenge', 'ResearchforTrainersreachinglevel45');
INSERT INTO Mission(Name, EventName) VALUES ('Level 48 Challenge', 'ResearchforTrainersreachinglevel48');
INSERT INTO Mission(Name, EventName) VALUES ('Level 50 Challenge', 'ResearchforTrainersreachinglevel50');
INSERT INTO Mission(Name, EventName) VALUES ('A Spooky Message', 'Halloween2018and2019');
INSERT INTO Mission(Name, EventName) VALUES ('A Spooky Message Unmasked', 'Halloween2020');
INSERT INTO Mission(Name, EventName) VALUES ('What Lies beneath the Mask?', 'Halloween2021');
INSERT INTO Mission(Name, EventName) VALUES ('Mysterious Masks', 'Halloween2022');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Andreanne.Mertz', 'A Hairy Situation', '20-Feb-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Elenora_Parisia', 'A Bubbly Disposition', '03-Dec-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Victoria.Pacoch', 'A Spooky Message Unmasked', '25-Aug-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Federico.Smitha', 'Quality Quills', '09-Mar-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Golden70', 'Slippery Swirls', '04-Oct-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Jerry29', 'The Bravest Bird', '16-May-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Jerry29', 'Mysterious Masks', '04-Aug-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Bella.Stark', 'Just a Nibble', '22-May-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Curtis.Smith', 'Just a Nibble', '01-Oct-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Lizzie_Conn', 'Squirtle Community Day Classic', '15-May-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Raheem.Emmerich', 'The Spheal Deal', '07-Aug-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Andreanne.Mertz', 'Sweet Snacks', '06-May-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Adella.Mraz', 'Bulbasaur Community Day Classic', '19-May-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Edyth20', 'Just a Nibble', '21-Nov-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Flavie24', 'What Lies beneath the Mask?', '01-Oct-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Flavie24', 'Decoding Porygon', '28-Jan-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Gillian.McDermo', 'Investigating Illusions', '27-Aug-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Isac76', 'Electric for Electabuzz', '10-Nov-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Lonnie.Torp16', 'Bulbasaur Community Day Classic', '05-Jun-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Maye_Lynch', 'A Spooky Message', '08-Oct-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Kattie_OKon18', 'Stop and Smell the Roselia', '27-Nov-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Tamara_Rau33', 'The Great Gastly', '19-Mar-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Kay.Tromp-Homen', 'From Scalchops to Seamitars', '12-May-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Andreanne.Mertz', 'Muscle Memories', '21-Jan-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Isac76', 'From Scalchops to Seamitars', '20-Jan-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Sigurd.Welch27', 'Investigating Illusions', '24-Nov-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Susana.OReilly-', 'Quality Quills', '30-Dec-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Ruthie.Bode', 'What Lies beneath the Mask?', '03-Feb-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Adella.Mraz', 'Electric for Electabuzz', '02-Dec-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Lizzie_Conn', 'Quality Quills', '31-Dec-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Christop96', 'Field Notes: Starly', '21-Nov-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Katlynn37', 'Level 50 Challenge', '25-Jun-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Maye_Lynch', 'Flash Spark, and Gleam', '20-Apr-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Flavie24', 'A Rocky Road', '07-Mar-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Isac76', 'Mysterious Masks', '09-Oct-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Federico.Smitha', 'Snivy in the Sunshine', '12-Dec-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Lonnie.Torp16', 'Larvitar Community Day Classic', '15-Mar-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Rosendo_Schultz', 'Field Notes: Galarian Zigzagoon', '16-Jun-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Jamal7', 'Squirtle Community Day Classic', '20-Jun-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Ruthie.Bode', 'Nothin Dull About Duskull', '01-Aug-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Makayla67', 'Strong Stuff', '05-Jun-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Makayla67', 'A Rocky Road', '11-Aug-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Ron65', 'Squirtle Community Day Classic', '30-Jul-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Sigurd.Welch27', 'Straight to the Top Machop!', '26-Nov-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Ruthie.Bode', 'A Spooky Message', '04-Mar-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Flossie.Kub19', 'Seeing Double', '20-Jul-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Sigurd.Welch27', 'Spreading Cheer', '25-Aug-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Elva.Mertz97', 'Gritty and Glacial', '10-Jun-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Maudie.Stark51', 'Level 48 Challenge', '27-Sep-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Flavie24', 'Muscle Memories', '24-Dec-16');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Victoria.Pacoch', 14, '30-Mar-22');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Elenora_Parisia', 80, '29-Apr-18');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Andreanne.Mertz', 664, '07-Mar-21');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Kay.Tromp-Homen', 897, '10-Oct-21');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Golden70', 157, '26-Apr-21');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Effie.Marks', 409, '11-Feb-18');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Golden70', 223, '02-Dec-18');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Gillian.McDermo', 414, '31-Jan-20');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Makayla67', 881, '04-Jan-23');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Flavie24', 562, '23-Feb-19');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Gunner.Herman', 567, '10-Jul-17');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Effie.Marks', 915, '02-Nov-18');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Larue.Quitzon', 483, '18-Dec-21');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Carlos14', 777, '04-Feb-20');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Kay.Tromp-Homen', 283, '29-Dec-16');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Maudie.Stark51', 317, '05-Nov-16');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Carlos14', 454, '11-Feb-16');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Lizzie_Conn', 658, '03-Mar-16');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Lonnie.Torp16', 279, '18-Feb-22');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Katlynn37', 875, '06-Jan-18');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Jamal7', 423, '29-Nov-21');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Susana.OReilly-', 357, '08-Apr-22');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Earl90', 144, '28-May-20');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Berry_Simonis72', 267, '14-Feb-23');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Susana.OReilly-', 221, '24-Oct-23');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Flavie24', 613, '31-Jul-18');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Jerry29', 67, '22-Dec-18');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Andreanne.Mertz', 509, '21-Nov-22');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Curtis.Smith', 109, '22-Apr-23');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Elva.Mertz97', 248, '01-Dec-17');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Maye_Lynch', 963, '02-Mar-19');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Sigurd.Welch27', 762, '21-Jul-18');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Ruthie.Bode', 127, '17-Jun-17');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Roselyn_Cronin', 271, '04-Nov-19');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Makayla67', 802, '18-Apr-20');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Jerry29', 670, '01-Feb-21');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Markus6', 42, '12-Nov-20');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Jerry29', 214, '01-Dec-19');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Samara52', 766, '28-Dec-17');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Stan_Fadel4', 924, '10-Apr-21');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Andreanne.Mertz', 769, '14-Oct-17');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Curtis.Smith', 435, '27-May-23');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Maudie.Stark51', 566, '22-Sep-16');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Jamal7', 674, '19-Feb-21');
INSERT INTO PlayerCapturedPokemon(PlayerUsername, SpeciesID, CapturedDate) VALUES ('Rosendo_Schultz', 539, '25-Jun-21');
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Kattie_OKon18', 'Legendary Raid Ticket', 38);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Gillian.McDermo', 'Metal Coat', 93);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Adella.Mraz', 'X Attack', 90);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Susana.OReilly-', 'Premier Ball', 16);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Victoria.Pacoch', 'Ultra Ball', 83);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Vincenzo98', 'Great Ball', 73);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Gillian.McDermo', 'X Attack', 68);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Carlos14', 'Move Reroll Fast Attack', 36);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Jerry29', 'Special Camera', 69);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Jamal7', 'Incense Ordinary', 29);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Roselyn_Cronin', 'Legendary Raid Ticket', 49);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Raheem.Emmerich', 'Metal Coat', 70);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Effie.Marks', 'Legendary Raid Ticket', 51);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Maye_Lynch', 'Move Reroll Special Attack', 96);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Curtis.Smith', 'Incense Beluga Box', 46);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Curtis.Smith', 'Move Reroll Special Attack', 52);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Roselyn_Cronin', 'Sun Stone', 61);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Vivianne_Hegman', 'Paid Raid Ticket', 51);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Andreanne.Mertz', 'Golden Pinap Berry', 2);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Andreanne.Mertz', 'Master Ball', 83);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Vincenzo98', 'Wepar Berry', 40);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Rosendo_Schultz', 'Metal Coat', 85);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Andreanne.Mertz', 'Lucky Egg', 52);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Tamara_Rau33', 'Up Grade', 92);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Ruthie.Bode', 'Incubator Super', 73);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Catherine46', 'Gen4 Evolution Stone', 12);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Maudie.Stark51', 'Move Reroll Special Attack', 5);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Curtis.Smith', 'Ultra Ball', 32);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Tamara_Rau33', 'Troy Disk', 18);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Vivianne_Hegman', 'Max Potion', 100);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Lizzie_Conn', 'Revive', 12);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Ron65', 'Wepar Berry', 75);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Earl90', 'Poke Ball', 47);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Maudie.Stark51', 'Nanab Berry', 87);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Lonnie.Torp16', 'Legendary Raid Ticket', 81);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Roselyn_Cronin', 'Wepar Berry', 19);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Effie.Marks', 'Up Grade', 74);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Lizzie_Conn', 'Potion', 69);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Raheem.Emmerich', 'Incubator Super', 99);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Stan_Fadel4', 'Metal Coat', 6);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Effie.Marks', 'Ultra Ball', 46);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Jamal7', 'Lucky Egg', 73);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Corene57', 'Move Reroll Special Attack', 92);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Bella.Stark', 'Golden Razz Berry', 76);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Markus6', 'Wepar Berry', 15);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Ruthie.Bode', 'Paid Raid Ticket', 12);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Jerry29', 'Wepar Berry', 92);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Stan_Fadel4', 'Max Potion', 96);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Bella.Stark', 'Hyper Potion', 36);
INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity) VALUES ('Maudie.Stark51', 'Free Raid Ticket', 51);

INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Celebrate 2019', '02-Jul-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Celebrate 2019', '05-Sep-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Celebrate 2019', '07-May-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Investigating Illusions', '29-Apr-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Investigating Illusions', '07-Sep-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Investigating Illusions', '11-Nov-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Seeing Double', '16-Dec-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Seeing Double', '03-Jun-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Seeing Double', '03-Apr-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'A Hairy Situation', '24-May-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'A Hairy Situation', '24-Jul-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'A Hairy Situation', '10-Mar-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'The Great Gastly', '16-Nov-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'The Great Gastly', '26-Jul-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'The Great Gastly', '06-Nov-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Making a Splash', '04-Mar-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Making a Splash', '21-Aug-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Making a Splash', '21-Jul-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Decoding Porygon', '26-Jun-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Decoding Porygon', '08-May-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Decoding Porygon', '14-Apr-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'A Tale of Tails', '20-Jul-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'A Tale of Tails', '23-Aug-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'A Tale of Tails', '08-Jan-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Electric for Electabuzz', '12-Aug-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Electric for Electabuzz', '06-Aug-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Electric for Electabuzz', '25-Sep-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'No Match for Magmar', '07-Oct-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'No Match for Magmar', '28-Mar-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'No Match for Magmar', '26-Apr-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'December Community Day', '13-Jul-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'December Community Day', '21-Jul-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'December Community Day', '03-Jun-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Straight to the Top Machop!', '03-Jul-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Straight to the Top Machop!', '27-Jan-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Straight to the Top Machop!', '08-Apr-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Stop and Smell the Roselia', '11-Feb-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Stop and Smell the Roselia', '23-Jul-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Stop and Smell the Roselia', '05-Mar-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'The Bravest Bird', '29-Oct-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'The Bravest Bird', '03-Nov-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'The Bravest Bird', '18-Aug-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Snivy in the Sunshine', '07-Mar-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Snivy in the Sunshine', '26-Jul-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Snivy in the Sunshine', '10-Feb-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Cotton-Winged Bird', '19-Mar-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Cotton-Winged Bird', '20-May-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Cotton-Winged Bird', '18-Aug-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Just a Nibble', '29-Dec-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Just a Nibble', '19-May-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Just a Nibble', '20-Apr-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Roasted Berries', '06-Dec-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Roasted Berries', '01-Sep-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Roasted Berries', '29-Jan-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'What You Choose to Be', '12-Nov-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'What You Choose to Be', '17-Jul-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'What You Choose to Be', '21-Jun-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'From Scalchops to Seamitars', '03-Jan-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'From Scalchops to Seamitars', '03-Sep-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'From Scalchops to Seamitars', '21-Aug-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Nothin Dull About Duskull', '02-Jan-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Nothin Dull About Duskull', '09-Jan-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Nothin Dull About Duskull', '24-Mar-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Flash Spark, and Gleam', '24-Apr-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Flash Spark, and Gleam', '26-Sep-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Flash Spark, and Gleam', '11-Mar-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'December Community Day 2021', '19-Apr-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'December Community Day 2021', '23-Jun-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'December Community Day 2021', '03-Mar-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'The Spheal Deal', '25-Apr-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'The Spheal Deal', '16-Sep-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'The Spheal Deal', '12-Jul-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Bulbasaur Community Day Classic', '14-Nov-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Bulbasaur Community Day Classic', '28-Jul-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Bulbasaur Community Day Classic', '10-Apr-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'A Hop Skip, and Jump Away', '11-Jun-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'A Hop Skip, and Jump Away', '04-Apr-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'A Hop Skip, and Jump Away', '21-Apr-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Gritty and Glacial', '24-Dec-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Gritty and Glacial', '13-Aug-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Gritty and Glacial', '15-Mar-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Mudkip Community Day Classic', '08-Feb-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Mudkip Community Day Classic', '21-May-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Mudkip Community Day Classic', '22-Mar-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Strong Stuff', '08-Dec-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Strong Stuff', '25-Jul-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Strong Stuff', '26-Aug-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'A Rocky Road', '03-Jun-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'A Rocky Road', '24-May-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'A Rocky Road', '22-Dec-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Field Notes: Deino', '27-May-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Field Notes: Deino', '18-Jan-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Field Notes: Deino', '22-Apr-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Field Notes: Starly', '03-Jan-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Field Notes: Starly', '05-Dec-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Field Notes: Starly', '20-Apr-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Field Notes: Galarian Zigzagoon', '13-Apr-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Field Notes: Galarian Zigzagoon', '23-Jan-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Field Notes: Galarian Zigzagoon', '05-Oct-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Rock n Roll', '17-Oct-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Rock n Roll', '10-Jul-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Rock n Roll', '28-Feb-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Field Notes: Trick of the Light', '01-Oct-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Field Notes: Trick of the Light', '27-Mar-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Field Notes: Trick of the Light', '15-Sep-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Dratini Community Day Classic', '26-Mar-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Dratini Community Day Classic', '13-Sep-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Dratini Community Day Classic', '08-May-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Sweet Snacks', '01-May-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Sweet Snacks', '18-Sep-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Sweet Snacks', '05-Feb-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'December Community Day 2022', '08-May-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'December Community Day 2022', '03-Sep-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'December Community Day 2022', '25-Nov-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Quality Quills', '03-Jan-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Quality Quills', '05-May-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Quality Quills', '18-Jan-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Larvitar Community Day Classic', '29-Sep-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Larvitar Community Day Classic', '30-May-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Larvitar Community Day Classic', '19-Nov-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Abundant Noise', '30-Jul-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Abundant Noise', '06-Dec-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Abundant Noise', '19-Nov-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Field Notes: Slow and Slower', '01-Oct-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Field Notes: Slow and Slower', '31-Mar-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Field Notes: Slow and Slower', '23-Dec-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Spreading Cheer', '30-Aug-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Spreading Cheer', '01-Mar-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Spreading Cheer', '22-Dec-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Swinub Community Day Classic', '25-Feb-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Swinub Community Day Classic', '12-Jun-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Swinub Community Day Classic', '08-Jun-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Fur and Flames', '30-Oct-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Fur and Flames', '14-Oct-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Fur and Flames', '18-Aug-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Keeping Sharp', '14-Mar-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Keeping Sharp', '03-Sep-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Keeping Sharp', '08-Aug-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Squirtle Community Day Classic', '09-Jun-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Squirtle Community Day Classic', '27-Jun-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Squirtle Community Day Classic', '29-Nov-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Slippery Swirls', '01-Mar-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Slippery Swirls', '15-Apr-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Slippery Swirls', '29-Dec-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'A Bubbly Disposition', '01-Jan-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'A Bubbly Disposition', '28-Aug-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'A Bubbly Disposition', '07-Nov-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Community Day Classic: Charmander', '16-Feb-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Community Day Classic: Charmander', '29-Mar-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Community Day Classic: Charmander', '02-Jun-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Plugging Along', '20-Dec-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Plugging Along', '06-Jan-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Plugging Along', '18-Aug-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Muscle Memories', '18-Nov-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Muscle Memories', '11-Nov-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Muscle Memories', '30-May-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'A Muddy Buddy', '15-Oct-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'A Muddy Buddy', '05-Nov-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'A Muddy Buddy', '19-Aug-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Level 43 Challenge', '23-May-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Level 43 Challenge', '11-Mar-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Level 43 Challenge', '03-Nov-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Level 45 Challenge', '03-Mar-18');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Level 45 Challenge', '24-Aug-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Level 45 Challenge', '11-Oct-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Level 48 Challenge', '01-Sep-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Level 48 Challenge', '03-Jan-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Level 48 Challenge', '24-Jun-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Level 50 Challenge', '28-May-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Level 50 Challenge', '25-Apr-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Level 50 Challenge', '20-Mar-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'A Spooky Message', '10-Apr-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'A Spooky Message', '01-Feb-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'A Spooky Message', '25-Sep-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'A Spooky Message Unmasked', '29-Apr-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'A Spooky Message Unmasked', '13-Nov-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'A Spooky Message Unmasked', '25-Oct-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'What Lies beneath the Mask?', '03-Apr-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'What Lies beneath the Mask?', '30-Jan-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'What Lies beneath the Mask?', '10-May-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Mysterious Masks', '17-Sep-21');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Mysterious Masks', '08-Oct-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Mysterious Masks', '02-May-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Catch 10 Pokemon', '07-Aug-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Catch 10 Pokemon', '22-Jan-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Catch 10 Pokemon', '31-Jul-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'A Spooky Message 2018', '07-May-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'A Spooky Message 2018', '15-Nov-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'A Spooky Message 2018', '13-Jan-19');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'Go Fest 1st Part', '24-Jan-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'Go Fest 1st Part', '19-Aug-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'Go Fest 1st Part', '01-Aug-22');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'All-in-One 151 1st Part', '28-Apr-16');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'All-in-One 151 1st Part', '26-May-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'All-in-One 151 1st Part', '17-Feb-17');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('R4ch3l', 'City Safari:Seoul 2023', '04-Dec-20');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('N0rm', 'City Safari:Seoul 2023', '03-Sep-23');
INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate) VALUES ('Greg0r', 'City Safari:Seoul 2023', '13-May-21');


