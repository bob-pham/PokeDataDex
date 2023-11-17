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