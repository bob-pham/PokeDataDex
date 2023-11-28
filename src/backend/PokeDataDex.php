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
          <h1 class="header-text">View Datasets</h1>
          <div>
            <form action="ViewTables.php">
              <input type="submit" value="View Tables">
            </form>
          </div>
        </div>
        <div class="section">
          <h1 class="header-text">Search</h1>
          <?php
            include("./Select.php");
          ?>
          <?php
            include("./Leaderboard.php");
          ?>
        </div>
        <div class="section">
          <h1 class="header-text">Edit</h1>
            <div class="section">
                <h1 class="header-text">View Datasets</h1>
                <div>
                    <form action="Update.php">
                        <input type="submit" value="Update">
                    </form>
                </div>
            </div>
          <form method="POST" action="PokeDataDex.php">
            <select id="select" onChange="operationToggle(value)">
              <option selected value="N/A">Operation</option>
              <option value="modify-insert">INSERT</option>
              <option value="modify-update">UPDATE</option>
              <option value="modify-delete">DELETE</option>
            </select>
          </form>
          <div class="hide" id="modify-insert">

          </div>
          <div class="hide" id="modify-update">

          </div>
          <div class="hide" id="modify-delete">

          </div>
        </div>
        <div class="section">
          <img src="assets/logo.png" type="image.png">
        </div>
  <script src="js/helper.js" defer></script>
	</body>
</html>

