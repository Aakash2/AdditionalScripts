import psycopg2
from datetime import datetime
import re
import xlrd

con_evalbase = psycopg2.connect(database='examevaldb',  user='exam', password='123456',host='localhost')
#host='192.168.194.37')
cursor_obj = con_evalbase.cursor()
today = datetime.now()

###enter in mst_courses
#February/03_02_2016/Task3_Conversion_Import/
files="AlreadyMarksEntrered2.xls"
workbook_obj=xlrd.open_workbook(files)
sheet_obj=workbook_obj.sheet_by_name('AlreadyMarksEntrered2')

courselist = []
cnt=0


def calculate_letter_grade(batchid,gpa1):
    letgrade='Z'
     
    if batchid < 9:
	gpa_grade_mapping_old = {'0.0-0.0':'F','0.1-1.0':'D','1.1-2.0':'C-','2.1-3.0':'C','3.1-4.0':'C+','4.1-5.0':'B-','5.1-6.0':'B','6.1-7.0':'B+','7.1-8.0':'A-','8.1-9.0':'A','9.1-10.0':'A+'}
	for gparange in gpa_grade_mapping_old:
		try:
			rangeval=gparange.split("-")
			#minval=float(rangeval[0])
			#maxval=float(rangeval[1])
			#if minval <= gpa <= maxval:
			if float(rangeval[0])<=float(gpa1)<=float(rangeval[1]):
				letgrade=gpa_grade_mapping_old[gparange]
				return letgrade
		except:
			print ''
			
			
    else :
    	gpa_grade_mapping_new = {'0.0-0.9':'F','1.0-1.9':'E','2.0-2.9':'D','3.0-3.9':'C-','4.0-4.9':'C+','5.0-5.9':'B-','6.0-6.9':'B+','7.0-7.9':'A-','8.0-8.9':'A+','9.0-10.0':'O'}
	for gparange in gpa_grade_mapping_new:
		try:
			rangeval=gparange.split("-")
			#minval=float(rangeval[0])
			#maxval=float(rangeval[1])
			#if minval <= gpa <= maxval:
			if float(rangeval[0])<=float(gpa1)<=float(rangeval[1]):
				letgrade=gpa_grade_mapping_new[gparange]	
				return letgrade
		except:
			print ''







for row in range(1,sheet_obj.nrows):
	# strip() removes the unwanted data ie. left and right spaces 
	'''	scseid_newln= sheet_obj.cell(row,5).value.replace('\n','')
	scseid_val= scseid_newln.replace("'","''")
	scseid = re.sub(' +',' ',scseid_val).strip()'''
	
	scseid= int (sheet_obj.cell(row,0).value)
	
	gpaactual= sheet_obj.cell(row,1).value#.replace('\n','')
	#gpa_val= gpa_newln.replace("'","''")
	#gpaactual = re.sub(' +',' ',gpa_val).strip()
	
	
	batchid=10
	lettergrade=calculate_letter_grade(batchid,gpaactual)
	print scseid,gpaactual,lettergrade
	

	query1="select scse_id from exams_rel_students_courses_semesters where scse_id='%d' and scse_deleted='N'"%(scseid)
	cursor_obj.execute(query1)
	scsedata=cursor_obj.fetchall()
	
	
	if len(scsedata)!=0 :
		query1_ins = "update exams_rel_students_courses_semesters set scse_letter_grade='%s', scse_last_modified_datetime='%s' where scse_id='%d'" %(lettergrade,today,scseid)
		cursor_obj.execute(query1_ins)
		cnt=cnt+1
print 'Updations...:',cnt


cursor_obj.close()		
con_evalbase.commit()
con_evalbase.close()


