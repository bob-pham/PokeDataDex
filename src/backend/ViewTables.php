<div class="query">
  <h2>View Database</h2>
  <form method="GET" action="PokeDataDex.php">
    <input type="hidden" id="viewTables" name="viewTables">
    <select name="tableToView" id="tableToView">
      <option value="None">N/A</option>
      <option value="Team">Team</option>
      <option value="MascotColour">MascotColour</option>
      <option value="Player">Player</option>
      <option value="PlayerXPLevel">PlayerXPLevel</option>
      <option value="Item">Item</option>
      <option value="ItemEffectType">ItemEffectType</option>
      <option value="ItemTypeUses">ItemTypeUses</option>
      <option value="Mission">Mission</option>
      <option value="MissionEventNameXP">MissionEventNameXP</option>
      <option value="Location">Location</option>
      <option value="BiomeAttackBonus">BiomeAttackBonus</option>
      <option value="Gym">Gym</option>
      <option value="Pokestop">Pokestop</option>
      <option value="Egg">Egg</option>
      <option value="EggSpecies">EggSpecies</option>
      <option value="Pokemon">Pokemon</option>
      <option value="PokemonSpeciesCP">PokemonSpeciesCP</option>
      <option value="PokemonSpeciesTypes">PokemonSpeciesTypes</option>
      <option value="NPC">NPC</option>
      <option value="RoleCanBattle">RoleCanBattle</option>
      <option value="PlayerOwnsItem">PlayerOwnsItem</option>
      <option value="PlayerCompletedMission">PlayerCompletedMission</option>
      <option value="Battle">Battle</option>
      <option value="LeagueMaxCP">LeagueMaxCP</option>
      <option value="PlayerCapturedPokemon">PlayerCapturedPokemon</option>
      <option value="PlayerCapturedEgg">PlayerCapturedEgg</option>
      <option value="PlayerVisitedPokestop">PlayerVisitedPokestop</option>
      <option value="NPCAppearedAtPokestop">NPCAppearedAtPokestop</option>
      <option value="NPCSighting">NPCSighting</option>
      <option value="NPCSightingEventName">NPCSightingEventName</option>
    </select>
    <input type="submit" value="Submit">
  </form>
<?php
include_once("./util.php");

function viewTables() {
  // These are for basic queries
  global $db_conn;
  $table = $_GET["tableToView"];
  if ($table === "None") {
    return;
  }
  $result = executePlainSQL("SELECT Count(*) FROM $table");
  if (($row = oci_fetch_row($result)) != false) {
    echo '<div class="subheader">';
    echo "<p> We Found " . $row[0] . " Results for $table!</p>";
    echo '</div>';
  }
  $result = executePlainSQL("SELECT * FROM " . $table);
  printResult($result);
}

handleRequests($_GET, "viewTables");

?>
</div>
