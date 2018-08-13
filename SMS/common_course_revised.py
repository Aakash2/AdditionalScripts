import psycopg2
from datetime import datetime
import re
import xlrd



con_evalbase = psycopg2.connect(database='examevaldb',user='exam', password='123456',host='localhost') #'192.168.194.37'
cursor = con_evalbase.cursor()
today = datetime.now()

workbook_obj=xlrd.open_workbook('SW_II_sem.xls')
sheet_obj=workbook_obj.sheet_by_name('Sheet1')
enrol=[]
course=[]
email_id=[]
enrol_id_ls =[]
course_id_ls = [] 
tiss_email_id_ls =[]
batch_id=[]
batch_id_ls=[]
cpse_course_list=[]
abc=[]
for row_index in range(1,sheet_obj.nrows):                       #1 skips the heading of the excel and starts from the second line
	enrollment_number=sheet_obj.cell(row_index,1).value     #Fetches 0th column value
	course_name=sheet_obj.cell(row_index,2).value
	#print course_name
	faculty_name=sheet_obj.cell(row_index,3).value
	tiss_email=sheet_obj.cell(row_index,6)
	stud_sem=sheet_obj.cell(row_index,5).value
	stud_seme=int(stud_sem)
	stud_batch=sheet_obj.cell(row_index,4).value
	


	query5="select acba_id from exams_mst_academic_batches where acba_name='%s'"%(stud_batch)
	cursor.execute(query5)
	batch_id=cursor.fetchone()
	if batch_id is not None:
		batch_id_ls.append(batch_id[0])
		batch_id_value= int(batch_id[0])	

	query1="select stud_id from exams_mst_students where stud_enrollment_number ='%s'"%(str(enrollment_number.strip()))
	cursor.execute(query1)
	enrol_id = cursor.fetchone() 
	if enrol_id is not None:	
		enrol_id_ls.append(enrol_id[0])

	query2="select cour_id from exams_mst_courses where cour_name = '%s' and cour_deleted='N'"%(str(course_name.strip()))
	cursor.execute(query2)
	course_id = cursor.fetchone()
	#course_id_value=course_id[0][0]
	if course_id is not None:
		course_id_ls.append(course_id[0]) 
		course_id_value= int(course_id[0])

	query3="select empl_id from exams_mst_employees where empl_email = '%s'"%(str(tiss_email).split('\'')[1].strip())
	cursor.execute(query3)
	tiss_email_id = cursor.fetchone()
	if tiss_email_id is not None:
		tiss_email_id_ls.append(tiss_email_id[0])

	print enrollment_number
	
	#print stud_seme,batch_id_value,course_id_value
	query4="select cpse_id from exams_rel_courses_programes_semesters where cpse_seme_id=%d and cpse_acba_id=%d and cpse_cour_id=%d and cpse_deleted='N'"%(stud_seme,batch_id_value,course_id_value)
	cursor.execute(query4)
	abc=cursor.fetchone()
	#print abc
	if abc is not None:
		cpse_course_list.append(abc)
	
	enrol.append(str(enrollment_number.strip()))
	course.append(str(course_name).strip())
	email_id.append(str(tiss_email).split('\'')[1].strip())   #it will only fetch email id and remaing text is splited and we are taking 0th value
	
#print len(cpse_course_list)
cpse_11=( ", ".join( repr(e) for e in cpse_course_list))
#courr = [item[0] for item in cpse_11]
#print cpse_11
all_details=zip(enrol,course,email_id)   #all values are combined here

enrol=tuple(enrol)
course=tuple(course)   #values comes in tuple
email_id=tuple(email_id)

query1="select stud_id from exams_mst_students where stud_enrollment_number in %s"%(enrol,)
cursor.execute(query1)
student_id=[item[0] for item in cursor.fetchall()]            #it convert values from tuple which is in the list like[()] into single list


query1="select cour_id from exams_mst_courses where cour_name in %s and cour_deleted='N'"%(course,)
cursor.execute(query1)
course_id=cursor.fetchall()
#print course_id

query1="select empl_id from exams_mst_employees where empl_email in %s"%(email_id,)
cursor.execute(query1)
employee_id=[item[0] for item in cursor.fetchall()]


#print(", ".join(cpse_course_list))


all_details_new = zip(enrol_id_ls,course_id_ls,tiss_email_id_ls)
for i in all_details_new:
	query111="select rscs_faculty_empl_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id =%s and rscs_course_id =%s and rscs_batch_id=%d and rscs_sem_id=%d"%(i[0],i[1],batch_id_value,stud_seme)
	cursor.execute(query111)
	abcd=[item[0] for item in cursor.fetchall()] 
	faculty_exists=( ", ".join( repr(e) for e in abcd))     #it will remove the square bracket of the list
	#if len(faculty_exists)==0:	
	#print i[2]
	
	query1="update tcourse_evaluation_rel_stu_courses set rscs_faculty_empl_id = %s,rscs_last_modified_datetime ='%s' where rscs_stu_id =%s and rscs_course_id =%s and rscs_batch_id=%d and rscs_sem_id=%d"%(i[2],today,i[0],i[1],batch_id_value,stud_seme)
	
	cursor.execute(query1)
	#print enrollment_number
	#print enrollment_number.strip()+','+course_name.strip()+','+str(faculty_name).strip()
cursor.close()
con_evalbase.commit()
con_evalbase.close()




