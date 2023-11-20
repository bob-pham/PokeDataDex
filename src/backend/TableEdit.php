<div>
  <h2>Insert Values into Table:</h2>
  <form method="POST" action="PokeDataDex.php">
    <select id="select" onChange="handleSelection(value)">
      <option selected value="insert-select">Select a table</option>
      <option value="insert-player">Player</option>
      <option value="insert-item">Item</option>
      <option value="insert-pokemon">Pokemon</option>
    </select>
  </form>
  <form method="POST" action="PokeDataDex.php">
    <input type="hidden" id="insertRequest" name="insertRequest">
    <div class="hide" id="insert-player">
      Username: <input type="text" name="insertPlayerUsername"></input><br />
      XP: <input type="text" name="insertPlayerXP"></input><br />
      Team Name: <input type="text" name="insertPlayerTeamName"></input><br />
      Level: <input type="text" name="insertPlayerLevel"></input><br />
  <input type="submit" value="Insert" name="insertPlayerSubmit"></p>
  </div>
  <div class="hide" id="insert-item">
    Name: <input type="text" name="insertItemName"></input><br />
    Cost (optional): <input type="text" name="insertItemCost"></input><br />
    Effect: <input type="text" name="insertItemEffect"></input><br />
    Type: <input type="text" name="insertItemType"></input><br />
    Uses (optional): <input type="text" name="insertItemUses"></input><br />
  <input type="submit" value="Insert" name="insertItemSubmit"></p>
  </div>
  <div class="hide" id="insert-pokemon">
    ID: <input type="text" name="insertPokemonID"></input><br />
    Species Name: <input type="text" name="insertPokemonSpeciesName"></input><br />
    Combat Score: <input type="text" name="insertPokemonCP"></input><br />
    Distance (optional): <input type="text" name="insertPokemonDistance"></input><br />
    Nickname (optional): <input type="text" name="insertPokemonNickname"></input><br />
    Type1: <input type="text" name="insertPokemonType1"></input><br />
    Type2 (optional): <input type="text" name="insertPokemonType2"></input><br />
    Health Points: <input type="text" name="insertPokemonHP"></input><br />
    Attack: <input type="text" name="insertPokemonAttack"></input><br />
    Gym Country (optional): <input type="text" name="insertPokemonGymCountry"></input><br />
    Gym Postal Code (optional): <input type="text" name="insertPokemonGymPostalCode"></input><br />
    Gym Name (optional): <input type="text" name="insertPokemonGymName"></input><br />
    Stationed at Date (optional): <input type="text" name="insertPokemonStationedDate"></input><br />
    Found Country (optional): <input type="text" name="insertPokemonFoundCountry"></input><br />
    Found Postal Code (optional): <input type="text" name="insertPokemonFoundPostalCode"></input><br />
    Found Name (optional): <input type="text" name="insertPokemonFoundName"></input><br />
    <input type="submit" value="Insert" name="insertPokemonSubmit"></p>
  </div>
  </form>
  <hr />
  <h2>Update a Value in Table:</h2>
  <form method="POST" action="PokeDataDex.php">
    <select id="select" onChange="handleSelection(value)">
      <option selected value="update-select">Select a table </option>
      <option value="update-player">Player </option>
      <option value="update-item">Item </option>
      <option value="update-pokemon">Pokemon </option>
  </select>
    <p>The values are case sensitive and if you enter in the wrong case, the update statement will not do anything.</p>
  </form>

  <form method="POST" action="PokeDataDex.php">
    <input type="hidden" id="updateRequest" name="updateRequest">
    <div class="hide" id="update-player">
    Username: <input type="text" name="updatePlayerUsername"></input><br />
    XP: <input type="text" name="updatePlayerXP"></input><br />
    Team Name: <input type="text" name="updatePlayerTeamName"></input><br />
    Level: <input type="text" name="updatePlayerLevel"></input><br />
    <input type="submit" value="Update" name="updatePlayerSubmit"></p>
    </div>
    <div class="hide" id="update-item">
      Name: <input type="text" name="updateItemName"></input><br />
      Cost (optional): <input type="text" name="updateItemCost"></input><br />
      Effect: <input type="text" name="updateItemEffect"></input><br />
      Type: <input type="text" name="updateItemType"></input><br />
      Uses (optional): <input type="text" name="updateItemUses"></input><br />
      <input type="submit" value="Update" name="updateItemSubmit"></p>
    </div>
    <div class="hide" id="update-pokemon">
      ID: <input type="text" name="updatePokemonID"></input><br />
      Species Name: <input type="text" name="updatePokemonSpeciesName"></input><br />
      Combat Score: <input type="text" name="updatePokemonCP"></input><br />
      Distance (optional): <input type="text" name="updatePokemonDistance"></input><br />
      Nickname (optional): <input type="text" name="updatePokemonNickname"></input><br />
      Type1: <input type="text" name="updatePokemonType1"></input><br />
      Type2 (optional): <input type="text" name="updatePokemonType2"></input><br />
      Health Points: <input type="text" name="updatePokemonHP"></input><br />
      Attack: <input type="text" name="updatePokemonAttack"></input><br />
      Gym Country (optional): <input type="text" name="updatePokemonGymCountry"></input><br />
      Gym Postal Code (optional): <input type="text" name="updatePokemonGymPostalCode"></input><br />
      Gym Name (optional): <input type="text" name="updatePokemonGymName"></input><br />
      Stationed at Date (optional): <input type="text" name="updatePokemonStationedDate"></input><br />
      Found Country (optional): <input type="text" name="updatePokemonFoundCountry"></input><br />
      Found Postal Code (optional): <input type="text" name="updatePokemonFoundPostalCode"></input><br />
      Found Name (optional): <input type="text" name="updatePokemonFoundName"></input><br />
      <input type="submit" value="Update" name="updatePokemonSubmit"></p>
    </div>
    </form>

    <hr />

    <h2>Delete a Value in Table:
    <select id="select" onChange="handleSelection(value)">
      <option selected value="delete-select">Select a table </option>
      <option value="delete-player">Player </option>
      <option value="delete-item">Item </option>
      <option value="delete-pokemon">Pokemon </option>
    </select>
    </h2>
    <p>The values are case sensitive and if you enter in the wrong case, the delete statement will not do anything.</p>

  <form method="POST" action="PokeDataDex.php">
    <input type="hidden" id="deleteRequest" name="deleteRequest">
    <div class="hide" id="delete-player">
      Username: <input type="text" name="deletePlayerUsername"></input><br />
      <input type="submit" value="Delete" name="deletePlayerSubmit"></p>
    </div>
    <div class="hide" id="delete-item">
      Name: <input type="text" name="deleteItemName"></input><br />
      <input type="submit" value="Delete" name="deleteItemSubmit"></p>
    </div>
    <div class="hide" id="delete-pokemon">
      ID: <input type="text" name="deletePokemonID"></input><br />
      <input type="submit" value="Delete" name="deletePokemonSubmit"></p>
    </div>
  </form>
