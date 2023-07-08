class Group < ApplicationRecord
  belongs_to :user
  has_many :group_trades, dependent: :destroy
  has_many :trades, through: :group_trades

  with_options presence: true do
    validates_length_of :name, in: 3..250
    validates :icon
  end
  validates_format_of :icon,
                      with: %r{^(http(s)://.)[-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_+.~#?&/=]*)$},
                      multiline: true, message: 'icon must be a url for an image'

  def group_trades_total
    trades.sum(:amount)
  end
end
