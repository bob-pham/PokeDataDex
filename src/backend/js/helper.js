
function showOnlySelected(choice) {
  const divs = document.getElementById("viewTablesForm").getElementsByTagName("div");

  for (let i = 0; i < divs.length; i++) {
    divs[i].style.display="none";
  }

  document.getElementById(choice).style.display="block";
}

function handleSelection(choice) {
    type = choice.split("-")[0];
    hideAll(type);
    document.getElementById(choice).style.display="block";
}

function hideAll(type) {
    document.getElementById(type + '-player').style.display="none";
    document.getElementById(type + '-item').style.display="none";
    document.getElementById(type + '-pokemon').style.display="none";
}

function leaderboardInputToggle(choice) {
    if (choice === "Player's Strongest Pokemon" || choice === "Teams with N Players" || choice === "Teams Who Own the Most Species Name") {
        document.getElementById("value-input").style.display="flex";
        document.getElementById("count-input").style.display="flex";
        document.getElementById("query-submit").style.display="flex";
        if (choice === "Player's Strongest Pokemon") {
            document.getElementById('value-input-label').innerHTML = 'Player Username:';
        } else if (choice === "Teams with N Players") {
            document.getElementById('value-input-label').innerHTML = '# of Players:';
        } else if (choice === "Teams Who Own the Most Species Name") {
            document.getElementById('value-input-label').innerHTML = 'Species Name';
        }
    } else if (choice === "None") {
        document.getElementById("value-input").style.display="none";
        document.getElementById("count-input").style.display="none";
        document.getElementById("query-submit").style.display="none";
    } else {
        document.getElementById("value-input").style.display="none";
        document.getElementById("count-input").style.display="flex";
        document.getElementById("query-submit").style.display="flex";
    }
}

function addDropdown(selectName, options) {
    let select = document.getElementById(selectName);
    for (const username of options.split(', ')) {
        let option = document.createElement('option');
        option.text = username;
        option.value = username;
        select.add(option);
    }
}