require "../spec_helper"

describe "select queries" do
  it "works" do
    manager = ManagerQuery.new.preload_employees.first
    pp manager.employees

    employee = EmployeeQuery.new.preload_manager.first
    pp employee.manager
  end
end
