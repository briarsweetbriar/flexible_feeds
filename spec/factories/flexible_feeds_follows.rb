# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flexible_feeds_follow, :class => 'FlexibleFeeds::Follow' do
    feed
    follower { |a| a.association(:user) }
  end
end
