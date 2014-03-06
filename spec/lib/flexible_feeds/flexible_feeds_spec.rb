require 'spec_helper'

module FlexibleFeeds
  describe FlexibleFeeds do

    context "has a has_one feed association by default" do
      before :each do
        @user = FactoryGirl.create(:user)
      end

      it "which is dependent: :destroy" do
        expect(@user).to have_one(:feed).class_name("FlexibleFeeds::Feed").
          dependent(:destroy)
      end

      it "which is automatically created after_save" do
        expect(@user.feed).to eq FlexibleFeeds::Feed.first
      end
    end

    context "has the option for a has_many feed association" do
      before :each do
        @group = FactoryGirl.create(:group)
      end

      it "which is dependent: :destroy" do
        expect(@group).to have_many(:feeds).class_name("FlexibleFeeds::Feed").
          dependent(:destroy)
      end

      it "which are not automatically created" do
        expect(@group.feeds.length).to eq 0
      end

      context "which are scoped by name" do
        before :each do
          @feed1 = @group.feeds.create(name: "Feed 1")
          @feed2 = @group.feeds.create(name: "Feed 2")
          @feed3 = @group.feeds.create(name: "Feed 3")
        end

        it "so that they return the requested feed" do
          expect(@group.feed_named("Feed 2")).to eq @feed2
        end
      end
    end

  end
end
