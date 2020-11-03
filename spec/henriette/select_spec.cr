require "../spec_helper"

describe "select queries" do
  it "works" do
    manager = ManagerQuery.new.preload_business_sales.preload_employees.first
    pp manager.employees
    pp manager.business_sales

    employee = EmployeeQuery.new.preload_manager.first
    pp employee.manager
  end
end
