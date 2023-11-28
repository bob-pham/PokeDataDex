<div class="query">
  <h2>View Database</h2>
  <form method="GET" id="viewTablesForm" class="section" action="PokeDataDex.php">
    <input type="hidden" id="viewTables" name="viewTables">
    <?php
include_once("./util.php");
function getTableNames() {
  $table_names = array();
  $result = executePlainSQL("SELECT table_name FROM user_tables");
  while (($row = OCI_Fetch_Array($result, OCI_ASSOC | OCI_RETURN_NULLS)) != false) {
    foreach ($row as $cell) {
      $table_names[] = $cell;
    }
  }
  return $table_names;
}

function getTableSelector($table_names) {
  $inputs = "<select id=\"TableSelector\" name=\"TableSelector\" onChange=\"showOnlySelected(value)\">";
  $inputs = $inputs . "<option value=\"None\" selected>None</option>";
  foreach ($table_names as $table) {
    $inputs = $inputs . "<option value=\"$table\">$table</option>";
  }
  $inputs = $inputs . "</select>";
  return $inputs;
}

function getInputRows($table_names) {
  $input_rows = "";
  foreach ($table_names as $tableName) {
    $input_rows = $input_rows . getRowInputs($tableName);
  } 
  return $input_rows;
}


function getRowInputs($tableName) {
  $inputs = "<div id=\"$tableName\" name=\"$tableName\" class=\"hide query-inputbox\">";
  $result = executePlainSQL("SELECT column_name FROM USER_TAB_COLUMNS WHERE table_name = '$tableName'");
  while (($row = OCI_Fetch_Array($result, OCI_ASSOC | OCI_RETURN_NULLS)) != false) {
    foreach ($row as $cell) {
      $name = $tableName . "-" . $cell;
      $inputs = $inputs . "<label class=\"modify-item\">$cell</label>";
      $inputs = $inputs . "<input type=\"checkbox\" id=\"$name\" name=\"$name\" value=\"$name\">";
    }
  }
  $inputs = $inputs . "</div>";
  return $inputs;
}

function getUI() {
  global $db_conn;
  if ($db_conn == NULL) {
    connectToDB();
  }
  
  $table_names = getTableNames();
  $table_selector = getTableSelector($table_names);
  $rows = getInputRows($table_names);
  echo $table_selector;
  echo $rows;

  disconnectFromDB();
}

getUI();
    ?>
    <input type="submit" value="Submit">
  </form>
<?php
include_once("./util.php");

function viewTables() {
  global $db_conn;
  $tableName = $_GET["TableSelector"];
  $columns = array();
  $columns_to_show = array();

  if ($tableName === "None") {
    return;
  }

  $result = executePlainSQL("SELECT column_name FROM USER_TAB_COLUMNS WHERE table_name = '$tableName'");
 
  while (($row = OCI_Fetch_Array($result, OCI_ASSOC | OCI_RETURN_NULLS)) != false) {
    foreach ($row as $cell) {
      $columns[] = $cell;
    }
  }

  foreach ($columns as $c){
    $name = $tableName . "-" . $c;
    if (isset($_GET[$name])){
      $columns_to_show[] = $c;
    }
  }

  $query = "SELECT " . implode(", ", $columns_to_show) . " FROM $tableName";
  $result = executePlainSQL($query);
  printResult($result);
}
handleRequests($_GET, "viewTables");
?>
</div>
