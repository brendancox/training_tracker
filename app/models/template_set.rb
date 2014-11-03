class TemplateSet < ActiveRecord::Base
  belongs_to :template
  belongs_to :workout_component
end
