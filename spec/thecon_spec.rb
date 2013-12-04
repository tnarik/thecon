require 'spec_helper'

describe Thecon do
  describe "::VERSION" do
    it "exists" do
    	expect(Thecon::VERSION).not_to be_empty
    end
  end

  describe "::ready?" do
    it "exists" do
      expect(Thecon::respond_to? :ready?).to eq(true)
    end

    it "returns true for an known and valid IP" do
      expect(Thecon::ready?(80, "www.google.com") ).to eq(true)
    end

    it "returns false for an invalid IP" do
      expect(Thecon::ready?(80, "192.0.2.0") ).to eq(false)
    end
  end
end