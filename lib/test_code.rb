

def some_tests

  # get a list of  people who are following the target
  cursor = Twitter.follower_ids("carlshimer")
  
  # get a list of people who the target is following
  Twitter.friend_ids("carlshimer")

  # list of users (takes an array of ids)
  Twitter.users(cursor.ids)

  # get a list of the hash tags for the top 200 tweets.
  tweets = Twitter.user_timeline("scalzi",:include_entities=>true,:count=>200)

  # get a list of the uniq hash tags.
  tweets.map { |x| x.hashtags }.map { |x| x.length == 0 ? nil : x.map { |x| x.text }}.flatten.compact


  # sparkline or something

  dates = {}
  tweets.each do |x|
    rec = dates[x.created_at.to_date] ||= 0
    rec+=1
  end


  # mnotes:
  # use the html doctype for html 5 compat
  # use the rails file cache to store the generic dump of data
  # to avoid hitting the server a bunch.


end
