class Weather < ApplicationRecord

  scope :older_than_one_day, -> { where("fetched_at < ?", 1.day.ago) }

  def self.cleanup_old_records
    older_than_one_day.destroy_all
  end

  def stale?
    fetched_at < 1.hour.ago
  end
end
