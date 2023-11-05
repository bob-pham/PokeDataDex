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
DROP TABLE PlayerCapturedSpecies CASCADE CONSTRAINTS;
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

CREATE TABLE PlayerCapturedSpecies(
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

CREATE TABLE PlayerVisitedPokestop(
    PlayerUsername CHAR(15),
    PokestopCountry CHAR(50),
    PokestopPostalCode CHAR(10),
    PokestopName CHAR(50),
    VisitedDate INTEGER NOT NULL,
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
INSERT INTO Team(Name, Mascot)
VALUES (‘Valor’, ‘Moltres’), 
       (‘Mystic’, ‘Articuno’), 
       (‘Instinct’, ‘Zapdos’), 
       (‘Aqua’, ‘Kyogre’), 
       (‘Magma’, ‘Groudon’);

INSERT INTO MascotColour(Mascot, Colour)
VALUES (‘Moltres’, ‘Red’), 
       (‘Articuno’, ‘Blue’), 
       (‘Zapdos’, ‘Yellow’), 
       (‘Kyogre’, ‘Sapphire’), 
       (‘Groudon’, ‘Crimson’);

INSERT INTO Player(Username, XP, TeamName)
VALUES (‘Steph4n’, 6000, ‘Valor’), 
       (‘J@son’, 30000, ‘Mystic’), 
       (‘B0b’, 40000, ‘Instinct’), 
       (‘Greg0r’, 40000, ‘Instinct’), 
       (‘N0rm’, 40000, ‘Mystic’), 
       (‘Go4t’, 6000, ‘Valor’), 
       (‘J3ssica’, 304, ‘Aqua’), 
       (‘R4ch3l’, 404, ‘Magma’);

INSERT INTO PlayerXPLevel(XP, Level)
VALUES (6000, 6), 
       (30000, 30), 
       (40000, 40), 
       (300, 1), 
       (400, 1);

INSERT INTO Item(Name, Cost, Effect)
VALUES (‘PokeBall’, 100, ‘Catches Pokemon’), 
       (‘Incense’, 40, ‘Attracts Pokemon’), 
       (‘Incubator’, 150, ‘Hatches eggs’), 
       (‘Raid Pass’, 100, ‘Raid Entry Ticket’), 
       (‘Lure Module’, 100, ‘Lures Pokemon’);

INSERT INTO ItemEffectType(Effect, Type)
VALUES (‘Catches Pokemon’, ‘Ball’), 
       (‘Attracts Pokemon’, ‘Buff’), 
       (‘Hatches Eggs’, ‘Egg Incubator’), 
       (‘Raid Entry Ticket’, ‘Raid Items’), 
       (‘Lures Pokemon’, ‘Lure’);

INSERT INTO ItemTypeUses(Type, Uses)
VALUES (‘Ball’, 20), 
       (‘Buff’, 1), 
       (‘Egg Incubator’, 5), 
       (‘Raid Items’, 1), 
       (‘Lure’, 1);

INSERT INTO Mission(Name, EventName)
VALUES (‘Catch 10 Pokemon’, ‘Default’), 
       (‘A Spooky Message 2018’, ‘Halloween 2018’), 
       (‘Go Fest 1st Part’, ‘GO Fest 2023 Fascinating Facets’), 
       (‘All-in-One 151 1st Part’, ‘All-in-One’), 
       (‘City Safari:Seoul 2023’, ‘City Safari 2023’);

INSERT INTO MissionEventNameXP(EventName, XP)
VALUES (‘Default’, 600), 
       (‘Halloween 2018’, 1080), 
       (‘Go Fest 2023 Fascinating Facets’, 2023), 
       (‘All-in-one’, 5100), 
       (‘City Safari 2023’ 2023);

INSERT INTO Location(Country, PostalCode, Name, Biome)
VALUES (‘Canada’, ‘V6T 1Z4’, ‘UBC Science’, ‘Nature’), 
       (‘Canada’, ‘K1A 0A6’, ‘House of Commons’, ‘Water’), 
       (‘Canada’, ‘V0N 1B4’, ‘Blackcomb Guest Services’, ‘Snow’), 
       (‘USA’, ‘NM 87111’, ‘White Residence’, ‘Toxic’), 
       ('France', '75001', 'Louvre Museum', 'Nature'),
       ('Australia', '2000', 'Sydney Opera House', 'Water'),
       ('Brazil', '71020-970', 'Christ the Redeemer', 'Mountain'),
       ('Japan', '100-0001', 'Shibuya Crossing', 'Nature'),
       (‘UK’, ‘SW1A 1BQ’, ‘Buckingham Palace’, ‘Enchanted’);

INSERT INTO BiomeAttackBonus(Biome, AttackBonus)
VALUES (‘Nature’, ‘Grass’), 
       (‘Water’, ‘Water’), 
       (‘Snow’, ‘Ice’), 
       (‘Toxic’, ‘Poison’), 
       (‘Mountain’, ‘Ground’),
       (‘Enchanted’, ‘Fairy’);

INSERT INTO Gym(Country, PostalCode, Name, BadgeName, SponsorName)
VALUES (‘Canada’, ‘V6T 1Z4’, ‘UBC Science’, ‘ICICS Building’, ‘UBC’), 
       (‘Canada’, ‘K1A 0A6’, ‘House of Commons’, ‘House of Commons CAN’, ‘Gov Of Canada’), 
       (‘Canada’, ‘V0N 1B4’, ‘Blackcomb Guest Services’, ‘GuestServicesBlckcmb’ ,‘Whistler’), 
       (‘USA’, ‘NM 87111’, ‘White Residence, ‘TheOneWhoKnocks’, ‘Heisenberg’), 
       ('Brazil', '71020-970', 'Christ the Redeemer', ‘The Redeemer’, 'Church'),
       ('Japan', '100-0001', 'Shibuya Crossing', ‘Shibuya’, 'Shibuya'),
       (‘UK’, ‘SW1A 1BQ’, ‘Buckingham Palace’, ‘BuckinghamPalace’, ‘Royal Family’);

INSERT INTO Pokestop(Country, PostalCode, Name, Rating, SponsorName)
VALUES (‘Canada’, ‘V6T 1Z4’, ‘UBC Science’, 0, ‘Starbucks’), 
       (‘Canada’, ‘K1A 0A6’, ‘House of Commons’, 7, ‘Gov Of Canada’), 
       (‘Canada’, ‘V0N 1B4’, ‘Blackcomb Guest Services’, 7, ‘Whistler’), 
       (‘USA’, ‘NM 87111’, ‘White Residence’, 10, ‘Heisenberg’), 
       ('France', '75001', 'Louvre Museum', 8, 'Louvre Staff'),
       ('Australia', '2000', 'Sydney Opera House', 9, 'Kangaroos'),
       (‘UK’, ‘SW1A 1BQ’, ‘Buckingham Palace’, 9, ‘Royal Family’);

INSERT INTO Egg(ID, SpeciesName)
VALUES (0001, ‘MagiKarp’)
       (0002, ‘Machop’), 
       (0003, ‘Meowth’), 
       (0004, ‘Deino’), 
       (0005, ‘Larvitar’);

INSERT INTO EggSpecies(SpeciesName, Type1, Type2, Distance)
VALUES (‘MagiKarp’, ‘Water’, NULL, 2), 
       (‘Machop’, ‘Fighting’, NULL, 5), 
       (‘Meowth’, ‘Normal’, NULL, 7), 
       (‘Deino’, ‘Dark’, ‘Dragon’, 10), 
       (‘Larvitar’, ‘Rock’, ‘Ground’, 12);
  
INSERT INTO Pokemon(ID, SpeciesName, CP, Distance, Nickname, GymCountry, GymPostalCode, GymName, StationedAtDate, FoundCountry, FoundPostalCode, FoundName)
VALUES (0006, ‘Slaking’, 3804, 114, NULL, ‘Canada’, ‘V6T 1Z4’, ‘UBC Science’, ‘2023-10-19’, ‘Canada’, ‘V0N 1B4’, ‘Blackcomb Guest Services’), 
       (0007, ‘Vaporeon’, 2616, 0, ‘Squidward’, NULL, NULL, NULL, ‘Canada’, ‘V6T 1Z4’, ‘UBC Science’), 
       (0008, ‘Dialga’, 2242, 0, NULL, NULL, NULL, NULL, ‘Canada’, ‘K1A 0A6’, ‘House of Commons’), 
       (0009, ‘Abomasnow’, 1803, 1, ‘ObamaSnow’, ‘Canada’, ‘K1A 0A6’, ‘House of Commons’, ‘Canada’, ‘K1A 0A6’, ‘House of Commons’), 
       (0010, ‘Regirock’, 1319, 3, ‘Dwayne’, ‘Canada’, ‘V0N 1B4’, ‘Blackcomb Guest Services’, ‘USA’, ‘NM 87111’, ‘White Residence’);

INSERT INTO PokemonSpeciesTypes(SpeciesName, Type1, Type2)
VALUES (‘Slacking’, ‘Normal’, NULL), 
       (‘Vaporeon’, ‘Water’, NULL), 
       (‘Dialga’, ‘Steel’, ‘Dragon’), 
       (‘Abomasnow’, ‘Grass’, ‘Ice’), 
       (‘Regirock’, ‘Rock’, NULL);

INSERT INTO PokemonSpeciesCP(SpeciesName, CP, HP, Attack)
VALUES (‘Slaking’, 3804, 218, 3), 
       (‘Vaporeon’, 2616, 215, 2), 
       (‘Dialga’, 2242, 131, 3), 
       (‘Abomasnow’, 1803, 154, 2), 
       (‘Regirock’, 1319, 105, 1);

INSERT INTO NPC(Name, Role)
VALUES (‘Cadela’, ‘Team Leader’), 
       (‘Professor Oak’, ‘Professor’), 
       (‘Arlo’, ‘Team Rocket Leader’), 
       (‘Male Grunt’, ‘Team Rocket Grunt’), 
       (‘Balloon Grunt’, ‘Team Rocket Balloon’);

INSERT INTO RoleCanBattle(Role, CanBattle)
VALUES (‘TeamLeader’, FALSE), 
       (‘PROFESSOR’, FALSE), 
       (‘Team Rocket Leader’, TRUE), 
       (‘Team Rocket Grunt’, TRUE), 
       (‘Team Rocket Balloon’, ‘TRUE’);

INSERT INTO PlayerOwnsItem(PlayerUsername, ItemName, Quantity)
VALUES (‘Steph4n’, ‘LureModule’, 1), 
       (‘J@son’, ‘Pokeball’, 20), 
       (‘B0b’, ‘Pokeball’, 10), 
       (‘B0b’, ‘LureModule’, 5),
       (‘Greg0r’, ‘Pokeball’, 100), 
       (‘N0rm’, ‘Pokeball’, 420), 
       (‘Go4t’, ‘LureModule’, 23),  
       (‘B0b’, ‘Raid Pass’, 2);

INSERT INTO PlayerCompletedMission(PlayerUsername, MissionName, CompletedDate)
VALUES (‘B0b’, ‘Catch 10 Pokemon’, ‘2018-09-11’), 
       (‘B0b’, ‘All-in-One 151 1st Part’, ‘2021-02-20’), 
       (‘J@son’, ‘Catch 10 Pokemon’, ‘2018-10-01’), 
       (‘Steph4n’, ‘Catch 10 Pokemon’, ‘2023-10-19’), 
       (‘J3ssica’, ‘Go Fest 1st Part’, ‘2023-08-22’);

INSERT INTO BattleLeague(DateOccurred, PlayerUsername1, PlayerUsername2, League, Time)
VALUES (‘2023-10-19’, ‘B0b’, ‘J@son’, ‘Great League’, 5), 
       (‘2023-10-18’, ‘B0b’, ‘J3ssica’, ‘Ultra League’, 4), 
       (‘2023-10-18’, ‘J@son’, ‘Steph4n’, ‘Master League’, 5), 
       (‘2022-01-05’, ‘J3ssica’, ‘R4chel’, ‘Training’, 10),
       (‘2022-10-05’, ‘N0rm’, ‘J3ssica’, ‘Ultra League’, 3), 
       (‘2023-01-18’, ‘J@son’, ‘Greg0r’, ‘Master League’, 1), 
       (‘2021-01-05’, ‘Go4t’, ‘R4chel’, ‘Training’, 10),  
       (‘2018-05-10’, ‘B0b’, ‘J@son’, ‘Friendly’, 1);

INSERT INTO LeagueMaxCP(League, CP)
VALUES (‘Great League’, 1500), 
       (‘Ultra League’, 2500), 
       (‘Master League’, 9999), 
       (‘Training’, 1500), 
       (‘Friendly’, 2500);


INSERT INTO PlayerCapturedSpecies(PlayerUsername, SpeciesID, CapturedDate)
VALUES (‘B0b’, 0008, ‘2019-03-23’), 
       (‘J@son’, 0010, ‘2019-04-04’), 
       (‘St4phan’, 0007, ‘2021-11-14’), 
       (‘B0b’, 0001, ‘2020-04-23’), 
       (‘J@son’, 0002, ‘2021-05-05’), 
       (‘St4phan’, 0003, ‘2021-12-14’), 
       (‘J3ssica’, 0009, ‘2019-02-26’), 
       (‘R4chel’,  0006, ‘2019-06-18’);

INSERT INTO PlayerVisitedPokestop(PlayerUsername, PokestopCountry, PokestopPostalCode, PokestopName, VisitedDate)
VALUES (‘B0b’, ‘USA’, ‘NM 87111’, ‘White Residence’, ‘2022-12-02’), 
       (‘J@son’, ‘USA’, ‘NM 87111’, ‘White Residence’, ‘2023-09-06’), 
       (‘St4phan’, ‘Canada’, ‘K1A 0A6’, ‘House of Commons’, ‘2020-04-05’), 
       (‘J3ssica’, ‘Canada’, ‘V6T 1Z4’, ‘UBC Science’, ‘2023-10-19’), 
       (‘R4chel’, ‘UK’, ‘SW1A 1BQ’, ‘Buckingham Palace’, ‘BuckinghamPalace’, ‘2019-01-01’);

INSERT INTO NPCAppearedAtPokestop(NPCName, PokestopCountry, PokestopPostalCode, PokestopName)
VALUES (‘Male Grunt’, ‘Canada’, ‘V6T 1Z4’, ‘UBC Science’), 
       (‘Male Grunt’, ‘Canada’, ‘K1A 0A6’, ‘House of Commons’), 
       (‘Arlo’, ‘Canada’, ‘V0N 1B4’, ‘Blackcomb Guest Services’), 
       (‘Balloon Grunt’, ‘USA’, ‘NM 87111’, ‘White Residence’), 
       (‘Professor Oak’, ‘UK’, ‘SW1A 1BQ’, ‘Buckingham Palace’);

INSERT INTO NPCSighting(NPCName, PokestopCountry, PokestopPostalCode, PokestopName, SightingDate, EventName)
VALUES (‘Male Grunt’, ‘Canada’, ‘V6T 1Z4’, ‘UBC Science’, ‘2023-10-11’, ‘Default’), 
       (‘Male Grunt’, ‘Canada’, ‘K1A 0A6’, ‘House of Commons’, ‘2018-10-30’, ‘Halloween 2018’), 
       (‘Arlo’, ‘Canada’, ‘V0N 1B4’, ‘Blackcomb Guest Services’, ‘2023-07-22’, ‘Go Fest 2023 Fascinating Facets’), 
       (‘Balloon Grunt’, ‘USA’, ‘NM 87111’, ‘White Residence’, ‘2021-02-20’, ‘All-in-One 151’), 
       (‘Professor Oak’, ‘UK’, ‘SW1A 1BQ’, ‘Buckingham Palace’, ‘2023-11-04’, ‘City Safari 2023’);

INSERT INTO NPCSightingEventName(EventName, XP, Duration)
VALUES (‘Default’, 100, 60), 
       (‘Halloween 2018’, 1000, 48), 
       (‘Go Fest 2023 Fascinating Facets’, 2023, 48), 
       (‘All-in-one’, 250, 48), 
       (‘City Safari 2023’, 2023, 48);

