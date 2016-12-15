require "spec_helper"

describe Faraday::LogFilter::Filter do
  describe "#filter_url" do
    subject { described_class.new([:foo, token: :truncate, api_key: :truncate]) }

    let(:url) do
      URI("http://foo.bar?token=sometoken&format=json&api_key=12345677890&foo=bar")
    end

    it "filters out one of the parameters and truncates the other" do
      expect(subject.filter_url(url)).to eq(
        URI("http://foo.bar?token=somet&format=json&api_key=12345&foo=[FILTERED]")
      )
    end
  end
end
