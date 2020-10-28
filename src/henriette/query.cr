require "./query_extensions/**"

abstract class Henriette::Query(T) < Avram::Query(T)
  include Avram::Queryable(T)
  include Henriette::QueryExtensions
  def_clone
  private getter query_builder

  macro generate_for(model)
    {% model = model.resolve %}
    MODEL = {{ model }}

    {% if model.has_constant?("PRIMARY_KEY") %}
      include Avram::PrimaryKeyQueryable({{ model }})
    {% end %}
    BaseMacros.generate_property_conditions({{ model.constant("COLUMNS") }})
  end

  macro connect_with(assoc_name, query)
    {% model = MODEL.resolve %}
    {% association = model.constant("ASSOCIATIONS")[assoc_name] %}
    {% if association[:relationship] == :belongs_to %}
      BelongsToMacros.generate({{ association }}, {{ query }})
    {% elsif association[:relationship] == :has_many %}
      HasManyMacros.generate({{ model }}, {{ association }}, {{ query }})
    {% end %}
  end

  def update : Int64
    raise "NOT IMPLEMENTED"
  end
end
