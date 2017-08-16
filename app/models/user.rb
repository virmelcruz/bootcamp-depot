class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_secure_password #uses bcrypt, assumes that the fields of password is password. chechks if password and password configuration is matched.
end
