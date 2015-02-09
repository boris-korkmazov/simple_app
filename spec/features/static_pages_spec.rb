require 'rails_helper'


describe 'Static pages' do
  feature 'Home page' do
    scenario "should have SampleApp" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end

    scenario "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title "Home"
    end
  end


  feature "Help page" do
    scenario 'Static pages' do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    scenario "should have the right title 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_title "Help"
    end
  end

  feature 'About page' do
    scenario 'should have the content\'About Us\''do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    scenario "should have the right title 'About'" do
      visit '/static_pages/about'
      expect(page).to have_title "About Us"
    end
  end
end