class User < ActiveRecord::Base
  has_many :workouts, :dependent => :destroy
  has_many :templates, :dependent => :destroy
  has_many :workout_components, :dependent => :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
