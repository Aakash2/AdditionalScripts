# Create your views here.
import socket, pickle
import django
import xlwt
import os
import psycopg2
import re
from datetime import datetime, date,timedelta as td
import calendar
import time 
import json
import psycopg2
import xlrd
from datetime import datetime as dt
from datetime import timedelta
con_evalbase = psycopg2.connect(database='examevaldb',  user='exam', password='123456', host='localhost')
cursor = con_evalbase.cursor()
print 'Enrollment No'+';'+'Name'+';'+'Date'+';'+'Lecture Time'+';'+'Attendance'+';'+'Program Name'
att=''
lectime=''
from_time=to_time=''
fcLectures=['2017-06-14','2017-06-15','2017-06-21','2017-06-22','2017-06-28','2017-06-29','2017-07-05','2017-07-06','2017-07-12','2017-07-13','2017-07-19','2017-07-20','2017-07-26','2017-07-27','2017-08-02','2017-08-03','2017-08-09','2017-08-10','2017-08-16','2017-08-17','2017-08-23','2017-08-24','2017-08-31']

time=['14:00:00','18:00:00']
for k in time:
	for i in fcLectures:
		a = datetime.strptime(i,'%Y-%m-%d').date()
		b = datetime.strptime('2017-07-05','%Y-%m-%d').date()
		#Finding fc's student
		someDetail ='''select distinct stud_enrollment_number,stud_fname,stud_lname,prog_name from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id inner join exams_mst_programs on stud_prog_id = prog_id inner join exams_mst_courses on rscs_course_id=cour_id inner join exams_rel_campus_school_programes_courses on rcp_prog_id= stud_prog_id and rscs_course_id=rcp_cour_id inner join exams_mst_schools on rcp_school_id=sch_id where rscs_course_id in (1,2,3,4,5) and rscs_deleted='N' and stud_deleted='N' and stud_status='OnRole' and rscs_batch_id=21 and rcp_deleted='N' and sch_deleted='N' and rcp_campus_id=1 order by prog_name '''
		cursor.execute(someDetail)	
		someDetailList = cursor.fetchall() 
		#print "len",len(someDetailList)
	
		for j in someDetailList:
			stud_enrollment_number=j[0]
			name=j[1]+' '+j[2]
			prog_name=j[3]
			#cour_name=j[4]
			#sch_name=j[5] 

			if k =='14:00:00':				
				#if a < b:
					#from_time='13:30:00'
					#to_time='14:30:00'
				#else:
				from_time='13:45:00'
				to_time='14:10:00'
		
				InObj='''select enroll_no  from studattendance_mst_biometric_attendance where device_number in
		('mumbai_convention_gate1','mumbai_convention_gate2','mumbai_convention_gate3','mumbai_convention_gate4')
		and punch_date = '%s' and punch_time between '%s' and '%s' and enroll_no='%s' order by punch_date,punch_time'''%(i,from_time,to_time,stud_enrollment_number) 
				cursor.execute(InObj)	
				InLen = cursor.fetchall() 
				lecttime='14-16'
				if len(InLen) > 0:
					att='P'
				else:
					att='A'
				
			elif k =='18:00:00':
				#if a < b:
					#from_time='17:30:00'
					#to_time='18:30:00'
				#else:
				from_time='17:50:00'
				to_time='18:15:00'

				outObj='''select enroll_no  from studattendance_mst_biometric_attendance where device_number in
		('mumbai_convention_gate1','mumbai_convention_gate2','mumbai_convention_gate3','mumbai_convention_gate4')
		and punch_date = '%s' and punch_time between '%s' and '%s' and enroll_no='%s' order by punch_date,punch_time'''%(i,from_time,to_time,stud_enrollment_number) 
				cursor.execute(outObj)	
				InLen = cursor.fetchall()
				lecttime='16-18' 
				if len(InLen) > 0:
					att='P'
				else:
					att='A'


			#if att=='A':
				#print i+';'+k+';'+stud_enrollment_number+';'+att
			print stud_enrollment_number+';'+name+';'+i+';'+lecttime+';'+att+';'+prog_name#+';'+cour_name+';'+sch_name
				


