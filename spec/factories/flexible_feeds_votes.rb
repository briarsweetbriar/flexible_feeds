# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :flexible_feeds_vote, :class => 'FlexibleFeeds::Vote' do
    event
    voter { |a| a.association(:user) }
    value 1
  end
end
