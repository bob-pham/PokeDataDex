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
          <h1 class="header-text">Navigate</h1>
            <div class="modify">
              <form action="ViewTables.php" class="query-item" >
                <input type="submit" value="View Tables">
              </form>
              <form action="Insert.php" class="query-item" >
                <input type="submit" value="Insert">
              </form>
              <form action="Update.php" class="query-item" >
                <input type="submit" value="Update">
              </form>
              <form action="Delete.php" class="query-item" >
                <input type="submit" value="Delete">
              </form>
            </div>
        </div>
        <div class="divider">
        <hr class="divider">
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
          <img src="assets/logo.png" type="image.png">
        </div>
  <script src="js/helper.js" defer></script>
	</body>
</html>

