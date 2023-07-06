class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable

  has_many :groups, dependent: :destroy
  has_many :trades, dependent: :destroy

  with_options presence: true do
    validates :name, length: { minimum: 3, maximum: 27 }
    validates :email
    validates :password, length: { minimum: 6, maximum: 128 }
  end

  def admin?
    role == 'admin'
  end
end
