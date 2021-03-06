class Manager < BaseModel
  primary_key id : Int64
  column created_at : Time
  column updated_at : Time
  column name : String
  has_many employees : Array(Employee)
  has_many business_sales : Array(BusinessSale), through: :employees
end
