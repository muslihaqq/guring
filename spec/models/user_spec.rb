# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:target_user) { create(:user) }

  describe '#clock_in' do
    it 'creates a new sleep_record' do
      expect {
        user.clock_in!
      }.to change(user.sleep_records, :count).by(1)
    end
  end

  describe '#clock_out' do
    let!(:sleep_record_incomplete) { create(:sleep_record_incomplete, user: user) }

    it 'updates an sleep_record incomplete to be completed' do
      expect {
        user.clock_out!
      }.to change(user.sleep_records.incomplete, :count).by(-1)
    end
  end
end