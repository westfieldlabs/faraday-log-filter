require "spec_helper"

require "logger"
require "stringio"

describe Faraday::LogFilter::Middleware do
  let(:log) { StringIO.new }
  let(:logger) { Logger.new(log) }

  it "logs with the filtered params" do
    connection(logger, filter: [:api]).get("/temaki?api=122435")
    log.rewind
    expect(log.read).to include("api=[FILTERED]")
  end

  it "logs the request method at an INFO level" do
    connection(logger).get("/temaki?api=123456")
    log.rewind
    expect(log.read).to match(/\bINFO\b.+\bGET\b/)
  end

  it "logs the request URI at an INFO level" do
    connection(logger).get("/temaki?api=123456")
    log.rewind
    expect(log.read).to match(%r{\bINFO\b.+\bhttp://sushi.com/temaki\b})
  end

  it "logs a response status code at an INFO level" do
    connection(logger).get("/temaki")
    log.rewind
    expect(log.read).to match(/INFO.+Status: 200\b/)
  end

  it "doesn't logs request's body" do
    connection(logger).post("/nigirizushi")
    log.rewind
    expect(log.readlines.join).not_to include('DEBUG -- response: {"id":"1"}')
  end

  it "logs the request's headers at DEBUG level" do
    connection(logger).post('/nigirizushi')
    log.rewind

    expect(log.readlines.join).to include('DEBUG -- response: Content-Type: "application/json"')
  end

  context "when set body log to true" do
    it "logs the request's body at DEBUG level" do
      connection(logger, log_options: { bodies: true }).post('/nigirizushi')
      log.rewind

      expect(log.readlines.join).to include('DEBUG -- response: {"id":"1"}')
    end
  end

  context "when set headers log to false" do
    it "doesn't log the request's headers" do
      connection(logger, log_options: { headers: false }).post('/nigirizushi')
      log.rewind

      expect(log.readlines.join).not_to include('DEBUG -- response: Content-Type: "application/json"')
    end
  end

  private

  def connection(logger = nil, config={})
    Faraday.new(url: "http://sushi.com") do |builder|
      builder.request(:url_encoded)
      builder.response(:log_filter, logger, config)
      builder.adapter(:test) do |stub|
        stub.get("/temaki") do
          [200, { "Content-Type" => "text/plain" }, "temaki"]
        end
        stub.post("/nigirizushi") do
          [200, { "Content-Type" => "application/json" }, "{\"id\":\"1\"}"]
        end
      end
    end
  end
end
