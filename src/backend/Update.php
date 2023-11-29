<!DOCTYPE html>
<html>
<head>
    <title>PokeDataDex</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital@1&family=Pixelify+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" href="assets/logo.png" sizes="16x16" type="image.png">
    <link rel="stylesheet" type="text/css" href="styles/styles.css">
</head>
<body class="background">
<div class="header">
    <h1 class="header-text">PokeDataDex</h1>
    <h3 class="sub-header-text">By Bob Pham, Jason Wang, Stevan Zhuang</h3>
</div>
<div class="section">
    <h1 class="header-text">Home</h1>
    <div>
        <form action="PokeDataDex.php">
            <input type="submit" value="Home">
        </form>
    </div>
</div>

<div class="section">
<div class="subsection">
  <h2>Update a Value in Table:</h2>
  <div class="subsection">
  <form method="POST" action="Update.php">
    <select id="select" onChange="handleSelection(value)">
      <option selected value="update-select">Select a table </option>
      <option value="update-player">Player </option>
      <option value="update-item">Item </option>
      <option value="update-pokemon">Pokemon </option>
    </select>
  </form>
  <p class="modify-item">
    Fields with no values entered will not be updated, enter NULL to change field to null value.
  </p>
  </div>
  <div class="modify">
  <form method="POST" action="Update.php">
    <input type="hidden" id="updateRequest" name="updateRequest">
    <div class="hide" id="update-player">
      <select name="updatePlayerSelect" id="updatePlayerSelect"></select>
      <label class="modify-item">XP: </label>
      <input type="text" name="updatePlayerXP"></input>
      <label class="modify-item">Team Name: </label>
      <input type="text" name="updatePlayerTeamName"></input>
      <label class="modify-item">Level: </label>
      <input type="text" name="updatePlayerLevel"></input>
      <div class="subsection">
        <input type="submit" value="Update" name="updatePlayerSubmit">
      </div>
    </div>
    <div class="hide" id="update-item">
      <select name="updateItemSelect" id="updateItemSelect"></select>
      <label class="modify-item">Cost</label>
      <input type="text" name="updateItemCost"></input>
      <label class="modify-item">Effect: </label>
      <input type="text" name="updateItemEffect"></input>
      <label class="modify-item">Type: </label>
      <input type="text" name="updateItemType"></input>
      <label class="modify-item">Uses: </label>
      <input type="text" name="updateItemUses"></input>
      <div class="subsection">
        <input type="submit" value="Update" name="updateItemSubmit">
      </div>
    </div>
    <div class="hide" id="update-pokemon">
      <select name="updatePokemonSelect" id="updatePokemonSelect"></select>
      <label class="modify-item">Species Name: </label>
      <input type="text" name="updatePokemonSpeciesName"></input>
      <label class="modify-item">Combat Score: </label>
      <input type="text" name="updatePokemonCP"></input>
      <label class="modify-item">Distance: </label>
      <input type="text" name="updatePokemonDistance"></input>
      <label class="modify-item">Nickname: </label>
      <input type="text" name="updatePokemonNickname"></input>
      <label class="modify-item">Type1: </label>
      <input type="text" name="updatePokemonType1"></input>
      <label class="modify-item">Type2: </label>
      <input type="text" name="updatePokemonType2"></input>
      <label class="modify-item">Health Points: </label>
      <input type="text" name="updatePokemonHP"></input>
      <label class="modify-item">Attack: </label>
      <input type="text" name="updatePokemonAttack"></input>
      <label class="modify-item">Gym Country: </label>
      <input type="text" name="updatePokemonGymCountry"></input>
      <label class="modify-item">Gym Postal Code: </label>
      <input type="text" name="updatePokemonGymPostalCode"></input>
      <label class="modify-item">Gym Name: </label>
      <input type="text" name="updatePokemonGymName"></input>
      <label class="modify-item">Stationed at Date (dd-mon-yyyy): </label>
      <input type="text" name="updatePokemonStationedDate"></input>
      <label class="modify-item">Found Country</label>
      <input type="text" name="updatePokemonFoundCountry"></input>
      <label class="modify-item">Found Postal Code: </label>
      <input type="text" name="updatePokemonFoundPostalCode"></input>
      <label class="modify-item">Found Name: </label>
      <input type="text" name="updatePokemonFoundName"></input>
      <div class="subsection">
        <input type="submit" value="Update" name="updatePokemonSubmit">
      </div>
    </div>
    <?php
    include_once("./util.php");
    function getUI() {
        global $db_conn;
        if ($db_conn == NULL) {
            connectToDB();
        }
        getSelectUI("update");
        disconnectFromDB();
    }
    getUI()
    ?>
  </form>
  </div>

