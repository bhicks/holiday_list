require 'spec_helper'

describe HolidayList do
  before do
    new_time = Time.local(2014, 1, 29, 12, 0, 0)
    Timecop.freeze(new_time)
  end

  after do
    Timecop.return
  end

  subject { HolidayList.list }

  shared_context 'valid credentials' do
    before do
      HolidayList.configure do |config|
        config.id  = 'usa__en@holiday.calendar.google.com'
        config.key = 'A_GOOD_KEY'
      end
    end
  end

  context 'with valid credentials' do
    include_context 'valid credentials'

    it 'should generate a list' do
      VCR.use_cassette '01 29 2014 list' do
        expect(subject.length).to eq(30)
      end
    end
  end

  context 'without credentials' do
    before do
      HolidayList.configure do |config|
        config.id  = nil
        config.key = nil
      end
    end

    it 'should raise an argument error' do
      VCR.use_cassette 'no google access key' do
        expect { subject.first }.to raise_error(ArgumentError)
      end
    end
  end

  context 'without valid credentials' do
    before do
      HolidayList.configure do |config|
        config.id  = 'bad_id'
        config.key = 'bad_key'
      end
    end

    it 'should raise an error' do
      VCR.use_cassette 'bad google access_key' do
        expect { subject.first }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'a holiday' do
    include_context 'valid credentials'

    let(:holiday) do
      VCR.use_cassette '01 29 2014 list' do
        subject.first
      end
    end

    it 'summary should be Groundhog Day' do
      expect(holiday[:summary]).to eq('Groundhog Day')
    end

    it 'start date should be valid' do
      groundhog_day = Date.parse('2014-02-02')
      expect(holiday[:start_date]).to eq groundhog_day
    end
  end
end
