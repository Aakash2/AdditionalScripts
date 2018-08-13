import psycopg2
from datetime import datetime
from datetime import date
import re
import xlrd
import json
from datetime import timedelta

con_evalbase = psycopg2.connect(database='examevaldb',  user='exam', password='123456', host='localhost' )#192.168.194.37
cursor = con_evalbase.cursor()

today = datetime.now()
###enter in mst_students

#file_obj = open('PMRDFfinal.csv', 'rt')
#file_obj = open('February/03_02_2016/Fellows_details.csv', 'rt')
#file_reader = csv.reader(file_obj,delimiter="|")

workbook_obj=xlrd.open_workbook('fee_structure_map.xls')
############################## Please Check the batch_id#######################333
sheet_obj=workbook_obj.sheet_by_name('Sheet1')


class mydict(dict):
        def __str__(self):
            return json.dumps(self)
#used for incrementing the enrollment and registration number
for row in range(1,sheet_obj.nrows):
	
	enrollno=sheet_obj.cell(row,1).value.replace('\n','')			#row[2].replace(' ','')
	enrol_num=enrollno.replace("'","''")
	enrollment_num=re.sub(' +',' ',enrol_num).strip()


	query1="select stud_id,stud_prog_id,stud_acba_id,stud_campus_id,stud_sem_id,stud_goi from exams_mst_students where stud_enrollment_number='%s'"%(enrollment_num)
	cursor.execute(query1)
	studexists=cursor.fetchall()
	stud_id=studexists[0][0]
	stud_prog_id=studexists[0][1]
	stud_acba_id=studexists[0][2]
	stud_campus_id=studexists[0][3]
	stud_sem_id=studexists[0][4]	
	stud_goi=studexists[0][5]
	
	if stud_goi=='Y':
		stud_goi=2
	else:
		stud_goi=1


	query_fest="select fest_id from fees_mst_fees_structures where fest_acye_id='%s' and fest_seme_id='%s' and fest_deleted='%s'"%(stud_acba_id,stud_sem_id,'N')
	cursor.execute(query_fest)
	resu_fest=cursor.fetchall()
	


	for a in resu_fest:
		fest_id=a[0]
	

		query_fspr="select fspr_fest_id from fees_rel_fee_structures_programs where fspr_loca_id='%s' and fspr_prog_id='%s' and fspr_fest_id='%s' and fspr_fee_cate='%s'"%(stud_campus_id,stud_prog_id,fest_id,stud_goi)
		cursor.execute(query_fspr)
		resu_fspr=cursor.fetchall()
		print "ressssssss",resu_fspr
		
		resu_fspr_len=len(resu_fspr)
		
		if resu_fspr_len == 1:
			fest_id_final=resu_fspr[0][0]
			print "resu_fspr_lenresu_fspr_len",fest_id_final


	json_dict_head={}
	fehead_obj="select fsfh_fehe_id,fsfh_fee_amount from fees_rel_fee_structures_fee_heads where fsfh_fest_id = '%s' and fsfh_deleted='%s'"%(fest_id_final,'N')
	cursor.execute(fehead_obj)
	amou_fetch=cursor.fetchall()
	
	
	
	#a=rel_fee_structures_fee_heads.objects.filter(Q(fsfh_fest_id=fest_id_final)&Q(fsfh_deleted='N'))
	#print "lenthh", len(fehead_obj)
	for b in amou_fetch:
		print b[0],b[1]
		fsfh_fehe_id=b[0]
		fsfh_fee_amount = str(b[1])
		

		fee_fspr_obj="select fehe_name,fehe_id from fees_mst_fee_heads where fehe_id='%s' and fehe_deleted='%s'"%(fsfh_fehe_id,'N')
		cursor.execute(fee_fspr_obj)
		head_fetch=cursor.fetchall()
		#fehead_name_obj=mst_fee_heads.objects.filter(Q(fehe_id=fsfh_fehe_id)&Q(fehe_deleted='N'))
		for va in head_fetch:
			fehead_name=va[0]
			feheadid=va[1]
			json_dict_head.update({feheadid:fsfh_fee_amount})
			json_dict_head=mydict(json_dict_head)


	print "ddddddddddd",json_dict_head
	select_query="select "
	query_ins="insert into fees_rel_stud_fee_decription(stud_fee_stud_id,stud_fee_fest_id,stud_fee_description,stud_fee_isconfirm,stud_fee_enabled,stud_fee_deleted,stud_fee_creator_empl_id,stud_fee_created_datetime,stud_fee_last_modifier_empl_id,stud_fee_last_modified_datetime)VALUES('%s','%s','%s','%s','%s','%s','%s','%s', '%s','%s')"%(stud_id,fest_id_final,json_dict_head,'N','Y','N',239,today,239,today)
	cursor.execute(query_ins)
	

cursor.close()
con_evalbase.commit()
con_evalbase.close()
	




