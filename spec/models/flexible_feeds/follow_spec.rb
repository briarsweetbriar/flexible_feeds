require 'spec_helper'

module FlexibleFeeds
  describe Follow do

    context "belongs to" do
      before :each do
        @follow = FactoryGirl.build(:flexible_feeds_follow)
      end

      it "follower" do
        expect(@follow).to belong_to(:follower)
      end

      it "feed" do
        expect(@follow).to belong_to(:feed)
      end
    end
  end
end
