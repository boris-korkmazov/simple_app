require "rails_helper"

describe "for non-signed-in user" do
  let(:user) { FactoryGirl.create(:user) }
  describe "in the Microposts controller" do
    describe "submitting to the create action" do  
      before { post microposts_path}
      it { expect(response).to redirect_to(signin_path) }
    end
    describe "submitting to the destroy action" do  
      before { delete micropost_path(FactoryGirl.create(:micropost))}
      it { expect(response).to redirect_to(signin_path) }
    end
  end
end