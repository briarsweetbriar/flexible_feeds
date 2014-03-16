module FlexibleFeeds
  module ActsAsParent
    extend ActiveSupport::Concern
 
    module ClassMethods
      def acts_as_parent(options = {})

        cattr_accessor :permitted_children
        cattr_accessor :unpermitted_children
        self.permitted_children = options[:permitted_children]
        self.unpermitted_children = options[:unpermitted_children]

        def is_parental?
          true
        end

        send :include, InstanceMethods
      end
    end

    module InstanceMethods
      def is_parental?
        true
      end

      def children
        FlexibleFeeds::Event.where(parent: event).includes(:eventable)
      end

      def descendants
        FlexibleFeeds::Event.where(ancestor: event).includes(:eventable)
      end

      def parent_of(child)
        if can_accept_child?(child.eventable)
          ancestor = self.try(:ancestor) || self.event
          child.update_attributes(parent: self.event, ancestor: ancestor)
          child.increment_parent_counter
        end
      end

      private
      def can_accept_child?(child)
        if self.class.permitted_children.present?
          self.class.permitted_children.include?(child.class)
        elsif self.class.unpermitted_children.present?
          !self.class.unpermitted_children.include?(child.class)
        else
          child.try(:is_childish?)
        end
      end

      def initialize_event
        event || create_event
      end
    end
  end
end

ActiveRecord::Base.send :include, FlexibleFeeds::ActsAsParent