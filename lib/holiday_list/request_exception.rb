class HolidayList
  # RequestException
  # Provides convenience methods for common exceptions
  module RequestException
    private

    def argument_error!
      fail ArgumentError, 'A valid google access key is required'
    end
  end
end
