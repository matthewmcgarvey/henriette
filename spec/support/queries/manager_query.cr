class ManagerQuery < Henriette::Query(Manager)
  generate_for Manager
  connect_with :employees, EmployeeQuery
  connect_with :business_sales, BusinessSaleQuery
end
