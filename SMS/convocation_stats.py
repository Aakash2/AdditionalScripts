import django
import psycopg2
import sys
import os
sys.path.append('/var/Educational_Assessment/')
os.environ['DJANGO_SETTINGS_MODULE'] = 'Educational_Assessment.settings'
django.setup()
from django.conf import settings
from django import http
from django.db import connection
from django.db.models import Q
from django.contrib.auth.decorators import login_required
from django.http import HttpResponse
from django.shortcuts import render
from django.forms.models import modelformset_factory
from django.template import RequestContext
from tcourse_evaluation.models import rel_stu_courses
from exams.models import rel_courses_programes_semesters,mst_courses,mst_programs,rel_campus_prog_batch_year_sems, rel_students_courses_semesters,mst_students,mst_semesters,mst_academic_batches,mst_campus,convocation_details
from decimal import Decimal
from operator import itemgetter
import math
from collections import OrderedDict
from exams.views.commonfun import calculate_letter_grade
from exams.views.summary_sheet_nov17 import display_ss_nov17,getData_nov17

########################################################################################################################################################################################################
# Queries Function called from summary_sheet211 returns 2 types of outputs i.e final gpa and course details
########################################################################################################################################################################################################
def getData(ui_semeid,campid,progid,batchid,student_id_list,ctype,summary_format,semno):
   # Variables initialized
   cur = connection.cursor()
   getdval={}   
   cour_code_name=[]
   semes_id=0
   stud_marks=[]
   cour_code_name=[]
   course_type_val='' 
   course_dicti={}
   # Variables initialized


   #semno variable is used for number of semesters ( in 4th sem we include cbcs marks also)
   #if ui_semeid==semno:

   # condition for passing values based on semesters. For odd semesters front end coursetype data to be generated else all values filter
   
   
	
   if summary_format > 1:
	course_type_val="'S1','Re','R','I','S2','RC'"
	rc_query="select * from exams_rel_students_courses_semesters where scse_rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_deleted='N' and rscs_batch_id=%s and rscs_stu_id in %s ) and scse_deleted='N' and scse_course_attempt='RC' and scse_isconfirm='N' "%(batchid,student_id_list)
   	cur.execute(rc_query)
   	rc_query_op=cur.fetchall()
	if len(rc_query_op) > 1:
		course_type_val="'S1','Re','R','I','S2'"
   		#print "shrwerjwerwjerwejrwejrwejrwejrjwer", len(rc_query_op)
   else:
	course_type_val= "'"+ctype+"'"

   # below query gives values in totals, eg. if 1st sem : Ist sem credits, Grade Point Average, Enrollment Number but data of ALL the Students   
   query_stdentwise_mark_records="select rscs_stu_id ,stud_enrollment_number,stud_fname,stud_mname,stud_lname,sum(scse_gpa_actual*cpse_credits) ,sum(cpse_credits),round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),1) from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students where scse_deleted='N' and scse_rscs_id=rscs_id and rscs_stu_id in %s and rscs_cpse_id=cpse_id and scse_cpse_id=rscs_cpse_id and ((scse_gpa_actual is not null and scse_isabsent='N') or(scse_gpa_actual is null and scse_isabsent='Y'))and scse_course_type <> 'AU' and scse_course_type <>'EC' and scse_course_type <>'NC' and scse_course_type <>'C' and rscs_stu_id=stud_id and cast(rscs_sem_id as text) in (select regexp_split_to_table(cpby_sem%s,',')  from exams_rel_campus_prog_batch_year_sems where cpby_camp_id_id=%s and cpby_prog_id_id=%s and cpby_acba_id_id=%s )and scse_deleted='N' and(scse_rscs_id,scse_id ) in (select scse_rscs_id , first_value(scse_id) over (partition by scse_rscs_id, scse_cpse_id order by case when scse_course_attempt in (%s) then 1 else 2 end ,scse_id desc) from exams_rel_students_courses_semesters where scse_deleted='N')and rscs_batch_id=stud_acba_id and scse_isconfirm='Y' and scse_rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id in %s and scse_rscs_id in (select scse_rscs_id from exams_rel_students_courses_semesters where scse_deleted='N'))group by rscs_stu_id ,stud_enrollment_number,stud_fname,stud_mname,stud_lname order by rscs_stu_id"%(student_id_list,str(ui_semeid),str(campid),str(progid),str(batchid),course_type_val,student_id_list)
   #print "finallllllllllllllll",query_stdentwise_mark_records
   cur.execute(query_stdentwise_mark_records)
   studentwise_mark_records=cur.fetchall()
   #print "ooooooooooooooooooooooooooooooooooooooooooo",query_stdentwise_mark_records
   # below query gives values in totals, eg. if 1st sem : Ist sem credits, Grade Point Average, Enrollment Number but data of ALL the Students    
 
   # This gives us the marks, credits as well as total gp
   query_mark="select stud_id,cour_code,scse_gpa_actual,scse_letter_grade,cpse_credits,scse_course_result,scse_course_attempt,scse_course_type,scse_semester_attempt,cour_name,stud_enrollment_number,rscs_id from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students,exams_mst_courses where scse_deleted='N' and scse_rscs_id=rscs_id and rscs_stu_id in %s and rscs_cpse_id=cpse_id and scse_cpse_id=rscs_cpse_id and cour_id=rscs_course_id and rscs_stu_id=stud_id and cast(rscs_sem_id as text) in (select regexp_split_to_table(cpby_sem%s,',')  from exams_rel_campus_prog_batch_year_sems  where cpby_camp_id_id=%s and cpby_prog_id_id=%s and cpby_acba_id_id=%s ) and scse_deleted='N' and(scse_rscs_id,scse_id ) in (select scse_rscs_id , first_value(scse_id) over (partition by scse_rscs_id, scse_cpse_id order by case when scse_course_attempt in (%s) then 1 else 2 end , scse_id desc) from exams_rel_students_courses_semesters where scse_deleted='N')and scse_isconfirm='Y' and rscs_batch_id=%s and scse_rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id in %s) and rscs_batch_id=stud_acba_id and scse_rscs_id in (select scse_rscs_id from exams_rel_students_courses_semesters where scse_deleted='N')group by rscs_stu_id ,stud_enrollment_number,stud_fname, stud_id,cour_code,scse_gpa_actual,scse_letter_grade,cpse_credits,scse_course_result, scse_course_attempt,scse_course_type,scse_semester_attempt,cour_name,stud_enrollment_number,rscs_id order by rscs_stu_id, scse_semester_attempt"%(student_id_list,str(ui_semeid),str(campid),str(progid),str(batchid),course_type_val,str(batchid),student_id_list)
   #print "all studentttttt",query_mark
   cur.execute(query_mark)
   l1 = cur.fetchall()
   #print "sfsdfmnjsmfsdmfsdfmfsdfsdmmsdfsdm",l1
   # format conversion of the query result 
   for vals in l1:   # This is for making the header of table
	if vals[1] not in course_dicti:
		if ui_semeid==vals[8]:
			course_dicti.update({vals[1]:[vals[4],vals[7],vals[9]]})
   
   for cour_id in l1:        #This is for the course code and course name table in html
	if ui_semeid==cour_id[8]:  #This will show  course[Particular sem ]
		cour_code=cour_id[1]
		cour_name=cour_id[9]
	   	if (cour_code,cour_name) not in cour_code_name:
			cour_code_name.append((cour_code,cour_name))
   
   getdval.update({'l1':l1,'query_op':studentwise_mark_records,'course_dicti':course_dicti,'cour_code_name':cour_code_name})
   # format conversion of the query result 

   return getdval
