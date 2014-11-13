class Template < ActiveRecord::Base
  has_many :component_sets, :dependent => :destroy
  has_many :component_times, :dependent => :destroy
  belongs_to :user
  accepts_nested_attributes_for :component_sets, :allow_destroy => true, reject_if: proc {|attributes| attributes['kg'].blank? && attributes['reps'].blank? && attributes['num_of_sets'].blank?}
  accepts_nested_attributes_for :component_times, :allow_destroy => true, reject_if: proc {|attributes| attributes['meters'].blank?	&& attributes['seconds'].blank?}
end
