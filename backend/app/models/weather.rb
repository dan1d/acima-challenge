class Weather < ApplicationRecord

  def stale?
    fetched_at < 1.hour.ago
  end
end
