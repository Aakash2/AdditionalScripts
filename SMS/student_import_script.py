import psycopg2
from datetime import datetime
from datetime import date
import re
import xlrd
from datetime import timedelta

con_evalbase = psycopg2.connect(database='examevaldb',  user='exam', password='123456', host= 'localhost')

cursor = con_evalbase.cursor()

today = datetime.now()
###enter in mst_students

#file_obj = open('PMRDFfinal.csv', 'rt')
#file_obj = open('February/03_02_2016/Fellows_details.csv', 'rt')
#file_reader = csv.reader(file_obj,delimiter="|")

workbook_obj=xlrd.open_workbook('Format_Students.xls')
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
	regis_newline = sheet_obj.cell(row,20).value.replace('\n','')
	regis_val= regis_newline.replace("'","''")
	regis = re.sub(' +',' ',regis_val).strip()
	#print regis

	#fname, mname,lname
	fname_newline = sheet_obj.cell(row,2).value.replace('\n','')
	fname_val= fname_newline.replace("'","''")
	fname = re.sub(' +',' ',fname_val).strip()
	mname_newline = sheet_obj.cell(row,3).value.replace('\n','')
	mname_val= mname_newline.replace("'","''")
	mname = re.sub(' +',' ',mname_val).strip()
	lname_newline = sheet_obj.cell(row,4).value.replace('\n','')
	lname_val= lname_newline.replace("'","''")
	lname = re.sub(' +',' ',lname_val).strip()
   
	# DOB
	#dob=sheet_obj.cell(row,5).value   
	#print dob
	
	#date_object = datetime.strptime(dob, '%y-%m-%d')
	xldate=sheet_obj.cell(row,5).value         #if not working with Upper Please use this one(this line and below line) For BA use this
   	dob = datetime(1899, 12, 30) + timedelta(days=xldate + 1462 * workbook_obj.datemode)
   	print dob


	#gender & Salutation
	gender_newline=sheet_obj.cell(row,6).value.replace('\n','')
	gender_val= gender_newline.replace("'","''")
	gender = re.sub(' +',' ',gender_val).strip()
	if gender == 'M'or gender=='Male':
	 	gender='Male'
		sal='Mr.'
	else:
		gender='Female'
		sal='Miss.'
	
	#campus	
	campus_newline = sheet_obj.cell(row,7).value.replace('\n','')
	campus_val= campus_newline.replace("'","''")
	campus = re.sub(' +',' ',campus_val).strip()
	#print campus
	query1="select campus_id from exams_mst_campus where campus_name = '%s'"%(campus)
	cursor.execute(query1)
	campusi=cursor.fetchall()
	campusid=campusi[0][0]
	#print campus

	# hostel
	hostel=sheet_obj.cell(row,8).value.strip()
	
	#category
	caterow_newline=sheet_obj.cell(row,9).value.replace('\n','')
	caterow_val= caterow_newline.replace("'","''")
	caterow = re.sub(' +',' ',caterow_val).strip()	
	if caterow=='GENERAL':
		cateval='GN'
	elif caterow == 'FN' :
		cateval='Foreign National'
	else:
		cateval=sheet_obj.cell(row,9).value.strip()
#	print caterow,cateval
	query1 = "select cate_id from exams_mst_categories where cate_name = '%s'"%(cateval)
	cursor.execute(query1)
	catelist=cursor.fetchall()# this list returns o/p as [(4,)]
	#print "These are the values of category list ..:",catelist
	cateid=catelist[0][0] # thus converted and stored in another variable and then used as 4
	
	#semester
	semid=1 # because the 2nd semester id in exams_mst_semesters is 2

	#Address
	query1 = "select coun_id from exams_mst_countries where coun_name = '%s'"%(sheet_obj.cell(row,11).value.strip())
	#print query1
	cursor.execute(query1)
	counlist=cursor.fetchall()
	counid=counlist[0][0]
	abc=sheet_obj.cell(row,12).value.strip()
	if abc=='Uttaranchal' :
		abc='Uttarakhand'
	query1 = "select state_id from exams_mst_state where state_name = '%s'"%(abc)
	cursor.execute(query1)
	statelist=cursor.fetchall()
	stateid=statelist[0][0]
	#print query1,statelist[0][0]
	#query1 = "select state_id from exams_mst_state where state_name = '%s'"%(abc)
	#cursor.execute(query1)
	#domlist=cursor.fetchall()
	domid=stateid #domlist[0][0]
	citi_newline = sheet_obj.cell(row,18).value.replace('\n','')
	citi_val= citi_newline.replace("'","''")
	citi = re.sub(' +',' ',citi_val).strip()
	#print citi
	query1="select citi_id from exams_mst_cities where citi_name='%s'"%(citi)
	cursor.execute(query1)
	citilist=cursor.fetchall()
	citid=citilist[0][0]
	#print citid,citi
	# tiss email
	#print "emaiiiiiiiii",sheet_obj.cell(row,14).value
	tissemid=sheet_obj.cell(row,14).value #.strip()
	#tissemid=tissemid+'@tiss.edu'
