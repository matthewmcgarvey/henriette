module Henriette::QueryExtensions::HasManyMacros
  macro generate(model, association, query)
    def preload_{{ association[:assoc_name].id }}
      preload_{{ association[:assoc_name].id }}({{ query.id }}.new)
    end

    def preload_{{ association[:assoc_name].id }}(preload_query : {{ query.id }})
      add_preload do |records|
        ids = records.map(&.id)
        if ids.empty?
          {{ association[:assoc_name].id }} = {} of {{ association[:assoc_type] }}::PrimaryKeyType => Array({{ association[:assoc_type] }})
        else
          {% if association[:through] %}
            {% through_assoc = model.resolve.constant("ASSOCIATIONS")[association[:through]] %}
            {% assoc_assocs = association[:assoc_type].resolve.constant("ASSOCIATIONS").values %}
            {% through = assoc_assocs.select { |x| x[:assoc_type] == through_assoc[:assoc_type] }.first %}
            all_{{ association[:assoc_name].id }} = preload_query
              .join_{{ through[:assoc_name].id }}
              .__yield_where_{{ through[:assoc_name].id }} do |through_query|
                through_query.{{ association[:foreign_key].id }}.in(ids)
              end
              .preload_{{ through[:assoc_name].id }}
              .distinct

            {{ association[:assoc_name].id }} = {} of {{ association[:assoc_type] }}::PrimaryKeyType => Array({{ association[:assoc_type] }})
            all_{{ association[:assoc_name].id }}.each do |item|
              item_through = item.{{ through[:assoc_name].id }}
              {{ association[:assoc_name].id }}[item_through.{{ association[:foreign_key].id }}] ||= Array({{ association[:assoc_type] }}).new
              {{ association[:assoc_name].id }}[item_through.{{ association[:foreign_key].id }}] << item
            end
          {% else %}
            {{ association[:assoc_name].id }} = preload_query
              .{{ association[:foreign_key].id }}.in(ids)
              .results.group_by(&.{{ association[:foreign_key].id }})
          {% end %}
        end
        records.each do |record|
          record._preloaded_{{ association[:assoc_name].id }} = {{ association[:assoc_name].id }}[record.id]? || [] of {{ association[:assoc_type] }}
        end
      end
      self
    end
  end
end
