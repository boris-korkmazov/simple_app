require 'rails_helper'


describe 'Static pages' do

  subject {page}

  feature 'Home page' do
    before do 
      visit root_path
      full_title('') 
    end
    scenario "should have SampleApp" do
      should have_content('Sample App')
    end

    scenario "should have the right title" do
      should have_title "Home"
    end

    describe "for signed-in users" do
      let(:user) {FactoryGirl.create(:user)}
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem Ipsum" )
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet" )
        sign_in user
        visit root_path
      end

      scenario "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector "li##{item.id}", text: item.content
        end
      end
    end
  end


  feature "Help page" do
    before {visit help_path}
    scenario 'Static pages' do
      should have_content('Help')
    end

    scenario "should have the right title 'Help'" do
      should have_title "Help"
    end
  end

  feature 'About page' do
    before {visit about_path}
    scenario 'should have the content\'About Us\''do
      should have_content('About Us')
    end

    scenario "should have the right title 'About'" do
      should have_title "About Us"
    end
  end

  feature 'Contact page' do
    before {visit contact_path}
    scenario "should have the content 'Contact'" do
      should have_content 'Contact'
    end

    scenario "should have the right title 'Contact'" do
      should have_title 'Contact'
    end
  end
end