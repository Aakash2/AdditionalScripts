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
print 'Enrollment No'+';'+'Name'+';'+'Date'+';'+'From Time'+';'+'To Time'+';'+'From punch Count'+';'+'To punch Count'+';'+'Room_id'+';'+'Attendance'+';'+'punche'
att=''
lectime=''
from_time=to_time=''
frompunch=topunch=''
rname=''
st=['5702','5703','5704','5705']
for f in st:
	
	obj='''select * from studattendance_rel_courses_programes_room_schedule where cprs_cpse_id ='%s' and cprs_deleted='N' order by cprs_fixed_classes'''%(f)
	cursor.execute(obj)	
	classSchedule = cursor.fetchall()

	for l in classSchedule:	
		cprs_cpse_id=l[1]
		cprs_room_id=l[2]
		from_time=l[4]
		to_time=l[5]
		cprs_fixed_classes=l[8]
	
		roomObj='''select room_name from studattendance_mst_rooms where room_id='%s' '''%(cprs_room_id)
		cursor.execute(roomObj)	
		roomdet = cursor.fetchall()
		for r in roomdet:
			rname=r[0]
		for d in eval(cprs_fixed_classes):
			y= datetime.strptime(d,"%Y-%m-%d").date()

			fromdatetime = datetime.combine(y, datetime.strptime(str(from_time),"%H:%M:%S").time())
			todatetime = datetime.combine(y, datetime.strptime(str(to_time),"%H:%M:%S").time())

			from_minus_ten= (fromdatetime- td(minutes = 0)).time()
			from_plus_ten= (fromdatetime+ td(minutes = 10)).time()

			to_minus_ten= (todatetime - td(minutes = 10)).time()
			to_plus_ten= (todatetime + td(minutes = 10)).time()

			from_minus_30= (fromdatetime- td(minutes = 30)).time()
			from_plus_30= (fromdatetime+ td(minutes = 30)).time()

			to_minus_30= (todatetime - td(minutes = 30)).time()
			to_plus_30= (todatetime + td(minutes = 30)).time()
		
			stud_list='''select stud_enrollment_number,stud_fname,stud_lname from tcourse_evaluation_rel_stu_courses inner join exams_mst_students on stud_id = rscs_stu_id where rscs_course_id=9 and rscs_deleted='N' and rscs_batch_id=21 and rscs_cpse_id ='%s' order by stud_enrollment_number'''%(f)

			cursor.execute(stud_list)	
			stuList = cursor.fetchall()

			for h in stuList:
				frompunch=topunch=''
				frompunch_=[]
				topunch_=[]
				enrollment_no=h[0]
				first_name=h[1]
				lname=h[2]
	
				get_from_puch = '''select distinct enroll_no,punch_date,punch_time,ba_cpse_id from studattendance_mst_biometric_attendance left join studattendance_mst_biometric_device on device_number = bd_device_no 
		left join studattendance_rel_device_room on bd_id in (select cast(regexp_split_to_table(dvrm_bd_id ,',') as int) from studattendance_rel_device_room where dvrm_room_id in (%s)) left join studattendance_rel_courses_programes_room_schedule on  cprs_room_id = dvrm_room_id where ba_cpse_id in('0','%s') and punch_date >= '%s' and punch_date <= '%s' and  (punch_time between '%s' and '%s') and enroll_no='%s' '''% (cprs_room_id,cprs_cpse_id, str(d), str(d),from_minus_ten,from_plus_ten,h[0])
				#print "get_from_puch",get_from_puch
				cursor.execute(get_from_puch)					
				from_punches = cursor.fetchall() 
				from_punches_count = len(from_punches)
				#for p in from_punches:
					#frompunch=p[2]
					#frompunch_.append(str(frompunch))


			
				get_from_30 = '''select distinct enroll_no,punch_date,punch_time,ba_cpse_id from studattendance_mst_biometric_attendance left join studattendance_mst_biometric_device on device_number = bd_device_no 
		left join studattendance_rel_device_room on bd_id in (select cast(regexp_split_to_table(dvrm_bd_id ,',') as int) from studattendance_rel_device_room where dvrm_room_id in (%s)) left join studattendance_rel_courses_programes_room_schedule on  cprs_room_id = dvrm_room_id where ba_cpse_id in('0','%s') and punch_date >= '%s' and punch_date <= '%s' and  (punch_time between '%s' and '%s') and enroll_no='%s' '''% (cprs_room_id,cprs_cpse_id, str(d), str(d),from_minus_30,from_plus_30,h[0])
				#print "------------",from_minus_30,from_plus_30
				#print "get_from_30",get_from_30
				cursor.execute(get_from_30)					
				from_punches = cursor.fetchall() 
				from_punches_count = len(from_punches)
				for p in from_punches:
					frompunch=p[2]
					frompunch_.append(str(frompunch))
		
				get_to_puch = '''select distinct enroll_no,punch_date,punch_time,ba_cpse_id from studattendance_mst_biometric_attendance left join studattendance_mst_biometric_device on device_number = bd_device_no 
		inner join studattendance_rel_device_room on bd_id in (select cast(regexp_split_to_table(dvrm_bd_id ,',') as int) from studattendance_rel_device_room where dvrm_room_id in (%s)) left join studattendance_rel_courses_programes_room_schedule on  cprs_room_id = dvrm_room_id where  ba_cpse_id in('0','%s') and punch_date >= '%s' and punch_date <= '%s' and  (punch_time between '%s' and '%s') and enroll_no='%s' '''% (cprs_room_id,cprs_cpse_id, str(d), str(d),to_minus_ten,to_plus_ten,h[0])
				cursor.execute(get_to_puch)
				#print "xxx",get_to_puch	
					 
				to_punches = cursor.fetchall()
				to_punches_count = len(to_punches)	
					
				#for t in to_punches:
					#topunch=t[2]
					#topunch_.append(str(topunch))


			
				get_to_30 = '''select distinct enroll_no,punch_date,punch_time,ba_cpse_id from studattendance_mst_biometric_attendance left join studattendance_mst_biometric_device on device_number = bd_device_no 
		inner join studattendance_rel_device_room on bd_id in (select cast(regexp_split_to_table(dvrm_bd_id ,',') as int) from studattendance_rel_device_room where dvrm_room_id in (%s)) left join studattendance_rel_courses_programes_room_schedule on  cprs_room_id = dvrm_room_id where  ba_cpse_id in('0','%s') and punch_date >= '%s' and punch_date <= '%s' and  (punch_time between '%s' and '%s') and enroll_no='%s' '''% (cprs_room_id,cprs_cpse_id, str(d), str(d),to_minus_30,to_plus_30,h[0])
				cursor.execute(get_to_30)
				#print "xxx",get_to_30	
					 
				to_punches = cursor.fetchall()
				to_punches_count = len(to_punches)	
					
				for t in to_punches:
					topunch=t[2]
					topunch_.append(str(topunch))
			
				if from_punches_count == 0 and to_punches_count > 0:				
					att='A'
				elif from_punches_count > 0 and to_punches_count == 0:
					att='A'
				elif from_punches_count == 0 and to_punches_count == 0:	
					att='A'
				else:
					att='P'
			
				if att=='A':
					print str(h[0])+';'+str(first_name)+' '+str(lname)+';'+str(d)+';'+str(from_time)+';'+str(to_time)+';'+str(from_punches_count)+';'+str(to_punches_count)+';'+str(rname)+';'+str(att)+';'+str(frompunch_)[1:-1]+';'+str(topunch_)[1:-1]

				


