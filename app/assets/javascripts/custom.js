$(document).ready(function(){

});

$(document).on('page:change', function(){
  $(".actual-seconds").each(updateTimeInputs);

  var clickedDate = getParameterByName('date');
  if (clickedDate){ 
    updateDate(clickedDate);
  }

  if ($("#calendar").length > 0){
    runFullCalendar();
  }
});

$(document).on('click', '.duplicateExercise', function(event){
  event.preventDefault();
  parentSection = $(this).closest("tbody");
  cloneExercise(parentSection);
});

$(document).on('click', '.removeExercise', function(event){
  event.preventDefault();
  parentSection = $(this).closest("tbody").fadeOut();
});

$(document).on('click', '.addExercise', function(event){
  event.preventDefault();
  prevTBody = $(this).closest("tbody").prev("tbody");
  cloneExercise(prevTBody).find('input').val('');

});

function cloneExercise(exerciseSection){
  var selectedExercise = exerciseSection.find(":selected").val();
  newSection = exerciseSection.clone();
  newSection.find("select").val(selectedExercise);
  exerciseSection.after(newSection);
  return newSection;
}


function adjustMinHours(minObject, min){
  var hourObject = minObject.closest("td").find(".hours");
  var currentHours = parseInt(hourObject.val()) || 0;
  var extraHours = Math.floor(min / 60);
  var extraMin = min - extraHours * 60;
  var hours = currentHours + extraHours;
  if (hours < 0) {
    hourObject.val(0);
    minObject.val(0);
    return false;
  } else {
    hourObject.val(hours);
    minObject.val(extraMin);
  }
}

function adjustSecMin(secObject, sec){
  var minObject = secObject.closest("td").find(".mins");
  var currentMins = parseInt(minObject.val()) || 0;
  var extraMins = Math.floor(sec / 60);
  var extraSec = sec - extraMins * 60;
  var min = currentMins + extraMins;
  if (min < 0 ) {
    var checkHours = adjustMinHours(minObject, min);
    if (checkHours) {
      secObject.val(extraSec);
    } else {
      minObject.val(0);
      secObject.val(0);
    }
  } else {
    minObject.val(min);
    secObject.val(extraSec);
    adjustMinHours(minObject, min);
  }
}

function addTimesToActualSeconds(thisObject){
  parentTd = thisObject.closest("td");
  var hours = parseInt(parentTd.find(".hours").val()) || 0;
  var minutes = parseInt(parentTd.find(".mins").val()) || 0;
  var seconds = parseInt(parentTd.find(".secs").val()) || 0;
  var actualSeconds = hours * 3600 + minutes * 60 + seconds;
  parentTd.find(".actual-seconds").val(actualSeconds);
}

$(document).on('click keyup', '.mins', function(){
  var minObject = $(this);
  var min = parseInt(minObject.val()) || 0;
  if (min >= 60 || min < 0) {adjustMinHours(minObject, min)}
    addTimesToActualSeconds(minObject);
});

$(document).on('click keyup', '.secs', function(){
  var secObject = $(this);
  var sec = parseInt(secObject.val()) || 0;
  if (sec >= 60 || sec < 0) {adjustSecMin(secObject, sec)}
    addTimesToActualSeconds(secObject);
});

$(document).on('click keyup', '.hours', function(){
  var hourObject = $(this);
  addTimesToActualSeconds(hourObject);
});

function updateTimeInputs(){
  var parentTd = $(this).closest("td");
  var actualSeconds = parentTd.find(".actual-seconds").val();
  if (actualSeconds > 0) {
    var secObject = parentTd.find(".secs");
    secObject.val(actualSeconds);
    adjustSecMin(secObject, actualSeconds);
  }
}

function updateDate(clickedDate){
  $("#recorded_workout_workout_date_1i").val(clickedDate.substring(0,4));
  $("#recorded_workout_workout_date_2i").val(removePrecedingZero(clickedDate.substring(5,7)));
  $("#recorded_workout_workout_date_3i").val(removePrecedingZero(clickedDate.substring(8,10)));
}

function getParameterByName(name) {
    var match = RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search);
    return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
}

function removePrecedingZero(numString){
  //removes preceding zero in a 2 digit number (of type string)
  if (numString.substring(0,1) == '0'){
    return numString.substring(1,2);
  } else {
    return numString;
  }
}

$(document).on('click', '.select-component-type', function(){
  if ($(this).val() === 'Reps'){
    $('.times-select').hide();
    $('.reps-select').show();
  }
  if ($(this).val() === 'Time'){
    $('.reps-select').hide();
    $('.times-select').show();
  }
});