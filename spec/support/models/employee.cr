class Employee < BaseModel
  primary_key id : Int8
  column created_at : Time
  column updated_at : Time
  column name : String
  belongs_to manager : Manager
end
