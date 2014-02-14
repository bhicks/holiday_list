require 'holiday_list/params'
require 'holiday_list/request_exception'

class HolidayList
  # GoogleCalendarRequestString:
  # Generates the google calendar api request string
  class GoogleCalendarRequestString
    include RequestException

    # TODO:
    # - make class more extensible
    #   - URL_BASE should be a method, so we can override it for other calendar providers
    # - rename class, redundat String, and is it really a 'Request'?
    # - don't think 'to_str' is working. should work like:
    #     gcrs = GoogleCalendarRequestString.new(configuration)
    #     conn.get gcrs # '/calendar/v3/calendars/12345/events?time_min=yesterday'
    URL_BASE ||= 'https://www.googleapis.com'
    URL_PATH ||= '/calendar/v3/calendars'

    attr_reader :id, :params

    def initialize(configuration)
      argument_error! unless configuration.configured?

      key = configuration.key
      @id = configuration.id

      @params = Params.new(key)
    end

    def to_str
      "#{URL_PATH}/#{id}/events?#{params}"
    end
  end
end