########################################################################################################################################################################################################
# Queries Function called from summary_sheet211 returns 2 types of outputs i.e final gpa and course details
########################################################################################################################################################################################################


########################################################################################################################################################################################################
# Display Function called from summary_sheet211 returns final dictionary
########################################################################################################################################################################################################
def display_ss(display_values,ui_semeid,batchid,campid,progid,student_string,ctype,summary_format,semno,cpbyobj):
   # variables initialized
   cur = connection.cursor()
   summary111=final_gp_dict={}
   impro_dict={}
   impro_list=[]
   disp_sem_list=[]
   student_gp_total={}
   students_credits={}
   prev_sem=0
   students_cbcs_credits={}
   pos=0
   fail_credit=0
   fail_course_list=[]
   sem_result='PP'
   # variables initialized

   query_output=display_values.get('query_op', None ) # we can call by taking name of dictionary[values in the dictionary]
   query_mark=display_values.get('l1', None )    # calling dictionary within dictionary by name
   all_stud_courses=display_values['course_dicti']
   #print "fsdfsdfsdfsfffff", query_mark
   
   ######-----------#######---------- Start of "query_mark" For Loop to search all students all courses appeared for and forming their list ------------#######--------------########
   
   #######################################  Finding 1st,2nd,3rd,4th sem (credits and GP) seperately   ################################
   

   for cour_creditt in query_mark:
	student_enroll=cour_creditt[10]
	stud_sem=int(cour_creditt[8])
	stud_credit=cour_creditt[4]
	course_type=cour_creditt[7]
	student_gpa_actual=cour_creditt[2]
	cour_code=cour_creditt[1]
	scse_course_attempt=cour_creditt[6]
	scse_course_result=cour_creditt[5]
	scse_rscs=cour_creditt[11]
	
	
	########### it takes regular marks if regular marks are greater than Impro or Revaluation marks ##############
	if scse_course_attempt in ('I','R'):
		impro_query_2nd="select max(scse_gpa_actual) from exams_rel_students_courses_semesters where scse_rscs_id ='%s' and scse_deleted='N'"%(scse_rscs)
		cur.execute(impro_query_2nd)
		impro_2nd=cur.fetchall()
		student_gpa_actual=impro_2nd[0][0]
	###############################################################################################################

	################################# If we are generating second sem regular and improvement marks are there then it should consier regular(2nd sem)####	
	if scse_course_attempt in ('Re','I','R','S1','S2') and ctype=='Re' and stud_sem==int(ui_semeid):
		impro_query_3nd="select scse_gpa_actual from exams_rel_students_courses_semesters where scse_rscs_id ='%s' and scse_deleted='N' and scse_course_attempt ='Re'"%(scse_rscs)
		cur.execute(impro_query_3nd)
		impro_3nd=cur.fetchall()
		student_gpa_actual=impro_3nd[0][0]
	####################################################################################################################
	################################# If we are generating second sem Summplemntry 1 and S2 marks are there then it should consier S1 where available otherwise RE, R, I (2nd sem)####
	if scse_course_attempt in ('Re','I','R','S1','S2') and ctype=='S1' and stud_sem==int(ui_semeid):
		impro_query_3nd="select CASE WHEN EXISTS (SELECT scse_gpa_actual FROM exams_rel_students_courses_semesters WHERE scse_course_attempt='S1' AND scse_rscs_id ='%s' AND scse_deleted='N') THEN (SELECT scse_gpa_actual FROM exams_rel_students_courses_semesters WHERE scse_course_attempt='S1' AND scse_rscs_id ='%s' AND scse_deleted='N') WHEN EXISTS (SELECT scse_gpa_actual FROM exams_rel_students_courses_semesters WHERE scse_course_attempt in('I','R') AND scse_rscs_id ='%s' AND scse_deleted='N') THEN (SELECT scse_gpa_actual FROM exams_rel_students_courses_semesters WHERE scse_course_attempt in('I','R') AND scse_rscs_id ='%s' AND scse_deleted='N') ELSE (SELECT scse_gpa_actual FROM exams_rel_students_courses_semesters WHERE scse_course_attempt in ('Re') AND scse_rscs_id ='%s' AND scse_deleted='N') END from exams_rel_students_courses_semesters where scse_rscs_id ='%s' and scse_deleted='N'"%(scse_rscs,scse_rscs,scse_rscs,scse_rscs,scse_rscs,scse_rscs)
		#print "impro_query_3nd",impro_query_3nd
		cur.execute(impro_query_3nd)
		impro_3nd=cur.fetchall()
		student_gpa_actual=impro_3nd[0][0]
	######################################################################################################################################################
	total_gp = ''	
	#repeat_cour_obj=rel_students_courses_semesters.objects.filter(Q(scse_rscs_id=scse_rscs)&Q(scse_deleted='N'))	
	#for a in repeat_cour_obj:
		#if a.scse_course_attempt=='RC' and ctype!='RC' and stud_sem==ui_semeid:
			#student_gpa_actual=0
	
	if student_gpa_actual==None:
		student_gpa_actual=0
		total_gp=(student_gpa_actual*stud_credit)
	if student_gpa_actual != None:
		total_gp=(student_gpa_actual*stud_credit)
	if student_gpa_actual == 0.0:	
		total_gp=(student_gpa_actual*stud_credit)
	#### For 4th semester, we need to calculate cbcs marks also#### 
	cour_typee_list=['C','AU','EC','NC']
        if (ui_semeid==semno or (batchid=='10' and ui_semeid=='2')): 
		cour_typee_list.remove('C')
	####### above condition is used for properly calculating cbcs marks and if 'c' is in cour_type_list, it will exclude cbcs courses #################
	if course_type not in cour_typee_list:	
		if student_enroll not in students_credits:
		   students_credits[student_enroll]=[]
		if student_enroll not in student_gp_total:
		   student_gp_total[student_enroll]=[]

		if student_enroll not in students_cbcs_credits:
		   students_cbcs_credits[student_enroll]=0
		if course_type=='C' and student_gpa_actual>=4:
			if students_cbcs_credits[student_enroll]==0:
				students_cbcs_credits[student_enroll] = stud_credit
                        else:
				students_cbcs_credits[student_enroll] = students_cbcs_credits[student_enroll] + stud_credit
		
		if stud_sem != prev_sem:
			students_credits[student_enroll].append(stud_credit)
			student_gp_total[student_enroll].append(total_gp)
                        prev_sem= stud_sem
			#print "credittttttsssssssssssssssssss",stu
                        if len(students_credits[student_enroll]) == 1:
				pos = 0
			else:
				pos = pos + 1
			############# Using for header(Total Gp Sem1, sem2)##############
			if stud_sem not in disp_sem_list:
				disp_sem_list.append(stud_sem)
			##################################################################
		else:
			if len(students_credits[student_enroll])==0:
				students_credits[student_enroll].append(stud_credit)
				student_gp_total[student_enroll].append(total_gp)
			else :
				students_credits[student_enroll][pos] = students_credits[student_enroll][pos] + stud_credit
				student_gp_total[student_enroll][pos] = student_gp_total[student_enroll][pos] + total_gp
		
				#print "adadadadadadadad",students_credits[student_enroll]
   ######-----------#######---------- End of "query_mark" For Loop to search all students all courses appeared for and forming their list ------------#######--------------########
   query_mark="select stud_id,cour_code,scse_gpa_actual,scse_letter_grade,cpse_credits,scse_course_result,scse_course_attempt,scse_course_type,scse_semester_attempt,cour_name,stud_enrollment_number,rscs_id from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students,exams_mst_courses where scse_deleted='N' and scse_rscs_id=rscs_id and rscs_stu_id in %s and rscs_cpse_id=cpse_id and scse_cpse_id=rscs_cpse_id and cour_id=rscs_course_id and rscs_stu_id=stud_id and cast(rscs_sem_id as text) in (select regexp_split_to_table(cpby_sem%s,',')  from exams_rel_campus_prog_batch_year_sems  where cpby_camp_id_id=%s and cpby_prog_id_id=%s and cpby_acba_id_id=%s ) and scse_deleted='N' and(scse_rscs_id,scse_id ) in (select scse_rscs_id , first_value(scse_id) over (partition by scse_rscs_id, scse_cpse_id order by case when scse_course_attempt in ('%s') then 1 else 2 end , scse_id desc) from exams_rel_students_courses_semesters where scse_deleted='N')and scse_isconfirm='Y' and rscs_batch_id=%s and scse_rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id in %s) and scse_rscs_id in (select scse_rscs_id from exams_rel_students_courses_semesters where scse_deleted='N')group by rscs_stu_id ,stud_enrollment_number,stud_fname, stud_id,cour_code,scse_gpa_actual,scse_letter_grade,cpse_credits,scse_course_result, scse_course_attempt,scse_course_type,scse_semester_attempt,cour_name,stud_enrollment_number,rscs_id order by rscs_stu_id, scse_semester_attempt"%(student_string,str(ui_semeid),str(campid),str(progid),str(batchid),ctype,str(batchid),student_string)
   #print "qqqqqqqqqqqqqueryyyyyyyyyyyyyy", query_mark
   cur.execute(query_mark)
   query_mark = cur.fetchall()

   # &&&&&&&&&&&&&&&&&+++++++++++++++++&&&&&&&&&&&&&&& Start of "query_output" For Loop to search all students final marks &&&&&&&&&&&&&&&&&&+++++++++++++++++&&&&&&&&&&&&&&&&&
   for student_details in query_output:
	dict_stu_marks={}
	impro_output=0
	stud_id=student_details[0]
	enrollment_number=student_details[1]
	sname = student_details[2]+' '+student_details[3]+' '+student_details[4]
        if str(campid)!='2' and ui_semeid==semno:
                if len(convocation_details.objects.filter(Q(convocation_stud_id=stud_id)&Q(convocation_deleted='N')))!=0:
                        convobj= convocation_details.objects.get(Q(convocation_stud_id=stud_id)&Q(convocation_deleted='N'))
                        if convobj.convocation_full_name!=None :
                                sname= convobj.convocation_full_name.strip().title()
                        elif convobj.convocation_cor_name !=None:
                                sname=convobj.convocation_cor_name

	final_gpa=student_details[5]
	#print "gpaaaaaaaaaaaaaaaaa", final_gpa
	final_credit=student_details[6]
	final_grade=student_details[7]
	if final_grade == None:
		final_grade=0.0
	all_cour_marks={}
	last_result=''
	sem_result='PP'
	stu_courses=[]
	course_info11=[]
	# Current sem selected value data is searched
	for acmarks in query_mark:
		
		cpse_cred = acmarks[4]
		course_name_is= acmarks[9]
		course_type= acmarks[7]
		
		course_atte=acmarks[6]
		rscs_id=acmarks[11]
		gpa_marks=acmarks[2]

		############## To show the course attempt in summary sheet###########
		repeat_cour_obj=rel_students_courses_semesters.objects.filter(Q(scse_rscs_id=rscs_id)&Q(scse_deleted='N'))	
		#for a in repeat_cour_obj:
			#if a.scse_course_attempt=='RC' and ctype!='RC':
				#course_atte='RC'
				#print "heyyyyyyyyyyyyy in the loop",a.scse_course_attempt
				#gpa_marks=0
		cour_code_new=acmarks[1]
		stud_sem=int(acmarks[8])
		#print "scseeeeeeeeeeeeeee_Rscsssss", rscs_id
		if course_name_is not in course_info11:
			course_info11.append(course_name_is)
		if stud_id==acmarks[0] :
			
			########### This condition works if regular marks are greater than improvement or Revaluation######
			if course_atte in ('I','R'):
				impro_query="select max(scse_gpa_actual) from exams_rel_students_courses_semesters where scse_rscs_id ='%s' and scse_deleted='N'"%(rscs_id)
				cur.execute(impro_query)
				impro=cur.fetchall()
				gpa_marks=impro[0][0]
			################################# If we are generating second sem regular and improvement marks are already there then it should consier regular(2nd sem)####
			if course_atte in ('Re','I','R','S1','S2') and ctype=='Re':
				impro_query="select scse_gpa_actual from exams_rel_students_courses_semesters where scse_rscs_id ='%s' and scse_deleted='N' and scse_course_attempt='Re'"%(rscs_id)
				cur.execute(impro_query)
				impro=cur.fetchall()
				gpa_marks=impro[0][0]

			####for PP,FR, FS####
			if batchid in(1,3):
				#print "fksdfskfskfsdfksdfksdfksdf",batchid
				if ((gpa_marks < 5 and progid=='46') or gpa_marks < 4) and ui_semeid==acmarks[8] and course_type !='C' and course_type!='AU' and course_type != 'EC' and course_type != 'NC':
					fail_credit=fail_credit+cpse_cred
					fail_course_list.append(cour_code_new)
			else:
				if ((gpa_marks < 5 and progid=='46') or gpa_marks < 4) and ui_semeid==acmarks[8] and course_type!='AU' and course_type != 'EC' and course_type != 'NC':
					fail_credit=fail_credit+cpse_cred
					fail_course_list.append(cour_code_new)
			######################
			#print "gapaaaaaaaaaaaaakkkkkkkkkkkkkkkkkkkkkkaa", gpa_marks
			if gpa_marks != None:
				if course_type !='C' and course_type!='AU' and course_type != 'EC' and course_type != 'NC':
					abc=(gpa_marks*cpse_cred)
					impro_output=impro_output+abc
					impro_dict.update({acmarks[0]:{'impro_output':impro_output}})
					
			###########################################################################################
			#print "adddddddddddddddddddddddd",acmarks[1]
			if ui_semeid==acmarks[8]:
				dict_stu_marks.update({acmarks[1]:{'gpa':gpa_marks,'lettergrade':acmarks[3],'course_type':acmarks[7],'exam_attempt':acmarks[6]}})
		#print "courrrrrrrrrrrrrrrrrrseeeee", course_atte,final_gpa
		if course_atte in ('Re','R','I','S1') and ctype in ('Re','R','I','S1'):
			final_gpa=impro_output

	# ------ appending of values based on Absent data			
	studtcour=dict_stu_marks.keys()
	for courid in sorted(all_stud_courses):
		if courid in studtcour:
			a=dict_stu_marks[courid]
			#print "aaaaa",a
			if a['exam_attempt'] == 'Re' :
                		a['exam_attempt'] = ''
        		if a['exam_attempt'] == 'R':
                		a['exam_attempt'] = 'Re'

			if a['course_type']=='AU':
				stu_courses.append(['AU','-',a['course_type'],a['exam_attempt']])
			elif a['course_type']=='NC':
				stu_courses.append(['NC','-',a['course_type'],a['exam_attempt']])
			elif a['gpa']==None:
				stu_courses.append(['AB','-',a['course_type'],a['exam_attempt']])
			#elif a['exam_attempt']=='RC' and ctype!='RC':
				#stu_courses.append([a['gpa'],'-',a['course_type'],a['exam_attempt']]) 
			elif a['exam_attempt']=='RC':
				stu_courses.append([a['gpa'],a['lettergrade'],a['course_type'],a['exam_attempt']])
			else:	
				stu_courses.append([a['gpa'],a['lettergrade'],a['course_type'],a['exam_attempt']])
		else :
			stu_courses.append(['','-','-','-'])	
	# ------ appending of values based on Absent data


	################### Adding 1st,2nd,3rd,4th sem GP & Credit in one variable ###############################
	len_final_gp=len(student_gp_total[enrollment_number])
	finalll=0
	final_cre=0
	for i in range(len_final_gp):
		finalll=finalll+student_gp_total[enrollment_number][i]
		final_cre=final_cre+students_credits[enrollment_number][i]
	
	final_grade=(finalll/final_cre)
	query2="select round((%s/%s),1)"%(finalll,final_cre)
	cur.execute(query2)
   	calcu = cur.fetchall()
	final_grade=calcu[0][0]

	##############################################################################################################################
        ############################# calculate_letter_grade function is in commonfun.py ############################

	
	# Declaration of Result : PASS or FAIL
        fd_letter_grade=calculate_letter_grade(batchid,final_grade)
        cgpa_student=int(math.ceil(final_grade))
	
	
        if progid =='46':
           if cgpa_student > 5:
              last_result='P'
           else:
              last_result='F'
        elif cgpa_student > 4:
           last_result='P'
        else:
           last_result='F'
	
        for a in stu_courses:
	   #print "cbcs,",a[2]
	   cour_typee_list=['C','AU','EC','NC']
           if (ui_semeid==semno or (batchid=='10' and ui_semeid=='2')): 
		cour_typee_list.remove('C')
           if progid =='46':
              if (a[2] not in cour_typee_list and a[0] < 5.0) or (a[2] not in cour_typee_list and a[0]=='AB'):
                 final_grade='-'
                 last_result='F'
                 fd_letter_grade='F'
           else:
                 if ((a[2] not in cour_typee_list and a[0] < 4.0) or (a[2] not in cour_typee_list and a[0]=='AB') or (a[3]=='RC' and ctype!='RC')):
                    final_grade='-'
                    last_result='F'
                    fd_letter_grade='F'
	#print "lastttttttt", sem_result,enrollment_number
        if last_result =='F' :
		#print "kkkkkkkkkkkkkkkkkkkkkkkkkkk",sem_result,enrollment_number
		if fail_credit > 4 or len(fail_course_list) >=3 :
	 		sem_result='FR'
		else:
			sem_result='FS' 
         	#if batchid=='1':
		if ui_semeid==semno:
          	  	sem_result='Fail'
         	fail_course_list=[]
         	fail_credit=0
	elif last_result=='P':
                # write logic to check cbcs credits and mandatory credits
                flagres=''
                studobj=mst_students.objects.get(stud_id=stud_id)
		if studobj.stud_credit_check=='N':
		      #print "udaaaaaaaaaaaaaaaaaaaaaaaa",studobj.stud_credit_check
                      flagres='PASS'
		      
                elif studobj.stud_credit_check=='Y':
                   mandatorycredits=int(final_cre)-students_cbcs_credits[enrollment_number]
		   if ui_semeid==semno or (batchid=='10' and ui_semeid=='2'):
		           if  students_cbcs_credits[enrollment_number]>=cpbyobj[0][2] and mandatorycredits>=cpbyobj[0][1]:
		              flagres='PASS'

			      
		           else :
		              flagres='FAIL'
		              fail_course_list=[]
		              fail_credit=0
		   else:
			flagres='PASS'
                else:
                   sem_result='Unknown'
                if flagres=='FAIL':
		   #print "sssss",ui_semeid,
                   if ui_semeid==semno:
                      sem_result='Fail'
                   else:
                      sem_result='FS'
                   last_result='F'
                   final_grade='-'
                   fd_letter_grade='F'
                elif flagres=='PASS':
                   if ui_semeid==semno:
                      sem_result='Pass'
                   else :
                      sem_result='PP'
                else:
                   sem_result='Unknown'

	else :
		sem_result='Unknown'

	
	summary111.update({enrollment_number:{'enrollment_number':enrollment_number,'sname':sname,'final_cre_123':final_cre,'sem_result':sem_result,'disp_sem_list':disp_sem_list,'credits_final':final_credit,'total_gp':final_gpa,'gpa_f':final_grade,'marks':stu_courses,'letter_grade':fd_letter_grade,'last_result':last_result,'final_gp11':student_gp_total[enrollment_number],'finalll':finalll,'final_credi11':students_credits[enrollment_number]}})
   # &&&&&&&&&&&&&&&&&+++++++++++++++++&&&&&&&&&&&&&&& END of "query_output" For Loop to search all students final marks &&&&&&&&&&&&&&&&&&+++++++++++++++++&&&&&&&&&&&&&&&&&

   return summary111 
