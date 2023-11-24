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
        <label class="modify-item">Type1: </label>
        <input type="text" name="insertPokemonType1"></input>
        <label class="modify-item">Type2 (optional): </label>
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
        <label class="modify-item">Stationed at Date (optional): </label>
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
    $username = "'" . $_POST['insertPlayerUsername'] . "'";
    $xp = $_POST['insertPlayerXP'];
    $teamname = "'" . $_POST['insertPlayerTeamName'] . "'";
    $level = $_POST['insertPlayerLevel'];

    $values = valuesJoin([$xp, $level]);
    if (!keyInTable('PlayerXPLevel', "XP", $xp)) {
        executePlainSQL("INSERT INTO PlayerXPLevel VALUES ($values)");
    }
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
    if (!keyInTable('ItemTypeUses', "Type", $type)) {
        executePlainSQL("INSERT INTO ItemTypeUses VALUES ($values)");
    }
    $values = valuesJoin([$effect, $type]);
    if (!keyInTable('ItemEffectType', "Effect", $effect)) {
        executePlainSQL("INSERT INTO ItemEffectType VALUES ($values)");
    }
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
    if (!keyInTable('PokemonSpeciesTypes', "SpeciesName", $speciesname)) {
        executePlainSQL("INSERT INTO PokemonSpeciesTypes VALUES ($values)");
    }
    $values = valuesJoin([$speciesname, $cp, $attack, $hp]);
    if (!keyInTable('PokemonSpeciesCP', "SpeciesName", $speciesname)) {
        executePlainSQL("INSERT INTO PokemonSpeciesCP VALUES ($values)");
    }
    $values = valuesJoin([
        $id, $speciesname, $cp, $distance, $nickname,
        $gymcountry, $gympostalcode, $gymname, $stationeddate,
        $foundcountry, $foundpostalcode, $foundname
    ]);
    executePlainSQL("INSERT INTO Pokemon VALUES ($values)");
    OCICommit($db_conn);
}

handleRequests("Insert");

?>
</div>
