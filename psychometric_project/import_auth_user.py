import csv
import sys
import psycopg2
from datetime import datetime

con_evalbase = psycopg2.connect(database='psychometricdb',  user='stud_user1', password='123456',host='localhost')

#con_evalbase = psycopg2.connect(database='psychometricdb',  user='stud_user1', password='aiexam2homah', host='192.168.194.37')

cursor = con_evalbase.cursor()
#cursor1 = con_evalbase.cursor()
#cursor2 = con_evalbase.cursor()
today = datetime.now()

#f = open('ap.csv', 'rt')
f = open('/home/aakash/Desktop/psychometric/psy_data.csv', 'rt')

reader = csv.reader(f,delimiter="|")
campusvalue = []
programmevalue = []
usernamevalue = []
count = 0

###enter in mst_courses
for row in reader:
	#print row
	username = row[7]
	email = row[7]
	password = row[12]
	query1_sel = "select username from auth_user where username='%s'"%(username)
	cursor.execute(query1_sel)
	usernamevalue=cursor.fetchall()
	print usernamevalue
	if len(usernamevalue)==0:
		query1_ins = "insert into auth_user(password,last_login,is_superuser,username,first_name,last_name,email,is_staff,is_active,date_joined) values('%s','%s','FALSE','%s','','','%s','FALSE','TRUE','%s') " %(password,today,username,email,today)  
		cursor.execute(query1_ins)
		count=count+1
		
con_evalbase.commit()
f.close()
print 'insert count',count
	
			
cursor.close()

con_evalbase.close()
