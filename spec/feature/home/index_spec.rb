require 'rails_helper'

RSpec.feature 'Splash page', type: :feature do
  scenario 'displays the Budget App title and login/signup links' do
    visit unauthenticated_root_path

    expect(page).to have_css('section.bg-splash') # check for the splash section

    within '.splash-title' do
      expect(page).to have_css('h1.bio-monster-family', text: 'Budget App') # check for the Budget App title
    end

    within '.splash-links' do
      expect(page).to have_link('LOG IN', href: user_session_path) # check for the login link
      expect(page).to have_link('SIGN UP', href: new_user_registration_path) # check for the signup link
    end
  end
end
