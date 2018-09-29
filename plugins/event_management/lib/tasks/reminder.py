#!/usr/bin/python
# coding: utf-8


import logging
from logging import getLogger, Formatter
from logging.handlers import RotatingFileHandler
def init_logging(conf):
	handler_format = Formatter(conf['format'])

	file_handler = RotatingFileHandler(conf['file'], 'a', conf['size'], conf['max'])
	file_handler.setFormatter(handler_format)
	if conf['level'] == 'debug':
		file_handler.setLevel(logging.DEBUG)
	elif conf['level'] == 'info':
		file_handler.setLevel(logging.INFO)
	elif conf['level'] == 'warning':
		file_handler.setLevel(logging.WARNING)
	elif conf['level'] == 'error':
		file_handler.setLevel(logging.ERROR)
	elif conf['level'] == 'critical':
		file_handler.setLevel(logging.CRITICAL)

	logger = getLogger("Reminder")
	logger.setLevel(logging.DEBUG)
	logger.addHandler(file_handler)

	return logger

import MySQLdb

def connect(config):
	logger.debug('connect DB - %s/%s/%s/%s' % (config['host'], config['database'], config['username'], config['password']))
	return MySQLdb.connect(
		user = config['username'],
		passwd = config['password'],
		host = config['host'],
		db = config['database'],
		charset = "utf8"
	)


from datetime import datetime, timedelta

def get_events(con, config):
	#print "config=[" + str(config) + "]"
	if 'project' not in config:
		raise Exception("'project' is not found")

	events_sql = """SELECT
 id,
 event_subject,
 event_date,
 event_place_station,
 event_place,
 event_caption
FROM event_models
WHERE
 DATE(event_date) = '%s'""" % (datetime.today() + timedelta(days=config['day_ago'])).strftime("%Y-%m-%d")

	if type(config['project']) is int:
		# project id (ex. 1, 2)
		events_sql += " AND project_id = '%d'" % config['project']
	else:
		# project identifier (ex. thanks_k, thanks_k_manage)
		events_sql += " AND project_id = (SELECT id FROM projects WHERE identifier = '%s')" % config['project']

	events = []
	try:
		cur = con.cursor()
		cur.execute(events_sql)

		for row in cur.fetchall():
			ev = {
				'id': int(row[0]),
				'subject': row[1],
				'date': row[2],
				'station': row[3],
				'place': row[4],
				'description': row[5]
			}
			events.append(ev)

	finally:
		cur.close

	return events

def get_eventusers(con, event_id):
	# SELECT eu.id, eu.user_id, us.login, us.firstname, us.lastname, us.mail, us.mail_notification FROM event_users AS eu LEFT JOIN users AS us ON eu.user_id = us.id WHERE event_model_id = '361';
	if type(event_id) is not int or event_id <= 0:
		raise Exception("invalid event_id")

	# イベント機能のバグで、イベントを更新すると event_users のレコードがすべて複製される
    # つまり、同じユーザのレコードが重複する。
    # そのため、そのまま使ってしまうと同じユーザに同じメールを複数送ることになるので
    # GROUP BY eu.user_id として、新しい方のレコードのみ採用する
	users_sql = """SELECT 
  eu.id, 
  eu.user_id, 
  us.login, 
  us.firstname, 
  us.lastname, 
  us.mail, 
  us.mail_notification 
 FROM event_users AS eu 
  LEFT JOIN users AS us 
   ON eu.user_id = us.id 
 WHERE 
  eu.event_model_id = '%s'
 GROUP BY eu.user_id""" % event_id
	
	users = []
	try:
		cur = con.cursor()
		cur.execute(users_sql)

		for row in cur.fetchall():
			us = {
				'id': int(row[1]),
				'account': row[2],
				'name': row[3],
				'part': row[4].replace("_", ""),  # ここは本来 lastname だが、実質 CB_ といったパート名なので part とする
				'mail': row[5],
				'notification': True if row[6] != 'none' else False
			}
			users.append(us)

	finally:
		cur.close

	return users

