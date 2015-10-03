# Twitter bot for creating random tabla composition tweets
# Feb 2015
# Thunderheavyindustries@gmail.com

require "Twitter"
require_relative 'Twit_Init'

class TablaBot




	@@currently_running = false
	@@bols= Hash[0,"Ta",1,"Tin",2,"Tun",3,"Din",4,"Te",5,"Re",6,"Tha",7,"Ge",8,"Ka",9,"Dha",10,"Dha2",11,"Dha3",12,"Dhi",13,"Dhe",14,"Dhet",15,"Kre",16,"The",17,"The2",18,"-"]

		Twit_id = Twitilize.new
		@@client = Twit_id.initialize_TablaBot

    @@status = @@client.mentions_timeline
    @@last_id = @@status[0].id
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

	def composition_response name

		puts "Tweeting to #{name}"
		@@client.follow(name)
		com = tweet_composition name
		@@client.update(com)
	end

	def compose_for_fun

		str = ""
		while str.length<140

			c = @@bols[rand(19)] #calls a random bol from the hash of bols

			if (str+" "+c).length <140
				str+=" "+c #builds a string of hits
			else
				break
			end
		end
		puts "tweeting just for fun"
		@@client.update(str)
	end

	def monitor
		@@currently_running = true

		10.times do |x|
			puts "#{@@total_cycles} cycles have run thus far"
			@@total_cycles+=1
			puts "sub cycle #{x} of 10"
			sleep(120)
	     begin
			puts "checking status"
			@@status = @@client.mentions_timeline

	     rescue
	     	puts "We hit an error with Twitter"
	     	puts "Waiting for 20 seconds then retrying"
	     	(0..20).each do |t|
	  		puts "#{20-t}"
	  		sleep(1)
	    	end
	    	puts "Reboot!"
	    	@@currently_running = false
	    	keep_going
	      end

			if @@last_id != @@status[0].id

				puts "status: responding to tweets"

				@@status.each do |mention|
					if mention.id > @@last_id
						composition_response mention.user.screen_name
					else
					end
				end
				puts "all tweets sent"
				puts "updating most recent revieved tweet"
				@@last_id = @@status[0].id
			else
				puts "no requests currently"

				if @@total_cycles % 97 == 0
					compose_for_fun
					
				elsif @@total_cycles % 499 == 0

					followers = @@client.followers("tabla_bot").map(&:screen_name)
					lucky_follower = followers.sample
					composition_response lucky_follower
				end
			end
		end
		@@currently_running = false
	end


	def keep_going
		while 1<2
			if @@currently_running != true
				monitor
			else
				puts "Things are running smoothly"
			end
		end
	end


	def tester
		followers = @@client.followers("tabla_bot").map(&:screen_name)
		puts followers
	end
	
end




TB= TablaBot.new
TB.tester

