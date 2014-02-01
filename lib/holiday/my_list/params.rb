require 'active_support/core_ext/object/to_query'

module Holiday
  class MyList
    # Params:
    # Munges google calendar api request parameters
    class Params
      attr_reader :key

      def initialize(key, time_options = {})
        @key     = key
        @options = time_options
      end

      def to_s
        {
          key:          key,
          orderBy:      order_by,
          singleEvents: single_events,
          timeMin:      time_min,
          timeMax:      time_max
        }.to_query
      end

      private

      def time_min
        @time_min ||= @options.fetch('start') { DateTime.now.to_s }
      end

      def time_max
        @time_max ||= @options.fetch('end') { (DateTime.now + 1.year).to_s }
      end

      def order_by
        'startTime'
      end

      def single_events
        true
      end

      def time_min
        DateTime.now.to_s
      end

      def time_max
        (DateTime.now + 365).to_s
      end
    end
  end
end