def replace_tags(text, data, tag_prefix = None):
	if tag_prefix is not None or len(tag_prefix) > 0:
		tag_prefix = tag_prefix + "."

	for k in data:
		tag = '((#' + tag_prefix + k + '#))'

		if data[k] is None:
			value = ""
		elif type(data[k]) is datetime:
			value = data[k].strftime('%Y-%m-%d')
		elif type(data[k]) is str:
			value = data[k]
		elif type(data[k]) is int:
			value = str(data[k])
		else:
			value = "%s" % data[k]
		#print "  tag=" + tag + " -> value=" + value

		text = text.replace(tag, value)

	return text


import smtplib
from email.mime.text import MIMEText
from email.utils import formatdate
from email.header import Header
from email import charset

# メール送信を utf-8 8bit にするための設定
CSET = 'utf-8'
charset.add_charset(CSET, charset.SHORTEST, None, CSET)

def send_mail(host, port, from_addr, to_addr, subject, body):
	# * redine_conf
	# production:
	#  email_delivery:
	#    delivery_method: :smtp
	#    smtp_settings:
	#      address: "localhost"
	#      port: 3025
	#      domain: thanks-k.com

	msg = MIMEText(body.encode(CSET), 'plain', CSET)
	msg['Subject'] = Header(subject, CSET)
	msg['From'] = from_addr
	msg['To'] = to_addr
	msg['Date'] = formatdate(localtime=True)

	smtp = smtplib.SMTP(host, port)
	smtp.helo()
	smtp.sendmail(from_addr, to_addr, msg.as_string())
	smtp.close()




import sys
import yaml

redmine_path = '/var/lib/redmine'
event_plugin_path = redmine_path + '/plugins/event_management'
redmine_yml = redmine_path + '/config/configuration.yml'
db_yml = redmine_path + '/config/database.yml'
remind_yml = event_plugin_path + '/config/reminder.yml'


# load reminder config 
if len(sys.argv) > 1:
	remind_yml = sys.argv[1]
remind_conf = yaml.load(open(remind_yml, "r+"))
if 'remind' not in remind_conf:
	sys.exit()

logger = init_logging(remind_conf['setting']['log'])
logger.info('start event reminder')

# load mysql config
logger.debug('load ' + db_yml)
db_conf = yaml.load(open(db_yml, "r+"))

# load redmine configuration
logger.debug('load ' + redmine_yml)
redmine_conf = yaml.load(open(redmine_yml, "r+"))


# connect DB 
try:
	con = connect(db_conf['production'])
except Exception as err:
	logger.exception('database connection failed - %s' % err)
	sys.exit()

# ex) reminder.conf 
#
# remind:
#    - project: 1
#      day_ago: 1
#      hour: 10
#      subject: 【前日リマインド】((#event.subject#))
#      body: |-
#        明日のイベントのリマインドです。
#        
#        日時：((#event.date#))
#        イベント：((#event.subject#))
#        場所：((#event.place#))
#        最寄駅：((#event.station#))
#

current_hour = datetime.now().hour

n = 0
# loop remind
for remind in remind_conf['remind']:
	n += 1

	if remind['hour'] != current_hour:
		logger.info('remind item %d: %s (still not remind time)' % (n, remind['subject']))
		continue
	logger.info('remind item %d: %s' % (n, remind['subject']))

	events = []
	try:
		events = get_events(con, remind)
	except Exception as err:
		logger.exception('failed to get event list - %s' % err)
		continue
		
	# loop events
	for ev in events:
		logger.info('remind event found: %s %s' % (ev['date'].strftime('%Y-%m-%d'), ev['subject']))

		try:
			users = get_eventusers(con, ev['id'])
		except Exception as err:
			logger.exception('failed to get user list - event_id=%d %s' % (ev['id'], err))
			continue

		# loop users in a event
		for us in users:
			if us['notification'] == False:
				logger.info('skip %s (%s)' % (us['name'], us['mail']))
				continue

			body = replace_tags(remind['body'], ev, 'event')
			body = replace_tags(body, us, 'user')
			subject = replace_tags(remind['subject'], ev, 'event')
			subject = replace_tags(subject, us, 'user')

			send_mail(redmine_conf['production']['email_delivery']['smtp_settings']['address'], 
			          redmine_conf['production']['email_delivery']['smtp_settings']['port'], 
			          remind_conf['setting']['from'], 
					  us['mail'], 
					  subject, 
					  body)
			logger.info('sent remind to %s (%s)' % (us['mail'], us['name']))

logger.info('finish event reminder')
