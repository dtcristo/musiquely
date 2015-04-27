module UpsertHelper
  def timestamp
    Time.utc.now.strftime('%Y-%m-%d %H:%M:%S.%6N')
  end
end
