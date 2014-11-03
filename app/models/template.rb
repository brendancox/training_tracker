class Template < ActiveRecord::Base
  has_many :component_sets, :dependent => :destroy
  has_many :component_times, :dependent => :destroy
  accepts_nested_attributes_for :component_sets
  accepts_nested_attributes_for :component_times
end
