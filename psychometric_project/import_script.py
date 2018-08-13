import csv
import sys
import psycopg2
from datetime import datetime

con_evalbase = psycopg2.connect(database='psychometricdb',  user='stud_user1', password='123456', host='localhost')
#con_evalbase = psycopg2.connect(database='psychometricdb',  user='stud_user1', password='aiexam2homah', host='192.168.194.37')

cursor = con_evalbase.cursor()
#cursor1 = con_evalbase.cursor()
#cursor2 = con_evalbase.cursor()
today = datetime.now()

f = open('/home/aakash/Desktop/psychometric/psy_data.csv','rt')
#f = open('psychometric_db_import.csv', 'rt')

reader = csv.reader(f,delimiter="|")
campusvalue = []
programmevalue = []
regisvalue = []
count = 0

###enter in mst_courses
for row in reader:
	registno = row[0]+'-2017'
	print row
	enrollno = row[1]
	print "Before insertion"+enrollno
	fname = row[2]
	mname = row[3]
	lname = row[4]
	batch = row[6]
	email = row[7]
	gender = row[8]
	campus = row[5]
	#print campus
	programme = row[9]
	mobileno=row[10]
	password=row[11]
	if "'" in password:
		password= password.replace("'","''")
	if "'" in lname:
		lname=lname.replace("'","''")	
		
	#waitlist=row[11]
	print 'campus : ',campus,
	campusid = "select campus_id from psychometric_app_mst_campus where campus_name='%s'"%(campus)
	cursor.execute(campusid)
	campusvalue=cursor.fetchall()
	campus = campusvalue[0][0]
	progid = "select programme_id from psychometric_app_mst_programme where programme_name='%s'"%(programme)
	cursor.execute(progid)
	programmevalue=cursor.fetchall()
	programme = programmevalue[0][0]
	'''
	query1_sel = "select student_registration_no from psychometric_app_mst_student where student_registration_no='%s'"%(registno)
	cursor.execute(query1_sel)
	regisvalue=cursor.fetchall()
	
	if len(regisvalue)!=0:
		registno_in_table = regisvalue[0][0]
		#print registno_in_table
		if registno == registno_in_table:
			query1_update = "update psychometric_app_mst_student set student_prog_id=%s,student_campus_id=%s,student_last_modified_datetime='%s' where student_registration_no='%s'"%(programme,campus,today,registno)
			cursor.execute(query1_update)
	else:
	'''
	#query1_sel = "select student_enrollment_no from psychometric_app_mst_student where student_enrollment_no='%s'"%(enrollno)
	query1_sel = "select * from psychometric_app_mst_student where student_registration_no='%s'"%(registno)
	cursor.execute(query1_sel)
	enrollnoexists=cursor.fetchall()
	print 'Length...',len(enrollnoexists)
	if len(enrollnoexists)==0:
		print registno
		query1_ins = "insert into psychometric_app_mst_student(student_registration_no,student_enrollment_no,student_fname,student_mname,student_lname,student_campus_id,student_batch,student_email_id,student_gender,student_creator_id,student_created_datetime,student_last_modifier_id,student_last_modified_datetime,student_enabled,student_deleted,student_test_status,student_prog_id,student_mobile_no,student_campus_test_taken,student_begin_test,student_counsellor_comments,student_password,student_wait_list_value) values('%s','%s','%s','%s','%s','%s','%s','%s','%s','1','%s','1','%s','Y','N','Pending','%s','%s',null,'N',null,'%s',null) " %(registno,enrollno,fname,mname,lname,campus,batch,email,gender,today,today,programme,mobileno,password)  
		cursor.execute(query1_ins)
		count=count+1
		print "After insertion"+enrollno
		
con_evalbase.commit()
f.close()
print 'Final Imported Count : ',count			
cursor.close()

con_evalbase.close()
