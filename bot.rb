#!/usr/bin/env ruby

require 'cinch'
require 'gameidea'
require 'yaml'

def serve(m, messages)
	text = m.message.split " "
	user = m.user.nick
	user = text[1] if text[1]

	return false if User(user).unknown?

	message = messages.sample
	message["%user"] = user
	m.channel.action message
end

if File.exist? "config.yml" then
    config = YAML::load_file "config.yml"
else
    config = YAML::load_file "config.default.yml"
end

bot = Cinch::Bot.new do
  	configure do |c|
		c.server = config["server"]
		c.channels = config["channels"]
	  	c.nick = config["nick"]
	  	c.user = config["user"]
	    c.encoding = config["encoding"]
	    c.password = config["password"]
	    c.master = config["master"]
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

    on :message, /^\!source/ do |m|
        m.channel.send "Find me on GitHub: https://github.com/shvelo/EvilNinja"
    end

    on :message, /^\!about/ do |m|
        m.channel.send "NinjaBot by Nick Shvelidze"
        m.channel.send "Find me on GitHub: https://github.com/shvelo/EvilNinja"
    end

    on :message, /^\!(help|commands)/ do |m|
        m.channel.send "Serve food: !coffee, !pizza, !chocolate"
        m.channel.send "Generate game ideas: !gameidea"
        m.channel.send "About NinjaBot: !about"
    end

	on :privmsg do |m|
		info "Received private message from #{m.user.nick}"
		if m.user.nick == config["master"] && m.user.authed? then
			message = m.message.split " "
			command = message.shift
			info "command: #{command}"
			args = message

			if command == "channel" || command == "chn" then
				Channel(config["default_channel"]).send(args.join " ")
			elsif command == "topic" || command == "tp" then
				topic = args.join " "
				User('chanserv').send "topic #{config['default_channel']} #{topic}"
			elsif command == "message" || command == "msg" then
				Channel(args.shift).send(args.join " ")
			elsif command == "action" || command == "ac" then
				Channel(args.shift).action(args.join " ")
			elsif command == "server" || command == "srv" then
				irc.send(args.join " ")
			elsif command == "op" then
				User("chanserv").send("op #{config['default_channel']} #{config['master']}")
			elsif command == "join" || command == "jn" then
				Channel(args.join " ").join
			end
		end
	end

	on :connect do
		User("chanserv").send("op #{config['default_channel']}")
	end
end

bot.start
