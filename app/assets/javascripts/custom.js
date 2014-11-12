$(document).on('page:change', function(){
  $(".actual-seconds").each(updateTimeInputs);
  scheduledOrCompleted();
  checkForFormDivsToHide();

  if ($("#calendar").length > 0){
    runFullCalendar();
  }
});


$(document).on('click', '.removeExercise', function(event){
  event.preventDefault();
  parentSection = $(this).closest(".exercise-fields").hide();
  parentSection.find('.destroy').val(true);
});


$(document).on('click', '.addCardioExercise', function(event){
  event.preventDefault();
  addSet('times');
});

$(document).on('click', '.addRepsExercise', function(event){
  event.preventDefault();
  addSet('sets');
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
  var parentSection = $(this).closest(".exercise-fields");
  var actualSeconds = parentSection.find(".actual-seconds").val();
  if (actualSeconds > 0) {
    var seconds = actualSeconds % 60;
    var minutes = (actualSeconds - seconds) / 60 % 60;
    var hours = ((actualSeconds - seconds) / 60 - minutes) / 60;
    parentSection.find('.hours').val(hours);
    parentSection.find('.mins').val(minutes);
    parentSection.find('.secs').val(seconds);
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
  //$('#save').prop('disabled', true);
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

function addSet(type){
  var newDiv = $('.' + type + ':first').clone();
  $('.exercise-fields').last().after(newDiv);
  newDiv.show();
  newDiv.find('input').each(function(){
    var thisInput = $(this);
    thisInput.val('');
    if (!thisInput.hasClass('number-entry-time')){
      var thisId = thisInput.attr('id');
      var thisName = thisInput.attr('name');
      thisInput.attr('id', thisId.replace('0', componentsCount[type]));
      thisInput.attr('name', thisName.replace('0', componentsCount[type]));
      console.log(thisInput.attr('id'));
    }
  });
  var selectId = newDiv.find('select').attr('id');
  var selectName = newDiv.find('select').attr('name');
  newDiv.find('select').attr('id', selectId.replace('0', componentsCount[type]));
  newDiv.find('select').attr('name', selectName.replace('0', componentsCount[type]));
  componentsCount[type]++;
}


function checkForFormDivsToHide(){
  if ($('#workout_component_times_attributes_0_order').val() === '-1'){
    $('#workout_component_times_attributes_0_order').closest('.exercise-fields').hide();
  }
  if ($('#workout_component_sets_attributes_0_order').val() === '-1'){
    $('#workout_component_sets_attributes_0_order').closest('.exercise-fields').hide();
  }
}
