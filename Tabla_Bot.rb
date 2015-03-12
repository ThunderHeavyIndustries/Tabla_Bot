# Twitter bot for creating random tabla composition tweets
# Feb 2015
# Thunderheavyindustries@gmail.com



require "Twitter"


class TablaBot

	@@bols= Hash[0,"Ta",1,"Tin",2,"Tun",3,"Din",4,"Te",5,"Re",6,"Tha",7,"Ge",8,"Ka",9,"Dha",10,"Dha2",11,"Dha3",12,"Dhi",13,"Dhe",14,"Dhet",15,"Kre",16,"The",17,"The2",18,"-"]

		@@client = Twitter::REST::Client.new do |config|
  			config.consumer_key        = ""
  			config.consumer_secret     = ""
 			config.access_token        = ""
 			config.access_token_secret = ""
		end

	

	def tweet_composition requester

		str="@#{requester}:" #initializing string

		while str.length-requester.length<140

			c = @@bols[rand(19)] #calls a random bol from the hash of bols

			if (str+" "+c).length <140
				str+=" "+c #builds a string of hits
			else
				return str
			end
		end

		return str
	end

	def composition_response num_change


		num_change.times do|x|

			puts "Tweeting to #{@@client.mentions_timeline[x].user.screen_name}"
			@@client.follow(@@client.mentions_timeline[x].user.screen_name)
			com = tweet_composition @@client.mentions_timeline[x].user.screen_name
			@@client.update(com)
		end
	end

	def monitor


		status = @@client.mentions_timeline.size
		updated_status = status
		@@client.update( "I'm accepting requests")

		while 1<2

			puts "sleeping"
			sleep(120)
			puts "checking status"
			status = @@client.mentions_timeline.size

			if status > updated_status

				puts "status: updating tweeting"
				dif = status-updated_status
				composition_response dif
				updated_status = status
				puts "tweet/s sent"
			else
			end
		end
	end
	
end


TB= TablaBot.new
TB.monitor



