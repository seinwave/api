class User < ApplicationRecord
  validates :first_name, presence: true, length: {maximum: 50}
  validates(:last_name, length: {maximum: 50})
  validates(:email, presence: true, length: {maximum: 255})
end
