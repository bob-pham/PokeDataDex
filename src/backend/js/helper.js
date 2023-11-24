

function operationToggle(choice) {
  hideAllChoices();
  document.getElementById(choice).style.display="grid";
}

function hideAllChoices() {
  document.getElementById('modify-insert').style.display="none";
  document.getElementById('modify-update').style.display="none";
  document.getElementById('modify-delete').style.display="none";
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
