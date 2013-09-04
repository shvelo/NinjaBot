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

	on :private do |m|
		if m.user.nick == @master then
			message = m.text.split " "
			command = message.shift
			args = message

			if command == "channel" then
				Channel(channels[0]).send(args.join " ")
			elsif command == "server" then
				m.server.send(args.join " ")
			end
		end
	end

	on :connect do
		User("nickserv").send("identify #{@password}")
		User("chanserv").send("op #{@nick} \#EvilNinja")
	end
end

bot.start
