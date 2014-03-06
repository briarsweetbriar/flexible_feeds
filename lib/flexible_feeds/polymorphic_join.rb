module FlexibleFeeds
  module PolymorphicJoin
    extend ActiveSupport::Concern

    module ClassMethods
      def polymorphically_joined_through(join_table, params)
        association = params[:association_name]
        singular_association = params[:singular_association_name]
        
        define_method association do
          send(join_table).collect { |join| join.send(singular_association) }
        end
        
        define_method "#{association}_include?".to_sym do |instance|
          send(join_table).where(singular_association => instance).exists?
        end
        
        define_method "add_#{singular_association}".to_sym do |instance|
          result = send(join_table).create(singular_association => instance)
          self.reload()
          result
        end
        
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
