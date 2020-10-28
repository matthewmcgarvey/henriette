abstract class Henriette::Query
  module HasManyMacros
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
