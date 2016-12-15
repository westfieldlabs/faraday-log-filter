require 'delegate'

module Faraday
  module LogFilter
    class Env < SimpleDelegator
      def initialize(env, params_filter=[])
        super env
        @filter = Filter.new(params_filter)
      end

      def headers
        Array(response_headers).map { |k, v| "#{k}: #{v.inspect}" }.join("\n")
      end

      def http_verb
        __getobj__.method
      end

      def dump_url
        @filter.filter_url(url).to_s
      end

      def dump_body
        if self[:body].respond_to?(:to_str)
          self[:body].to_str
        else
          pretty_inspect(self[:body])
        end
      end

      def status
        super.to_s
      end

      def has_body?
        !!self[:body]
      end

      private
      def pretty_inspect(body)
        require 'pp' unless body.respond_to?(:pretty_inspect)
        body.pretty_inspect
      end
    end
  end
end
