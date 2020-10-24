abstract class Henriette::Query
  module BaseMacros
    macro generate_primary_key_methods(model, primary_key_name, primary_key_type)
      def self.find(id : {{ primary_key_type }})
        new.find(id)
      end

      def find(id : {{ primary_key_type }})
        {{ primary_key_name }}(id).first
      end
    end

    macro generate_property_conditions(columns)
      {% for column in columns %}
        def {{ column.var }}(value : {{ column.type }})
          {{ column.var }}.eq(value)
        end

        def {{ column.var }}
          column_name = "#{self.class.table_name}.{{ column.var }}"
          {{ column.type }}::Lucky::Criteria(self, {{ column.type }}).new(self, column_name)
        end
      {% end %}
    end

    macro generate_general_methods(model)
      def database : Avram::Database.class
        {{ model }}.database
      end
    end
  end
end
