#!/usr/bin/ruby

require 'net/smtp'

class MailList
  def initialize(list, contents)
    @emails = Array.new

    IO.foreach(list) { |l|
      @emails << l if (l !~ /^\#/)
    }
    @message = Hash.new
    @message['body'] = IO.readlines(contents)
    @message['reply-to'] = 'feamster@cc.gatech.edu'
  end
  
  def send(from, subject, cc=nil)
    @message['from'] = from
    @message['subject'] = subject
    @message['cc'] = cc

    @emails.each { |t|
      t.chomp!

      name = t.split(/::/)[0]
      email = t.split(/::/)[1]
      topic = t.split(/::/)[2]

      firstname = name.split(/\s+/)[0]

      @message['to'] = name + ' ' + email
    
      fullText = ["From: #{@message['from']}", 
		  "Reply-To: #{@message['reply-to']}", 
		  "To: #{@message['to']}",
		  "Cc: #{@message['cc']}", 
		  "Subject: #{@message['subject']}\n\n",
		  @message['body'].join("")].join("\n")
      fullText.gsub!(/\@INVITE\@/, firstname);
      fullText.gsub!(/\@TOPIC\@/, topic);

      print "#{@message['to']}\n"

      Net::SMTP.start('localhost') do |smtp|
	smtp.send_message(fullText,
			  @message['from'],
			  [@message['to'], @message['cc'].split(/,/)].flatten)
      end

    }


  end
end

list = MailList.new("maillist.txt", "invite2.txt")
  list.send("Nick Feamster <feamster@cc.gatech.edu>",
	    "Invitation: CS 7001 Guest Lecture",
	    "Nick Feamster <feamster@cc.gatech.edu>, Nick Feamster <feamster@gmail.com>")
