require "rails_helper"

describe "Authentication" do 
  subject { page }

  feature "signin page" do
    before {visit signin_path}

    scenario { should have_content('Sign in') }
    scenario { should have_title('Sign in') }
  end
  describe "signin" do
    before{ visit signin_path }
    
    feature "invalid authorization" do
      scenario { should have_title('Sign in') }
      before {
        click_button "Sign in"
      }
      scenario { should have_selector('.alert-error') }
      scenario {
        click_link "Home"
        should_not have_selector('div.alert.alert-error')
      }
    end


    feature "valid information" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        sign_in user
      end

      scenario { should have_title(user.name) }
      scenario { should have_link('Users',       href: users_path) }
      scenario { should have_link( "Profile", href: user_path(user)) }
      scenario { should have_link('Settings', href: edit_user_path(user)) }
      scenario { should have_link('Sign out', href: signout_path ) }
      scenario { should_not have_link('Sign in', href: signin_path) }

      feature "followed by signout" do
        before { click_link "Sign out" }

        scenario { should have_link 'Sign in' }
      end
    end
  end

  feature "authorization" do
    feature "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      describe "in the Users Controller" do
        feature "visiting the edit page" do
          before { visit edit_user_path(user) }
          scenario { should have_title('Sign in') }
        end

        feature "submitting to the update action" do
          before { visit user_path(user) }
          scenario { should have_content('Sign in') }
        end


        feature "visiting the user index" do
          before { visit users_path }
          scenario {should have_title('Sign in')}
        end


        feature "visiting the following page" do
          before {visit following_user_path(user)}
          scenario { should have_title('Sign in') }
        end


        feature "visiting the followers page" do
          before {visit following_user_path(user)}
          scenario { should have_title('Sign in') }
        end
      end

      

      describe "when attempting to visit a protect page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
        feature "after signing in " do
          scenario "should render desired prot page" do
            expect(page).to have_title("Edit user")
          end
        end
      end
    end

    feature "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) {FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "submitting a Get request to the User#edit action" do
        before { visit edit_user_path(wrong_user)}
        scenario { expect(page).not_to have_title('Edit User') }
        scenario { expect(current_path).to eq (root_path) }
      end

    end
  end
end