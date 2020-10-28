class EmployeeQuery < Henriette::Query
  generate_for Employee
  connect_with :manager, ManagerQuery
end
