import psycopg2
from datetime import datetime
from datetime import date
import re
import xlrd
from datetime import timedelta

con_evalbase = psycopg2.connect(database='examevaldb',  user='exam', password='123456', host='localhost' )#192.168.194.37
cursor = con_evalbase.cursor()

today = datetime.now()
###enter in mst_students

#file_obj = open('PMRDFfinal.csv', 'rt')
#file_obj = open('February/03_02_2016/Fellows_details.csv', 'rt')
#file_reader = csv.reader(file_obj,delimiter="|")

workbook_obj=xlrd.open_workbook('hostel_dh.xls')
############################## Please Check the batch_id#######################333
sheet_obj=workbook_obj.sheet_by_name('Sheet1')

#used for incrementing the enrollment and registration number
for row in range(1,sheet_obj.nrows):
	#student id
	#student_id += 1	#row[1]	
	
	#enrollment
	enrollno=sheet_obj.cell(row,1).value.replace('\n','')			#row[2].replace(' ','')
	enrol_num=enrollno.replace("'","''")
	enrollment_num=re.sub(' +',' ',enrol_num).strip()

	sem_name=1

	hostel_dh=sheet_obj.cell(row,3).value

	yes_no_val=sheet_obj.cell(row,4).value

	query1="select stud_id from exams_mst_students where stud_enrollment_number='%s'"%(enrollment_num)
	cursor.execute(query1)
	studexists=cursor.fetchall()
	stud_id=studexists[0][0]

	if hostel_dh=='Hostel':
		hostel_column_val=15
	if hostel_dh=='DH':
		hostel_column_val=16

	if yes_no_val == 'Yes':
		yes_no_column='Y'
	if yes_no_val == 'No':
		yes_no_column='N'
	
	#print "studexistss",studexists[0][0]
	query2="select shd_stud_id from fees_rel_stud_hostel_dh_details where shd_stud_id='%s' and shd_sem_id='%s' and shd_hostel_dh='%s' and shd_yes_no='%s'"%(stud_id,'1',hostel_column_val,yes_no_column)
	cursor.execute(query2)
	stud_dh_exists=cursor.fetchall()
	
	if len(stud_dh_exists)==0:
		insert_query="insert into fees_rel_stud_hostel_dh_details (shd_stud_id,shd_sem_id,shd_hostel_dh,shd_yes_no,shd_creator_empl_id,stud_fee_created_datetime,shd_enabled,shd_deleted)VALUES('%s','%s','%s','%s','%s','%s','%s','%s')"%(stud_id,1,hostel_column_val,yes_no_column,239,today,'Y','N')
		cursor.execute(insert_query)
		print "inserted",enrollment_num
	else:
		print "Hostel/DH information is already there",enrollment_num


cursor.close()
con_evalbase.commit()
con_evalbase.close()







