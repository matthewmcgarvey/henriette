abstract class Henriette::Model

  macro inherited
    include ::DB::Serializable

    # contains TypeDeclaration, should only be accessed with macros
    COLUMNS = [] of Nil
    COLUMN_NAMES = [] of Symbol
    default_table_name

    def self.column_names : Array(Symbol)
      COLUMN_NAMES
    end
  end

  macro primary_key(decl)
    PRIMARY_KEY_NAME = {{ decl.var }}
    PRIMARY_KEY_TYPE = {{ decl.type }}
    column {{ decl }}
  end

  macro column(type)
    {% COLUMNS << type %}
    {% COLUMN_NAMES << type.var.symbolize %}
    property {{ type }}
  end

  macro default_table_name
    {% table_name = run("../run_macros/infer_table_name.cr", @type.id) %}
    table {{ table_name }}
  end

  macro table(table_name)
    def self.table_name : Symbol
      {{ table_name.id.symbolize }}
    end

    def table_name : Symbol
      self.class.table_name
    end
  end
end
