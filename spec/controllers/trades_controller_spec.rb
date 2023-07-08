require 'rails_helper'

RSpec.describe TradesController, type: :controller do
  describe 'GET #index' do
    context 'when user is authenticated' do
      let!(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }
      let!(:group) { Group.create(name: 'Food', icon: 'https://example.com/image1.png', user: user) }
      let!(:trade1) { Trade.create(name: 'Groceries', amount: 50, user: user, groups: [group]) }
      let!(:trade2) { Trade.create(name: 'Restaurants', amount: 100, user: user, groups: [group]) }

      before do
        user.confirm
        sign_in(user)
        get :index, params: { group_id: group.id }
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'assigns the correct group to @group' do
        expect(assigns(:group)).to eq(group)
      end

      it 'assigns the group trades to @trades' do
        expect(assigns(:trades)).to eq([trade2, trade1])
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end

    context 'when user is not authenticated' do
      before { get :index, params: { group_id: 1 } }

      it 'redirects to the sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #new' do
    context 'when user is authenticated' do
      let!(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }
      let!(:group1) { Group.create(name: 'Food', icon: 'https://example.com/image1.png', user: user) }
      let!(:group2) { Group.create(name: 'Entertainment', icon: 'https://example.com/image2.png', user: user) }

      before do
        user.confirm
        sign_in(user)
        get :new, params: { group_id: group1.id }
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'assigns a new trade to @trade' do
        expect(assigns(:trade)).to be_a_new(Trade)
      end

      it 'assigns the correct group to @group' do
        expect(assigns(:group)).to eq(group1)
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    context 'when user is not authenticated' do
      before { get :new, params: { group_id: 1 } }

      it 'redirects to the sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    let!(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }
    let!(:group1) { Group.create(name: 'Food', icon: 'https://example.com/image1.png', user: user) }
    let!(:group2) { Group.create(name: 'Entertainment', icon: 'https://example.com/image2.png', user: user) }

    before do
      user.confirm
      sign_in(user)
    end

    context 'with valid attributes' do
      it 'creates a new trade' do
        expect {
          post :create, params: { group_id: group1.id, trade: { name: 'Groceries', amount: 50, group_ids: [group1.id, group2.id] } }
        }.to change(Trade, :count).by(1)
      end

      it 'assigns the user as the creator of the trade' do
        post :create, params: { group_id: group1.id, trade: { name: 'Groceries', amount: 50, group_ids: [group1.id, group2.id] } }
        expect(assigns(:trade).user).to eq(user)
      end

      it 'assigns the correct groups to the trade' do
        post :create, params: { group_id: group1.id, trade: { name: 'Groceries', amount: 50, group_ids: [group1.id, group2.id] } }
        expect(assigns(:trade).groups).to eq([group1, group2])
      end

      it 'sets a flash notice' do
        post :create, params: { group_id: group1.id, trade: { name: 'Groceries', amount: 50, group_ids: [group1.id, group2.id] } }
        expect(flash[:notice]).to eq('Transaction was successfully created')
      end

      it 'redirects to the group trades index page' do
        post :create, params: { group_id: group1.id, trade: { name: 'Groceries', amount: 50, group_ids: [group1.id, group2.id] } }
        expect(response).to redirect_to(group_trades_path(group1.id))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new trade' do
        expect {
          post :create, params: { group_id: group1.id, trade: { name: nil, amount: 50, group_ids: [group1.id, group2.id] } }
        }.not_to change(Trade, :count)
      end

      it 'renders the new template' do
        post :create, params: { group_id: group1.id, trade: { name: nil, amount: 50, group_ids: [group1.id, group2.id] } }
        expect(response).to render_template(:new)
      end
    end
  end
end