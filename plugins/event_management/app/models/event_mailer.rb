#coding: utf-8

class EventMailer < ActionMailer::Base
	default from: Setting.mail_from
	include Redmine::I18n

	def send_call_event(user, owner, subject, event)
		@event_owner = owner
		@event = event
		@user = user
		@to = user.mail
		@subject = subject
		mail( :to => @to, :subject => @subject ) do |format|
			format.text
		end
	end
end
