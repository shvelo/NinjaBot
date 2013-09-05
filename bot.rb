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
		messages = [
			"brings #{m.user.nick} a cup of coffee",
			"brings #{m.user.nick} a glass of iced coffee",
			"brings #{m.user.nick} a cup of capuccino",
			"brings #{m.user.nick} a cup of hot chocolate",
			"brings #{m.user.nick} a cup of espresso"
		]
		m.channel.action messages.sample
	end

	on :message, "!pizza" do |m|
		messages = [
			"brings #{m.user.nick} a hot slice of pepperoni pizza",
			"brings #{m.user.nick} a cold slice of pizza",
			"brings #{m.user.nick} a slice of mushroom pizza",
			"throws #{m.user.nick} a slice of evil-looking pizza"
		]
		m.channel.action messages.sample
	end

	on :message, "!chocolate" do |m|
		messages = [
			"brings #{m.user.nick} a bar of KitKat",
			"brings #{m.user.nick} a box of KitKat",
			"brings #{m.user.nick} a bar of Snickers",
			"brings #{m.user.nick} a bar of Twix",
			"brings #{m.user.nick} a box of Alpen Gold"
		]
		m.channel.action messages.sample
	end

	on :privmsg do |m|
		info "Received private message from #{m.user.nick}"
		if m.user.nick == "shvelo" && m.user.authed? then
			message = m.message.split " "
			command = message.shift
			info "command: #{command}"
			args = message

			if command == "channel" || command == "chn" then
				Channel("#EvilNinja").send(args.join " ")
			elsif command == "message" || command == "msg" then
				Channel(args.shift).send(args.join " ")
			elsif command == "action" || command == "ac" then
				Channel(args.shift).action(args.join " ")
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
