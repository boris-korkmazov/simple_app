require 'rails_helper'

describe "User pages" do
  subject { page }

  feature 'signup page' do
    before {visit signup_path}
    scenario { should have_content('Sign up')}
    scenario { should have_title('Sign up')}
  end

  feature "proifile page" do
    let(:user) { FactoryGirl.create(:user) }

    before { visit user_path(user) }

    scenario { should have_content(user.name) }

    scenario { should have_title(user.name) }
  end

  describe "singup page" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    feature "with invalid information" do
      scenario "should not create a user" do
        expect {click_button submit}.not_to change(User, :count)
      end

      scenario "with valid information" do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"

        expect {click_button submit}.to change(User, :count).by(1)
      end
    end 
  end
end