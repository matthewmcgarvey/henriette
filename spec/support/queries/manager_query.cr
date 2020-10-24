class ManagerQuery < Henriette::Query
  generate_for Manager
  connect_with :employees, EmployeeQuery
end
