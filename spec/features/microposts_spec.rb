require 'rails_helper'

feature "MicropostPages", type: :request do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before { sign_in user }

  feature "micropost creation" do 
    before { visit root_path }

    describe "with invalid information" do

      scenario "should not create a micropost" do
        expect {click_button "Post"}.not_to change(Micropost, :count)  
      end

      describe "error message" do
        before {click_button "Post"}
        scenario { should have_content('error') }
      end

    end

    describe "with valid information" do
      before{ fill_in "micropost_content", with: "Lorem ipsum" }
      scenario "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
  feature "microposts destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    
    describe "as correct user" do
      
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
