require 'spec_helper'

describe "Agencies" do
  describe "GET /agencies" do
    it "works! (now write some real specs)" do
      get agencies_path
      response.status.should be(200)
    end
  end
end
