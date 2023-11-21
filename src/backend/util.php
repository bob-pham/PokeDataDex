<?php
$success = True; //keep track of errors so it redirects the page only if there are no errors
$db_conn = NULL; // edit the login credentials in connectToDB()
$show_debug_alert_messages = False; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())

function executePlainSQL($cmdstr, $logging = true) {
  //takes a plain (no bound variables) SQL command and executes it
  global $db_conn, $success;

  $statement = OCIParse($db_conn, $cmdstr);
  //There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

  if (!$statement) {
    if ($logging) {
      echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
      $e = OCI_Error($db_conn); // For OCIParse errors pass the connection handle
      echo htmlentities($e['message']);
    }
    $success = False;
  }
  
  $r = OCIExecute($statement, OCI_DEFAULT);

  if (!$r) {
    if ($logging) {
      echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
      $e = oci_error($statement); // For OCIExecute errors pass the statementhandle
      echo htmlentities($e['message']);
    }
    $success = False;
  }

	return $statement;
}


function executeBoundSQL($cmdstr, $list) {
/* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
In this case you don't need to create the statement several times. Bound variables cause a statement to only be parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
See the sample code below for how this function is used */

  global $db_conn, $success;
  $statement = OCIParse($db_conn, $cmdstr);

  if (!$statement) {
    echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
    $e = OCI_Error($db_conn);
    echo htmlentities($e['message']);
    $success = False;
  }

  foreach ($list as $tuple) {
    foreach ($tuple as $bind => $val) {
      //echo $val;
      //echo "<br>".$bind."<br>";
      OCIBindByName($statement, $bind, $val);
      unset ($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
	  }

    $r = OCIExecute($statement, OCI_DEFAULT);

    if (!$r) {
      echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
      $e = OCI_Error($statement); // For OCIExecute errors, pass the statementhandle
      echo htmlentities($e['message']);
      echo "<br>";
      $success = False;
    }
  }
}

function keyInTable($table, $key, $value) {
  $result = executePlainSQL("SELECT $key FROM $table WHERE $key = $value", false);
  if (!OCI_Fetch_Array($result, OCI_ASSOC | OCI_RETURN_NULLS)) {
    return false;
  }
  return true;
}

function valuesJoin($values) {
  for ($idx = 0; $idx < sizeof($values); $idx++) {
    if (inputIsNull($values[$idx])) {
      $values[$idx] = 'NULL';
    }
  }
  return join(', ', $values);
}

function valuesJoinByName($values, $names) {
  $res = "";
  for ($idx = 0; $idx < sizeof($values); $idx++) {
    if (in_array($values[$idx], ["", "''"])) {
      continue;
    } else if (in_array(strtolower($values[$idx]), ["null", "'null'"])) {
      $values[$idx] = 'NULL';
    }
    if ($idx !== 0) {
      $res .= ", ";
    }
    $res .= "$names[$idx] = $values[$idx]";
  }
  return $res;
}

function inputIsNull($input) {
  return in_array(strtolower($input), ["", "''", "null", "'null'"]);
}

function printResult($result) { //prints results from a select statement
  // echo "<br>Retrieved data from table Player:<br>";
  echo '<div class="result-table">';
  echo "<table>";
  $header = "<tr>";

  $num_columns = OCI_Num_Fields($result);
  for ($i = 1; $i <= $num_columns; $i++) {
    $header = $header . "<th>" . OCI_Field_Name($result, $i) . "</th>";
  }
  $header = $header . "</tr>";
  echo $header;
    
  while (($row = OCI_Fetch_Array($result, OCI_ASSOC | OCI_RETURN_NULLS)) != false) {
    $temp_row = "";
    foreach ($row as $cell) {
      if ($cell === null) {
        $temp_row = $temp_row . "<td>N/A</td>";
      } else {
        $temp_row = $temp_row . "<td>" . $cell . "</td>";
      }
    }
    echo "<tr>" . $temp_row . "</tr>";
  }
  echo "</table>";
  echo '</div>';
}

function connectToDB() {
  global $db_conn;

  // Your username is ora_(CWL_ID) and the password is a(student number). For example,
  // ora_platypus is the username and a12345678 is the password.
  $db_conn = OCILogon(ORACLE_USER, ORACLE_PSSWD, "dbhost.students.cs.ubc.ca:1522/stu");

  if ($db_conn) {
    return true;
  } else {
    $e = OCI_Error(); // For OCILogon errors pass no handle
    echo htmlentities($e['message']);
    return false;
  }
}

function disconnectFromDB() {
  global $db_conn;

  OCILogoff($db_conn);
}

?>
