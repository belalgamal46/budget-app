require 'rails_helper'

RSpec.feature 'Create new group', type: :feature do
  let!(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }

  before do
    user.confirm
    login_as(user, scope: :user)
  end

  scenario 'User creates a new group' do
    visit new_group_path

    fill_in 'Category name', with: 'Food'
    fill_in 'Icon URL', with: 'https://example.com/food-icon.png'
    click_button 'Create Category'

    expect(page).to have_current_path(groups_path)
    expect(page).to have_content('Group was successfully created.')
    expect(page).to have_content('Food')
  end
end
