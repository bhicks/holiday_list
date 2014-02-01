require 'spec_helper'

class WillError # rubocop:disable Documentation
  include HolidayList::RequestException

  def without_arguments
    argument_error!
  end

  def with_arguments
    argument_error! 'My custom error message goes here!'
  end
end

describe HolidayList::RequestException do
  shared_examples_for 'argument_error!' do
    let(:arguments) { [ArgumentError, message] }

    it 'uses the correct argument' do
      expect { subject.send(method) }.to raise_error(*arguments)
    end
  end

  subject { WillError.new }

  describe '#argument_error!' do
    context 'without a default argument' do
      let(:message) { 'A valid google access key is required' }
      let(:method)  { :without_arguments }

      it_should_behave_like 'argument_error!'
    end

    context 'with a default argument' do
      let(:message) { 'My custom error message goes here!' }
      let(:method)  { :with_arguments }

      it_should_behave_like 'argument_error!'
    end
  end
end
