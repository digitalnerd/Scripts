#!/usr/bin/env python

import smtplib

SMTP_SERVER = "smtp.gmail.com"
PORT = "587"
YOUR_EMAIL_ADDR=""
PASS=""
  
server = smtplib.SMTP(SMTP_SERVER, PORT)
server.starttls()
server.login(YOUR_EMAIL_ADDR, PASS)
  
msg = "YOUR MESSAGE"
server.sendmail(YOUR_EMAIL_ADDR, "THE EMAIL ADDRESS TO SEND TO", msg)
server.quit()
