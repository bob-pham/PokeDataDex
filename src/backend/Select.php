<div class="query">
  <form method="GET" action="PokeDataDex.php">
    <input type="hidden" id="selectUIRequest" name="selectUIRequest">
    <label>Main</label>
    <select name="main" id="main">
      <option value="Player">Player</option>
      <option value="Mission">Mission</option>
      <option value="Pokemon">Pokemon</option>
      <option value="Battle">Battle</option>
      <option value="NPCSighting">NPCSighting</option>
    </select>
    Name: <input type="text" name="valueName" default="None">
    <label>Associated with</label>
    <select name="secondary" id="secondary">
      <option value="None">N/A</option>
      <option value="Team">Team</option>
      <option value="Player">Player</option>
      <option value="Item">Item</option>
      <option value="Mission">Mission</option>
      <option value="Location">Location</option>
      <option value="Gym">Gym</option>
      <option value="Pokestop">Pokestop</option>
      <option value="Egg">Egg</option>
      <option value="Pokemon">Pokemon</option>
      <option value="Species">Species</option>
      <option value="Battle">Battle</option>
    </select>
    <input type="submit" value="Submit">
  </form>
<?php
include_once("./util.php");

function handleSelectUIRequest() {
  // These are for basic queries
  global $db_conn;
  $from = $_GET["main"];
  if ($_GET["secondary"] !== "None") {
    $from = $from . "" . $_GET["secondary"];
    echo "<h1>this executed</h1>";
  }
  $result = executePlainSQL("SELECT * FROM " . $_GET["main"]);
  printResult($result);
}

if (isset($_GET["selectUIRequest"])) {
  if ($db_conn == NULL) {
    connectToDB();
  }
  handleSelectUIRequest();
}

?>
</div>
