import psycopg2
from datetime import datetime
import re
import xlrd

con_evalbase = psycopg2.connect(database='examevaldb',  user='exam',password='123456',host='localhost')

cursor_obj = con_evalbase.cursor()
today = datetime.now()

###enter in mst_courses
#February/03_02_2016/Task3_Conversion_Import/
files="co_1820.xls"
workbook_obj=xlrd.open_workbook(files)
sheet_obj=workbook_obj.sheet_by_name('Sheet1')

courselist = []
coursenamelist = []
courseexists = []
stucourseexists = []

#code for reading single row from excel
for row in range(1,sheet_obj.nrows):
	# strip() removes the unwanted data ie. left and right spaces 
	seccc_newln= sheet_obj.cell(row,3).value.replace('\n','')
	seccode_val= seccc_newln.replace("'","''")
	sec_course_code = re.sub(' +',' ',seccode_val).strip()
	
	#\n replaced by ''
	course_newln = sheet_obj.cell(row,4).value.replace('\n','')
	#single quote replaced for database by '' this helps execute query
	coursename_val= course_newln.replace("'","''")
	#re.sub(pattern,replace,string,max) and returns modified string
	#also,here it is used because if 2 spaces occur in cour_name from (in between the course_name) excel it would remove two spaces and put single space in words and strip will remove the forward and backward space  
	course_name = re.sub(' +',' ',coursename_val).strip()
	
	if course_name not in courselist:
		courselist.append([course_name,sec_course_code]) 

#counter for exams_mst_courses
#count = 873
query111="select cour_code from exams_mst_courses where cour_id in (select max(cour_id) from exams_mst_courses)"
cursor_obj.execute(query111)
courseobj=cursor_obj.fetchall()
maxval=0
maxabsval=''
for vals in courseobj:
	#vala=list(vals)
	#print vals[0]
	absval=re.findall(r'[^\W\d_]+|\d+',vals[0])
	if absval[1]>maxval:
		maxval=absval[1]
		maxval=int(maxval)
		maxval=maxval+1
		maxabsval=absval[0]+str(maxval)
		#print maxabsval
count=maxval	
ind=0
#code for checking and inserting course details 
for newcvalue in courselist:
	query1 = "select cour_name from exams_mst_courses where cour_name = '%s' and cour_deleted='N'" % newcvalue[0]
	cursor_obj.execute(query1)
	courseexists=cursor_obj.fetchall()
	new_coursecode='SUB'+str(count)
	#print newcvalue[1]
	if len(courseexists)==0 :
		query1_ins = "insert into exams_mst_courses(cour_code,cour_name,cour_enabled,cour_deleted,cour_creator_empl_id,cour_created_datetime,cour_last_modified_empl_id,cour_last_modified_datetime,cour_history,cour_code_sec) values('%s','%s','Y','N',238,'%s',238,'%s','','%s') " %(new_coursecode,newcvalue[0],today,today,newcvalue[1])  
		count = count + 1
		print new_coursecode,newcvalue[0]	
		cursor_obj.execute(query1_ins)
		ind=ind+1
print 'Final no. of courses'
print ind		
con_evalbase.commit()

###enter in rel_campus_prog

#insertion in another table through same csv and read twice because file object state is changed

# files="/home/aakash/Desktop/SHS_16_III.xls"
# workbook_obj=xlrd.open_workbook(files)
# sheet_obj=workbook_obj.sheet_by_name('Sheet1')

courlist = []
proglist = []
campuslist=[]
campprogexists=[]

rcpc=0

for row in range(1,sheet_obj.nrows):
	campuscol_newln =sheet_obj.cell(row,0).value.replace('\n','')
	campusname_val= campuscol_newln.replace("'","''")
	campusname = re.sub(' +',' ',campusname_val).strip()
	#print campusname
	schoolcol_newln =sheet_obj.cell(row,1).value.replace('\n','')
	schoolname_val= schoolcol_newln.replace("'","''")
	schoolname = re.sub(' +',' ',schoolname_val).strip()
	
	progcol_newln =sheet_obj.cell(row,2).value.replace('\n','')
	progname_val= progcol_newln.replace("'","''")
	progname = re.sub(' +',' ',progname_val).strip()
	
	course_newln = sheet_obj.cell(row,4).value.replace('\n','')
	coursename_val= course_newln.replace("'","''") 
	coursename = re.sub(' +',' ',coursename_val).strip()
	
	query1="select campus_id from exams_mst_campus where campus_name='%s' and campus_deleted='N'"%(campusname)
	cursor_obj.execute(query1)
	campuslist=cursor_obj.fetchall()
	campusid=campuslist[0][0]

	query1="select sch_id from exams_mst_schools where sch_name='%s' and sch_deleted='N'"%(schoolname)
	cursor_obj.execute(query1)
	schoollist=cursor_obj.fetchall()
	schoolid=schoollist[0][0]
	
	query1="select prog_id from exams_mst_programs where prog_name='%s' and prog_deleted='N'"%(progname)
	cursor_obj.execute(query1)
	proglist=cursor_obj.fetchall()
	progid=proglist[0][0]

	query1="select cour_id from exams_mst_courses where cour_name='%s' and cour_deleted='N'"%(coursename)
	cursor_obj.execute(query1)
	courlist=cursor_obj.fetchall()
	courid=courlist[0][0]

	query1 = "select rcp_id from exams_rel_campus_school_programes_courses where rcp_campus_id = '%s' and rcp_school_id = '%s' and rcp_prog_id='%s' and rcp_cour_id='%s' and rcp_deleted='N'"%(campusid,schoolid,progid,courid)
	cursor_obj.execute(query1)
	campprogexists=cursor_obj.fetchall()
	
	if len(campprogexists)==0 :
		query1_ins = "insert into exams_rel_campus_school_programes_courses(rcp_campus_id,rcp_school_id,rcp_prog_id,rcp_cour_id,rcp_enabled,rcp_deleted,rcp_creator_empl_id,rcp_created_datetime,rcp_last_modified_empl_id,rcp_last_modified_datetime,rcp_history) values('%s','%s','%s','%s','Y','N',238,'%s',238,'%s','') " %(campusid,schoolid,progid,courid,today,today)  
		cursor_obj.execute(query1_ins)
		rcpc=rcpc+1
print 'Final no. of rcps'
print rcpc

cursor_obj.close()		
con_evalbase.commit()
con_evalbase.close()

if rcpc!=0:
	print 'Courses Successfully Mapped in RCP!'


