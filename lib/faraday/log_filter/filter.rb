module Faraday
  module LogFilter
    class Filter
      def initialize(params_to_filter)
        params_to_filter = Array(params_to_filter)
        @params_to_truncate = params_to_filter.last.is_a?(Hash) ? params_to_filter.pop : {}
        @params_to_filter   = params_to_filter | @params_to_truncate.keys
      end

      def filter_url(url)
        url.query = filtered_query_for(url).map { |params| params.join("=") }.join("&")

        url
      end

      private

      def filtered_query_for(url)
        filter(CGI::parse(url.query.to_s))
      end

      def filter(params)
        params.map do |param, value|
          [
            param,
            filter_or_truncate_param(param, value)
          ]
        end.to_h
      end

      def in_filter_list?(param)
        @params_to_filter.include? param.to_sym
      end

      def filter_or_truncate_param(param, value)
        return value unless in_filter_list?(param)

        @params_to_truncate[param.to_sym] ? value.first[0..4] : "[FILTERED]"
      end
    end
  end
end
