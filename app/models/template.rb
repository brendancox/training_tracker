class Template < ActiveRecord::Base
  has_many :template_sets, :dependent => :destroy
  has_many :template_times, :dependent => :destroy
  accepts_nested_attributes_for :template_sets
  accepts_nested_attributes_for :template_times
end
