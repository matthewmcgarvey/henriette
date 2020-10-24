abstract class Henriette::Model

  macro inherited
    include ::DB::Serializable

    # contains TypeDeclaration, should only be accessed with macros
    COLUMNS = [] of Nil
    # contains TypeDeclaration, should only be accessed with macros
    ASSOCIATIONS = {} of Nil => Nil
    COLUMN_NAMES = [] of Symbol
    default_table_name

    def self.column_names : Array(Symbol)
      COLUMN_NAMES
    end
  end

  macro primary_key(decl)
    PRIMARY_KEY_NAME = {{ decl.var }}
    PRIMARY_KEY_TYPE = {{ decl.type }}
    alias PrimaryKeyType = {{ decl.type }}
    column {{ decl }}
  end

  macro column(decl)
    {% COLUMNS << decl %}
    {% COLUMN_NAMES << decl.var.symbolize %}
    property {{ decl }}
  end

  macro belongs_to(decl)
    {% foreign_key = "#{decl.var}_id" %}
    {% ASSOCIATIONS[decl.var.symbolize] = { relationship: :belongs_to, assoc_name: decl.var, assoc_type: decl.type, foreign_key: foreign_key } %}
    column({{ foreign_key.id }} : {{ decl.type }}::PrimaryKeyType)
  end

  macro has_many(decl)
    {% foreign_key = "#{@type.name.underscore.split("::").last.id}_id".id %}
    {% ASSOCIATIONS[decl.var.symbolize] = { relationship: :has_many, assoc_name: decl.var, assoc_type: decl.type, foreign_key: foreign_key } %}
    @[::DB::Field(ignore: true)]
    property {{ decl }} = {{ decl.type }}.new
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
