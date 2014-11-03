function runFullCalendar(){

  $('#calendar').fullCalendar({

    events: eventsArray,
    editable: true,
    dayClick: function(date) {
    	window.location.href = newWorkoutUrl + '?date=' + date.format();
    }

  });
}