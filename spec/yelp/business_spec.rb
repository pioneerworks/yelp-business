require "spec_helper"

RSpec.describe Yelp::Business do
  it "has a version number" do
    expect(Yelp::Business::VERSION).not_to be nil
  end
end
