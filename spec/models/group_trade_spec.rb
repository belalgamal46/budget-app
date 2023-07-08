require 'rails_helper'

RSpec.describe GroupTrade, type: :model do
  let!(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }
  let!(:group) { Group.create(name: 'Food', icon: 'https://example.com/image.png', user: user) }
  let!(:trade) { Trade.create(name: 'KFC', amount: 10, user: user) }

  describe 'associations' do
    it 'belongs to a group' do
      group_trade = GroupTrade.create(group: group, trade: trade)
      expect(group_trade.group).to eq(group)
    end

    it 'belongs to a trade' do
      group_trade = GroupTrade.create(group: group, trade: trade)
      expect(group_trade.trade).to eq(trade)
    end
  end
end
