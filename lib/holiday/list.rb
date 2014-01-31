require 'holiday/list/version'
require 'httparty'
require 'active_record'
require 'json'

module Holiday
  module List
    module_function

    def list
      HolidayList.new.to_a
    end

    def configure
      yield configuration
    end

    def configuration
      @configuration ||= HolidayList::Configuration.new
    end
  end
end

class HolidayList
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

  class Configuration
    attr_accessor :id, :key
  end

  private

  def argument_error!
    fail ArgumentError, 'A valid google access key is required'
  end

  def initialize
    @calendar_request_string = GoogleCalendarRequestString.new
  end

  def invalid_request?
    return false unless response_error
    response_error['code'] == 400
  end

  def response
    @response ||= HTTParty.get @calendar_request_string
  end

  def json_response
    @json_response ||= JSON.parse(response.body)
  end

  def response_error
    json_response['error']
  end

  class GoogleCalendarRequestString
    attr_reader :id, :params

    def initialize
      key     = Holiday::List.configuration.key
      @id     = Holiday::List.configuration.id

      fail ArgumentError, 'A valid google access key is required' unless key

      @params = Params.new(key)
    end

    def to_str
      "https://www.googleapis.com/calendar/v3/calendars/#{id}/events?#{params}"
    end

    class Params < ActiveRecord::Base
      attr_reader :key, :time_min, :time_max

      def initialize(key, time_options = {})
        @key      = key
        @time_min = time_options.fetch('start') { DateTime.now.to_s }
        @time_max = time_options.fetch('end') { (DateTime.now + 1.year).to_s }
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
