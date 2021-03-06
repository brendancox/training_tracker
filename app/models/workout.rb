class Workout < ActiveRecord::Base
  has_many :component_sets, :dependent => :destroy
  has_many :component_times, :dependent => :destroy
  belongs_to :user
  validates :user_id, presence: :true
  accepts_nested_attributes_for :component_sets, :allow_destroy => true, reject_if: proc {|attributes| attributes['workout_component_id'].blank? || attributes['kg'].blank? && attributes['reps'].blank? && attributes['num_of_sets'].blank?}
  accepts_nested_attributes_for :component_times, :allow_destroy => true, reject_if: proc {|attributes| attributes['workout_component_id'].blank? || attributes['meters'].blank?	&& attributes['seconds'].blank?}

  default_scope {order(workout_date: :desc)}
  scope :recent_scheduled, -> {where(completed: false).where('workout_date < ?', Date.today).limit(5)}

end
