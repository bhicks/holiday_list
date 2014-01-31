require 'holiday/list/version'
require 'httparty'
require 'active_record'
require 'json'

module Holiday
  # MyList:
  # Used to generate a list of upcoming holidays
  class MyList
    def self.list
      new.to_a
    end

    def self.configure
      yield configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def initialize
      @request_string = GoogleCalendarRequestString.new configuration
    end

    def to_a
      argument_error! if invalid_request?

      json_response['items'].map do |item|
        {
          summary:    item['summary'],
          start_date: Date.parse(item['start']['date']),
          etag:       item['etag']
        }
      end
    end

    private

    def configuration
      self.class.configuration
    end

    def argument_error!
      fail ArgumentError, 'A valid google access key is required'
    end

    def invalid_request?
      return false unless response_error
      response_error['code'] == 400
    end

    def response
      @response ||= HTTParty.get @request_string
    end

    def json_response
      @json_response ||= JSON.parse(response.body)
    end

    def response_error
      json_response['error']
    end
  end
end

module Holiday
  class MyList
    # Configuration:
    # Used to persist access token configurations
    class Configuration
      attr_accessor :id, :key

      def configured?
        !key.nil?
      end
    end
  end
end

module Holiday
  class MyList
    # GoogleCalendarRequestString:
    # Generates the google calendar api request string
    class GoogleCalendarRequestString
      URL_BASE ||= 'https://www.googleapis.com/calendar/v3/calendars'

      attr_reader :id, :params

      def initialize(configuration)
        argument_error! unless configuration.configured?

        key = configuration.key
        @id = configuration.id

        @params = Params.new(key)
      end

      def to_str
        "#{URL_BASE}/#{id}/events?#{params}"
      end

      private

      def argument_error!
        fail ArgumentError, 'A valid google access key is required'
      end
    end
  end
end

module Holiday
  class MyList
    class GoogleCalendarRequestString
      # Params:
      # Munges google calendar api request parameters
      class Params < ActiveRecord::Base
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
          }.to_param
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
end
