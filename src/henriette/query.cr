abstract class Henriette::Query
  def_clone
  private getter query_builder

  macro connect(model)
    {% model = model.resolve %}
    class_getter table_name = {{ model.id }}.table_name
    class_getter schema_class = {{ model }}
    include Avram::Queryable({{ model }})

    {% if model.has_constant?("PRIMARY_KEY") %}
      generate_primary_key_methods({{ model }}, {{ model.constant("PRIMARY_KEY_NAME") }}, {{ model.constant("PRIMARY_KEY_TYPE") }})
    {% end %}
    generate_property_conditions({{ model.constant("COLUMNS") }})
    generate_general_methods({{ model }})
  end

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
        condition = Core::Where::Equal.new(
          column: {{ column.var.symbolize }},
          value: value
        )
        query_builder.where(condition)
      end

      def {{ column.var }}(_nil : Nil)
        condition = Core::Where::IsNull.new(column: {{ column.var.symbolize }})
        query_builder.where(condition)
      end

      def {{ column.var }}(values : Array({{ column.type }}))
        condition = Core::Where::IsIn.new(
          column: {{ column.var.symbolize }},
          value: values
        )
        query_builder.where(condition)
      end
    {% end %}
  end

  macro generate_general_methods(model)
    def database : Avram::Database.class
      {{ model }}.database
    end
  end

  def update : Int64
    raise "NOT IMPLEMENTED"
  end
end
