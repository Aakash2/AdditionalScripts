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

from datetime import timedelta
con_evalbase = psycopg2.connect(database='examevaldb',  user='exam', password='123456', host='localhost')
cursor = con_evalbase.cursor()

print 'Cpse Id'+'|'+'Program Name'+'|'+'Course Name'+'|'+'Course Type'+'|'+'Room Name'+'|'+'Class Date'+'|'+'Class Schedule Time'+'|'+'Total Student Count'+'|'+'InTime Count'+'|'+'Out Time Count'+'|'+'Present Attendance Count'+'|'+'Present(Either In/out)'
allrec=[]
allclasses=[]
classDays=[]
someDetail ='''select rscs_cpse_id,cour_name, count(rscs_stu_id) ,cprs_fromtime,cprs_totime,cprs_room_id,cprs_fixed_classes,prog_name,rscs_course_type,room_name from tcourse_evaluation_rel_stu_courses inner join exams_mst_students on rscs_stu_id=stud_id inner join exams_mst_courses on rscs_course_id=cour_id inner join  exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and cpse_deleted='N' inner join exams_mst_programs on cpse_prog_id=prog_id inner join studattendance_rel_courses_programes_room_schedule on rscs_cpse_id=cprs_cpse_id and cprs_deleted='N' inner join studattendance_mst_rooms on cprs_room_id=room_id where stud_status='OnRole' and stud_deleted='N' and rscs_deleted='N' and rscs_course_id not in (1,2,3,4,5) and rscs_cpse_id in (select distinct cpse_id from studattendance_rel_courses_programes_room_schedule inner join exams_rel_courses_programes_semesters on cprs_cpse_id=cpse_id where cpse_deleted='N' and cprs_deleted='N' and cpse_acba_id in (10) and cpse_seme_id = 3) group by rscs_cpse_id,cour_name,cprs_fromtime,cprs_totime,cprs_fixed_classes,cprs_room_id,prog_name,rscs_course_type,room_name order by cour_name'''
cursor.execute(someDetail)	
someDetailList = cursor.fetchall() 

