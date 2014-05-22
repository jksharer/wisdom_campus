require 'spec_helper'

describe "agencies/show" do
  before(:each) do
    @agency = assign(:agency, stub_model(Agency,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
