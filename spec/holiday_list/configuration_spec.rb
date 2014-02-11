require 'spec_helper'

describe HolidayList::Configuration do
  subject { HolidayList::Configuration.new }

  describe '#configured?' do
    shared_examples 'failing configuration' do
      it 'is false' do
        expect(subject.configured?).to be false
      end
    end

    context 'without a key' do
      before { subject.id = 'id' }

      it_behaves_like 'failing configuration'
    end

    context 'without an id' do
      before { subject.key = 'key' }

      it_behaves_like 'failing configuration'
    end

    context 'without a key or id' do
      it_behaves_like 'failing configuration'
    end

    context 'with a key and id' do
      before do
        subject.key = 'key'
        subject.id  = 'id'
      end

      it 'is true' do
        expect(subject.configured?).to be true
      end
    end
  end
end
