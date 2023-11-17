setup_script="./src/database/pokemon.sql"
styles="./src/backend/styles/styles.css"
host="dbhost.students.cs.ubc.ca:1522/stu"

# backend files
main="./src/backend/PokeDataDex.php"
util="./src/backend/util.php"
backend="./src/backend/"
dst="$HOME/public_html/"
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

# Loop through files in the destination directory
for dest_item in "$dst"/*; do
  dest_item_name=$(basename "$dest_item")
  # Check if there is a corresponding item in the source directory
  if [ -e "$backend/$dest_item_name" ]; then
    if [ -d "$dest_item" ]; then
      rm -rf "$dest_item"
    else
      rm -f "$dest_item"
    fi
  fi
done

cp -urf "$backend"/* "$dst"

if [ -e "$main" ]; then
  curr_file="$HOME/public_html/PokeDataDex.php"
  sed -i "s/ORACLE_USER/'$ORACLE_USER'/g" "$curr_file" 
  sed -i "s/ORACLE_PSSWD/'$ORACLE_PSSWD'/g" "$curr_file" 
else
  echo "ERROR: could find $main"
fi

if [ -e "$util" ]; then
  curr_file="$HOME/public_html/util.php"
  sed -i "s/ORACLE_USER/'$ORACLE_USER'/g" "$curr_file" 
  sed -i "s/ORACLE_PSSWD/'$ORACLE_PSSWD'/g" "$curr_file" 
else
  echo "ERROR: could find $main"
fi


if [ -e "$setup_script" ]; then
  sqlplus -S "$ORACLE_USER/$ORACLE_PSSWD@stu" <<EOF
  @$setup_script
  quit;
EOF
fi

