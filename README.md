# Faraday::LogFilter

A Faraday middleware for params filtering in logs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "faraday-log-filter", github: "westfieldlabs/faraday-log-filter"
```

And then execute:

```bash
$ bundle install
```

## Usage

Once required, the logger can be added to any Faraday connection by inserting
it into your connection's request/response stack:

```ruby
connection = Faraday.new(url: "http://foo.com") do |faraday|
  faraday.request  :url_encoded
  faraday.response :log_filter, nil, 
    filter: [:param1, param2: :truncate], 
    log_options: { bodies: false, headers: true }
end
```

By default, the Faraday::LogFilter will log to STDOUT. If this is not your
desired log location, simply provide any Logger-compatible object as a
parameter to the middleware definition:

```ruby
faraday.response :log_filter, Rails.logger, filter: filter: [:param1, param2: :truncate]
```

### Example output

#### Request logging

Log output for the request-portion of an HTTP interaction:

```plain
GET http://sushi.com/temaki?param1=[FILTERED]&param2=12345
```
