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

workbook_obj=xlrd.open_workbook('test_12.xls')
############################## Please Check the batch_id#######################333
sheet_obj=workbook_obj.sheet_by_name('Sheet1')

pwdlist=[]
catelist=[]
statelist=[]
#camplist=[]
progtypelist=[]
proglist=[]
batchlist=[]
semlist=[]

#used for incrementing the enrollment and registration number
for row in range(1,sheet_obj.nrows):
	#student id
	#student_id += 1	#row[1]	
	
	#enrollment
	enrollno=sheet_obj.cell(row,1).value.replace('\n','')			#row[2].replace(' ','')
	enrol_num=enrollno.replace("'","''")
	enrollment_num=re.sub(' +',' ',enrol_num).strip()
	
	#registration
	regis_newline = sheet_obj.cell(row,17).value.replace('\n','')
	regis_val= regis_newline.replace("'","''")
	regis = re.sub(' +',' ',regis_val).strip()
	print regis

	#fname, mname,lname
	fname_newline = sheet_obj.cell(row,2).value.replace('\n','')
	fname_val= fname_newline.replace("'","''")
	fname = re.sub(' +',' ',fname_val).strip()
	'''mname_newline = sheet_obj.cell(row,).value.replace('\n','')
	mname_val= mname_newline.replace("'","''")
	mname = re.sub(' +',' ',mname_val).strip()
	lname_newline = sheet_obj.cell(row,4).value.replace('\n','')
	lname_val= lname_newline.replace("'","''")
	lname = re.sub(' +',' ',lname_val).strip()'''
   
	# DOB
	dob=sheet_obj.cell(row,3).value   
	#print dob
	
	#date_object = datetime.strptime(dob, '%y-%m-%d')
	'''xldate=sheet_obj.cell(row,3).value         #if not working with Upper Please use this one(this line and below line) For BA use this
   	dob = datetime(1899, 12, 30) + timedelta(days=xldate + 1462 * workbook_obj.datemode)
   	#print dob'''


	#gender & Salutation
	gender_newline=sheet_obj.cell(row,4).value.replace('\n','')
	gender_val= gender_newline.replace("'","''")
	gender = re.sub(' +',' ',gender_val).strip()
	if gender == 'M'or gender=='Male':
	# gender='Male'
		sal='Mr.'
		gender='Male'
	else:
		gender='Female'
		sal='Miss.'
	
	#campus	
	campus_newline = sheet_obj.cell(row,5).value.replace('\n','')
	campus_val= campus_newline.replace("'","''")
	campus = re.sub(' +',' ',campus_val).strip()
	print campus
	if campus == 'Chennai (Banyan)':
		campus='CHENNAI (BANYAN)'
		
	query1="select campus_id from exams_mst_campus where campus_name = '%s'"%(campus)
	cursor.execute(query1)
	campusi=cursor.fetchall()
	campusid=campusi[0][0]
	#print campus

	# hostel
	hostel=sheet_obj.cell(row,6).value.strip()
	
	#category
	caterow_newline=sheet_obj.cell(row,7).value.replace('\n','')
	caterow_val= caterow_newline.replace("'","''")
	caterow = re.sub(' +',' ',caterow_val).strip()	
	if caterow=='GENERAL':
		cateval='GN'
	elif caterow == 'FN' :
		cateval='Foreign National'
	else:
		cateval=sheet_obj.cell(row,7).value.strip()
	#print caterow
	query1 = "select cate_id from exams_mst_categories where cate_name = '%s'"%(cateval)
	#print query1
	cursor.execute(query1)
	catelist=cursor.fetchall()# this list returns o/p as [(4,)]
	#print "These are the values of category list ..:",catelist
	cateid=catelist[0][0] # thus converted and stored in another variable and then used as 4
	
	#semester
	semid=1 # because the 2nd semester id in exams_mst_semesters is 2

	#Address
	query1 = "select coun_id from exams_mst_countries where coun_name = '%s'"%(sheet_obj.cell(row,8).value.strip())
	
	cursor.execute(query1)
	counlist=cursor.fetchall()
	counid=counlist[0][0]
	abc=sheet_obj.cell(row,9).value.strip()
	if abc=='Uttaranchal' :
		abc='Uttarakhand'
	if abc=='Orissa':
		abc='Odisha'
	query1 = "select state_id from exams_mst_state where state_name = '%s'"%(abc)
	cursor.execute(query1)
	statelist=cursor.fetchall()
	stateid=statelist[0][0]

	query1 = "select state_id from exams_mst_state where state_name = '%s'"%(abc)
	cursor.execute(query1)
	domlist=cursor.fetchall()
	domid=domlist[0][0]

	citi_newline = sheet_obj.cell(row,15).value.replace('\n','')
	citi_val= citi_newline.replace("'","''")
	citi = re.sub(' +',' ',citi_val).strip()
	print citi
	query1="select citi_id from exams_mst_cities where citi_name='%s'"%(citi)
	print query1
	cursor.execute(query1)
	citilist=cursor.fetchall()
	citid=citilist[0][0]
	
	# tiss email
	tissemid=sheet_obj.cell(row,11).value.strip()

	# personal email
	personalemid=sheet_obj.cell(row,12).value.strip()
	
	# student mobile no
	studmobno=sheet_obj.cell(row,13).value
	mobile= int(studmobno)
	
	# student other contact no
	studcontno=sheet_obj.cell(row,14).value
	other_mo=int(studcontno)
	
	# address
	studadd=sheet_obj.cell(row,16).value.replace("'","''")
	#print studadd
	
	#batch
	batchid=25 # because the year in exams_mst_academic_batches is 2014-2016
	
	#pwd
	pwdtype=sheet_obj.cell(row,19).value
	if pwdtype=='':
		pwdtype='NA'
	query1="select pwdtype_id from exams_mst_pwdtype where pwdtype_name='%s'"%(pwdtype)
	print "query1"
	cursor.execute(query1)
	pwdtp=cursor.fetchall()
	pwdtt=pwdtp[0][0]
	
	

	#program id
	#progid=sheet_obj.cell(row,21).value # in exams_mst_programs pk
	ampus_newline = sheet_obj.cell(row,18).value.replace('\n','')
	ampus_val= ampus_newline.replace("'","''")
	ampus = re.sub(' +',' ',ampus_val).strip()
	#print ampus
	print "ffffffff",ampus
	if ampus=="M.A./M.Sc in Development Policy, Planning and Practice":
		ampus='M.A./M.Sc. in Development Policy, Planning and Practice'
	
	query1="select prog_id from exams_mst_programs where prog_name='%s'"%(ampus)
	print "query1",query1
	cursor.execute(query1)
	program11=cursor.fetchall()
	progd=program11[0][0]
	#print progd,ampus

	#program type id
	progtypeid=sheet_obj.cell(row,26).value # in mst_programme_type MA id is 1
	ptypeid = int(progtypeid)
	
	#pincode
	pincode=sheet_obj.cell(row,20).value
	pincode= int(pincode)
	#print pincode
	
	#parents Email
	paremail=sheet_obj.cell(row,21).value
	#print paremail
	
	parent_income=sheet_obj.cell(row,22).value
	#print parent_income
	
	#print parent_income

	#existing record check
	query1="select stud_id from exams_mst_students where stud_enrollment_number='%s'"%(enrollment_num)
	cursor.execute(query1)
	studexists=cursor.fetchall()
	#print fname

	stud_password=sheet_obj.cell(row,23).value
	stud_fee_paid_semester=1
	stud_goi=sheet_obj.cell(row,24).value	
	
	#print "progdddddddd",progd
	if len(studexists)==0:
		query1_ins = "insert into exams_mst_students(stud_enrollment_number,stud_regis_number,stud_salutation,stud_fname,stud_dob,stud_gender,stud_campus_id,stud_prog_id,stud_prog_type_id,stud_acba_id,stud_sem_id,stud_pwdtype_id,stud_hostel,stud_admission_cate_id,stud_status,stud_coun_id,stud_state_id,stud_citi_id,stud_domicile_id,stud_tiss_email,stud_other_email,stud_mobile_number,stud_other_number,stud_permanentadd,stud_pincode,stud_parent_email,stud_parent_number,stud_parent_income,stud_creator_empl_id,stud_created_datetime,stud_last_modified_empl_id,stud_last_modified_datetime,stud_history,stud_enabled,stud_deleted,stud_fee_paid_semester,stud_goi) values('%s','%s','%s','%s','%s','%s', '%s','%s','%s','%s','%s','%s','','%s','OnRole','%s','%s','%s','%s','%s','%s','%s',null,'%s','%s','%s','%s','%s',1,'%s',1,'%s','','Y','N','%s','%s') " %(enrollment_num,regis,sal,fname,dob,gender,campusid,progd,ptypeid,batchid,semid,pwdtt,  cateid,counid,stateid,citid,domid,tissemid,personalemid,mobile,studadd,pincode,paremail,other_mo,parent_income,today,today,stud_fee_paid_semester,stud_goi)  
		cursor.execute(query1_ins)
	

		query_auth="insert into auth_user(password,last_login,is_superuser,username,first_name,last_name,email,is_staff,is_active,date_joined)VALUES('%s','%s','%s','%s','%s','%s','%s','%s', '%s','%s')"%(stud_password,today,'FALSE',enrollment_num,fname,fname,tissemid,'TRUE','TRUE',today)
		cursor.execute(query_auth)
		
	else:
		print "%s student name already exists" %(fname)

cursor.close()
con_evalbase.commit()
con_evalbase.close()

#Note:hostel is No for all
#other_mo should be parents mobile number
#other mobile number should be something(25)


