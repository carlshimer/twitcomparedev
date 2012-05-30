# pretty basic controller here

class CompareController < ApplicationController

  def data

    # the caching may seem like goldplating but it sure
    # speeds up development.
    
    users = ["user1","user2"]

    @twit_users = users.map do |x| 
      Rails.cache.fetch(:twit_user=>params[x]) do
        Twitter.user(params[x])
      end
    end

    @uniq_tag = users.reduce { |x,y| "#{params[x]}_#{params[y]}" }

    @tweets = {}
    @tweet_stats = {}

    users.each do |x|
      user_tweets = Rails.cache.fetch(:tweets_user=>params[x]) do
        # max 200 unless you pay twitter scrooge mcduck bags of cash
        Twitter.user_timeline(params[x],
                              :include_entities=>true,
                              :count=>200,:exclude_replies=>false)
      end
      @tweets[params[x]] = user_tweets
      @tweet_stats[params[x]] = compute_date_stats(user_tweets)

      
    end

    @common_followers = users.map do |x| 
      Rails.cache.fetch(:twit_followers=>params[x]) do
        exhaust(:follower_ids,params[x])
      end
    end.reduce { |x,y| x & y }

    @common_friends = users.map do |x| 
      Rails.cache.fetch(:twit_friends=>params[x]) do
        exhaust(:friend_ids,params[x])
      end
    end.reduce { |x,y| x & y }

    @common_mentions = @tweets.map do |k,user_tweets|
      Set.new(user_tweets.map { |x| x.user_mentions.map { |y| y.screen_name }}.flatten)
    end.reduce { |x,y| x & y }

    @common_hashtags = @tweets.map do |k,user_tweets|
      Set.new(user_tweets.map { |x| x.hashtags }.map { |x| x.length == 0 ? nil : x.map { |x| x.text }}.flatten.compact)
    end.reduce { |x,y| x & y }

  end

  # this is slightly broken in that it doesn't account for gaps.
  # ideally you'd want a good time span betewen the beginning
  # and the end of the collection period to account for when
  # the user doesn't tweetk.
  def compute_date_stats tweets
    dates = {}
    tweets.each do |x|
      rec = dates[x.created_at.to_date] ||= 0
      rec+=1
      dates[x.created_at.to_date] = rec
    end
    dates
  end

  def common_followers

  end

  def common_friends

  end

  def common_hashtags

  end

  def exhaust method,target
    
    cursor = Twitter.send(method,target)
    final = Set.new(cursor.ids)

    while true
      puts "using cursor #{cursor.next_cursor}"
      break if cursor.next_cursor == 0
      cursor = Twitter.send(method,target,{:cursor=>cursor.next_cursor})
      final |= Set.new(cursor.ids)
      puts "exhaust length = #{final.length}"
      # limit this right now at 30K.
      break if final.length >= 30000
    end
    final
  end

end
