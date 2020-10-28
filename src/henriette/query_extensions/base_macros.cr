module Henriette::QueryExtensions::BaseMacros
  macro generate_property_conditions(columns)
    {% for column in columns %}
      def {{ column.var }}(value : {{ column.type }})
        {{ column.var }}.eq(value)
      end

      def {{ column.var }}
        column_name = "#{table_name}.{{ column.var }}"
        {{ column.type }}::Lucky::Criteria(self, {{ column.type }}).new(self, column_name)
      end
    {% end %}
  end
end