#print "someDetail",len(someDetailList)
cnt=1
for i in someDetailList:
	rscs_cpse_id=i[0]
	cour_name=i[1]
	mapping_stud_count=i[2]
	cprs_fromtime=i[3]
	cprs_totime=i[4]
	cprs_room_id=i[5]
	cprs_fixed_classes=i[6]
	prog_name=i[7]
	courseType=i[8]
	room_name=i[9]

	for dt in eval(cprs_fixed_classes):
		#print "class_date",dt
		
		
		y= datetime.strptime(dt,"%Y-%m-%d").date()

		fromdatetime = datetime.combine(y, datetime.strptime(str(cprs_fromtime),"%H:%M:%S").time())
		todatetime = datetime.combine(y, datetime.strptime(str(cprs_totime),"%H:%M:%S").time())

		from_minus_ten= (fromdatetime- td(minutes = 0)).time()
		from_plus_ten= (fromdatetime+ td(minutes = 10)).time()

		to_minus_ten= (todatetime - td(minutes = 10)).time()
		to_plus_ten= (todatetime + td(minutes = 10)).time()

		#In time Count

		inObj='''select distinct enroll_no from studattendance_mst_biometric_device inner join studattendance_mst_biometric_attendance on device_number = bd_device_no where punch_date='%s' and enroll_no in (select stud_enrollment_number from tcourse_evaluation_rel_stu_courses inner join exams_mst_students on rscs_stu_id=stud_id where rscs_cpse_id='%s' and rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' order by stud_enrollment_number) and (punch_time between '%s' and '%s') and bd_id in (select cast(regexp_split_to_table (dvrm_bd_id ,',') as int) as "dvrmbdid" from studattendance_rel_device_room where dvrm_room_id = '%s' and dvrm_deleted='N') order by enroll_no'''%(dt,rscs_cpse_id,from_minus_ten,from_plus_ten,cprs_room_id) 
		cursor.execute(inObj)	
		intimevalidList = cursor.fetchall() 
		intimecount=len(intimevalidList)
		
		#Out time Count

		outObj='''select distinct enroll_no from studattendance_mst_biometric_device inner join studattendance_mst_biometric_attendance on device_number = bd_device_no where punch_date='%s' and enroll_no in (select stud_enrollment_number from tcourse_evaluation_rel_stu_courses inner join exams_mst_students on rscs_stu_id=stud_id where rscs_cpse_id='%s' and rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' order by stud_enrollment_number) and (punch_time between '%s' and '%s') and bd_id in (select cast(regexp_split_to_table (dvrm_bd_id ,',') as int) as "dvrmbdid" from studattendance_rel_device_room where dvrm_room_id = '%s' and dvrm_deleted='N') order by enroll_no''' %(dt,rscs_cpse_id,to_minus_ten,to_plus_ten,cprs_room_id)
		cursor.execute(outObj)	
		outtimevalidList = cursor.fetchall() 
		outtimecount=len(outtimevalidList)

		intersectObj='''(select distinct enroll_no from studattendance_mst_biometric_device inner join studattendance_mst_biometric_attendance on device_number = bd_device_no where punch_date='%s' and enroll_no in (select stud_enrollment_number from tcourse_evaluation_rel_stu_courses inner join exams_mst_students on rscs_stu_id=stud_id where rscs_cpse_id='%s' and rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' order by stud_enrollment_number) and (punch_time between '%s' and '%s') and bd_id in (select cast (regexp_split_to_table (dvrm_bd_id ,',') as int) as "dvrmbdid" from studattendance_rel_device_room where dvrm_room_id = '%s' and dvrm_deleted='N') order by enroll_no) intersect (select distinct enroll_no from studattendance_mst_biometric_device inner join studattendance_mst_biometric_attendance on device_number = bd_device_no where punch_date='%s' and enroll_no in (select stud_enrollment_number from tcourse_evaluation_rel_stu_courses inner join exams_mst_students on rscs_stu_id=stud_id where rscs_cpse_id='%s' and rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' order by stud_enrollment_number) and (punch_time between'%s' and '%s') and bd_id in (select cast(regexp_split_to_table (dvrm_bd_id ,',') as int) as "dvrmbdid" from studattendance_rel_device_room where dvrm_room_id = '%s' and dvrm_deleted='N') order by enroll_no)'''%(dt,rscs_cpse_id,from_minus_ten_new,from_plus_ten_new,cprs_room_id,dt,rscs_cpse_id,to_minus_ten,to_plus_ten,cprs_room_id)
		cursor.execute(intersectObj)	
		intersecttimevalidList = cursor.fetchall() 
		intersecttimecount=len(intersecttimevalidList)
		


		unionObj='''(select distinct enroll_no from studattendance_mst_biometric_device inner join studattendance_mst_biometric_attendance on device_number = bd_device_no where punch_date='%s' and enroll_no in (select stud_enrollment_number from tcourse_evaluation_rel_stu_courses inner join exams_mst_students on rscs_stu_id=stud_id where rscs_cpse_id='%s' and rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' order by stud_enrollment_number) and (punch_time between '%s' and '%s') and bd_id in (select cast (regexp_split_to_table (dvrm_bd_id ,',') as int) as "dvrmbdid" from studattendance_rel_device_room where dvrm_room_id = '%s' and dvrm_deleted='N') order by enroll_no) union (select distinct enroll_no from studattendance_mst_biometric_device inner join studattendance_mst_biometric_attendance on device_number = bd_device_no where punch_date='%s' and enroll_no in (select stud_enrollment_number from tcourse_evaluation_rel_stu_courses inner join exams_mst_students on rscs_stu_id=stud_id where rscs_cpse_id='%s' and rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' order by stud_enrollment_number) and (punch_time between'%s' and '%s') and bd_id in (select cast(regexp_split_to_table (dvrm_bd_id ,',') as int) as "dvrmbdid" from studattendance_rel_device_room where dvrm_room_id = '%s' and dvrm_deleted='N') order by enroll_no)'''%(dt,rscs_cpse_id,from_minus_ten,from_plus_ten,cprs_room_id,dt,rscs_cpse_id,to_minus_ten,to_plus_ten,cprs_room_id)
		cursor.execute(unionObj)	
		uniontimevalidList = cursor.fetchall() 
		uniontimecount=len(uniontimevalidList)


		print str(rscs_cpse_id)+'|'+prog_name+'|'+cour_name+'|'+str(courseType)+'|'+str(room_name)+'|'+str(dt)+'|'+str(cprs_fromtime)+'-'+str(cprs_totime)+'|'+str(mapping_stud_count)+'|'+str(intimecount)+'|'+str(outtimecount)+'|'+str(intersecttimecount)+'|'+str(uniontimecount)
