import psycopg2
from datetime import datetime
import re
import xlrd

con_evalbase = psycopg2.connect(database='examevaldb',  user='exam',password='123456',host='localhost')

cursor_obj = con_evalbase.cursor()
today = datetime.now()

updcnt=0
excnt=0
rscsids=[]	
courli=[]
studs=[]
files="common_course_sw.xls"
workbook_obj=xlrd.open_workbook(files)
sheet_obj=workbook_obj.sheet_by_name('Sheet1')
for row in range(1,sheet_obj.nrows):
	#enrolment no
	enrolcol_newln =sheet_obj.cell(row,1).value.replace('\n','')
	enrolname_val= enrolcol_newln.replace("'","''")
	enrollno = re.sub(' +',' ',enrolname_val).strip()
	query1="select stud_id,stud_campus_id from exams_mst_students where stud_enrollment_number='%s' and stud_deleted='N' and stud_status ='OnRole'"%(enrollno)
	cursor_obj.execute(query1)
	studlist=cursor_obj.fetchall()
	
	if len(studlist)!=0:
		#course
		studid=studlist[0][0]
		studcampusid=studlist[0][1]
		courcol_newln =sheet_obj.cell(row,2).value.replace('\n','')
		courname_val= courcol_newln.replace("'","''")
		courname = re.sub(' +',' ',courname_val).strip()
		query2="select cour_id from exams_mst_courses where cour_name='%s' and cour_deleted='N'"%(courname)

		cursor_obj.execute(query2)
		courlist=cursor_obj.fetchall()
		courid=courlist[0][0]
		if courid not in courli:
			courli.append(courid)
		#batch
		batchcol_newln =sheet_obj.cell(row,4).value.replace('\n','')
		batchname_val= batchcol_newln.replace("'","''")
		batchname = re.sub(' +',' ',batchname_val).strip()
		query3="select acba_id from exams_mst_academic_batches where acba_name='%s' and acba_deleted='N'"%(batchname)
		cursor_obj.execute(query3)
		batchlist=cursor_obj.fetchall()
		batchid=batchlist[0][0]

		#semester
		semesid=sheet_obj.cell(row,5).value

		#faculty email id
		femailcol_newln =sheet_obj.cell(row,6).value.replace('\n','')
		femailname_val= femailcol_newln.replace("'","''")
		femailname = re.sub(' +',' ',femailname_val).strip()
	
		query4="select empl_id from exams_mst_employees where empl_email='%s' and empl_deleted='N'"%(femailname)
		cursor_obj.execute(query4)
		empllist=cursor_obj.fetchall()
		emplid=empllist[0][0]

		#rscs enrollment check
		query5="select cpse_id from exams_rel_courses_programes_semesters where cpse_acba_id=%d and cpse_cour_id=%d and cpse_seme_id=%d and cpse_campus_id=%d and cpse_deleted='N' "%(batchid,courid,int(semesid),studcampusid)
		cursor_obj.execute(query5)
		cpselist=cursor_obj.fetchall()
		cpseid=cpselist[0][0]
	
		#rscs enrollment check
		try:	
			query6="select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_batch_id=%d and rscs_stu_id=%d and rscs_sem_id=%d and rscs_course_id=%d and rscs_deleted='N' and rscs_course_type='M' "%(batchid,studid,int(semesid),courid)
			cursor_obj.execute(query6)
			rscslist=cursor_obj.fetchall()
			#print batchid,studid,courid
			rscsids.append(rscslist[0][0])
		except:
			excnt=excnt+1
			#print batchid,studid,courid
			studs.extend([batchid,studid,courid])
		if len(rscslist)!=0 :
			query1_upd = "update tcourse_evaluation_rel_stu_courses set rscs_faculty_empl_id=%d,rscs_last_modified_datetime='%s',rscs_last_modifier_id=238 where rscs_id=%d and rscs_deleted='N' and rscs_course_type='M'" %(emplid,today,rscslist[0][0])  
			cursor_obj.execute(query1_upd)
			updcnt=updcnt+1
	else:
		print "student inactive",enrollno,courname

cursor_obj.close()		
con_evalbase.commit()
con_evalbase.close()

#print rscsids,len(rscsids),excnt
print 'Rows Updated: ',updcnt,courli,studs
