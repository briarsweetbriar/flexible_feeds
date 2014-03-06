# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group, :class => 'Group' do
    name "My Name"
  end
end
