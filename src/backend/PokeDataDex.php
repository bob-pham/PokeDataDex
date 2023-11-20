<!--Test Oracle file for UBC CPSC304 2018 Winter Term 1
  Created by Jiemin Zhang
  Modified by Simona Radu
  Modified by Jessica Wong (2018-06-22)
  This file shows the very basics of how to execute PHP commands
  on Oracle.
  Specifically, it will drop a table, create a table, insert values
  update values, and then query for values

  IF YOU HAVE A TABLE CALLED "Player" IT WILL BE DESTROYED

  The script assumes you already have a server set up
  All OCI commands are commands to the Oracle libraries
  To get the file to work, you must place it somewhere where your
  Apache server can run it, and you must rename it to have a ".php"
  extension.  You must also change the username and password on the
  OCILogon below to be your ORACLE username and password -->

  <html>
    <head>
        <title>PokeDataDex</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Pixelify+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="icon" href="./assets/logo.png" sizes="16x16" type="image.png">
        <style>
            <?php include 'styles/styles.css'; ?>
        </style>
    </head>

    <body class="background">
        <div class="header">
          <h1 class="header-text">PokeDataDex</h1>
          <h3 class="sub-header-text">By Bob Pham, Jason Wang, Stevan Zhuang</h3>
        </div>
        <?php
          include("./ViewTables.php");
        ?>
        <?php
          include("./Leaderboard.php");
        ?>
        <h2>Reset</h2>
        <p>If you wish to reset the table press on the reset button. If this is the first time you're running this page, you MUST use reset</p>

        <form method="POST" action="PokeDataDex.php">
            <!-- if you want another page to load after the button is clicked, you have to specify that page in the action parameter -->
            <input type="hidden" id="resetTablesRequest" name="resetTablesRequest">
            <p><input type="submit" value="Reset" name="reset"></p>
        </form>

        <hr />

        <?php
          include("./TableEdit.php");
        ?>

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

        function handleRequests($requests, $method) {
            foreach (array_keys($requests) as $req) {
                if (isset($method[$req])) {
                    if (connectToDB()) {
                        $requests[$req]();
                        disconnectFromDB();
                    }
                }
            }
        }

        $post_requests = [
            'reset' => 'handleResetRequest'
        ];
        foreach (["Insert", "Update", "Delete"] as $op) {
            foreach (["Player", "Item", "Pokemon"] as $table) {
                $post_requests[strtolower($op) . $table . "Submit"] = 'handle' . "$op$table" . 'Request';
            }
        }
        $get_requests = [
        ];

        handleRequests($post_requests, $_POST);
        handleRequests($get_requests, $_GET);

		?>
	</body>
</html>

