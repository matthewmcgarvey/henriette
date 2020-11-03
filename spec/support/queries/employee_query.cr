class EmployeeQuery < Henriette::Query(Employee)
  generate_for Employee
  connect_with :manager, ManagerQuery
  connect_with :business_sales, BusinessSaleQuery
end
