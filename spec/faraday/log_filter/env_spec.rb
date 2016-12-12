require "spec_helper"
require 'uri'
describe Faraday::LogFilter::Env do
  subject { described_class.new(env) }
  let(:env) { double('Env') }

  describe "#has_body?" do
    context "when env has body" do
      let(:env) { {body: "content" } }

      it { is_expected.to have_body }
    end

    context "when env has no body" do
      let(:env) { {} }

      it { is_expected.not_to have_body }
    end
  end

  describe "#dump_url" do
    let(:url) { URI("http://google.com?param=value") }
    let(:env) { double(url: url) }

    it "returns the env url as string" do
      expect(subject.dump_url).to eq("http://google.com?param=value")
    end

    it "filters the url params" do
      expect_any_instance_of(Faraday::LogFilter::Filter).to receive(:filter_url).with(url)

      subject.dump_url
    end
  end

  describe "#dump_body" do
    context "when body content is a string" do
      let(:env) { {body: "some content"} }

      it "returns the body content" do
        expect(subject.dump_body).to eq "some content"
      end
    end

    context "when body content is not a string" do
      let(:body) { {foo: "bar", baz: "zaz"} }
      let(:env) { {body: body} }

      it "returns the body content" do
        require 'pp'
        expect(subject.dump_body).to eq body.pretty_inspect
      end
    end
  end

  describe "#headers" do
    let(:headers) do
      {
        AUTHENTICATON: 'Bearer foo',
        Accept: 'application/json'
      }
    end
    let(:env) { double('Env', response_headers: headers) }

    it "returns all headers as string" do
      expect(subject.headers).to eq "AUTHENTICATON: \"Bearer foo\"\nAccept: \"application/json\""
    end
  end

  describe "#status" do
    let(:env) { double('Env', status: 200) }
    it "return status as string" do
      expect(subject.status).to eq "200"
    end
  end

  describe "#http_verb" do
    let(:env) { double("Env", method: "POST") }
    it "returns env method" do
      expect(subject.http_verb).to eq("POST")
    end
  end
end
