# pretty basic controller here

class CompareController < ApplicationController

  def data

    # no database, just some nice rails file caching to speed things up a 
    # bit.

    users = ["user1","user2"]

    @twit_users = users.map { |x| Twitter.user(params[x]) }

    # prety basic ajax rendering of markup.

    #render :text => "<p>HI there</p>", :content_type=>"text/html"
  end

end
