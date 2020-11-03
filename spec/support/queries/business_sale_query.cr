class BusinessSaleQuery < Henriette::Query(BusinessSale)
  generate_for BusinessSale
  connect_with :employee, EmployeeQuery
end
