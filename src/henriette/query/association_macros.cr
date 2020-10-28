abstract class Henriette::Query
  module AssociationMacros
    macro generate_belong_to_preload(model, association, query)
      def preload_{{ association[:assoc_name].id }}
        preload_{{ association[:assoc_name].id }}({{ query.id }}.new)
      end

      def preload_{{ association[:assoc_name].id }}(query : {{ query.id }})
        add_preload do |records|
          ids = [] of {{ model }}::PrimaryKeyType
          records.each do |record|
            record.{{ association[:foreign_key].id }}.try do |id|
              ids << id
            end
          end
          empty_results = {} of {{ model }}::PrimaryKeyType => Array({{ model }})
          {{ association[:assoc_name].id }} = ids.empty? ? empty_results  : preload_query.id.in(ids).results.group_by(&.id)
          records.each do |record|
            if id = record.{{ association[:foreign_key].id }}
              record.__set_preloaded_{{ association[:assoc_name].id }} {{ association[:assoc_name].id }}[id]?.try(&.first?)
            else
              record.__set_preloaded_{{ association[:assoc_name].id }} nil
            end
          end
        end
        self
      end
    end

    macro generate_has_many_preload(model, association, query)
      def preload_{{ association[:assoc_name].id }}
        preload_{{ association[:assoc_name].id }}({{ query.id }}.new)
      end

      def preload_{{ association[:assoc_name].id }}(preload_query : {{ query.id }})
        add_preload do |records|
          ids = records.map(&.id)
          if ids.empty?
            {{ association[:assoc_name].id }} = {} of {{ association[:assoc_type] }}::PrimaryKeyType => Array({{ association[:assoc_type] }})
          else
            {{ association[:assoc_name].id }} = preload_query
              .{{ association[:foreign_key].id }}.in(ids)
              .results.group_by(&.{{ association[:foreign_key].id }})
          end
          records.each do |record|
            record._preloaded_{{ association[:assoc_name].id }} = {{ association[:assoc_name].id }}[record.id]? || [] of {{ association[:assoc_type] }}
          end
        end
        self
      end
    end
  end
end
