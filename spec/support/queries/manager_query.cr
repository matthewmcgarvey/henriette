class ManagerQuery < Henriette::Query(Manager)
  generate_for Manager
  connect_with :employees, EmployeeQuery
end
