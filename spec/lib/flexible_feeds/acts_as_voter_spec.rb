require 'spec_helper'

module FlexibleFeeds
  describe ActsAsVoter do

    it "has_many votes" do
      user = FactoryGirl.build(:user)
      expect(user).to have_many(:votes)
    end
  end
end