require 'rails_helper'

RSpec.describe Trade, type: :model do
  let!(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }

  describe 'associations' do
    it 'belongs to a user' do
      trade = Trade.create(name: 'Apple', amount: 10, user: user)
      expect(trade.user).to eq(user)
    end

    it 'has many group trades' do
      trade = Trade.create(name: 'Apple', amount: 10, user: user)
      group = Group.create(name: 'Food', icon: 'https://example.com/image.png', user: user)
      group_trade = GroupTrade.create(group: group, trade: trade)
      expect(trade.group_trades).to include(group_trade)
      expect(trade.groups).to include(group)
    end
  end

  describe 'validations' do
    it 'is valid with a name and amount' do
      trade = Trade.create(name: 'Apple', amount: 10, user: user)
      expect(trade).to be_valid
    end

    it 'is invalid without a name' do
      trade = Trade.create(name: '', amount: 10, user: user)
      expect(trade).not_to be_valid
      expect(trade.errors[:name]).to include('is too short (minimum is 1 character)')
    end

    it 'is invalid without an amount' do
      trade = Trade.create(name: 'Apple', user: user)
      expect(trade).not_to be_valid
      expect(trade.errors[:amount]).to include('is not a number')
    end

    it 'is invalid with a negative amount' do
      trade = Trade.create(name: 'Apple', amount: -10, user: user)
      expect(trade).not_to be_valid
      expect(trade.errors[:amount]).to include('must be greater than or equal to 0')
    end

    it 'is invalid with a short name' do
      trade = Trade.create(name: '', amount: 10, user: user)
      expect(trade).not_to be_valid
      expect(trade.errors[:name]).to include('is too short (minimum is 1 character)')
    end

    it 'is invalid with a long name' do
      name = 'a' * 101
      trade = Trade.create(name: name, amount: 10, user: user)
      expect(trade).not_to be_valid
      expect(trade.errors[:name]).to include('is too long (maximum is 100 characters)')
    end
  end
end
