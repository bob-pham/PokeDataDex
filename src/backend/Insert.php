<div class="subsection">
  <h2>Insert Values into Table:</h2>
  <form method="POST" action="PokeDataDex.php">
    <select id="select" onChange="handleSelection(value)">
      <option selected value="insert-select">Select a table</option>
      <option value="insert-player">Player</option>
      <option value="insert-item">Item</option>
      <option value="insert-pokemon">Pokemon</option>
    </select>
  </form>
  <div class="modify">
  <form method="POST" action="PokeDataDex.php">
    <input type="hidden" id="insertRequest" name="insertRequest">
    <div class="hide" id="insert-player">
      <label class="modify-item">Username: </label>
      <input type="text" name="insertPlayerUsername"></input>
      <label class="modify-item">XP: </label>
      <input type="text" name="insertPlayerXP"></input>
      <label class="modify-item">Team Name: </label>
      <input type="text" name="insertPlayerTeamName"></input>
      <label class="modify-item">Level: </label>
      <input type="text" name="insertPlayerLevel"></input>
      <div class="subsection">
        <input type="submit" value="Insert" name="insertPlayerSubmit">
      </div>
    </div>
    <div class="hide" id="insert-item">
      <label class="modify-item">Name: </label>
      <input type="text" name="insertItemName"></input>
      <label class="modify-item">Cost (optional)</label>
      <input type="text" name="insertItemCost"></input>
      <label class="modify-item">Effect: </label>
      <input type="text" name="insertItemEffect"></input>
      <label class="modify-item">Type: </label>
      <input type="text" name="insertItemType"></input>
      <label class="modify-item">Uses (optional): </label>
      <input type="text" name="insertItemUses"></input>
      <div class="subsection">
        <input type="submit" value="Insert" name="insertItemSubmit">
      </div>
    </div>
    <div class="hide" id="insert-pokemon">
      <label class="modify-item">ID: </label>
      <input type="text" name="insertPokemonID"></input>
      <label class="modify-item">Species Name: </label>
      <input type="text" name="insertPokemonSpeciesName"></input>
      <label class="modify-item">Combat Score: </label>
      <input type="text" name="insertPokemonCP"></input>
      <label class="modify-item">Distance (optional): </label>
      <input type="text" name="insertPokemonDistance"></input>
      <label class="modify-item">Nickname (optional): </label>
      <input type="text" name="insertPokemonNickname"></input>
      <label class="modify-item">Type 1: </label>
      <input type="text" name="insertPokemonType1"></input>
      <label class="modify-item">Type 2 (optional): </label>
      <input type="text" name="insertPokemonType2"></input>
      <label class="modify-item">Health Points: </label>
      <input type="text" name="insertPokemonHP"></input>
      <label class="modify-item">Attack: </label>
      <input type="text" name="insertPokemonAttack"></input>
      <label class="modify-item">Gym Country (optional): </label>
      <input type="text" name="insertPokemonGymCountry"></input>
      <label class="modify-item">Gym Postal Code (optional): </label>
      <input type="text" name="insertPokemonGymPostalCode"></input>
      <label class="modify-item">Gym Name (optional): </label>
      <input type="text" name="insertPokemonGymName"></input>
      <label class="modify-item">Stationed at Date (mm-mon-yyyy, optional): </label>
      <input type="text" name="insertPokemonStationedDate"></input>
      <label class="modify-item">Found Country (optional)</label>
      <input type="text" name="insertPokemonFoundCountry"></input>
      <label class="modify-item">Found Postal Code (optional): </label>
      <input type="text" name="insertPokemonFoundPostalCode"></input>
      <label class="modify-item">Found Name (optional): </label>
      <input type="text" name="insertPokemonFoundName"></input>
      <div class="subsection">
        <input type="submit" value="Insert" name="insertPokemonSubmit">
      </div>
    </div>
  </div>
  </form>
<?php
include_once("./util.php");

function handleInsertPlayerRequest() {
    global $db_conn;
    try {
        $username = parseInput($_POST['insertPlayerUsername'], 'str', 'Username');
        $xp = parseInput($_POST['insertPlayerXP'], 'int', 'XP');
        $teamname = parseInput($_POST['insertPlayerTeamName'], 'str', 'Team Name');
        $level = parseInput($_POST['insertPlayerLevel'], 'int', 'Level');
    } catch(Exception $e) {
        alertUser($e->getMessage());
        return;
    }
    if (keysInTable('Player', ['Username' => $username])) {
        alertUser("Input for Player Username must be unique");
        return;
    }
    $values = valuesJoin([$xp, $level]);
    if (!keysInTable('PlayerXPLevel', ["XP" => $xp])) {
        executePlainSQL("INSERT INTO PlayerXPLevel VALUES ($values)");
    }
    if (!keysInTable('Team', ['Name' => $teamname])) {
        alertUser("Input for Team Name must be in the Team table");
        return;
    }
    $values = valuesJoin([$username, $xp, $teamname]);
    executePlainSQL("INSERT INTO Player VALUES ($values)");
    OCICommit($db_conn);
}

