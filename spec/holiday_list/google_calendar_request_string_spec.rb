require 'spec_helper'

describe HolidayList::GoogleCalendarRequestString do
  let(:configuration) do
    double('Configuration', configured?: true).as_null_object
  end

  subject { HolidayList::GoogleCalendarRequestString.new(configuration) }

  describe '#new' do
    context 'configured' do
      before do
        HolidayList::GoogleCalendarRequestString
          .any_instance.should_not_receive(:argument_error!)
      end

      it 'creates a new object' do
        subject
      end
    end

    context 'not configured' do
      before do
        configuration.stub(:configured?).and_return(false)
        HolidayList::GoogleCalendarRequestString
          .any_instance.should_receive(:argument_error!)
      end

      it 'calls argument_error!' do
        subject
      end
    end
  end

  describe '#to_s' do
    let(:params) { double('Params') }

    before do
      HolidayList::Params.stub(:new).and_return(params)
    end

    it 'uses Params' do
      params.should_receive(:to_s)
      subject.to_s
    end
  end
end
