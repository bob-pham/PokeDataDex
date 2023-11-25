<div class="query">
  <h2>View Database</h2>
  <form method="GET" action="PokeDataDex.php">
    <input type="hidden" id="viewTables" name="viewTables">
    <select name="tableToView" id="tableToView">
      <option value="None">N/A</option>
      <option value="Team-MascotColour">Team</option>
      <option value="Player-PlayerXPLevel">Player</option>
      <option value="PlayerOwnsItem">PlayerOwnsItem</option>
      <option value="PlayerCompletedMission">PlayerCompletedMission</option>
      <option value="PlayerCapturedPokemon">PlayerCapturedPokemon</option>
      <option value="PlayerCapturedEgg">PlayerCapturedEgg</option>
      <option value="PlayerVisitedPokestop">PlayerVisitedPokestop</option>
      <option value="Item-ItemEffectType-ItemTypeUses">Item</option>
      <option value="Mission-MissionEventNameXP">Mission</option>
      <option value="Location-BiomeAttackBonus">Location</option>
      <option value="Gym-BiomeAttackBonus">Gym</option>
      <option value="Pokestop-BiomeAttackBonus">Pokestop</option>
      <option value="Egg-EggSpecies">Egg</option>
      <option value="Pokemon-PokemonSpeciesCP-PokemonSpeciesTypes">Pokemon</option>
      <option value="NPC-RoleCanBattle">NPC</option>
      <option value="Battle-LeagueMaxCP">Battle</option>
      <option value="NPCAppearedAtPokestop">NPCAppearedAtPokestop</option>
      <option value="NPCSighting-NPCSightingEventName">NPCSighting</option>
    </select>
    <input type="submit" value="Submit">
  </form>
<?php
include_once("./util.php");

function viewTables() {
  // These are for basic queries
  global $db_conn;
  $value = explode('-', $_GET["tableToView"]);
  $table = $value[0];

  if ($table === "None") {
    return;
  }

  $result = executePlainSQL("SELECT Count(*) FROM $table");
  if (($row = oci_fetch_row($result)) != false) {
    echo '<div class="subheader">';
    echo "<p> We Found " . $row[0] . " Results for $table!</p>";
    echo '</div>';
  }
  
  $to_select = implode(" NATURAL JOIN ", $value);
  $query = "SELECT * FROM " . $to_select;

  $result = executePlainSQL($query);
  printResult($result);
}

handleRequests($_GET, "viewTables");

?>
</div>
