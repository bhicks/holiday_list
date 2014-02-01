class HolidayList
  # RequestException
  # Provides convenience methods for common exceptions
  module RequestException
    private

    def argument_error!(message = nil)
      message ||= 'A valid google access key is required'
      fail ArgumentError, message
    end
  end
end
