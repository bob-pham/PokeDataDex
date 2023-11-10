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

