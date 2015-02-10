require 'rails_helper'

describe "User pages" do
  subject { page }

  feature 'signup page' do
    before {visit signup_path}
    scenario { should have_content('Sign up')}
    scenario { should have_title('Sign up')}
  end
  
end