########################################################################################################################################################################################################
#Display Function called from summary_sheet211 returns final dictionary
########################################################################################################################################################################################################



########################################################################################################################################################################################################
# 'Main Function' called from the front end  
########################################################################################################################################################################################################

def summary_sheet2017(fake_request): ## to generate summary sheet through url /summary2 on button click on gc_form.htm
  # values from front end
  response = HttpResponse()
  cur = connection.cursor()
  #auth_user = request.user.username
  #auth_username = auth_user+'@tiss.edu'
  message = ''
  ctype = 'All'
  newctype = 'All'
  progid = fake_request['progid']
  semeid = fake_request['semeid']
  ui_semeid = fake_request['semeid']
  month = 'April'
  year = '2018'
  batchid = fake_request['batchid']
  campid = fake_request['campusid']
  campobj=mst_campus.objects.get(campus_id=campid)
  campusname=campobj.campus_name
  sumtype = ''
  summary_exam_type='All'
  # values from front end

  # query for checking the semesters data in data table for format
  summ="select regexp_split_to_table(cpby_sem%s,','),cpby_mandatory_credits,cpby_cbcs_credits,cpby_no_of_semester from exams_rel_campus_prog_batch_year_sems where cpby_camp_id_id=%s and cpby_prog_id_id=%s and cpby_acba_id_id=%s"%(str(ui_semeid),str(campid),str(progid),str(batchid))
  cur.execute(summ)
  sumarry_for=cur.fetchall()
  summary_format=len(sumarry_for)
  # query for checking the semesters data in data table for format
  #print summ
  '''no_of_sem_query="select cpby_no_of_semester from exams_rel_campus_prog_batch_year_sems where cpby_camp_id_id=%s and cpby_prog_id_id=%s and cpby_acba_id_id=%s"%(str(campid),str(progid),str(batchid))
  cur.execute(no_of_sem_query)
  semno=cur.fetchall()'''
  semno=sumarry_for[0][3]
  #print "semnoooooooo", semno

  program_details = mst_programs.objects.get(prog_id = progid)
  progname = program_details.prog_name
  batcobj=mst_academic_batches.objects.get(Q(acba_id=batchid) &Q(acba_deleted='N'))
  batch = batcobj.acba_name
  campus_instance=mst_campus.objects.get(campus_id = campid )
  semobj=mst_semesters.objects.get(Q(seme_id=semeid)&Q(seme_deleted='N'))
  semester = semobj.seme_name

  # variables initialized
  students_list = []
  cpselist=[]
  studid_list=[]
  rscs_cpse_list=[]
  rscs_id_list=[]
  scse_cpse_list=[]
  scse_rscs_list=[]
  stud_id_list=[]
  summary111={}
  display_values={}
  courses=[]
  courseinfo1=[]
  totalcredits = []
  disp_gp_list_final=[]
  disp_cre_list_final=[]
  m = []
  # variables initialized

  # verification if marks are confirmed for the enrolled students
  stud_obj=mst_students.objects.filter(Q(stud_prog_id=progid)&Q(stud_status='OnRole')&Q(stud_acba_id=batchid)&Q(stud_deleted='N')&Q(stud_campus_id=campid))
    
  for val in stud_obj:
      studid_list.append(val.stud_id)
  rscs_obj=rel_stu_courses.objects.filter(Q(rscs_stu_id__in=studid_list)&Q(rscs_deleted='N')&Q(rscs_sem_id=semeid))
  for rscsval in rscs_obj:
        if rscsval.rscs_cpse_id not in rscs_cpse_list:
            rscs_cpse_list.append(rscsval.rscs_cpse_id)
        rscs_id_list.append(rscsval.rscs_id)

  if ctype == 'All':
      scse_obj=rel_students_courses_semesters.objects.filter(Q(scse_cpse_id__in=rscs_cpse_list)&Q(scse_deleted='N')&Q(scse_semester_attempt=str(semeid))&Q(scse_rscs_id__in=rscs_id_list))
  else:	
      scse_obj=rel_students_courses_semesters.objects.filter(Q(scse_cpse_id__in=rscs_cpse_list)&Q(scse_deleted='N')&Q(scse_semester_attempt=str(semeid))&Q(scse_rscs_id__in=rscs_id_list)&Q(scse_course_attempt=ctype))

  #print "scccccccccccseeeeobj", len(scse_obj)
  #print "cpseseeeeeee",rscs_cpse_list
  for scseval in scse_obj:
        scse_cpse_list.append(scseval.scse_cpse_id)
        scse_rscs_list.append(scseval.scse_rscs_id)
 
  # total cpse's based on the students enrolled for in that batch and sem and campus
  cpseobj12=rel_courses_programes_semesters.objects.filter(Q(cpse_id__in=scse_cpse_list)&Q(cpse_acba_id=int(batchid))&Q(cpse_seme_id=int(semeid))&Q(cpse_deleted='N')&Q(cpse_campus_id=campid))
  allcpse_len=len(cpseobj12)
  
  # confirmed cpse's
  cpseobj=rel_courses_programes_semesters.objects.filter(Q(cpse_id__in=scse_cpse_list)&Q(cpse_acba_id=int(batchid))&Q(cpse_seme_id=int(semeid))&Q(cpse_deleted='N')&Q(cpse_isconfirm='Y')&Q(cpse_campus_id=campid))
  selcpse=len(cpseobj)
  #print "scseeeeeeeeeeee_cpse__",scse_cpse_list
  # checking if marks are confirmed for the enrolled students

  if selcpse!=allcpse_len: #### if all the courses are not confirmed in cpse table ##
	message="Please Confirm the Marks For All Subjects"
        return render(request,'html/gc_form11.html',{'campusname':campusname,'message':message,'campusid':campid,'progname':progname,'programid':progid,'semesterid':semeid,'sheet':ctype,'month':month,'year':year,'batchid':batchid})

  else: # if all the cpse's & scse's are confirmed then fetching the data of the students
	for c in cpseobj:	
		cpseid=c.cpse_id
		cpselist.append(cpseid)
	# checking if the marks for the given cpse'ids are entered
	if ctype=='All':
		rel_students_courses_semesters_objects=rel_students_courses_semesters.objects.filter(Q(scse_deleted='N')&Q(scse_cpse__in=cpselist)&Q(scse_isconfirm='Y')&Q(scse_semester_attempt=semeid)&Q(scse_rscs_id__in=scse_rscs_list))
	else:
		rel_students_courses_semesters_objects=rel_students_courses_semesters.objects.filter(Q(scse_deleted='N')&Q(scse_cpse__in=cpselist)&Q(scse_isconfirm='Y')&Q(scse_course_attempt=ctype)&Q(scse_rscs_id__in=scse_rscs_list))
	#print "leelllllllllllllll", cpselist
	# checking if the marks for the given cpse'ids are entered
  	if len(rel_students_courses_semesters_objects)!=0: 
	    #print "udaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
            # based on scse --> rscs --> student reference total onrole student list
	    for scse in rel_students_courses_semesters_objects:
		rscsid=scse.scse_rscs_id
		rscsobj=rel_stu_courses.objects.filter(Q(rscs_id=rscsid)&Q(rscs_deleted='N')&Q(rscs_cpse__in=cpselist))
		for r in rscsobj:
			studid=r.rscs_stu_id
			studobj=mst_students.objects.get(stud_id=studid)
			if studid not in students_list:
				studstatus=studobj.stud_status
				studsemnew=studobj.stud_sem_id
				if studstatus=='OnRole':
				   students_list.append(studid)
	    student_string = '('
	    for student in students_list:
		student_string = student_string + str(student) + ','
	    student_string = student_string[:-1]
	    student_string = student_string + ')'
            # based on scse --> rscs --> student reference total onrole student list

            if summary_format == 0:
		message= "Your Summary Sheet format is not entered in the System. Please contact Administrator."
		return render(request,'html/gc_form2017.htm',{'campusname':campusname,'message':message,'campusid':campid,'progname':progname,'programid':progid,'semesterid':semeid,'sheet':ctype,'month':month,'year':year,'batchid':batchid})

	    	
	    

	    if int(batchid) >= 10 :
		display_values.update(getData_nov17(ui_semeid,campid,progid,batchid,student_string,ctype,summary_format,semno)) #will execute a query and bring the course credits, marks, gpa in the query [BACKGROUND CHECK] 
	    	summary111.update(display_ss_nov17(display_values,ui_semeid,batchid,campid,progid,student_string,ctype,summary_format,semno,sumarry_for))  #All data from getData will be in display_values and we are sending this to display_ss [FRONT DISPLAY]
	    else:
		# calling the functions for searching the records of students
	    	display_values.update(getData(ui_semeid,campid,progid,batchid,student_string,ctype,summary_format,semno)) #will execute a query and bring the course credits, marks, gpa in the query [BACKGROUND CHECK] 
		summary111.update(display_ss(display_values,ui_semeid,batchid,campid,progid,student_string,ctype,summary_format,semno,sumarry_for))  #All data from getData will be in display_values and we are sending this to display_ss [FRONT DISPLAY]

	    courses=[]
	    courseinfo1=[]
	    # details to be shown to client based on the type of summary sheet to be shown
	    allkeys = display_values
	    nv=allkeys['course_dicti']
	    for nvals in nv:
		courses.append(nvals)
            
	    courses.sort()
	    
	    for val in courses:
		totalcredits.append(nv[val][0])
	   
	    enrollnos = summary111.keys()
	    enrollnos.sort()
	    cour_info=allkeys['cour_code_name']      #This is for the course code and course name table in html
	    for val in enrollnos:
		m.append(summary111[val])
	    sem_list_header=summary111[enrollnos[0]]['disp_sem_list']
	    
	    roman_dict={'1':'I','2':'II','3':'III','4':'IV','5':'V','6':'VI','7':'VII','8':'VIII'}
	    roman_number_list=['I','II','III','IV','V','VI']
	    col_span=len(sem_list_header)+1
	    for sem_value in sem_list_header:
		final_sem=roman_dict[str(sem_value)]
		disp_cre_list_final.append(final_sem)
		disp_gp_list_final.append(final_sem)
	    # details to be shown to client based on the type of summary sheet to be shown

  #return {'summary_exam_type':summary_exam_type,'disp_cre_list_final':disp_cre_list_final,'pri_gp_list':disp_gp_list_final,'col_span':col_span,'final_sem':final_sem,'summary_format':summary_format,'courseinfo1':cour_info,'credits':totalcredits,'summary111':m,'campusname':campusname,'courses':courses,'progname':progname,'camp_name':campus_instance.campus_name,'ctype':ctype,'month':month,'year':year,'semester':semester,'batch':batch}
  return {'summary111':m,'campusname':campusname,'courses':courses,'progname':progname,'camp_name':campus_instance.campus_name,'ctype':ctype,'month':month,'year':year,'semester':semester,'batch':batch}

