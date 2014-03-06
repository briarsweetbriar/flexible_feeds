# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flexible_feeds_feed,
          :class => 'FlexibleFeeds::Feed',
          aliases: [:feed] do
            name "My Feed"
  end
end
