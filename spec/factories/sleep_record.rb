# frozen_string_literal: true

FactoryBot.define do
  clock_in = Faker::Time.between_dates(from: 1.week.ago, to: Date.current, period: :night)
  clock_out = Faker::Time.between_dates(from: 1.week.ago, to: Date.current, period: :morning)

  factory :sleep_record do
    association :user
    clock_in { clock_in }
    clock_out { clock_out }
    sleep_time { clock_out - clock_in }
  end

  factory :sleep_record_incomplete, class: 'SleepRecord' do
    association :user
    clock_in { DateTime.current.beginning_of_day }
  end
end

