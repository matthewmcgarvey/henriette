class BaseModel < Henriette::Model
  def self.database : Avram::Database.class
    TestDatabase
  end
end
