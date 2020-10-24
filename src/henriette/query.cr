require "./query/**"

abstract class Henriette::Query
  def_clone
  private getter query_builder

  macro generate_for(model)
    {% model = model.resolve %}
    MODEL = {{ model }}
    class_getter table_name = {{ model.id }}.table_name
    class_getter schema_class = {{ model }}
    include Avram::Queryable({{ model }})

    {% if model.has_constant?("PRIMARY_KEY") %}
      BaseMacros.generate_primary_key_methods({{ model }}, {{ model.constant("PRIMARY_KEY_NAME") }}, {{ model.constant("PRIMARY_KEY_TYPE") }})
    {% end %}
    BaseMacros.generate_property_conditions({{ model.constant("COLUMNS") }})
    BaseMacros.generate_general_methods({{ model }})
  end

  macro connect_with(assoc_name, query)
    {% model = MODEL.resolve %}
    {% association = model.constant("ASSOCIATIONS")[assoc_name] %}
    {% if association[:relationship] == :belongs_to %}
      AssociationMacros.generate_belongs_to_preload({{ model }}, {{ association }}, {{ query }})
    {% elsif association[:relationship] == :has_many %}
      AssociationMacros.generate_has_many_preload({{ model}}, {{ association }}, {{ query }})
    {% end %}
  end

  def update : Int64
    raise "NOT IMPLEMENTED"
  end
end
