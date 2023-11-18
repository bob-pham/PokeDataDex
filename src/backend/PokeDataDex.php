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
        <link rel="icon" href="assets/logo.png" sizes="16x16" type="image.png">
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
          include("./Select.php");
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

        <hr />

        <h2>Count the Tuples in DemoTable</h2>
        <form method="GET" action="PokeDataDex.php"> <!--refresh page when submitted-->
            <input type="hidden" id="countTupleRequest" name="countTupleRequest">
            <input type="submit" name="countTuples"></p>
        </form>

        <?php
        include_once("./util.php");

        function handleUpdateRequest() {
            global $db_conn;

            $old_name = $_POST['oldName'];
            $new_name = $_POST['newName'];

            // you need the wrap the old name and new name values with single quotations
            executePlainSQL("UPDATE Player SET name='" . $new_name . "' WHERE name='" . $old_name . "'");
            OCICommit($db_conn);
        }

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

        function handleInsertPlayerRequest() {
            global $db_conn;
            $username = "'" . $_POST['insertPlayerUsername'] . "'";
            $xp = $_POST['insertPlayerXP'];
            $teamname = "'" . $_POST['insertPlayerTeamName'] . "'";
            $level = $_POST['insertPlayerLevel'];

            $values = valuesJoin([$xp, $level]);
            executePlainSQL("INSERT INTO PlayerXPLevel VALUES ($values)");
            $values = valuesJoin([$username, $xp, $teamname]);
            executePlainSQL("INSERT INTO Player VALUES ($values)");
            OCICommit($db_conn);
        }

        function handleInsertItemRequest() {
            global $db_conn;
            $name = "'" . $_POST['insertItemName'] . "'";
            $cost = $_POST['insertItemCost'];
            $effect = "'" . $_POST['insertItemEffect'] . "'";
            $type = "'" . $_POST['insertItemType'] . "'";
            $uses = $_POST['insertItemUses'];

            $values = valuesJoin([$type, $uses]);
            executePlainSQL("INSERT INTO ItemTypeUses VALUES ($values)");
            $values = valuesJoin([$effect, $type]);
            executePlainSQL("INSERT INTO ItemEffectType VALUES ($values)");
            $values = valuesJoin([$name, $cost, $effect]);
            executePlainSQL("INSERT INTO Item VALUES ($values)");
            OCICommit($db_conn);
        }

        function handleInsertPokemonRequest() {
            global $db_conn;
            $id = $_POST['insertPokemonID'];
            $speciesname = "'" . $_POST['insertPokemonSpeciesName'] . "'";
            $cp = $_POST['insertPokemonCP'];
            $distance = $_POST['insertPokemonDistance'];
            $nickname =  "'" . $_POST['insertPokemonNickname'] . "'";
            $type1 = "'" . $_POST['insertPokemonType1'] . "'";
            $type2 = "'" . $_POST['insertPokemonType2'] . "'";
            $hp = $_POST['insertPokemonHP'];
            $attack = $_POST['insertPokemonAttack'];
            $gymcountry = "'" . $_POST['insertPokemonGymCountry'] . "'";
            $gympostalcode = "'" . $_POST['insertPokemonGymPostalCode'] . "'";
            $gymname = "'" . $_POST['insertPokemonGymName'] . "'";
            $stationeddate = "'" . $_POST['insertPokemonStationedDate'] . "'";
            $foundcountry = "'" . $_POST['insertPokemonFoundCountry'] . "'";
            $foundpostalcode = "'" . $_POST['insertPokemonFoundPostalCode'] . "'";
            $foundname = "'" . $_POST['insertPokemonFoundName'] . "'";

            $values = valuesJoin([$speciesname, $type1, $type2]);
            executePlainSQL("INSERT INTO PokemonSpeciesTypes VALUES ($values)");
            $values = valuesJoin([$speciesname, $cp, $attack, $hp]);
            executePlainSQL("INSERT INTO PokemonSpeciesCP VALUES ($values)");
            $values = valuesJoin([
                $id, $speciesname, $cp, $distance, $nickname,
                $gymcountry, $gympostalcode, $gymname, $stationeddate,
                $foundcountry, $foundpostalcode, $foundname
            ]);
            executePlainSQL("INSERT INTO Pokemon VALUES ($values)");
            OCICommit($db_conn);
        }

        function handleDeletePlayerRequest() {
            global $db_conn;
            $username = $_POST['deletePlayerUsername'];
            executePlainSQL("DELETE FROM Player WHERE Username = '$username'");
            OCICommit($db_conn);
        }

        function handleDeleteItemRequest() {
            global $db_conn;
            $name = $_POST['deleteItemName'];
            executePlainSQL("DELETE FROM Item WHERE Name = '$name'");
            OCICommit($db_conn);
        }

        function handleDeletePokemonRequest() {
            global $db_conn;
            $id = $_POST['deletePokemonID'];
            executePlainSQL("DELETE FROM Pokemon WHERE ID = '$id'");
            OCICommit($db_conn);
        }

        function handleCountRequest() {
            global $db_conn;
            $tables = ["Player", "Item", "Pokemon"];
            foreach ($tables as $table) {
                $result = executePlainSQL("SELECT Count(*) FROM $table");
                if (($row = oci_fetch_row($result)) != false) {
                    echo "<br> The number of tuples in $table: " . $row[0] . "<br>";
                }
            }
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
            'countTupleRequest' => 'handleCountRequest'
        ];

        handleRequests($post_requests, $_POST);
        handleRequests($get_requests, $_GET);

		?>
	</body>
</html>

