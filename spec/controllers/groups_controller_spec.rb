require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe 'GET #index' do
    context 'when user is authenticated' do
      let!(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }
      let!(:group1) { Group.create(name: 'Food', icon: 'https://example.com/image1.png', user: user) }
      let!(:group2) { Group.create(name: 'Entertainment', icon: 'https://example.com/image2.png', user: user) }

      before do
        user.confirm
        sign_in(user)
        get :index
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'assigns the user groups to @groups' do
        expect(assigns(:groups)).to eq([group1, group2])
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end

    context 'when user is not authenticated' do
      before { get :index }

      it 'redirects to the sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #new' do
    context 'when user is authenticated' do
      let!(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }

      before do
        user.confirm
        sign_in(user)
        get :new
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'assigns a new group to @group' do
        expect(assigns(:group)).to be_a_new(Group)
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end
    end

    context 'when user is not authenticated' do
      before { get :new }

      it 'redirects to the sign in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    let!(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }

    before do
      user.confirm
      sign_in(user)
    end

    context 'with valid attributes' do
      it 'creates a new group' do
        expect { post :create, params: { group: { name: 'Food', icon: 'https://example.com/image.png' } }
        }.to change(Group, :count).by(1)
      end

      it 'assigns the user as the owner of the group' do
        post :create, params: { group: { name: 'Food', icon: 'https://example.com/image.png' } }
        expect(assigns(:group).user).to eq(user)
      end

      it 'sets a flash notice' do
        post :create, params: { group: { name: 'Food', icon: 'https://example.com/image.png' } }
        expect(flash[:notice]).to eq('Group was successfully created.')
      end

      it 'redirects to the groups index page' do
        post :create, params: { group: { name: 'Food', icon: 'https://example.com/image.png' } }
        expect(response).to redirect_to(groups_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new group' do
        expect { post :create, params: { group: { name: nil, icon: 'https://example.com/image.png' } }
        }.not_to change(Group, :count)
      end

      it 'renders the new template' do
        post :create, params: { group: { name: nil, icon: 'https://example.com/image.png' } }
        expect(response).to render_template(:new)
      end
    end
  end
end
