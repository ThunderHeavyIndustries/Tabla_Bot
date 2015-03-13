# Twitter bot for creating random tabla composition tweets
# Feb 2015
# Thunderheavyindustries@gmail.com



require "Twitter"


class TablaBot
	@@currently_running = false
	@@bols= Hash[0,"Ta",1,"Tin",2,"Tun",3,"Din",4,"Te",5,"Re",6,"Tha",7,"Ge",8,"Ka",9,"Dha",10,"Dha2",11,"Dha3",12,"Dhi",13,"Dhe",14,"Dhet",15,"Kre",16,"The",17,"The2",18,"-"]

		@@client = Twitter::REST::Client.new do |config|
  			config.consumer_key        = ""
  			config.consumer_secret     = ""
 			config.access_token        = ""
 			config.access_token_secret = ""
		end

    @@status = @@client.mentions_timeline.size
    @@total_cycles=0
	

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

			puts "Tweeting to #{@@status[x].user.screen_name}"
			@@client.follow(@@status[x].user.screen_name)
			com = tweet_composition @@status[x].user.screen_name
			@@client.update(com)
		end
	end

	def monitor
		@@currently_running = true
		updated_status = @@status

		10.times do |x|
			puts "#{@@total_cycles} cycles have run thus far"
			@@total_cycles+=1
			puts "sleep cycle #{x}"
			sleep(120)
	  begin
			puts "checking status"
			@@status = @@client.mentions_timeline.size

	  rescue
	  	puts "We hit an error with Twitter"
	  	(0..20).each do |t|
	  		puts "Waiting for #{20-t} seconds then retrying"
	  		sleep(1)
	  	end
	  	puts "Reboot!"
	  	@@currently_running = false
	  	keep_going
	  end

			if @@status > updated_status

				puts "status: updating tweeting"
				dif = @@status-updated_status
				composition_response dif
				updated_status = @@status
				puts "tweet/s sent"
			else
				puts "no requests currently"
			end
		end
		@@currently_running = false
	end


	def keep_going
		while 1<2
			if @@currently_running != true
				monitor
			else
			end
		end
	end
	
end


TB= TablaBot.new
TB.monitor
TB.keep_going



