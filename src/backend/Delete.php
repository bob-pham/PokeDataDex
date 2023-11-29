<!DOCTYPE html>
<html>
<head>
    <title>PokeDataDex</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital@1&family=Pixelify+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="icon" href="assets/logo.png" sizes="16x16" type="image.png">
    <link rel="stylesheet" type="text/css" href="styles/styles.css">
</head>
<body class="background">
<div class="header">
    <h1 class="header-text">PokeDataDex</h1>
    <h3 class="sub-header-text">By Bob Pham, Jason Wang, Stevan Zhuang</h3>
</div>
<div class="section">
    <h1 class="header-text">Home</h1>
    <div>
        <form action="PokeDataDex.php">
            <input type="submit" value="Home">
        </form>
    </div>
</div>

<div class="section">
<div class="subsection">
  <h2>Delete a Value in Table:</h2>
  <form method="POST" action="Delete.php">
    <select id="select" onChange="handleSelection(value)">
      <option selected value="delete-select">Select a table</option>
      <option value="delete-player">Player</option>
      <option value="delete-item">Item</option>
      <option value="delete-pokemon">Pokemon</option>
    </select>
  </form>
  <div class="modify">
  <form method="POST" action="Delete.php">
    <input type="hidden" id="deleteRequest" name="deleteRequest">
    <div class="hide" id="delete-player">
      <select name="deletePlayerSelect" id="deletePlayerSelect"></select>
      <input type="submit" value="Delete" name="deletePlayerSubmit">
    </div>
    <div class="hide" id="delete-item">
      <select name="deleteItemSelect" id="deleteItemSelect"></select>
      <input type="submit" value="Delete" name="deleteItemSubmit">
    </div>
    <div class="hide" id="delete-pokemon">
      <select name="deletePokemonSelect" id="deletePokemonSelect"></select>
      <input type="submit" value="Delete" name="deletePokemonSubmit">
    </div>
    <?php
    include_once("./util.php");
    function getUI() {
        global $db_conn;
        if ($db_conn == NULL) {
            connectToDB();
        }
        getSelectUI("delete");
        disconnectFromDB();
    }
    getUI()
    ?>
  </form>
  </div>
<?php
include_once("./util.php");

function handleDeletePlayerRequest() {
    global $db_conn;
    try {
        $username = parseInputSkip($_POST['deletePlayerSelect'], 'char_15', 'Username');
    } catch(Exception $e) {
        alertUser($e->getMessage());
        return;
    }
    executePlainSQL("DELETE FROM Player WHERE Username = $username");
    OCICommit($db_conn);
}

function handleDeleteItemRequest() {
    global $db_conn;
    try {
        $name = parseInputSkip($_POST['deleteItemSelect'], 'char_30', 'Name');
    } catch(Exception $e) {
        alertUser($e->getMessage());
        return;
    }
    executePlainSQL("DELETE FROM Item WHERE Name = $name");
    OCICommit($db_conn);
}

function handleDeletePokemonRequest() {
    global $db_conn;
    try {
        $id = parseInputSkip($_POST['deletePokemonSelect'], 'int', 'ID');
    } catch(Exception $e) {
        alertUser($e->getMessage());
        return;
    }
    executePlainSQL("DELETE FROM Pokemon WHERE ID = $id");
    OCICommit($db_conn);
}

foreach (["Player", "Item", "Pokemon"] as $table) {
    handleRequests($_POST, "delete$table" . "Submit");
}

?>
</div>
    <div class="section">
        <img src="assets/logo.png" type="image.png">
    </div>
    <script src="js/helper.js" defer></script>
</body>
</html>