function runFullCalendar(){

  $('#calendar').fullCalendar({

    events: eventsArray,
    editable: false,
    timeFormat: '',
    dayClick: function(date) {
    	window.location.href = newWorkoutUrl + '?date=' + date.format();
    }

  });
}