<?php
include_once("./util.php");

function handleUpdatePlayerRequest() {
    global $db_conn;
    try {
        $username = parseInputSkip($_POST['updatePlayerSelect'], 'char_15', 'Username');
        $xp = parseInputSkip($_POST['updatePlayerXP'], 'int', 'XP');
        $teamname = parseInputSkip($_POST['updatePlayerTeamName'], 'char_8', 'Team Name');
        $level = parseInputSkip($_POST['updatePlayerLevel'], 'int', 'Level');
    } catch(Exception $e) {
        alertUser($e->getMessage());
        return;
    }
    $values = valuesJoin([$xp, $level]);
    if (!inputIsNull($xp) && !keysInTable('PlayerXPLevel', ["XP" => $xp])) {
        if (inputIsNull($level)) {
            alertUser("Level given Input for XP is unknown, Level must be specified");
            return;
        }
        executePlainSQL("INSERT INTO PlayerXPLevel VALUES ($values)");
    }
    if (!inputIsNull($teamname) && !keysInTable('Team', ['Name' => $teamname])) {
        alertUser("Input for Team Name must be in the Team table");
        return;
    }
    $values = valuesJoinByName([$xp, $teamname], ["XP", "TeamName"]);
    if (strlen($values) === 0) {
        return;
    }
    executePlainSQL("UPDATE Player SET $values WHERE Username = $username");
    OCICommit($db_conn);
}

function handleUpdateItemRequest() {
    global $db_conn;
    try {
        $name = parseInputSkip($_POST['updateItemSelect'], 'char_30', 'Name');
        $cost = parseInputSkip($_POST['updateItemCost'], 'int', 'Cost', true);
        $effect = parseInputSkip($_POST['updateItemEffect'], 'char_100', 'Effect');
        $type = parseInputSkip($_POST['updateItemType'], 'char_20', 'Type');
        $uses = parseInputSkip($_POST['updateItemUses'], 'int', 'Uses', true);
    } catch(Exception $e) {
        alertUser($e->getMessage());
        return;
    }
    $values = valuesJoin([$type, $uses]);
    if (!inputIsNull($type) && !keysInTable('ItemTypeUses', ["Type" => $type])) {
        if (inputIsNull($uses)) {
            alertUser("Uses given Input for Type is unknown, Uses must be specified");
            return;
        }
        executePlainSQL("INSERT INTO ItemTypeUses VALUES ($values)");
    }
    $values = valuesJoin([$effect, $type]);
    if (!inputIsNull($effect) && !keysInTable('ItemEffectType', ["Effect" => $effect])) {
        if (inputIsNull($type)) {
            alertUser("Type given Input for Effect is unknown, Type must be specified");
            return;
        }
        executePlainSQL("INSERT INTO ItemEffectType VALUES ($values)");
    }
    $values = valuesJoinByName([$cost, $effect], ["Cost", "Effect"]);
    if (strlen($values) === 0) {
        return;
    }
    executePlainSQL("UPDATE Item SET $values WHERE name = $name");
    OCICommit($db_conn);
}

