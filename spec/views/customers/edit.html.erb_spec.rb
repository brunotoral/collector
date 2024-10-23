require 'rails_helper'

RSpec.describe "customers/edit", type: :view do
  let(:customer) {
    Fabricate(:customer)
  }

  before(:each) do
    assign(:customer, customer)
  end

  it "renders the edit customer form" do
    render

    assert_select "form[action=?][method=?]", customer_path(customer), "post" do
    end
  end
end
