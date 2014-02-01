require 'holiday_list/params'
require 'holiday_list/request_exception'

class HolidayList
  # GoogleCalendarRequestString:
  # Generates the google calendar api request string
  class GoogleCalendarRequestString
    include RequestException

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
  end
end
