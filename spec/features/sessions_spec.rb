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
        fill_in "Email", with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      scenario { should have_title(user.name) }
      scenario { should have_link( "Profile", href: user_path(user)) }
      scenario { should have_link('Sign out', href: signout_path ) }
      scenario { should_not have_link('Sign in', href: signin_path) }

      feature "followed by signout" do
        before { click_link "Sign out" }

        scenario { should have_link 'Sign in' }
      end
    end
  end
end