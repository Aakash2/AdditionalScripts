import csv
import sys
import psycopg2
from datetime import datetime

con_erpbase = psycopg2.connect(database='studbase',  user='stud_user1', password='123456', host='localhost' ) 
#host='192.168.194.20') 
cursor = con_erpbase.cursor()

today = datetime.now()

f = open(r"ut3.csv", "rt")
#with open(r"UntitledMPhilRS.csv") as f: 
List1 = []
List2 = []
List3 = []
List4 = []

reader = csv.reader(f,delimiter="|")
counter	=0
for row in reader:
	print row
	country="select coun_id from studbase_mst_countries where coun_name = '%s'"%str(row[6])
	cursor.execute(country)
	country_id = cursor.fetchall()
	state="select state_id from studbase_mst_state where state_name = '%s'"%str(row[7])
	cursor.execute(state)
	state_id = cursor.fetchall()
	if str(row[8]) == 'Other':
		citiname='Others'
		citi="select citi_id from studbase_mst_cities where citi_name = '%s'"%(citiname)
	else:
		citi="select citi_id from studbase_mst_cities where citi_name = '%s'"%str(row[8])
	cursor.execute(citi)
	citi_id = cursor.fetchall()
	domicile="select state_id from studbase_mst_state where state_name = '%s'"%str(row[9])
	cursor.execute(domicile)
	domicile_id = cursor.fetchall()
	if str(row[12]) == 'GN':
		cate = 'General'
		category = "select cate_id from studbase_mst_category where cate_name = '%s'"%(cate)
	else:
		category = "select cate_id from studbase_mst_category where cate_name = '%s'"%str(row[12])
	cursor.execute(category)
	category_id = cursor.fetchall()
	school_centre = "select sc_id from studbase_mst_school_center where sc_name = '%s'"%str(row[13].replace("'","''"))
	cursor.execute(school_centre)
	school_centre_id = cursor.fetchall()
	typename = "select type_id from studbase_mst_type where type_name = '%s'"%str(row[14])
	cursor.execute(typename)
	typename_id = cursor.fetchall()
	semname = "select sem_id from studbase_mst_semester where sem_name = '%s'"%str(row[15])
	cursor.execute(semname)
	semname_id = cursor.fetchall()
	#print semname_id[0][0]
	pwd_type_val = str(row[18])
	#pwdtype_id_val = 0
	#print row[36]
	campusname = "select campus_id from studbase_mst_campus where campus_name = '%s'"%str(row[36])
	cursor.execute(campusname)
	campusname_id = cursor.fetchall() 
	
	#query1 = "select stud_id from secretary_mst_stud_personal_details where stud_enrollno ='%s' and stud_tissemail = '%s'"%(row[0],row[21])
	#cursor.execute(query1)
	#stuenrolltissidexists=cursor.fetchall()
	#print len(stucourseexists)
	#address=row[23].replace("\'","")
	#print address
	#research_proposal=row[48].replace("\'","")
	research_proposal=" "
	#print research_proposal
	enrollno=row[0]
	#print enrollno
	#ab=row[38]
	#print ab
	#print ':dsad'
	#print enrollno,row[1],row[2],row[3],row[4],row[5],country_id[0][0],state_id[0][0],citi_id[0][0],domicile_id[0][0],row[10],row[11],category_id[0][0],school_centre_id[0][0],typename_id[0][0],semname_id[0][0],row[17],row[19],row[20],row[22],row[23],row[25],row[26],row[27],row[28],row[29],row[30],row[31],row[32],row[33],row[34],row[35],campusname_id[0][0],row[37],today,today
	#query1 = "select stud_id from secretary_mst_stud_personal_details where stud_enrollno ='%s' and stud_tissemail = '%s'"%(row[0],row[21])
	#cursor.execute(query1)
	#stuenrolltissidexists=cursor.fetchall()
	#print len(stuenrolltissidexists)
	query1 = "select stud_id from secretary_mst_stud_personal_details where stud_enrollno ='%s'"%(enrollno)
	cursor.execute(query1)
	stuenrolltissidexists=cursor.fetchall()
	print 'Length of students',enrollno
	#print len(stuenrolltissidexists)
	
	if len(stuenrolltissidexists)==0 :
		counter=counter+1 
		if pwd_type_val == '':
			query1_ins = "insert into secretary_mst_stud_personal_details(stud_enrollno,stud_fname,stud_mname,stud_lname,stud_dob,stud_gender,stud_coun_id,stud_state_id,stud_citi_id,stud_domicile_id,stud_qualification,stud_annualincome,stud_category_id,stud_course_id,stud_type_id,stud_sem_id,stud_guide_id,stud_ispwd,stud_mobileno,stud_othercontact,stud_tissemail,stud_personalemail,stud_permanentadd,stud_campstat,stud_work,stud_partfull,stud_offaddress,stud_empnoc,stud_experience,stud_medical,stud_admityr,stud_netset,stud_hostel,stud_hosteladd,stud_address,stud_campus_id,stud_currentstatus,stud_mphilphd,stud_mphilenrollno,stud_modularcourse_attended,stud_modularcourse1,stud_modularcourse2,stud_modularcourse3,stud_modularcourse4,stud_modularcourse5,stud_modularcourse6,stud_mphilphdcomp,stud_creator_empl_id,stud_created_datetime,stud_last_modifier_empl_id,stud_last_modified_datetime,stud_enabled,stud_deleted,stud_research_proposal_title,stud_pg_tiss,stud_pg_school_center_id,stud_newenrollno) values('%s','%s','%s','%s','%s','%s',%d,%d,%d,%d,'%s','%s',%d,%d,%d,%d,NULL,'%s','%s','%s','','%s','%s','%s','','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',%d,'%s','','','','','','','','','','No',1,'%s',1,'%s','Y','N','','',NULL,'') " %(enrollno,row[1],row[2],row[3],row[4],row[5],country_id[0][0],state_id[0][0],citi_id[0][0],domicile_id[0][0],row[10],row[11],category_id[0][0],school_centre_id[0][0],typename_id[0][0],semname_id[0][0],row[17],row[19],row[20],row[22],row[23],row[25],row[26],row[27],row[28],row[29],row[30],row[31],row[32],row[33],row[34],row[35],campusname_id[0][0],row[37],today,today) 
			cursor.execute(query1_ins) 
		else:
			print 'In Else part : '			
			print str(row[18])
			pwdtype = "select pwdtype_id from studbase_mst_pwdtype where pwdtype_name = '%s'"%str(row[18])
			cursor.execute(pwdtype)
			pwdtype_id = cursor.fetchall()
			pwdtype_id_val = int(pwdtype_id[0][0])
			print pwdtype_id_val 
			query1_ins = "insert into secretary_mst_stud_personal_details(stud_enrollno,stud_fname,stud_mname,stud_lname,stud_dob,stud_gender,stud_coun_id,stud_state_id,stud_citi_id,stud_domicile_id,stud_qualification,stud_annualincome,stud_category_id,stud_course_id,stud_type_id,stud_sem_id,stud_guide_id,stud_ispwd,stud_pwdtype_id,stud_mobileno,stud_othercontact,stud_tissemail,stud_personalemail,stud_permanentadd,stud_campstat,stud_work,stud_partfull,stud_offaddress,stud_empnoc,stud_experience,stud_medical,stud_admityr,stud_netset,stud_hostel,stud_hosteladd,stud_address,stud_campus_id,stud_currentstatus,stud_mphilphd,stud_mphilenrollno,stud_modularcourse_attended,stud_modularcourse1,stud_modularcourse2,stud_modularcourse3,stud_modularcourse4,stud_modularcourse5,stud_modularcourse6,stud_mphilphdcomp,stud_creator_empl_id,stud_created_datetime,stud_last_modifier_empl_id,stud_last_modified_datetime,stud_enabled,stud_deleted,stud_research_proposal_title,stud_pg_tiss,stud_pg_school_center_id,stud_newenrollno) values('%s','%s','%s','%s','%s','%s',%d,%d,%d,%d,'%s','%s',%d,%d,%d,%d,NULL,'%s',%d,'%s','%s','','%s','%s','%s','','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',%d,'%s','','','','','','','','','','No',1,'%s',1,'%s','Y','N','','',NULL,'') " %(enrollno,row[1],row[2],row[3],row[4],row[5],country_id[0][0],state_id[0][0],citi_id[0][0],domicile_id[0][0],row[10],row[11],category_id[0][0],school_centre_id[0][0],typename_id[0][0],semname_id[0][0],row[17],pwdtype_id_val,row[19],row[20],row[22],row[23],row[25],row[26],row[27],row[28],row[29],row[30],row[31],row[32],row[33],row[34],row[35],campusname_id[0][0],row[37],today,today) 
			cursor.execute(query1_ins) 
	
	con_erpbase.commit()
print counter
f.close()
'''
f = open('MphilPhdothercampus_2015_tiss_id.csv', 'rt')

reader = csv.reader(f,delimiter="|")
for row in reader:
	enrollno=row[0].replace(" ","")
	updatequery="update secretary_mst_stud_personal_details set stud_tissemail='%s' where stud_enrollno='%s'"%(row[1],enrollno)
	cursor.execute(updatequery) 
	
	con_erpbase.commit()

f.close()
'''
cursor.close()
con_erpbase.close()
