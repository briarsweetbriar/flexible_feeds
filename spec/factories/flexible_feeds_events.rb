# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flexible_feeds_event,
          class: 'FlexibleFeeds::Event',
          aliases: [:event] do
            eventable { |a| a.association(:comment) }
            creator { |a| a.association(:user) }
  end
end
