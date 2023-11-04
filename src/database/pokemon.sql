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