<div class="subsection">
  <h2>Update a Value in Table:</h2>
  <div class="subsection">
  <form method="POST" action="PokeDataDex.php">
    <select id="select" onChange="handleSelection(value)">
      <option selected value="update-select">Select a table </option>
      <option value="update-player">Player </option>
      <option value="update-item">Item </option>
      <option value="update-pokemon">Pokemon </option>
  </select>
  </form>
  <p class="modify-item">
        The values are case sensitive and if you enter in the wrong case, the update statement will not do anything.
        Fields with no values entered will not be updated, enter NULL to change field to null value.
  </p>
  </div>
  <div class="modify">
  <form method="POST" action="PokeDataDex.php">
    <input type="hidden" id="updateRequest" name="updateRequest">
    <div class="hide" id="update-player">
      <label class="modify-item">Username: </label>
      <input type="text" name="updatePlayerUsername"></input>
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
      <label class="modify-item">Name: </label>
      <input type="text" name="updateItemName"></input>
      <label class="modify-item">Cost (optional)</label>
      <input type="text" name="updateItemCost"></input>
      <label class="modify-item">Effect: </label>
      <input type="text" name="updateItemEffect"></input>
      <label class="modify-item">Type: </label>
      <input type="text" name="updateItemType"></input>
      <label class="modify-item">Uses (optional): </label>
      <input type="text" name="updateItemUses"></input>
      <div class="subsection">
        <input type="submit" value="Update" name="updateItemSubmit">
      </div>
    </div>
    <div class="hide" id="update-pokemon">
        <label class="modify-item">ID: </label>
        <input type="text" name="updatePokemonID"></input>
        <label class="modify-item">Species Name: </label>
        <input type="text" name="updatePokemonSpeciesName"></input>
        <label class="modify-item">Combat Score: </label>
        <input type="text" name="updatePokemonCP"></input>
        <label class="modify-item">Distance (optional): </label>
        <input type="text" name="updatePokemonDistance"></input>
        <label class="modify-item">Nickname (optional): </label>
        <input type="text" name="updatePokemonNickname"></input>
        <label class="modify-item">Type1: </label>
        <input type="text" name="updatePokemonType1"></input>
        <label class="modify-item">Type2 (optional): </label>
        <input type="text" name="updatePokemonType2"></input>
        <label class="modify-item">Health Points: </label>
        <input type="text" name="updatePokemonHP"></input>
        <label class="modify-item">Attack: </label>
        <input type="text" name="updatePokemonAttack"></input>
        <label class="modify-item">Gym Country (optional): </label>
        <input type="text" name="updatePokemonGymCountry"></input>
        <label class="modify-item">Gym Postal Code (optional): </label>
        <input type="text" name="updatePokemonGymPostalCode"></input>
        <label class="modify-item">Gym Name (optional): </label>
        <input type="text" name="updatePokemonGymName"></input>
        <label class="modify-item">Stationed at Date (optional): </label>
        <input type="text" name="updatePokemonStationedDate"></input>
        <label class="modify-item">Found Country (optional)</label>
        <input type="text" name="updatePokemonFoundCountry"></input>
        <label class="modify-item">Found Postal Code (optional): </label>
        <input type="text" name="updatePokemonFoundPostalCode"></input>
        <label class="modify-item">Found Name (optional): </label>
        <input type="text" name="updatePokemonFoundName"></input>
      <div class="subsection">
        <input type="submit" value="Update" name="updatePokemonSubmit">
      </div>
    </div>
  </form>
  </div>

<?php
include_once("./util.php");

function handleUpdatePlayerRequest() {
    global $db_conn;
    $username = "'" . $_POST['updatePlayerUsername'] . "'";
    $xp = $_POST['updatePlayerXP'];
    $teamname = "'" . $_POST['updatePlayerTeamName'] . "'";
    $level = $_POST['updatePlayerLevel'];

    $values = valuesJoin([$xp, $level]);
    if (!inputIsNull($xp) && !keyInTable('PlayerXpLevel', "XP", $xp)) {
        executePlainSQL("INSERT INTO PlayerXPLevel VALUES ($values)");
    }
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
    if (!inputIsNull($type) && !keyInTable('ItemTypeUses', "Type", $type)) {
        executePlainSQL("INSERT INTO ItemTypeUses VALUES ($values)");
    }
    $values = valuesJoin([$effect, $type]);
    if (!inputIsNull($effect) && !keyInTable('ItemEffectType', "Effect", $effect)) {
        executePlainSQL("INSERT INTO ItemEffectType VALUES ($values)");
    }
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
    if (!inputIsNull($speciesname) && !keyInTable('PokemonSpeciesTypes', "SpeciesName", $speciesname)) {
        executePlainSQL("INSERT INTO PokemonSpeciesTypes VALUES ($values)");
    }
    $values = valuesJoin([$speciesname, $cp, $attack, $hp]);
    if (!inputIsNull($speciesname) && !keyInTable('PokemonSpeciesCP', "SpeciesName", $speciesname)) {
        executePlainSQL("INSERT INTO PokemonSpeciesCP VALUES ($values)");
    }
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

foreach (["Player", "Item", "Pokemon"] as $table) {
    handleRequests($_POST, "Update$table");
}

?>
</div>
