<div class="selectUI">
  <form method="GET" action="Pokemon.php">
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
    <label>Filters</label>
    <select name="filter", id="filter">
      <option value="None">N/A</option>
      <option value="Min">Min</option>
      <option value="Max">Max</option>
      <option value="Avg">Avg</option>
      <option value="Count">Count</option>
    </select>
    <input type="submit" value="Submit">
  </form>
</div>
<?php
include_once("./util.php");
?>
          
