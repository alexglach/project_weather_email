class User < ApplicationRecord

  validates :email, 
           uniqueness: true, 
           presence: true
  validates :city, presence: true, inclusion: {in: CITIES}
end
