# update category and 
import psycopg2
from datetime import datetime

import xlrd
con_evalbase = psycopg2.connect(database='examevaldb', user='exam', password='123456', host='localhost' )
cursor = con_evalbase.cursor()
	
today = datetime.now()

workbook_obj=xlrd.open_workbook('GOI_details.xls')
sheet_obj=workbook_obj.sheet_by_name('Sheet1')
counter=updcou=0
exc_counter=0
for row in range(1,sheet_obj.nrows):
	regisno=sheet_obj.cell(row,0).value.strip()
	enrollno = sheet_obj.cell(row,1).value.strip()
	category = sheet_obj.cell(row,2).value.strip()
	otheremail = sheet_obj.cell(row,3).value.strip()
	#goi = 'Y'
	#print enrollno	
	studque=''
	try:
		studque="select stud_id from exams_mst_students where stud_deleted='N' and (stud_enrollment_number='%s' or (stud_other_email ='%s' or stud_parent_email='%s'));"%(enrollno,otheremail,otheremail)
		#print studque
		cursor.execute(studque)
		studq=cursor.fetchall()
		studid=studq[0][0]

		cateque="select cate_id from exams_mst_categories where cate_name='%s';"%(category)
		cursor.execute(cateque)
		cateq=cursor.fetchall()
		cateid=cateq[0][0]

		#print cateid	

		#print studque

		counter=counter+1
	
		if len(studq)!=0:
			update_que="update exams_mst_students set stud_goi='Y', stud_admission_cate_id=%d where stud_id=%d and stud_deleted='N';"%(int(cateid),int(studid))

			cursor.execute(update_que)
			updcou=updcou+1
			print update_que
			
		else:
			print "Student details does not exist ",(enrollno) 
	except:
		exc_counter=exc_counter+1
		print row,studque


	

cursor.close()
con_evalbase.commit()
con_evalbase.close()
print 'Total Considered : ', counter,' Updated Counter : ',updcou

print exc_counter,'exception count'
