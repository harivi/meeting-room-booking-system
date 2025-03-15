class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bookings, dependent: :destroy  

  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: %w[admin employee] }
end
