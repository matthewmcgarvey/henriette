class BusinessSale < BaseModel
  primary_key id : Int64
  column created_at : Time
  column updated_at : Time
  column name : String
  belongs_to employee : Employee
end
