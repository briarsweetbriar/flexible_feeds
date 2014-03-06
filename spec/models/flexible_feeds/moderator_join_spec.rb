require 'spec_helper'

module FlexibleFeeds
  describe ModeratorJoin do

    context "belongs to" do
      before :each do
        @moderator_join = FactoryGirl.build(:flexible_feeds_moderator_join)
      end

      it "feed" do
        expect(@moderator_join).to belong_to(:feed)
      end

      it "moderator" do
        expect(@moderator_join).to belong_to(:moderator)
      end
    end
  end
end
