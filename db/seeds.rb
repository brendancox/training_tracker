# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

exercise_types = [
	['Time', 'Machine', 'Treadmill'],
	['Time', 'Machine', 'Cycle'],
	['Time', 'Machine', 'Row'],
	['Time', 'Machine', 'Stepper'],
	['Time', 'Road/Track', 'Run'],
	['Time', 'Road/Track', 'Cycle'],
	['Reps', 'Machine', 'Bicep Curls'],
	['Reps', 'Machine', 'Chest Press'],
	['Reps', 'Machine', 'Lat Pulldown'],
	['Reps', 'Machine', 'Shoulder Press'],
	['Reps', 'Machine', 'Ab Crunch'],
	['Reps', 'Machine', 'Leg Press'],
	['Reps', 'Machine', 'Leg Extenstions'],
	['Reps', 'Free Weights', 'Bench Press'],
	['Reps', 'Free Weights', 'Deadlift'],
	['Reps', 'Free Weights', 'Bicep Curls'],
	['Reps', 'Free Weights', 'Triceps Kickback'],
	['Reps', 'Free Weights', 'Squats'],
	['Reps', 'Free Weights', 'Forward Raise'],
	['Reps', 'Free Weights', 'Lunges'],
	['Reps', 'Body Weight Only', 'Press-ups'],
	['Reps', 'Body Weight Only', 'Squats'],
	['Reps', 'Body Weight Only', 'Lunges'],
	['Reps', 'Body Weight Only', 'Crunches'],
	['Reps', 'Body Weight Only', 'Leg-lifts'],
]

exercise_types.each do |component_type, equipment, name|
	WorkoutComponent.create(component_type: component_type,
							equipment: equipment,
							name: name)
end
