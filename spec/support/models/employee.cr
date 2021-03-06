class Employee < BaseModel
  primary_key id : Int64
  column created_at : Time
  column updated_at : Time
  column name : String
  belongs_to manager : Manager
  has_many business_sales : Array(BusinessSale)
end
