<div class="query">
  <h2>Search Players</h2>
  <div class="section">
    <p class="modify-item">If no inputs are provided, default will show all rows</p>
    <p class="modify-item">Logic is read left to right</p>
    <p class="modify-item">Left OR/AND takes priority if XP is not selected</p>
  </div>
  <div>
  <form method="GET" action="PokeDataDex.php">
    <div class="section">
    <input type="hidden" name="select" id="select">
    <div class="query-inputbox">
      <label class="modify-item">Username</label>
      <input type="text" id="userNameValue" name="userNameValue", value=""></input>
      <select id="userNameOperator" name="userNameOperator">
        <option selected value="Exact">==</option>
        <option value="Ends">Ends With (%s)</option>
        <option value="Starts">Starts With (s%)</option>
        <option value="Has">Has (%s%)</option>
      </select>
      <select id="userNameSelect" name="userNameSelect">
        <option selected value="UNION">OR</option>

        <option value="INTERSECT">AND</option>
      </select>
      <label class="modify-item">XP</label>
      <input type="number" id="userXP" name="userXP", value=""></input>
      <select id="userXPOperator" name="userXPOperator">
        <option selected value=">">></option>
        <option value="<"><</option>
        <option value="=">=</option>
      </select>
      <select id="userXPSelect" name="userXPSelect">
        <option selected value="UNION">OR</option>
        <option value="INTERSECT">AND</option>
      </select>
      <label class="modify-item">TeamName</label>
      <input type="text" id="userTeam" name="userTeam" value=""></input>
      <select id="userTeamOperator" name="userTeamOperator">
        <option selected value="Exact">==</option>
        <option value="Ends">Ends With (%s)</option>
        <option value="Starts">Starts With (s%)</option>
        <option value="Has">Has (%s%)</option>
      </select>
    </div>
    <input type="submit" value="Submit">
    </div>
  </form>
  </div>
<?php
include_once("./util.php");

function handleWildcards($field, $cards) {
  if ($field == "") {
    return "'%'";
  }
  switch ($cards) {
    case "Exact":
      return "'$field'";
    case "Ends":
      return "'%$field'";
    case "Starts":
      return "'$field%'";
    case "Has":
      return "'%$field%'";
    default:
      return "'$field'";
  }
}
  
function selectQuery() {
  try {
    $queryBase = "(SELECT * FROM Player p WHERE ";
    $query= "";

    $userNameValue = str_replace("'", "", parseInput($_GET["userNameValue"], "char_15", "Username", True));
    $userXP = str_replace("'", "", parseInput($_GET["userXP"], "int", "XP", True));
    $userTeam = str_replace("'", "", parseInput($_GET["userTeam"], "char_8", "Team", True));

    if($userNameValue != "") {
      $toFind = handleWildcards($userNameValue , $_GET["userNameOperator"]);
      $query = $query . $queryBase . "TRIM(p.Username) LIKE $toFind ) " . $_GET["userNameSelect"] . " "; 
    }

    if($userXP != "") {
      $query = $query . $queryBase . "p.XP " . $_GET["userXPOperator"] . " " . $userXP . ") " . $_GET["userXPSelect"] . " "; 
    }

    if($userTeam != "") {
      $toFind = handleWildcards($userTeam, $_GET["userTeamOperator"]);
      $query = $query . $queryBase . "TRIM(p.TeamName) LIKE $toFind )";
    }

    $query = trim($query, " UNION ");
    $query = trim($query, " INTERSECT ");

    if ($query == "") {
      $query = "SELECT * FROM Player";
    }

    $result = executePlainSQL($query);
    printResult($result);
    return;
  } catch(Exception $e) {
      alertUser($e->getMessage());
      return;
  }
}


if (isset($_GET["select"])) {
  global $db_conn;
  if ($db_conn == NULL) {
    connectToDB();
  }
  selectQuery();
  disconnectFromDB();
}

?>
</div>
