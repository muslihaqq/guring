# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:sleep_records) }
    it { should have_many(:active_relationships).class_name('Follow').with_foreign_key('follower_id').dependent(:destroy) }
    it { should have_many(:passive_relationships).class_name('Follow').with_foreign_key('followed_id').dependent(:destroy) }
    it { should have_many(:following).through(:active_relationships).source(:followed) }
    it { should have_many(:followers).through(:passive_relationships).source(:follower) }
  end

  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:target_user) { create(:user) }

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

  describe "#follow" do
    it "creates a new follower relationship" do
      expect { user.follow(other_user) }.to change { user.following.count }.by(1)
      expect(user.following?(other_user)).to be_truthy
    end
  end

  describe "#unfollow" do
    it "destroys the follower relationship" do
      user.follow(other_user)
      expect { user.unfollow(other_user) }.to change { user.following.count }.by(-1)
      expect(user.following?(other_user)).to be_falsey
    end
  end

  describe "#following?" do
    it "returns true if the user is following the other user" do
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
    end

    it "returns false if the user is not following the other user" do
      expect(user.following?(other_user)).to be_falsey
    end
  end
end