setup_script="./src/database/pokemon.sql"
styles="./src/backend/styles/styles.css"
host="dbhost.students.cs.ubc.ca:1522/stu"

# backend files
main="./src/backend/PokeDataDex.php"

prompt_pass=0

if [[ -v "ORACLE_USER" && -v "ORACLE_PSSWD" ]]; then
  read -p "Use saved Username and password? (y/n): " resp

  if [[ "$resp" == "y" ]]; then
    prompt_pass=1
  fi
fi

if [[ "$prompt_pass" == 0 ]]; then 
  read -p "Enter your cwl: " user
  read -s -p "Enter your password (a[student num]): " password

  echo "Setting Environment variables for SQL server... Done"
  # will go away once you restart your shell
  export ORACLE_USER="ora_$user"
  export ORACLE_PSSWD="$password"
fi

echo "Copying files to public dir..."

if [ -e "$main" ]; then
  curr_file="$HOME/public_html/PokeDataDex.php"
  rm -f "$curr_file"
  cp "$main" "$curr_file"
  echo "Copied $main to $curr_file"
  sed -i "s/ORACLE_USER/'$ORACLE_USER'/g" "$curr_file" 
  sed -i "s/ORACLE_PSSWD/'$ORACLE_PSSWD'/g" "$curr_file" 
else
  echo "ERROR: could find $main"
fi

if [ -e "$styles" ]; then
  curr_file="$HOME/public_html/styles.css"
  rm -f "$curr_file"
  cp "$styles" "$curr_file"
  echo "Copied $styles to $curr_file"
else
  echo "ERROR: could find $styles"
fi

if [ -e "$setup_script" ]; then
  sqlplus -S "$ORACLE_USER/$ORACLE_PSSWD@stu" <<EOF
  @$setup_script
  quit;
EOF
fi

