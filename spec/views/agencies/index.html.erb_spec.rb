require 'spec_helper'

describe "agencies/index" do
  before(:each) do
    assign(:agencies, [
      stub_model(Agency,
        :name => "Name"
      ),
      stub_model(Agency,
        :name => "Name"
      )
    ])
  end

  it "renders a list of agencies" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