function handleInsertItemRequest() {
    global $db_conn;
    try {
        $name = parseInput($_POST['insertItemName'], 'str', 'Name');
        $cost = parseInput($_POST['insertItemCost'], 'int', 'Cost', true);
        $effect = parseInput($_POST['insertItemEffect'], 'str', 'Effect');
        $type = parseInput($_POST['insertItemType'], 'str', 'Type');
        $uses = parseInput($_POST['insertItemUses'], 'int', 'Uses', true);
    } catch(Exception $e) {
        alertUser($e->getMessage());
        return;
    }
    if (keysInTable('Item', ['Name' => $name])) {
        alertUser("Input for Item Name must be unique");
        return;
    }
    $values = valuesJoin([$type, $uses]);
    if (!keysInTable('ItemTypeUses', ["Type" => $type])) {
        executePlainSQL("INSERT INTO ItemTypeUses VALUES ($values)");
    }
    $values = valuesJoin([$effect, $type]);
    if (!keysInTable('ItemEffectType', ["Effect" => $effect])) {
        executePlainSQL("INSERT INTO ItemEffectType VALUES ($values)");
    }
    $values = valuesJoin([$name, $cost, $effect]);
    executePlainSQL("INSERT INTO Item VALUES ($values)");
    OCICommit($db_conn);
}

function handleInsertPokemonRequest() {
    global $db_conn;
    try {
        $id = parseInput($_POST['insertPokemonID'], 'int', 'ID');
        $speciesname = parseInput($_POST['insertPokemonSpeciesName'], 'str', 'Species Name');
        $cp = parseInput($_POST['insertPokemonCP'], 'int', 'Combat Score');
        $distance = parseInput($_POST['insertPokemonDistance'], 'int', 'Distance', true);
        $nickname = parseInput($_POST['insertPokemonNickname'], 'str', 'Nickname', true);
        $type1 = parseInput($_POST['insertPokemonType1'], 'str', 'Type 1');
        $type2 = parseInput($_POST['insertPokemonType2'], 'str', 'Type 2', true);
        $hp = parseInput($_POST['insertPokemonHP'], 'int', 'Health Points');
        $attack = parseInput($_POST['insertPokemonAttack'], 'int', 'Attack');
        $gymcountry = parseInput($_POST['insertPokemonGymCountry'], 'str', 'Gym Country', true);
        $gympostalcode = parseInput($_POST['insertPokemonGymPostalCode'], 'str', 'Gym Postal Code', true);
        $gymname = parseInput($_POST['insertPokemonGymName'], 'str', 'Gym Name', true);
        $stationeddate = parseInput($_POST['insertPokemonStationedDate'], 'date', 'Stationed at Date', true);
        $foundcountry = parseInput($_POST['insertPokemonFoundCountry'], 'str', 'Found Country', true);
        $foundpostalcode = parseInput($_POST['insertPokemonFoundPostalCode'], 'str', 'Found Postal Code', true);
        $foundname = parseInput($_POST['insertPokemonFoundName'], 'str', 'Found Name', true);
    } catch(Exception $e) {
        alertUser($e->getMessage());
        return;
    }
    if (keysInTable('Pokemon', ['ID' => $id])) {
        alertUser("Input for Pokemon ID must be unique");
        return;
    }
    $values = valuesJoin([$speciesname, $type1, $type2]);
    if (!keysInTable('PokemonSpeciesTypes', ["SpeciesName" => $speciesname])) {
        executePlainSQL("INSERT INTO PokemonSpeciesTypes VALUES ($values)");
    }
    $values = valuesJoin([$speciesname, $cp, $attack, $hp]);
    if (!keysInTable('PokemonSpeciesCP', ["SpeciesName" => $speciesname])) {
        executePlainSQL("INSERT INTO PokemonSpeciesCP VALUES ($values)");
    }
    $locationTuple = ['Country' => $gymcountry, 'PostalCode' => $gympostalcode, 'Name' => $gymname];
    $anyNonNull = !inputIsNull($gymcountry) || !inputIsNull($gympostalcode) || !inputIsNull($gymname);
    if ($anyNonNull && !keysInTable('Location', $locationTuple)) {
        alertUser("Input for Gym Country, Gym Postal Code, Gym Name must be in the Location table");
        return;
    }
    $locationTuple = ['Country' => $foundcountry, 'PostalCode' => $foundpostalcode, 'Name' => $foundname];
    $anyNonNull = !inputIsNull($foundcountry) || !inputIsNull($foundpostalcode) || !inputIsNull($foundname);
    if ($anyNonNull && !keysInTable('Location', $locationTuple)) {
        alertUser("Input for Found Country, Found Postal Code, Found Name must be in the Location table");
        return;
    }
    $values = valuesJoin([
        $id, $speciesname, $cp, $distance, $nickname,
        $gymcountry, $gympostalcode, $gymname, $stationeddate,
        $foundcountry, $foundpostalcode, $foundname
    ]);
    executePlainSQL("INSERT INTO Pokemon VALUES ($values)");
    OCICommit($db_conn);
}

foreach (["Player", "Item", "Pokemon"] as $table) {
    handleRequests($_POST, "insert$table" . "Submit");
}

?>
</div>