########################################################################################################################################################################################################
# 'Main Function' called from the front end and returns final data 
########################################################################################################################################################################################################


if __name__ == "__main__":

   #all_prog_cam_details="select distinct stud_campus_id,stud_prog_id,stud_acba_id,cpby_no_of_semester,campus_name,prog_name from exams_mst_students inner join exams_rel_campus_prog_batch_year_sems on stud_campus_id=cpby_camp_id_id and stud_prog_id=cpby_prog_id_id and stud_acba_id=cpby_acba_id_id inner join exams_mst_programs on stud_prog_id=prog_id inner join exams_mst_campus on stud_campus_id=campus_id where stud_status='OnRole' and cpby_acba_id_id in (3,10,20)  and prog_prty_id in (1,2) and campus_id in (1,2) order by stud_campus_id,stud_prog_id,stud_acba_id;"

   all_prog_cam_details="select distinct stud_campus_id,stud_prog_id,stud_acba_id,cpby_no_of_semester,campus_name,prog_name from exams_mst_students inner join exams_rel_campus_prog_batch_year_sems on stud_campus_id=cpby_camp_id_id and stud_prog_id=cpby_prog_id_id and stud_acba_id=cpby_acba_id_id inner join exams_mst_programs on stud_prog_id=prog_id inner join exams_mst_campus on stud_campus_id=campus_id where stud_status='OnRole' and cpby_acba_id_id in (3,10,20)  and prog_prty_id in (1,2) and campus_id in (4) and prog_id !=82 order by stud_campus_id,stud_prog_id,stud_acba_id;"
   cursor_ob=connection.cursor()

   cursor_ob.execute(all_prog_cam_details)
   resultq=cursor_ob.fetchall()

   fp = open('2018.csv','a')

   for record in resultq:
       fake_request = {}
       fake_request['progid']=record[1]#progid
       fake_request['semeid']=record[3]#finalsemester
       fake_request['campusid']=record[0]#campus_id
       fake_request['batchid']=record[2]#batch_id
       val_dict=summary_sheet2017(fake_request)
       #print val_dict['summary111'] 
       for val in val_dict['summary111']:
          # main file format - Tuljapur;B.A. (Hons) in Social Work with Specialization in Rural Development Programme;T2015BASW01;-;F;F
          # gender file format - T2015BASW01;Male;Rajiv
          print record[4]+';'+record[5]+';'+val['enrollment_number']+';'+str(val['gpa_f'])+';'+val['letter_grade']+';'+val['last_result']
          fp.write(record[4]+';'+record[5]+';'+val['enrollment_number']+';'+str(val['gpa_f'])+';'+val['letter_grade']+';'+val['last_result'])
          fp.write('\n')

   fp.close()


