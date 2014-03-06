# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flexible_feeds_moderator_join, :class => 'FlexibleFeeds::ModeratorJoin' do
    feed
    moderator { |a| a.association(:user) }
  end
end
