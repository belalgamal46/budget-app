require 'rails_helper'

RSpec.feature 'Groups index page', type: :feature do
  let!(:user) { User.create(name: 'John', email: 'john@example.com', password: 'password') }
  let!(:group1) { Group.create(name: 'Food', icon: 'https://images.pexels.com/photos/16952091/pexels-photo-16952091/free-photo-of-wood-landscape-field-summer.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', user: user) }
  let!(:group2) { Group.create(name: 'Entertainment', icon: 'https://images.pexels.com/photos/16952091/pexels-photo-16952091/free-photo-of-wood-landscape-field-summer.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load', user: user) }

  before do
    user.confirm
    sign_in user
    visit user_session_path
  end

  scenario 'displays the user name, categories, and sign out button' do
    expect(page).to have_current_path(authenticated_root_path)
    expect(page).to have_selector('ul.list-unstyled') # check for the unordered list
    expect(page).to have_content(user.name) # check for the user name
    expect(page).to have_content('CATEGORIES') # check for the categories title
    expect(page).to have_button('Sign out') # check for the sign out button
  end

  scenario 'displays the groups with their icons, names, and total trade amounts' do
    expect(page).to have_selector('main.bg-splash') # check for the main and section tags
    if Group.all.blank?
      expect(page).to have_content('Please add a new category') # check for the message when there are no groups
    else
      expect(page).to have_selector('div.px-3') # check for the div element with class px-3

      # check for each group's icon, name, and total trade amount
      expect(page).to have_css("img[src*='#{group1.icon}']")
      expect(page).to have_content(group1.name)
      expect(page).to have_content(group1.group_trades_total)
      expect(page).to have_css("img[src='#{group2.icon}']")
      expect(page).to have_content(group2.name)
      expect(page).to have_content(group2.group_trades_total)
    end

    expect(page).to have_link('Add Category', href: new_group_path) # check for the add category link
  end
end
