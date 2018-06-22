class Motorcycle < ActiveRecord::Base

  belongs_to :user

  validates :make, presence: true

end