import psycopg2
from datetime import datetime
import re
import xlrd

con_evalbase = psycopg2.connect(database='examevaldb',  user='exam',password='123456',host='localhost')

cursor_obj = con_evalbase.cursor()
today = datetime.now()

updcnt=0
inaccnt=0
files="minority.xls"
workbook_obj=xlrd.open_workbook(files)
sheet_obj=workbook_obj.sheet_by_name('Sheet1')
for row in range(1,sheet_obj.nrows):
	#other email
	enrolcol_newln =sheet_obj.cell(row,0).value.replace('\n','')
	enrolname_val= enrolcol_newln.replace("'","''")
	o_email = re.sub(' +',' ',enrolname_val).strip()
        
	minoritycol_newln =sheet_obj.cell(row,1).value.replace('\n','')
	minorityname_val= minoritycol_newln.replace("'","''")
	minority = re.sub(' +',' ',minorityname_val).strip()
        query1="select minority_id from exams_mst_minority where minority_name='%s' "%(minority)
	cursor_obj.execute(query1)
	minoritylist=cursor_obj.fetchall()
	minorityid=minoritylist[0][0]
        
	query2="select stud_id from exams_mst_students where stud_other_email='%s' "%(o_email)
	cursor_obj.execute(query2)
	studlist=cursor_obj.fetchall()
	
	if len(studlist)!=0:
		
		query1_upd = "update exams_mst_students set stud_minority_id=%d where stud_other_email='%s'" %(minorityid,o_email)  
		cursor_obj.execute(query1_upd)
                updcnt=updcnt+1
	else:
                inaccnt=inaccnt+1
                
cursor_obj.close()		
con_evalbase.commit()
con_evalbase.close()
print 'Updated Count:',updcnt,'\nDetails Not Found:',inaccnt


