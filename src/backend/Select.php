<div class="query">
  <h2>Search Players</h2>
  <p>Left OR/AND takes priority</p>
  <form method="GET" action="PokeDataDex.php">
    <input type="hidden" name="select" id="select">
    <div class="query-inputbox">
      <label class="modify-item">Username</label>
      <input type="text" id="userNameValue" name="userNameValue", value="None"></input>
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
      <input type="number" id="userXP" name="userXP", value="-1"></input>
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
      <input type="text" id="userTeam" name="userTeam" value="None"></input>
      <select id="userTeamOperator" name="userTeamOperator">
        <option selected value="Exact">==</option>
        <option value="Ends">Ends With (%s)</option>
        <option value="Starts">Starts With (s%)</option>
        <option value="Has">Has (%s%)</option>
      </select>
    </div>
      <input type="submit" value="Submit">
  </form>
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
  $queryBase = "(SELECT * FROM Player p WHERE ";
  $query= "";

  if($_GET["userNameValue"] != "None") {
    $toFind = handleWildcards($_GET["userNameValue"], $_GET["userNameOperator"]);
    $query = $query . $queryBase . "p.Username LIKE $toFind )" . $_GET["userNameSelect"] . " "; 
  }

  if($_GET["userXP"] != -1) {
    $query = $query . $queryBase . "p.XP " . $_GET["userXPOperator"] . " " . $_GET["userXP"] . ") " . $_GET["userXPSelect"] . " "; 
  }

  if($_GET["userTeam"] != "None") {
    $toFind = handleWildcards($_GET["userTeam"], $_GET["userTeamOperator"]);
    $query = $query . $queryBase . "p.TeamName LIKE $toFind )";
  }

  $query = trim($query, " UNION ");
  $query = trim($query, " INTERSECT ");

  if ($query == "") {
    $query = "SELECT * FROM Player";
  }

  $result = executePlainSQL($query);
  printResult($result);
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
