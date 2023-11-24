<div class="subsection">
  <h4>Delete a Value in Table:</h4>
  <div class="subsection">
    <select id="select" onChange="handleSelection(value)">
      <option selected value="delete-select">Select a table </option>
      <option value="delete-player">Player </option>
      <option value="delete-item">Item </option>
      <option value="delete-pokemon">Pokemon </option>
    </select>
    <p class="modify-item">The values are case sensitive and if you enter in the wrong case, the delete statement will not do anything.</p>
  </div>

  <div class="modify">
  <form method="POST" action="PokeDataDex.php">
    <input type="hidden" id="deleteRequest" name="deleteRequest">
    <div class="hide" id="delete-player">
        <label class="modify-item">Username: </label>
        <input type="text" name="deletePlayerUsername"></input>
      <input type="submit" value="Delete" name="deletePlayerSubmit">
    </div>
    <div class="hide" id="delete-item">
        <label class="modify-item">Name: </label>
        <input type="text" name="deleteItemName"></input>
      <input type="submit" value="Delete" name="deleteItemSubmit">
    </div>
    <div class="hide" id="delete-pokemon">
        <label class="modify-item">ID: </label>
        <input type="text" name="deletePokemonID"></input>
      <input type="submit" value="Delete" name="deletePokemonSubmit">
    </div>
  </form>
  </div>
  <?php
  include_once("./Reset.php");
  ?>
<?php
include_once("./util.php");

function handleDeletePlayerRequest() {
    global $db_conn;
    $username = $_POST['deletePlayerUsername'];
    executePlainSQL("DELETE FROM Player WHERE Username = '$username'");
    OCICommit($db_conn);
}

function handleDeleteItemRequest() {
    global $db_conn;
    $name = $_POST['deleteItemName'];
    executePlainSQL("DELETE FROM Item WHERE Name = '$name'");
    OCICommit($db_conn);
}

function handleDeletePokemonRequest() {
    global $db_conn;
    $id = $_POST['deletePokemonID'];
    executePlainSQL("DELETE FROM Pokemon WHERE ID = '$id'");
    OCICommit($db_conn);
}

handleRequests("Delete");
?>
</div>
