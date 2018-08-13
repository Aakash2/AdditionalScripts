import csv
import sys
import psycopg2
from datetime import datetime
import re

con_evalbase = psycopg2.connect(database='examevaldb',  user='hans', password='root', host='localhost')
cursor = con_evalbase.cursor()
#cursor1 = con_evalbase.cursor()
#cursor2 = con_evalbase.cursor()
today = datetime.now()


###enter in mst_courses

f = open('hohephhpphse_sem2.csv', 'rt')

reader = csv.reader(f,delimiter="|")
courselist = []
coursenamelist = []
courseexists = []
stucourseexists = []
studcoursedict={}
count = 490

#code for reading single row from excel
for row in reader:
	coursecol =row[4].strip()
	#course_code='SUB'+str(count)
	
	course_newline = row[4].replace('\n','')
	coursename_val= course_newline.replace("'","''")
	coursename = re.sub(' +',' ',coursename_val).strip()
	coursename_caps = coursename.upper()
	
	if coursename not in courselist:
		courselist.append([coursename_caps,coursename,coursecol]) 

#code for checking and inserting course details 
for value in courselist:
	query1 = "select cour_name from exams_mst_courses where upper(cour_name) = '%s' and cour_deleted='N'"%(value[1])
	cursor.execute(query1)
	courseexists=cursor.fetchall()
	
	if len(courseexists)==0 :
		course_code='SUB'+str(count)
		query1_ins = "insert into exams_mst_courses(cour_code,cour_name,cour_enabled,cour_deleted,cour_creator_empl_id,cour_created_datetime,cour_last_modified_empl_id,cour_last_modified_datetime,cour_history,cour_code_sec) values('%s','%s','Y','N',1,'%s',1,'%s','','%s') " %(course_code,value[2],today,today,value[3])  
		count = count + 1
		cursor.execute(query1_ins)
		
con_evalbase.commit()
f.close()

###enter in rel_campus_prog

#insertion in another table through same csv and read twice because file object state is changed

f = open('hohephhpphse_sem2.csv', 'rt')

reader = csv.reader(f,delimiter="|")
courlist = []
proglist = []
campuslist=[]
campprogexists=[]

for row in reader:
	campuscol =row[0].strip()
	schoolcol =row[7].strip()
	progcode =row[2].strip()
	course_newline = row[4].replace('\n','')
	coursename_val= course_newline.replace("'","''")
	coursename = re.sub(' +',' ',coursename_val).strip()
	coursename_caps = coursename.upper()
	query1="select campus_id from exams_mst_campus where campus_name='%s'"%(campuscol)
	cursor.execute(query1)
	campuslist=cursor.fetchall()
	campusid=campuslist[0][0]
	query1="select sch_id from exams_mst_schools where sch_name='%s'"%(schoolcol)
	cursor.execute(query1)
	schoollist=cursor.fetchall()
	schoolid=schoollist[0][0]
	query1="select prog_id from exams_mst_programs where prog_code='%s'"%(progcode)
	cursor.execute(query1)
	proglist=cursor.fetchall()
	progid=proglist[0][0]
	query1="select cour_id from exams_mst_courses where upper(cour_name)='%s'"%(coursename_caps)
	cursor.execute(query1)
	courlist=cursor.fetchall()
	courid=courlist[0][0]
	query1 = "select rcp_id from exams_rel_campus_school_programes_courses where rcp_campus_id = '%s' and rcp_school_id = '%s' and rcp_prog_id='%s' and rcp_cour_id='%s'"%(campusid,schoolid,progid,courid)
	cursor.execute(query1)
	campprogexists=cursor.fetchall()
	
	if len(campprogexists)==0 :
		query1_ins = "insert into exams_rel_campus_school_programes_courses(rcp_campus_id,rcp_school_id,rcp_prog_id,rcp_cour_id,rcp_enabled,rcp_deleted,rcp_creator_empl_id,rcp_created_datetime,rcp_last_modified_empl_id,rcp_last_modified_datetime,rcp_history) values('%s','%s','%s','%s','Y','N',1,'%s',1,'%s','') " %(campusid,schoolid,progid,courid,today,today)  
		cursor.execute(query1_ins)
		
con_evalbase.commit()
f.close()



