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
    end

    feature "with valid information" do
      before {
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      }
      scenario "should create a user" do
        expect {click_button submit}.to change(User, :count).by(1)
      end 
      feature "after saving the user" do
        before {
          click_button submit
        }
        
        let(:user) {User.find_by(email: 'user@example.com')}
        scenario { should have_link('Sign out') }
        scenario { should have_title(user.name)}
        scenario { should have_selector("div.alert.alert-success", text: 'Welcome') }
      end
    end

  end

end