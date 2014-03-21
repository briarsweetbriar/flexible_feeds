module FlexibleFeeds
  module ActsAsVoter
    extend ActiveSupport::Concern
 
    module ClassMethods
      def acts_as_voter(options = {})

        has_many :votes, as: :voter, class_name: "FlexibleFeeds::Vote"
      end
    end
  end
end

ActiveRecord::Base.send :include, FlexibleFeeds::ActsAsVoter