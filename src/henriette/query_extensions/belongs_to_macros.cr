module Henriette::QueryExtensions::BelongsToMacros
  macro generate(association, query)
    def preload_{{ association[:assoc_name].id }}
      preload_{{ association[:assoc_name].id }}({{ query.id }}.new)
    end

    def preload_{{ association[:assoc_name].id }}(preload_query : {{ query.id }})
      add_preload do |records|
        ids = [] of {{ association[:assoc_type].id }}::PrimaryKeyType
        records.each do |record|
          record.{{ association[:foreign_key].id }}.try do |id|
            ids << id
          end
        end
        empty_results = {} of {{ association[:assoc_type].id }}::PrimaryKeyType => Array({{ association[:assoc_type].id }})
        {{ association[:assoc_name].id }} : Hash({{ association[:assoc_type].id }}::PrimaryKeyType, Array({{ association[:assoc_type].id }}))
        {{ association[:assoc_name].id }} = ids.empty? ? empty_results  : preload_query.id.in(ids).results.group_by(&.id)
        records.each do |record|
          if id = record.{{ association[:foreign_key].id }}
            record._preloaded_{{ association[:assoc_name].id }} = {{ association[:assoc_name].id }}[id]?.try(&.first?)
          else
            record._preloaded_{{ association[:assoc_name].id }} = nil
          end
        end
      end
      self
    end

    def __yield_where_{{ association[:assoc_name].id }}
      assoc_query = yield {{ query.id }}.new
      merge_query(assoc_query.query)
    end

    def join_{{ association[:assoc_name].id }}
      inner_join_{{ association[:assoc_name].id }}
    end

    {% for join_type in ["Inner", "Left", "Right", "Full"] %}
      def {{ join_type.downcase.id }}_join_{{ association[:assoc_name].id }}
        join(
          Avram::Join::{{ join_type.id }}.new(
            from: table_name,
            to: {{ association[:assoc_type].id }}.table_name,
            primary_key: {{ association[:foreign_key].id.symbolize }},
            foreign_key: {{ association[:assoc_type].id }}::PRIMARY_KEY_NAME
          )
        )
      end
    {% end %}
  end
end
