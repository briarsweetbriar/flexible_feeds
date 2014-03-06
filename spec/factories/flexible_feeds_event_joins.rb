# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flexible_feeds_event_join, :class => 'FlexibleFeeds::EventJoin' do
    feed
    event
  end
end