</div>
<script>
<?php
  include("./js/helper.js")
?>
</script>
<?php
include_once("./util.php");

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

function handleUpdatePlayerRequest() {
    global $db_conn;
    $username = "'" . $_POST['updatePlayerUsername'] . "'";
    $xp = $_POST['updatePlayerXP'];
    $teamname = "'" . $_POST['updatePlayerTeamName'] . "'";
    $level = $_POST['updatePlayerLevel'];

    $values = valuesJoin([$xp, $level]);
    executePlainSQL("INSERT INTO PlayerXPLevel VALUES ($values)");
    $values = valuesJoinByName([$username, $xp, $teamname], ["Username", "XP", "TeamName"]);
    executePlainSQL("UPDATE Player SET $values WHERE Username = $username");
    OCICommit($db_conn);
}

function handleUpdateItemRequest() {
    global $db_conn;
    $name = "'" . $_POST['updateItemName'] . "'";
    $cost = $_POST['updateItemCost'];
    $effect = "'" . $_POST['updateItemEffect'] . "'";
    $type = "'" . $_POST['updateItemType'] . "'";
    $uses = $_POST['updateItemUses'];

    $values = valuesJoin([$type, $uses]);
    executePlainSQL("INSERT INTO ItemTypeUses VALUES ($values)");
    $values = valuesJoin([$effect, $type]);
    executePlainSQL("INSERT INTO ItemEffectType VALUES ($values)");
    $values = valuesJoinByName([$name, $cost, $effect], ["Name", "Cost", "Effect"]);
    executePlainSQL("UPDATE Item SET $values WHERE name = $name");
    OCICommit($db_conn);
}

function handleUpdatePokemonRequest() {
    global $db_conn;
    $id = $_POST['updatePokemonID'];
    $speciesname = "'" . $_POST['updatePokemonSpeciesName'] . "'";
    $cp = $_POST['updatePokemonCP'];
    $distance = $_POST['updatePokemonDistance'];
    $nickname =  "'" . $_POST['updatePokemonNickname'] . "'";
    $type1 = "'" . $_POST['updatePokemonType1'] . "'";
    $type2 = "'" . $_POST['updatePokemonType2'] . "'";
    $hp = $_POST['updatePokemonHP'];
    $attack = $_POST['updatePokemonAttack'];
    $gymcountry = "'" . $_POST['updatePokemonGymCountry'] . "'";
    $gympostalcode = "'" . $_POST['updatePokemonGymPostalCode'] . "'";
    $gymname = "'" . $_POST['updatePokemonGymName'] . "'";
    $stationeddate = "'" . $_POST['updatePokemonStationedDate'] . "'";
    $foundcountry = "'" . $_POST['updatePokemonFoundCountry'] . "'";
    $foundpostalcode = "'" . $_POST['updatePokemonFoundPostalCode'] . "'";
    $foundname = "'" . $_POST['updatePokemonFoundName'] . "'";

    $values = valuesJoin([$speciesname, $type1, $type2]);
    executePlainSQL("INSERT INTO PokemonSpeciesTypes VALUES ($values)");
    $values = valuesJoin([$speciesname, $cp, $attack, $hp]);
    executePlainSQL("INSERT INTO PokemonSpeciesCP VALUES ($values)");
    $values = valuesJoinByName([
        $id, $speciesname, $cp, $distance, $nickname, $gymcountry, $gympostalcode, $gymname,
        $stationeddate, $foundcountry, $foundpostalcode, $foundname
    ], [
        "ID", "SpeciesName", "CP", "Distance", "Nickname", "GymCountry", "GymPostalCode", "GymName",
        "StationedAtDate", "FoundCountry", "FoundPostalCode", "FoundName"
    ]);
    executePlainSQL("UPDATE Pokemon SET $values WHERE ID = $id");
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
?>
