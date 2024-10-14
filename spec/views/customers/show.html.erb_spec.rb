require 'rails_helper'

RSpec.describe "customers/show", type: :view do
  before(:each) do
    assign(:customer, Fabricate(:customer))
  end

  it "renders attributes in <p>" do
    render
  end
end
