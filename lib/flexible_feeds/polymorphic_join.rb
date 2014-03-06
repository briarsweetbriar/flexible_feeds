module FlexibleFeeds
  module PolymorphicJoin
    extend ActiveSupport::Concern

    module ClassMethods
      def polymorphically_joined_through(join_table, params)
        association = params[:association_name]
        singular_association = params[:singular_association_name]
        define_association(join_table, association, singular_association)
        define_include(join_table, association, singular_association)
        define_add(join_table, association, singular_association)
        define_remove(join_table, association, singular_association)
      end

      def define_association(join_table, association, singular_association)
        define_method association do
          send(join_table).collect { |join| join.send(singular_association) }
        end
      end

      def define_include(join_table, association, singular_association)
        define_method "#{association}_include?".to_sym do |instance|
          send(join_table).where(singular_association => instance).exists?
        end
      end

      def define_add(join_table, association, singular_association)
        define_method "add_#{singular_association}".to_sym do |instance|
          result = send(join_table).create(singular_association => instance)
          self.reload()
          result
        end
      end

      def define_remove(join_table, association, singular_association)
        define_method "remove_#{singular_association}".to_sym do |instance|
          return false unless send("#{association}_include?", instance)
          result = send(join_table).
            find_by(singular_association => instance).destroy
          self.reload()
          result
        end
      end
    end
  end

end
