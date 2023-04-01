# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  let(:user)        { create(:user) }
  let(:incomplete)  { create(:sleep_record, clock_in: 2.days.ago, clock_out: nil)}
  let(:complete)    { create(:sleep_record, clock_in: 3.days.ago.beginning_of_day, clock_out: 3.days.ago + 5.hours )}

  context 'scopes' do
    describe '#incomplete' do
      it 'returns incomplete sleep records' do
        expect(SleepRecord.incomplete).to eq([incomplete])
      end
    end

    describe '#complete' do
      it 'returns complete sleep records' do
        expect(SleepRecord.complete).to eq([complete])
      end
    end

    describe '#last_week' do
      it 'returns complete sleep records' do
        expect(SleepRecord.complete).to eq([complete])
      end
    end
  end
end