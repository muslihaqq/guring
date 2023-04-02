# frozen_string_literal: true

class UserOutput < ApiOutput
  def format
    {
      id: @object.id,
      handle: @object.name,
      created_at: @object.created_at,
      updated_at: @object.updated_at
    }
  end

  def login_format
    format.merge(
      token: token
    )
  end

  def detail_format
    format.merge(
      last_week_records: last_week_records
    )
  end

  private

  def token
    @options[:token]
  end

  def last_week_records
    @options[:last_week_records]
  end
end