function handleUpdatePokemonRequest() {
    global $db_conn;
    try {
        $id = parseInputSkip($_POST['updatePokemonSelect'], 'int', 'ID');
        $speciesname = parseInputSkip($_POST['updatePokemonSpeciesName'], 'char_20', 'Species Name');
        $cp = parseInputSkip($_POST['updatePokemonCP'], 'int', 'Combat Score');
        $distance = parseInputSkip($_POST['updatePokemonDistance'], 'int', 'Distance', true);
        $nickname = parseInputSkip($_POST['updatePokemonNickname'], 'char_15', 'Nickname', true);
        $type1 = parseInputSkip($_POST['updatePokemonType1'], 'char_10', 'Type 1');
        $type2 = parseInputSkip($_POST['updatePokemonType2'], 'char_10', 'Type 2', true);
        $hp = parseInputSkip($_POST['updatePokemonHP'], 'int', 'Health Points');
        $attack = parseInputSkip($_POST['updatePokemonAttack'], 'int', 'Attack');
        $gymcountry = parseInputSkip($_POST['updatePokemonGymCountry'], 'char_50', 'Gym Country', true);
        $gympostalcode = parseInputSkip($_POST['updatePokemonGymPostalCode'], 'char_10', 'Gym Postal Code', true);
        $gymname = parseInputSkip($_POST['updatePokemonGymName'], 'char_50', 'Gym Name', true);
        $stationeddate = parseInputSkip($_POST['updatePokemonStationedDate'], 'date', 'Stationed at Date', true);
        $foundcountry = parseInputSkip($_POST['updatePokemonFoundCountry'], 'char_50', 'Found Country', true);
        $foundpostalcode = parseInputSkip($_POST['updatePokemonFoundPostalCode'], 'char_10', 'Found Postal Code', true);
        $foundname = parseInputSkip($_POST['updatePokemonFoundName'], 'char_50', 'Found Name', true);
    } catch(Exception $e) {
        alertUser($e->getMessage());
        return;
    }
    $values = valuesJoin([$speciesname, $type1, $type2]);
    if (!inputIsNull($speciesname) && !keysInTable('PokemonSpeciesTypes', ["SpeciesName" => $speciesname])) {
        if (inputIsNull($type1)) {
            alertUser("Type 1 given Input for Species Name is unknown, Type 1 must be specified");
            return;
        }
        executePlainSQL("INSERT INTO PokemonSpeciesTypes VALUES ($values)");
    }
    $values = valuesJoin([$speciesname, $cp, $attack, $hp]);
    if (!inputIsNull($speciesname) && !keysInTable('PokemonSpeciesCP', ["SpeciesName" => $speciesname])) {
        if (inputIsNull($cp) || inputIsNull($attack) || inputIsNull($hp)) {
            alertUser("Combat Power, Attack, and HP given Input for Species Name is unknown, all must be specified");
            return;
        }
        executePlainSQL("INSERT INTO PokemonSpeciesCP VALUES ($values)");
    }
    $locationTuple = ['Country' => $gymcountry, 'PostalCode' => $gympostalcode, 'Name' => $gymname];
    $allNonNull = !inputIsNull($gymcountry) && !inputIsNull($gympostalcode) && !inputIsNull($gymname);
    $anyNonNull = !inputIsNull($gymcountry) || !inputIsNull($gympostalcode) || !inputIsNull($gymname);
    if ($anyNonNull && !$allNonNull) {
        alertUser("Input for Gym Country, Gym Postal Code and Gym Name must all be specified");
        return;
    }
    if ($anyNonNull && !keysInTable('Location', $locationTuple)) {
        alertUser("Input for Gym Country, Gym Postal Code and Gym Name must be in the Location table");
        return;
    }
    $locationTuple = ['Country' => $foundcountry, 'PostalCode' => $foundpostalcode, 'Name' => $foundname];
    $allNonNull = !inputIsNull($foundcountry) && !inputIsNull($foundpostalcode) && !inputIsNull($foundname);
    $anyNonNull = !inputIsNull($foundcountry) || !inputIsNull($foundpostalcode) || !inputIsNull($foundname);
    if ($anyNonNull && !$allNonNull) {
        alertUser("Input for Found Country, Found Postal Code and Found Name must all be specified");
        return;
    }
    if ($anyNonNull && !keysInTable('Location', $locationTuple)) {
        alertUser("Input for Found Country, Found Postal Code and Found Name must be in the Location table");
        return;
    }
    $values = valuesJoinByName([
        $speciesname, $cp, $distance, $nickname, $gymcountry, $gympostalcode, $gymname,
        $stationeddate, $foundcountry, $foundpostalcode, $foundname
    ], [
        "SpeciesName", "CP", "Distance", "Nickname", "GymCountry", "GymPostalCode", "GymName",
        "StationedAtDate", "FoundCountry", "FoundPostalCode", "FoundName"
    ]);
    if (strlen($values) === 0) {
        return;
    }
    executePlainSQL("UPDATE Pokemon SET $values WHERE ID = $id");
    OCICommit($db_conn);
}

foreach (["Player", "Item", "Pokemon"] as $table) {
    handleRequests($_POST, "update$table" . "Submit");
}

?>
</div>
    <div class="section">
        <img src="assets/logo.png" type="image.png">
    </div>
    <script src="js/helper.js" defer></script>
</body>
</html>