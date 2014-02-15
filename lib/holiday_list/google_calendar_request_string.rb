require 'holiday_list/params'
require 'holiday_list/request_exception'

class HolidayList
  # GoogleCalendarRequestString:
  # Generates the google calendar api request string
  class GoogleCalendarRequestString
    include RequestException

    # TODO:
    # - make class more extensible
    # - rename class, redundat String, and is it really a 'Request'?
    # - don't think 'to_str' is working. should work like:
    #     gcrs = GoogleCalendarRequestString.new(configuration)
    #     conn.get gcrs # '/calendar/v3/calendars/12345/events?time_min=yesterday'
    def self.url_base
      'https://www.googleapis.com'
    end

    def url_path
      '/calendar/v3/calendars'
    end

    attr_reader :id, :params

    def initialize(configuration)
      argument_error! unless configuration.configured?

      key = configuration.key
      @id = configuration.id

      @params = Params.new(key)
    end

    def to_str
      "#{url_path}/#{id}/events?#{params}"
    end
  end
end
