module FlexibleFeeds
  module ActsAsChild
    extend ActiveSupport::Concern
 
    module ClassMethods
      def acts_as_child(options = {})

        def is_childish?
          true
        end

        after_destroy :decrement_parent_counter

        send :include, InstanceMethods
      end
    end

    module InstanceMethods
      def is_childish?
        true
      end

      def parent
        event.parent
      end

      def ancestor
        event.ancestor
      end

      def child_of(parent)
        if can_accept_parent?(parent.eventable)
          ancestor = parent.try(:ancestor) || parent
          event.update_attributes(parent: parent, ancestor: ancestor)
          event.increment_parent_counter
        end
      end

      private
      def can_accept_parent?(parent)
        if parent.class.try(:permitted_children).present?
          parent.class.permitted_children.include?(self.class)
        elsif parent.class.try(:unpermitted_children).present?
          !parent.class.unpermitted_children.include?(self.class)
        else
          parent.try(:is_parental?)
        end
      end

      def decrement_parent_counter
        event.decrement_parent_counter
      end
    end
  end
end

ActiveRecord::Base.send :include, FlexibleFeeds::ActsAsChild