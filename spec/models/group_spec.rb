require 'rails_helper'

RSpec.describe Group, type: :model do
  let!(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }

  describe 'validations' do
    it 'is valid with a name and icon' do
      group = Group.create(name: 'Food', icon: 'https://example.com/image.png', user: user)
      expect(group).to be_valid
    end

    it 'is invalid without a name' do
      group = Group.create(name: '', icon: 'https://example.com/image.png', user: user)
      expect(group).not_to be_valid
      expect(group.errors[:name]).to include('is too short (minimum is 3 characters)')
    end

    it 'is invalid without an icon' do
      group = Group.create(name: 'Food', user: user)
      expect(group).not_to be_valid
      expect(group.errors[:icon]).to include("can't be blank")
    end

    it 'is invalid with an invalid icon url' do
      group = Group.create(name: 'Food', icon: 'not_a_url', user: user)
      expect(group).not_to be_valid
      expect(group.errors[:icon]).to include('icon must be a url for an image')
    end

    it 'is invalid with a short name' do
      group = Group.create(name: 'F', icon: 'https://example.com/image.png', user: user)
      expect(group).not_to be_valid
      expect(group.errors[:name]).to include('is too short (minimum is 3 characters)')
    end

    it 'is invalid with a long name' do
      name = 'a' * 251
      group = Group.create(name: name, icon: 'https://example.com/image.png', user: user)
      expect(group).not_to be_valid
      expect(group.errors[:name]).to include('is too long (maximum is 250 characters)')
    end
  end

  describe '#group_trades_total' do
    it 'returns the sum of the trade amounts for the group' do
      group = Group.create(name: 'Food', icon: 'https://example.com/image.png', user: user)
      trade1 = Trade.create(name: "MacDonald's", amount: 10, user: user)
      trade2 = Trade.create(name: 'PizzaHut', amount: 20, user: user)
      group.group_trades.create(trade_id: trade1.id)
      group.group_trades.create(trade_id: trade2.id)
      expect(group.group_trades_total).to eq(30)
    end
  end
end
