<div>
  <h2>Reset</h2>
  <form method="POST" action="PokeDataDex.php">
    <input type="hidden" id="resetTablesRequest" name="resetTablesRequest">
    <p><input type="submit" value="Reset" name="reset"></p>
  </form>
<?php
  include_once("./util.php");

  function handleResetRequest() {
    global $db_conn;
    // Drop old tables
    foreach (['Player', 'Item', 'Pokemon'] as $tablename) {
        executePlainSQL("DROP TABLE $tablename CASCADE CONSTRAINTS");
    }
    // Create new tables
    executePlainSQL("CREATE TABLE Player(
        Username CHAR(15) PRIMARY KEY,
        XP INTEGER NOT NULL,
        TeamName CHAR(8) NOT NULL,
        FOREIGN KEY (TeamName)
            REFERENCES Team(Name)
            ON DELETE CASCADE,
        FOREIGN KEY (XP)
            REFERENCES PlayerXPLevel(XP)
            ON DELETE CASCADE
    )");
    executePlainSQL("CREATE TABLE Item(
        Name CHAR(30) PRIMARY KEY,
        Cost INTEGER,
        Effect CHAR(100),
        FOREIGN KEY (Effect)
            REFERENCES ItemEffectType(Effect)
            ON DELETE CASCADE
    )");
    executePlainSQL("CREATE TABLE Pokemon(
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
    )");
    OCICommit($db_conn);
}

?>
</div>
