module ComponentRelations
  extend ActiveSupport::Concern

  included do 
	belongs_to :workout
	belongs_to :workout_component
	validates :workout_component_id, presence: :true
	validates :workout_id, presence: :true
  end
end