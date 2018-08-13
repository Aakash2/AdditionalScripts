import smtplib

server = smtplib.SMTP('mail.tiss.edu', 587)
server.starttls()
server.login("akash.sharma@tiss.edu", "H@ns24@$")

msg = "Checkout! Its Works"
server.sendmail("akash.sharma@tiss.edu", "akash.sharma@tiss.edu", msg)
server.quit()
