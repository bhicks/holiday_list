class HolidayList
  # Configuration:
  # Used to persist access token configurations
  class Configuration
    attr_accessor :id, :key

    def configured?
      !key.nil?
    end
  end
end
