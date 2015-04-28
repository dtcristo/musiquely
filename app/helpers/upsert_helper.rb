module UpsertHelper
  def self.timestamp
    Time.now.utc.strftime('%Y-%m-%d %H:%M:%S.%6N')
  end
end
