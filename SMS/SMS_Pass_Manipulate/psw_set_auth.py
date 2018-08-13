import psycopg2
from datetime import datetime
from datetime import date
import re
import xlrd
from datetime import timedelta

con_evalbase = psycopg2.connect(database='examevaldb',  user='exam', password='123456', host='localhost' )
cursor = con_evalbase.cursor()

today = datetime.now()

workbook_obj=xlrd.open_workbook('ban.xls')
############################## Please Check the batch_id#######################333
sheet_obj=workbook_obj.sheet_by_name('Sheet1')


#used for incrementing the enrollment and registration number
for row in range(1,sheet_obj.nrows):

	#enrollment
	enrollno=sheet_obj.cell(row,4).value.replace('\n','')
	enrol_num=enrollno.replace("'","''")
	enrollment_num=re.sub(' +',' ',enrol_num).strip()
	print enrollno,enrollment_num

	# tiss email
	tissemid=sheet_obj.cell(row,2).value.strip()
	
	fname=sheet_obj.cell(row,1).value.strip()

	#existing record check
	query1="select username from auth_user where username='%s'"%(enrollment_num)
	cursor.execute(query1)
	studexists=cursor.fetchall()
	#print fname

	stud_password=sheet_obj.cell(row,3).value

	if len(studexists)==0:
		query_auth="insert into auth_user(password,last_login,is_superuser,username,first_name,last_name,email,is_staff,is_active,date_joined)VALUES('%s','%s','%s','%s','%s','%s','%s','%s', '%s','%s')"%(stud_password,today,'FALSE',enrollment_num,fname,fname,tissemid,'TRUE','TRUE',today)
		cursor.execute(query_auth)
		
	else:
		print "%s student name already exists" %(fname)

cursor.close()
con_evalbase.commit()
con_evalbase.close()




