require "../spec_helper"

describe "select queries" do
  it "works" do
    manager = ManagerQuery.first
    pp manager
  end
end
