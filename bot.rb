#!/usr/bin/env ruby

require 'cinch'
require 'gameidea'

def serve(m, messages)
	text = m.message.split " "
	user = m.user.nick
	user = text[1] if text[1]

	return false if m.channel.users[user.to_sym] == nil

	message = messages.sample
	message["%user"] = user
	m.channel.action message
end

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

	on :message, /hello/i do |m|
		nick = bot().nick()
		m.reply "Hello, #{m.user.nick}" if m.message.match /#{nick}[^\w]*$/
	end

	on :message, /^\!coffee/ do |m|
		messages = [
			"brings %user a cup of coffee",
			"brings %user a glass of iced coffee",
			"brings %user a cup of capuccino",
			"brings %user a cup of hot chocolate",
			"brings %user a cup of espresso"
		]
		
		serve(m, messages)
	end

	on :message, /^\!pizza/ do |m|
		messages = [
			"brings %user a hot slice of pepperoni pizza",
			"brings %user a cold slice of pizza",
			"brings %user a slice of mushroom pizza",
			"throws %user a slice of evil-looking pizza"
		]

		serve(m, messages)
	end

	on :message, /^\!chocolate/ do |m|
		messages = [
			"brings %user a bar of KitKat",
			"brings %user a box of KitKat",
			"brings %user a bar of Snickers",
			"brings %user a bar of Twix",
			"brings %user a box of Alpen Gold"
		]
		
		serve(m, messages)
	end

	on :message, /^\!gameidea/ do |m|
		idea = gameidea
		m.channel.send "#{idea[:where]} #{idea[:who]} #{idea[:what]}"
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
			elsif command == "topic" || command == "tp" then
				topic = args.join " "
				User('chanserv').send "topic #EvilNinja #{topic}"
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
		User("chanserv").send("op #EvilNinja")
	end
end

bot.start
