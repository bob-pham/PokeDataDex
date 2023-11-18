<div>
  <h2>Insert Values into Table:</h2>
  <form method="POST" action="PokeDataDex.php">
    <select id="select" onChange="handleSelection(value)">
      <option selected value="insert-select">Select a table</option>
      <option value="insert-player">Player</option>
      <option value="insert-item">Item</option>
      <option value="insert-pokemon">Pokemon</option>
    </select>
  </form>
  <form method="POST" action="PokeDataDex.php">
    <input type="hidden" id="insertRequest" name="insertRequest">
    <div class="hide" id="insert-player">
      Username: <input type="text" name="insertPlayerUsername"></input><br />
      XP: <input type="text" name="insertPlayerXP"></input><br />
      Team Name: <input type="text" name="insertPlayerTeamName"></input><br />
      Level: <input type="text" name="insertPlayerLevel"></input><br />
  <input type="submit" value="Insert" name="insertPlayerSubmit"></p>
  </div>
  <div class="hide" id="insert-item">
    Name: <input type="text" name="insertItemName"></input><br />
    Cost (optional): <input type="text" name="insertItemCost"></input><br />
    Effect: <input type="text" name="insertItemEffect"></input><br />
    Type: <input type="text" name="insertItemType"></input><br />
    Uses (optional): <input type="text" name="insertItemUses"></input><br />
  <input type="submit" value="Insert" name="insertItemSubmit"></p>
  </div>
  <div class="hide" id="insert-pokemon">
    ID: <input type="text" name="insertPokemonID"></input><br />
    Species Name: <input type="text" name="insertPokemonSpeciesName"></input><br />
    Combat Score: <input type="text" name="insertPokemonCP"></input><br />
    Distance (optional): <input type="text" name="insertPokemonDistance"></input><br />
    Nickname (optional): <input type="text" name="insertPokemonNickname"></input><br />
    Type1: <input type="text" name="insertPokemonType1"></input><br />
    Type2 (optional): <input type="text" name="insertPokemonType2"></input><br />
    Health Points: <input type="text" name="insertPokemonHP"></input><br />
    Attack: <input type="text" name="insertPokemonAttack"></input><br />
    Gym Country (optional): <input type="text" name="insertPokemonGymCountry"></input><br />
    Gym Postal Code (optional): <input type="text" name="insertPokemonGymPostalCode"></input><br />
    Gym Name (optional): <input type="text" name="insertPokemonGymName"></input><br />
    Stationed at Date (optional): <input type="text" name="insertPokemonStationedDate"></input><br />
    Found Country (optional): <input type="text" name="insertPokemonFoundCountry"></input><br />
    Found Postal Code (optional): <input type="text" name="insertPokemonFoundPostalCode"></input><br />
    Found Name (optional): <input type="text" name="insertPokemonFoundName"></input><br />
    <input type="submit" value="Insert" name="insertPokemonSubmit"></p>
  </div>
  </form>
  <hr />
  <h2>Update a Value in Table:</h2>
  <form method="POST" action="PokeDataDex.php">
    <select id="select" onChange="handleSelection(value)">
      <option selected value="update-select">Select a table </option>
      <option value="update-player">Player </option>
      <option value="update-item">Item </option>
      <option value="update-pokemon">Pokemon </option>
    </select
    <p>The values are case sensitive and if you enter in the wrong case, the update statement will not do anything.</p>
  </form>

  <form method="POST" action="PokeDataDex.php">
    <input type="hidden" id="updateRequest" name="updateRequest">
    <div class="hide" id="update-player">
    Username: <input type="text" name="updatePlayerUsername"></input><br />
    XP: <input type="text" name="updatePlayerXP"></input><br />
    Team Name: <input type="text" name="updatePlayerTeamName"></input><br />
    <input type="submit" value="Update" name="updateSubmit"></p>
    </div>
    <div class="hide" id="update-item">
      Name: <input type="text" name="updateItemName"></input><br />
      Cost: <input type="text" name="updateItemCost"></input><br />
      Effect: <input type="text" name="updateItemEffect"></input><br />
      <input type="submit" value="Update" name="updateSubmit"></p>
    </div>
    <div class="hide" id="update-pokemon">
      ID: <input type="text" name="updatePokemonID"></input><br />
      Species Name: <input type="text" name="updatePokemonSpeciesName"></input><br />
      Combat Score (CP): <input type="text" name="updatePokemonCP"></input><br />
      Distance: <input type="text" name="updatePokemonDistance"></input><br />
      Nickname: <input type="text" name="updatePokemonNickname"></input><br />
      Gym Country: <input type="text" name="updatePokemonGymCountry"></input><br />
      Gym Postal Code: <input type="text" name="updatePokemonGymPostalCode"></input><br />
      Gym Name: <input type="text" name="updatePokemonGymName"></input><br />
      Stationed at Date: <input type="text" name="updatePokemonStationedDate"></input><br />
      Found Country: <input type="text" name="updatePokemonFoundCountry"></input><br />
      Found Postal Code: <input type="text" name="updatePokemonFoundPostalCode"></input><br />
      Found Name: <input type="text" name="updatePokemonFoundName"></input><br />
      <input type="submit" value="Update" name="updateSubmit"></p>
    </div>
    </form>

    <hr />

    <h2>Delete a Value in Table:
    <select id="select" onChange="handleSelection(value)">
      <option selected value="delete-select">Select a table </option>
      <option value="delete-player">Player </option>
      <option value="delete-item">Item </option>
      <option value="delete-pokemon">Pokemon </option>
    </select>
    </h2>
    <p>The values are case sensitive and if you enter in the wrong case, the delete statement will not do anything.</p>

  <form method="POST" action="PokeDataDex.php">
    <input type="hidden" id="deleteRequest" name="deleteRequest">
    <div class="hide" id="delete-player">
      Username: <input type="text" name="deletePlayerUsername"></input><br />
      <input type="submit" value="Delete" name="deletePlayerSubmit"></p>
    </div>
    <div class="hide" id="delete-item">
      Name: <input type="text" name="deleteItemName"></input><br />
      <input type="submit" value="Delete" name="deleteItemSubmit"></p>
    </div>
    <div class="hide" id="delete-pokemon">
      ID: <input type="text" name="deletePokemonID"></input><br />
      <input type="submit" value="Delete" name="deletePokemonSubmit"></p>
    </div>
  </form>
</div>
<script>
<?php
  include("./js/helper.js")
?>
</script>
<?php
  include_once("./util.php");
?>
