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
con_evalbase = psycopg2.connect(database='examevaldb',  user='exam', password='123456', host='')
cursor = con_evalbase.cursor()

#print 'Cpse Id'+'|'+'Program Name'+'|'+'Course Name'+'|'+'Course Type'+'|'+'Class Date'+'|'+'Class Schedule Time'+'|'+'Total Student Count'+'|'+'InTime Count'+'|'+'Out Time Count'+'|'+'Present Attendance Count'+'|'+'Present(Either In/out)'
print 'Enrollment No'+';'+'Name'+';'+'Cpse Id'+';'+'Program Name'+';'+'Course Name'+';'+'Course Type'+';'+'Class Date'+';'+'Class Schedule Time'+';'+'RoomID'+';'+'Room Name'+';'+'Device List'+';'+'InTime Count'+';'+'Out Time Count'+';'+'Present Status'+';'+'From Punch'+';'+'To Punch'
allrec=[]
allclasses=[]
classDays=[]
status=''
someDetail ='''select distinct rscs_cpse_id,rscs_course_id,stud_enrollment_number,cprs_room_id,cprs_fromtime,cprs_totime,cprs_fixed_classes,cour_name,prog_name,cpse_cour_type,room_name,stud_fname,stud_lname
from exams_mst_students
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id 
inner join exams_rel_courses_programes_semesters on cpse_id=rscs_cpse_id
inner join studattendance_rel_courses_programes_room_schedule on cprs_cpse_id=rscs_cpse_id
inner join exams_mst_courses on rscs_course_id= cour_id
inner join exams_mst_programs on cpse_prog_id=prog_id
inner join studattendance_mst_rooms  on room_id= cprs_room_id
where stud_status ='OnRole' and stud_sem_id='1' and stud_acba_id='21' and stud_deleted='N' and cpse_deleted='N' and 
rscs_course_id not in (1,2,3,4,5) and rscs_deleted='N' and cprs_deleted='N' order by stud_enrollment_number,rscs_cpse_id'''
cursor.execute(someDetail)	
someDetailList = cursor.fetchall() 

#print "someDetail",len(someDetailList)
cnt=1
for i in someDetailList:
	#print "i",i
	rscs_cpse_id=i[0]
	rscs_course_id=i[1]
	stud_enrollment_number=i[2]
	cprs_room_id=i[3]
	cprs_fromtime=i[4]
	cprs_totime=i[5]
	cprs_fixed_classes=i[6]
	prog_name=i[7]
	cour_name=i[8]
	cpse_cour_type=i[9]
	room_name=i[10]
	stud_fname=i[11]
	stud_lname=i[12]
	
	finddeviceobj='''select distinct bd_device_no from studattendance_rel_device_room inner join studattendance_mst_biometric_device on bd_id in (select cast(regexp_split_to_table (dvrm_bd_id ,',') as int) as "dvrmbdid" from studattendance_rel_device_room where dvrm_room_id = '%s' and dvrm_deleted='N') order by bd_device_no'''%(cprs_room_id)
	cursor.execute(finddeviceobj)	
	deviceList = cursor.fetchall() 
	
	

	for dt in eval(cprs_fixed_classes):
		frompunch=topunch=''
		frompunch_=[]
		topunch_=[]
		#print "class_date",dt
		y= datetime.strptime(dt,"%Y-%m-%d").date()

		fromdatetime = datetime.combine(y, datetime.strptime(str(cprs_fromtime),"%H:%M:%S").time())
		todatetime = datetime.combine(y, datetime.strptime(str(cprs_totime),"%H:%M:%S").time())

		from_minus_ten= (fromdatetime- td(minutes = 0)).time()
		from_plus_ten= (fromdatetime+ td(minutes = 10)).time()

		to_minus_ten= (todatetime - td(minutes = 10)).time()
		to_plus_ten= (todatetime + td(minutes = 10)).time()
		
		#print "to_minus_ten",from_plus_ten,to_minus_ten
		
		#In time Count

		inObj='''select distinct enroll_no,punch_time from studattendance_mst_biometric_device inner join studattendance_mst_biometric_attendance on device_number = bd_device_no where punch_date='%s' and enroll_no in (select stud_enrollment_number from tcourse_evaluation_rel_stu_courses inner join exams_mst_students on rscs_stu_id=stud_id where rscs_cpse_id='%s' and rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' order by stud_enrollment_number) and (punch_time between '%s' and '%s') and bd_id in (select cast(regexp_split_to_table (dvrm_bd_id ,',') as int) as "dvrmbdid" from studattendance_rel_device_room where dvrm_room_id = '%s' and dvrm_deleted='N' and enroll_no='%s')''' %(dt,rscs_cpse_id,from_minus_ten,from_plus_ten,cprs_room_id,stud_enrollment_number) 
		#print "inObj",inObj
		cursor.execute(inObj)	
		intimevalidList = cursor.fetchall() 
		intimecount=len(intimevalidList)
		for j in intimevalidList:
			frompunch=j[1]
			frompunch_.append(str(frompunch))
		#Out time Count

		outObj='''select distinct enroll_no,punch_time from studattendance_mst_biometric_device inner join studattendance_mst_biometric_attendance on device_number = bd_device_no where punch_date='%s' and enroll_no in (select stud_enrollment_number from tcourse_evaluation_rel_stu_courses inner join exams_mst_students on rscs_stu_id=stud_id where rscs_cpse_id='%s' and rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' order by stud_enrollment_number) and (punch_time between '%s' and '%s') and bd_id in (select cast(regexp_split_to_table (dvrm_bd_id ,',') as int) as "dvrmbdid" from studattendance_rel_device_room where dvrm_room_id = '%s' and dvrm_deleted='N'and enroll_no ='%s')''' %(dt,rscs_cpse_id,to_minus_ten,to_plus_ten,cprs_room_id,stud_enrollment_number)
		cursor.execute(outObj)	
		outtimevalidList = cursor.fetchall() 
		outtimecount=len(outtimevalidList)
		for b in outtimevalidList:
			topunch=b[1]
			topunch_.append(str(topunch))


		if intimecount > 0 and outtimecount > 0:
			status='P'
		else :
			status='A'
		

		print str(stud_enrollment_number)+';'+str(stud_fname)+' '+ str(stud_lname)+';'+str(rscs_cpse_id)+';'+str(prog_name)+';'+str(cour_name)+';'+cpse_cour_type+';'+str(dt)+';'+str(cprs_fromtime)+'-'+str(cprs_totime)+';'+str(cprs_room_id)+';'+str(room_name)+';'+str(deviceList)+';'+str(intimecount)+';'+str(outtimecount)+';'+str(status)+';'+str(frompunch_)+';'+str(topunch_)

