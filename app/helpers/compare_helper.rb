module CompareHelper
  def users_for(twitter_ids,tag)
    Rails.cache.fetch(:tag=>tag) do
      # hack for now.. only showing the first 50 users
      # since the api seems to only support 50 at a time
      Twitter.users(twitter_ids.to_a[0..50])
    end
  end
end