#        print tissemid
	# personal email
	personalemid=sheet_obj.cell(row,15).value.strip()
	
	# student mobile no
	studmobno=sheet_obj.cell(row,16).value
	mobile= int(studmobno)
	
	# student other contact no
	studcontno=sheet_obj.cell(row,17).value

	other_mo=int(studcontno)
	
	# address
	studadd=sheet_obj.cell(row,19).value.replace("'","''")
	#print studadd
	
	
	
	#pwd
	pwdtype=sheet_obj.cell(row,23).value
	if pwdtype=='':
		pwdtype='NA'
	query1="select pwdtype_id from exams_mst_pwdtype where pwdtype_name='%s'"%(pwdtype)
	cursor.execute(query1)
	pwdtp=cursor.fetchall()
	pwdtt=pwdtp[0][0]
	
	

	#program id
	#progid=sheet_obj.cell(row,21).value # in exams_mst_programs pk
	ampus_newline = sheet_obj.cell(row,21).value.replace('\n','')
	ampus_val= ampus_newline.replace("'","''")
	ampus = re.sub(' +',' ',ampus_val).strip()
	#print ampus
	
	query1="select prog_id from exams_mst_programs where prog_name='%s'"%(ampus)
	#print "aaaaaaaaaaaaaaaaaaaassssssssssss", query1
	cursor.execute(query1)
	program11=cursor.fetchall()
	progd=program11[0][0]
	#print progd,ampus


	""" #batch
	batchid=12 # because the year in exams_mst_academic_batches is 2014-2016
	if progd==46:
		batchid=20
	if progd in (70,77):
		batchid=22 """
        batchid=int(sheet_obj.cell(row,29).value)
	#program type id
	progtypeid=sheet_obj.cell(row,22).value # in mst_programme_type MA id is 1
	ptypeid = int(progtypeid)

	
	#pincode
	pincode=sheet_obj.cell(row,24).value
	pincode= int(pincode)
	#print pincode
	
	#parents Email
	paremail=sheet_obj.cell(row,25).value
	#print paremail
	
	parent_income=sheet_obj.cell(row,26).value
	'''aampus_newline = sheet_obj.cell(row,26).value.replace('\n','')
	aampus_val= aampus_newline.replace("'","''")
	parent_income = re.sub(' +',' ',aampus_val).strip()
	if parent_income == '6.51 lakhs & above':
		parent_income=652000
	if parent_income == '2.01-2.50 lakhs':
		parent_income=225000
	if parent_income == 'Less than 1 lakh':
		parent_income=90000
	if parent_income == '4.51-6.50 lakhs':
		parent_income=500000	
	if parent_income == '1.01-2.00 lakhs':
		parent_income=150000
	if parent_income == '2.51-4.50 lakhs':
		parent_income=275000'''
	#print len(parent_income)
	#print parent_income
	#parent_income=int(parent_income)
	#print parent_income
        goit=sheet_obj.cell(row,28).value
	#existing record check
	query1="select stud_id from exams_mst_students where stud_enrollment_number='%s'"%(enrollment_num)
	cursor.execute(query1)
	studexists=cursor.fetchall()
	#print fname

	# catgory

	if len(studexists)==0:
		query1_ins = "insert into exams_mst_students(stud_enrollment_number,stud_regis_number,stud_salutation,stud_fname,stud_mname,stud_lname,stud_dob,stud_gender,stud_campus_id,stud_prog_id,stud_prog_type_id,stud_acba_id,stud_sem_id,stud_pwdtype_id,stud_hostel,stud_admission_cate_id,stud_status,stud_coun_id,stud_state_id,stud_citi_id,stud_domicile_id,stud_tiss_email,stud_other_email,stud_mobile_number,stud_other_number,stud_permanentadd,stud_pincode,stud_parent_email,stud_parent_number,stud_parent_income,stud_creator_empl_id,stud_created_datetime,stud_last_modified_empl_id,stud_last_modified_datetime,stud_history,stud_enabled,stud_deleted,stud_goi,stud_fee_rem_bal_show) values('%s','%s','%s','%s','%s','%s','%s','%s', '%s','%s','%s','%s','%s','%s','','%s','OnRole','%s','%s','%s','%s','%s','%s','%s',null,'%s','%s','%s','%s','%s',1,'%s',1,'%s','','Y','N','%s','Y') " %(enrollment_num,regis,sal,fname,mname,lname,dob,gender,campusid,progd,ptypeid,batchid,semid,pwdtt,  cateid,counid,stateid,citid,domid,tissemid,personalemid,mobile,studadd,pincode,paremail,other_mo,parent_income,today,today,goit)  
		cursor.execute(query1_ins)
                print 'Counter:-',row
	else:
		#print "%s student name already exists" %(fname)
                query_upd="update exams_mst_students set stud_tiss_email='%s' where stud_enrollment_number='%s' "%(tissemid,enrollment_num)
                cursor.execute(query_upd) 
                
cursor.close()
con_evalbase.commit()
con_evalbase.close()

#Note:hostel is No for all
#other_mo should be parents mobile number
#other mobile number should be something(25)


