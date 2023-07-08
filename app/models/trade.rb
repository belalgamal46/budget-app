class Trade < ApplicationRecord
  belongs_to :user

  has_many :group_trades, dependent: :destroy
  has_many :groups, through: :group_trades

  with_options presence: true do
    validates_length_of :name, in: 1..100
    validates_numericality_of :amount, greater_than_or_equal_to: 0
  end
end
