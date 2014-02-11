require 'spec_helper'

describe HolidayList::Params do
  before do
    new_time = Time.local(2014, 1, 29, 12, 0, 0)
    Timecop.freeze(new_time)
  end

  after do
    Timecop.return
  end

  subject { HolidayList::Params.new('12345', options) }
  let(:options) { Hash.new }

  describe '#to_s' do
    before do
      subject.should_receive(:params_hash).and_return Hash.new
    end

    it 'calls #params_hash' do
      subject.to_s
    end
  end

  describe '#params_hash' do
    let(:params_hash) { subject.params_hash }

    it 'uses the passed in key' do
      expect(params_hash[:key]).to eq '12345'
    end

    it 'orders by startTime' do
      expect(params_hash[:orderBy]).to eq 'startTime'
    end

    it 'uses single events' do
      expect(params_hash[:singleEvents]).to be true
    end

    describe 'time ranges' do
      shared_examples 'customizable start and stop dates' do
        it 'uses a default start date of today' do
          expect(params_hash[:timeMin]).to eq start
        end

        it 'uses a default stop date of 1 year from now' do
          expect(params_hash[:timeMax]).to eq stop
        end
      end

      context 'with default start and stop dates' do
        let(:start) { DateTime.new(2014, 1, 29, 12, 0, 0, '-6') }
        let(:stop)  { DateTime.new(2015, 1, 29, 12, 0, 0, '-6') }

        it_behaves_like 'customizable start and stop dates'
      end

      context 'with custom start and stop dates' do
        let(:start) { DateTime.new(2014, 2, 1) }
        let(:stop)  { DateTime.new(2014, 2, 15) }

        let(:options) do
          {
            'start' => start,
            'stop'  => stop
          }
        end

        it_behaves_like 'customizable start and stop dates'
      end

      context 'with invalid dates' do
        let(:start) { 'foo' }
        let(:stop)  { 'bar' }

        let(:options) do
          {
            'start' => start,
            'stop'  => stop
          }
        end

        it 'throws an error' do
          expect { params_hash[:timeMin] }.to raise_error ArgumentError
        end
      end

      context 'with stop date after start date' do
        let(:start) { DateTime.new(2014, 1, 29, 12, 0, 0, '-6') }
        let(:stop)  { DateTime.new(2014, 1, 28, 18, 5, 10, '-6') }

        let(:options) do
          {
            'start' => start,
            'stop'  => stop
          }
        end

        it 'throws an error' do
          expect { params_hash[:timeMin] }.to raise_error ArgumentError
        end
      end
    end
  end
end
