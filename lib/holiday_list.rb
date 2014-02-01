require 'holiday_list/version'
require 'holiday_list/configuration'
require 'holiday_list/google_calendar_request_string'
require 'httparty'
require 'json'

# MyList:
# Used to generate a list of upcoming holidays
class HolidayList
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
