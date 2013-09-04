#!/usr/bin/env ruby

require 'cinch'

bot = Cinch::Bot.new do
  	configure do |c|
		c.server = "irc.freenode.org"
		c.channels = ["#EvilNinja"]
	  	c.nick = "NinjaBot"
	  	c.user = c.nick
	    c.encoding = "UTF-8"
	    c.password = "dr-ninja"
	    c.master = "shvelo"
	end

	on :message, "hello" do |m|
		m.reply "Hello, #{m.user.nick}"
	end

	on :message, "!coffee" do |m|
		m.channel.action "brings #{m.user.nick} a cup of coffee"
	end

	on :privmsg do |m|
		info "Received private message from #{m.user.nick}"
		if m.user.nick == "shvelo" then
			message = m.message.split " "
			command = message.shift
			info "command: #{command}"
			args = message

			if command == "channel" || command == "chn" then
				Channel("#EvilNinja").send(args.join " ")
			elsif command == "message" || command == "msg" then
				Channel(args.shift).send(args.join " ")
			elsif command == "server" || command == "srv" then
				irc.send(args.join " ")
			elsif command == "op" then
				User("chanserv").send("op #EvilNinja shvelo")
			elsif command == "join" || command == "jn" then
				Channel(args.join " ").join
			end
		end
	end

	on :connect do
		User("nickserv").send("identify #{@password}")
		User("chanserv").send("op \#EvilNinja")
	end
end

bot.start
