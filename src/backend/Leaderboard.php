<div class="query">
  <h2>Leaderboards</h2>
  <form method="GET" class="query-section" action="PokeDataDex.php">
    <input type="hidden" name="leaderboard" id="leaderboard">
    <select name="leaderboardType" id="leaderboardType" onChange="leaderboardInputToggle(value)">
      <option value="None">N/A</option>
      <option value="Highest Level">Players with Highest Level</option>
      <option value="Most Pokemon">Players with most Pokemon</option>
      <option value="Most Items">Players with most Items</option>
      <option value="Most Battles Won">Players Won the most Battles</option>
      <option value="Strongest Pokemon">Strongest Pokemon</option>
      <option value="All Missions">Players Who Completed All Missions</option>
      <option value="Team All Missions">Teams with Most Players Who Completed All Missions</option>
      <option value="Team with Battled Players">Teams with Most Players Who Done a Battle</option>
      <option value="Player's Strongest Pokemon">Player's Strongest pokemon for each Type</option>
      <option value="Teams with N Players">Teams with at least N players</option>
      <option value="Teams Who Own the Most Species Name">Teams Who Own the Most of a Certain Pokemon Species</option>
    </select>
    <div class="query-input hide" id="value-input">
      <label class="query-item query-label" id="value-input-label" for="valueName"></label>
      <input class="query-item query-input-box" type="text" id="valueName" name="valueName">
      </div>
    <div class="query-input hide" id="count-input">
      <label class="query-item query-label" for="count">Max Rows:</label>
      <input class="query-item query-input-box" type="number" id="count" name="count" min="1" max="100" value="100">
    </div>
    <div class="query-input hide" id="query-submit">
      <input class="query-item" type="submit" value="Submit">
    </div>
  </form>
<?php
include_once("./util.php");


function highestLevel() {
  $query = 
  "SELECT p.Username as \"Player\", l.PlayerLevel
  FROM Player p, PlayerXPLevel l
  WHERE p.XP = l.XP
  ORDER BY p.XP DESC";

  return $query;
}

function mostPokemon() {
  $query = 
  "SELECT p.Username as \"Player \", COUNT(*) as \"# Caught\" 
  FROM Player p, PlayerCapturedPokemon pk 
  WHERE p.Username = pk.PlayerUsername 
  GROUP BY p.Username 
  HAVING COUNT(*) > 0 
  ORDER BY COUNT(*) DESC";

  return $query;
}

function mostItems() {
  $query = 
  "SELECT p.Username as \"Player \", COUNT(*) as \"# Owned\" 
  FROM Player p, PlayerOwnsItem pk 
  WHERE p.Username = pk.PlayerUsername 
  GROUP BY p.Username 
  HAVING COUNT(*) > 0 
  ORDER BY COUNT(*) DESC";

  return $query;
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

  return $query;
}

function mostBattlesWon() {
  $query = 
  "SELECT p.PlayerUsername1 as \"Player \", COUNT(*) as \"# Won\" 
  FROM Battle p 
  GROUP BY p.PlayerUsername1
  HAVING COUNT(*) > 0 
  ORDER BY COUNT(*) DESC";

  return $query;
}

function strongestPokemon() {
  $query = 
  "SELECT p.ID, p.SpeciesName, p.Nickname, p.CP
  FROM Pokemon p 
  ORDER BY p.CP DESC";

  return $query;
}

function teamAllMissions() {
  $query = 
  "SELECT p.TeamName as \"Team \", COUNT(*) as \"# Players\"
  FROM Player p
  WHERE NOT EXISTS ((SELECT m.Name
                    FROM Mission m)
                    MINUS
                    (SELECT pm.MissionName
                    FROM PlayerCompletedMission pm
                    WHERE pm.PlayerUsername = p.Username))
  GROUP BY p.TeamName
  ORDER BY COUNT(*) DESC";

  return $query;
}

function teamWithBattledPlayers() {
  $query =
  "SELECT p.TeamName as \"Team \", COUNT(*) as \"# Players\"
  FROM Player p
  WHERE p.Username IN (SELECT DISTINCT pl.Username
                       FROM Player pl, Battle b
                       WHERE (pl.Username = b.PlayerUsername1
                           or pl.Username = b.PlayerUsername2))
  GROUP BY p.TeamName
  ORDER BY COUNT(*) DESC";

  return $query;
}

function PlayersStrongestPokemon($playerUsername) {
  $query =
  "SELECT t.Type1 as \"First Type \", MAX(cp) as \"Combat Power\"
  FROM Pokemon p, PokemonSpeciesTypes t, PlayerCapturedPokemon c
  WHERE p.SpeciesName = t.SpeciesName AND p.ID = c.SpeciesID AND c.PlayerUsername = $playerUsername
  GROUP BY t.Type1";

  return $query;
}

function TeamsWithAtLeastNPlayers($n) {
  $query =
  "SELECT p.TeamName as \"Team \", COUNT(*) as \"# Players\"
  FROM Player p
  GROUP BY TeamName 
  HAVING COUNT(*) >= $n";

  return $query;
}

function teamsWithMostOwnedSpecies($species) {
  $query = 
  "SELECT pl.TeamName as \"Team \", COUNT(*) as \" # of $species \"  
  FROM  player pl JOIN (SELECT * FROM PLAYERCAPTUREDPOKEMON c JOIN POKEMON p ON (c.SpeciesID = p.ID)) j
  ON pl.Username = j.PlayerUsername
  WHERE j.SpeciesName = $species
  GROUP BY pl.TeamName
  ORDER BY COUNT(*) DESC";

  return $query;
}

if (isset($_GET["leaderboard"])) {
  global $db_conn;
  if ($db_conn == NULL) {
    connectToDB();
  }
  switch($_GET["leaderboardType"]) {
    case "Highest Level":
      $query = highestLevel();
      break;
    case "Most Pokemon":
      $query = mostPokemon();
      break;
    case "Most Items":
      $query = mostItems();
      break;
    case "All Missions":
      $query = allMissions();
      break;
    case "Most Battles Won":
      $query = mostBattlesWon();
      break;
    case "Strongest Pokemon":
      $query = strongestPokemon();
      break;
    case "Team All Missions":
      $query = teamAllMissions();
      break;
    case "Team with Battled Players":
      $query = teamWithBattledPlayers();
      break;
    case "Player's Strongest Pokemon":
      try {
        $query = PlayersStrongestPokemon(parseInput($_GET["valueName"], 'char_15', 'Player Username'));
      } catch(Exception $e) {
          alertUser($e->getMessage());
      }
      break;
    case "Teams with N Players":
      try {
        $query = TeamsWithAtLeastNPlayers(parseInput($_GET["valueName"], 'int', '# of Players'));
      } catch(Exception $e) {
          alertUser($e->getMessage());
      }
      break;
    case "Teams Who Own the Most Species Name":
      try {
        $query = teamsWithMostOwnedSpecies(parseInput($_GET["valueName"], 'char_20', 'Species Name'));
      } catch(Exception $e) {
          alertUser($e->getMessage());
      }
      break;
    default:
      break;
  }

  if (isset($query)) {
    $num = $_GET["count"];
    $query = $query . " FETCH NEXT " . $num. " ROWS ONLY";
    $result = executePlainSQL($query);
    printResult($result);
  }
  disconnectFromDB();
}
?>
</div>
