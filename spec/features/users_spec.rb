require 'rails_helper'

describe "User pages" do
  subject { page }
  feature "Create User" do
    feature 'signup page' do
      before {visit signup_path}
      scenario { should have_content('Sign up')}
      scenario { should have_title('Sign up')}
    end

    feature "profile page" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:m1) {FactoryGirl.create(:micropost, user: user, content:"Foo")}
      let!(:m2) {FactoryGirl.create(:micropost, user: user, content:"Bar")}

      before { 
        visit user_path(user) 
      }

      scenario { should have_content(user.name) }

      scenario { should have_title(user.name) }

      feature 'microposts' do
        it {should have_content(m1.content) }
        it {should have_content(m2.content) } 
        it {should have_content(user.microposts.count)}
      end

      describe "follow/unfollow buttons" do
        let(:other_user) { FactoryGirl.create(:user) }
        before { sign_in user }

        feature 'following a user' do
          before { visit user_path(other_user) }

          scenario "should increment the followed user count" do
            expect { 
              click_button "Follow"
            }.to change(user.followed_users, :count).by(1)
          end

          scenario "should increment the other user's followers count" do
            expect { 
              click_button "Follow"
            }.to change(other_user.followers, :count).by(1)
          end
 
          feature "toggling the  button" do
            before { click_button "Follow"}
            scenario { should have_xpath('//input[@value="Unfollow"]') }
          end
        end 

        feature 'unfollowing a user' do
          before { 
            user.follow! other_user
            visit user_path(other_user) 
          }

          scenario "should decrement the followed user count" do
            expect { 
              click_button "Unfollow"
            }.to change(user.followed_users, :count).by(-1)
          end

          scenario "should decrement the other user's followers count" do
            expect { 
              click_button "Unfollow"
            }.to change(other_user.followers, :count).by(-1)
          end

          feature "toggling the  button" do
            before { click_button "Unfollow"}
            scenario { should have_xpath('//input[@value="Follow"]') }
          end
        end 
      end
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
  feature "Edit user" do
    let (:user) { FactoryGirl.create(:user) }
    before { 
      sign_in user
      visit edit_user_path(user)
       }

    feature "page" do
      scenario { should have_content( "Update your profile" ) }
      scenario { should have_title("Edit user") }
      scenario { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    feature "with invalid infornmation" do
      before { click_button "Save change" }

      scenario { should have_content('error') }
    end

    feature "with valid infornmation" do
      let(:new_name) {'serg'}
      let(:new_email){'serg@mail.coma'}
      before {
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Save change"
      }

      scenario { should have_title(new_name) }
      scenario { should have_selector('.alert-success') }
      scenario { should have_content('Profile updated') }
      scenario { should have_link('Sign out') }
      scenario {
        expect(user.reload.name).to eq new_name
      }
      scenario {
         expect(user.reload.email).to eq new_email
      }
    end
  end

  describe 'index' do
    before do 
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@ex.com")
      visit users_path
    end

    scenario {should have_title "All users"}
    scenario {should have_content "All users"}

    describe 'pagination' do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }
    
      scenario { should have_selector('div.pagination') }
      scenario "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    feature "delete links" do
      scenario { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) {FactoryGirl.create(:admin)}
        before do 
          sign_in admin
          visit users_path
        end

        scenario { should have_link('delete', href: user_path(User.first)) }

        scenario "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it {should_not have_link('delete', href: user_path(admin))}



      end
    end
  end
  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before {user.follow!(other_user)}

    feature "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      scenario { should have_title(full_title('Following')) }
      scenario { should have_selector('h3', text: 'Following') }
      scenario { should have_link(other_user.name, href: user_path(other_user)) }
    end

    feature "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      scenario { should have_title(full_title('Followers')) }
      scenario { should have_selector('h3', text: 'Followers') }
      scenario { should have_link(user.name, href: user_path(user)) }
    end
  end 
end