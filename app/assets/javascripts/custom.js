$(document).on('page:change', function(){
  $(".actual-seconds").each(updateTimeInputs);


  var clickedDate = getParameterByName('date');
  if (clickedDate){ 
    updateDate(clickedDate);
    scheduledOrCompleted();
  }

  if ($("#calendar").length > 0){
    runFullCalendar();
  }
});

$(document).on('click', '.duplicateExercise', function(event){
  event.preventDefault();
  parentSection = $(this).closest(".exercise-fields");
  cloneExercise(parentSection);
});

$(document).on('click', '.removeExercise', function(event){
  event.preventDefault();
  parentSection = $(this).closest(".exercise-fields").fadeOut();
});

$(document).on('click', '.addExercise', function(event){
  event.preventDefault();
  prevDiv = $(this).closest(".exercise-fields").prev(".exercise-fields");
  cloneExercise(prevDiv).find('input').val('');
});

$(document).on('click', '#workout_workout_date_1i', scheduledOrCompleted);
$(document).on('click', '#workout_workout_date_2i', scheduledOrCompleted);
$(document).on('click', '#workout_workout_date_3i', scheduledOrCompleted);

function getDateFromSelect(){
  var year = $('#workout_workout_date_1i').val();
  var month = $('#workout_workout_date_2i').val();
  var date = $('#workout_workout_date_3i').val();
  return (year + '-' + month + '-' + date);
}

function scheduledOrCompleted(){
  var selectDate = getDateFromSelect();
  if (moment().diff(selectDate, 'hours') < 0){
    $('#workout_completed_false').prop('disabled', false).prop('checked', true);
    $('#workout_completed_true').prop('disabled', true);
  } else if (moment().diff(selectDate, 'hours') > 0){
    $('#workout_completed_true').prop('disabled', false).prop('checked', true);
    $('#workout_completed_false').prop('disabled', true);
  } else {
    $('#workout_completed_false').prop('disabled', false);
    $('#workout_completed_true').prop('disabled', false);
  }
}

function cloneExercise(exerciseSection){
  var selectedExercise = exerciseSection.find(":selected").val();
  var newSection = exerciseSection.clone();
  newSection.find("select").val(selectedExercise);
  exerciseSection.after(newSection);
  return newSection;
}


function addTimesToActualSeconds(thisInput){
  var parentClass = thisInput.closest(".cardio-time");
  var hours = parseInt(parentClass.find(".hours").val()) || 0;
  var minutes = parseInt(parentClass.find(".mins").val()) || 0;
  var seconds = parseInt(parentClass.find(".secs").val()) || 0;
  var actualSeconds = hours * 3600 + minutes * 60 + seconds;
  parentClass.find(".actual-seconds").val(actualSeconds);
}

$(document).on('click keyup', '.number-entry-time', function(){
  var thisInput = $(this);
  addTimesToActualSeconds(thisInput);
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
  $("#workout_workout_date_1i").val(clickedDate.substring(0,4));
  $("#workout_workout_date_2i").val(removePrecedingZero(clickedDate.substring(5,7)));
  $("#workout_workout_date_3i").val(removePrecedingZero(clickedDate.substring(8,10)));
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

$(document).on("click", '.how_scheduled', howDaysAreScheduled);

function howDaysAreScheduled(){
  if ($(this).val() === 'Schedule by number of days'){
    $(this).closest('.template').find('.num_of_days').show();
    $(this).closest('.template').find('.days_of_week').hide();
  } else if ($(this).val() === 'Select by days of week'){
    $(this).closest('.template').find('.num_of_days').hide();
    $(this).closest('.template').find('.days_of_week').show();    
  }
}


$(document).on('click', '#preview', generateSchedule);

function generateSchedule(){
  newEventsArray = []; //empty newEventsArray
  $('.template').each(function(){
    thisDiv = $(this);
    if (thisDiv.find('[name=template]').prop('checked') === true){
      var currentDate = moment(thisDiv.find('[name=start_date]').val());
      var endDate = moment(thisDiv.find('[name=end_date]').val());
      if (thisDiv.find('.how_scheduled').val() === 'Schedule by number of days'){
        var everyNumDays = parseInt(thisDiv.find('[name=every_num_of_days]').val()); 
        while (currentDate <= endDate){
          newEventsArray.push({
            title: thisDiv.find('[name=template]').data('template-name'),
            start: currentDate.format('YYYY-MM-DD'),
            color: '#00FF00',
            textColor: 'black',
            template_id: thisDiv.find('[name=template]').val()
          });
          currentDate.add(everyNumDays, 'd');
        }
      } else if (thisDiv.find('.how_scheduled').val() === 'Select by days of week'){
        daysOfWeekArray = [];
        thisDiv.find('.day_of_week').each(function(){
          if ($(this).prop('checked') === true){
            daysOfWeekArray.push(parseInt($(this).val()));
          }
        });
        for (var j = 0; j < daysOfWeekArray.length; j++){
          currentDate = moment(thisDiv.find('[name=start_date]').val());
          var x = 0;
          while (currentDate <= endDate){
            if (currentDate.day() === daysOfWeekArray[j]){
              newEventsArray.push({
                title: thisDiv.find('[name=template]').data('template-name'),
                start: currentDate.format('YYYY-MM-DD'),
                color: '#00FF00',
                textColor: 'black',
                template_id: thisDiv.find('[name=template]').val()
              });
            }
            currentDate.add(1, 'd');
          }
        }
      }
    }
  });
  var combinedEventsArray = newEventsArray.concat(eventsArray);
  $('#calendar').fullCalendar('removeEvents')
  $('#calendar').fullCalendar('addEventSource', combinedEventsArray);
  $('#save').prop('disabled', false);
}

$(document).on('click', '#save', postData);

function postData(){
  $('#preview').prop('disabled', true);
  $('#save').prop('disabled', true);
  $.ajax({
    type: 'POST',
    url: '/save_schedule',
    data: {scheduled: newEventsArray},
    timeout: 2000,
    success: function(response){
      console.log(response.response);
      $('#save_success').text('Schedule Saved!')
    },
    error: function(){
      console.log('error');
    }
  });
}

