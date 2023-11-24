<div class="query">
  <h2>Leaderboards</h2>
  <form method="GET" action="PokeDataDex.php">
    <input type="hidden" name="leaderboard" id="leaderboard">
    <select name="leaderboardType" id="leaderboardType">
      <option value="None">N/A</option>
      <option value="Highest Level">Players with Highest Level</option>
      <option value="Most Pokemon">Players with most Pokemon</option>
      <option value="Most Items">Players with most Items</option>
      <option value="Most Battles Won">Players Won the most Battles</option>
      <option value="Strongest Pokemon">Strongest Pokemon</option>
      <option value="All Missions">Players Who Completed All Missions</option>
    </select>
    <input type="text" name="valueName" default="None">
    <input type="number" name="count" min="1" max="100" default="100">
    <input type="submit" value="Submit">
  </form>
<?php
include_once("./util.php");


function highestLevel() {
  $query = 
  "SELECT p.Username as \"Player\" 
  FROM Player p 
  ORDER BY p.XP DESC";

  $result = executePlainSQL($query);
  printResult($result);
}

function mostPokemon() {
  $query = 
  "SELECT p.Username as \"Player \", COUNT(*) as \"# Caught\" 
  FROM Player p, PlayerCapturedPokemon pk 
  WHERE p.Username = pk.PlayerUsername 
  GROUP BY p.Username 
  HAVING COUNT(*) > 0 
  ORDER BY COUNT(*) DESC";

  $result = executePlainSQL($query);
  printResult($result);
}

function mostItems() {
  $query = 
  "SELECT p.Username as \"Player \", COUNT(*) as \"# Owned\" 
  FROM Player p, PlayerOwnsItem pk 
  WHERE p.Username = pk.PlayerUsername 
  GROUP BY p.Username 
  HAVING COUNT(*) > 0 
  ORDER BY COUNT(*) DESC";

  $result = executePlainSQL($query);
  printResult($result);
}

function allMissions() {
  $query = 
  "SELECT p.Username
    FROM Player p 
    WHERE NOT EXISTS ((SELECT m.Name
                      FROM Mission m)
                      MINUS
                      (SELECT pm.MissionName
                      FROM PlayerCompletedMission pm 
                      WHERE pm.PlayerUsername = p.Username))";

  $result = executePlainSQL($query);
  printResult($result);
}

function mostBattlesWon() {
  $query = 
  "SELECT p.PlayerUsername1 as \"Player \", COUNT(*) as \"# Won\" 
  FROM Battle p 
  GROUP BY p.PlayerUsername1
  HAVING COUNT(*) > 0 
  ORDER BY COUNT(*) DESC";

  $result = executePlainSQL($query);
  printResult($result);
}

function strongestPokemon() {
  $query = 
  "SELECT p.ID, p.SpeciesName, p.Nickname, p.CP
  FROM Pokemon p 
  ORDER BY p.CP DESC";

  $result = executePlainSQL($query);
  printResult($result);
}

if (isset($_GET["leaderboard"])) {
  if ($db_conn == NULL) {
    connectToDB();
  }
  switch($_GET["leaderboardType"]) {
    case "Highest Level":
      highestLevel();
      break;
    case "Most Pokemon":
      mostPokemon();
      break;
    case "Most Items":
      mostItems();
      break;
    case "All Missions":
      allMissions();
      break;
    case "Most Battles Won":
      mostBattlesWon();
      break;
    case "Strongest Pokemon":
      strongestPokemon();
      break;
    default:
      break;
  }
  disconnectFromDB();
}
?>
</div>
