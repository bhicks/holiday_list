require 'active_support/core_ext/object/to_query'
require 'active_support/core_ext/date_time/calculations'

class HolidayList
  # Params:
  # Munges google calendar api request parameters
  class Params
    attr_reader :key

    def initialize(key, time_options = {})
      @key     = key
      @options = time_options

      validate_options!
    end

    def to_s
      params_hash.to_query
    end

    def params_hash
      {
        key:          key,
        orderBy:      order_by,
        singleEvents: single_events,
        timeMin:      time_min,
        timeMax:      time_max
      }
    end

    private

    def time_min
      @time_min ||= @options.fetch('start') { DateTime.now }
    end

    def time_max
      @time_max ||= @options.fetch('stop') { DateTime.now.next_year }
    end

    def order_by
      'startTime'
    end

    def single_events
      true
    end

    def validate_options!
      message = 'Start and end dates must be valid DateTime objects that'\
                ' occur sequentially'

      fail ArgumentError, message if [time_min, time_max].any? do |time|
        time.class != DateTime
      end

      fail ArgumentError, message if time_min > time_max
    end
  end
end
