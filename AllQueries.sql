SELECT cour_id, cour_code, cour_name, cour_code_sec from exams_mst_courses where cour_deleted='N' order by cour_name;

#####******--- used for date time stamp ---******####
SELECT * FROM exams_rel_campus_school_programes_courses WHERE rcp_created_datetime > '2016-02-12';

#####******--- used for fething multiple courses ---******####
﻿SELECT cour_name
  FROM exams_mst_courses
where cour_deleted ='N'
 GROUP BY cour_name
HAVING COUNT(cour_name) > 1;

#####******--- kind of inner join query fetching data from multiple table using where condition ---******####
select sch_name,prog_name,cour_name
from exams_mst_schools,exams_mst_programs, exams_mst_courses, exams_rel_campus_school_programes_courses
where exams_rel_campus_school_programes_courses.rcp_school_id=exams_mst_schools.sch_id AND
exams_rel_campus_school_programes_courses.rcp_prog_id=exams_mst_programs.prog_id AND
exams_rel_campus_school_programes_courses.rcp_cour_id=exams_mst_courses.cour_id AND rcp_deleted='N' order by sch_name;

#####******--- query to showcase group by of selected attributes and sorting it based on multiple values or records in common. For instance campus,school,prog,courses showing in ascending order and checking the having count on group by items ---******####
select rcp_deleted,campus_name,sch_id, sch_name,prog_id,prog_name,cour_id,cour_name
from exams_rel_campus_school_programes_courses 
	inner join exams_mst_courses on rcp_cour_id=cour_id 
	inner join exams_mst_programs on rcp_prog_id=prog_id
	inner join exams_mst_schools on rcp_school_id=sch_id 
	inner join exams_mst_campus on rcp_campus_id=campus_id
	group by rcp_deleted,campus_name,sch_id, sch_name,prog_id,prog_name,cour_id,cour_name
	having (COUNT(cour_name)>=1 and count(prog_name)>1 and count(sch_name)>1)
	order by sch_name,prog_name,cour_name ASC;

##### Query 1 For Hostel ----used for exporting the data for changing the status of fees of students for next year----
select stud_enrollment_number AS "Enrollment No",acba_name AS "Batch",sfed_hostel AS "Hostel", sfed_dh AS "DH" from fees_rel_stud_fee_details 
inner join exams_mst_students on sfed_stud_id=stud_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_fees_categories on sfed_cate_id=fee_cate_id
where exams_mst_students.stud_sem_id=2 and stud_acba_id=1 and stud_campus_id=1 and stud_status='OnRole' and stud_deleted='N';

#####Query 2 For SPO ----used for exporting data----
select stud_enrollment_number AS "Enrollment No",acba_name AS "Batch",fee_cate_name AS "Fee Category" from fees_rel_stud_fee_details 
inner join exams_mst_students on sfed_stud_id=stud_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_fees_categories on sfed_cate_id=fee_cate_id
where exams_mst_students.stud_sem_id=2 and stud_acba_id=1 and stud_campus_id=1 and stud_status='OnRole' and stud_deleted='N';

#####Query For Hostel output in hostel1 excel file ----used for----later tested/ trial
select stud_enrollment_number AS "Enrollment No",acba_name AS "Batch",sfed_hostel AS "Hostel", sfed_dh AS "DH" from fees_rel_stud_fee_details 
inner join exams_mst_students on sfed_stud_id=stud_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_fees_categories on sfed_cate_id=fee_cate_id
where sfed_sem_id=2 order by stud_enrollment_number;

####Query For Hotel and SPO Combined ---- used for verification through mst_student----
select stud_enrollment_number from exams_mst_students 
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_programme_type on prog_prty_id=progtype_id
where stud_deleted='N' and stud_sem_id=2 and stud_acba_id=1
and stud_status='OnRole' and stud_campus_id=1 and progtype_id!=5 and stud_id in (select sfed_stud_id from fees_rel_stud_fee_details)order by stud_enrollment_number;


*****************************************************************************************************************************************************
'Execution Date:15/03/16'

#####Query For SPO Final ------
select stud_enrollment_number AS "Enrollment No",stud_fname AS "First Name",stud_mname AS "Middle Name", stud_lname AS "Last Name", cate_name AS "Admission Category",acba_name AS "Batch",fee_cate_name AS "Fee Category" from fees_rel_stud_fee_details 
inner join exams_mst_students on sfed_stud_id=stud_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_fees_categories on sfed_cate_id=fee_cate_id
inner join exams_mst_categories on cate_id=stud_admission_cate_id
where exams_mst_students.stud_sem_id=2 and stud_acba_id=1 and stud_campus_id=1 and stud_status='OnRole' and stud_deleted='N' order by stud_enrollment_number;

#####Query For Hostel Final ------
select stud_enrollment_number AS "Enrollment No",stud_fname AS "First Name",stud_mname AS "Middle Name", stud_lname AS "Last Name", cate_name AS "Admission Category",acba_name AS "Batch",sfed_hostel AS "Hostel",sfed_dh AS "DH" from fees_rel_stud_fee_details 
inner join exams_mst_students on sfed_stud_id=stud_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_fees_categories on sfed_cate_id=fee_cate_id
inner join exams_mst_categories on cate_id=stud_admission_cate_id
where exams_mst_students.stud_sem_id=2 and stud_acba_id=1 and stud_campus_id=1 and stud_status='OnRole' and stud_deleted='N' order by stud_enrollment_number;

#####Query used For Exculded 6 Students Details -----
select stud_enrollment_number AS "Enrollment No",stud_fname AS "First Name",stud_mname AS "Middle Name", stud_lname AS "Last Name",
cate_name AS "Admission Category" , acba_name AS "Batch" , stud_hostel AS "Hostel", fee_cate_name AS "Fees Category"
from exams_mst_students
left join exams_mst_fees_categories on stud_fee_cate_id=fee_cate_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_categories on cate_id=stud_admission_cate_id
where exams_mst_students.stud_sem_id=2 and stud_acba_id=1 and stud_campus_id=1 and stud_status='OnRole' and stud_deleted='N' and stud_prog_type_id<>5
and stud_id not in(select sfed_stud_id from fees_rel_stud_fee_details) order by stud_enrollment_number;

#####Query used For MPhil Students for SPO and Hostel -----93 records
select stud_enrollment_number AS "Enrollment No",stud_fname AS "First Name",stud_mname AS "Middle Name", stud_lname AS "Last Name",
cate_name AS "Admission Category" , acba_name AS "Batch", stud_hostel AS "Hostel", fee_cate_name AS "Fees Category"
from exams_mst_students
inner join exams_mst_fees_categories on stud_fee_cate_id=fee_cate_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_categories on cate_id=stud_admission_cate_id
where stud_sem_id=2 and stud_acba_id=1 and stud_campus_id=1 and stud_status='OnRole' and stud_deleted='N' and stud_prog_type_id=5 order by stud_enrollment_number;
*****************************************************************************************************************************************************

'Execution Date:12/04/16'

#####Query used For searching the list of CBCS courses ------
select cour_id, cour_name, cour_code, cour_code_sec from exams_rel_courses_programes_semesters inner join exams_mst_courses on  cpse_cour_id=cour_id where cpse_cour_type='C' and cpse_seme_id=2 and cour_deleted='N' and cpse_deleted='N' order by cour_code_sec;

#####Query used For searching the list of CBCS courses from cpse ------
select * from exams_rel_courses_programes_semesters where cpse_cour_type='C' and cpse_seme_id=2;

*****************************************************************************************************************************************************

'Execution Date:13/04/16'

-- query for permissions returned 15 rows. 
select * from exams_rel_employees_activities_permissions where emap_empl_id=14 and emap_proc_id=5 and emap_deleted='N' and emap_acti_id=44 and emap_proc_id=5 and emap_acti_id=44; 

-- query for searching unique program from rcp.
select distinct(rcp_prog_id) from exams_rel_campus_school_programes_courses where rcp_id in (1346,1347,1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,1358,1359,1360) and rcp_deleted='N';

-- query for retiriving all the courses from cpse returned 39 courses of CBCS.
select * from exams_rel_courses_programes_semesters where cpse_campus_id=1 and cpse_deleted='N' and cpse_cour_type='C' and cpse_acba_id!=2;

-- replaced query for 2nd one returned 1 row
select * from exams_rel_campus_school_programes_courses where rcp_id =1346 and rcp_prog_id=83 and rcp_campus_id=1 and rcp_deleted='N';

-- CBCS courses with name
select cour_id, cour_name, cour_code, cour_code_sec from exams_rel_courses_programes_semesters inner join exams_mst_courses on  cpse_cour_id=cour_id where cpse_cour_type='C' and cpse_seme_id=2 and cour_deleted='N' and cpse_deleted='N' order by cour_code_sec;

*****************************************************************************************************************************************************

'Execution Date:18/04/2016'
-- query for fetching data from course_evaluation, marks_emtry that students of LLM has taken which course : returned 29 rows incorrect batch
select stud_id, stud_enrollment_number,cour_name,cour_id, cour_enabled, cour_code_sec from tcourse_evaluation_rel_stu_courses 
inner join  exams_mst_students on rscs_stu_id=stud_id 
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id
where rscs_course_type='C' and stud_campus_id=1 and stud_prog_id=46 and rscs_deleted='N' and rscs_batch_id=1 and rscs_sem_id=2;

--update
update tcourse_evaluation_rel_stu_courses set rscs_batch_id=4 where 
rscs_stu_id in (782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,
803,804,805,806,807,808,809,810,811,4159) and rscs_course_type='C'

-- search LLM
select stud_id, stud_enrollment_number,cour_name,cour_id, cour_enabled, cour_code_sec from tcourse_evaluation_rel_stu_courses 
inner join  exams_mst_students on rscs_stu_id=stud_id 
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id
where rscs_course_type='C' and stud_campus_id=1 and stud_prog_id=46 and rscs_deleted='N' and rscs_batch_id=4 and rscs_sem_id=2;

*****************************************************************************************************************************************************

--Query with scse(marks data of students) returned 1655 rows if last not exempted last line other wise 1325 rows
select * from exams_rel_courses_programes_semesters 
inner join exams_rel_students_courses_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on rscs_id=scse_rscs_id
inner join exams_mst_students on stud_id=rscs_stu_id
where cpse_cour_type='C' and cpse_deleted='N' and scse_course_attempt='Re' and cpse_seme_id=2
and scse_course_type='C' and scse_deleted='N' 
and rscs_deleted='N' and rscs_course_type='C' 

--Query without scse(marks data of students) returned 1655 rows if last not exempted last line other wise 1325 rows
select * from exams_rel_courses_programes_semesters 
--inner join exams_rel_students_courses_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on rscs_cpse_id=cpse_id
inner join exams_mst_students on stud_id=rscs_stu_id
where cpse_cour_type='C' and cpse_deleted='N' 
--and scse_course_attempt='Re' and scse_course_type='C' and scse_deleted='N' 
and rscs_deleted='N' and rscs_course_type='C'

select * from exams_rel_courses_programes_semesters 
inner join exams_rel_students_courses_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on rscs_cpse_id=cpse_id
inner join exams_mst_students on stud_id=rscs_stu_id
where cpse_cour_type='C' and cpse_deleted='N' and scse_course_attempt='Re' and scse_course_type='C' and scse_deleted='N' 
and rscs_deleted='N' and rscs_course_type='C'

select * from exams_rel_courses_programes_semesters 
inner join exams_rel_students_courses_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on rscs_id=scse_rscs_id
inner join exams_mst_students on stud_id=rscs_stu_id
where cpse_cour_type='C' and cpse_deleted='N' and scse_course_attempt='Re' 
and scse_course_type='C' and scse_deleted='N' 
and rscs_deleted='N' and rscs_course_type='C'

select stud_enrollment_number,cour_name 
from exams_mst_students
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id and rscs_course_type='C' and rscs_deleted='N'
inner join exams_mst_courses on cour_id=rscs_course_id
inner join exams_rel_courses_programes_semesters on cpse_id=rscs_cpse_id
where stud_acba_id in (1,4) and stud_campus_id=1 order by cpse_id

select * from exams_mst_students
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id where rscs_course_type='C' and rscs_deleted='N'

--server returned 2109 rows
select stud_enrollment_number,cour_name 
from exams_mst_students
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id and rscs_course_type='C' and rscs_deleted='N'
inner join exams_mst_courses on cour_id=rscs_course_id
inner join exams_rel_courses_programes_semesters on cpse_id=rscs_cpse_id
where stud_campus_id=1 order by cpse_id

*****************************************************************************************************************************************************

select stud_enrollment_number, cour_code_sec ,cour_name, stud_fname, stud_lname, seme_name, acba_name, rscs_batch_id, rscs_sem_id, rscs_course_id,stud_campus_id
from exams_mst_students
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_cpse_id=scse_cpse_id and rscs_id=scse_rscs_id
inner join exams_mst_academic_batches on rscs_batch_id=acba_id
inner join exams_mst_semesters on rscs_sem_id=seme_id
inner join exams_mst_courses on rscs_course_id=cour_id
where rscs_course_type='C' and rscs_deleted='N' and cpse_cour_type='C' and cpse_deleted='N' 
and scse_course_attempt='Re' and scse_deleted='N' and stud_deleted='N';

--query for selecting the CBCS students who has not selected sem2 online returned 54 rows.
select * from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
where rscs_course_type='C' and rscs_deleted='N' and stud_choice_viewed_sem2 is null;

--query for selecting the CBCS students who has selected CBCS courses online returned 1271 rows.
select * from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
where rscs_course_type='C' and rscs_deleted='N' and stud_choice_viewed_sem2 = 'Y';

select count(rscs_course_id),cour_name from tcourse_evaluation_rel_stu_courses
inner join exams_mst_courses on cour_id=rscs_course_id and rscs_sem_id=2
inner join exams_rel_courses_programes_semesters on cpse_id=rscs_cpse_id
where rscs_course_type='C' and rscs_deleted='N' and rscs_sem_id=2
group by rscs_course_id,cour_name,cpse_id
order by cpse_id

***************************************************************************************************************************************************

--queries executed on 25_April_16.
select * from exams_rel_campus_school_programes_courses where rcp_prog_id=28

select * from exams_rel_courses_programes_semesters where cpse_prog_id=33 and cpse_seme_id=2

select distinct(cour_name),cour_id from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id 
inner join exams_mst_courses on rscs_course_id=cour_id where stud_prog_id=33 and rscs_sem_id=2 and rscs_course_type='C';

select * from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id where stud_prog_id=33 and rscs_sem_id=2 and rscs_course_type='C' and stud_deleted='N' and rscs_deleted='N';

select * from exams_rel_courses_programes_semesters where cpse_prog_id=33

**************************************************************************************************************************************************

-- query for searching the data for enrolling or deenrolling cbcs students
select * from tcourse_evaluation_rel_stu_courses 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and scse_cpse_id=rscs_cpse_id
inner join exams_mst_students on stud_id=rscs_stu_id
where scse_deleted='N' and rscs_deleted='N' and rscs_course_type='C' and scse_course_attempt='Re' and stud_status='OnRole';

**************************************************************************************************************************************************

-- query for searching the students with 1 entry
select rscs_stu_id from tcourse_evaluation_rel_stu_courses 
where rscs_course_type='C' and rscs_batch_id=1 and rscs_sem_id=2
Group by rscs_stu_id
having count(rscs_stu_id) =1 order by rscs_stu_id;

**************************************************************************************************************************************************

-- query for searching the students of Social Work

select prog_name,stud_enrollment_number, cour_code_sec ,cour_name, stud_fname, stud_lname, seme_name, acba_name, rscs_batch_id, rscs_sem_id, rscs_course_id,stud_campus_id
from exams_mst_students
inner join exams_mst_programs on prog_id=stud_prog_id
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_academic_batches on rscs_batch_id=acba_id
inner join exams_mst_semesters on rscs_sem_id=seme_id
inner join exams_mst_courses on rscs_course_id=cour_id
where rscs_course_type='C' and rscs_deleted='N' and cpse_cour_type='C' 
and cpse_deleted='N' and stud_deleted='N' and rscs_sem_id=2 and rscs_batch_id=1 and stud_campus_id=1 and prog_id in (2,33,34,35,36,37,38,39,40) order by(prog_name,stud_id,cour_name);

-- query for searching the secretariat course code of 16 CBCS courses of 2nd sem

select distinct cour_code_sec from exams_mst_students 
inner join exams_rel_courses_programes_semesters on cpse_seme_id=2 and cpse_acba_id=1 and cpse_cour_type='C' 
inner join exams_mst_courses on cour_id=cpse_cour_id
where stud_sem_id=2 and stud_acba_id=1 and cour_deleted='N' and stud_prog_id in (2,33,34,35,36,37,38,39,40);

**************************************************************************************************************************************************
-- CBCS 27/05/2016

--Query for finding students of "Law, Institutions,Society & Development" and their second sem CBCS courses returned 104 rows

select stud_enrollment_number, cour_name from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=rscs_cpse_id
where rscs_deleted='N' and rscs_sem_id=2 and rscs_course_type='C' and cpse_deleted='N' and scse_deleted='N' and rscs_stu_id in 
(select distinct(rscs_stu_id) from tcourse_evaluation_rel_stu_courses 
where rscs_course_type='C' and rscs_batch_id='1' and rscs_sem_id=2 and rscs_deleted='N' and rscs_course_id=582) 
order by stud_enrollment_number;

--OR--

select * from tcourse_evaluation_rel_stu_courses 
where rscs_course_type='C' and rscs_deleted='N' and rscs_sem_id=2 and rscs_batch_id=1 
and rscs_stu_id in (325,766,668,637,3298,639,189,759,363,330,16,27,83,746,22,48,647,141,667,662,407,213,207,191,648,190,398,202,98,41,373,347,4155,379,393,200,767,4154,30,167,11,414,8,348,36,46,88,131,50,35,600,619,620,625,655)

--Query for finding students of "Law, Institutions,Society & Development" and their third sem CBCS courses returned 96 rows

select stud_enrollment_number, cour_name from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=rscs_cpse_id
where rscs_deleted='N' and rscs_sem_id=3 and rscs_course_type='C' and cpse_deleted='N' and scse_deleted='N' and rscs_stu_id in 
(select distinct(rscs_stu_id) from tcourse_evaluation_rel_stu_courses 
where rscs_course_type='C' and rscs_batch_id='1' and rscs_sem_id=2 and rscs_deleted='N' and rscs_course_id=582) 
order by stud_enrollment_number;

--OR--

select * from tcourse_evaluation_rel_stu_courses 
where rscs_course_type='C' and rscs_deleted='N' and rscs_sem_id=3 and rscs_batch_id=1 
and rscs_stu_id in (325,766,668,637,3298,639,189,759,363,330,16,27,83,746,22,48,647,141,667,662,407,213,207,191,648,190,398,202,98,41,373,347,4155,379,393,200,767,4154,30,167,11,414,8,348,36,46,88,131,50,35,600,619,620,625,655)

-- Query for updating the records of students 

update tcourse_evaluation_rel_stu_courses
set rscs_deleted='Y' where rscs_id in (26040,26225,26522) and rscs_course_type ='C' and rscs_cpse_id=912

**************************************************************************************************************************************************
-----Data from CBCS_related.sql
--Query to find students eligible for CBCS
﻿select count(stud_enrollment_number) from exams_mst_students where stud_acba_id=1 and stud_campus_id=1 
and stud_status='OnRole'

--Query to find students who have viewed CBCS link but not selected any course
select count(stud_enrollment_number) from exams_mst_students where stud_acba_id=1 and stud_campus_id=1 
and stud_choice_viewed is not null and stud_choice_selected is null

--Query to find students who have viewed CBCS link
select count(stud_enrollment_number) from exams_mst_students where stud_acba_id=1 and stud_campus_id=1 
and stud_choice_viewed is not null

--Query to find  which student has opted for which CBCS course
select stud_enrollment_number,cour_name 
from exams_mst_students
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id and rscs_course_type='C' and rscs_deleted='N'
inner join exams_mst_courses on cour_id=rscs_course_id
inner join exams_rel_courses_programes_semesters on cpse_id=rscs_cpse_id
where stud_acba_id=1 and stud_campus_id=1 order by cpse_id

--Query to find count of CBCS course 
select count(rscs_course_id),cour_name from tcourse_evaluation_rel_stu_courses
inner join exams_mst_courses on cour_id=rscs_course_id
inner join exams_rel_courses_programes_semesters on cpse_id=rscs_cpse_id
where rscs_course_type='C'  and rscs_deleted='N'
group by rscs_course_id,cour_name,cpse_id
order by cpse_id

--Query for searching the CLL-PTM students 
select prog_name,stud_enrollment_number, cour_code_sec ,cour_name, seme_name from exams_mst_students
inner join exams_mst_programs on prog_id=stud_prog_id
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_semesters on rscs_sem_id=seme_id
inner join exams_mst_courses on rscs_course_id=cour_id
where rscs_course_type='C' and rscs_deleted='N' and cpse_cour_type='C' 
and cpse_deleted='N' and stud_deleted='N' and rscs_sem_id=2 and rscs_batch_id=1 and stud_campus_id=1 and stud_status='OnRole' and rscs_course_id=585 order by(stud_enrollment_number);

-- Query for updating the records of students 

update tcourse_evaluation_rel_stu_courses
set rscs_deleted='Y' where rscs_id in (26040,26225,26522) and rscs_course_type ='C' and rscs_cpse_id=912

--Query for finding students of "Law, Institutions,Society & Development" and their second sem CBCS courses

select stud_enrollment_number, cour_name from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=rscs_cpse_id
where rscs_deleted='N' and rscs_sem_id=2 and rscs_course_type='C' and cpse_deleted='N' and scse_deleted='N' and rscs_stu_id in 
(select distinct(rscs_stu_id) from tcourse_evaluation_rel_stu_courses 
where rscs_course_type='C' and rscs_batch_id='1' and rscs_sem_id=2 and rscs_deleted='N' and rscs_course_id=582) 
order by stud_enrollment_number;

--Query for finding students of "Law, Institutions,Society & Development" and their third sem CBCS courses

select stud_enrollment_number, cour_name from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=rscs_cpse_id
where rscs_deleted='N' and rscs_sem_id=3 and rscs_course_type='C' and cpse_deleted='N' and scse_deleted='N' and rscs_stu_id in 
(select distinct(rscs_stu_id) from tcourse_evaluation_rel_stu_courses 
where rscs_course_type='C' and rscs_batch_id='1' and rscs_sem_id=2 and rscs_deleted='N' and rscs_course_id=582) 
order by stud_enrollment_number;

--Query for searching the CLL-PTM students 

select prog_name,stud_enrollment_number, cour_code_sec ,cour_name, seme_name from exams_mst_students
inner join exams_mst_programs on prog_id=stud_prog_id 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_semesters on rscs_sem_id=seme_id
inner join exams_mst_courses on rscs_course_id=cour_id
where rscs_course_type='C' and rscs_deleted='N' and cpse_cour_type='C' 
and cpse_deleted='N' and stud_deleted='N' and rscs_sem_id=2 and rscs_batch_id=1 and stud_campus_id=1 and stud_status='OnRole' and rscs_course_id=585 order by(stud_enrollment_number);

---------------------------------------------------------------------------------------------------------------------------------------------
-- Query for searching data who are failed in regular after supplementary1 marks saved gives repetative entries
select * from exams_rel_students_courses_semesters where scse_cpse_id=905 and scse_course_attempt in ('Re','S1') and scse_course_type='C' and (scse_gpa_actual < 4.0 or scse_gpa_actual is null) and scse_deleted='N'

-- Query for searching data who are failed in regular after supplementary1 marks saved --- final 
select * from exams_rel_students_courses_semesters where scse_cpse_id=905 and scse_course_attempt='S1' and scse_deleted='N' 
union 
select * from exams_rel_students_courses_semesters where scse_cpse_id=905 and scse_course_attempt='Re' and scse_deleted='N' and (scse_gpa_actual < 4 or scse_gpa_actual is null) and scse_rscs_id not in (select scse_rscs_id from exams_rel_students_courses_semesters where scse_cpse_id=905 and scse_course_attempt='S1' and scse_deleted='N')

**************************************************************************************************************************************************
--01/06/16
-- Final BASIC Query
select distinct (stud_enrollment_number), sch_name,prog_name, cour_name, stud_fname, stud_lname, scse_isconfirm,scse_gpa_actual, scse_course_result from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id 
inner join exams_mst_schools on rcp_school_id=sch_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
where rscs_deleted='N' and rscs_course_type='C' and rscs_sem_id=2 and rscs_batch_id=1 and rcp_school_id=1
and scse_deleted='N' and scse_course_type='C'and rcp_deleted='N'
and cpse_deleted='N' and cpse_cour_type='C' and stud_status='OnRole' order by cour_name,prog_name,stud_enrollment_number

--case 1 when marks , courseresult , are saved and scse_isconfirm='N' == not confirm
--case 2 when marks, courseresult , are not entered and scse_isconfirm='N'== marks not entered
--case 3 when marks, courseresult, are saved and scse_isconfirm='Y' == confirm

-- trial 2 
select distinct (stud_enrollment_number), sch_name,prog_name, cour_name, stud_fname, stud_lname,  
CASE 
	WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='Y' THEN REPLACE(scse_isconfirm,'Y','Confirmed') 
	WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='N' THEN
		CASE is_confirm WHEN scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','Saved')
		ELSE REPLACE(scse_isconfirm,'Y','Confirmed') END
	--WHEN scse_gpa_actual is null and scse_course_result is not null and scse_isconfirm is not null THEN REPLACE(scse_isconfirm,'N','Confirmed')
	ELSE 'Marks Not Saved' END as scse_isconfirm,scse_gpa_actual, scse_course_result from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id 
inner join exams_mst_schools on rcp_school_id=sch_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
where rscs_deleted='N' and rscs_course_type='C' and rscs_sem_id=2 and rscs_batch_id=1 and rcp_school_id=1
and scse_deleted='N' and scse_course_type='C'and rcp_deleted='N'
and cpse_deleted='N' and cpse_cour_type='C' and stud_status='OnRole' order by cour_name,prog_name,stud_enrollment_number

-- Final Query executed for Social Work for dislaying the saved and marks and unsaved marks
select distinct (stud_enrollment_number), sch_name,prog_name, cour_name, stud_fname, stud_lname,  
CASE 
	WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='Y' THEN REPLACE(scse_isconfirm,'Y','Confirmed') 
	WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','Saved')
	WHEN scse_gpa_actual is null and scse_course_result is not null and scse_isconfirm is not null THEN 

		CASE WHEN scse_isconfirm='N' and scse_course_result='F' THEN REPLACE(scse_isconfirm,'N','Saved')
		WHEN scse_isconfirm='N' and scse_course_result ='' THEN REPLACE(scse_isconfirm,'N','No Marks')
		ELSE REPLACE(scse_isconfirm,'Y','Confirmed') END
		
	ELSE 'NO DATA' END as scse_isconfirm,scse_gpa_actual, scse_course_result, scse_isconfirm from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id 
inner join exams_mst_schools on rcp_school_id=sch_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
where rscs_deleted='N' and rscs_course_type='C' and rscs_sem_id=2 and rscs_batch_id=1 and rcp_school_id=1
and scse_deleted='N' and scse_course_type='C'and rcp_deleted='N'
and cpse_deleted='N' and cpse_cour_type='C' and stud_status='OnRole' order by cour_name,prog_name,stud_enrollment_number

************************************************************************************************************************************************

--#Dt: 2/6/16
-- Final Query executed for Social Work for dislaying the saved marks, confirmed marks and not entered
select distinct (stud_enrollment_number) as "Enrollment Number", sch_name as "School Name",prog_name as "Program Name", cour_code_sec as "Course Code" ,cour_name as "Course Name", stud_fname as "First Name", stud_lname as "Last Name",  
CASE 
	WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='Y' THEN REPLACE(scse_isconfirm,'Y','Confirmed') 
	WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','Saved')
	WHEN scse_gpa_actual is null and scse_course_result is not null and scse_isconfirm is not null THEN --condition satisfied for 2nd part as scse_course_result is ''(blank) and not null

		CASE WHEN scse_isconfirm='N' and scse_course_result='F' THEN REPLACE(scse_isconfirm,'N','Saved')
		WHEN scse_isconfirm='N' and scse_course_result ='' THEN REPLACE(scse_isconfirm,'N','No Marks') --2nd part if no marks
		ELSE REPLACE(scse_isconfirm,'Y','Confirmed') END
		
	ELSE 'NO DATA' END as "Marks Status",scse_gpa_actual as "GPA", scse_course_result as "Result" from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id 
inner join exams_mst_schools on rcp_school_id=sch_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
where rscs_deleted='N' and rscs_course_type='C' and rscs_sem_id=2 and rscs_batch_id=1 and rcp_school_id=1
and scse_deleted='N' and scse_course_type='C'and rcp_deleted='N'
and cpse_deleted='N' and cpse_cour_type='C' and stud_status='OnRole' and stud_deleted='N' order by cour_name,prog_name,stud_enrollment_number

***********************************************************************************************************************************************
--data from other file

select * from exams_rel_students_courses_semesters where scse_cpse_id=905 and scse_course_attempt in ('Re','S1') and scse_course_type='C' and (scse_gpa_actual < 4.0 or scse_gpa_actual is null) and scse_deleted='N'

select * from exams_rel_students_courses_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students 
where scse_cpse_id=905 and scse_course_attempt='S1' and scse_deleted='N' and scse_rscs_id=rscs_id and rscs_stu_id=stud_id
union 
select * from exams_rel_students_courses_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students
where scse_cpse_id=905 and scse_course_attempt='Re' and scse_deleted='N' and 
(scse_gpa_actual < 4 or scse_gpa_actual is null) and scse_rscs_id not in (select scse_rscs_id from exams_rel_students_courses_semesters 
where scse_cpse_id=905 and scse_course_attempt='S1' and scse_deleted='N')

SELECT CASE WHEN scse_cpse_id=905 and scse_course_attempt='S1' and scse_deleted='N' 
            WHEN scse_cpse_id=905 and scse_course_attempt='Re' and scse_deleted='N' and (scse_gpa_actual < 4 or scse_gpa_actual is null) THEN *
--            ELSE <returndefaultcase>
       END *
FROM exams_rel_students_courses_semesters

select * from exams_rel_students_courses_semesters where scse_cpse_id=905 and scse_course_attempt='S1' and scse_deleted='N' 

select * from exams_rel_students_courses_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students 
where scse_rscs_id=rscs_id and rscs_stu_id=stud_id and scse_course_attempt='%s' and scse_deleted='N' and scse_cpse_id=%d order by stud_enrollment_number

---trial data partly successful

select * from exams_rel_students_courses_semesters where scse_cpse_id=905 and scse_course_attempt='S1' and scse_deleted='N' 
union 
select * from exams_rel_students_courses_semesters where scse_cpse_id=905 and scse_course_attempt='Re' and scse_deleted='N' and (scse_gpa_actual < 4 or scse_gpa_actual is null) and scse_rscs_id not in (select scse_rscs_id from exams_rel_students_courses_semesters where scse_cpse_id=905 and scse_course_attempt='S1' and scse_deleted='N')

-----------------------------------------------------------------------------------------------------------------------------------------------

--Dt. 03/06/16 query to check cbcs courses whose marks are not yet confirmed for 2nd semester

select distinct cour_id, cour_name from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id 
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_campus_school_programes_courses on rscs_course_id=rcp_cour_id and rcp_prog_id=83
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_students_courses_semesters on scse_cpse_id=rscs_cpse_id and scse_rscs_id=rscs_id
where rscs_course_type='C' and rscs_deleted='N' and cpse_cour_type='C' and cpse_deleted='N' 
and rscs_sem_id=2 and rscs_batch_id=1 and scse_deleted='N' and scse_isconfirm='N' and cpse_isconfirm='N'

*************************************************************************************************************************************************
--06 june 2016
--modified queries
select distinct (stud_enrollment_number),stud_fname,stud_lname,sch_name,prog_name,acba_name,seme_name,cour_code_sec,cour_name, 
CASE WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='Y' THEN REPLACE(scse_isconfirm,'Y','Confirmed') 
WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','Saved') 
WHEN scse_gpa_actual is null and scse_course_result is not null and scse_isconfirm is not null THEN 
	CASE WHEN scse_isconfirm='N' and scse_course_result='F' THEN REPLACE(scse_isconfirm,'N','Saved') 
	WHEN scse_isconfirm='N' and scse_course_result ='' THEN REPLACE(scse_isconfirm,'N','No Marks') 
	ELSE REPLACE(scse_isconfirm,'Y','Confirmed') END ELSE 'NO DATA' END scse_isconfirm, scse_gpa_actual, scse_course_result 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id 
inner join exams_mst_courses on rscs_course_id=cour_id 
inner join exams_mst_programs on stud_prog_id=prog_id 
inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id
inner join exams_mst_academic_batches on rscs_batch_id=acba_id
inner join exams_mst_semesters on rscs_sem_id=seme_id
inner join exams_mst_schools on rcp_school_id=sch_id 
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id where rscs_deleted='N' and rscs_course_type='C' 
and rscs_sem_id=2 and rscs_batch_id=1 and rcp_school_id=6 and scse_deleted='N' and scse_course_type='C'and rcp_deleted='N' and cpse_deleted='N' 
and cpse_cour_type='C' and stud_status='OnRole' and stud_deleted='N' order by cour_name,prog_name,stud_enrollment_number


select distinct (stud_enrollment_number),stud_fname, stud_lname, sch_name,prog_name,acba_name,seme_name,cour_code_sec,cour_name, 
CASE WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='Y' THEN REPLACE(scse_isconfirm,'Y','Confirmed') 
WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','Saved') 
WHEN scse_gpa_actual is null and scse_course_result is not null and scse_isconfirm is not null THEN CASE 
WHEN scse_isconfirm='N' and scse_course_result='F' THEN REPLACE(scse_isconfirm,'N','Saved') 
WHEN scse_isconfirm='N' and scse_course_result ='' THEN REPLACE(scse_isconfirm,'N','No Marks') 
ELSE REPLACE(scse_isconfirm,'Y','Confirmed') END ELSE 'NO DATA' END scse_isconfirm, scse_gpa_actual, scse_course_result from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id inner join exams_mst_courses on rscs_course_id=cour_id 
inner join exams_mst_programs on stud_prog_id=prog_id inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id 
inner join exams_mst_academic_batches on rscs_batch_id=acba_id inner join exams_mst_semesters on rscs_sem_id=seme_id 
inner join exams_mst_schools on rcp_school_id=sch_id inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id where rscs_deleted='N' and rscs_course_type='C' 
and rscs_sem_id=2 and rscs_batch_id=1 and scse_deleted='N' and scse_course_type='C'and rcp_deleted='N' and cpse_deleted='N'
 and cpse_cour_type='C' and stud_status='OnRole' and stud_deleted='N' order by cour_name,prog_name,stud_enrollment_number

*************************************************************************************************************************************************

-- count number of students whose marks are entered in cbcs and not entered and total number of students 
--07/06/16 query to find data of students. i.e students marks entered and not entered
--------------------------------------------------------------------------------------------------------------------------------------------------
-- query to select all CBCS students for 2nd sem
select sch_name,cour_name , count (rscs_stu_id) as total_students from exams_mst_students
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=rscs_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_campus_school_programes_courses on rscs_course_id=rcp_cour_id and rcp_prog_id=83
inner join exams_mst_schools on sch_id=rcp_school_id
where rscs_deleted='N' and stud_deleted='N' and stud_status='OnRole' and rscs_course_type='C' 
and scse_deleted='N' and scse_course_type='C' and cour_deleted='N' and rscs_sem_id=2 and rscs_batch_id in (1,4)
group by sch_name,cour_name order by cour_name

--students whose marks are entered
--union
select cour_name,count (scse_id) as marks_entered from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=rscs_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id  
where rscs_deleted='N' and stud_deleted='N' and stud_status='OnRole' and rscs_course_type='C' and scse_course_result!='' 
and scse_deleted='N' and scse_course_type='C' and cour_deleted='N' and rscs_sem_id=2 and rscs_batch_id=1
group by cour_name order by cour_name

----students whose marks are not entered
--union 
select cour_name,count (scse_id) as marks_not_entered from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=rscs_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id  
where rscs_deleted='N' and stud_deleted='N' and stud_status='OnRole' and rscs_course_type='C' and scse_gpa_actual is null and scse_letter_grade='' and scse_course_result=''
and scse_deleted='N' and scse_course_type='C' and cour_deleted='N' and rscs_sem_id=2 and rscs_batch_id=1
group by cour_name order by cour_name

-------------------------------------------------------------------------------------------------------------------------------------------------
--Dt. 08/06/16
-- displaying the list of students whose 2nd sem only cbcs course marks are not entered
select sch_name as "School Name", cour_code_sec as "Course Code",cour_name as "Course Name", stud_enrollment_number as "Enrollment Number",stud_fname as "First Name", stud_lname as "Last Name" from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=rscs_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id  
inner join exams_rel_campus_school_programes_courses on rscs_course_id=rcp_cour_id and rcp_prog_id=83
inner join exams_mst_schools on sch_id=rcp_school_id
where rscs_deleted='N' and stud_deleted='N' and stud_status='OnRole' and rscs_course_type='C' and scse_gpa_actual is null and scse_letter_grade='' and scse_course_result=''
and scse_deleted='N' and scse_course_type='C' and cour_deleted='N' and rscs_sem_id=2 and rscs_batch_id = 1
order by cour_name, stud_enrollment_number

-- modified query for DS
select distinct (stud_enrollment_number) as "Enrollment Number",stud_fname as "First Name",stud_lname as "Last Name",sch_name as "School Name",prog_name as "Programme Name",acba_name as "Batch",seme_name as "Semester",cour_code_sec as "Course Code",cour_name as "Course Name",
CASE WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='Y' THEN REPLACE(scse_isconfirm,'Y','Confirmed') 
WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','Saved') 
WHEN scse_gpa_actual is null and scse_course_result is not null and scse_isconfirm is not null THEN 
	CASE WHEN scse_isconfirm='N' and scse_course_result='F' and scse_isabsent='Y' THEN REPLACE (scse_isconfirm,'N','Absent') 
	--WHEN scse_isconfirm='N' and scse_course_result='F' 
	WHEN scse_isconfirm='N' and scse_course_result ='' THEN REPLACE(scse_isconfirm,'N','No Marks') 
	ELSE REPLACE(scse_isconfirm,'Y','Absent') END ELSE 'NO DATA' END as "Marks Status" , scse_gpa_actual as "GPA", scse_course_result as "Result"
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id 
inner join exams_mst_courses on rscs_course_id=cour_id 
inner join exams_mst_programs on stud_prog_id=prog_id 
inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id
inner join exams_mst_academic_batches on rscs_batch_id=acba_id
inner join exams_mst_semesters on rscs_sem_id=seme_id
inner join exams_mst_schools on rcp_school_id=sch_id 
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id where rscs_deleted='N' and rscs_course_type='C' 
and rscs_sem_id=2 and rscs_batch_id=1 and rcp_school_id=6 and scse_deleted='N' and scse_course_type='C'and rcp_deleted='N' and cpse_deleted='N' 
and cpse_cour_type='C' and stud_status='OnRole' and stud_deleted='N' order by prog_name,cour_name,stud_enrollment_number

-----
-- query to deenroll 18 students in scse 
update exams_rel_students_courses_semesters set scse_deleted='Y' 
where scse_cpse_id=916 and  scse_deleted='N' and scse_rscs_id in 
(select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_deleted='N' and rscs_cpse_id=916 and rscs_stu_id in (146,179,240,242,245,247,254,256,
266,267,278,285,292,293,332,351,405,428)) 

-- query to deenroll 18 students in rscs 
update tcourse_evaluation_rel_stu_courses set rscs_deleted='Y'
where rscs_cpse_id=916 and rscs_deleted='N' and rscs_id in 
(select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_deleted='N' and rscs_cpse_id=916 and rscs_stu_id in (146,179,240,242,245,247,254,256,
266,267,278,285,292,293,332,351,405,428)) 

-- query to select data of project management as students are to be deenrolled
select scse_id, rscs_id, rscs_stu_id, scse_deleted,rscs_deleted from tcourse_evaluation_rel_stu_courses join 
exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=916 and rscs_course_type='C' and 
rscs_stu_id in (146,179,240,242,245,247,254,256,266,267,278,285,292,293,332,351,405,428)

-- project management 18 students
select * from exams_mst_students where stud_id in (146,179,240,242,245,247,254,256,
266,267,278,285,292,293,332,351,405,428)

***************************************************************************************************************************************************
--Dt: 09/06/16
--select cbcs course details whose marks are entered today 
select stud_enrollment_number as "Enrollment Number", stud_fname as "Student First Name", stud_lname as "Student Last Name", sch_name as "School Name", prog_name as "Programme Name",cour_code_sec as "Course Code",cour_name as "Course Name",
CASE WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='Y' THEN REPLACE(scse_isconfirm,'Y','Confirmed') 
	WHEN scse_gpa_actual is not null and scse_course_result is not null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','Saved') 
	WHEN scse_gpa_actual is null and scse_course_result is not null and scse_isconfirm is not null THEN 
		CASE WHEN scse_isconfirm='N' and scse_course_result='F' and scse_isabsent='Y' THEN REPLACE (scse_isconfirm,'N','Absent') 
			WHEN scse_isconfirm='N' and scse_course_result ='' THEN REPLACE(scse_isconfirm,'N','No Marks') 
			ELSE REPLACE(scse_isconfirm,'Y','Absent') 
		END 
	ELSE 'NO DATA' 
END as "Marks Status",scse_gpa_actual as "GPA", scse_course_result as "Result", scse_last_modified_datetime as "Last Modified",empl_fname as "Employee First Name",empl_lname as "Employee Last Name"
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=rscs_cpse_id 
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_rel_campus_school_programes_courses on rcp_cour_id=rscs_course_id and rcp_prog_id=83
inner join exams_mst_courses on rcp_cour_id=cour_id
inner join exams_mst_schools on sch_id=rcp_school_id 
inner join exams_mst_employees on empl_id=scse_last_modified_empl_id
where rscs_deleted='N' and stud_deleted='N' and stud_status='OnRole' and rscs_course_type='C' and cpse_cour_type='C' and scse_deleted='N' and cpse_deleted='N' and rscs_sem_id=2 and rscs_batch_id=1 and scse_last_modified_datetime > '2016-06-09'
order by prog_name,cour_name,stud_enrollment_number

-- query to sum up first and second sem gpa
select rscs_stu_id, stud_enrollment_number, stud_fname,ssem,fsem, sum(ssem+fsem) from (
select rscs_stu_id ,stud_enrollment_number,stud_fname,sum(scse_gpa_actual*cpse_credits) ,sum(cpse_credits), 
round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),1) as ssem ,
(select round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),1)
from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students 
where scse_rscs_id=rscs_id and rscs_stu_id=1246 and rscs_cpse_id=cpse_id and scse_cpse_id=rscs_cpse_id and ((scse_gpa_actual is not null 
and scse_isabsent='N')or(scse_gpa_actual is null and scse_isabsent='Y'))and scse_course_type <> 'AU' 
and scse_course_type <>'EC' and scse_course_type <>'NC' and rscs_stu_id=stud_id  and rscs_sem_id=1 
and scse_deleted='N' and scse_course_attempt ='Re'group by rscs_stu_id ,stud_enrollment_number,stud_fname order by rscs_stu_id)as "fsem"
from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students 
where scse_rscs_id=rscs_id and rscs_stu_id=1246 and rscs_cpse_id=cpse_id and scse_cpse_id=rscs_cpse_id and ((scse_gpa_actual is not null 
and scse_isabsent='N')or(scse_gpa_actual is null and scse_isabsent='Y'))and scse_course_type <> 'AU' 
and scse_course_type <>'EC' and scse_course_type <>'NC' and rscs_stu_id=stud_id  and rscs_sem_id=2 
and scse_deleted='N' and scse_course_attempt ='Re'group by rscs_stu_id ,stud_enrollment_number,stud_fname order by rscs_stu_id) as derivedtable 
group by rscs_stu_id,stud_enrollment_number, stud_fname,ssem,fsem

**************************************************************************************************************************
--11/06/16 query for searching the permissions given to 2 secretariats (pratima and thamilarasi) after inserting their 5 optional courses in mst and rcp returned 52 rows
select * from exams_rel_employees_activities_permissions where emap_last_modified_datetime > '2016-06-10' order by emap_empl_id, emap_rcp_id, emap_acti_id


-- Dt: 16/06/16 query to search the secretarits of all campusses
select campus_name,empl_id,sch_name,empl_email,role_name--,prog_name 
from exams_mst_employees 
inner join exams_mst_schools on empl_school_centre_id=sch_id
inner join exams_mst_campus on empl_campus_id=campus_id
inner join exams_mst_roles on empl_role_id=role_id
inner join exams_rel_campus_school_programes_courses on rcp_campus_id=empl_campus_id and sch_id=rcp_school_id
--inner join exams_mst_programs on rcp_prog_id=prog_id
where empl_role_id=3 and empl_is_admin='N' and empl_deleted='N' and rcp_deleted='N' 
group by campus_name,empl_id,sch_name,empl_email,role_name--,prog_name
--or
select empl_id,empl_fname,empl_lname,campus_name,sch_name,empl_email,role_name--,prog_name 
from exams_mst_employees 
inner join exams_mst_schools on empl_school_centre_id=sch_id
inner join exams_mst_campus on empl_campus_id=campus_id
inner join exams_mst_roles on empl_role_id=role_id
inner join exams_rel_campus_school_programes_courses on rcp_campus_id=empl_campus_id and sch_id=rcp_school_id
inner join exams_mst_programs on rcp_prog_id=prog_id
where empl_role_id=3 and empl_is_admin='N' and empl_deleted='N' and rcp_deleted='N' 
group by campus_name,empl_id,sch_name,empl_email,role_name--,prog_name
order by empl_id

-- query to find the students who are failed in CBCS courses in 2015-17 2nd sem returned 16 rows

select prog_name,stud_enrollment_number, stud_id,stud_fname ,scse_gpa_actual,scse_isabsent from exams_rel_students_courses_semesters 
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_programs on stud_prog_id=prog_id
where scse_deleted='N' and scse_course_type='C' and scse_gpa_actual < 4 order by prog_name
--or
select * from exams_rel_students_courses_semesters where scse_deleted='N' and scse_course_type='C' and scse_gpa_actual < 4 order by scse_cpse_id
--query end

--query to see the programs allowed to secretariats
select campus_name,empl_id,sch_name,empl_email,role_name,prog_name 
from exams_mst_employees 
inner join exams_mst_schools on empl_school_centre_id=sch_id
inner join exams_mst_campus on empl_campus_id=campus_id
inner join exams_mst_roles on empl_role_id=role_id
inner join exams_rel_campus_school_programes_courses on rcp_campus_id=empl_campus_id and sch_id=rcp_school_id
inner join exams_mst_programs on rcp_prog_id=prog_id
where empl_role_id=3 and empl_is_admin='N' and empl_deleted='N' and rcp_deleted='N' 
group by campus_name,empl_id,sch_name,empl_email,role_name,prog_name
order by campus_name,sch_name

--query to search the marks of 2 students MAWS failed students
select sum(Credits) AS credit123 from (
select scse_id,scse_gpa_actual,scse_course_attempt,scse_course_result,scse_cpse_id,cpse_credits,sum(scse_gpa_actual*cpse_credits) AS Credits
from tcourse_evaluation_rel_stu_courses 
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id
where rscs_deleted='N' AND rscs_sem_id=1 AND rscs_batch_id=1 AND rscs_stu_id=540 AND scse_id!=639
group by scse_id,scse_gpa_actual,scse_course_attempt,scse_course_result,scse_cpse_id,cpse_credits)AS derivedTable    

***************************************************************************************************************************************************
--Dt. 23/06/16 final query to check students failed excluding cbcs courses

select stud_id,stud_enrollment_number,stud_fname,stud_lname,prog_name,scse_gpa_actual,cpse_credits,
stud_acba_id,scse_course_type,stud_sem_id from exams_rel_students_courses_semesters inner join 
tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id inner join exams_rel_courses_programes_semesters 
on cpse_id=rscs_cpse_id inner join exams_mst_students on rscs_stu_id=stud_id inner join exams_mst_programs 
on stud_prog_id=prog_id where scse_semester_attempt='2' and scse_course_result='F' and scse_deleted='N' 
and scse_course_attempt='Re' and (scse_gpa_actual < 4 or scse_gpa_actual is null) and rscs_deleted='N' and rscs_batch_id=1 and rscs_sem_id=2 
and scse_course_type <> 'C' and scse_isconfirm='Y' and stud_status='OnRole' and stud_deleted='N'
order by stud_enrollment_number,stud_prog_id 

--Query to search 1st sem data for a specific student based on enrollment number
select stud_enrollment_number,stud_fname,stud_lname,cour_name,scse_gpa_actual,cpse_credits,scse_course_result, scse_course_attempt
from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on cpse_cour_id=cour_id
where scse_deleted='N' and scse_semester_attempt='1' and rscs_sem_id=1 and scse_cpse_id=rscs_cpse_id and rscs_deleted='N' 
and stud_status='OnRole' and rscs_stu_id=stud_id and stud_enrollment_number='H2014BAMA013'
order by stud_enrollment_number, cour_name


select distinct(prog_name)
--stud_id,stud_enrollment_number,stud_fname,stud_lname,distinct(prog_name),scse_gpa_actual,cpse_credits,stud_acba_id,scse_course_type,stud_sem_id
 from exams_rel_students_courses_semesters inner join 
tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id inner join exams_rel_courses_programes_semesters 
on cpse_id=rscs_cpse_id inner join exams_mst_students on rscs_stu_id=stud_id inner join exams_mst_programs 
on stud_prog_id=prog_id where scse_semester_attempt='2' and scse_course_result='F' and scse_deleted='N' 
and scse_course_attempt='Re' and (scse_gpa_actual < 4 or scse_gpa_actual is null) and rscs_deleted='N' and rscs_batch_id=1 and rscs_sem_id=2 
and scse_course_type <> 'C' and scse_isconfirm='Y' and stud_status='OnRole' and stud_deleted='N'
--order by stud_enrollment_number,stud_prog_id
 group by prog_name

select scse_id,scse_rscs_id, scse_cpse_id, scse_isabsent, scse_letter_grade, scse_gpa_rounded, scse_course_type, scse_course_attempt, scse_course_result 
from exams_rel_students_courses_semesters where scse_rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses 
where rscs_stu_id in (237)) and scse_course_attempt='Re' and scse_deleted='N' and scse_semester_attempt='2'

select rscs_stu_id ,stud_enrollment_number,stud_fname,sum(scse_gpa_actual*cpse_credits) ,sum(cpse_credits),
round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),1) from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students where scse_rscs_id=rscs_id and rscs_stu_id=237 and rscs_cpse_id=cpse_id and scse_cpse_id=rscs_cpse_id and ((scse_gpa_actual is not null and scse_isabsent='N')or(scse_gpa_actual is null and scse_isabsent='Y'))and scse_course_type <> 'AU' and scse_course_type <>'EC' and scse_course_type <>'NC' and scse_course_type <>'C' and rscs_stu_id=stud_id  and rscs_sem_id in (1,2) and scse_deleted='N' and(scse_rscs_id,scse_id ) in (select scse_rscs_id , first_value(scse_id) over (partition by scse_rscs_id, scse_cpse_id order by case when scse_course_attempt in ('S1','Re','R','I','S2') then 1 else 2 end , scse_id desc) from  exams_rel_students_courses_semesters)and scse_rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id=237)and scse_rscs_id in (select scse_rscs_id from exams_rel_students_courses_semesters)group by rscs_stu_id ,stud_enrollment_number,stud_fname order by rscs_stu_id

***************************************************************************************************************************************************
--Dt. 05/07/2016 queries to update data in cpse and scse tables of specified program
-- scse updation
update exams_rel_students_courses_semesters set scse_isconfirm ='N' ,scse_last_modified_datetime='2016-07-05 14:30:22.574712+05:30' where scse_cpse_id in 
(select distinct scse_cpse_id from exams_rel_students_courses_semesters where scse_cpse_id in 
(select cpse_id from exams_rel_courses_programes_semesters
where cpse_prog_id=5 and cpse_deleted='N') and scse_deleted='N' order by scse_cpse_id)

select distinct scse_cpse_id from exams_rel_students_courses_semesters where scse_cpse_id in 
(select cpse_id from exams_rel_courses_programes_semesters
where cpse_prog_id=5 and cpse_deleted='N') and scse_deleted='N' order by scse_cpse_id

--cpse updation
update exams_rel_courses_programes_semesters  set cpse_isconfirm ='N' ,cpse_last_modified_datetime='2016-07-05 14:30:22.574712+05:30' where cpse_id in (select cpse_id from exams_rel_courses_programes_semesters
where cpse_prog_id=5 and cpse_deleted='N')

--query to select cbcs students of 2nd sem who are not OnRole
select stud_fname, stud_lname, stud_status from exams_mst_students ,tcourse_evaluation_rel_stu_courses 
where rscs_id in (select scse_rscs_id from exams_rel_students_courses_semesters where scse_course_type='C' and scse_semester_attempt='2' and scse_deleted='N')
and rscs_stu_id=stud_id and stud_status!='OnRole'

***************************************************************************************************************************************************
--Dt. updation in query to search sem marks
select stud_enrollment_number,stud_fname,stud_lname,cour_name,scse_gpa_actual,cpse_credits,scse_course_result, scse_course_attempt,scse_course_type,scse_semester_attempt
from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on cpse_cour_id=cour_id
where scse_deleted='N' and scse_semester_attempt='1' and rscs_sem_id=1 and scse_cpse_id=rscs_cpse_id and rscs_deleted='N' 
and stud_status='OnRole' and rscs_stu_id=stud_id and stud_enrollment_number='M2015HRM066'
order by stud_enrollment_number, cour_name

***************************************************************************************************************************************************
--Dt. 
select prog_id,prog_name from exams_mst_programs where prog_id in (
select distinct rcp_prog_id from exams_rel_campus_school_programes_courses,exams_mst_programs where rcp_school_id=1 and rcp_prog_id not in (83,17,18))

-- 9 programs of social work excluding CBCS and online programs

select prog_id,prog_name from exams_mst_programs where prog_id in (
select distinct rcp_prog_id from exams_rel_campus_school_programes_courses,exams_mst_programs where rcp_school_id=1 and rcp_prog_id not in (83,17,18))

***************************************************************************************************************************************************

select distinct stud_id ,stud_enrollment_number,prog_id,prog_name,stud_fname, stud_lname, sum(cpse_credits) as "CR",
--CASE WHEN count (scse_cpse_id) > 1 and scse_deleted='N' then (select sum(scse_gpa_actual*cpse_credits) from exams_rel_students_courses_semesters where scse_ )
--	else 
--sum(CASE WHEN (count(scse_cpse_id)>1 and count(scse_rscs_id)>1) and scse_deleted='N' then  
--ELSE 
sum(scse_gpa_actual*cpse_credits) as "SemGrades",round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),3) as "FinalGPsem"
from exams_rel_students_courses_semesters
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and scse_cpse_id=rscs_cpse_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_deleted='N' and stud_status='OnRole' and scse_semester_attempt in ('1','2') and scse_deleted='N' and cpse_deleted='N' and scse_course_attempt in ('Re','R') and scse_course_result='P' and cpse_prog_id=2
and scse_course_type <> 'AU' and scse_course_type <>'EC' and scse_course_type <>'NC' and scse_course_type <>'C' and
rscs_stu_id not in (
select distinct rscs_stu_id from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id
where rscs_deleted='N' and cpse_deleted='N' and cpse_prog_id=2 and rscs_stu_id not in (
select distinct rscs_stu_id from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id
where rscs_deleted='N' and cpse_deleted='N' and 
(scse_course_result='P'  and scse_course_attempt='R') and cpse_prog_id=2 and scse_semester_attempt in ('1','2') order by rscs_stu_id)
and
((scse_gpa_actual < 4 or scse_course_result='F') and scse_course_attempt in ('Re','R')) and scse_semester_attempt in ('1','2') order by rscs_stu_id
)
group by stud_id ,stud_enrollment_number,prog_id,prog_name,stud_fname, stud_lname
order by stud_id 

-----query for searching max value data
select scse_id,scse_cpse_id ,sum(scse_gpa_actual*cpse_credits),scse_gpa_actual,cpse_credits from exams_rel_students_courses_semesters inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id inner join
-- query to search 
(select scse_cpse_id as "sc",scse_rscs_id as "sr",max(scse_gpa_actual) as "mv" from exams_rel_students_courses_semesters 
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
where scse_course_attempt in ('Re','R') and scse_course_type <> 'AU' and 
scse_course_type <>'EC' and scse_semester_attempt in ('1','2') and scse_course_type <>'NC' and scse_course_type <>'C' and scse_deleted='N' --and --rscs_stu_id=8
and (scse_cpse_id=scse_cpse_id and scse_rscs_id=scse_rscs_id) and cpse_prog_id=2 and cpse_acba_id=1
group by scse_cpse_id,scse_rscs_id ) as dertable on scse_cpse_id=sc and scse_rscs_id=sr and scse_gpa_actual=mv group by scse_id,scse_cpse_id,scse_gpa_actual,cpse_credits


-----fianl query for searching max values
select sum(cpse_credits),sum(scse_gpa_actual*cpse_credits),round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),3) 
from exams_rel_students_courses_semesters inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id inner join
-- query to search 
(select scse_cpse_id as "sc",scse_rscs_id as "sr",max(scse_gpa_actual) as "mv" from exams_rel_students_courses_semesters 
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
where scse_course_attempt in ('Re','R') and scse_course_type <> 'AU' and 
scse_course_type <>'EC' and scse_semester_attempt in ('1','2') and scse_course_type <>'NC' and scse_course_type <>'C' and scse_deleted='N' and rscs_stu_id=8
and (scse_cpse_id=scse_cpse_id and scse_rscs_id=scse_rscs_id) --and cpse_prog_id=2 and cpse_acba_id=1 
and rscs_stu_id=rscs_stu_id
group by scse_cpse_id,scse_rscs_id ) as dertable on scse_cpse_id=sc and scse_rscs_id=sr and scse_gpa_actual=mv 


***************************************************************************************************************************************************
--Dt. 15/07/16 query to update the students semesters of mumbai campus
update exams_mst_students set stud_sem_id=3 where stud_id in
(select distinct stud_id--,stud_enrollment_number,stud_fname,stud_lname,prog_name,stud_sem_id 
from exams_mst_students
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_rel_courses_programes_semesters on cpse_prog_id=stud_prog_id
where stud_deleted='N' and stud_status='OnRole' and stud_sem_id=2 and stud_campus_id=1 and cpse_prog_id=stud_prog_id order by stud_id)

***************************************************************************************************************************************************
---Final query searching the scholarship details of only mumbai sampus students passed in regular or revaluation of 15-17 batch
select stud_id as "Stud_Id",prog_name as "Program Name",stud_enrollment_number as "Student Enrollment Number",stud_fname as "First Name",stud_lname as "Last Name",stud_gender as "Gender",sum(scse_gpa_actual*cpse_credits) as "Total Grade" ,sum(cpse_credits) as "Total Credits",
round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),1) as "GPA",round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),3) as "GPA3Dec" 
from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students,exams_mst_programs 
where scse_rscs_id=rscs_id and stud_prog_id=prog_id and stud_acba_id=1 and stud_campus_id=1 and --cpse_prog_id=3 and 
rscs_stu_id not in (
select distinct rscs_stu_id from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id

where rscs_deleted='N' and cpse_deleted='N' --and cpse_prog_id=3
and rscs_stu_id not in (
select distinct rscs_stu_id from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id
where rscs_deleted='N' and cpse_deleted='N' and 
(scse_course_result='P' and scse_course_attempt='R') --and cpse_prog_id in (2,33,34,35,36,37,38,39,40) 
and scse_semester_attempt in ('1','2') order by rscs_stu_id)
and ((scse_gpa_actual < 4 or scse_course_result='F') and scse_course_attempt in ('Re','R')) and scse_semester_attempt in ('1','2') order by rscs_stu_id
)
--and rscs_stu_id=8 
and rscs_cpse_id=cpse_id and scse_cpse_id=rscs_cpse_id and (scse_course_result='P' and scse_course_attempt in ('Re','R'))
and ((scse_gpa_actual is not null and scse_isabsent='N')or(scse_gpa_actual is null and scse_isabsent='Y'))and scse_course_type <> 'AU' 
and scse_course_type <>'EC' and scse_course_type <>'NC' and scse_course_type <>'C' and rscs_stu_id=stud_id  and rscs_sem_id in (1,2) and scse_deleted='N' 
and(scse_rscs_id,scse_id ) in (
select scse_rscs_id , first_value(scse_id) over (partition by scse_rscs_id, scse_cpse_id order by case when scse_course_attempt in ('Re','R') 
then 1 else 2 end , scse_id desc) from  exams_rel_students_courses_semesters)
and scse_rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses --where rscs_stu_id=8
)
and scse_rscs_id in (select scse_rscs_id from exams_rel_students_courses_semesters)
group by stud_id ,prog_name,stud_enrollment_number,stud_fname,stud_lname,stud_gender 
order by stud_id

---query showing only mumbai MA 15-17 data

--Dt. 15/07/16 data mumbai campus MA programs
select stud_id as "Stud_Id",prog_name as "Program Name",stud_enrollment_number as "Student Enrollment Number",stud_fname as "First Name",stud_lname as "Last Name",stud_gender as "Gender",sum(scse_gpa_actual*cpse_credits) as "Total Grade" ,sum(cpse_credits) as "Total Credits",
round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),1) as "GPA",round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),3) as "GPA3Dec" 
from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students,exams_mst_programs 
where scse_rscs_id=rscs_id and stud_prog_id=prog_id and stud_acba_id=1 and stud_campus_id=1 and prog_prty_id=1 and --cpse_prog_id=3 and 
rscs_stu_id not in (
select distinct rscs_stu_id from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id

where rscs_deleted='N' and cpse_deleted='N' --and cpse_prog_id=3
and rscs_stu_id not in (
select distinct rscs_stu_id from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id
where rscs_deleted='N' and cpse_deleted='N' and 
(scse_course_result='P' and scse_course_attempt='R') --and cpse_prog_id in (2,33,34,35,36,37,38,39,40) 
and scse_semester_attempt in ('1','2') order by rscs_stu_id)
and ((scse_gpa_actual < 4 or scse_course_result='F') and scse_course_attempt in ('Re','R')) and scse_semester_attempt in ('1','2') order by rscs_stu_id
)
--and rscs_stu_id=8 
and rscs_cpse_id=cpse_id and scse_cpse_id=rscs_cpse_id and (scse_course_result='P' and scse_course_attempt in ('Re','R'))
and ((scse_gpa_actual is not null and scse_isabsent='N')or(scse_gpa_actual is null and scse_isabsent='Y'))and scse_course_type <> 'AU' 
and scse_course_type <>'EC' and scse_course_type <>'NC' and scse_course_type <>'C' and rscs_stu_id=stud_id  and rscs_sem_id in (1,2) and scse_deleted='N' 
and(scse_rscs_id,scse_id ) in (
select scse_rscs_id , first_value(scse_id) over (partition by scse_rscs_id, scse_cpse_id order by case when scse_course_attempt in ('Re','R') 
then 1 else 2 end , scse_id desc) from  exams_rel_students_courses_semesters)
and scse_rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses --where rscs_stu_id=8
)
and scse_rscs_id in (select scse_rscs_id from exams_rel_students_courses_semesters)
group by stud_id ,prog_name,stud_enrollment_number,stud_fname,stud_lname,stud_gender 
order by stud_id
***************************************************************************************************************************************************
-----ultimate query
select distinct stud_id ,stud_enrollment_number,prog_id,prog_name,stud_fname, stud_lname,
sum(cpse_credits) as "Credits",sum(scse_gpa_actual*cpse_credits) as "Grand Total GP",round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),3) as "GPA"
from exams_rel_students_courses_semesters 
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id 
 inner join
-- query to search 
(select scse_cpse_id as "sc",scse_rscs_id as "sr",max(scse_gpa_actual) as "mv" from exams_rel_students_courses_semesters 
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
where scse_course_attempt in ('Re','R') and scse_course_type <> 'AU' and 
scse_course_type <>'EC' and scse_semester_attempt in ('1','2') and scse_course_type <>'NC' and scse_course_type <>'C' and scse_deleted='N' --and scse_rscs_id=2071
and (scse_cpse_id=scse_cpse_id and scse_rscs_id=scse_rscs_id) and cpse_prog_id=3 --cpse_prog_id in (2,33,34,35,36,37,38,39,40)
and cpse_acba_id=1 
and rscs_stu_id=rscs_stu_id
group by scse_cpse_id,scse_rscs_id ) as dertable on scse_cpse_id=sc and scse_rscs_id=sr and scse_gpa_actual=mv 

inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_status='OnRole' and stud_deleted='N' and rscs_deleted='N' and scse_deleted='N'

and rscs_stu_id not in (
select distinct rscs_stu_id from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id
where rscs_deleted='N' and cpse_deleted='N' and cpse_prog_id=3 
and rscs_stu_id not in (
select distinct rscs_stu_id from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id
where rscs_deleted='N' and cpse_deleted='N' and 
(scse_course_result='P'  and scse_course_attempt='R') and cpse_prog_id =3 --cpse_prog_id in (2,33,34,35,36,37,38,39,40) 
and scse_semester_attempt in ('1','2') order by rscs_stu_id)
and ((scse_gpa_actual < 4 or scse_course_result='F') and scse_course_attempt in ('Re','R')) and scse_semester_attempt in ('1','2') order by rscs_stu_id
)
and cpse_deleted='N' and scse_course_attempt in ('Re','R') and scse_course_result='P' and cpse_prog_id=3
and scse_course_type <> 'AU' and scse_course_type <>'EC' and scse_course_type <>'NC' and scse_course_type <>'C'

group by stud_id ,stud_enrollment_number,prog_id,prog_name,stud_fname, stud_lname
order by prog_id,stud_id






select stud_enrollment_number,stud_fname,stud_lname,cour_name,scse_gpa_actual,cpse_credits,scse_course_result,scse_letter_grade, scse_id,scse_cpse_id,scse_rscs_id,scse_cpse_id,scse_course_attempt,scse_course_type,scse_semester_attempt
from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on cpse_cour_id=cour_id
where scse_deleted='N' and scse_semester_attempt='1' and rscs_sem_id=1 
and scse_cpse_id=rscs_cpse_id and rscs_deleted='N' 
and stud_status='OnRole' and rscs_stu_id=stud_id and stud_enrollment_number='M2015HE004' and scse_course_type='M' --and scse_course_attempt in ('Re','R')
order by stud_enrollment_number, cour_name


select scse_id,rscs_stu_id ,stud_enrollment_number,scse_cpse_id,scse_gpa_actual,scse_course_attempt 
from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students 
where scse_deleted='N' and scse_isconfirm='Y' and scse_rscs_id=rscs_id and rscs_stu_id =343 and rscs_cpse_id=cpse_id and scse_cpse_id=rscs_cpse_id
and ((scse_gpa_actual is not null and scse_isabsent='N')or(scse_gpa_actual is null and scse_isabsent='Y'))and rscs_stu_id=stud_id and rscs_sem_id in (1,2)
and scse_deleted='N' and(scse_rscs_id,scse_id ) in (select scse_rscs_id , first_value(scse_id) over (partition by scse_rscs_id, scse_cpse_id 
order by case when scse_course_attempt in ('R','Re','S1','I','S2') then 1 else 2 end , scse_id desc) 
from  exams_rel_students_courses_semesters where scse_deleted='N')and scse_rscs_id in 
(select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id = 343)
and scse_rscs_id in (select scse_rscs_id from exams_rel_students_courses_semesters where scse_deleted='N')order by rscs_stu_id


--problem q
select max(scse_id),sum(cpse_credits),sum(scse_gpa_actual*cpse_credits),round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),3) 
from exams_rel_students_courses_semesters inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id inner join
-- query to search 
(select scse_cpse_id as "sc",scse_rscs_id as "sr", max(scse_gpa_actual) as "mv"--,scse_course_attempt as "ca" 
from exams_rel_students_courses_semesters 
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
where scse_course_attempt in ('Re','R') and scse_course_type <> 'AU' and 
scse_course_type <>'EC' and scse_semester_attempt in ('1','2') and scse_course_type <>'NC' and scse_course_type <>'C' and scse_deleted='N' and rscs_stu_id=343
and (scse_cpse_id=scse_cpse_id and scse_rscs_id=scse_rscs_id) and cpse_prog_id=3 and cpse_acba_id=1 
and rscs_stu_id=rscs_stu_id
group by scse_cpse_id,scse_rscs_id,scse_gpa_actual
) as dertable on scse_cpse_id=sc and scse_rscs_id=sr and scse_gpa_actual=mv --and scse_course_attempt=ca
where scse_course_attempt in ('Re','R') and scse_course_type <> 'AU' and
scse_course_type <>'EC' and scse_semester_attempt in ('1','2') and scse_course_type <>'NC' and scse_course_type <>'C' and scse_deleted='N'
group by scse_id
--problem q



select rscs_stu_id ,stud_enrollment_number,stud_fname,sum(scse_gpa_actual*cpse_credits) ,sum(cpse_credits),round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),1) 
from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students 
where scse_deleted='N' and scse_rscs_id=rscs_id and rscs_stu_id=343 
and rscs_cpse_id=cpse_id and scse_cpse_id=rscs_cpse_id 
and ((scse_gpa_actual is not null and scse_isabsent='N')or(scse_gpa_actual is null and scse_isabsent='Y'))and scse_course_type <> 'AU' 
and scse_course_type <>'EC' and scse_course_type <>'NC' and rscs_stu_id=stud_id  and rscs_sem_id in (1,2) and scse_deleted='N' 
and rscs_stu_id not in (
select distinct rscs_stu_id from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id
inner join exams_mst_students on stud_prog_id=cpse_prog_id and stud_status='OnRole' and stud_deleted='N'
where rscs_deleted='N' and cpse_deleted='N' and cpse_prog_id=3 
/*and rscs_stu_id not in (
select distinct rscs_stu_id from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id
where rscs_deleted='N' and cpse_deleted='N' and 
(scse_course_result='P'  and scse_course_attempt='R') and cpse_prog_id =3 --cpse_prog_id in (2,33,34,35,36,37,38,39,40) 
and scse_semester_attempt in ('1','2') order by rscs_stu_id)*/
and ((scse_gpa_actual < 4 or scse_course_result='F') and scse_course_attempt in ('Re','R')) and scse_semester_attempt in ('1','2') order by rscs_stu_id
)
and(scse_rscs_id,scse_id ) 
in (
select scse_rscs_id , first_value(scse_id) 
over 
(partition by scse_rscs_id, scse_cpse_id 
order by 
case when scse_course_attempt in ('Re') then 1 
     else 2 end , scse_id desc) 
from  exams_rel_students_courses_semesters 
where scse_deleted='N' and scse_rscs_id in (2301,3375,3454,1969,2755,2071,3340,2403,2368,2138,1934,2004,1899) 
)
and scse_rscs_id in 
(select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id=343
)and scse_rscs_id in (select scse_rscs_id 
from exams_rel_students_courses_semesters where scse_deleted='N')
group by rscs_stu_id ,stud_enrollment_number,stud_fname order by rscs_stu_id

---query to search students of mumbai campus for updation
select exams_mst_students.* from exams_mst_students
inner join exams_rel_courses_programes_semesters on cpse_prog_id=stud_prog_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_rel_campus_school_programes_courses on rcp_prog_id=prog_id
where rcp_campus_id=1 and stud_deleted='N' and stud_status='OnRole' and stud_sem_id=cpse_seme_id and cpse_seme_id=2




select stud_id from exams_mst_students
inner join exams_rel_courses_programes_semesters on cpse_prog_id=stud_prog_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_rel_campus_school_programes_courses on rcp_prog_id=prog_id
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id= stud_id
where rcp_campus_id=1 and stud_deleted='N' and stud_status='OnRole' and stud_sem_id=cpse_seme_id and cpse_seme_id=2 and rscs_deleted='N'



**************************************************************************************************************************************************

--rough query for 2nd export to excel - modified
select distinct (stud_enrollment_number),stud_fname,stud_lname,sch_name,prog_name,acba_name,seme_name,cour_code_sec,cour_name,
CASE
	WHEN scse_course_result is not null and scse_isconfirm='Y' THEN REPLACE(scse_isconfirm,'Y','Confirmed') 
	WHEN scse_course_result is not null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','Saved') 
	--WHEN scse_gpa_actual is null and scse_course_result is not null and scse_isconfirm is not null THEN 
	--WHEN scse_gpa_actual is null and scse_course_result is not null and scse_isconfirm is not null THEN 'No Marks'
	/*CASE 
		--WHEN scse_isconfirm='N' and scse_course_result='F' and scse_isabsent='Y' THEN REPLACE (scse_isconfirm,'N','Absent') 
		WHEN scse_isconfirm='N' and scse_course_result ='' THEN REPLACE(scse_isconfirm,'N','No Marks') 
		ELSE REPLACE(scse_isconfirm,'Y','Absent') 
	END*/  
ELSE 'NO DATA' 
END as scse_isconfirm, 
CASE 
	---WHEN scse_gpa_actual is not null then scse_gpa_actual
	WHEN scse_gpa_actual is null and scse_isconfirm ='Y' and scse_isabsent='Y' THEN 'Absent'
	--WHEN scse_isconfirm ='Y' and scse_isabsent='Y' THEN CONVERT(scse_gpa_actual AS VARCHAR(20))
	---WHEN scse_gpa_actual is not null then scse_gpa_actual
	--WHEN scse_gpa_actual is null and scse_isconfirm ='Y' and scse_isabsent='Y' THEN REPLACE (CONVERT (scse_gpa_actual),'','Absent') 
ELSE CONVERT (VARCHAR(20) , CONVERT (NUMERIC(3,1),scse_gpa_actual),
END as scse_gpa_actual, scse_course_result from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id 
inner join exams_mst_courses on rscs_course_id=cour_id inner join exams_mst_programs on stud_prog_id=prog_id 
inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id 
inner join exams_mst_academic_batches on rscs_batch_id=acba_id inner join exams_mst_semesters on rscs_sem_id=seme_id 
inner join exams_mst_schools on rcp_school_id=sch_id inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
where rscs_deleted='N' and rscs_course_type='C' and rscs_sem_id=2 and rscs_batch_id=1 and rcp_school_id=1 
and scse_deleted='N' and scse_course_type='C'and rcp_deleted='N' and cpse_deleted='N' and cpse_cour_type='C' 
and stud_status='OnRole' and stud_deleted='N' order by prog_name,cour_name,stud_enrollment_number

--select the year where month is > than 11
select stud_id,EXTRACT (YEAR from stud_created_datetime) from exams_mst_students where EXTRACT (MONTH from stud_created_datetime) >11 and stud;

-- query for selecting failed students based on cpseid
select * from exams_rel_students_courses_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students 
where scse_rscs_id=rscs_id and rscs_stu_id=stud_id and scse_course_attempt='Re' and scse_cpse_id=917 
and (scse_gpa_actual<=4 or scse_isabsent='Y') and (scse_rscs_id,scse_cpse_id) not in (select scse_rscs_id,scse_cpse_id from exams_rel_students_courses_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students 
where scse_rscs_id=rscs_id and rscs_stu_id=stud_id and (scse_course_attempt='R' or scse_course_attempt='I') and scse_cpse_id=917 
and (scse_gpa_actual>=4 or scse_isabsent='Y')
order by stud_enrollment_number)
order by stud_enrollment_number

**************************************************************************************************************************************************

--Dt.25/7/16 query to search the course and its confirmed/unconfirmed status
select distinct cour_name, CASE WHEN scse_isconfirm='Y' then REPLACE (scse_isconfirm,'Y', 'Confirmed')
WHEN scse_isconfirm='N' then REPLACE (scse_isconfirm,'N','Unconfirmed')
END scse_isconfirm,CASE WHEN cpse_isconfirm='Y' then REPLACE (cpse_isconfirm,'Y', 'Confirmed')
WHEN cpse_isconfirm='N' then REPLACE (cpse_isconfirm,'N','Unconfirmed')
END cpse_isconfirm from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters, exams_mst_courses
where scse_cpse_id=cpse_id and cpse_cour_id=cour_id and scse_deleted='N' and cpse_prog_id=2  and cpse_seme_id =2 order by cour_name

---very important query to search and display numeric value after converting it into varchar and displaying numeric where not empty otherwise string
select distinct (stud_enrollment_number),stud_fname,stud_lname,sch_name,prog_name,acba_name,seme_name,cour_code_sec,cour_name,
CASE
	WHEN scse_course_result is not null and scse_isconfirm='Y' THEN REPLACE(scse_isconfirm,'Y','Confirmed') 
	WHEN scse_course_result is not null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','Saved') 
	--WHEN scse_gpa_actual is null and scse_course_result is not null and scse_isconfirm is not null THEN 
	--WHEN scse_gpa_actual is null and scse_course_result is not null and scse_isconfirm is not null THEN 'No Marks'
	/*CASE 
		--WHEN scse_isconfirm='N' and scse_course_result='F' and scse_isabsent='Y' THEN REPLACE (scse_isconfirm,'N','Absent') 
		WHEN scse_isconfirm='N' and scse_course_result ='' THEN REPLACE(scse_isconfirm,'N','No Marks') 
		ELSE REPLACE(scse_isconfirm,'Y','Absent') 
	END*/  
ELSE 'NO DATA' 
END as scse_isconfirm, 
CASE 
	WHEN scse_gpa_actual is not null then cast (scse_gpa_actual as varchar) 
	WHEN scse_gpa_actual is null and scse_isconfirm='N' THEN COALESCE (NULLIF(cast (scse_gpa_actual as varchar(10)),''),'No Marks')
	WHEN scse_gpa_actual is null and scse_isconfirm='Y' THEN COALESCE (NULLIF(cast (scse_gpa_actual as varchar(10)),''),'ABSENT')
	--WHEN scse_gpa_actual is null and scse_isconfirm ='Y' and scse_isabsent='Y' THEN 'Absent'
	--when scse_gpa_actual is null or scse_gpa_actual=0 and scse_isconfirm ='Y' THEN TO_CHAR(scse_gpa_actual,'"Absent:"scse_gpa_actual') as '1'
	--WHEN scse_isconfirm ='Y' and scse_isabsent='Y' THEN CONVERT(scse_gpa_actual VARCHAR(20))
	---WHEN scse_gpa_actual is not null then scse_gpa_actual
	  --REPLACE (CONVERT(varchar(10),scse_gpa_actual,''),'','Absent') 
--ELSE CONVERT (VARCHAR(20) , CONVERT (NUMERIC(3,1),scse_gpa_actual),
	--when scse_isconfirm='Y' THEN COALESCE(scse_gpa_actual,REPLACE (CONVERT (scse_gpa_actual::text),'','Absent'))
END as scse_gpa_actual, scse_course_result from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id 
inner join exams_mst_courses on rscs_course_id=cour_id inner join exams_mst_programs on stud_prog_id=prog_id 
inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id 
inner join exams_mst_academic_batches on rscs_batch_id=acba_id inner join exams_mst_semesters on rscs_sem_id=seme_id 
inner join exams_mst_schools on rcp_school_id=sch_id inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
where rscs_deleted='N' and rscs_course_type='C' and rscs_sem_id=2 and rscs_batch_id=1 and rcp_school_id=1 
and scse_deleted='N' and scse_course_type='C'and rcp_deleted='N' and cpse_deleted='N' and cpse_cour_type='C' 
and stud_status='OnRole' and stud_deleted='N' order by prog_name,cour_name,stud_enrollment_number

--query to select the value after converting it into other datatype and show a string where empty or null
select COALESCE (NULLIF(cast (scse_gpa_actual as varchar(10)),''),'ABSENT') from exams_rel_students_courses_semesters where scse_deleted='N' and cast(scse_gpa_actual as varchar(10)) is null

*************************************************************************************************************************************************

--very important query to search and display numeric value after converting it into varchar and displaying numeric where not empty otherwise string
select distinct (stud_enrollment_number),stud_fname,stud_lname,sch_name,prog_name,acba_name,seme_name,cour_code_sec,cour_name,
CASE
	WHEN scse_course_result is not null and scse_isconfirm='Y' THEN REPLACE(scse_isconfirm,'Y','Confirmed') 
	WHEN scse_course_result is not null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','Saved') 
ELSE 'NO DATA' 
END as scse_isconfirm, 
CASE 
	WHEN scse_gpa_actual is not null then cast (scse_gpa_actual as varchar) 
	WHEN scse_gpa_actual is null and scse_isconfirm='N' THEN COALESCE (NULLIF(cast (scse_gpa_actual as varchar(10)),''),'No Marks')
	WHEN scse_gpa_actual is null and scse_isconfirm='Y' THEN COALESCE (NULLIF(cast (scse_gpa_actual as varchar(10)),''),'ABSENT')
END as scse_gpa_actual, scse_course_result from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id 
inner join exams_mst_courses on rscs_course_id=cour_id inner join exams_mst_programs on stud_prog_id=prog_id 
inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id 
inner join exams_mst_academic_batches on rscs_batch_id=acba_id inner join exams_mst_semesters on rscs_sem_id=seme_id 
inner join exams_mst_schools on rcp_school_id=sch_id inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
where rscs_deleted='N' and rscs_course_type='C' and rscs_sem_id=2 and rscs_batch_id=1 and rcp_school_id=1 
and scse_deleted='N' and scse_course_type='C'and rcp_deleted='N' and cpse_deleted='N' and cpse_cour_type='C' 
and stud_status='OnRole' and stud_deleted='N' order by prog_name,cour_name,stud_enrollment_number

*************************************************************************************************************************************************

--Dt. 03/08/16 query to update for tcsion import students
update exams_mst_students set stud_status='OnRole' where stud_id >=6384 and (stud_status='Active' or stud_status='Inactive')

*************************************************************************************************************************************************
--Dt: 12/08/16 query to search the course imported programs

select distinct prog_name, sch_name from exams_rel_employees_activities_permissions 
inner join exams_rel_campus_school_programes_courses  on emap_rcp_id=rcp_id
inner join exams_mst_programs on rcp_prog_id=prog_id
inner join exams_mst_schools on rcp_school_id = sch_id
inner join exams_rel_courses_programes_semesters on prog_id=cpse_prog_id
where emap_created_datetime > '2016-05-10' and (cpse_seme_id=3 and cpse_acba_id=1) or (cpse_seme_id=1 and cpse_acba_id=9)
order by sch_name


***********************************************************************************************************************************************

-- Dt : 22/08/16 query to update the permissions given for superadmin
update exams_rel_employees_activities_permissions set emap_deleted='Y' where emap_empl_id=238 and emap_proc_id=5 and emap_acti_id in (44,45,46)

--testing for hyderabad campus for CBCS
select distinct stud_enrollment_number,stud_fname,stud_lname,sch_name,prog_name,acba_name,seme_name,cour_code_sec,cour_name, 
CASE WHEN scse_course_result is not null and scse_isconfirm='Y' THEN REPLACE(scse_isconfirm,'Y','Confirmed') 
WHEN scse_gpa_actual is null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','No Marks') 
WHEN scse_course_result is not null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','Saved') ELSE 'NO DATA' END as scse_isconfirm,
 scse_gpa_actual, scse_course_result ,scse_isabsent,scse_course_attempt	 
 from exams_mst_students 
 --inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id 
 
 inner join exams_mst_programs on stud_prog_id=prog_id 
 inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id 
inner join exams_mst_courses on rcp_cour_id=cour_id
--rscs_course_id=cour_id 
 inner join exams_rel_courses_programes_semesters on cpse_prog_id=83 --on rscs_cpse_id=cpse_id 
 inner join exams_mst_academic_batches on cpse_acba_id=acba_id --rscs_batch_id=acba_id 
 inner join exams_mst_semesters on cpse_seme_id=seme_id --rscs_sem_id=seme_id 
 inner join exams_mst_schools on rcp_school_id=sch_id 
inner join exams_mst_campus on rcp_campus_id=campus_id
 inner join exams_rel_students_courses_semesters on --rscs_id=scse_rscs_id and 
 cpse_id=scse_cpse_id 
 where --rscs_deleted='N' and rscs_course_type='C' and rscs_sem_id=3 and rscs_batch_id=1 and 
 rcp_school_id=4 and scse_deleted='N' and scse_course_type='C'and rcp_deleted='N' and cpse_deleted='N' and cpse_cour_type='C' and stud_status='OnRole' and stud_deleted='N' and campus_id=4
order by prog_name,cour_name,stud_enrollment_number

--or--
select distinct stud_enrollment_number,stud_fname,stud_lname,sch_name,prog_name,acba_name,seme_name,cour_code_sec,cour_name, 
CASE WHEN scse_course_result is not null and scse_isconfirm='Y' THEN REPLACE(scse_isconfirm,'Y','Confirmed') 
WHEN scse_gpa_actual is null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','No Marks') 
WHEN scse_course_result is not null and scse_isconfirm='N' THEN REPLACE(scse_isconfirm,'N','Saved') ELSE 'NO DATA' END as scse_isconfirm,
 scse_gpa_actual, scse_course_result ,scse_isabsent,scse_course_attempt	 
 from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id 
 inner join exams_mst_courses on rscs_course_id=cour_id inner join exams_mst_programs on stud_prog_id=prog_id 
 inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id 
 inner join exams_mst_academic_batches on rscs_batch_id=acba_id 
 inner join exams_mst_semesters on rscs_sem_id=seme_id 
 inner join exams_mst_schools on rcp_school_id=sch_id 
 inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and cpse_prog_id=83
 inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id 
 where rscs_deleted='N' and rscs_course_type='C' and rscs_sem_id=3 and rscs_batch_id=1 
 and rcp_school_id=4 and cpse_campus_id=4 and scse_deleted='N' and scse_course_type='C'and rcp_deleted='N' and cpse_deleted='N' and cpse_cour_type='C' and stud_status='OnRole' and stud_deleted='N' 
order by prog_name,cour_name,stud_enrollment_number

*********************************************************************************************************************************************************

--Dt: Query for deleting the details based on enrollment_number and course name 
--required in cases like if later marks changed still record is displayed
select stud_id,stud_enrollment_number,stud_fname,stud_lname,exams_rel_students_courses_semesters.* from 
exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id 
where scse_deleted='N' and rscs_deleted='N' and
stud_enrollment_number='M2015DM006' and (cpse_id=919 or cour_name='Homelessness, Poverty and Mental Health')

--Dt.: Query to select prog_name
select distinct rcp_prog_id, prog_name from exams_rel_campus_school_programes_courses inner join exams_mst_programs on rcp_prog_id=prog_id where rcp_school_id=18 and rcp_deleted='N'

-- Dt.: Query to delete the records from tables
delete from tcourse_evaluation_rel_stu_courses where rscs_created_datetime > '2016-08-26'

*********************************************************************************************************************************************************

---*** used for updating PMRDF data
update exams_mst_students set stud_acba_id = 15 where (select stud_enrollment_number like 'PMRDFs14C3%')

---***
select distinct cpse_id from exams_mst_students,exams_rel_campus_school_programes_courses,exams_rel_courses_programes_semesters,exams_rel_students_courses_semesters,tcourse_evaluation_rel_stu_courses where stud_prog_id=91 and rscs_deleted='N'

---*** query to locate rcp repeat entries
select rcp_id,rcp_prog_id,rcp_cour_id,rcp_school_id from exams_rel_campus_school_programes_courses where rcp_deleted='N' order by rcp_prog_id,rcp_cour_id,rcp_school_id;

*********************************************************************************************************************************************************

---*** Query to search the employee details and program permissions
select distinct campus_name as "Campus Name", sch_name as "School Name" ,sch_id as "School Id", 
empl_id as "Emp Id",empl_fname as "E_First Name", empl_lname as "E_Last Name",role_name as "Role", empl_email as "E_Email",
progtype_name as "Prog Type",prog_id as "Prog Id",prog_name as "Program"
from exams_mst_employees 
inner join exams_mst_schools on empl_school_centre_id=sch_id
inner join exams_rel_campus_school_programes_courses on sch_id=rcp_school_id
inner join exams_mst_programs  on rcp_prog_id=prog_id
inner join exams_mst_campus on empl_campus_id=campus_id
inner join exams_mst_programme_type on prog_prty_id=progtype_id
inner join exams_rel_employees_activities_permissions on empl_id=emap_empl_id and rcp_id=emap_rcp_id
inner join exams_mst_roles on empl_role_id=role_id
where rcp_deleted='N' and empl_deleted='N' and sch_deleted='N' 
order by campus_name, sch_name,sch_id, empl_id,empl_email,prog_id,prog_name

---*** Query to search the employee details and program permissions only of MA and mumbai campus
select distinct campus_name as "Campus Name", sch_name as "School Name" ,sch_id as "School Id", 
empl_id as "Emp Id",empl_fname as "E_First Name", empl_lname as "E_Last Name",role_name as "Role", empl_email as "E_Email",
progtype_name as "Prog Type",prog_id as "Prog Id",prog_name as "Program"
from exams_mst_employees 
inner join exams_mst_schools on empl_school_centre_id=sch_id
inner join exams_rel_campus_school_programes_courses on sch_id=rcp_school_id
inner join exams_mst_programs  on rcp_prog_id=prog_id
inner join exams_mst_campus on empl_campus_id=campus_id
inner join exams_mst_programme_type on prog_prty_id=progtype_id
inner join exams_rel_employees_activities_permissions on empl_id=emap_empl_id and rcp_id=emap_rcp_id
inner join exams_mst_roles on empl_role_id=role_id
where rcp_deleted='N' and empl_deleted='N' and sch_deleted='N' and prog_prty_id=1 and empl_campus_id=1
order by campus_name, sch_name,sch_id, 
empl_id,empl_email,prog_id,prog_name

*********************************************************************************************************************************************************
---***Dt. 06/09/16 query to search the details based of cpse mapping done till date by the secretariats
select distinct prog_id,sch_name,prog_name,empl_fname from exams_rel_courses_programes_semesters 
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
inner join exams_mst_campus on cpse_campus_id=campus_id
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
inner join exams_mst_programs on cpse_prog_id=prog_id
inner join exams_mst_employees on cpse_last_modified_empl_id=empl_id 
inner join exams_mst_schools on empl_school_centre_id=sch_id
where (cpse_acba_id in (9,10) and cpse_seme_id=1) or (cpse_acba_id in (1,4) and cpse_seme_id=3) and cpse_campus_id=2
order by sch_name,prog_name

--PHD students wrong entry
select stud_enrollment_number, stud_fname,stud_lname,prog_name  --distinct prog_name
from exams_mst_students 
inner join exams_mst_programs on stud_prog_id=prog_id where stud_status='OnRole' and stud_deleted='N' and stud_campus_id=1 and stud_enrollment_number like 'MP20%'
order by stud_enrollment_number

update exams_mst_students set stud_deleted='Y' where stud_campus_id=1 and stud_enrollment_number like 'MP20%' and stud_deleted='N' and stud_status='OnRole'

********************************************************************************************************************************************************

select * from tcourse_evaluation_rel_stu_courses where rscs_stu_id in (4958)

select rcp_id,exams_rel_courses_programes_semesters.*--distinct prog_id --rcp_id,prog_name,cpse_acba_id if ,cpse_seme_id,rcp_id 
from exams_rel_campus_school_programes_courses
inner join exams_rel_courses_programes_semesters on rcp_campus_id=cpse_campus_id and rcp_prog_id=cpse_prog_id 
inner join exams_rel_employees_activities_permissions on rcp_id=emap_rcp_id
inner join exams_mst_employees on emap_empl_id=empl_id
inner join exams_mst_programs on rcp_prog_id=prog_id
where empl_school_centre_id=1 and cpse_prog_id=23 and emap_proc_id=8 and empl_id=14
order by prog_id

select exams_mst_students.* from exams_mst_students 

update exams_mst_students set stud_sem_id=5 where stud_id in (select stud_id from exams_mst_students where stud_acba_id=2 and stud_deleted='N' and stud_prog_id=17)

********************************************************************************************************************************************************

--Dt:14/09/2016 Query to search out the programs under a school
select distinct prog_name from exams_mst_programs 
inner join exams_rel_courses_programes_semesters on cpse_prog_id=prog_id 
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
inner join exams_rel_campus_school_programes_courses on cpse_prog_id=rcp_prog_id
and cpse_deleted='N' and cpse_campus_id=1 and rcp_school_id=13 and rcp_deleted='N'
order by prog_name

delete from exams_mst_courses where cour_created_datetime >='2016-09-14 13:08:49.19015+05:30'

delete from exams_rel_campus_school_programes_courses where rcp_created_datetime >='2016-09-14 13:08:49.19015+05:30'


select distinct prog_id,prog_name from exams_rel_campus_school_programes_courses inner join exams_mst_programs on rcp_prog_id=prog_id where rcp_school_id=4

--select cbcs courses which exist compared to new data
select distinct cour_name, seme_name,sch_name 
from exams_mst_courses inner join exams_rel_courses_programes_semesters on cpse_cour_id=cour_id and cpse_prog_id=83
inner join exams_rel_campus_school_programes_courses on rcp_prog_id=83 and rcp_cour_id=cour_id and rcp_campus_id=1
inner join exams_mst_semesters on cpse_seme_id=seme_id
inner join exams_mst_schools on rcp_school_id=sch_id
where cpse_deleted='N' and rcp_deleted='N' and cour_name in ('Everyday Ethics and Constitutional Values','Doing Gender','Participatory Training Methodology','Social Value Creation and Social Innovation','Community Mental Health','Socio-Cultural Contexts of Counselling','Law, Institutions and Society','Ethics in Disaster Management','Secular Ethics','Social Network Analysis and Organizations','Introduction to Micro Finance','Labour and Technology in Globalized World','Crime Culture and Media','Human Growth and Behaviour','Law, Justice and Democratic Rights','Child and Adolescent Mental Health','Design for Inclusive Environment and Accessibility','Society, Conflicts and Peace Processes','Queering Feminism','GIS for Social Sciences','Psychosocial Health and Wellbeing of the Elderly','Social Epidemiology of Nutrition','Global Public Health','Public Health Across Lifespan','Perspectives on Urban Space','Contemporary Issues in Sustainability and Climate Change','Introduction to the Philosophy of Science','Perspectives on the Water Sector: An Overview','Introduction to Sectoral Regulation I (Water Sector Regulation and Food Safety Regulation)','Information and Communication Technologies for Development','Gender, Culture and Space','Digital Scholarship')
order by seme_name

*************************************************************************************************************************************************************************************************************

select prog_id,prog_name ,cour_id,cour_name from exams_rel_campus_school_programes_courses inner join exams_mst_courses on rcp_cour_id=cour_id
inner join exams_mst_programs on rcp_prog_id = prog_id
where rcp_created_datetime > '2016-09-16'
order by prog_id,cour_id

select stud_id,stud_enrollment_number,stud_fname,stud_lname,exams_rel_students_courses_semesters.* from 
exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id and rscs_sem_id=2
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id 
where scse_deleted='N' and rscs_deleted='N' and
stud_enrollment_number='B2015MH008'

--sem 3 CBCS courses deleted or record checking query
select * from exams_rel_students_courses_semesters inner join tcourse_evaluation_rel_stu_courses on scse_cpse_id=rscs_cpse_id
where rscs_deleted='N' and scse_deleted='N' and rscs_cpse_id in (1346,1342,1347) and rscs_sem_id=3


--Query to search out student of 2015-17 batch who has not enrolled for any cbcs course in 2nd and 3rd sem
select distinct stud_id,stud_enrollment_number,stud_fname, stud_lname,prog_id,prog_name,sch_id,sch_name from exams_mst_students 
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id and rcp_campus_id=stud_campus_id
inner join exams_mst_schools on rcp_school_id=sch_id 
where stud_status='OnRole' and stud_deleted='N' and stud_campus_id=1 and stud_acba_id=1 and prog_prty_id=1 and stud_prog_id!= 17
and stud_id not in (
select distinct stud_id from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id
where stud_status='OnRole' and stud_deleted='N' and rscs_deleted='N' and cpse_prog_id=83 and stud_prog_id!= 17 and stud_acba_id=1 and stud_campus_id=1)
order by stud_enrollment_number,stud_id


-- Awesome Queries
--This was used for passing it to main query as in .. on 23/09/2016
--query to split a csv value to multiple rows in postres
SELECT * 
FROM (
   SELECT regexp_split_to_table(question, ',') as splitted_value  from polls_poll
) t

-- query to a csv value into mutilple columns in postgres
select * from exams_mst_students where stud_id in ( select a[1],a[2],a[3],a[4] from ( select regexp_split_to_array(cpby_sem4,',') from exams_rel_campus_prog_batch_year_sems where cpby_camp_id_id=1 and cpby_prog_id_id=16 and cpby_acba_id_id=1 ) as dt(a)) 	

-------------------

--Dt :- 3/10/16 As per new cbcs framework, query to search the student who has chosen more than 2 "Open Electives" for the semester worked in the case of 2016-18 Batch
select distinct stud_enrollment_number, cpse_course_variant
from tcourse_evaluation_rel_stu_courses inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_mst_courses on rscs_course_id=cour_id 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
where rscs_course_type='C' and rscs_batch_id=10 and rscs_sem_id=2 and rscs_deleted='N' and cpse_prog_id=83 and stud_status='OnRole' 
and stud_deleted='N' and stud_campus_id=1 and cpse_course_variant='OE'
group by stud_enrollment_number,cpse_course_variant
having count(cpse_course_variant)>=2

--students of 2016-18 enrolled for open electives (OE or EF) elective foundation courses
select distinct stud_enrollment_number, stud_fname ,stud_lname,cpse_capacity,cpse_day,cpse_course_variant 
from tcourse_evaluation_rel_stu_courses inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_mst_courses on rscs_course_id=cour_id 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
where rscs_course_type='C' and rscs_batch_id=10 and rscs_sem_id=2 and rscs_deleted='N' and cpse_prog_id=83 and stud_status='OnRole' and stud_deleted='N' and stud_campus_id=1
--and cpse_capacity <1000 
order by stud_enrollment_number 
--stud_enrollment_number,cpse_course_variant

--students of 2015-17 chose 4th sem courses
select cour_name,stud_enrollment_number, stud_fname ,cpse_capacity,scse_created_datetime from tcourse_evaluation_rel_stu_courses inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_mst_courses on rscs_course_id=cour_id 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
where rscs_course_type='C' and rscs_batch_id=1 and rscs_sem_id=4 and rscs_deleted='N' and cpse_prog_id=83 and stud_status='OnRole' and stud_deleted='N' and stud_campus_id=1
order by --cour_name,stud_enrollment_number,
scse_created_datetime

--Final query to search the capacity of courses and no of enrollments done till date
select sch_name, cour_name as "Course Name",
count (stud_id) as "No. of Enrollments",cpse_capacity as "Capacity" from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_rel_campus_school_programes_courses on cpse_prog_id=rcp_prog_id and cpse_cour_id=rcp_cour_id
inner join exams_mst_schools on rcp_school_id=sch_id
where stud_status='OnRole' and stud_deleted='N' and cpse_prog_id=83 and rscs_deleted='N' and scse_deleted='N' and rcp_campus_id=1 and cpse_seme_id=2
and stud_acba_id=10 and rscs_sem_id=2 and cpse_course_variant='EF'
group by cour_name,cpse_capacity,sch_name

--------------------------------
--Dt. 04/1016 NEW Electives (CBCS Framework)
--Final query to search the capacity of courses and no of enrollments done till date 15-17 batch
select sch_name as "School Name", cour_name as "Course Name",cpse_course_variant as "Course Variant",acba_name as "Batch",seme_name as "Semester",
count (stud_id) as "No. of Enrollments",cpse_capacity as "Capacity" from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_rel_campus_school_programes_courses on cpse_prog_id=rcp_prog_id and cpse_cour_id=rcp_cour_id
inner join exams_mst_schools on rcp_school_id=sch_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
where stud_status='OnRole' and stud_deleted='N' and cpse_prog_id=83 and rscs_deleted='N' and scse_deleted='N' and rcp_campus_id=1 and cpse_seme_id=4
and stud_acba_id=1 and rscs_sem_id=4 --and cpse_course_variant='EF' 
group by cour_name,cpse_capacity,sch_name,cpse_course_variant,acba_name,seme_name
order by cpse_course_variant,cour_name

--Final query to search the capacity of courses and no of enrollments done till date 16-18 batch
select sch_name as "School Name", cour_name as "Course Name",cpse_course_variant as "Course Variant",acba_name as "Batch",seme_name as "Semester",
count (stud_id) as "No. of Enrollments",cpse_capacity as "Capacity" from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_rel_campus_school_programes_courses on cpse_prog_id=rcp_prog_id and cpse_cour_id=rcp_cour_id
inner join exams_mst_schools on rcp_school_id=sch_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
where stud_status='OnRole' and stud_deleted='N' and cpse_prog_id=83 and rscs_deleted='N' and scse_deleted='N' and rcp_campus_id=1 and cpse_seme_id=2
and stud_acba_id=10 and rscs_sem_id=2 --and cpse_course_variant='EF' 
group by cour_name,cpse_capacity,sch_name,cpse_course_variant,acba_name,seme_name
order by cpse_course_variant,cour_name

--all students of 15-17 and 16-18 batch who has taken 'Labour and Technology in Globalized World' course returned 60 records
--59 of 2015-17 and 1 of 2016-18 
select cour_name,acba_name,seme_name,stud_enrollment_number,stud_fname,stud_lname,prog_name,stud_tiss_email,stud_other_email,stud_mobile_number
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_semesters on cpse_seme_id=seme_id 
inner join exams_mst_courses on cpse_cour_id=cour_id and cour_name='Labour and Technology in Globalized World'
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
where rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' and scse_deleted='N' and cpse_acba_id in (10,1) and cpse_seme_id in (2,4) and cour_deleted='N' and cpse_prog_id=83
order by stud_enrollment_number

--Dt. 05/10/16
--LTGW stud_id and rscs_id,scse_id
select cour_name, seme_id,stud_id, rscs_id,scse_id
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_semesters on cpse_seme_id=seme_id 
inner join exams_mst_courses on cpse_cour_id=cour_id and cour_name='Labour and Technology in Globalized World'
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
where rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' and scse_deleted='N' and cpse_acba_id in (10,1) and cpse_seme_id in (2,4) and cour_deleted='N' and cpse_prog_id=83
order by stud_enrollment_number

-- query to find out the cbcs courses completed by a student of 15-17 batch not completed 8 credits till date 05/10/16
select stud_enrollment_number ,stud_fname, stud_lname, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id=1 and stud_acba_id=1 and stud_sem_id=3 --and rscs_sem_id=4 
group by stud_enrollment_number,stud_fname, stud_lname, cpse_credits
having count(cpse_credits)<4
order by stud_enrollment_number


select stud_enrollment_number ,stud_fname, stud_lname, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id=1 and stud_acba_id=1 and stud_sem_id=3 --and rscs_sem_id=4 
group by stud_enrollment_number,stud_fname, stud_lname, cpse_credits
--having count(cpse_credits)<4
order by stud_enrollment_number

--displays each semester and the courses as CBCS 15-17 batch
select stud_enrollment_number ,stud_fname, stud_lname ,cour_name,cpse_seme_id--, count(cpse_credits) as "Total CBCS courses appeared",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id=1 and stud_acba_id=1 and stud_sem_id=3 
group by stud_enrollment_number,stud_fname, stud_lname, cour_name,cpse_seme_id--, cpse_credits
order by stud_enrollment_number,cpse_seme_id 

update exams_rel_students_courses_semesters set scse_deleted='Y' and scse_last_modified_datetime=now() where (select stud_id, rscs_id,scse_id
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_semesters on cpse_seme_id=seme_id 
inner join exams_mst_courses on cpse_cour_id=cour_id and cour_name='Labour and Technology in Globalized World'
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
where rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' and scse_deleted='N' and cpse_acba_id in (10,1) and cpse_seme_id in (2,4) and cour_deleted='N' and cpse_prog_id=83
order by stud_enrollment_number)

SELECT Now() AS CurrentDateTime

select current_timestamp

--Query1 SCSE for LTWG students detetion
update exams_rel_students_courses_semesters set scse_deleted='Y' , scse_last_modified_empl_id=238 , scse_last_modified_datetime = current_timestamp
where scse_id in (select scse_id
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_semesters on cpse_seme_id=seme_id 
inner join exams_mst_courses on cpse_cour_id=cour_id and cour_name='Labour and Technology in Globalized World'
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
where rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' and scse_deleted='N' and cpse_acba_id in (10,1) and cpse_seme_id in (2,4) and cour_deleted='N' and cpse_prog_id=83
order by stud_enrollment_number)


--Query2 RSCS for LTWG students detetion
update tcourse_evaluation_rel_stu_courses set rscs_deleted='Y' and rscs_last_modifier_id=238 and rscs_last_modified_datetime= '2016-10-05 11:28:32.517527+05:30'
where rscs_id in (63946,63992,63993,64055,64155,64161,64177,64178,64292,64361,64392,64462,64497,64569,64625,64675,64700,64841,64883,64905,64936,64974,65035,65101,65111,65115,65124,65159,65176,65182,65201,65217,65226,65228,65232,65259,65297,65310,65396,65432,65434,65448,65532,65535,65540,65628,65630,65638,65664,65671,65714,65721,65771,65818,66880,66884,66886,66897,66900,67608)

update exams_rel_students_courses_semesters set scse_deleted='Y' and scse_last_modified_empl_id=238 where scse_id in (select scse_id from exams_rel_students_courses_semesters where scse_id in  (46833,46879,46880,46942,47042,47048,47064,47065,47179,47248,47279,47349,47384,47456,47512,47562,47587,47728,47770,47792,47823,47861,47922,47988,47998,48002,48011,48046,48063,48069,48088,48104,48113,48115,48119,48146,48184,48197,48283,48319,48321,48335,48419,48422,48427,48515,48517,48525,48551,48558,48601,48608,48658,48705,49769,49773,49775,49786,49789,50497))

update exams_rel_students_courses_semesters set scse_last_modified_datetime= '2016-10-05 11:28:32.517527+05:30' where scse_id in (
select scse_id from exams_rel_students_courses_semesters where scse_id in (46833,46879,46880,46942,47042,47048,47064,47065,47179,47248,47279,47349,47384,47456,47512,47562,47587,47728,47770,47792,47823,47861,47922,47988,47998,48002,48011,48046,48063,48069,48088,48104,48113,48115,48119,48146,48184,48197,48283,48319,48321,48335,48419,48422,48427,48515,48517,48525,48551,48558,48601,48608,48658,48705,49769,49773,49775,49786,49789,50497))

--Dt. 06/10/16
--Query to search a students marks for all semesters
select stud_enrollment_number,stud_fname,stud_lname,cour_name,scse_gpa_actual,cpse_credits,scse_course_result, scse_course_attempt,scse_course_type,scse_semester_attempt
from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on cpse_cour_id=cour_id
where scse_deleted='N' and scse_semester_attempt in ('1','2','3','4') and rscs_sem_id in(1,2,3,4) and scse_cpse_id=rscs_cpse_id and rscs_deleted='N' 
and stud_status='OnRole' and rscs_stu_id=stud_id and stud_enrollment_number='M2015HE009'
order by stud_enrollment_number, scse_semester_attempt,cour_name


---selection of students as required special date format and concatenated student details
select stud_id,stud_enrollment_number as "Enrollment Number", CONCAT(stud_fname ,' ',stud_lname) as " Student Name",stud_tiss_email as "Tiss Email",stud_gender as "Gender", to_char("stud_dob", 'DD/MM/YYYY') as "DOB",
campus_name as "Campus",prog_name as "Program Name",progtype_name as "Program Type",acba_name as "Batch",seme_name as "Semester",stud_other_email as "Other Email"
from exams_mst_students inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_programme_type on stud_prog_type_id=progtype_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_semesters on stud_sem_id=seme_id
where stud_deleted='N' and 	stud_status='OnRole' and stud_prog_type_id!=6
order by stud_enrollment_number,prog_name

---query exectued for online MAIFS program to search students whose supplementary marks are not entered
select stud_enrollment_number as "Enrollment Number",cour_name as "Course Name",seme_id as "Semester" from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on rscs_sem_id=seme_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_programs on cpse_prog_id=prog_id
and stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and stud_prog_id =18 and stud_acba_id=4 and (scse_course_result='' or scse_course_result='F' )
order by seme_id

--finding the maxlength of a field 
select max(length(stud_enrollment_number)) from exams_mst_students where stud_status='OnRole' and stud_deleted='N'


---Dt. 17/10/16 

--number of enrollments for each course
select sch_name as "School Name", cour_name as "Course Name",cpse_course_variant as "Course Variant",acba_name as "Batch",seme_name as "Semester",
count (stud_id) as "No. of Enrollments",cpse_capacity as "Capacity" from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id and scse_deleted='N' 
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_rel_campus_school_programes_courses on cpse_prog_id=rcp_prog_id and cpse_cour_id=rcp_cour_id
inner join exams_mst_schools on rcp_school_id=sch_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
where stud_status='OnRole' and stud_deleted='N' and cpse_prog_id=83 and rscs_deleted='N' and scse_deleted='N' and rcp_campus_id=1 and (cpse_seme_id =2
and stud_acba_id = 10) or (cpse_seme_id=4 and stud_acba_id=1) --and rscs_sem_id in (4,2) --and cpse_course_variant='EF' 
group by cour_name,cpse_capacity,sch_name,cpse_course_variant,acba_name,seme_name
order by seme_name,sch_name,cour_name,cpse_course_variant

--students of 15-17 with less credits
select prog_name,stud_enrollment_number ,stud_fname, stud_lname,seme_name, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id=1 and stud_acba_id=1 and stud_sem_id=3 --and rscs_sem_id=4 
group by prog_name,stud_enrollment_number,stud_fname, stud_lname, cpse_credits,seme_name
having count(cpse_credits)<4
order by prog_name,stud_enrollment_number

--list of all students of 16-18, 15-17 taken cbcs courses for II,IV semester respectively
select distinct prog_name,stud_enrollment_number, stud_fname ,stud_lname,cour_name,cpse_capacity,cpse_day,cpse_course_variant,seme_name,acba_name
from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id and rscs_deleted='N'
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_mst_courses on rscs_course_id=cour_id 
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_programs on stud_prog_id=prog_id
where rscs_course_type='C' and (rscs_batch_id=10 and rscs_sem_id=2) or (rscs_batch_id=1 and rscs_sem_id=4) and rscs_deleted='N' and scse_deleted='N'
and cpse_prog_id=83 and stud_status='OnRole' and stud_deleted='N' and stud_campus_id=1 --and rscs_created_datetime > '2016-10-15'
--and cpse_capacity <1000 
order by seme_name,acba_name,stud_enrollment_number

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Dt:19/10/16
--15-17 batch students taken cbcs courses till date
select prog_name,stud_enrollment_number ,stud_fname, stud_lname,seme_name, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed", stud_tiss_email as "Tiss Email",stud_other_email as "Other Email", stud_mobile_number as "Contact Number"
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id=1 and stud_acba_id=1 and stud_sem_id=3 --and rscs_sem_id=4 
group by prog_name,stud_enrollment_number,stud_fname, stud_lname, cpse_credits,seme_name,stud_id
order by prog_name,stud_enrollment_number

--student not enrolled for any CBCS course from 2015-17 batch
select stud_enrollment_number as "Enrollment Number", stud_fname as "First Name", stud_lname as "Last Name", prog_name as "Program Name",seme_name as "Semester", stud_tiss_email as "Tiss Email",stud_other_email as "Other Email", stud_mobile_number as "Mobile Number"
from exams_mst_students
inner join exams_mst_programs on stud_prog_id = prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
where stud_campus_id=1 and stud_acba_id=1 and prog_prty_id=1 and stud_sem_id = 3 and stud_status='OnRole' and stud_deleted='N' and stud_prog_type_id=1 and stud_prog_id not in (18,17) and stud_id not in (select stud_id--prog_name,stud_enrollment_number ,stud_fname, stud_lname,seme_name, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id=1 and stud_acba_id=1 and stud_sem_id=3 --and rscs_sem_id=4 
group by prog_name,stud_enrollment_number,stud_fname, stud_lname, cpse_credits,seme_name,stud_id
order by prog_name,stud_enrollment_number
) order by stud_enrollment_number

--check to see Audit course or EC course credits 
select distinct scse_letter_grade, scse_id, scse_course_type,scse_course_attempt,cpse_id,cpse_prog_id,cpse_seme_id,cpse_credits,cpse_total_hours 
from exams_rel_students_courses_semesters inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id where scse_course_type in ('AU','EC')
order by cpse_seme_id

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Dt. 21/10/16
--Working query to search the onrole students of MADS who has generated hallticket for 15-17 third sem exam
select stud_enrollment_number,stud_tiss_email,stud_fname,stud_lname from exams_mst_students where stud_deleted='N'and stud_status='OnRole' and stud_campus_id='1' and stud_prog_id=8 and stud_sem_id=3 and stud_id not in 
(
select cast (sh_stu as int) from tcourse_evaluation_stu_hallticket where cast (sh_stu as int ) in (

select distinct cast(eval_stu as int) from tcourse_evaluation_mst_eval 
where eval_stu in ('501','490','516','498','4131','509','499','515','495','514','511',
'483','480','472','473','497','493','4132','504','489','502','482','500','488','513','505','475','512','508','487','477','510','494','484','479','491','471','486','476','481','506','474') 
and eval_prog_id=8 and eval_sem_id=3 ) 

and sh_stud_sem='3')

--trial query

select distinct exams_mst_students.* from exams_mst_students inner join tcourse_evaluation_mst_eval on stud_id = cast(eval_stu as int) and stud_sem_id=eval_sem_id
where stud_deleted='N'and stud_status='OnRole' and stud_campus_id='1' and stud_prog_id=8 and stud_sem_id=3
--order by stud_enrollment_number
and stud_id not in (select cast(sh_stu as int) from tcourse_evaluation_stu_hallticket where sh_stud_sem='3')

--Dt. 22/10/16
--qeury to check course evaluation status
select campus_name,stud_enrollment_number,stud_tiss_email,stud_fname,stud_lname,prog_name,seme_name,acba_name from exams_mst_students 
inner join exams_mst_programs on stud_prog_id= prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_campus on campus_id=stud_campus_id
where stud_deleted='N' and stud_status='OnRole' and stud_campus_id='1' and stud_prog_id in (8,9) and --((stud_sem_id=3 and stud_acba_id=1) )--or 
((stud_acba_id=10 and stud_sem_id=1)) 
and stud_id not in 
	(select distinct cast (sh_stu as int) from tcourse_evaluation_stu_hallticket 
	where cast (sh_stu as int ) in 
		(
		select distinct cast(eval_stu as int) from tcourse_evaluation_mst_eval 
		where eval_stu in 
			(
			select cast (stud_id as text) from exams_mst_students 
			where stud_prog_id in (8,9) and stud_campus_id=1 and --((stud_sem_id=3 and stud_acba_id=1))-- or 
			((stud_acba_id=10 and stud_sem_id=1)) 
			and stud_status='OnRole' and stud_deleted='N'
			) 
		and eval_prog_id in (8,9) and eval_sem_id in (1)--(3)
		)
	and sh_stud_sem in ('1')--('3')
	)
order by prog_name,seme_name,stud_enrollment_number


--Dt: 25/10/16


--students who has taken only 1 course 16-18
select distinct rscs_stu_id  , count (rscs_course_id) 
from tcourse_evaluation_rel_stu_courses inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id 
where rscs_deleted='N' and rscs_batch_id=10 and rscs_sem_id=2 and rscs_course_type='C' and scse_deleted='N'
group by rscs_stu_id
having count(rscs_course_id)<=1

---student of 16-18 taken 2 courses
select distinct rscs_stu_id, count (rscs_course_id) from tcourse_evaluation_rel_stu_courses inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id 
where rscs_deleted='N' and rscs_batch_id=10 and rscs_sem_id=2 and rscs_course_type='C' and scse_deleted='N'
group by rscs_stu_id
having count(rscs_course_id)=2

---query to find out 2016-18 batch students registered for Compulsory Elective Courses for 2nd sem
select distinct sch_name as "School Name", prog_name as "Program Name",stud_enrollment_number as "Enrollment Number", stud_fname as "First Name", stud_lname as "Last Name",stud_tiss_email as "Tiss Email"
,stud_other_email as "Other Email",stud_mobile_number as "Mobile No",acba_name as "Batch",seme_name as "Current Semester"
from exams_mst_students inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id and rcp_campus_id=stud_campus_id
inner join exams_mst_schools on rcp_school_id=sch_id
where stud_campus_id =1 and stud_acba_id=10 and stud_sem_id=1 and stud_status='OnRole' and stud_deleted='N' and stud_prog_type_id=1 and stud_prog_id not in (42,17,18) 
--order by stud_prog_id
and stud_id not in (
select distinct stud_id--,sch_name as "School Name", cour_name as "Course Name",cpse_course_variant as "Course Variant",acba_name as "Batch",seme_name as "Semester",
--count (stud_id) as "No. of Enrollments",cpse_capacity as "Capacity" 
from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id and rscs_deleted='N'
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id and scse_deleted='N' and scse_course_type='C'
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_rel_campus_school_programes_courses on cpse_prog_id=rcp_prog_id and cpse_cour_id=rcp_cour_id
inner join exams_mst_schools on rcp_school_id=sch_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
where stud_status='OnRole' and stud_deleted='N' and cpse_prog_id=83 and rscs_deleted='N' and scse_deleted='N' and rcp_campus_id=1 and cpse_seme_id =2
and stud_acba_id = 10 and stud_prog_type_id=1) 
order by prog_name

---all students of 16-18 MA mumbai elligible for CBCS
select distinct prog_name,stud_enrollment_number ,stud_fname,stud_lname,stud_tiss_email,stud_other_email,stud_mobile_number
from exams_mst_students 
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_prog_type_id =1 and stud_acba_id=10 and stud_sem_id=1 and stud_status='OnRole' and stud_deleted='N' AND stud_campus_id=1 and stud_prog_id not in (17,18,42)
order by prog_name

--16-18 batch students (6)  who has enrolled for only 1 course
select distinct prog_name,stud_enrollment_number, stud_fname ,stud_lname,cour_name,cpse_capacity,cpse_day,cpse_course_variant,seme_name,acba_name
from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id and rscs_deleted='N'
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_mst_courses on rscs_course_id=cour_id 
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_programs on stud_prog_id=prog_id
where rscs_course_type='C' and (rscs_batch_id=10 and rscs_sem_id=2) --or (rscs_batch_id=1 and rscs_sem_id=4) 
and rscs_deleted='N' and scse_deleted='N' and stud_id in (6786,5479,6771,6065,5865,5728)
and cpse_prog_id=83 and stud_status='OnRole' and stud_deleted='N' and stud_campus_id=1 --and rscs_created_datetime > '2016-10-15' 
--and cpse_capacity <1000 
order by seme_name,acba_name,stud_enrollment_number


--final students from 16-18 enrolled for 1 cbcs course
select distinct prog_name,stud_enrollment_number, stud_fname ,stud_lname,cour_name,cpse_capacity,cpse_day,cpse_course_variant,seme_name,acba_name
from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id and rscs_deleted='N'
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_mst_courses on rscs_course_id=cour_id 
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_programs on stud_prog_id=prog_id
where rscs_course_type='C' and (rscs_batch_id=10 and rscs_sem_id=2) --or (rscs_batch_id=1 and rscs_sem_id=4) 
and rscs_deleted='N' and scse_deleted='N' and stud_id in (select distinct rscs_stu_id
from tcourse_evaluation_rel_stu_courses inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id 
where rscs_deleted='N' and rscs_batch_id=10 and rscs_sem_id=2 and rscs_course_type='C' and scse_deleted='N'
group by rscs_stu_id
having count(rscs_course_id)<=1)
and cpse_prog_id=83 and stud_status='OnRole' and stud_deleted='N' and stud_campus_id=1 --and rscs_created_datetime > '2016-10-15' 
--and cpse_capacity <1000 
order by seme_name,acba_name,stud_enrollment_number

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Dt. 04/11/16

 select * from exams_rel_employees_activities_permissions where emap_empl_id=15

 update exams_rel_employees_activities_permissions set emap_last_modified_datetime=now() where emap_empl_id=15

 update exams_rel_employees_activities_permissions set emap_deleted='Y' where emap_empl_id=15

--marks entered before 4Nov 2016
select prog_name,stud_enrollment_number,seme_name,acba_name,cour_name,exams_rel_students_courses_semesters.* from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_students_courses_semesters on rscs_id =scse_rscs_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_acba_id in (9,10,11) and stud_status='OnRole' and stud_deleted='N' and scse_letter_grade!='' and scse_deleted='N' and rscs_deleted='N' and scse_course_type!='C' and stud_campus_id=1
order by prog_name,cour_name,stud_enrollment_number

--Dt.07/11/16
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select * from exams_rel_employees_activities_permissions where emap_empl_id=15 and emap_deleted='N'

update exams_rel_employees_activities_permissions set emap_last_modified_datetime=now(),emap_deleted='Y',emap_last_modifier_empl_id=238 where emap_empl_id=15


--returned 541 records on 7th Nov 2016
select * from exams_mst_students where stud_enrollment_number = stud_regis_number 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--query to find out student details who have NOT generated Grade Card of 2016-18 batch
select campus_name as "Campus",stud_enrollment_number as "Enrollment Number",stud_tiss_email as "Tiss Email",stud_fname as "First Name",stud_lname as "Last Name",prog_name as "Program",seme_name as "Semester",acba_name as "Batch" from exams_mst_students
inner join exams_mst_programs on stud_prog_id= prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_campus on campus_id=stud_campus_id
where stud_status='OnRole' and stud_deleted='N' and (stud_acba_id=10 and stud_sem_id=1)  
and stud_prog_id=16 and stud_id not in (
select cast(sh_stu as int) from tcourse_evaluation_stu_hallticket where cast(sh_stu as int) in (
select stud_id from exams_mst_students where stud_status='OnRole' and stud_deleted='N' and (stud_acba_id=10 and stud_sem_id=1) 
and stud_prog_id=16) )
order by stud_enrollment_number

--query to find out student details who have NOT generated Grade Card of 2015-17 batch
select campus_name as "Campus",stud_enrollment_number as "Enrollment Number",stud_tiss_email as "Tiss Email",stud_fname as "First Name",stud_lname as "Last Name",prog_name as "Program",seme_name as "Semester",acba_name as "Batch" from exams_mst_students 
inner join exams_mst_programs on stud_prog_id= prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_campus on campus_id=stud_campus_id
where stud_status='OnRole' and stud_deleted='N' and (stud_acba_id=1 and stud_sem_id=3)  
and stud_prog_id=16 and stud_id not in (
select cast(sh_stu as int) from tcourse_evaluation_stu_hallticket where cast(sh_stu as int) in (
select stud_id from exams_mst_students where stud_status='OnRole' and stud_deleted='N' and (stud_acba_id=1 and stud_sem_id=3) 
and stud_prog_id=16) )
order by stud_enrollment_number

--Dt:- 08/11/16
--cbcs courses and permissions given to secretariats with separate records
select  distinct campus_name,sch_name,cour_name, seme_name ,acba_name, empl_fname
from exams_mst_employees
inner join exams_mst_schools on empl_school_centre_id=sch_id
inner join exams_rel_campus_school_programes_courses on sch_id=rcp_school_id
inner join exams_rel_courses_programes_semesters on rcp_cour_id=cpse_cour_id and rcp_prog_id=cpse_prog_id 
inner join exams_mst_courses on rcp_cour_id=cour_id
inner join exams_mst_campus on rcp_campus_id=campus_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
inner join exams_rel_employees_activities_permissions on rcp_id=emap_rcp_id and emap_deleted='N' and emap_empl_id=empl_id 
where rcp_prog_id=83 and cpse_deleted='N' and rcp_deleted='N'
group by empl_fname,campus_name,sch_name,cour_name, seme_name ,acba_name
order by sch_name,seme_name,acba_name

--cbcs courses and permissions given to secretariats
select distinct campus_name,sch_name, cour_name,acba_name,seme_name, string_agg(empl_fname,', ' ) as "empl"
from exams_mst_employees 
inner join exams_rel_campus_school_programes_courses on empl_school_centre_id=rcp_school_id
inner join exams_rel_courses_programes_semesters on rcp_cour_id=cpse_cour_id and rcp_prog_id=cpse_prog_id
inner join exams_mst_schools on rcp_school_id=sch_id
inner join exams_mst_courses on rcp_cour_id=cour_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
inner join exams_mst_campus on rcp_campus_id=campus_id
where empl_deleted='N' and rcp_prog_id=83 and empl_role_id=3
group by sch_name,cour_name,campus_name,acba_name,seme_name
order by sch_name,cour_name

--unique cbcs courses and elligible employees
select distinct sch_name, cour_name, string_agg(empl_fname,', ' )
from exams_mst_employees 
inner join exams_rel_campus_school_programes_courses on empl_school_centre_id=rcp_school_id
inner join exams_mst_schools on rcp_school_id=sch_id
inner join exams_mst_courses on rcp_cour_id=cour_id
where empl_deleted='N' and rcp_prog_id=83 and empl_role_id=3
group by sch_name,cour_name
order by sch_name,cour_name

--query to select marks of the given semester
select stud_enrollment_number,cour_name, scse_id,scse_cpse_id,scse_rscs_id,cpse_credits, scse_isconfirm,scse_deleted,scse_gpa_actual, scse_letter_grade,rscs_batch_id,scse_course_attempt,scse_course_type,scse_semester_attempt
from
exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on rscs_sem_id=seme_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
where scse_deleted='N' and stud_status='OnRole' and stud_deleted='N' and stud_enrollment_number='M2015MC014' --and scse_semester_attempt ='2' --and rscs_batch_id=1
order by cour_name

-- Dt. 11/11/16 select query showing records as in Grade Card or an alternate for new summary sheet query
select stud_enrollment_number as "Enrollment No", stud_fname as "First Name", stud_mname as "Middle Name",stud_lname as "Last Name",cour_name as "Course Title",cpse_cour_type as "Course Type",cpse_total_hours as "Total Hours",cpse_credits as "Credits",scse_gpa_actual as "Grade Point",scse_letter_grade as "Letter Grade" from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and scse_cpse_id=cpse_id and scse_semester_attempt='2'
inner join exams_mst_courses on cpse_cour_id=cour_id
where stud_status='OnRole' and stud_deleted='N' and stud_prog_id=20 and stud_acba_id=1 and stud_sem_id=3 and rscs_deleted='N' and scse_deleted='N' and scse_semester_attempt='2'
order by stud_enrollment_number,cour_name

--Dt. 16/11/16
--query to find the courses
select stud_id,cour_code,scse_gpa_actual,scse_letter_grade,cpse_credits,scse_course_result,scse_course_attempt,scse_course_type,scse_semester_attempt,cour_name,stud_enrollment_number 
from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_mst_courses on rscs_course_id= cour_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
where scse_deleted='N' and stud_status='OnRole' and stud_deleted='N' and rscs_deleted='N' and scse_isconfirm='Y' and stud_id =330--and rscs_stu_id in (330) 
and rscs_sem_id=2
and (scse_rscs_id,scse_id ) in (select scse_rscs_id , first_value(scse_id) over (partition by scse_rscs_id, scse_cpse_id 
 order by case when scse_course_attempt in ('Re') then 1 else 2 end , scse_id desc) from exams_rel_students_courses_semesters where scse_deleted='N') 
 --and ((scse_gpa_actual is not null and scse_isabsent='N')or(scse_gpa_actual is null and scse_isabsent='Y'))
group by rscs_stu_id ,stud_enrollment_number,stud_fname, stud_id,cour_code,scse_gpa_actual,scse_letter_grade,cpse_credits,scse_course_result,scse_course_attempt,scse_course_type,scse_semester_attempt,cour_name,stud_enrollment_number
order by rscs_stu_id, scse_semester_attempt

--Dt. 18/11/16
select stud_id,stud_enrollment_number,stud_tiss_email, stud_fname
from exams_mst_students where stud_enrollment_number in 
('GM2015CO016','GM2015CO017','GM2015CO018','GM2015CO019','GM2015CODP021','GM2015CODP022','GM2015CODP023','GM2015CODP024','GM2015CODP025','GM2015LE021',
'GM2015LE022','GM2015LE023','GM2015LE024','GM2015LE025','GM2015LE026','GM2015LE027','GM2015PH016','GM2015PH017','GM2015PH018','GM2015PH019','GM2015PH020',
'GM2015EESD022','GM2015EESD023','GM2015EESD024','GM2015EESD025','GM2015EESD027','GM2015EESD028','GM2015EESD029','GM2015LSSP017','GM2015LSSP018','GM2015LSSP019',
'GM2015LSSP020','GM2015LSSP021','GM2015LSSP022','GM2015LSSP023','GM2015PC015','GM2015PC016','GM2015SSA017','GM2015SSA018','GM2015SSA019','GM2015SSA020','GM2016CO015',
'GM2016CODP021','GM2016CODP022','GM2016CODP023','GM2016CODP024','GM2016CODP025','GM2016CODP026','GM2016CODP027','GM2016CODP028','GM2016LE020','GM2016LE021','GM2016LE022',
'GM2016LE023','GM2016LE024','GM2016LE025','GM2016LE026','GM2016LE027','GM2016PH016','GM2016EESD019','GM2016EESD020','GM2016EESD021','GM2016EESD022','GM2016EESD024','GM2016LSSP016',
'GM2016LSSP017','GM2016LSSP018','GM2016LSSP019','GM2016LSSP020','GM2016LSSP021','GM2016LSSP022','GM2016PC016','GM2016PC017','GM2016PC018','GM2016PC019','GM2016PC020','GM2016SSA018','GM2016SSA020') order by stud_enrollment_number

select distinct stud_enrollment_number,prog_name from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_campus_school_programes_courses on cpse_prog_id=rcp_prog_id and cpse_cour_id=rcp_cour_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_programs on cpse_prog_id=prog_id
where stud_deleted='N' and stud_status='OnRole' and stud_campus_id=1 and rcp_school_id =1 and cpse_cour_id=125
order by prog_name,stud_enrollment_number

--Dt. 23/11/16
--for searching course evaluation Mphil SHSS CE details
select * from tcourse_evaluation_stu_hallticket  where sh_stu in (
select cast (stud_id as varchar) from exams_mst_students where stud_prog_id in (66,69) and stud_deleted='N' and stud_status='OnRole')

select * from exams_mst_students where stud_prog_id in (66,69) and stud_status='OnRole' and stud_deleted='N' and stud_acba_id =10

--Dt. 28/11/16
update exams_mst_students set stud_sem_id=5 where stud_id in (
select stud_id from exams_mst_students where stud_status='OnRole' and stud_deleted='N' and stud_campus_id=2 and stud_acba_id=8 and stud_prog_id in (70,77)
)

--Dt. 29/11/16
select * from exams_mst_students where stud_enrollment_number like '2012%'

select stud_enrollment_number,stud_fname,stud_lname,cour_name,scse_gpa_actual,cpse_credits,scse_course_result, scse_course_attempt,scse_letter_grade,scse_semester_attempt,scse_created_datetime
from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on cpse_cour_id=cour_id
where scse_deleted='N' --and scse_semester_attempt='1' and rscs_sem_id=1 
and scse_cpse_id=rscs_cpse_id and rscs_deleted='N' 
and stud_status='OnRole' and rscs_stu_id=stud_id and stud_enrollment_number='M2015DM001'
order by stud_enrollment_number, cour_name


***************************************************************************************************************************************************************************************************************

select campus_name,empl_id,sch_name,empl_email,role_name,prog_name 
from exams_mst_employees 
inner join exams_mst_schools on empl_school_centre_id=sch_id
inner join exams_mst_campus on empl_campus_id=campus_id
inner join exams_mst_roles on empl_role_id=role_id
inner join exams_rel_campus_school_programes_courses on rcp_campus_id=empl_campus_id and sch_id=rcp_school_id
inner join exams_mst_programs on rcp_prog_id=prog_id
where empl_role_id=3 and empl_is_admin='N' and empl_deleted='N' and rcp_deleted='N' 
group by campus_name,empl_id,sch_name,empl_email,role_name,prog_name
order by campus_name,sch_name

--Total number of students in SSW in 16-18 batch
select * from exams_mst_students where stud_status='OnRole' and stud_deleted='N' and stud_acba_id =10 and stud_prog_id in  
(select distinct rcp_prog_id from exams_rel_campus_school_programes_courses inner join exams_mst_programs on rcp_prog_id=prog_id where rcp_campus_id=1 and rcp_school_id =1 and prog_id not in (17,18,83) and prog_prty_id=1)

--Dt:- 30/11/2016 for searching the students of SSW who has given feedback for common course i.e. 'Social Case Work' & 'Social Group Work'
select stud_enrollment_number,prog_name,eval_sem_id,cour_name,tcourse_evaluation_mst_eval.* from tcourse_evaluation_mst_eval 
inner join exams_mst_programs on eval_prog_id=prog_id 
inner join exams_mst_courses on eval_course_id = cour_id 
inner join exams_mst_students on eval_stu=cast(stud_id as varchar)
where eval_stu in (
select cast(stud_id as varchar) from exams_mst_students where stud_status='OnRole' and stud_deleted='N' and stud_acba_id =10 and stud_prog_id in  
(select distinct rcp_prog_id from exams_rel_campus_school_programes_courses inner join exams_mst_programs on rcp_prog_id=prog_id 
where rcp_campus_id=1 and rcp_school_id =1 and prog_id not in (17,18,83) and prog_prty_id=1)) and eval_course_id in (127,128)
order by prog_name,cour_name,stud_enrollment_number

-- Students in 16-18 batch
select * from exams_mst_students where stud_status='OnRole' and stud_deleted='N' and stud_prog_id=2 and stud_acba_id=10

select distinct prog_name,cour_name,stud_enrollment_number,acba_name,stud_sem_id,rscs_faculty_empl_id
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_mst_courses on rscs_course_id =cour_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
where stud_status='OnRole' and stud_deleted='N' and rscs_deleted='N' and rscs_faculty_empl_id is null
and stud_prog_id in (select distinct rcp_prog_id from exams_rel_campus_school_programes_courses inner join exams_mst_programs on rcp_prog_id=prog_id 
where rcp_campus_id=1 and rcp_school_id =1 and prog_id not in (17,18,83) and prog_prty_id=1) and stud_acba_id in (10) and cour_id in (126,127,128,48) and stud_campus_id=1
order by prog_name,cour_name

-- Students in 16-18 batch of mumbai campus
select * from exams_mst_students where stud_deleted='N' and stud_status='OnRole' and stud_prog_id in (select distinct rcp_prog_id from exams_rel_campus_school_programes_courses inner join exams_mst_programs on rcp_prog_id=prog_id 
where rcp_campus_id=1 and rcp_school_id =1 and prog_id not in (17,18,83) and prog_prty_id=1) and stud_acba_id in (10) and stud_campus_id=1


select * from exams_rel_students_courses_semesters where scse_rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id in (
select stud_id from exams_msT_students where stud_enrollment_number in ('M2015SE008','M2015SE002','M2015SE009','M2015SE010','M2015SE011','M2015SE014','M2015SE017','M2015SE019','M2015SE020','M2015SE021','M2015SE025','M2015SE028','M2015SE030')) and rscs_course_type='C' and rscs_cpse_id=1335) and scse_cpse_id =1335

**************************************************************************************************************************************************************************************************************

--Query to search courses offered in 15-17 batch as CBCS as well as Mandatory
select cour_id,cour_name from exams_mst_courses where cour_id in (
select distinct rscs_course_id from tcourse_evaluation_rel_stu_courses , exams_mst_courses
where rscs_course_id in (select distinct rscs_course_id from tcourse_evaluation_rel_stu_courses inner join exams_mst_courses on rscs_course_id=cour_id
where rscs_sem_id=3 and rscs_course_type ='C' and rscs_batch_id=1) and rscs_sem_id=3 and rscs_course_type ='M' and rscs_batch_id=1)


update exams_rel_students_courses_semesters set scse_deleted='Y' where scse_id in (
select scse_id from exams_rel_students_courses_semesters where scse_cpse_id=1335 and scse_id in (52148,52149,52151,52146,52152,52153,52154,52155,52156,52157,52158,52150,52147))


select * from tcourse_evaluation_rel_stu_courses inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id where scse_id in (--310,309,319,315,328,318,312,320,329,311,305,321,325
52146,52147,52148,52149,52150,52151,52152,52153,52154,52155,52156,52157,52158,27458,27102,24519,27236,27419,27610,27406,27450,27675,27280,27235,27302,27220) order by scse_deleted

update tcourse_evaluation_rel_stu_courses set rscs_deleted='N' where rscs_id in (41876,44710,44825,44840,44841,44885,44907,45011,45024,45055,45063,45215,45273)

update exams_rel_students_courses_semesters set scse_deleted='N' where scse_id in (24519,27102,27220,27235,27236,27280,27302,27406,27419,27450,27458,27610,27675)

delete from tcourse_evaluation_rel_stu_courses where rscs_id in (45024,41876,44840,45273,44710,44825,45011,44907,45215,44841,44885,45063,45055)

select * from tcourse_evaluation_rel_stu_courses where rscs_stu_id in (643,650,645,642,644,651,637,640,646,639,653,652,638,641,4128,648,647) and rscs_cpse_id in (3552,1343) and rscs_deleted='N'
select * from exams_rel_students_courses_semesters where scse_rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id in (643,650,645,642,644,651,637,640,646,639,653,652,638,641,4128,648,647) and rscs_cpse_id in (3552,1343) and rscs_deleted='N') 


--Query to search courses offered in 15-17 batch as CBCS as well as Mandatory
select cour_id,cour_name from exams_mst_courses where cour_id in (
select distinct rscs_course_id from tcourse_evaluation_rel_stu_courses , exams_mst_courses
where rscs_course_id in (select distinct rscs_course_id from tcourse_evaluation_rel_stu_courses inner join exams_mst_courses on rscs_course_id=cour_id
where rscs_sem_id=3 and rscs_course_type ='C' and rscs_batch_id=1 and rscs_deleted='N') and rscs_sem_id=3 and rscs_course_type ='M' and rscs_batch_id=1 and rscs_deleted='N')

-- mandatory course scse records
select * from exams_rel_students_courses_semesters where scse_cpse_id=2521 and scse_rscs_id in (63377,63389,63380,63391,63383,63379,63386,63396,63382,63381,63387,63385,63378)
**************************************************************************************************************************************************************************************************************

select * from exams_rel_students_courses_semesters where scse_rscs_id in (
select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id in (
select stud_id from exams_msT_students where stud_enrollment_number in ('M2015SE008','M2015SE002','M2015SE009','M2015SE010','M2015SE011','M2015SE014','M2015SE017','M2015SE019','M2015SE020','M2015SE021','M2015SE025','M2015SE028','M2015SE030')) and rscs_course_type='C' and rscs_cpse_id=1335) and scse_cpse_id =1335


select * from exams_rel_students_courses_semesters
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
where scse_rscs_id=rscs_id and rscs_stu_id=stud_id and scse_course_attempt='Re' and scse_cpse_id=1335
and scse_deleted='N' and rscs_deleted='N' and stud_status='OnRole' and stud_deleted='N' --and rscs_cpse_id= scse_cpse_id 
and scse_course_result='' 
order by stud_enrollment_number

--working cbcs_courses_view.py query
select * from exams_rel_students_courses_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students 
where scse_rscs_id=rscs_id and rscs_stu_id=stud_id and scse_course_attempt='Re' and scse_cpse_id=1335 
and scse_deleted='N' and scse_course_type=rscs_course_type and rscs_deleted='N' order by stud_enrollment_number



select * from tcourse_evaluation_rel_stu_courses inner join (select * from exams_rel_students_courses_semesters where scse_id in (--310,309,319,315,328,318,312,320,329,311,305,321,325
52146,52147,52148,52149,52150,52151,52152,52153,52154,52155,52156,52157,52158,27458,27102,24519,27236,27419,27610,27406,27450,27675,27280,27235,27302,27220)) as t on t.scse_rscs_id=rscs_id

select * from tcourse_evaluation_rel_stu_courses inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id where scse_id in (--310,309,319,315,328,318,312,320,329,311,305,321,325
52146,52147,52148,52149,52150,52151,52152,52153,52154,52155,52156,52157,52158,27458,27102,24519,27236,27419,27610,27406,27450,27675,27280,27235,27302,27220) order by scse_deleted

select * from exams_rel_students_courses_semesters where scse_rscs_id in (63391,63378,63377,63389,63385,63380,63383,63379,63386,63396,63382,63381,63387) and scse_cpse_id=1335
select * from tcourse_evaluation_rel_stu_courses where rscs_id in (63391,63378,63377,63389,63385,63380,63383,63379,63386,63396,63382,63381,63387) and rscs_cpse_id=1335

select * from tcourse_evaluation_rel_stu_courses right join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
where rscs_course_id =325 and scse_deleted='N'

select * from exams_rel_students_courses_semesters where scse_rscs_id in 
(select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_cpse_id=2521) order by scse_course_type
 and scse_cpse_id=2521 


select stud_enrollment_number,stud_fname,stud_lname,cour_name,scse_gpa_actual,cpse_credits,scse_course_result, scse_course_attempt,scse_course_type,scse_semester_attempt
from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on cpse_cour_id=cour_id
where scse_deleted='N' and scse_semester_attempt='1' and rscs_sem_id=1 and scse_cpse_id=rscs_cpse_id and rscs_deleted='N' 
and stud_status='OnRole' and rscs_stu_id=stud_id and stud_enrollment_number='M2015CCSS004'
order by stud_enrollment_number, cour_name


*************************************************************************************************************************************************************************************************************
--finally updated records on 2/11/16 cbcs - mandatory issue
select * from exams_rel_students_courses_semesters where scse_rscs_id in (63391,63378,63377,63389,63385,63380,63383,63379,63386,63396,63382,63381,63387) and scse_cpse_id=1335

--finally updated records for below cpseid where EC course corectly shown in cpse,scse but not in rscs
update tcourse_evaluation_rel_stu_courses set rscs_batch_id=1, rscs_sem_id=1 where rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_cpse_id =700)


--search to find mismatch in cpse,scse,rscs
select scse_id,scse_course_type,rscs_id,rscs_course_type,cpse_id,cpse_cour_type from exams_rel_students_courses_semesters 
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
where cpse_deleted='N' and rscs_deleted='N' and scse_deleted='N' and rscs_batch_id=1 
and (rscs_course_type!=scse_course_type or cpse_cour_type!=rscs_course_type or scse_course_type!=cpse_cour_type)
order by cpse_id

*************************************************************************************************************************************************************************************************************
--Dt. 8/12/16
--list of all students of 16-18, 15-17 taken cbcs courses
select distinct prog_name,stud_enrollment_number, stud_fname ,stud_lname,cour_name,cpse_capacity,cpse_day,cpse_course_variant,seme_name,acba_name,stud_tiss_email,stud_mobile_number
from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id and rscs_deleted='N'
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_mst_courses on rscs_course_id=cour_id 
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_programs on stud_prog_id=prog_id
where rscs_course_type='C' and (rscs_batch_id=10 and rscs_sem_id=2) or (rscs_batch_id=1 and rscs_sem_id=4) and rscs_deleted='N' and scse_deleted='N'
and cpse_prog_id=83 and stud_status='OnRole' and stud_deleted='N' and stud_campus_id=1 and stud_prog_type_id=1 --and rscs_created_datetime > '2016-10-15'
--and cpse_capacity <1000 
order by seme_name,acba_name,stud_enrollment_number

-- cbcs courses enrolled by a student till date
select stud_enrollment_number,stud_fname ,stud_lname, cour_name,sch_name, seme_name,cpse_cour_type from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on rscs_sem_id=seme_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_campus_school_programes_courses on cpse_cour_id=rcp_cour_id and cpse_prog_id=rcp_prog_id
inner join exams_mst_schools on rcp_school_id=sch_id
where rscs_course_type='C' and rscs_deleted='N' and scse_deleted='N' and stud_enrollment_number='M2015RG004'

--courses offered as non-credit
select distinct campus_name,prog_name,cour_name,acba_name,seme_name,cpse_cour_type 
from exams_rel_courses_programes_semesters
inner join exams_rel_campus_school_programes_courses on cpse_prog_id=rcp_prog_id and cpse_cour_id=rcp_cour_id
inner join exams_mst_courses on rcp_cour_id=cour_id
inner join tcourse_evaluation_rel_stu_courses on rscs_course_id=rcp_cour_id
inner join exams_mst_programs on rcp_prog_id=prog_id
inner join exams_mst_campus on rcp_campus_id=campus_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
where rcp_deleted='N' and rscs_deleted='N' and cour_deleted='N' and cpse_cour_type='NC'
order by campus_name,seme_name

*************************************************************************************************************************************************************************************************************
update auth_user set is_active='FALSE' where username = 'leonilla'

delete from auth_user where username ='rajul.krishnan'


update exams_rel_courses_programes_semesters set cpse_cour_id=582 where cpse_cour_id=1290 and cpse_id=2545

select * from tcourse_evaluation_rel_stu_courses where rscs_deleted='N' and rscs_course_id=582 and rscs_sem_id=4 and rscs_batch_id=1 and rscs_cpse_id=2545

update tcourse_evaluation_rel_stu_courses set rscs_course_id = 582 where rscs_deleted='N' and rscs_course_id=1290 and rscs_sem_id=4 and rscs_batch_id=1 and rscs_cpse_id=2545


select * from tcourse_evaluation_rel_stu_courses where rscs_cpse_id in (2545) and rscs_deleted='N'


select * from exams_rel_courses_programes_semesters where cpse_id in (2545)
*************************************************************************************************************************************************************************************************************
--Dt: 16/12/16
--students to search who has scored letter grade 'E'
select prog_name,acba_name,cour_name ,cpse_seme_id,cpse_isconfirm from exams_rel_students_courses_semesters 
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join exams_mst_programs on cpse_prog_id=prog_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
inner join exams_mst_courses on cpse_cour_id=cour_id
where scse_letter_grade ='E' and rscs_deleted='N' and scse_deleted='N'
order by prog_name

--SEARCH STUDENT WITH FAILED AND IMPROVEMENT ENTRIES
select stud_enrollment_number,stud_fname,stud_lname,prog_name,cour_name,scse_gpa_actual,scse_course_attempt,scse_semester_attempt from exams_rel_students_courses_semesters 
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_mst_programs on cpse_prog_id=prog_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
where scse_course_attempt in ('S1','I') and scse_gpa_actual is not null and prog_id!=83 and stud_campus_id=1 and stud_status='OnRole'
order by stud_enrollment_number,cour_name

************************************************************************************************************************************************************************************************************

--query to find marks editted by me
select distinct cpse_id,campus_name,prog_name,cour_name,scse_semester_attempt,rscs_batch_id,scse_last_modified_datetime from exams_rel_students_courses_semesters 
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_programs on cpse_prog_id=prog_id
inner join exams_mst_campus on cpse_campus_id=campus_id
where scse_last_modified_empl_id='238' 
and cpse_isconfirm='N' and scse_isconfirm='N' and scse_course_type not in ('C') and scse_deleted='N' and stud_status='OnRole' and stud_deleted='N'
order by prog_name,scse_semester_attempt

***********************************
--Dt.: 19/12/16 RAW queries
		--CPSE
select * from exams_rel_courses_programes_semesters where cpse_id=2441

update exams_rel_courses_programes_semesters set cpse_cour_type='AU' where cpse_id=2441

--SCSE
select * from exams_rel_students_courses_semesters where scse_cpse_id=2441 and scse_deleted='N'

update exams_rel_students_courses_semesters set scse_letter_grade='',scse_gpa_actual=null,scse_gpa_rounded='' and scse_course_type='AU' where scse_deleted='N' and scse_cpse_id=2441

update exams_rel_students_courses_semesters set scse_course_type='AU' where scse_deleted='N' and scse_cpse_id=2441

--RSCS
select * from tcourse_evaluation_rel_stu_courses where rscs_deleted='N' and rscs_cpse_id=2441

update tcourse_evaluation_rel_stu_courses set rscs_course_type='AU' where rscs_deleted='N' and rscs_cpse_id=2441


-------------------------------SERVER--------------------------
--CPSE
select * from exams_rel_courses_programes_semesters where cpse_id=1103
select * from exams_rel_courses_programes_semesters where cpse_id=2441
update exams_rel_courses_programes_semesters set cpse_cour_type='AU' where cpse_id=2441

--SCSE
select * from exams_rel_students_courses_semesters where scse_cpse_id=2441 and scse_deleted='N'

update exams_rel_students_courses_semesters set scse_letter_grade='',scse_gpa_actual='',scse_course_result='' and scse_course_type='AU' where scse_deleted='N' and scse_cpse_id=2441

--RSCS
select * from tcourse_evaluation_rel_stu_courses where rscs_deleted='N' and rscs_cpse_id=2441

update tcourse_evaluation_rel_stu_courses set rscs_course_type='AU' where rscs_deleted='N' and rscs_cpse_id=2441


select *  from exams_rel_courses_programes_semesters where cpse_id in (993,994,995,996,997,998,999,1000)
select * from exams_rel_students_courses_semesters  where scse_cpse_id in (993,994,995,996,997,998,999,1000)


select * from exams_rel_students_courses_semesters where scse_cpse_id in (
select cpse_id from exams_rel_courses_programes_semesters where cpse_cour_type='AU' and cpse_acba_id=1 and cpse_seme_id=2) and scse_deleted='N' 

select * from exams_mst_students where stud_id=1246


**************************************
-- Crucial Data Dt:20/12/16
--search the programs who might have generated the summary sheet and grade card
select distinct prog_id from exams_mst_students 
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_rel_courses_programes_semesters on stud_campus_id=cpse_campus_id and prog_id=cpse_prog_id
inner join exams_mst_courses on cpse_cour_id =cour_id
inner join tcourse_evaluation_rel_stu_courses on cpse_id=rscs_cpse_id and rscs_batch_id=1 and rscs_sem_id=3
inner join exams_rel_students_courses_semesters on cpse_id=scse_cpse_id and rscs_id=scse_rscs_id 
where stud_status='OnRole' and stud_deleted='N' and rscs_deleted='N' and scse_deleted='N' 
and stud_campus_id=1 and stud_acba_id=1 and stud_sem_id=3 and scse_isconfirm='Y'
order by prog_id

--select a student enrolled for any of these programs and who has failed or was absent for cbcs exams
select stud_enrollment_number,stud_fname,prog_name,cour_name,scse_gpa_actual,scse_course_type,scse_isabsent,scse_semester_attempt from tcourse_evaluation_rel_stu_courses 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_programs on stud_prog_id=prog_id
where scse_deleted='N' and rscs_deleted='N' and rscs_batch_id=1 and rscs_sem_id=3 and scse_course_type='C' 
and scse_isconfirm='Y' 
and ((scse_isabsent='N' and scse_course_result='F') or scse_isabsent='Y')
and stud_status='OnRole' and stud_deleted='N'
order by prog_name,stud_enrollment_number

--15-17 batch IIIrd sem programs for which grade cards may affect
select distinct prog_name--,cour_name,scse_gpa_actual,scse_course_type,scse_isabsent,scse_semester_attempt 
from tcourse_evaluation_rel_stu_courses 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_programs on stud_prog_id=prog_id
where scse_deleted='N' and rscs_deleted='N' and rscs_batch_id =1 and rscs_sem_id=3 and scse_course_type='C' 
and scse_isconfirm='Y' 
and ((scse_isabsent='N' and scse_course_result='F') or scse_isabsent='Y')
and stud_status='OnRole' and stud_deleted='N'
order by prog_name --,stud_enrollment_number

--searching the students of M&C 16-18 batch Ist sem who have not filled course evaluation
select stud_enrollment_number,stud_fname,stud_lname,stud_tiss_email from exams_mst_students where stud_id in (select distinct rscs_stu_id from (select rscs_sem_id,rscs_course_id,rscs_stu_id from (
select tcourse_evaluation_rel_stu_courses.* from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id and stud_acba_id=rscs_batch_id and rscs_sem_id=stud_sem_id
where stud_status='OnRole' and stud_deleted='N' and stud_acba_id=10 and stud_sem_id=1 and stud_prog_id=16
order by stud_id,stud_prog_id ) as table1 
except
select eval_sem_id,eval_course_id,cast (eval_stu as int) from (select * from tcourse_evaluation_mst_eval where eval_prog_id=16 and eval_sem_id=1 and eval_stu in (
select distinct eval_stu from tcourse_evaluation_mst_eval 
inner join exams_mst_students on cast(eval_stu as int)=stud_id
where eval_prog_id=16 and eval_sem_id=1 and stud_deleted='N' and stud_status='OnRole' and stud_acba_id=10 and stud_sem_id=1) ) as table2) as table3 )
order by stud_enrollment_number

-- Raw Query 15-17 batch M&C students 

select * from exams_mst_students where stud_id in (
select distinct rscs_stu_id from (
select rscs_sem_id,rscs_course_id,rscs_stu_id 
from (select tcourse_evaluation_rel_stu_courses.* from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id and stud_acba_id=rscs_batch_id and rscs_sem_id=stud_sem_id
where stud_status='OnRole' and stud_deleted='N' and stud_acba_id=1 and stud_sem_id=3 and stud_prog_id=16 and rscs_course_type<>'C'
order by stud_id,stud_prog_id ) as table1 
except
select eval_sem_id,eval_course_id,cast (eval_stu as int) from (select * from tcourse_evaluation_mst_eval where eval_prog_id=16 and eval_sem_id=3 and eval_stu in (
select distinct eval_stu from tcourse_evaluation_mst_eval 
inner join exams_mst_students on cast(eval_stu as int)=stud_id
where eval_prog_id=16 and eval_sem_id=3 and stud_deleted='N' and stud_status='OnRole' and stud_acba_id=1 and stud_sem_id=3) ) as table2
) as table3 
) order by stud_enrollment_number

--select student if enrolled number of courses for the batch is = to course evaluation given
select stud_enrollment_number,rscs_course_id from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
where stud_deleted='N' and stud_status='OnRole' and stud_acba_id=10 and stud_sem_id=1 

*****************************************************************************************************************************************************************************************************
--Dt. 29/12/16
--HRM student number of courses enrolled 
select rscs_stu_id,count (rscs_id) from tcourse_evaluation_rel_stu_courses inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
where rscs_deleted='N' and cpse_deleted='N' and cpse_prog_id=21 and cpse_acba_id=10 group by rscs_stu_id

--Dt. 6/1/17
-- cbcs enrollments after a given date
select distinct stud_enrollment_number 
from tcourse_evaluation_rel_stu_courses inner join exams_mst_students  on rscs_stu_id=stud_id 
where rscs_deleted='N' and rscs_created_datetime >= '2017-01-05 12:23:52.902698+05:30' and stud_status='OnRole' and stud_deleted='N' and stud_campus_id=1

*****************************************************************************************************************************************************************************************************
--Referred by Ms. Rupali Vaity : EXTREMELY IMPORTANT query to find out reference tables and the foreign key based on the master table (primary key)
SELECT tc.table_name, kcu.column_name FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY' AND ccu.table_name='exams_mst_campus';

*****************************************************************************************************************************************************************************************************
--Dt. 25/01/17
-- query to select data based on primary key table
SELECT
    tc.constraint_name, tc.table_name, kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name='exams_mst_students';

-- query to search all tables and their foreign keys
select tc.table_schema, tc.table_name, kc.column_name
from 
    information_schema.table_constraints tc
    join information_schema.key_column_usage kc 
        on kc.table_name = tc.table_name and kc.table_schema = tc.table_schema
where 
    tc.constraint_type = 'PRIMARY KEY'
    and kc.position_in_unique_constraint is not null
order by tc.table_schema,
         tc.table_name,
         kc.position_in_unique_constraint;

-- query to check students current semester for SHSS exclusively
select distinct exams_mst_students.* from exams_mst_students inner join exams_rel_campus_school_programes_courses on stud_prog_id=rcp_prog_id and rcp_school_id=4 and stud_sem_id not in (2,4) and stud_prog_type_id=1


update tcourse_evaluation_rel_stu_courses set rscs_course_id=505 where rscs_cpse_id=3511
select * from tcourse_evaluation_rel_stu_courses where rscs_cpse_id=3511

select * from tcourse_evaluation_mst_eval where eval_prog_id=77 and eval_course_id=142

update tcourse_evaluation_mst_eval set eval_course_id=505 where eval_prog_id=77 and eval_course_id=142 
*****************************************************************************************************************************************************************************************************
select exams_convocation_details.* from exams_mst_students inner join exams_convocation_details on stud_id=convocation_stud_id where stud_enrollment_number='H2014BAMA019'

--Dt.01/01/2017 convocation form details 15-17, 14-17
select campus_name,stud_enrollment_number,convocation_fname,convocation_mname,convocation_lname,acba_name,prog_name from exams_convocation_details 
inner join exams_mst_students on convocation_stud_id=stud_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
where convocation_id > 1207 and convocation_deleted='N' and stud_status='OnRole' and stud_deleted='N' 
order by campus_name,prog_name,stud_enrollment_number

--students who has not filled convocation details 
select * from exams_mst_students where stud_id not in (select convocation_stud_id--,campus_name,stud_enrollment_number,convocation_fname,convocation_mname,convocation_lname,acba_name,prog_name,convocation_created_datetime
from exams_convocation_details 
inner join exams_mst_students on convocation_stud_id=stud_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
where --convocation_id > 1207 
convocation_created_datetime > '2017-01-01'and convocation_deleted='N' and stud_status='OnRole' and stud_deleted='N' 
order by campus_name,prog_name,stud_enrollment_number)
and stud_acba_id in (1,8,9,12,13,14) and stud_prog_type_id!=7 and stud_status='OnRole' and stud_deleted='N'  

----select cbcs courses offered in respective school for 2nd and 4th semester
select distinct sch_id,sch_name,cour_id,cour_name,empl_fname --,exams_rel_courses_programes_semesters.* 
from exams_rel_campus_school_programes_courses
inner join exams_rel_courses_programes_semesters on rcp_cour_id=cpse_cour_id
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_mst_schools on rcp_school_id=sch_id
inner join exams_mst_employees on rcp_school_id=empl_school_centre_id
where rcp_deleted='N' and cpse_deleted='N' and cpse_cour_type='C' and rcp_prog_id='83' and ((cpse_seme_id =2 and cpse_acba_id=10) or (cpse_seme_id =4 and cpse_acba_id=1)) 
and empl_role_id=3 --and rcp_school_id=1
order by sch_id,cour_id

*****************************************************************************************************************************************************************************************************
--Dt. 08/02/17
--displays each semester and the courses as CBCS 15-17 batch
select stud_enrollment_number ,stud_fname, stud_lname ,cour_name,cpse_seme_id--, count(cpse_credits) as "Total CBCS courses appeared",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id=1 and stud_acba_id=1 and stud_sem_id=4 --and cpse_seme_id in (2,3)
group by stud_enrollment_number,stud_fname, stud_lname, cour_name,cpse_seme_id--, cpse_credits
--having count(stud_enrollment_number)>4
order by stud_enrollment_number,cpse_seme_id 

--displays each semester and the courses as CBCS 15-17 batch
select stud_enrollment_number ,stud_fname, stud_lname ,cour_name,cpse_seme_id--, count(cpse_credits) as "Total CBCS courses appeared",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id=1 and stud_acba_id=1 and stud_sem_id=4
and stud_id in (select stud_id from exams_mst_students where stud_enrollment_number in ('M2015DM006',
'M2015DM024',
'M2015DSA010',
'M2015DSA016',
'M2015DTA005',
'M2015HE007',
'M2015HE020',
'M2015HE035',
'M2015RG010',
'M2015RG011'
))
group by stud_enrollment_number,stud_fname, stud_lname, cour_name,cpse_seme_id--, cpse_credits
order by stud_enrollment_number,cpse_seme_id 

--Mumbai students of 15-17 batch enrolled for more than 4 cbcs courses 
select stud_enrollment_number ,stud_fname, stud_lname, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id=1 and stud_acba_id=1 and scse_course_attempt='Re' and stud_sem_id=4 --and rscs_sem_id=4 
--and stud_id in (select stud_id from exams_mst_students where stud_enrollment_number in ('M2015DM006','M2015DM024','M2015DSA010','M2015DSA016','M2015DTA005','M2015HE007','M2015HE020','M2015HE035','M2015RG010','M2015RG011'))
group by stud_enrollment_number,stud_fname, stud_lname, cpse_credits
having count(cpse_credits)>4
order by stud_enrollment_number

update exams_mst_students set stud_campus_id =5 where stud_id in(select * from exams_mst_students where stud_last_modified_datetime>'2017-02-07' and stud_prog_id=38)

select * from exams_rel_courses_programes_semesters where cpse_deleted='N' and cpse_total_hours is null and cpse_acba_id !=2
****************************************************************************************************************************************************************************************************

--Dt. 13/02/17
--query to find out convocation form filled details
select stud_enrollment_number, convocation_fname,convocation_mname,convocation_lname,prog_name,acba_name,convocation_last_modified_datetime
from exams_mst_students 
inner join exams_convocation_details on stud_id=convocation_stud_id 
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_status='OnRole' and stud_deleted='N' and stud_prog_id=88
--and stud_acba_id in (12,13,14,15,2) 
and convocation_last_modified_datetime >= '2017-01-01' order by stud_enrollment_number

select * from exams_mst_students where stud_acba_id in (13,2) and stud_prog_id =88 order by stud_fname


****************************************************************************************************************************************************************************************************
--query to find out convocation form filled details PMRDF
select stud_id,stud_enrollment_number, convocation_fname,convocation_mname,convocation_lname,prog_name,acba_name,convocation_last_modified_datetime
from exams_mst_students 
inner join exams_convocation_details on stud_id=convocation_stud_id 
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_status='OnRole' and stud_deleted='N' and stud_prog_id=88 
--and stud_acba_id in (12,13,14,15,2) 
and convocation_last_modified_datetime >= '2017-01-01' order by stud_enrollment_number
		
select stud_enrollment_number,stud_tiss_email,stud_fname,stud_mname,stud_lname,acba_name from exams_mst_students inner join exams_mst_academic_batches on stud_acba_id=acba_id
where stud_acba_id in (2) and stud_prog_id =88 and stud_status='OnRole' and stud_deleted='N' order by stud_fname 

--Referred by Ms. Rupali Vaity : EXTREMELY IMPORTANT query to find out reference tables and the foreign key based on the master table (primary key)
SELECT tc.table_name, kcu.column_name FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY' AND ccu.table_name='exams_mst_students';

--12 students of PMRDF who 14-16 batch who are to be updated in convocation
select * from exams_mst_students where stud_id in (4901,4903,4908,4912,4914,4915,4920,4921,4927,4928,4930,4935)
select * from exams_mst_students where stud_id in (7035,7043,7036,7051,7045,7041,7057,7055,7061,7054,7044,7056)

select * from exams_mst_students where stud_deleted='N' and stud_status='OnRole' and stud_prog_id=88 and stud_acba_id=12

select * from exams_convocation_details where convocation_stud_id in (select stud_id from exams_mst_students where stud_prog_id=88 and stud_acba_id =2)

--query to set pmrdf 14-16 batch students as deleted='Y'

update exams_mst_students set stud_deleted='Y' where stud_id in (select stud_id from exams_mst_students where stud_prog_id=88 and stud_acba_id =2)
	 
-- MPhil Convocation15-17
select campus_name,stud_enrollment_number,convocation_fname,convocation_mname,convocation_lname,acba_name,prog_name,convocation_dob,convocation_permanentadd,convocation_mobile_number,convocation_research_title from exams_convocation_details inner join exams_mst_students on convocation_stud_id=stud_id inner join exams_mst_campus on stud_campus_id=campus_id inner join exams_mst_programs on stud_prog_id=prog_id inner join exams_mst_academic_batches on stud_acba_id=acba_id where convocation_id > 1207 and convocation_deleted='N' and stud_status='OnRole' and stud_deleted='N' and stud_prog_type_id=5 order by campus_name,prog_name,stud_enrollment_number


--Important query to concatenate Month year from database

select textcat(textcat (cpby_sem1_from, ' - '), cpby_sem1_to) from exams_rel_campus_prog_batch_year_sems where cpby_camp_id_id=1 and cpby_prog_id_id=88 and cpby_acba_id_id=12

*****************************************************************************************************************************************************************************************************

--Dt. 22/02/17
--PMRDF
select * from exams_mst_students inner join exams_convocation_details on stud_id=convocation_stud_id
where stud_prog_id=88 and stud_status='OnRole' and stud_deleted='N' 

select campus_name,progtype_name,prog_name,stud_enrollment_number,convocation_fname,convocation_mname,
convocation_lname,acba_name,convocation_dob,convocation_permanentadd,convocation_mobile_number,convocation_research_title 
from exams_convocation_details inner join exams_mst_students on convocation_stud_id=stud_id 
inner join exams_mst_campus on stud_campus_id=campus_id 
inner join exams_mst_programs on stud_prog_id=prog_id 
inner join exams_mst_academic_batches on stud_acba_id=acba_id 
inner join exams_mst_programme_type on stud_prog_type_id=progtype_id
where convocation_stud_id!=1233 and convocation_deleted='N' and stud_status='OnRole' 
and stud_deleted='N' and convocation_last_modified_datetime > '2017-01-01'
order by campus_name,prog_name,stud_enrollment_number

--excluded students PMRDF
select campus_name,progtype_name,prog_name,stud_enrollment_number ,convocation_fname,convocation_mname,convocation_lname,acba_name,convocation_dob,convocation_permanentadd,convocation_mobile_number,convocation_research_title 
from exams_convocation_details inner join exams_mst_students on convocation_stud_id=stud_id 
inner join exams_mst_campus on stud_campus_id=campus_id 
inner join exams_mst_programs on stud_prog_id=prog_id 
inner join exams_mst_academic_batches on stud_acba_id=acba_id 
inner join exams_mst_programme_type on stud_prog_type_id=progtype_id
where stud_deleted='N' and stud_status='OnRole' and convocation_deleted='N' and stud_enrollment_number in (select --campus_name,progtype_name,prog_name,
stud_enrollment_number --,convocation_fname,convocation_mname,convocation_lname,acba_name,convocation_dob,convocation_permanentadd,convocation_mobile_number,convocation_research_title 
from exams_convocation_details inner join exams_mst_students on convocation_stud_id=stud_id 
inner join exams_mst_campus on stud_campus_id=campus_id 
inner join exams_mst_programs on stud_prog_id=prog_id 
inner join exams_mst_academic_batches on stud_acba_id=acba_id 
inner join exams_mst_programme_type on stud_prog_type_id=progtype_id
where --convocation_id > 1207 and 
convocation_deleted='N' and stud_status='OnRole' and stud_deleted='N' and convocation_last_modified_datetime > '2017-01-01'
order by campus_name,prog_name,stud_enrollment_number)
 and stud_enrollment_number 
 not in ('B2015APCLP001','B2015APCLP002','B2015APCLP003','B2015APCLP005','B2015APCLP006','B2015APCLP007','B2015APCLP008','B2015APCLP009','B2015APCP023','MH2015APCLP018','B2015APCP001','B2015APCP002','B2015APCP003','B2015APCP004','B2015APCP006','B2015APCP007','B2015APCP009','B2015APCP010','B2015APCP011','B2015APCP014','B2015APCP015','B2015APCP016','B2015APCP017','B2015APCP018','B2015APCP019','B2015APCP020','B2015MPA001','B2015MPA003','B2015MPA004','B2015MH001','B2015MH003','B2015MH004','B2015MH005','B2015MH006','B2015MH007','B2015MH008','B2015MH009','B2015MH011','B2015MH012','G2014BAMA002','G2014BAMA003','G2014BAMA004','G2014BAMA005','G2014BAMA008','G2014BAMA009','G2014BAMA010','G2014BAMA012','G2014BAMA013','G2014BAMA014','G2014BAMA015','G2014BAMA017','G2014BAMA018','G2014BAMA020','G2014BAMA021','G2014BAMA022','G2014BAMA023','G2014BAMA025','G2014BAMA026','G2014BAMA027','G2014BAMA028','G2014BAMA029','G2014BAMA030','G2014BAMA035','G2014BAMA036','G2014BAMA037','G2014BAMA038','G2014BAMA039','G2014BAMA040','G2014BAMA041','G2014BAMA042','G2014BAMA044','G2014BAMA045','G2014BAMA047','G2014BAMA048','G2014BAMA050','G2014BAMA051','G2014BAMA052','G2014BAMA053','G2014BAMA054','G2014BAMA055','G2015EESD001','G2015EESD002','G2015EESD004','G2015EESD005','G2015EESD007','G2015EESD011','G2015EESD012','G2015EESD015','G2015EESD017','G2015EESD018','G2015EESD019','G2015EESD020','G2015EESD021','GM2015EESD022','GM2015EESD023','GM2015EESD024','GM2015EESD025','GM2015EESD027','GM2015EESD028','GM2015EESD029','G2015LSSP001','G2015LSSP002','G2015LSSP004','G2015LSSP005','G2015LSSP006','G2015LSSP007','G2015LSSP008','G2015LSSP009','G2015LSSP010','G2015LSSP011','G2015LSSP012','G2015LSSP013','G2015LSSP014','GM2015LSSP017','GM2015LSSP018','GM2015LSSP020','GM2015LSSP021','GM2015LSSP022','GM2015LSSP023','G2014PC004','G2015PC004','G2015PC005','G2015PC006','G2015PC007','G2015PC010','G2015PC011','G2015PC012','G2015PC013','G2015PC014','GM2015PC015','GM2015PC016','G2015SSA001','G2015SSA003','G2015SSA007','G2015SSA009','G2015SSA011','G2015SSA015','G2015SSA016','GM2015SSA017','GM2015SSA018','GM2015SSA019','GM2015SSA020','G2014CO002','G2015CO001','G2015CO002','G2015CO003','G2015CO005','G2015CO006','G2015CO007','G2015CO008','G2015CO009','G2015CO010','G2015CO014','G2015CO015','GM2015CO016','GM2015CO017','GM2015CO018','G2015CODP001','G2015CODP002','G2015CODP003','G2015CODP004','G2015CODP005','G2015CODP006','G2015CODP007','G2015CODP008','G2015CODP009','G2015CODP010','G2015CODP011','G2015CODP012','G2015CODP013','G2015CODP014','G2015CODP015','G2015CODP016','G2015CODP017','G2015CODP018','G2015CODP019','G2015CODP020','GM2015CODP021','GM2015CODP022','GM2015CODP023','GM2015CODP024','GM2015CODP025','G2014LE006','G2015LE002','G2015LE003','G2015LE004','G2015LE005','G2015LE006','G2015LE007','G2015LE008','G2015LE009','G2015LE010','G2015LE011','G2015LE014','G2015LE015','G2015LE016','G2015LE017','G2015LE018','G2015LE019','G2015LE020','GM2015LE021','GM2015LE022','GM2015LE023','GM2015LE025','GM2015LE026','GM2015LE027','G2015PH002','G2015PH003','G2015PH004','G2015PH005','G2015PH006','G2015PH007','G2015PH008','G2015PH009','G2015PH010','G2015PH011','G2015PH012','G2015PH013','G2015PH014','GM2015PH015','GM2015PH016','GM2015PH017','GM2015PH018','GM2015PH020','GM2015SS001','GM2015SS002','GM2015SS004','GM2015SS005','GM2015SS006','GM2015SS007','GM2015SS008','GM2015SS009','H2013BAMA05','H2014BAMA001','H2014BAMA003','H2014BAMA004','H2014BAMA005','H2014BAMA007','H2014BAMA008','H2014BAMA009','H2014BAMA010','H2014BAMA011','H2014BAMA012','H2014BAMA014','H2014BAMA015','H2014BAMA017','H2014BAMA018','H2014BAMA019','H2014BAMA020','H2014BAMA021','H2014BAMA023','H2014BAMA024','H2014BAMA025','H2014BAMA026','H2014BAMA027','H2014BAMA028','H2014BAMA029','H2014BAMA031','H2014BAMA032','H2014BAMA033','H2014BAMA035','H2014BAMA036','H2014BAMA037','H2014BAMA038','H2014BAMA039','H2014BAMA040','H2014BAMA041','H2014BAMA042','H2014BAMA043','H2014BAMA044','H2014BAMA045','H2014BAMA047','H2014BAMA048','H2014BAMA049','H2014BAMA050','H2014BAMA051','H2014BAMA052','H2014BAMA053','H2014BAMA054','H2014BAMA055','H2014BAMA056','H2014BAMA057','H2014BAMA058','H2014BAMA059','H2014BAMA060','H2014BAMA061','H2014BAMA062','H2014DS024','H2015DS002','H2015DS005','H2015DS006','H2015DS007','H2015DS009','H2015DS010','H2015DS012','H2015DS013','H2015DS014','H2015DS015','H2015DS016','H2015DS017','H2015DS018','H2015DS019','H2015DS020','H2015DS021','H2015DS023','H2015DS024','H2015DS025','H2015DS027','H2015DS028','H2015DS029','H2015DSM031','H2015DSM032','H2015DSM033','H2015DSM034','H2015DSM035','H2015DSM036','H2015HRM001','H2015HRM002','H2015HRM003','H2015HRM004','H2015HRM005','H2015HRM006','H2015HRM007','H2015HRM023','H2015HRMM008','H2015HRMM009','H2015HRMM010','H2015HRMM011','H2015HRMM012','H2015HRMM013','H2015HRMM014','H2015HRMM015','H2015HRMM016','H2015HRMM017','H2015HRMM018','H2015HRMM019','H2015HRMM021','H2015HRMM022','H2015ED003','H2015ED004','H2015ED006','H2015ED007','H2015ED008','H2015ED009','H2015ED011','H2015ED012','H2015ED013','H2015ED014','H2015ED015','H2015ED017','H2015ED020','H2015ED021','H2015ED023','H2015ED024','H2015ED026','H2015ED028','H2015ED029','H2015PPG001','H2015PPG002','H2015PPG007','H2015PPG012','H2015PPG013','H2015PPG014','H2015PPG016','H2015PPG023','H2015PPG024','H2015PPG025','H2015PPG027','H2015PPGM030','H2015PPGM031','H2015PPGM032','H2015PPGM033','H2015PPGM034','H2015PPGM035','H2014RDG005','H2014RDG012','H2015RDG001','H2015RDG002','H2015RDG003','H2015RDG004','H2015RDG005','H2015RDG006','H2015RDG007','H2015RDG008','H2015RDG010','H2015RDG011','H2015RDG012','H2015RDG014','H2015RDG015','H2015RDG016','H2015RDG017','H2015RDG019','H2015RDG020','H2015RDG021','H2015RDG023','H2015RDG024','H2015RDG025','H2015RDG026','H2015RDG027','H2015RDG028','H2015RDG034','H2015RDGM030','H2015RDGM032','H2015RDGM033','H2015RDGM035','H2014WS014','H2014WS024','H2015WS001','H2015WS005','H2015WS006','H2015WS007','H2015WS008','H2015WS009','H2015WS010','H2015WS011','H2015WS012','H2015WS013','H2015WS014','H2015WS015','H2015WS017','H2015WS019','H2015NRG001','H2015NRG002','H2015NRG003','H2015NRG004','H2015NRG006','H2015NRG007','H2015NRG008','H2015NRG009','H2015NRG012','H2015NRG013','H2015NRG014','H2015NRG016','H2015NRG018','H2015NRG019','H2015NRG020','H2015NRG021','H2015NRG022','H2015NRG023','H2015NRG024','H2015NRG026','H2015NRG027','H2015NRG028','H2015NRG029','HM2015ED001','HM2015ED002','HM2015ED003','HM2015ED004','HM2015ED006','HM2015ED007','HM2015WS001','MH2015APCLP001','MH2015APCLP003','MH2015APCLP006','MH2015APCLP007','MH2015APCLP008','MH2015APCLP009','MH2015APCLP010','MH2015APCLP012','MH2015APCLP013','MH2015APCLP014','MH2015APCLP016','MH2015APCLP017','MH2015APCLP020','M2015APCLP002','M2015APCLP003','M2015APCLP004','M2015APCLP005','M2015APCLP006','M2015APCLP007','M2015APCLP008','M2015APCLP009','M2015APCLP010','M2015APCLP011','M2015APCLP012','M2015APCLP013','M2015APCLP014','M2015APCLP015','M2015APCLP016','M2015APCLP017','M2015APCLP018','M2015APCLP019','M2015APCLP020','M2015APCLP021','M2015APCLP022','M2015APCLP023','MH2015APCLP002','M2015APCP001','M2015APCP002','M2015APCP003','M2015APCP004','M2015APCP005','M2015APCP006','M2015APCP007','M2015APCP008','M2015APCP009','M2015APCP010','M2015APCP011','M2015APCP012','M2015APCP013','M2015APCP014','M2015APCP015','M2015APCP016','M2015APCP017','M2015APCP018','M2015APCP019','M2015APCP021','M2015APCP022','M2015APCP023','M2015APCP024','M2015APCP025','M2015APCP026','M2015APCP027','M2015APCP028','M2015APCP029','M2014DS052','M2015DS001','M2015DS002','M2015DS003','M2015DS004','M2015DS005','M2015DS006','M2015DS007','M2015DS009','M2015DS011','M2015DS012','M2015DS014','M2015DS016','M2015DS017','M2015DS018','M2015DS019','M2015DS020','M2015DS021','M2015DS024','M2015DS025','M2015DS026','M2015DS028','M2015DS030','M2015DS031','M2015DS032','M2015DS033','M2015DS035','M2015DS037','M2015DS038','M2015DS039','M2015DS041','M2015DS042','M2015DS043','M2015DS044','M2015DS046','M2015DS047','M2015DS048','M2015DS050','M2015DS051','M2015DS053','M2015DS054','M2015GL001','M2015GL002','M2015GL007','M2015GL011','M2015GL012','M2015GL013','M2015GL014','M2015GL016','M2015GL017','M2015HRM001','M2015HRM002','M2015HRM003','M2015HRM005','M2015HRM006','M2015HRM007','M2015HRM008','M2015HRM009','M2015HRM010','M2015HRM011','M2015HRM012','M2015HRM013','M2015HRM014','M2015HRM015','M2015HRM016','M2015HRM017','M2015HRM018','M2015HRM019','M2015HRM020','M2015HRM023','M2015HRM024','M2015HRM025','M2015HRM026','M2015HRM027','M2015HRM028','M2015HRM029','M2015HRM031','M2015HRM032','M2015HRM033','M2015HRM034','M2015HRM035','M2015HRM036','M2015HRM037','M2015HRM038','M2015HRM039','M2015HRM040','M2015HRM041','M2015HRM042','M2015HRM043','M2015HRM044','M2015HRM045','M2015HRM046','M2015HRM047','M2015HRM048','M2015HRM049','M2015HRM050','M2015HRM052','M2015HRM053','M2015HRM054','M2015HRM056','M2015HRM057','M2015HRM059','M2015HRM060','M2015HRM061','M2015HRM062','M2015HRM063','M2015HRM064','M2015HRM066','M2015HRM067','M2015HRM069','M2015HRM071','M2015MC001','M2015MC003','M2015MC004','M2015MC005','M2015MC006','M2015MC007','M2015MC008','M2015MC009','M2015MC011','M2015MC012','M2015MC013','M2015MC014','M2015MC017','M2015MC020','M2015MC023','M2015MC025','M2015MC026','M2015MC027','M2015MC028','M2015WS001','M2015WS003','M2015WS005','M2015WS006','M2015WS008','M2015WS011','M2015WS013','M2015WS016','M2015WS018','M2015WS019','M2015WS020','M2015WS022','M2015WS025','M2015WS026','M2015WS027','M2015CCSS001','M2015CCSS002','M2015CCSS004','M2015CCSS005','M2015CCSS006','M2015CCSS008','M2015CCSS009','M2015CCSS010','M2015CCSS011','M2015CCSS012','M2015CCSS013','M2015CCSS015','M2015CCSS016','M2015CCSS017','PMRDFs12C1MDP01','PMRDFs12C1MDP12','PMRDFs12C1MDP25','PMRDFs12C1MDP32','PMRDFs12C1MDP41','PMRDFs12C2MDP02','PMRDFs12C2MDP03','PMRDFs12C2MDP10','PMRDFs14C1MDP05','PMRDFs14C1MDP09','PMRDFs14C1MDP10','PMRDFs14C1MDP13','PMRDFs14C1MDP19','PMRDFs14C1MDP44','PMRDFs14C1MDP52','PMRDFs14C1MDP53','PMRDFs14C1MDP57','PMRDFs14C1MDP59','PMRDFs14C1MDP62','PMRDFs14C2MDP02','PMRDFs14C2MDP04','PMRDFs14C2MDP10','PMRDFs14C2MDP18','PMRDFs14C2MDP40','PMRDFs14C2MDP41','PMRDFs14C2MDP47','PMRDFs14C2MDP49','PMRDFs14C2MDP51','PMRDFs14C2MDP53','PMRDFs14C2MDP62','PMRDFs14C2MDP63','PMRDFs14C2MDP64','PMRDFs14C2MDP65','PMRDFs14C2MDP71','PMRDFs14C2MDP72','PMRDFs14C2MDP75','PMRDFs14C2MDP83','PMRDFs14C2MDP87','PMRDFs14C3MDP11','PMRDFs14C3MDP13','PMRDFs14C3MDP17','PMRDFs14C3MDP18','M2013DM025','M2015DM001','M2015DM002','M2015DM003','M2015DM004','M2015DM005','M2015DM006','M2015DM007','M2015DM008','M2015DM010','M2015DM012','M2015DM013','M2015DM014','M2015DM016','M2015DM017','M2015DM019','M2015DM020','M2015DM021','M2015DM023','M2015DM024','M2015DM026','M2015DM027','M2015DM028','M2015DM030','M2015DM031','M2015DM032','M2015DM033','M2015DM034','M2015DM035','M2015DM036','M2015DM038','M2015DM039','M2015DM040','M2015DM041','M2015DM042','M2015RG001','M2015RG002','M2015RG004','M2015RG005','M2015RG006','M2015RG007','M2015RG008','M2015RG009','M2015RG010','M2015RG011','M2015RG012','M2015RG013','M2015RG014','M2015RG015','M2015RG017','M2015RG018','M2015RG019','M2015RG020','M2015RG021','M2015UPG003','M2015UPG004','M2015UPG005','M2015UPG006','M2015UPG007','M2015UPG008','M2015UPG009','M2015UPG011','M2015UPG012','M2015UPG013','M2015UPG014','M2015UPG016','M2015UPG017','M2015UPG018','M2015UPG019','M2014WPG012','M2015WPG001','M2015WPG003','M2015WPG006','M2015WPG007','M2015WPG009','M2015WPG011','M2015WPG012','M2015WPG013','M2015WPG014','M2015WPG015','M2015SE001','M2015SE008','M2015SE009','M2015SE011','M2015SE013','M2015SE015','M2015SE016','M2015SE017','M2015SE019','M2015SE020','M2015SE021','M2015SE023','M2015SE025','M2015SE028','M2015SE030','M2014CF019','M2015CF001','M2015CF002','M2015CF003','M2015CF005','M2015CF006','M2015CF007','M2015CF008','M2015CF009','M2015CF010','M2015CF012','M2015CF013','M2015CF014','M2015CF015','M2015CF016','M2015CF017','M2015CF018','M2015CF019','M2015CF021','M2015CF022','M2015CF023','M2015CF024','M2015CF025','M2015CF026','M2015CF027','M2015CF028','M2015CF029','M2015CF030','M2015CF031','M2015CF032','M2015CF033','M2015CF034','M2015CF035','M2015CF036','M2015CODP002','M2015CODP003','M2015CODP004','M2015CODP005','M2015CODP006','M2015CODP007','M2015CODP008','M2015CODP009','M2015CODP011','M2015CODP012','M2015CODP014','M2015CODP015','M2015CODP017','M2015CODP019','M2015CODP020','M2015CODP021','M2015CODP022','M2015CODP023','M2015CODP024','M2015CODP025','M2015CODP026','M2015CODP027','M2015CODP028','M2015CODP029','M2015CODP030','M2015CODP031','M2015CODP032','M2015CODP033','M2015CODP034','M2015CJ001','M2015CJ003','M2015CJ006','M2015CJ009','M2015CJ010','M2015CJ011','M2015CJ014','M2015CJ015','M2015CJ016','M2015CJ018','M2015CJ019','M2015CJ021','M2015CJ023','M2015CJ025','M2015CJ027','M2015CJ029','M2015CJ030','M2014DTA001','M2015DTA002','M2015DTA003','M2015DTA004','M2015DTA005','M2015DTA007','M2015DTA009','M2015DTA010','M2015DTA012','M2015DTA013','M2015DTA014','M2015DTA015','M2015DTA016','M2015DTA017','M2015DTA019','M2015DTA020','M2015DTA023','M2015DTA024','M2015DTA025','M2015DTA027','M2015DTA028','M2015DTA029','M2015DTA031','M2015DTA032','M2015DSA001','M2015DSA002','M2015DSA003','M2015DSA005','M2015DSA006','M2015DSA008','M2015DSA009','M2015DSA010','M2015DSA011','M2015DSA012','M2015DSA013','M2015DSA015','M2015DSA016','M2015DSA017','M2015DSA018','M2015DSA019','M2015DSA020','M2015DSA021','M2015DSA022','M2015DSA023','M2014LE017','M2015LE001','M2015LE002','M2015LE003','M2015LE004','M2015LE005','M2015LE006','M2015LE007','M2015LE008','M2015LE009','M2015LE010','M2015LE011','M2015LE013','M2015LE014','M2015LE015','M2015LE017','M2015LE018','M2015LE019','M2015LE020','M2015LE021','M2015LE023','M2015LE024','M2015LE025','M2015LE026','M2015LE027','M2015LE028','M2015LE029','M2015LE030','M2015LE031','M2015MH001','M2015MH002','M2015MH003','M2015MH004','M2015MH006','M2015MH007','M2015MH008','M2015MH009','M2015MH010','M2015MH011','M2015MH012','M2015MH013','M2015MH014','M2015MH015','M2015MH016','M2015MH018','M2015MH019','M2015MH024','M2014PH009','M2015PH001','M2015PH002','M2015PH003','M2015PH004','M2015PH005','M2015PH006','M2015PH007','M2015PH010','M2015PH011','M2015PH012','M2015PH013','M2015PH014','M2015PH015','M2015PH016','M2015PH018','M2015PH020','M2015PH021','M2015WCP001','M2015WCP002','M2015WCP003','M2015WCP004','M2015WCP005','M2015WCP006','M2015WCP007','M2015WCP008','M2015WCP010','M2015WCP011','M2015WCP012','M2015WCP013','M2015WCP015','M2015WCP016','M2015WCP017','M2015WCP018','M2015WCP020','M2015WCP022','M2015WCP023','M2015HE003','M2015HE004','M2015HE005','M2015HE006','M2015HE007','M2015HE008','M2015HE009','M2015HE011','M2015HE012','M2015HE013','M2015HE014','M2015HE015','M2015HE017','M2015HE018','M2015HE019','M2015HE020','M2015HE021','M2015HE022','M2015HE023','M2015HE024','M2015HE025','M2015HE026','M2015HE027','M2015HE028','M2015HE029','M2015HE030','M2015HE031','M2015HE032','M2015HE034','M2015HE035','M2015HE036','M2015HE037','M2015HE038','M2015HE039','M2015HO001','M2015HO002','M2015HO003','M2015HO004','M2015HO005','M2015HO006','M2015HO007','M2015HO008','M2015HO009','M2015HO010','M2015HO011','M2015HO012','M2015HO013','M2015HO014','M2015HO015','M2015HO016','M2015HO018','M2015HO019','M2015HO020','M2015HO021','M2015HO022','M2015HO023','M2015HO024','M2015HO025','M2015HO026','M2015HO027','M2015HO028','M2015HO029','M2015HO030','M2015HO031','M2015HO032','M2015HO033','M2015HO034','M2015HO035','M2015HO036','M2015HO037','M2015HO039','M2015HO040','M2015HO041','M2015HO042','M2015HO043','M2015HO044','M2015HO045','M2015HO046','M2015HO047','M2015HO048','M2015HO049','M2015HO050','M2015HO051','M2015HO052','M2016ATJ001','M2016ATJ002','M2016ATJ003','M2016ATJ004','M2016ATJ005','M2016ATJ006','M2016ATJ009','M2016ATJ011','M2016ATJ013','M2016ATJ014','M2016ATJ016','M2016ATJ017','M2016ATJ018','M2016ATJ019','M2016ATJ020','M2016ATJ021','M2016ATJ022','M2016ATJ023','M2016ATJ024','M2016ATJ025','M2016ATJ026','M2016ATJ028','M2016ATJ029','M2015MLIS003','M2015MLIS004','M2015MLIS005','M2015MLIS006','M2015MLIS007','M2015MLIS009','M2015MLIS010','M2015MLIS011','M2015MLIS013','M2015MLIS014','M2015MLIS015','MM2014DS011','MM2015DS001','MM2015DS003','MM2015DS004','MM2015DS005','MM2015DS006','MM2015DS007','MM2015DS008','MM2015DS009','MM2015DS010','MM2015DS011','MM2015DM002','MM2015DM003','MM2015DM004','MM2015DM005','MM2015ED002','MM2015ED003','MM2015ED004','MM2015ED005','MM2015HS001','MM2014HSS001','MM2014HSS002','MM2014HSS004','MM2015ID001','MM2015ID009','MM2015ID011','MM2015MLS003','MM2015MLS004','MM2015MLS005','MM2015MLS006','MM2015MLS007','MM2015MLS008','MM2015MLS009','MM2015MLS010','MM2014PH005','MM2015PH001','MM2015PH002','MM2015PH004','MM2015PH006','MM2015PH007','MM2015PH008','MM2015PH009','MM2015PH011','MM2015PH012','MM2015PH013','MM2015PH014','MM2015SS002','MM2015SS004','MM2015SS008','MM2015SS009','MM2014SW020','MM2015SW001','MM2015SW002','MM2015SW003','MM2015SW006','MM2015SW010','MM2015SW012','MM2015SW013','MM2015SW015','MM2015SW017','MM2015SW019','MM2015SW020','MM2015SW021','MM2015SW022','MM2015SW023','MM2015WS002','MM2015WS003','MM2015WS005','MM2015WS009','MM2015WS011','M2014PHHP002','M2014PHHP012','M2015PHHP001','M2015PHHP003','M2015PHHP005','M2015PHHP006','M2015PHHP007','M2015PHHP008','M2015PHHP009','M2015PHHP010','M2015PHHP011','M2015PHHP012','M2015PHHP013','M2015PHHP014','M2015PHHP015','M2015PHHP016','M2015PHHP017','M2015PHHP018','M2015PHHP019','M2015PHHP020','M2015PHHP021','M2015PHSE001','M2015PHSE002','M2015PHSE003','M2015PHSE004','M2015PHSE005','M2015PHSE006','M2015PHSE007','M2015PHSE008','M2015PHSE009','M2015PHSE010','M2015PHSE011','M2015PHSE013','M2015PHSE014','M2015PHSE015','M2015PHSE016','M2015PHSE017','M2015PHSE018','M2015PHSE019','M2015PHSE021','M2015PHSE022','M2015PHSE023','M2015PHSE024','M2015PHSE027','M2015PHSE028','T2014BASW002','T2014BASW004','T2014BASW006','T2014BASW007','T2014BASW008','T2014BASW009','T2014BASW010','T2014BASW012','T2014BASW013','T2014BASW014','T2014BASW016','T2014BASW017','T2014BASW020','T2015BASW18','T2013BAMA21','T2014BAMA001','T2014BAMA002','T2014BAMA003','T2014BAMA004','T2014BAMA005','T2014BAMA008','T2014BAMA009','T2014BAMA010','T2014BAMA011','T2014BAMA013','T2014BAMA014','T2014BAMA015','T2014BAMA016','T2014BAMA017','T2014BAMA018','T2014BAMA019','T2014BAMA022','T2014BAMA023','T2014BAMA024','T2014BAMA026','T2014BAMA027','T2014BAMA030','T2014BAMA032','T2014BAMA033','T2014BAMA034','T2014BAMA035','T2014BAMA036','T2014BAMA037','T2014BAMA038','T2014BAMA039','T2014BAMA040','T2014BAMA041','T2014BAMA042','T2014BAMA043','T2014BAMA045','T2014BAMA046','T2014BAMA047','T2014BAMA049','T2014BAMA050','T2014BAMA051','T2014BAMA052','T2014BAMA053','T2014BAMA054','T2014BAMA055','T2014BAMA056','T2014BAMA057','T2014BAMA058','T2014BAMA059','T2014BAMA060','T2014BAMA061','T2014BAMA062','T2014BAMA063','T2014BAMA064','T2014BAMA065','T2014BAMA066','T2014BAMA067','T2014BAMA069','T2014BAMA070','T2015SIE001','T2015SIE002','T2015SIE003','T2015SIE004','T2015SIE006','T2015SIE007','T2015SIE008','T2015SIE009','T2015SIE010','T2015SIE011','T2015SIE013','T2015SIE014','T2015SIE015','T2015SIE016','T2015SIE017','T2015SIE018','T2015SIE019','T2015SIE020','T2015DPPP003','T2015DPPP005','T2015DPPP006','T2015DPPP007','T2015DPPP008','T2015DPPP009','T2015DPPP010','T2015DPPP011','T2015DPPP012','T2015DPPP013','T2015DPPP015','T2015DPPP017','T2015DPPP018','T2015DPPP019','T2015DPPP020','T2015DPPP021','T2015DPPP022','T2015DPPP024','T2015DPPP025','T2015DPPP026','T2015DPPP027','T2015DPPP029','T2015DPPP030','T2015DPPP031','T2015SLNG001','T2015SLNG002','T2015SLNG003','T2015SLNG004','T2015SLNG005','T2015SLNG006','T2015SLNG007','T2015SLNG008','T2015SLNG009','T2015SLNG011','T2015SLNG014','T2015SLNG015','T2015SLNG016','T2015SLNG017','T2015SLNG018','T2015SLNG020','T2015SLNG021','T2015RD001','T2015RD002','T2015RD003','T2015RD004','T2015RD006','T2015RD008','T2015RD009','T2015RD010','T2015RD011','T2015RD012','T2015RD013','T2015RD014','T2015RD015','T2015RD016','T2015RD018','T2015RD019','T2015RD021','T2015RD022','T2015RD023','T2015RD024','T2015RD025','T2015RD027','T2015RD029','T2015RD030','T2015RD032','T2015RD034','T2015RD035','T2015RD036','T2015RD037','TM2015RD001','TM2015RD002','TM2015RD003','TM2015RD005','TM2015RD006','TM2015RD008')
 order by campus_name,prog_name,stud_enrollment_number

******************************************************************************************************************************************************************************************************

--Dt. scse, rscs for 1233 dummy student
select scse_id, rscs_id,scse_cpse_id ,rscs_deleted,scse_deleted from tcourse_evaluation_rel_stu_courses inner join exams_rel_students_courses_semesters
on rscs_id=scse_rscs_id and rscs_cpse_id=scse_cpse_id
 where rscs_stu_id=1233 and rscs_deleted='Y' and scse_deleted='Y' and scse_last_modified_empl_id=238

--scse_update
 update exams_rel_students_courses_semesters set scse_deleted='Y',scse_last_modified_empl_id=238 where scse_id in (select scse_id--, rscs_id,scse_cpse_id ,rscs_deleted,scse_deleted 
 from tcourse_evaluation_rel_stu_courses inner join exams_rel_students_courses_semesters
on rscs_id=scse_rscs_id and rscs_cpse_id=scse_cpse_id
 where rscs_stu_id=1233 and rscs_deleted='N' and scse_deleted='Y')

--rscs update
update tcourse_evaluation_rel_stu_courses set rscs_deleted='Y',rscs_last_modifier_id=238 where rscs_id in (select rscs_id--, rscs_id,scse_cpse_id ,rscs_deleted,scse_deleted 
 from tcourse_evaluation_rel_stu_courses inner join exams_rel_students_courses_semesters
on rscs_id=scse_rscs_id and rscs_cpse_id=scse_cpse_id
 where rscs_stu_id=1233 and rscs_deleted='Y' and scse_deleted='Y' and rscs_last_modifier_id=238)


--Dt 28/02/17
--query to search students enrollments based on CBCS course name
select stud_enrollment_number,rscs_sem_id,cpse_id from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and rscs_cpse_id=scse_cpse_id
where stud_deleted='N' and stud_status='OnRole' and rscs_course_type='C' and rscs_deleted='N' and stud_campus_id=1 and stud_prog_type_id=1 and stud_acba_id=1
and cour_name='Introduction to the Philosophy of Science'
order by rscs_sem_id,stud_enrollment_number


select rscs_course_id,cour_name from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_courses on rscs_course_id=cour_id
where rscs_deleted='N' and rscs_course_type='C' and rscs_batch_id=1 and rscs_sem_id=4 and 
(rscs_course_id in (select distinct rscs_course_id from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_courses on rscs_course_id=cour_id
where rscs_deleted='N' and rscs_course_type='C' and rscs_batch_id=1 and rscs_sem_id=3) or rscs_course_id in (select distinct rscs_course_id from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_courses on rscs_course_id=cour_id
where rscs_deleted='N' and rscs_course_type='C' and rscs_batch_id=1 and rscs_sem_id=2))
group by rscs_course_id,cour_name
having count(rscs_course_id)>1 

select stud_enrollment_number,stud_fname,stud_lname,cour_name,scse_gpa_actual,cpse_credits,scse_course_result, scse_course_attempt,scse_letter_grade,rscs_batch_id,scse_semester_attempt,scse_created_datetime
from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on cpse_cour_id=cour_id
where scse_deleted='N' --and scse_semester_attempt='1' 
---and rscs_sem_id=2
and scse_cpse_id=rscs_cpse_id and rscs_deleted='N' 
and stud_status='OnRole' and rscs_stu_id=stud_id and stud_enrollment_number='G2015EESD006'
order by stud_enrollment_number, cour_name


select stud_enrollment_number ,sum(cpse_credits) from 
exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
where stud_deleted='N' and stud_status='OnRole' and stud_campus_id=1 and stud_prog_type_id=1 and stud_acba_id=1 and stud_prog_id not in (17,18) and rscs_deleted='N'
group by stud_enrollment_number
order by stud_enrollment_number


--students of 15-17 with more cbcs credits across campus
select stud_enrollment_number ,stud_fname, stud_lname,stud_tiss_email,stud_mobile_number, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id in (1,2,4,5) and stud_acba_id=1 and and scse_course_attempt='Re'
group by stud_enrollment_number,stud_fname, stud_lname, cpse_credits,stud_tiss_email,stud_mobile_number
having count(cpse_credits)>4
order by stud_enrollment_number


--student not enrolled for any CBCS course across all campus 15-17 batch only
select campus_name,stud_enrollment_number as "Enrollment Number", stud_fname as "First Name", stud_lname as "Last Name", prog_name as "Program Name",acba_name as "Batch",seme_name as "Semester", stud_tiss_email as "Tiss Email",stud_other_email as "Other Email", stud_mobile_number as "Mobile Number"
from exams_mst_students
inner join exams_mst_programs on stud_prog_id = prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_campus on stud_campus_id=campus_id
where 
stud_campus_id in (1,2,4) and  stud_prog_type_id in (1) and
stud_acba_id in (1) 
and stud_status='OnRole' and stud_deleted='N' and stud_prog_id not in (42,18,17) and stud_id not in (select stud_id 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' 
group by prog_name,stud_enrollment_number,stud_fname, stud_lname, cpse_credits,seme_name,stud_id
order by prog_name,stud_enrollment_number
) order by stud_enrollment_number

--students of 15-17 with less credits across Mumbai,tuljpur and hyderabad
select campus_name,prog_name,stud_enrollment_number ,stud_fname, stud_lname,acba_name,seme_name, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_campus on stud_campus_id=campus_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id in (1,2,4) and stud_acba_id=1 --and stud_sem_id=4 --and rscs_sem_id=4 
group by prog_name,stud_enrollment_number,stud_fname, stud_lname, cpse_credits,seme_name,acba_name,campus_name
having count(cpse_credits)<4
order by campus_name,prog_name,stud_enrollment_number

--select all students of Mumbai,tuljpur and hyderabad
select * from exams_mst_students where stud_status='OnRole' and stud_deleted='N' and stud_prog_type_id=1 and stud_acba_id=1 and stud_campus_id in (1,2,4) and stud_prog_id not in (17,42) order by stud_enrollment_number

select stud_enrollment_number,rscs_course_id from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and rscs_course_type='C' and stud_prog_id not in  (46,17,19) and stud_campus_id=1 and stud_acba_id=1 and stud_enrollment_number not like 'M2015%'

--students enrolled for course as cbcs and mandatory 
select stud_id,stud_enrollment_number,rscs_course_id,rscs_sem_id from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and rscs_course_type='C' and stud_prog_id not in  (46,17,19) --and stud_campus_id=1 and stud_acba_id=1
and (stud_id,rscs_course_id) in (select stud_id,rscs_course_id --enrollment_number,rscs_course_id 
from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and rscs_course_type='M' and stud_prog_id not in  (46,17,19) --and stud_campus_id=1 and stud_acba_id=1
)

select stud_enrollment_number,stud_fname,stud_lname,cour_name,rscs_course_id,scse_gpa_actual,cpse_credits,scse_course_result, scse_course_attempt,scse_course_type,scse_letter_grade,rscs_batch_id,scse_semester_attempt,scse_created_datetime
from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on cpse_cour_id=cour_id
where scse_deleted='N' --and scse_semester_attempt='1' 
---and rscs_sem_id=2
and scse_cpse_id=rscs_cpse_id and rscs_deleted='N' 
and stud_status='OnRole' and rscs_stu_id=stud_id and stud_enrollment_number in ('H2014WS014','M2014DTA001','M2014WCP004') and count(stud_fname,cour_name)>1
order by stud_enrollment_number, cour_name

--Dt. 06/03/17
select stud_enrollment_number,stud_fname,stud_lname,cour_name,rscs_course_id,scse_gpa_actual,cpse_credits,scse_course_result, scse_course_attempt,scse_course_type,scse_letter_grade,rscs_batch_id,scse_semester_attempt,scse_created_datetime
from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on cpse_cour_id=cour_id
where scse_deleted='N' --and scse_semester_attempt='1' 
---and rscs_sem_id=2
and scse_cpse_id=rscs_cpse_id and rscs_deleted='N' 
and stud_status='OnRole' and rscs_stu_id=stud_id and stud_enrollment_number in ('M2015HO043') and count(stud_fname,cour_name)>1
order by stud_enrollment_number, cour_name

select * from exams_mst_students where stud_enrollment_number  in ('M2015DS008','M2014DS052')

select cour_id,cour_code,cour_name from exams_mst_courses 
where cour_id IN(select DISTINCT(rscs_course_id) from tcourse_evaluation_rel_stu_courses 
where  rscs_stu_id='6257' and (rscs_course_id,rscs_sem_id) 
NOT IN(select eval_course_id ,eval_sem_id from tcourse_evaluation_mst_eval 
where eval_deleted='N' and eval_stu='6257') and rscs_deleted='N' and rscs_sem_id='2')order by(cour_id
--Complete list of enrollments in cbcs courses 27/02/2017
select campus_name,prog_name,stud_enrollment_number ,stud_fname, stud_lname ,cour_name,cpse_credits,seme_name,acba_name
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and scse_deleted='N' and stud_prog_id !=46
group by stud_enrollment_number,stud_fname, stud_lname, cour_name,cpse_seme_id,campus_id,prog_name,cpse_credits,seme_name,acba_name
order by campus_name,acba_name,prog_name,stud_enrollment_number


--students of 15-17 with more cbcs credits across campus
select stud_enrollment_number ,stud_fname, stud_lname,stud_tiss_email,stud_mobile_number, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id in (1,2,4,5) and stud_acba_id=1 and scse_course_attempt='Re'
--and stud_sem_id=4 --and rscs_sem_id=4 
--and stud_id in (select stud_id from exams_mst_students where stud_enrollment_number in ('M2015DM006','M2015DM024','M2015DSA010','M2015DSA016','M2015DTA005','M2015HE007','M2015HE020','M2015HE035','M2015RG010','M2015RG011'))
group by stud_enrollment_number,stud_fname, stud_lname, cpse_credits,stud_tiss_email,stud_mobile_number
having count(cpse_credits)>4
order by stud_enrollment_number

--student not enrolled for any CBCS course across all campus
select campus_name,stud_enrollment_number as "Enrollment Number", stud_fname as "First Name", stud_lname as "Last Name", prog_name as "Program Name",acba_name as "Batch",seme_name as "Semester", stud_tiss_email as "Tiss Email",stud_other_email as "Other Email", stud_mobile_number as "Mobile Number"
from exams_mst_students
inner join exams_mst_programs on stud_prog_id = prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_campus on stud_campus_id=campus_id
where 
--stud_campus_id=2 and 
stud_acba_id in (1,3,10,11) --and prog_prty_id=2 
--and stud_sem_id = 4 
and stud_status='OnRole' and stud_deleted='N' and stud_prog_id not in (18,17) and stud_id not in (select stud_id--prog_name,stud_enrollment_number ,stud_fname, stud_lname,seme_name, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' 
--and stud_campus_id=2 and stud_acba_id=3 and stud_sem_id=4 --and rscs_sem_id=4 
group by prog_name,stud_enrollment_number,stud_fname, stud_lname, cpse_credits,seme_name,stud_id
order by prog_name,stud_enrollment_number
) order by stud_enrollment_number


-------------------------------------------------
--from cbcs course enrollment query file 

﻿ --students of 15-17 with more cbcs credits across campus
select stud_enrollment_number ,stud_fname, stud_lname,stud_tiss_email,stud_mobile_number, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id in (1,2,4,5) and stud_acba_id=1 and scse_course_attempt='Re'
group by stud_enrollment_number,stud_fname, stud_lname, cpse_credits,stud_tiss_email,stud_mobile_number
having count(cpse_credits)>4
order by stud_enrollment_number


--student not enrolled for any CBCS course across all campus 15-17 batch only
select campus_name,stud_enrollment_number as "Enrollment Number", stud_fname as "First Name", stud_lname as "Last Name", prog_name as "Program Name",acba_name as "Batch",seme_name as "Semester", stud_tiss_email as "Tiss Email",stud_other_email as "Other Email", stud_mobile_number as "Mobile Number"
from exams_mst_students
inner join exams_mst_programs on stud_prog_id = prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_campus on stud_campus_id=campus_id
where 
stud_campus_id in (1,2,4) and  stud_prog_type_id in (1) and
stud_acba_id in (1) 
and stud_status='OnRole' and stud_deleted='N' and stud_prog_id not in (42,18,17) and stud_id not in (select stud_id 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' 
group by prog_name,stud_enrollment_number,stud_fname, stud_lname, cpse_credits,seme_name,stud_id
order by prog_name,stud_enrollment_number
) order by stud_enrollment_number

--students of 15-17 with less cbcs credits across Mumbai,tuljpur and hyderabad
select campus_name,prog_name,stud_enrollment_number ,stud_fname, stud_lname,acba_name,seme_name, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_campus on stud_campus_id=campus_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id in (1,2,4) and stud_acba_id=1 --and stud_sem_id=4 --and rscs_sem_id=4 
group by prog_name,stud_enrollment_number,stud_fname, stud_lname, cpse_credits,seme_name,acba_name,campus_name
having count(cpse_credits)<4
order by campus_name,prog_name,stud_enrollment_number

--select all students of Mumbai,tuljpur and hyderabad
select * from exams_mst_students where stud_status='OnRole' and stud_deleted='N' and stud_prog_type_id=1 and stud_acba_id=1 and stud_campus_id in (1,2,4) and stud_prog_id not in (17,42) order by stud_enrollment_number

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Dt: 15/03/17
--students with extra cbcs credits
select stud_enrollment_number ,stud_fname, stud_lname,stud_tiss_email,stud_mobile_number, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id in (1,2,4,5) and stud_acba_id=1 and scse_course_attempt='Re'
group by stud_enrollment_number,stud_fname, stud_lname, cpse_credits,stud_tiss_email,stud_mobile_number
having count(cpse_credits)>4
order by stud_enrollment_number

--list of 15-17 students with extra cbcs credits
select stud_enrollment_number ,stud_fname, stud_lname,stud_tiss_email,stud_mobile_number,cour_name,seme_name
--,count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and stud_campus_id in (1,2,4,5) and stud_acba_id=1 and scse_course_attempt='Re'
and stud_id in (select distinct rscs_stu_id from tcourse_evaluation_rel_stu_courses where rscs_deleted='N' and rscs_course_type='C' group by rscs_stu_id having count(rscs_stu_id)>4)
--group by stud_enrollment_number,stud_fname, stud_lname, cpse_credits,stud_tiss_email,stud_mobile_number
--having count(cpse_credits)>4
order by stud_enrollment_number,seme_name


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--list of cbcs courses in other than mumbai campus
select cpse_id,campus_name,cour_name,cpse_credits,acba_name,count(rscs_id)
from exams_rel_courses_programes_semesters 
inner join exams_mst_campus on cpse_campus_id=campus_id
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
inner join exams_mst_students on stud_acba_id=acba_id and stud_campus_id=cpse_campus_id 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id and rscs_cpse_id=cpse_id
where cpse_deleted='N' and cpse_campus_id!=1 and cpse_cour_type='C' and rscs_deleted='N' and rscs_course_type='C' and cpse_seme_id=rscs_sem_id and stud_status='OnRole' and stud_deleted='N'
group by cpse_id, campus_name,cour_name,cpse_credits,acba_name
order by cpse_id,campus_name,cour_name

--query to check cbcs courses across campus
select campus_name,cour_name,acba_name,seme_name,cpse_credits
from exams_rel_courses_programes_semesters 
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_mst_campus on cpse_campus_id=campus_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
where cpse_cour_type='C' and cpse_deleted='N' and cpse_campus_id!=1
order by campus_name,acba_name,cour_name

select cpse_id from exams_rel_courses_programes_semesters where cpse_id in (2259,2293,2292,2258,2284,2283,2288,2290,2285,2286,2289,2291,2287,3581,3580,3720,3721,3900,4025,4026,4027,4028)
and cpse_id not in (2258,2259,2283,2284,2285,2286,2287,2288,2289,2290,2291,2292,2293,3580,3720,3721,3900,4025,4026,4027,4028)


update exams_mst_students set stud_sem_id =2 where stud_id in (
select * from exams_mst_students where stud_campus_id=4 and stud_status='OnRole' and stud_deleted='N' and stud_prog_id=70 and stud_acba_id =8 order by stud_acba_id)

select * from exams_rel_employees_activities_permissions where emap_rcp_id in (3026,3027,3028,3029,3030,3031,3032,3033,3034,3035,3036,3037,3038)

select * from exams_rel_campus_school_programes_courses 
inner join exams_mst_courses on rcp_cour_id=cour_id
where (rcp_prog_id,rcp_cour_id,rcp_campus_id )in (select rcp_prog_id,rcp_cour_id,rcp_campus_id from exams_rel_campus_school_programes_courses where rcp_id in (3026,3027,3028,3029,3030,3031,3032,3033,3034,3035,3036,3037,3038))

update exams_rel_campus_school_programes_courses set rcp_school_id=15 where rcp_id in (
select * from exams_rel_campus_school_programes_courses where rcp_id in (3026,3027,3028,3029,3030,3031,3032,3033,3034,3035,3036,3037,3038) and rcp_deleted='N')


--Dt 17/03/17
--query to select details of students marked in HRM
select stud_fname,stud_lname,table1.* from (select distinct cour_name,rscs_batch_id,exams_rel_students_courses_semesters.* from exams_mst_students 
inner join exams_rel_courses_programes_semesters on cpse_prog_id=stud_prog_id
inner join exams_rel_students_courses_semesters on cpse_id=scse_cpse_id 
inner join tcourse_evaluation_rel_stu_courses on rscs_cpse_id=cpse_id and scse_rscs_id=rscs_id and rscs_deleted='N'
inner join exams_mst_courses on cpse_cour_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and stud_prog_id=21 and scse_course_attempt='I' and stud_acba_id in (1,10) and scse_deleted='N' and scse_letter_grade ='' order by scse_semester_attempt) as table1 
join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id 
inner join exams_mst_students on rscs_stu_id=stud_id

--Dt. 21/03/17
--select distinct campus and program
select distinct campus_name,prog_name from 
exams_rel_courses_programes_semesters
inner join exams_mst_campus on cpse_campus_id=campus_id
inner join exams_mst_programs on cpse_prog_id=prog_id
where cpse_deleted='N' and cpse_prog_id!=83
order by campus_name

--Dt:21/03/17 15-17 sudents across campus who didnt enroll for cbcs course 
select campus_name,stud_enrollment_number as "Enrollment Number", stud_fname as "First Name", stud_lname as "Last Name", prog_name as "Program Name",acba_name as "Batch",seme_name as "Semester", stud_tiss_email as "Tiss Email",stud_other_email as "Other Email", stud_mobile_number as "Mobile Number"
from exams_mst_students
inner join exams_mst_programs on stud_prog_id = prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_campus on stud_campus_id=campus_id
where 
stud_campus_id in (1,2,4) and 
stud_acba_id in (1) and prog_prty_id=1 and stud_prog_id not in (42,13,12)
--and stud_sem_id = 4 
and stud_status='OnRole' and stud_deleted='N' and stud_prog_id not in (18,17) and stud_id not in (select stud_id--prog_name,stud_enrollment_number ,stud_fname, stud_lname,seme_name, count(cpse_credits) as "Total CBCS Courses",sum(cpse_credits) as "Credits Completed" 
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_programs on stud_prog_id=prog_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' 
--and stud_campus_id=2 and stud_acba_id=3 and stud_sem_id=4 --and rscs_sem_id=4 
group by prog_name,stud_enrollment_number,stud_fname, stud_lname, cpse_credits,seme_name,stud_id
order by prog_name,stud_enrollment_number
) order by campus_name,stud_enrollment_number

--Search CBCS course details
select cpse_id,sch_name,cour_name,cpse_history,cpse_course_variant
--exams_rel_courses_programes_semesters.* 
from exams_rel_courses_programes_semesters 
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_rel_campus_school_programes_courses on cpse_cour_id=rcp_cour_id and rcp_prog_id=83
inner join exams_mst_schools on rcp_school_id=sch_id
where cpse_cour_type='C' and cpse_campus_id=1 and cpse_deleted='N'
order by cpse_id

******************************************************************************************************************************************************************************************************

--Dt: 27/03/17 Query to search all students of 16-18 batch
select campus_name,stud_enrollment_number,stud_regis_number,stud_fname, stud_mname,stud_lname as stud_name, stud_dob,stud_gender,prog_name,acba_name,progtype_name,stud_status,pwdtype_name,cate_name,
stud_tiss_email,stud_other_email,stud_mobile_number,stud_permanentadd,stud_pincode
from exams_mst_students 
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_categories on stud_admission_cate_id=cate_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_programme_type on stud_prog_type_id=progtype_id
inner join exams_mst_pwdtype on stud_pwdtype_id=pwdtype_id
where stud_acba_id=10 and stud_deleted='N'
order by campus_name,prog_name,stud_enrollment_number
select campus_name,stud_enrollment_number,stud_regis_number,stud_fname || ' ' || stud_mname || ' ' || stud_lname as stud_name, stud_dob,stud_gender,prog_name,acba_name,progtype_name,stud_status,pwdtype_name,cate_name,
stud_tiss_email,stud_other_email,stud_mobile_number,stud_permanentadd,stud_pincode
from exams_mst_students 
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_categories on stud_admission_cate_id=cate_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_programme_type on stud_prog_type_id=progtype_id
inner join exams_mst_pwdtype on stud_pwdtype_id=pwdtype_id
where stud_acba_id=10 and stud_deleted='N'
order by campus_name,prog_name,stud_enrollment_number

select campus_name,stud_enrollment_number,stud_regis_number, concat(stud_fname, ' ' ,stud_mname, ' ' ,stud_lname )as stud_name, 
stud_dob,stud_gender,prog_name,acba_name,progtype_name,stud_status,pwdtype_name,cate_name,
stud_tiss_email,stud_other_email,stud_mobile_number,stud_permanentadd,stud_pincode
from exams_mst_students 
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_categories on stud_admission_cate_id=cate_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
inner join exams_mst_programme_type on stud_prog_type_id=progtype_id
inner join exams_mst_pwdtype on stud_pwdtype_id=pwdtype_id
where stud_acba_id=10 and stud_deleted='N'
order by campus_name,prog_name,stud_enrollment_number

*******************************************************************************************************************************************************************************************************

--Date 07/03/17 21:25PM

--Complete list of enrollments in cbcs courses 15-17 7/03/2017
select campus_name,prog_name,stud_enrollment_number ,stud_fname, stud_lname ,cour_name,cpse_credits,seme_name,acba_name
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and rscs_sem_id=cpse_seme_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id and cpse_id=scse_cpse_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and cpse_deleted='N' and scse_course_type='C' and scse_deleted='N' and stud_prog_id !=46 and stud_acba_id=1
group by stud_enrollment_number,stud_fname, stud_lname, cour_name,cpse_seme_id,campus_id,prog_name,cpse_credits,seme_name,acba_name
order by campus_id,prog_name,stud_enrollment_number,seme_name,cour_name

--students enrolled for course as cbcs and mandatory 
select campus_name,prog_name,stud_enrollment_number,stud_fname,stud_lname,cour_name,seme_name from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_semesters on rscs_sem_id=seme_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and rscs_course_type='C' and stud_prog_id not in  (46,17,19) --and stud_campus_id=1 and stud_acba_id=1
and (stud_id,rscs_course_id,stud_acba_id) in (select stud_id,rscs_course_id,rscs_batch_id --enrollment_number,rscs_course_id 
from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and rscs_course_type='M' and stud_prog_id not in  (46,17,19) --and stud_campus_id=1 and stud_acba_id=1
)
order by campus_id,rscs_sem_id

--students enrolled for same cbcs courses and mandatory course
select stud_id,stud_enrollment_number,rscs_course_id,rscs_sem_id from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and rscs_course_type='C' and stud_prog_id not in  (46,17,19) --and stud_campus_id=1 and stud_acba_id=1
and (stud_id,rscs_course_id) in (
select stud_id,rscs_course_id --enrollment_number,rscs_course_id 
from exams_mst_students 
inner join tcourse_evaluation_rel_stu_courses on stud_id=rscs_stu_id
where stud_deleted='N' and stud_status='OnRole' and rscs_deleted='N' and rscs_course_type='M' and stud_prog_id not in  (46,17,19) --and stud_campus_id=1 and stud_acba_id=1
)

--query to search students marks and other details of all semesters
select stud_enrollment_number,stud_fname,stud_lname,cour_name,rscs_course_id,rscs_attendance_prob,scse_gpa_actual,scse_course_attempt,cpse_credits,scse_course_result, scse_course_attempt,scse_course_type,scse_letter_grade,rscs_batch_id,scse_semester_attempt,scse_created_datetime
from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on cpse_cour_id=cour_id
where scse_deleted='N' --and rscs_sem_id=4 
and scse_cpse_id=rscs_cpse_id and rscs_deleted='N' 
and stud_status='OnRole' and rscs_stu_id=stud_id and stud_enrollment_number in ('M2015WPG001')--,'M2014WCP004','H2014WS014','H2014RDG005','H2014RDG012')
order by scse_semester_attempt,cour_name


*******************************************************************************************************************************************************************************************************

--PMRDF convocation issues
select * from exams_convocation_details where convocation_id in (954,1026,949,2595,2536,1106,1156,1115,2594,2597,956,1017)  

--Dt.01/01/2017 convocation form details 15-17, 14-17
select campus_name,stud_enrollment_number,convocation_fname,convocation_mname,convocation_lname,acba_name,prog_name from exams_convocation_details 
inner join exams_mst_students on convocation_stud_id=stud_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
where convocation_last_modified_datetime>'2017-01-01' and convocation_deleted='N' and stud_status='OnRole' and stud_deleted='N' 
order by campus_name,prog_name,stud_enrollment_number


--Updated Convocation Descripancies
select * from exams_mst_students 
--inner join exams_convocation_details on stud_id=convocation_stud_id --and stud_status='OnRole' and stud_deleted='N' 
--and convocation_deleted='N'
where stud_enrollment_number in ('2016PGDM02','B2015APCLP001','B2015APCLP002','B2015APCLP003','B2015APCLP005','B2015APCLP006','B2015APCLP007','B2015APCLP008','B2015APCLP009','B2015APCP001','B2015APCP002','B2015APCP003','B2015APCP004','B2015APCP006','B2015APCP007','B2015APCP009','B2015APCP010','B2015APCP011','B2015APCP014','B2015APCP015','B2015APCP016','B2015APCP017','B2015APCP018','B2015APCP019','B2015APCP020','B2015APCP023','B2015MH001','B2015MH003','B2015MH004','B2015MH005','B2015MH006','B2015MH007','B2015MH008','B2015MH009','B2015MH010','B2015MH011','B2015MH012','B2015MPA001','B2015MPA002','B2015MPA003','B2015MPA004','G2014BAMA002','G2014BAMA003','G2014BAMA004','G2014BAMA005','G2014BAMA008','G2014BAMA009','G2014BAMA010','G2014BAMA012','G2014BAMA013','G2014BAMA014','G2014BAMA015','G2014BAMA017','G2014BAMA018','G2014BAMA020','G2014BAMA021','G2014BAMA022','G2014BAMA023','G2014BAMA025','G2014BAMA026','G2014BAMA027','G2014BAMA028','G2014BAMA029','G2014BAMA030','G2014BAMA035','G2014BAMA036','G2014BAMA037','G2014BAMA038','G2014BAMA039','G2014BAMA040','G2014BAMA041','G2014BAMA042','G2014BAMA044','G2014BAMA045','G2014BAMA047','G2014BAMA048','G2014BAMA050','G2014BAMA051','G2014BAMA052','G2014BAMA053','G2014BAMA054','G2014BAMA055','G2014CO002','G2014LE006','G2014PC004','G2014PH005','G2015CO001','G2015CO002','G2015CO003','G2015CO005','G2015CO006','G2015CO007','G2015CO008','G2015CO009','G2015CO010','G2015CO014','G2015CO015','G2015CODP001','G2015CODP002','G2015CODP003','G2015CODP004','G2015CODP005','G2015CODP006','G2015CODP007','G2015CODP008','G2015CODP009','G2015CODP010','G2015CODP011','G2015CODP012','G2015CODP013','G2015CODP014','G2015CODP015','G2015CODP016','G2015CODP017','G2015CODP018','G2015CODP019','G2015CODP020','G2015EESD001','G2015EESD002','G2015EESD004','G2015EESD005','G2015EESD007','G2015EESD011','G2015EESD012','G2015EESD015','G2015EESD017','G2015EESD018','G2015EESD019','G2015EESD020','G2015EESD021','G2015LE002','G2015LE003','G2015LE004','G2015LE005','G2015LE006','G2015LE007','G2015LE008','G2015LE009','G2015LE010','G2015LE011','G2015LE014','G2015LE015','G2015LE016','G2015LE017','G2015LE018','G2015LE019','G2015LE020','G2015LSSP001','G2015LSSP002','G2015LSSP004','G2015LSSP005','G2015LSSP006','G2015LSSP007','G2015LSSP008','G2015LSSP009','G2015LSSP010','G2015LSSP011','G2015LSSP012','G2015LSSP013','G2015LSSP014','G2015PC004','G2015PC005','G2015PC006','G2015PC007','G2015PC010','G2015PC011','G2015PC012','G2015PC013','G2015PC014','G2015PH002','G2015PH003','G2015PH004','G2015PH005','G2015PH006','G2015PH007','G2015PH008','G2015PH009','G2015PH010','G2015PH011','G2015PH012','G2015PH013','G2015PH014','G2015SSA001','G2015SSA003','G2015SSA007','G2015SSA009','G2015SSA011','G2015SSA015','G2015SSA016','GM2015CO016','GM2015CO017','GM2015CO018','GM2015CODP021','GM2015CODP022','GM2015CODP023','GM2015CODP024','GM2015CODP025','GM2015EESD022','GM2015EESD023','GM2015EESD024','GM2015EESD025','GM2015EESD027','GM2015EESD028','GM2015EESD029','GM2015LE021','GM2015LE022','GM2015LE023','GM2015LE025','GM2015LE026','GM2015LE027','GM2015LSSP017','GM2015LSSP018','GM2015LSSP019','GM2015LSSP020','GM2015LSSP021','GM2015LSSP022','GM2015LSSP023','GM2015PC015','GM2015PC016','GM2015PH015','GM2015PH016','GM2015PH017','GM2015PH018','GM2015PH020','GM2015SS001','GM2015SS002','GM2015SS004','GM2015SS005','GM2015SS006','GM2015SS007','GM2015SS008','GM2015SS009','GM2015SSA017','GM2015SSA018','GM2015SSA019','GM2015SSA020','H2013BAMA05','H2014BAMA001','H2014BAMA003','H2014BAMA004','H2014BAMA005','H2014BAMA007','H2014BAMA008','H2014BAMA009','H2014BAMA010','H2014BAMA011','H2014BAMA012','H2014BAMA014','H2014BAMA015','H2014BAMA017','H2014BAMA018','H2014BAMA019','H2014BAMA020','H2014BAMA021','H2014BAMA023','H2014BAMA024','H2014BAMA025','H2014BAMA026','H2014BAMA027','H2014BAMA028','H2014BAMA029','H2014BAMA031','H2014BAMA032','H2014BAMA033','H2014BAMA035','H2014BAMA036','H2014BAMA037','H2014BAMA038','H2014BAMA039','H2014BAMA040','H2014BAMA041','H2014BAMA042','H2014BAMA043','H2014BAMA044','H2014BAMA045','H2014BAMA047','H2014BAMA048','H2014BAMA049','H2014BAMA050','H2014BAMA051','H2014BAMA052','H2014BAMA053','H2014BAMA054','H2014BAMA055','H2014BAMA056','H2014BAMA057','H2014BAMA058','H2014BAMA059','H2014BAMA060','H2014BAMA061','H2014BAMA062','H2014DS024','H2014RDG005','H2014RDG012','H2014WS014','H2014WS024','H2015DS002','H2015DS005','H2015DS006','H2015DS007','H2015DS009','H2015DS010','H2015DS012','H2015DS013','H2015DS014','H2015DS015','H2015DS016','H2015DS017','H2015DS018','H2015DS019','H2015DS020','H2015DS021','H2015DS023','H2015DS024','H2015DS025','H2015DS027','H2015DS028','H2015DS029','H2015DSM031','H2015DSM032','H2015DSM033','H2015DSM034','H2015DSM035','H2015DSM036','H2015ED003','H2015ED004','H2015ED006','H2015ED007','H2015ED008','H2015ED009','H2015ED011','H2015ED012','H2015ED013','H2015ED014','H2015ED015','H2015ED017','H2015ED020','H2015ED021','H2015ED023','H2015ED024','H2015ED026','H2015ED028','H2015ED029','H2015HRM001','H2015HRM002','H2015HRM003','H2015HRM004','H2015HRM005','H2015HRM006','H2015HRM007','H2015HRM023','H2015HRMM008','H2015HRMM009','H2015HRMM010','H2015HRMM011','H2015HRMM012','H2015HRMM013','H2015HRMM014','H2015HRMM015','H2015HRMM016','H2015HRMM017','H2015HRMM018','H2015HRMM019','H2015HRMM021','H2015HRMM022','H2015NRG001','H2015NRG002','H2015NRG003','H2015NRG004','H2015NRG006','H2015NRG007','H2015NRG008','H2015NRG009','H2015NRG012','H2015NRG013','H2015NRG014','H2015NRG016','H2015NRG017','H2015NRG018','H2015NRG019','H2015NRG020','H2015NRG021','H2015NRG022','H2015NRG023','H2015NRG024','H2015NRG026','H2015NRG027','H2015NRG028','H2015NRG029','H2015NRG030','H2015PPG001','H2015PPG002','H2015PPG007','H2015PPG012','H2015PPG013','H2015PPG014','H2015PPG016','H2015PPG023','H2015PPG024','H2015PPG025','H2015PPG027','H2015PPGM030','H2015PPGM031','H2015PPGM032','H2015PPGM033','H2015PPGM034','H2015PPGM035','H2015RDG001','H2015RDG002','H2015RDG003','H2015RDG004','H2015RDG005','H2015RDG006','H2015RDG007','H2015RDG008','H2015RDG010','H2015RDG011','H2015RDG012','H2015RDG014','H2015RDG015','H2015RDG016','H2015RDG017','H2015RDG019','H2015RDG020','H2015RDG021','H2015RDG023','H2015RDG024','H2015RDG025','H2015RDG026','H2015RDG027','H2015RDG028','H2015RDG029','H2015RDG034','H2015RDGM030','H2015RDGM031','H2015RDGM032','H2015RDGM033','H2015RDGM035','H2015WS001','H2015WS005','H2015WS006','H2015WS007','H2015WS008','H2015WS009','H2015WS010','H2015WS011','H2015WS012','H2015WS013','H2015WS014','H2015WS015','H2015WS017','H2015WS018','H2015WS019','HM2014WS002','HM2014WS006','HM2015ED001','HM2015ED002','HM2015ED003','HM2015ED004','HM2015ED005','HM2015ED006','HM2015ED007','HM2015WS001','M2013CF020','M2013DM025','M2014APCP013','M2014CF019','M2014DS052','M2014DTA001','M2014DTA006','M2014LE017','M2014PH009','M2014PHHP002','M2014PHHP012','M2014WPG012','M2015APCLP002','M2015APCLP003','M2015APCLP004','M2015APCLP005','M2015APCLP006','M2015APCLP007','M2015APCLP008','M2015APCLP009','M2015APCLP010','M2015APCLP011','M2015APCLP012','M2015APCLP013','M2015APCLP014','M2015APCLP015','M2015APCLP016','M2015APCLP017','M2015APCLP018','M2015APCLP019','M2015APCLP020','M2015APCLP021','M2015APCLP022','M2015APCLP023','M2015APCP001','M2015APCP002','M2015APCP003','M2015APCP004','M2015APCP005','M2015APCP006','M2015APCP007','M2015APCP008','M2015APCP009','M2015APCP010','M2015APCP011','M2015APCP012','M2015APCP013','M2015APCP014','M2015APCP015','M2015APCP016','M2015APCP017','M2015APCP018','M2015APCP019','M2015APCP021','M2015APCP022','M2015APCP023','M2015APCP024','M2015APCP025','M2015APCP026','M2015APCP027','M2015APCP028','M2015APCP029','M2015CCSS001','M2015CCSS002','M2015CCSS004','M2015CCSS005','M2015CCSS006','M2015CCSS008','M2015CCSS009','M2015CCSS010','M2015CCSS011','M2015CCSS012','M2015CCSS013','M2015CCSS015','M2015CCSS016','M2015CCSS017','M2015CF001','M2015CF002','M2015CF003','M2015CF005','M2015CF006','M2015CF007','M2015CF008','M2015CF009','M2015CF010','M2015CF012','M2015CF013','M2015CF014','M2015CF015','M2015CF016','M2015CF017','M2015CF018','M2015CF019','M2015CF021','M2015CF022','M2015CF023','M2015CF024','M2015CF025','M2015CF026','M2015CF027','M2015CF028','M2015CF029','M2015CF030','M2015CF031','M2015CF032','M2015CF033','M2015CF034','M2015CF035','M2015CF036','M2015CJ001','M2015CJ003','M2015CJ006','M2015CJ009','M2015CJ010','M2015CJ011','M2015CJ014','M2015CJ015','M2015CJ016','M2015CJ018','M2015CJ019','M2015CJ021','M2015CJ023','M2015CJ025','M2015CJ027','M2015CJ029','M2015CJ030','M2015CODP002','M2015CODP003','M2015CODP004','M2015CODP005','M2015CODP006','M2015CODP007','M2015CODP008','M2015CODP009','M2015CODP011','M2015CODP012','M2015CODP014','M2015CODP015','M2015CODP017','M2015CODP019','M2015CODP020','M2015CODP021','M2015CODP022','M2015CODP023','M2015CODP024','M2015CODP025','M2015CODP026','M2015CODP027','M2015CODP028','M2015CODP029','M2015CODP030','M2015CODP031','M2015CODP032','M2015CODP033','M2015CODP034','M2015DM001','M2015DM002','M2015DM003','M2015DM004','M2015DM005','M2015DM006','M2015DM007','M2015DM008','M2015DM010','M2015DM012','M2015DM013','M2015DM014','M2015DM016','M2015DM017','M2015DM019','M2015DM020','M2015DM021','M2015DM023','M2015DM024','M2015DM026','M2015DM027','M2015DM028','M2015DM030','M2015DM031','M2015DM032','M2015DM033','M2015DM034','M2015DM035','M2015DM036','M2015DM038','M2015DM039','M2015DM040','M2015DM041','M2015DM042','M2015DS001','M2015DS002','M2015DS003','M2015DS004','M2015DS005','M2015DS006','M2015DS007','M2015DS009','M2015DS011','M2015DS012','M2015DS014','M2015DS016','M2015DS017','M2015DS018','M2015DS019','M2015DS020','M2015DS021','M2015DS024','M2015DS025','M2015DS026','M2015DS028','M2015DS030','M2015DS031','M2015DS032','M2015DS033','M2015DS035','M2015DS037','M2015DS038','M2015DS039','M2015DS041','M2015DS042','M2015DS043','M2015DS044','M2015DS046','M2015DS047','M2015DS048','M2015DS050','M2015DS051','M2015DS053','M2015DS054','M2015DSA001','M2015DSA002','M2015DSA003','M2015DSA005','M2015DSA006','M2015DSA008','M2015DSA009','M2015DSA010','M2015DSA011','M2015DSA012','M2015DSA013','M2015DSA015','M2015DSA016','M2015DSA017','M2015DSA018','M2015DSA019','M2015DSA020','M2015DSA021','M2015DSA022','M2015DSA023','M2015DTA001','M2015DTA002','M2015DTA003','M2015DTA004','M2015DTA005','M2015DTA007','M2015DTA009','M2015DTA010','M2015DTA012','M2015DTA013','M2015DTA014','M2015DTA015','M2015DTA016','M2015DTA017','M2015DTA019','M2015DTA020','M2015DTA023','M2015DTA024','M2015DTA025','M2015DTA027','M2015DTA028','M2015DTA029','M2015DTA030','M2015DTA031','M2015DTA032','M2015DUMM010','M2015GL001','M2015GL002','M2015GL003','M2015GL007','M2015GL011','M2015GL012','M2015GL013','M2015GL014','M2015GL016','M2015GL017','M2015HE003','M2015HE004','M2015HE005','M2015HE006','M2015HE007','M2015HE008','M2015HE009','M2015HE011','M2015HE012','M2015HE013','M2015HE014','M2015HE015','M2015HE017','M2015HE018','M2015HE019','M2015HE020','M2015HE021','M2015HE022','M2015HE023','M2015HE024','M2015HE025','M2015HE026','M2015HE027','M2015HE028','M2015HE029','M2015HE030','M2015HE031','M2015HE032','M2015HE033','M2015HE034','M2015HE035','M2015HE036','M2015HE037','M2015HE038','M2015HE039','M2015HO001','M2015HO002','M2015HO003','M2015HO004','M2015HO005','M2015HO006','M2015HO007','M2015HO008','M2015HO009','M2015HO010','M2015HO011','M2015HO012','M2015HO013','M2015HO014','M2015HO015','M2015HO016','M2015HO018','M2015HO019','M2015HO020','M2015HO021','M2015HO022','M2015HO023','M2015HO024','M2015HO025','M2015HO026','M2015HO027','M2015HO028','M2015HO029','M2015HO030','M2015HO031','M2015HO032','M2015HO033','M2015HO034','M2015HO035','M2015HO036','M2015HO037','M2015HO039','M2015HO040','M2015HO041','M2015HO042','M2015HO043','M2015HO044','M2015HO045','M2015HO046','M2015HO047','M2015HO048','M2015HO049','M2015HO050','M2015HO051','M2015HO052','M2015HRM001','M2015HRM002','M2015HRM003','M2015HRM004','M2015HRM005','M2015HRM006','M2015HRM007','M2015HRM008','M2015HRM009','M2015HRM010','M2015HRM011','M2015HRM012','M2015HRM013','M2015HRM014','M2015HRM015','M2015HRM016','M2015HRM017','M2015HRM018','M2015HRM019','M2015HRM020','M2015HRM023','M2015HRM024','M2015HRM025','M2015HRM026','M2015HRM027','M2015HRM028','M2015HRM029','M2015HRM030','M2015HRM031','M2015HRM032','M2015HRM033','M2015HRM034','M2015HRM035','M2015HRM036','M2015HRM037','M2015HRM038','M2015HRM039','M2015HRM040','M2015HRM041','M2015HRM042','M2015HRM043','M2015HRM044','M2015HRM045','M2015HRM046','M2015HRM047','M2015HRM048','M2015HRM049','M2015HRM050','M2015HRM051','M2015HRM052','M2015HRM053','M2015HRM054','M2015HRM056','M2015HRM057','M2015HRM059','M2015HRM060','M2015HRM061','M2015HRM062','M2015HRM063','M2015HRM064','M2015HRM065','M2015HRM066','M2015HRM067','M2015HRM068','M2015HRM069','M2015HRM071','M2015LE001','M2015LE002','M2015LE003','M2015LE004','M2015LE005','M2015LE006','M2015LE007','M2015LE008','M2015LE009','M2015LE010','M2015LE011','M2015LE013','M2015LE014','M2015LE015','M2015LE017','M2015LE018','M2015LE019','M2015LE020','M2015LE021','M2015LE023','M2015LE024','M2015LE025','M2015LE026','M2015LE027','M2015LE028','M2015LE029','M2015LE030','M2015LE031','M2015MC001','M2015MC002','M2015MC003','M2015MC004','M2015MC005','M2015MC006','M2015MC007','M2015MC008','M2015MC009','M2015MC011','M2015MC012','M2015MC013','M2015MC014','M2015MC015','M2015MC017','M2015MC018','M2015MC019','M2015MC020','M2015MC022','M2015MC023','M2015MC025','M2015MC026','M2015MC027','M2015MC028','M2015MH001','M2015MH002','M2015MH003','M2015MH004','M2015MH006','M2015MH007','M2015MH008','M2015MH009','M2015MH010','M2015MH011','M2015MH012','M2015MH013','M2015MH014','M2015MH015','M2015MH016','M2015MH018','M2015MH019','M2015MH022','M2015MH024','M2015MLIS003','M2015MLIS004','M2015MLIS005','M2015MLIS006','M2015MLIS007','M2015MLIS009','M2015MLIS010','M2015MLIS011','M2015MLIS013','M2015MLIS014','M2015MLIS015','M2015PH001','M2015PH002','M2015PH003','M2015PH004','M2015PH005','M2015PH006','M2015PH007','M2015PH008','M2015PH010','M2015PH011','M2015PH012','M2015PH013','M2015PH014','M2015PH015','M2015PH016','M2015PH018','M2015PH020','M2015PH021','M2015PHHP001','M2015PHHP003','M2015PHHP005','M2015PHHP006','M2015PHHP007','M2015PHHP008','M2015PHHP009','M2015PHHP010','M2015PHHP011','M2015PHHP012','M2015PHHP013','M2015PHHP014','M2015PHHP015','M2015PHHP016','M2015PHHP017','M2015PHHP018','M2015PHHP019','M2015PHHP020','M2015PHHP021','M2015PHSE001','M2015PHSE002','M2015PHSE003','M2015PHSE004','M2015PHSE005','M2015PHSE006','M2015PHSE007','M2015PHSE008','M2015PHSE009','M2015PHSE010','M2015PHSE011','M2015PHSE013','M2015PHSE014','M2015PHSE015','M2015PHSE016','M2015PHSE017','M2015PHSE018','M2015PHSE019','M2015PHSE021','M2015PHSE022','M2015PHSE023','M2015PHSE024','M2015PHSE027','M2015PHSE028','M2015RG001','M2015RG002','M2015RG004','M2015RG005','M2015RG006','M2015RG007','M2015RG008','M2015RG009','M2015RG010','M2015RG011','M2015RG012','M2015RG013','M2015RG014','M2015RG015','M2015RG017','M2015RG018','M2015RG019','M2015RG020','M2015RG021','M2015SE001','M2015SE002','M2015SE006','M2015SE008','M2015SE009','M2015SE010','M2015SE011','M2015SE013','M2015SE014','M2015SE015','M2015SE016','M2015SE017','M2015SE019','M2015SE020','M2015SE021','M2015SE023','M2015SE024','M2015SE025','M2015SE028','M2015SE029','M2015SE030','M2015UPG003','M2015UPG004','M2015UPG005','M2015UPG006','M2015UPG007','M2015UPG008','M2015UPG009','M2015UPG011','M2015UPG012','M2015UPG013','M2015UPG014','M2015UPG016','M2015UPG017','M2015UPG018','M2015UPG019','M2015WCP001','M2015WCP002','M2015WCP003','M2015WCP004','M2015WCP005','M2015WCP006','M2015WCP007','M2015WCP008','M2015WCP010','M2015WCP011','M2015WCP012','M2015WCP013','M2015WCP014','M2015WCP015','M2015WCP016','M2015WCP017','M2015WCP018','M2015WCP020','M2015WCP022','M2015WCP023','M2015WPG001','M2015WPG003','M2015WPG004','M2015WPG006','M2015WPG007','M2015WPG009','M2015WPG011','M2015WPG012','M2015WPG013','M2015WPG014','M2015WPG015','M2015WS001','M2015WS003','M2015WS005','M2015WS006','M2015WS008','M2015WS011','M2015WS013','M2015WS016','M2015WS018','M2015WS019','M2015WS020','M2015WS022','M2015WS025','M2015WS026','M2015WS027','M2016ATJ001','M2016ATJ002','M2016ATJ003','M2016ATJ004','M2016ATJ005','M2016ATJ006','M2016ATJ009','M2016ATJ011','M2016ATJ013','M2016ATJ014','M2016ATJ016','M2016ATJ017','M2016ATJ018','M2016ATJ019','M2016ATJ020','M2016ATJ021','M2016ATJ022','M2016ATJ023','M2016ATJ024','M2016ATJ025','M2016ATJ026','M2016ATJ027','M2016ATJ028','M2016ATJ029','M2016CJ002','M2016DTA005','M2016GL021','M2016WCP021','MH2015APCLP001','MH2015APCLP002','MH2015APCLP003','MH2015APCLP006','MH2015APCLP007','MH2015APCLP008','MH2015APCLP009','MH2015APCLP010','MH2015APCLP012','MH2015APCLP013','MH2015APCLP014','MH2015APCLP016','MH2015APCLP017','MH2015APCLP018','MH2015APCLP020','MM2014DM001','MM2014DS011','MM2014HSS001','MM2014HSS002','MM2014HSS004','MM2014PH005','MM2014SW020','MM2014SW022','MM2015DM002','MM2015DM003','MM2015DM004','MM2015DM005','MM2015DS001','MM2015DS002','MM2015DS003','MM2015DS004','MM2015DS005','MM2015DS006','MM2015DS007','MM2015DS008','MM2015DS009','MM2015DS010','MM2015DS011','MM2015DS015','MM2015ED001','MM2015ED002','MM2015ED003','MM2015ED004','MM2015ED005','MM2015HS001','MM2015ID001','MM2015ID009','MM2015ID011','MM2015MLS001','MM2015MLS003','MM2015MLS004','MM2015MLS005','MM2015MLS006','MM2015MLS007','MM2015MLS008','MM2015MLS009','MM2015MLS010','MM2015PH001','MM2015PH002','MM2015PH004','MM2015PH006','MM2015PH007','MM2015PH008','MM2015PH009','MM2015PH011','MM2015PH012','MM2015PH013','MM2015PH014','MM2015SS002','MM2015SS004','MM2015SS008','MM2015SS009','MM2015SW001','MM2015SW002','MM2015SW003','MM2015SW004','MM2015SW006','MM2015SW010','MM2015SW012','MM2015SW013','MM2015SW015','MM2015SW017','MM2015SW019','MM2015SW020','MM2015SW021','MM2015SW022','MM2015SW023','MM2015WS002','MM2015WS003','MM2015WS005','MM2015WS009','MM2015WS011','PMRDF003','PMRDF005','PMRDF010','PMRDF014','PMRDF016','PMRDF017','PMRDF022','PMRDF023','PMRDF029','PMRDF030','PMRDF032','PMRDF035','PMRDFs12C1MDP01','PMRDFs12C1MDP11','PMRDFs12C1MDP12','PMRDFs12C1MDP35','PMRDFs12C2MDP02','PMRDFs12C2MDP10','PMRDFs14C1MDP05','PMRDFs14C1MDP09','PMRDFs14C1MDP10','PMRDFs14C1MDP13','PMRDFs14C1MDP19','PMRDFs14C1MDP44','PMRDFs14C1MDP52','PMRDFs14C1MDP53','PMRDFs14C1MDP57','PMRDFs14C1MDP59','PMRDFs14C1MDP62','PMRDFs14C2MDP02','PMRDFs14C2MDP04','PMRDFs14C2MDP07','PMRDFs14C2MDP10','PMRDFs14C2MDP18','PMRDFs14C2MDP40','PMRDFs14C2MDP41','PMRDFs14C2MDP47','PMRDFs14C2MDP49','PMRDFs14C2MDP51','PMRDFs14C2MDP53','PMRDFs14C2MDP62','PMRDFs14C2MDP63','PMRDFs14C2MDP64','PMRDFs14C2MDP65','PMRDFs14C2MDP71','PMRDFs14C2MDP72','PMRDFs14C2MDP75','PMRDFs14C2MDP83','PMRDFs14C2MDP87','PMRDFs14C3MDP11','PMRDFs14C3MDP13','PMRDFs14C3MDP17','PMRDFs14C3MDP18','T2013BAMA21','T2014BAMA001','T2014BAMA002','T2014BAMA003','T2014BAMA004','T2014BAMA005','T2014BAMA007','T2014BAMA008','T2014BAMA009','T2014BAMA010','T2014BAMA011','T2014BAMA013','T2014BAMA014','T2014BAMA015','T2014BAMA016','T2014BAMA017','T2014BAMA018','T2014BAMA019','T2014BAMA022','T2014BAMA023','T2014BAMA024','T2014BAMA026','T2014BAMA027','T2014BAMA030','T2014BAMA032','T2014BAMA033','T2014BAMA034','T2014BAMA035','T2014BAMA036','T2014BAMA037','T2014BAMA038','T2014BAMA039','T2014BAMA040','T2014BAMA041','T2014BAMA042','T2014BAMA043','T2014BAMA045','T2014BAMA046','T2014BAMA047','T2014BAMA049','T2014BAMA050','T2014BAMA051','T2014BAMA052','T2014BAMA053','T2014BAMA054','T2014BAMA055','T2014BAMA056','T2014BAMA057','T2014BAMA058','T2014BAMA059','T2014BAMA060','T2014BAMA061','T2014BAMA062','T2014BAMA063','T2014BAMA064','T2014BAMA065','T2014BAMA066','T2014BAMA067','T2014BAMA069','T2014BAMA070','T2014BASW002','T2014BASW004','T2014BASW006','T2014BASW007','T2014BASW008','T2014BASW009','T2014BASW010','T2014BASW012','T2014BASW013','T2014BASW014','T2014BASW016','T2014BASW017','T2014BASW020','T2015BASW18','T2015DPPP003','T2015DPPP004','T2015DPPP005','T2015DPPP006','T2015DPPP007','T2015DPPP008','T2015DPPP009','T2015DPPP010','T2015DPPP011','T2015DPPP012','T2015DPPP013','T2015DPPP015','T2015DPPP016','T2015DPPP017','T2015DPPP018','T2015DPPP019','T2015DPPP020','T2015DPPP021','T2015DPPP022','T2015DPPP024','T2015DPPP025','T2015DPPP026','T2015DPPP027','T2015DPPP029','T2015DPPP030','T2015DPPP031','T2015RD001','T2015RD002','T2015RD003','T2015RD004','T2015RD006','T2015RD008','T2015RD009','T2015RD010','T2015RD011','T2015RD012','T2015RD013','T2015RD014','T2015RD015','T2015RD016','T2015RD018','T2015RD019','T2015RD021','T2015RD022','T2015RD023','T2015RD024','T2015RD025','T2015RD027','T2015RD029','T2015RD030','T2015RD032','T2015RD033','T2015RD034','T2015RD035','T2015RD036','T2015RD037','T2015RD038','T2015SIE001','T2015SIE002','T2015SIE003','T2015SIE004','T2015SIE006','T2015SIE007','T2015SIE008','T2015SIE009','T2015SIE010','T2015SIE011','T2015SIE013','T2015SIE014','T2015SIE015','T2015SIE016','T2015SIE017','T2015SIE018','T2015SIE019','T2015SIE020','T2015SLNG001','T2015SLNG002','T2015SLNG003','T2015SLNG004','T2015SLNG005','T2015SLNG006','T2015SLNG007','T2015SLNG008','T2015SLNG009','T2015SLNG011','T2015SLNG013','T2015SLNG014','T2015SLNG015','T2015SLNG016','T2015SLNG017','T2015SLNG018','T2015SLNG020','T2015SLNG021','T2016DPPP012','T2016SLNG010','T2016SLNG016','TM2015RD001','TM2015RD002','TM2015RD003','TM2015RD005','TM2015RD006','TM2015RD008')
and stud_id not in (
select stud_id --campus_name,progtype_name,prog_name,stud_enrollment_number,convocation_fname,convocation_mname,
--convocation_lname,acba_name,convocation_dob,convocation_permanentadd,convocation_mobile_number,convocation_research_title 
from exams_convocation_details inner join exams_mst_students on convocation_stud_id=stud_id 
inner join exams_mst_campus on stud_campus_id=campus_id 
inner join exams_mst_programs on stud_prog_id=prog_id 
inner join exams_mst_academic_batches on stud_acba_id=acba_id 
inner join exams_mst_programme_type on stud_prog_type_id=progtype_id
where convocation_stud_id!=1233 and convocation_deleted='N' and stud_status='OnRole' 
and stud_deleted='N' and convocation_last_modified_datetime > '2017-01-01'
order by campus_name,prog_name,stud_enrollment_number)

select * from exams_convocation_details where convocation_last_modified_datetime > '2017-01-01'

--list of convocation students with issues
select stud_enrollment_number,stud_fname,stud_lname,stud_dob,convocation_dob,stud_id,convocation_stud_id,convocation_id,convocation_fname,convocation_lname,convocation_upload
from exams_convocation_details inner join exams_mst_students on stud_id=convocation_stud_id and convocation_last_modified_datetime > '2017-01-01' and convocation_deleted='N' and stud_deleted='N' and stud_status='OnRole'
and stud_prog_id=88 and convocation_id in (954,1026,949,2595,2536,1106,1156,1115,2594,2597,956,1017)
--and convocation_upload like 'convocation/2017_Passouts/PMRDF0%'
 --and stud_enrollment_number in ('PMRDF014','PMRDF017','PMRDF030','PMRDF003','PMRDF029','PMRDF022','PMRDF010','PMRDF005','PMRDF016','PMRDF032','PMRDF035','PMRDF023')

---Update queries for convocation
update exams_convocation_details set convocation_upload = 
(select 'convocation/2017_Passouts/'||stud_enrollment_number||'.jpg' from exams_mst_students where stud_prog_id=88 and stud_enrollment_number='PMRDFs12C1MDP16')
where convocation_id=954
update exams_convocation_details set convocation_upload = 
(select 'convocation/2017_Passouts/'||stud_enrollment_number||'.jpg' from exams_mst_students where stud_prog_id=88 and stud_enrollment_number='PMRDFs12C2MDP11')
where convocation_id=1026
update exams_convocation_details set convocation_upload = 
(select 'convocation/2017_Passouts/'||stud_enrollment_number||'.jpg' from exams_mst_students where stud_prog_id=88 and stud_enrollment_number='PMRDFs12C1MDP05')
where convocation_id=949
update exams_convocation_details set convocation_upload = 
(select 'convocation/2017_Passouts/'||stud_enrollment_number||'.jpg' from exams_mst_students where stud_prog_id=88 and stud_enrollment_number='PMRDFs12C2MDP03')
where convocation_id=2595
update exams_convocation_details set convocation_upload = 
(select 'convocation/2017_Passouts/'||stud_enrollment_number||'.jpg' from exams_mst_students where stud_prog_id=88 and stud_enrollment_number='PMRDFs12C1MDP25')
where convocation_id=2536
update exams_convocation_details set convocation_upload = 
(select 'convocation/2017_Passouts/'||stud_enrollment_number||'.jpg' from exams_mst_students where stud_prog_id=88 and stud_enrollment_number='PMRDFs12C1MDP17')
where convocation_id=1106
update exams_convocation_details set convocation_upload = 
(select 'convocation/2017_Passouts/'||stud_enrollment_number||'.jpg' from exams_mst_students where stud_prog_id=88 and stud_enrollment_number='PMRDFs12C2MDP09')
where convocation_id=1156
update exams_convocation_details set convocation_upload = 
(select 'convocation/2017_Passouts/'||stud_enrollment_number||'.jpg' from exams_mst_students where stud_prog_id=88 and stud_enrollment_number='PMRDFs12C2MDP17')
where convocation_id=1115
update exams_convocation_details set convocation_upload = 
(select 'convocation/2017_Passouts/'||stud_enrollment_number||'.jpg' from exams_mst_students where stud_prog_id=88 and stud_enrollment_number='PMRDFs12C1MDP32')
where convocation_id=2594
update exams_convocation_details set convocation_upload = 
(select 'convocation/2017_Passouts/'||stud_enrollment_number||'.jpg' from exams_mst_students where stud_prog_id=88 and stud_enrollment_number='PMRDFs12C1MDP41')
where convocation_id=2597
update exams_convocation_details set convocation_upload = 
(select 'convocation/2017_Passouts/'||stud_enrollment_number||'.jpg' from exams_mst_students where stud_prog_id=88 and stud_enrollment_number='PMRDFs12C1MDP31')
where convocation_id=956
update exams_convocation_details set convocation_upload = 
(select 'convocation/2017_Passouts/'||stud_enrollment_number||'.jpg' from exams_mst_students where stud_prog_id=88 and stud_enrollment_number='PMRDFs12C2MDP16')
where convocation_id=1017

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Dt. 06/04/17 Recent Convocation Query
select campus_name,progtype_name,prog_name,stud_enrollment_number,convocation_fname,convocation_mname,
convocation_lname,acba_name,convocation_dob,regexp_replace(convocation_permanentadd, E'[\\n\\r]+', ' ', 'g' ),convocation_mobile_number,convocation_research_title 
from exams_convocation_details inner join exams_mst_students on convocation_stud_id=stud_id 
inner join exams_mst_campus on stud_campus_id=campus_id 
inner join exams_mst_programs on stud_prog_id=prog_id 
inner join exams_mst_academic_batches on stud_acba_id=acba_id 
inner join exams_mst_programme_type on stud_prog_type_id=progtype_id
where convocation_stud_id!=1233 and convocation_deleted='N' and stud_status='OnRole' 
and stud_deleted='N' and convocation_last_modified_datetime > '2017-01-01'
order by campus_name,prog_name,stud_enrollment_number

-- scse update query
update exams_rel_students_courses_semesters set scse_deleted='Y', scse_last_modified_empl_id=238,,scse_last_modified_datetime=now()
where scse_rscs_id in (
select rscs_id --stud_acba_id,stud_enrollment_number,tcourse_evaluation_rel_stu_courses.* 
from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
where rscs_deleted='N' and stud_status='OnRole'
and rscs_cpse_id=3637 and stud_acba_id=10)
--order by stud_acba_id

-- rscs update query
update tcourse_evaluation_rel_stu_courses 
set rscs_deleted='Y' , rscs_last_modifier_id=238,rscs_last_modified_datetime=now()
where rscs_id in (select rscs_id --stud_acba_id,stud_enrollment_number,tcourse_evaluation_rel_stu_courses.* 
from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
where rscs_deleted='N' and stud_status='OnRole'
and rscs_cpse_id=3637 and stud_acba_id=10)

select --cpse_credits,scse_gpa_actual,
* from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_rel_courses_programes_semesters on cpse_id=rscs_cpse_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id
where stud_deleted='N' and stud_prog_id=39 and rscs_batch_id=stud_acba_id and rscs_deleted='N' and scse_course_attempt='S1' and scse_course_type='C'
and rscs_sem_id='4' 

select stud_id,cour_code,scse_gpa_actual,scse_letter_grade,cpse_credits,scse_course_result,scse_course_attempt,
scse_course_type,scse_semester_attempt,cour_name,stud_enrollment_number,rscs_id 
from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,
tcourse_evaluation_rel_stu_courses,exams_mst_students,exams_mst_courses 
where rscs_batch_id=stud_acba_id and scse_deleted='N' and scse_rscs_id=rscs_id 
and rscs_stu_id in (3758,144) and rscs_batch_id='1' and rscs_cpse_id=cpse_id 
and scse_cpse_id=rscs_cpse_id and cour_id=rscs_course_id and rscs_stu_id=stud_id 
and cast(rscs_sem_id as text) in (select regexp_split_to_table(cpby_sem4,',')  
from exams_rel_campus_prog_batch_year_sems  where cpby_camp_id_id=1 
and cpby_prog_id_id=39 and cpby_acba_id_id=1 ) and scse_deleted='N'
 and(scse_rscs_id,scse_id ) in (select scse_rscs_id , first_value(scse_id) 
 over (partition by scse_rscs_id, scse_cpse_id order by case 
 when scse_course_attempt in ('Re') then 1 else 2 end , scse_id desc) 
 from exams_rel_students_courses_semesters where scse_deleted='N')
 and scse_isconfirm='Y' and scse_rscs_id in 
 (select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id 
 in (3758,144)) and scse_rscs_id in (select scse_rscs_id from exams_rel_students_courses_semesters where scse_deleted='N')group by rscs_stu_id ,stud_enrollment_number,stud_fname, stud_id,cour_code,scse_gpa_actual,scse_letter_grade,cpse_credits,scse_course_result, scse_course_attempt,scse_course_type,scse_semester_attempt,cour_name,stud_enrollment_number,rscs_id 
order by rscs_stu_id, scse_semester_attempt

select stud_id,cour_code,scse_gpa_actual,scse_letter_grade,cpse_credits,scse_course_result
,scse_course_attempt,scse_course_type,scse_semester_attempt,cour_name,stud_enrollment_number,rscs_id 
from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,
tcourse_evaluation_rel_stu_courses,exams_mst_students,exams_mst_courses where 
rscs_batch_id=stud_acba_id and scse_deleted='N' 
and scse_rscs_id=rscs_id and rscs_stu_id in (3758,144) and rscs_cpse_id=cpse_id 
and scse_cpse_id=rscs_cpse_id and cour_id=rscs_course_id and rscs_stu_id=stud_id 
and cast(rscs_sem_id as text) in (select regexp_split_to_table(cpby_sem4,',')  
from exams_rel_campus_prog_batch_year_sems  where cpby_camp_id_id=1 and cpby_prog_id_id=39 and cpby_acba_id_id=1 ) 
and scse_deleted='N' and(scse_rscs_id,scse_id ) in (select scse_rscs_id , first_value(scse_id) 
over (partition by scse_rscs_id, scse_cpse_id order by case when scse_course_attempt 
in ('S1','Re','R','I','S2','RC') then 1 else 2 end , scse_id desc) 
from exams_rel_students_courses_semesters where scse_deleted='N')
and scse_isconfirm='Y' and scse_rscs_id in (select rscs_id 
from tcourse_evaluation_rel_stu_courses where rscs_stu_id in (3758,144)) and rscs_batch_id=stud_acba_id 
and scse_rscs_id in (select scse_rscs_id from exams_rel_students_courses_semesters where scse_deleted='N')
group by rscs_stu_id ,stud_enrollment_number,stud_fname, stud_id,cour_code,scse_gpa_actual,
scse_letter_grade,cpse_credits,scse_course_result, scse_course_attempt,scse_course_type,
scse_semester_attempt,cour_name,stud_enrollment_number,rscs_id order by rscs_stu_id, scse_semester_attempt

select distinct rcp_prog_id ,prog_name from exams_rel_campus_school_programes_courses 
inner join exams_mst_programs on prog_id =rcp_prog_id
where rcp_school_id=15

--GPA division
select cpse_credits,scse_gpa_actual,cpse_credits*scse_gpa_actual from tcourse_evaluation_rel_stu_courses inner join exams_mst_students on stud_id=rscs_stu_id 
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_cpse_id=scse_cpse_id and rscs_id=scse_rscs_id
where stud_enrollment_number ='M2015UPG004' and rscs_deleted='N' and scse_deleted='N'

select * from exams_mst_employees where empl_role_id=3

update exams_mst_students set stud_sem_id=6 where stud_id in (select stud_id  from exams_mst_students where stud_enrollment_number in 
('PMRDFs14C1MDP05','PMRDFs14C1MDP13','PMRDFs14C1MDP52','PMRDFs14C1MDP53','PMRDFs14C1MDP57','PMRDFs14C1MDP62','PMRDFs14C2MDP02','PMRDFs14C2MDP04',
'PMRDFs14C2MDP07','PMRDFs14C2MDP10','PMRDFs14C2MDP18','PMRDFs14C2MDP40','PMRDFs14C2MDP41','PMRDFs14C2MDP47','PMRDFs14C2MDP49','PMRDFs14C2MDP51','PMRDFs14C2MDP53',
'PMRDFs14C2MDP62','PMRDFs14C2MDP63','PMRDFs14C2MDP64','PMRDFs14C2MDP65','PMRDFs14C2MDP71','PMRDFs14C2MDP72','PMRDFs14C2MDP75','PMRDFs14C2MDP83','PMRDFs14C2MDP87',
'PMRDFs14C3MDP11','PMRDFs14C3MDP13','PMRDFs14C3MDP18','PMRDFs12C1MDP01','PMRDFs12C1MDP05','PMRDFs12C1MDP11','PMRDFs12C1MDP12','PMRDFs12C1MDP16','PMRDFs12C1MDP17',
'PMRDFs12C1MDP25','PMRDFs12C1MDP31','PMRDFs12C1MDP32','PMRDFs12C1MDP35','PMRDFs12C2MDP02','PMRDFs12C2MDP03','PMRDFs12C2MDP09','PMRDFs12C2MDP10','PMRDFs12C2MDP11','PMRDFs12C2MDP16'))

--DS 15-17 students enrolled for cbcs courses
select cour_code ,cour_name,stud_enrollment_number,scse_gpa_actual,* from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
where stud_prog_id=8 and stud_acba_id=1 and rscs_course_type='C' and rscs_deleted='N' and stud_campus_id=1
order by stud_enrollment_number

--query to search students 2,3 sem courses based on given enrollment number
select cour_name,* from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on rscs_course_id=cour_id
where stud_enrollment_number ='M2015WCP020' and rscs_sem_id in (2,3) and rscs_course_type='M' and rscs_deleted='N'

********************************************************************************************************************************************************************************************************


select * from exams_rel_campus_prog_batch_year_sems where cpby_acba_id_id=1 and cpby_prog_id_id in (19,20,21)

--course evaluation deleted but marks entry enabled
update exams_rel_students_courses_semesters set scse_deleted='Y' where scse_id in (select scse_id--,prog_name,cour_name,stud_enrollment_number,acba_name,scse_last_modified_datetime,scse_last_modified_empl_id,rscs_last_modified_datetime,rscs_last_modifier_id,scse_gpa_actual
from tcourse_evaluation_rel_stu_courses 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_rel_courses_programes_semesters on cpse_id=rscs_cpse_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on cour_id=rscs_course_id
inner join exams_mst_programs on cpse_prog_id=prog_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
where rscs_deleted='Y' and scse_deleted='N' and cpse_deleted='N' )

select * from exams_mst_students where stud_enrollment_number in ('','M2015HRM002')
--course evaluation enabled but marks entry deleted
select prog_name,cour_name,stud_enrollment_number,acba_name,scse_last_modified_datetime,scse_last_modified_empl_id,rscs_last_modified_datetime,rscs_last_modifier_id,scse_gpa_actual
from tcourse_evaluation_rel_stu_courses 
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
inner join exams_rel_courses_programes_semesters on cpse_id=rscs_cpse_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on cour_id=rscs_course_id
inner join exams_mst_programs on cpse_prog_id=prog_id
inner join exams_mst_academic_batches on cpse_acba_id=acba_id
where rscs_deleted='N' and scse_deleted='Y' and cpse_deleted='N' order by acba_name

select rscs_stu_id ,stud_enrollment_number,stud_fname,stud_mname,stud_lname,sum(scse_gpa_actual*cpse_credits) ,sum(cpse_credits),round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),1) 
from exams_rel_students_courses_semesters,exams_rel_courses_programes_semesters,tcourse_evaluation_rel_stu_courses,exams_mst_students 
where scse_deleted='N' and scse_rscs_id=rscs_id and rscs_stu_id in (7008) and rscs_cpse_id=cpse_id and scse_cpse_id=rscs_cpse_id and ((scse_gpa_actual is not null and scse_isabsent='N') or(scse_gpa_actual is null and scse_isabsent='Y'))and scse_course_type <> 'AU' and scse_course_type <>'EC' and scse_course_type <>'NC' and scse_course_type <>'C' and rscs_stu_id=stud_id and cast(rscs_sem_id as text) in (select regexp_split_to_table(cpby_sem6,',')  from exams_rel_campus_prog_batch_year_sems where cpby_camp_id_id=2 and cpby_prog_id_id=70 and cpby_acba_id_id=8 )and scse_deleted='N' and(scse_rscs_id,scse_id ) in (select scse_rscs_id , first_value(scse_id) over (partition by scse_rscs_id, scse_cpse_id order by case when scse_course_attempt in ('S1','Re','R','I','S2','RC') then 1 else 2 end ,scse_id desc) from exams_rel_students_courses_semesters where scse_deleted='N')and rscs_batch_id=stud_acba_id and scse_isconfirm='Y' and scse_rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id in (7008) and scse_rscs_id in (select scse_rscs_id from exams_rel_students_courses_semesters where scse_deleted='N'))group by rscs_stu_id ,stud_enrollment_number,stud_fname,stud_mname,stud_lname order by rscs_stu_id
and stud_status='N' and stud_status='OnRole'

---CBCS courses taken by a student
select * from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id and rscs_course_type='C'
where stud_enrollment_number='M2015HRM002'

--calculation of students credits , gpa's,
select stud_id,cpse_id,scse_course_attempt,cpse_credits,scse_gpa_actual,cpse_credits*scse_gpa_actual ,scse_course_type
from tcourse_evaluation_rel_stu_courses inner join exams_mst_students on stud_id=rscs_stu_id 
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_rel_students_courses_semesters on rscs_cpse_id=scse_cpse_id and rscs_id=scse_rscs_id and rscs_sem_id=3
where stud_enrollment_number ='M2015HRM002' and rscs_deleted='N' and scse_deleted='N'


--15-17 student enrollement of cbcs courses
select cour_code ,cour_name,stud_enrollment_number,scse_gpa_actual,* from tcourse_evaluation_rel_stu_courses 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_students_courses_semesters on rscs_id=scse_rscs_id
where stud_acba_id=1 and rscs_course_type='C' and rscs_deleted='N' and stud_campus_id=1 and stud_enrollment_number ='M2015HRM002'
order by stud_enrollment_number

********************************************************************************************************************************************************************************************************

select campus_name,progtype_name,prog_name,stud_enrollment_number,convocation_fname,convocation_mname,
convocation_lname,acba_name,convocation_dob,regexp_replace(convocation_permanentadd, E'[\\n\\r]+', ' ', 'g' ),convocation_mobile_number,convocation_research_title,convocation_inc_name,convocation_cor_name
from exams_convocation_details inner join exams_mst_students on convocation_stud_id=stud_id 
inner join exams_mst_campus on stud_campus_id=campus_id 
inner join exams_mst_programs on stud_prog_id=prog_id 
inner join exams_mst_academic_batches on stud_acba_id=acba_id 
inner join exams_mst_programme_type on stud_prog_type_id=progtype_id
where convocation_stud_id!=1233 and convocation_deleted='N' and stud_status='OnRole' 
and stud_deleted='N' and convocation_last_modified_datetime > '2017-01-01'
order by campus_name,prog_name,stud_enrollment_number


select campus_name,progtype_name,prog_name,stud_enrollment_number,convocation_fname,convocation_mname,
convocation_lname,acba_name,convocation_dob,regexp_replace(convocation_permanentadd, E'[\\n\\r]+', ' ', 'g' ),convocation_mobile_number,convocation_research_title 
from exams_convocation_details inner join exams_mst_students on convocation_stud_id=stud_id 
inner join exams_mst_campus on stud_campus_id=campus_id 
inner join exams_mst_programs on stud_prog_id=prog_id 
inner join exams_mst_academic_batches on stud_acba_id=acba_id 
inner join exams_mst_programme_type on stud_prog_type_id=progtype_id
where convocation_stud_id!=1233 and convocation_deleted='N' and stud_status='OnRole' and stud_enrollment_number in ('T2015SIE001','T2015SIE002','T2015SIE003','T2015SIE004','T2015SIE006','T2015SIE007','T2015SIE008','T2015SIE009','T2015SIE010','T2015SIE011','T2015SIE013','T2015SIE014','T2015SIE015','T2015SIE016','T2015SIE017','T2015SIE018','T2015SIE019','T2015SIE020','T2015DPPP003','T2015DPPP004','T2015DPPP005','T2015DPPP006','T2015DPPP007','T2015DPPP008','T2015DPPP009','T2015DPPP010','T2015DPPP011','T2015DPPP012','T2015DPPP013','T2015DPPP015','T2015DPPP016','T2015DPPP017','T2015DPPP018','T2015DPPP019','T2015DPPP020','T2015DPPP021','T2015DPPP022','T2015DPPP024','T2015DPPP025','T2015DPPP026','T2015DPPP027','T2015DPPP029','T2015DPPP030 ','T2015DPPP031','T2015RD001','T2015RD002','T2015RD003','T2015RD004','T2015RD006','T2015RD008','T2015RD009','T2015RD010','T2015RD011','T2015RD012','T2015RD013','T2015RD014','T2015RD015','T2015RD016','T2015RD018','T2015RD019','T2015RD020','T2015RD021','T2015RD022','T2015RD023','T2015RD024','T2015RD025','T2015RD026','T2015RD027','T2015RD028','T2015RD029','T2015RD030','T2015RD032','T2015RD033','T2015RD034','T2015RD035','T2015RD036','T2015RD037','T2015RD038','T2015SLNG001','T2015SLNG002','T2015SLNG003','T2015SLNG004','T2015SLNG005','T2015SLNG006','T2015SLNG007','T2015SLNG008','T2015SLNG009','T2015SLNG011','T2015SLNG012','T2015SLNG013','T2015SLNG014','T2015SLNG015','T2015SLNG016','T2015SLNG017','T2015SLNG018','T2015SLNG020','T2015SLNG021','MM2014MLS004','MM2015SW022','MM2015MLS005','MM2015MLS008','MM2015SS006','MM2014DS011','MM2015WS002')
and stud_deleted='N' and convocation_last_modified_datetime > '2017-01-01'
order by campus_name,prog_name,stud_enrollment_number


--3rd
update exams_mst_students set stud_degree_type='MS' where stud_enrollment_number in ('M2015CCSS002','M2015CCSS004','M2015CCSS005','M2015CCSS008','M2015CCSS009','M2015CCSS010','M2015CCSS011','M2015CCSS012','M2015CCSS013','M2015CCSS016','M2015RG001','M2015RG002','M2015RG004','M2015RG006','M2015RG008','M2015RG014','M2015RG019','M2015RG020','M2015RG021','M2015UPG006','M2015UPG009','M2015UPG012','M2015UPG014','M2015UPG016','M2015UPG019','M2015WPG003','M2015WPG004','M2015WPG006','M2015WPG007','M2015WPG009','M2015WPG011','M2015WPG013','M2015WPG015','M2014WPG012','T2015SLNG006','T2015SLNG013','T2015SLNG014','T2015SLNG016','T2015SLNG017','T2015SLNG018','T2015DPPP012','T2015DPPP015','T2015DPPP017')

--2nd
select * from exams_mst_students where stud_deleted='N' and stud_status='OnRole' and stud_prog_id in (28,29,30,31,48,49) and stud_acba_id=1 order by stud_enrollment_number 

--1st
update exams_mst_students set stud_degree_type='MA' where stud_id in
(select stud_id from exams_mst_students where stud_deleted='N' and stud_status='OnRole' and stud_prog_id in (28,29,30,31,48,49) and stud_acba_id=1 order by stud_enrollment_number )

********************************************************************************************************************************************************************************************************

--Dt. 27/04/17 
--query to find no. of courses enrolled by a student of 15-17 batch 
select distinct campus_name,stud_enrollment_number,count(rscs_course_id) from 
tcourse_evaluation_rel_stu_courses
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id and cpse_acba_id =rscs_batch_id
inner join exams_rel_students_courses_semesters on scse_rscs_id=rscs_id and scse_cpse_id=cpse_id --and scse_acba_id=rscs_batch_id
inner join exams_mst_programs on cpse_prog_id=prog_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_campus on stud_campus_id=campus_id
where rscs_deleted='N' and scse_deleted='N' and cpse_deleted='N' and scse_course_attempt='Re' and
stud_acba_id=1 and stud_status='OnRole' and stud_deleted='N' --and prog_id !=83
group by campus_name,stud_id,rscs_batch_id order by campus_name


select * from exams_mst_students where stud_acba_id=1 and stud_prog_id=15 and stud_deleted='N' and stud_status='OnRole'


update exams_mst_students set stud_degree_type='MA' where stud_acba_id=1 and stud_prog_id=15 and stud_deleted='N' and stud_status='OnRole'


update exams_mst_students set stud_degree_type='MS' where stud_acba_id=1 and stud_prog_id=15 and stud_deleted='N' and stud_status='OnRole' and stud_enrollment_number in ( 
'M2015DM003','M2015DM005','M2015DM008','M2015DM010','M2015DM012','M2015DM014','M2015DM016','M2015DM020','M2015DM021','M2015DM023','M2015DM024','M2015DM027','M2015DM032','M2015DM034','M2015DM036','M2015DM040')


select * from exams_mst_students where stud_remarks !=''

--SQL Query to search credits based fail and pass students of MA 2015-2017 Mumbai,Hyderabad and tuljapur campus
select *,case 
when table1.gpa between 0.1 and 1.0 then 'D'
when table1.gpa between 1.1 and 2.0 then 'C-'
when table1.gpa between 2.1 and 3.0 then 'C'
when table1.gpa between 3.1 and 4.0 then 'C+'
when table1.gpa between 4.1 and 5.0 then 'B-'
when table1.gpa between 5.1 and 6.0 then 'B'
when table1.gpa between 6.1 and 7.0 then 'B+'
when table1.gpa between 7.1 and 8.0 then 'A-'
when table1.gpa between 8.1 and 9.0 then 'A'
when table1.gpa between 9.1 and 10.0 then 'A+'
else 'F'
end as "Letter Grade" from (select campus_name,rscs_stu_id ,stud_enrollment_number,stud_fname,stud_mname,stud_lname,sum(scse_gpa_actual*cpse_credits) as "totalgpa" ,sum(cpse_credits) as "credits_completed",
round(sum(scse_gpa_actual*cpse_credits)/sum(cpse_credits),1) as "gpa",cpby_mandatory_credits+cpby_cbcs_credits as "creditsreq",
case  
when sum(cpse_credits)>=cpby_mandatory_credits+cpby_cbcs_credits then 'Pass' 
else 'Fail' end as "Result"
from exams_rel_students_courses_semesters
inner join exams_rel_courses_programes_semesters on scse_cpse_id=cpse_id
inner join tcourse_evaluation_rel_stu_courses on scse_rscs_id=rscs_id and rscs_cpse_id=cpse_id 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_mst_campus on stud_campus_id=campus_id
--inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_rel_campus_prog_batch_year_sems on stud_prog_id=cpby_prog_id_id and cpby_acba_id_id=stud_acba_id and cpby_camp_id_id =stud_campus_id
where scse_deleted='N' and stud_acba_id in (1,2,4) 
and scse_cpse_id=rscs_cpse_id and ((scse_gpa_actual is not null and scse_isabsent='N') or(scse_gpa_actual is null and scse_isabsent='Y'))
and scse_course_type <> 'AU' and scse_course_type <>'EC' and scse_course_type <>'NC' and rscs_stu_id=stud_id and rscs_sem_id in (1,2,3,4,5,6)
and cpby_prog_id_id =stud_prog_id --and prog_prty_id=1
and rscs_deleted='N' and(scse_rscs_id,scse_id ) in (select scse_rscs_id , first_value(scse_id) over (partition by scse_rscs_id, scse_cpse_id 
order by case when scse_course_attempt in ('Re','R','RC','S1','S2') then 1 else 2 end ,scse_id desc) from exams_rel_students_courses_semesters where scse_deleted='N')
and rscs_batch_id=stud_acba_id and scse_isconfirm='Y' and scse_rscs_id in (select rscs_id from tcourse_evaluation_rel_stu_courses where rscs_stu_id in 
(select stud_id from exams_mst_students where stud_status='OnRole' and stud_deleted='N' and stud_campus_id in (1,2,4) and stud_acba_id in (1)) 
and rscs_deleted='N')group by campus_name,rscs_stu_id ,stud_enrollment_number,stud_fname,stud_mname,stud_lname,cpby_mandatory_credits,cpby_cbcs_credits
order by campus_name DESC,stud_enrollment_number ) as table1

*********************************************************************************************************************************************************************************************************
--Dt:- 23/05/17
--Query to search course not mapped for 16-18 IInd semester
select distinct campus_name,prog_name 
from exams_mst_programs inner join exams_rel_campus_school_programes_courses on prog_id=rcp_prog_id 
inner join exams_mst_campus on rcp_campus_id=campus_id
and prog_id in 
(select prog_id from exams_mst_programs 
where prog_deleted ='N' and prog_prty_id in (1,2,5) and prog_id not in (83,74,76,71,72,73,75,18,17,88)
and prog_id not in (
select prog_id --distinct campus_name,prog_name,cour_name,cpse_cour_type,cpse_created_datetime,seme_name cpse_credits
from exams_rel_courses_programes_semesters 
inner join exams_mst_programs on cpse_prog_id=prog_id
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_mst_campus on cpse_campus_id=campus_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
inner join exams_rel_campus_school_programes_courses on rcp_prog_id=cpse_prog_id 
where cpse_created_datetime > '2017-05-17' and cpse_deleted='N' --and cpse_seme_id=3 
order by prog_name,seme_name,cour_name,cpse_cour_type
) order by prog_name ) order by campus_name

--Query to search course mapped after email
select distinct campus_name,prog_name,cour_name,cpse_cour_type,cpse_created_datetime,seme_name cpse_credits
from exams_rel_courses_programes_semesters 
inner join exams_mst_programs on cpse_prog_id=prog_id
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_mst_campus on cpse_campus_id=campus_id
inner join exams_mst_semesters on cpse_seme_id=seme_id
where cpse_created_datetime > '2017-05-17' and cpse_deleted='N' --and cpse_seme_id=3 
order by prog_name,seme_name,cour_name,cpse_cour_type

--Dt. 12June17
--select students still not filled semester registration
select * from exams_mst_students 
inner join exams_mst_programs on stud_prog_id=prog_id
where ((stud_acba_id=10 and stud_sem_id=2) or (stud_acba_id=11 and stud_sem_id=3) or (stud_acba_id=3 and stud_sem_id=5)) and stud_status='OnRole' and stud_prog_type_id in (1,2,5) and
stud_id not in (select ssr_stu_id 
from exams_rel_stud_sem_registration where ssr_deleted='N')
order by stud_prog_id,stud_enrollment_number  

--Dt : 20/06/17 Query to search courses enrolled by students in semester registration form
select campus_name,stud_enrollment_number, stud_fname, stud_lname,stud_tiss_email,prog_name,cour_name,seme_name,rscs_course_type
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses on rscs_stu_id=stud_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_semesters on rscs_sem_id=seme_id
inner join exams_rel_courses_programes_semesters on cpse_id=rscs_cpse_id
where rscs_deleted='N' and cpse_deleted='N' and stud_status='OnRole' and stud_deleted='N'
and rscs_batch_id in (3,10) and rscs_course_type!='M' and rscs_sem_id in (3,5)
order by campus_name,prog_name,stud_enrollment_number,cour_name

********************************************************************************************************************************************************************************************************

--Dt:-27/06/17 query to extract semester registration student details excluding M.A. Elementary Education(Mumbai) and Chennai campus students
select campus_name,prog_name,stud_enrollment_number,stud_fname,stud_lname,seme_name,acba_name,ssr_stud_isconfirm, case -- ssr_stud_isconfirm
when ssr_stud_isconfirm ='N' then '' 
when ssr_stud_isconfirm = 'Y' then 'YES'
--as "Form Submitted"
--else 'No-Info'
END
from exams_mst_students 
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
left join exams_rel_stud_sem_registration on stud_id=ssr_stu_id
where stud_acba_id in (10,11,3) and stud_status='OnRole' and stud_prog_type_id in (1,2) and stud_campus_id !=5 and prog_id!=42
-- and stud_id not in (select ssr_stu_id from exams_rel_stud_sem_registration where ssr_deleted='N' and ssr_stud_isconfirm='Y')
order by campus_name,stud_prog_id,stud_enrollment_number  

--Dt:-27/06/17 query to extract semester registration student details excluding M.A. Elementary Education(Mumbai) and Chennai campus students
select campus_name,prog_name,stud_enrollment_number,stud_fname,stud_lname,seme_name,acba_name,ssr_stud_isconfirm, case -- ssr_stud_isconfirm
when ssr_stud_isconfirm ='N' then '' 
when ssr_stud_isconfirm = 'Y' then 'YES'
--as "Form Submitted"
--else 'No-Info'
END
from exams_mst_students 
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
left join exams_rel_stud_sem_registration on stud_id=ssr_stu_id and ssr_deleted='N'
where stud_acba_id in (10,11,3) and stud_status='OnRole' and stud_prog_type_id in (1,2) and stud_campus_id !=5 and prog_id!=42 
order by campus_name,stud_prog_id,stud_enrollment_number  

--students with UNCONFIRMED semester registration or Not Registered excluding M.A. Elementary Education(Mumbai) and Chennai campus students
select campus_name,prog_name,stud_enrollment_number,stud_fname,stud_lname,acba_name
from exams_mst_students 
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id 
where stud_acba_id in (10,11,3) and stud_status='OnRole' and stud_prog_type_id in (1,2) and stud_prog_id !=42 and  stud_campus_id!=5 and
stud_id not in (select ssr_stu_id 
from exams_rel_stud_sem_registration where ssr_deleted='N' and ssr_stud_isconfirm='Y')
order by campus_name,prog_name,stud_enrollment_number

--Raw perfect query for semester registration
select stud_id,stud_enrollment_number /*campus_name,prog_name,stud_enrollment_number,stud_fname,stud_lname,seme_name,acba_name,ssr_stud_isconfirm, case -- ssr_stud_isconfirm
when ssr_stud_isconfirm ='N' then '' 
when ssr_stud_isconfirm = 'Y' then 'YES'
--as "Form Submitted"
--else 'No-Info'
END*/
from exams_mst_students 
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
left join exams_rel_stud_sem_registration on stud_id=ssr_stu_id
where stud_acba_id in (10,11,3) and stud_status='OnRole' and stud_prog_type_id in (1,2) and stud_campus_id !=5 and prog_id!=42
-- and stud_id not in (select ssr_stu_id from exams_rel_stud_sem_registration where ssr_deleted='N' and ssr_stud_isconfirm='Y')
--order by campus_name,stud_prog_id,stud_enrollment_number) as table1
and stud_enrollment_number not in (
select stud_enrollment_number
from exams_mst_students 
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_campus on stud_campus_id=campus_id
where stud_acba_id in (10,11,3) and stud_status='OnRole' and stud_prog_type_id in (1,2) and stud_prog_id !=42 and  stud_campus_id!=5 and
stud_id not in (select ssr_stu_id 
from exams_rel_stud_sem_registration where ssr_deleted='N' and ssr_stud_isconfirm='Y')
order by campus_name,prog_name,stud_enrollment_number
) group by stud_id,stud_enrollment_number having count(stud_enrollment_number)>1  and stud_enrollment_number not in ('M2016PHHP015','M2016PHSE019','M2016HO032','M2016CCSS013','H2015BAMA18','M2016PH007','M2016CF010','H2015BAMA19','M2016PHSE022','M2016UPG020','M2016LE028','M2016HRM042','M2016CF030','M2016CF011','M2016CF003','H2015BAMA15','M2016RG020','M2016HRM029','M2016DS023','M2016HO039','T2016RD009','T2016DPPP020','T2016SLNG015','M2016HO048','M2016HO047','M2016HO031','M2016MC027','T2016BASW023','T2016BASW005','T2016BASW007','T2016BASW020','T2016BASW011','T2016BASW014','T2016BASW021','T2016BASW019','T2016BASW009','T2016BASW016','T2016BASW012','T2016BASW025','T2016BASW017','T2016BASW031','T2016BASW001','T2016BASW002','T2016BAMA030','H2015BAMA65','H2015BAMA44','H2015BAMA01','H2015BAMA17','H2015BAMA43','H2015BAMA02','H2015BAMA20','H2015BAMA60','H2015BAMA24','H2015BAMA33','H2015BAMA13','H2015BAMA64','H2015BAMA30','H2015BAMA59','H2015BAMA41','H2015BAMA39','H2015BAMA09','H2016DS003','H2016DS005','H2016DS007','H2016DS009','H2016DS011','H2016DS014','H2016DS015','H2016DS018','H2016DS019','H2016DS020','H2016DS023','H2016DS024','H2016DS016','H2016DS017','H2016DS026','H2016DS027','H2016DS028','H2016DS032','H2016ED001','H2016ED002','H2016ED004','H2016ED005','H2016ED006','H2016ED011','H2016RDG002','H2016ED016','H2016ED017','H2016ED018','H2016ED019','H2016NRG001','H2016NRG002','H2016BAMA005','H2016NRG003','H2016NRG004','H2016NRG005','H2016NRG006','H2016NRG007','H2016NRG008','H2016NRG009','H2016NRG011','H2016NRG017','H2016NRG020','H2016NRG023','H2016NRG027','H2016PPG002','H2016PPG003','H2016PPG006','H2016PPG007','H2016PPG008','H2016PPG014','H2016BAMA007','H2016PPG020','H2016PPG021','H2016PPG022','H2016PPG023','H2016PPG029','H2016RDG001','H2016RDG005','H2016RDG006','H2016RDG007','H2016RDG010','H2016RDG011','H2016RDG012','H2016RDG003','H2016RDG014','H2016RDG015','H2016RDG017','H2016RDG019','H2016RDG021','H2016RDG022','H2016RDG024','H2016RDG026','H2016WS001','H2016WS002','H2016WS004','H2016WS005','H2016WS006','H2016WS007','H2016WS008','H2016WS013','H2016WS014','H2016WS015','H2016WS020','H2016WS021','H2016WS022','H2016WS026','H2016WS029','H2016DSM033','H2016HRM001','H2016PPGM037','H2016HRM003','H2016HRM004','H2016HRM006','H2016HRM008','H2016HRM009','H2016BAMA009','H2015BAMA34','H2016HRM010','H2016HRM011','H2016HRM012','H2016HRM013','H2016HRM014','H2016HRM017','M2016HRM058','H2016HRM018','H2016HRM019','H2016PPGM038','H2016HRM020','H2016HRM021','H2016HRM022','H2016HRM024','H2016HRM027','H2016HRM029','H2016HRM030','H2016HRM031','H2016HRM032','H2016HRM033','H2016HRMM038','H2016HRMM039','H2016BAMA010','H2016BAMA012','H2016BAMA014','H2016BAMA015','H2016BAMA017','H2016BAMA018','H2016BAMA021','H2016BAMA026','H2016BAMA027','H2016BAMA028','H2016DS001','H2016BAMA030','H2016BAMA034','H2016BAMA035','H2016BAMA036','H2016BAMA037','H2016BAMA039','H2016BAMA040','H2016BAMA041','H2016BAMA042','H2016BAMA044','H2016BAMA046','H2016BAMA047','H2016BAMA049','H2016BAMA050','H2016BAMA053','H2016BAMA054','H2016BAMA059','H2016ED014','H2016PPG009','G2016BAMA030','H2016RDG028','H2016WS023','H2016WS024','H2016WS028','M2016HO024','M2016UPG002','H2016HRMM042','H2016NRG010','H2016NRG016','H2016HRMM036','H2016HRMM037','H2016NRG012','M2016MLIS009','T2016SLNG004','T2016BAMA004','T2016BAMA026','T2016RD030','H2015BAMA58','T2015BASW24','M2016WCP002','T2015BASW04','T2015BASW10','T2015BASW34','H2015BAMA03','H2016HRM005','T2015BASW06','H2016DS006','G2016SSA012','H2016DSM035','H2016DSM036','M2016PHSE015','M2016PH015','M2016PHSE002','M2016CODP019','H2016NRGM028','M2016HO042','M2016HO044','H2016NRGM029','M2016HO030','H2016NRGM031','H2016WS019','M2016PHSE025','M2016PH020','M2016HO033','M2016HRM005','M2016PHHP019','M2016DTA019','M2016HO028','M2016DM004','M2016HO046','M2016SE028','H2015BAMA12','H2015BAMA11','H2015BAMA45','H2015BAMA10','M2016HO001','M2016APCP027','M2016CF005','M2016LE030','M2016CF020','M2016CODP024','M2016CODP020','M2016HO021','M2016DTA014','M2016MH004','M2016MH012','M2016UPG012','M2016APCLP011','M2016WPG002','H2015BAMA52','M2016CF019','M2016DTA026','M2016SE008','M2016APCLP020','M2016HRM006','M2016DTA028','M2016RG010','M2016APCP021','M2016LE026','M2016CJ020','H2015BAMA49','M2016LE011','M2016CODP011','M2016LE031','M2016HRM069','M2016DS007','M2016SE010','M2016DM023','M2016WS006','M2016HO037','M2016WS011','M2016CJ027','M2016MC016','M2016APCLP021','H2015BAMA47','M2016HRM023','M2016HRM033','M2016PH005','M2016LE016','M2016DM003','M2016DSA010','M2016LE005','M2016APCP011','M2016HO004','M2016HRM014','M2016DS005','M2016APCLP014','M2016APCP014','M2016HRM024','M2016MH003','M2016DSA019','M2016APCLP007','M2016MLIS004','M2016WS002','M2016HRM054','M2016WS018','M2016APCP012','M2016HRM051','M2016DM026','M2016HRM067','M2016GL003','M2016PHHP016','M2016PHHP002','T2016DPPP001','T2016DPPP002','T2016DPPP003','T2016DPPP004','T2016DPPP006','T2016DPPP007','T2016DPPP010','T2016DPPP013','T2016DPPP014','T2016DPPP015','M2016PHHP011','H2015BAMA46','T2016DPPP016','T2016DPPP018','T2016SIE005','T2016SIE012','H2015BAMA48','T2016SLNG003','T2016SLNG006','T2016SLNG007','T2016SLNG008','T2016SLNG009','T2016SLNG011','T2016SLNG012','T2016SLNG013','T2016SLNG014','T2016SIE014','T2016SLNG017','T2016SLNG020','H2015BAMA38','M2016PHHP014','M2016PHHP001','M2016PHHP020','M2016PHHP009','M2016PHHP018','M2016PHHP010','M2016PHHP013','M2016PHHP004','M2016PHHP021','H2015BAMA37','M2016PHSE009','M2016PHSE018','M2016PHSE024','M2016PHSE023','M2016PHSE005','M2016PHSE021','M2016PHSE004','M2016PHSE020','M2016PHSE016','H2015BAMA35','M2016DM033','H2015BAMA28','H2015BAMA26','M2016PHSE026','M2016PHSE008','M2016PHSE003','H2015BAMA05','M2016APCP007','H2015BAMA16','M2016PH019','M2016CF012','M2016CF008','M2016HRM049','M2016RG013','M2016HRM036','M2016WS005','M2016CF017','M2016HRM043','M2016SE020','M2016APCP020','H2015BAMA42','M2016DM011','M2016DS036','M2016CJ005','H2015BAMA25','M2016APCLP004','M2016SE016','M2016APCP026','M2016DSA011','M2016DS012','M2016WCP008','M2016PH017','M2016CF009','M2016CCSS007','M2016CODP022','M2016CCSS004','M2016APCP019','M2016MH024','M2016PHSE027','M2016HRM060','M2016HRM039','M2016CODP008','M2016APCLP018','M2016CF016','M2016DTA017','M2016MC018','T2016DPPP021','T2016DPPP022','M2016LE007','M2016UPG019','M2016MC009','M2016DS040','M2016APCLP017','H2016HRM002','M2016DS006','H2016HRM015','H2016HRMM044','M2016HRM047','M2016WS030','M2016MH001','H2016HRMM041','H2016HRMM043','M2016DSA007','M2016WPG014','M2016DSA016','M2016MC025','M2016MLIS001','M2016PHHP007','M2016PHSE001','M2016HO038','M2016PHHP006','M2016PHHP003','M2016HO029','M2016HO050','M2016HO023','M2016HO025','M2016HO016','M2016HO041','M2016HO049','M2016HO043','M2016HO034','M2016HO027','M2016HO036','M2016HO026','M2016WS010','M2016LE019','M2016CODP025','M2016DTA003','M2016DSA004','M2016GL009','M2016APCP010','M2016DM035','M2016MH019','M2016UPG011','M2016RG001','M2016RG004','M2016UPG007','M2016UPG009','T2016BASW018','M2016UPG013','M2016UPG015','M2016RG007','M2016RG015','M2016RG014','M2016UPG017','M2016WPG001','M2016RG008','M2016WPG004','M2016WPG010','M2016WPG012','M2016HRM031','M2016WCP004','M2016HRM068','M2016HRM004','M2016WCP017','M2016DS031','M2016HRM044','M2016DM030','M2016CF006','M2016HRM053','M2016DM022','M2016RG017','M2016CODP010','M2016DSA024','M2016SE005','M2016CJ012','M2016DTA021','M2016HRM056','M2016HRM026','M2016WCP003','M2016CF024','M2016PH011','M2016CJ023','M2016HRM059','M2016DS037','M2016DS041','M2016APCP008','M2016WCP018','M2016WS020','M2016DS017','M2016APCLP002','M2016WCP014','M2016DTA002','M2016WPG005','M2016CF002','M2016HRM045','M2016SE030','M2016DM024','M2016HRM057','M2016DSA006','M2016MLIS002','M2016CF021','M2016CCSS010','M2016DSA015','M2016CJ019','M2016MLIS012','M2016MH006','M2016APCLP005','M2016APCP006','M2016UPG018','M2016APCP018','M2016WPG007','M2016CODP021','M2016GL005','M2016PH002','M2016WCP007','M2016HRM020','M2016DM014','M2016LE008','M2016DS011','M2016APCP001','M2016DM020','M2016RG002','M2016CJ017','M2016DM009','M2016CCSS012','M2016HRM013','M2016APCP017','M2016MC026','M2016CODP001','M2016UPG006','M2016HRM019','M2016LE025','M2016GL012','M2016HRM025','G2016SSA004','M2016DTA013','M2016CODP015','M2016APCP013','M2016DTA015','M2016MH008','M2016APCP005','M2016APCP028','M2016MC021','M2016DM034','M2016DS044','M2016DS025','M2016DM028','M2016WCP016','M2016DS027','M2016PHHP012','M2016PH008','M2016WCP006','M2016DSA018','M2016DM006','M2016HO045','M2016HO040','M2016MC013','M2016SE006','M2016LE006','T2016BASW028','M2016DM005','M2016RG006','M2016DS002','M2016CODP012','M2016CODP016','M2016APCLP009','M2016DM037','M2016HRM064','M2016CODP033','M2016HRM030','M2016WPG008','M2016DM031','M2016CJ024','M2016GL017','M2016CF013','M2016WS029','M2016WS009','M2016WS009','M2016LE012','M2016CODP009','M2016PH016','M2016WS017','M2016DTA023','M2016DM012','M2016SE024','M2016APCLP003','M2016APCLP019','M2016APCP022','M2016CF023','M2016DS047','M2016MLIS006','M2016CODP006','M2016DS016','M2016CJ025','M2016APCP023','M2016CJ009','M2016SE023','M2016DTA020','M2016MC006','M2016CJ021','M2016LE013','M2016HRM011','M2016LE029','M2016MH013','M2016APCP025','M2016DS034','M2016DS030','M2016HRM035','M2016DM036','M2016WCP012','M2016CCSS003','M2016DSA012','M2016MLIS011','M2016HRM032','M2016CF028','M2016DS046','M2016PH006','M2016APCLP008','M2016DSA025','M2016DS001','M2016CJ022','M2016HRM055','M2016DTA012','M2016MLIS008','M2016APCLP016','M2016APCLP006','M2016MLIS010','M2016HRM021','M2016DM027','M2016CODP028','M2016DM001','M2016DS045','M2016MH018','M2016UPG016','M2016WCP009','M2016DM016','M2016WPG009','M2016WPG015','M2016WPG003','M2016DTA025','M2016HRM066','M2016DS019','M2016DM008','M2016HRM046','M2016GL010','M2016SE022','M2016CJ002','M2016DSA013','M2016HRM052','M2016APCP015','M2016CJ006','M2016CF032','M2016RG019','M2016WS015','M2016WS024','M2016CJ010','M2016HRM063','M2016DS003','M2016DM007','M2016DS010','M2016HRM065','M2016CF018','M2016LE023','M2016DS035','M2016CJ015','M2016HRM027','M2016DS024','M2016HRM034','M2016HRM008','M2016MH022','M2016SE001','M2016SE019','M2016APCLP023','M2016WS026','M2016DM042','M2016SE015','M2016PH021','M2016APCP024','M2016WS007','M2016PH003','M2016DTA010','M2016CJ001','M2016WS027','M2016CODP014','M2016CCSS002','M2016SE002','M2016CJ013','M2016LE009','M2016WPG013','M2016HRM003','M2016CF001','M2016APCP002','M2016DSA002','M2016MH015','M2016DTA007','M2016HRM018','M2016CCSS005','M2016DTA024','M2016DSA023','M2016SE026','M2016LE024','M2016DSA001','M2016CODP002','M2016WCP001','M2016CF025','M2016SE025','M2016MLIS005','M2016MH005','M2016HRM048','M2016WS013','M2016GL023','M2016DS009','M2016MH011','M2016SE014','M2016APCP003','M2016LE020','M2016DS013','M2016DM017','M2016DM039','M2016CCSS015','M2016MH014','M2016UPG008','M2016DSA009','M2016LE022','M2016DS042','M2016LE021','M2016HRM007','M2016DTA005','M2016WS028','M2015MH023','M2015MH005','T2016RD016','T2016RD004','T2016RD005','T2016RD007','T2016RD008','T2016RD012','T2016RD018','T2016RD026','T2016RD028','T2016RD029','T2016RD033','T2016RD035','T2016SLNG016','M2016MC004','M2016MC005','M2016MC008','M2016MC012','M2016MC014','M2016MC015','M2016MC019','M2014WCP014','M2016MC002','M2016WCP005','H2016RDGM030','M2016DS033','H2016BAMA031')


-------------------------------------------PSYCHOMETRIC DB-----------------------------------------------------

--psychometric db can be deleted list
select student_registration_no,student_fname,student_mname,student_lname,student_prog_id,programme_name,student_batch,student_email_id,student_test_status,student_mobile_no from psychometric_app_mst_student 
inner join psychometric_app_mst_programme on programme_id=student_prog_id
where student_test_status='Pending' and 
student_campus_id =1 and student_batch like'2017%' and student_email_id not in ('ravikumaraish@gmail.com','anupamarjm@gmail.com','soulfriends92@gmail.com','christiana94stephen@gmail.com','diana.lizabeth.thomas@gmail.com','dsouza_elivia@yahoo.co.in','gracelorung96@gmail.com','hppatange@gmail.com','joshinag2@gmail.com','justey.shepherdslamp@gmail.com','ksbhovate@gmail.com','manikakhandelwal28@gmail.com','jagtapmayuresh46@gmail.com','meghalijoshi@yahoo.co.in','merinann95@gmail.com','pkumari7696@gmail.com','pujaroy198@yahoo.in','reethuphilomina@gmail.com','rodyzls@yahoo.co.in','shivangigoenka@gmail.com','shruti.shende4291@gmail.com','shruti941493@gmail.com','shubhi.takkar95@gmail.com','siyaravi117@gmail.com','kalia.renu@gmail.com','jubinamalik@gmail.com','tulikajoshi1993@gmail.com','vishnu071094@gmail.com','ananyazutshi29@gmail.com','manjarysmjs@gmail.com','sansammohite@gmail.com','abansal123423@gmail.com','aamirlay@gmail.com','ahmed.pathan95@gmail.com','anita.sohtun@gmail.com','varalika.mahar23@gmail.com','ashrafsaif09@gmail.com','cathleen.sami@gmail.com','diwakarkingpin01@gmail.com','harshal.maniyar@gmail.com','saeebamu@gmail.com','kausumi.saha@gmail.com','nayanika.singhal@gmail.com','preetisinghkv@gmail.com','pradeep.kamble1992@gmail.com','rahishk903@gmail.com','rajendra.7004@gmail.com','shabeeba.ltr@gmail.com','shalabhdgarhwal@gmail.com','puri.vangi1996@gmail.com','sharmashruti857.ss@gmail.com','sunaina_idmos@yahoo.com','anya.deka@outlook.com','shyamalan.rocks@gmail.com','oindrila.14@stu.aud.ac.in','santoshramchiary8213@gmail.com','lakshana6372@gmail.com','sushrijasakshiupadhyaya@gmail.com','theresautecht@web.de','abhilashdurugkar13@gmail.com','adeeteechordia@gmail.com','aditirai0207@gmail.com','anuja.sirohi@gmail.com','azamansari318@gmail.com','bhupendraspa@gmail.com','deeptisingnarpi12@gmail.com','deeptimarydmm@gmail.com','yadav.gargi08@gmail.com','harirasiet@gmail.com','ravi.mindindia@gmail.com','kavyarao7223@gmail.com','bhartiya.rail@yahoo.in','paulsfernandes@gmail.com','dahanwalraj252@gmail.com','prasu2929@gmail.com','shreya.jakhmola@gmail.com','siddhi.more16@gmail.com','jose18sonia@gmail.com','suryaandkarthi@gmail.com','tapojaymukherjee@gmail.com','paultom615@gmail.com','vikassst5726@gmail.com','vishnupriya123m@gmail.com','zabizoha0@gmail.com','manashmanjil@gmail.com','muhammednidhal9@gmail.com','bhokregajendrakumar@gmail.com','prakash_bsingh@yahoo.co.in','meerarajukumar@gmail.com','rajat06malik@gmail.com','a.kale97.ak@gmail.com','jnbagda007@gmail.com','XUEMENGZHANGE@HOTMAIL.COM','nicolle93@gmail.com','a.a.shekapure@gmail.com','amikakwar@gmail.com','ashwini93jadhavtiss@gmail.com','mnkhurana22@gmail.com','chonzombhutia07@gmail.com','eeshwarna107@gmail.com','ervin4tariang@gmail.com','huafrid.billimoria@gmail.com','ishi_8s@yahoo.co.in','delima_julia@outlook.com','yuvi.mg008@gmail.com','nadeerpayyoli@gmail.com','navjit143.spa@gmail.com','prasadwagh20@gmail.com','r.r.thakur89@gmail.com','riddhimehtaritz@gmail.com','shalini12janbisht12@gmail.com','shrutirose95@gmail.com','shubhankar_apte@rediffmail.com','shweta.gondalia94@gmail.com','bhattacharjee90@gmail.com','vaibhavkolhe398@gmail.com','vishwamaheshwari739@yahoo.com','aartiparcha999@gmail.com','b.jadav00@gmail.com','19dahliaraha94@gmail.com','savir.sequeira@gmail.com','juhig93@gmail.com','raiana.rai161@gmail.com','arkja.happiness@gmail.com','bhuvana.official.contact@gmail.com','daisykujurofficial@gmail.com','gssolankee@gmail.com','mithraprathapan@gmail.com','mdamirziya192@gmail.com','nabeela.n.rizvi@gmail.com','neeraj2meg@gmail.com','virendrasarswat100@gmail.com','gaikwadram19@gmail.com','smakadiya00@gmail.com','kodanesharad93@gmail.com','realsubra@gmail.com','sulbhaz66@gmail.com','vijendrabauddh08@gmail.com','vinithjoshua@gmail.com','vinoboshohe@gmail.com','akshaymere7@gmail.com','sohlaanviti95@gmail.com','asmitarmgudadhe@gmail.com','sean.chakma@gmail.com','pagagh5@gmail.com','nitinpagare9305@gmail.com','bhamasurya@gmail.com','ubw.tiss@gmail.com','lopezvvn@gmail.com','ramtekekunal91@gmail.com','mrudhugandhagaikwad@gmail.com','shrishti.mishrasm1@gmail.com','sweetkaira11@yahoo.com','vagmita81@hotmail.com','nibiatracy@gmail.com','nivisocio@gmail.com','pragya12mahajan@yahoo.co.in','mittalpravisha@gmail.com','scripta1295@gmail.com','rads.sharma06@gmail.com','rhea.g.banerjee@gmail.com','singhria723@gmail.com','rishitarheabarman@gmail.com','riyagpt73@gmail.com','suhail.iitb@gmail.com','shwetag1417@gmail.com','tabishraza2007@gmail.com','vaishali.pandey2015@teachforindia.org','qadirfarooqui23@gmail.com','irazadanish@gmail.com','nirajsingh11@gmail.com','ambuj0891@gmail.com','rajibdebangshisw@gmail.com','srivastava.ayushi95@gmail.com','dhanu.wan2411@gmail.com','iravatikamat@gmail.com','isha.lohumi@gmail.com','kaizeen.confectioner@gmail.com','rpchhakchhuak@gmail.com','boscomaryreena@gmail.com','mayurkumarkuduple@gmail.com','sangwan.meghna05@gmail.com','muktamohite201716@yahoo.com','nikitagagneja1992@gmail.com','nishthagupta1996@gmail.com','rajeswarirahul6@gmail.com','guptasammu@gmail.com','safwar26@gmail.com','sam.sea.sky@gmail.com','gargisnehal@gmail.com','sensreyoshi20@gmail.com','aomitito@gmail.com','saabbabu96@gmail.com','chaturvedi.varun89@gmail.com','shikhazp@gmail.com','fabien.major011@gmail.com','fasalurahmantsy@gmail.com','gomathymanjula@gmail.com','harshadaohol@gmail.com','himansu.190@rediffmail.com','kanikacts@gmail.com','iamkaransarin@gmail.com','sidheart26@live.com','avna8c@rediffmail.com','nikhilajandhyala@gmail.com','parvathivrv1295@gmail.com','pratikshakalpraj@gmail.com','jhapurvash3@gmail.com','rahulpokharikar@gmail.com','rajnish1765@gmail.com','riyachaudhary888@gmail.com','sabana.b@gmail.com','sayyed.manzer@gmail.com','shyambahadur00@gmail.com','somnathdadas123@gmail.com','vibhutikumarrai@gmail.com','victoriavairung526@gmail.com','akashpatil3221@gmail.com','p.saroha@gmail.com','anushkumar49@gmail.com','nadeemkhan.kdl@gmail.com','priyankatotre111@gmail.com','narzarirose@gmail.com','sumanoraon06@gmail.com','acorregor@unal.edu.co','anjaanceobeethovan@gmail.com','arjitamital23@gmail.com','asmitajadhav101@gmail.com','mendiratta.drishti@gmail.com','harshalinagrale21@gmail.com','harshita.binay@gmail.com','vaishnavik896@gmail.com','kajaltiwari.kt08@gmail.com','mrittikab129@gmail.com','nats18natasha@gmail.com','p.bansodtiss@gmail.com','ronica06@gmail.com','bharumak@yahoo.co.in','savitatyagi22@gmail.com','simranksms@gmail.com','snithansmo@gmail.com','rupshasdb@gmail.com','suveeravenkatesh@gmail.com','vidyawakchaurevrw@gmail.com','lerinavikuono@gmail.com','aayushirathi13@gmail.com','adiscary@gmail.com','aishwaryashekhar1@outlook.com','akanksha.384.sharma@gmail.com','chauhan.akshay912@gmail.com','mailorg11@gmail.com','aparnawanchoo24@gmail.com','appyadda@gmail.com','arnaz14@gmail.com','asna.anjoom@gmail.com','astha2725@gmail.com','uniqueavinav@gmail.com','ayush.khazanchi@gmail.com','dcsudha@outlook.com','cy5832@gmail.com','jaiswaldeepakkumarjd@gmail.com','crazywordpress17@gmail.com','harshitloya@gmail.com','kjain46@gmail.com','manishhappy08.mj@gmail.com','manishlikethis@gmail.com','maushamsastra@gmail.com','zucky.mohd@gmail.com','muskaanananth@gmail.com','olimitaroy7@gmail.com','pbasu5@gmail.com','hhssrs.prashaant@gmail.com','pratiksharustagi@gmail.com','praveen1336@gmail.com','raman2490@gmail.com','akshay090194@gmail.com','sabit6229@gmail.com','blessedsakshi@gmail.com','saaranyah@gmail.com','dutta.satyaki@gmail.com','saurabh.bitsg@gmail.com','shama.chalke@gmail.com','smairal@gmail.com','shouryashivam@gmail.com','shreyaahuja30@gmail.com','simran.sultania5@gmail.com','subhasisforv@gmail.com','sunilpal780@gmail.com','tejveerbakshi28@gmail.com','kaul05tushar@gmail.com','soni93tushar@gmail.com','vaibhav.js.pandey@gmail.com','vibhuti.raina@yahoo.com','akikhade@gmail.com','ami.ukey@gmail.com','i_would_reign_one_day@yahoo.com','jayasreedevadatham@gmail.com','kunalsingh89@gmail.com','monica.yashleen@gmail.com','nkbodele@gmail.com','saileshpal10101968@gmail.com','shephalikullu29@gmail.com','pawale.tanmay@gmail.com','vivekrajranjan@gmail.com','asha2607@gmail.com','bneraj@gmail.com','parthkhare15@gmail.com','shaivalchatwani026@gmail.com','siddharthanrs@gmail.com','manojktiwari92@gmail.com','praj93042@gmail.com','swadhinjamkar@gmail.com','rohina.zaffri@gmail.com','anshul.vimal10@gmail.com','narzaribigrai@gmail.com','dishapande015@gmail.com','diskityoudol1234@gmail.com','thangjam.jimmy@hotmail.com','rajorakajal31@gmail.com','monukumarmehra1993@gmail.com','raman.rkm.nit@gmail.com','prakasanshilpa1994@gmail.com','swaraj.thakare@gmail.com','amitbhaskar2612@gmail.com','kriti1098@gmail.com','mohitt.garg@gmail.com','nikita.kaliravana@gmail.com','priyanka.s1931@gmail.com','r.3311ranjan@gmail.com','sanjay.kumar929@gmail.com','sapnakarambhe335@gmail.com','stutichakraborty@gmail.com','vishakhayadav222@yahoo.com','gaurav.mahto@cuj.ac.in','nikhiludaya325@gmail.com','phuhaar@gmail.com','rohan.keshewar84@gmail.com','leishithingmahung@gmail.com','shraddha.kalani@gmail.com','xoxo.omgg@icloud.com','mayursoni08@gmail.com','mrtnjy01@gmail.com','silsarma.souvik@gmail.com','swarnavasb@gmail.com','amantushar2015@gmail.com','jaya.sharma429@gmail.com','raaz.hansdah@gmail.com','sanjay94civil@gmail.com','ankitrai.c2i@gmail.com','nknikhil87@gmail.com','singh.rashi96@yahoo.com','sabhyakumar@gmail.com','subhomaysaha@yahoo.in','','','mayanakajima@gmail.com','abhiyanta@gmail.com','baisaneamruta08@gmail.com','27amruthas11@gmail.com','anupama064.ar@gmail.com','ashishlwh@gmail.com','drasmitapillewan777@gmail.com','chris.susan20@gmail.com','dr.dnyaneshee.dudhal@gmail.com','rajegourip@gmail.com','kubavatharsh@gmail.com','chandel.khushboo@gmail.com','manasi.mk2005@gmail.com','mayanksakhuja6794@yahoo.in','mddanishbhai@gmail.com','dr.anilkumarmola@gmail.com','nadeemshaikh1806@gmail.com','yadavneer21@gmail.com','drnehapurohit1389@gmail.com','fbi.dr.nik99@gmail.com','pankaj.tangade2015@gmail.com','pkj3003@hotmail.com','remruatirenthlei11@gmail.com','dr.rahulrabhadiya07@gmail.com','ravikarsingh8@gmail.com','vohra_ridhima@yahoo.com','saba.naaz.78678@gmail.com','nerurkarsayali@gmail.com','seeratchauhan6@gmail.com','behl.shilpa@yahoo.com','shreyagaik@gmail.com','suneetrokx99@gmail.com','utsavsingh14@gmail.com','akanksha24pal@gmail.com','bhaweshk118@gmail.com','chandu.aarya@gmail.com','reshmakaur0013@gmail.com','naqeeb_afghan1@yahoo.com','akankshasingh_31@hotmail.com','vaidyaalok@gmail.com','aabhikane@gmail.com','aneeshachauhan@gmail.com','anishkumar2350@gmail.com','jain0208@gmail.com','archana.koul24@gmail.com','auraa2013@gmail.com','am.ashimamohan@gmail.com','bhargavrajput@gmail.com','mahajandeepika10@gmail.com','vamsimuzic@gmail.com','karankhetwani@gmail.com','khyatipatel.05.07@gmail.com','krunal.otist@gmail.com','medonica29@gmail.com','armaisha27@gmail.com','msarkar80@gmail.com','monica.nupur@gmail.com','nithyasai450@gmail.com','somkar33@gmail.com','pdbuva@gmail.com','pittu_862000@yahoo.co.in','pritikori29@gmail.com','priyankaborgaonkar07@gmail.com','b.ramya.ranjith@gmail.com','rj07031989@gmail.com','rapk1962@yahoo.com','rupaljadhao26@gmail.com','sal.150593@gmail.com','papanasambala@gmail.com','saheer65@gmail.com','shwetakamble2988@yahoo.com','kunzangaki27@gmail.com','sravyaangara999@gmail.com','subhajitroy6@gmail.com','varnika.r88@gmail.com','nairv982@gmail.com','rxwahidaxr27@gmail.com','zsg0625@gmail.com','aditi.kuchekar18@gmail.com','marwah.kash93@yahoo.com','mishra.kritika95@gmail.com','meenakshipunde9@gmail.com','nirmalendujena@gmail.com','priyankawaghela11@gmail.com','shivanand.bhande244@gmail.com','sudiptochattopadhyay199@gmail.com','vidyesh.1411@gmail.com','dr.abhishekgandhi@outlook.com','aaykayofficial@gmail.com','shukla.anupam90@gmail.com','anusha.puru@gmail.com','charan.g.tej@gmail.com','dr.dps.physio@gmail.com','chandroniv@gmail.com','piyush6588@gmail.com','massagaya3@gmail.com','jagrutihankare@gmail.com','dr.kirtisaharan@gmail.com','aabha.pawar6186@gmail.com','nikitaganpule@gmail.com','pushkarsinghmehra7@gmail.com','rachanaingle84@gmail.com','draryanrajneesh@gmail.com','sreekanth.k2015@teachforindia.org','sriramswamy91@yahoo.com','tanvishah813@gmail.com','uwais143@gmail.com','yashodharasetu@gmail.com','cpkosa.w@gmail.com','mangalyadav66@gmail.com','singhnarotam45@gmail.com','sowmya.garigipati@gmail.com','dr.patil9321@gmail.com','nileshpgawande11@gmail.com','sunita_kalita@rediffmail.com','Zaki.molakhail25@gmail.com','abheet_sharma@yahoo.co.in','dr.apurvakohli@gmail.com','babajisatguru25@gmail.com','c_sekhardr@yahoo.co.in','vaseemc97@gmail.com','parmarhardik99@yahoo.co.in','gedam.mayuri@gmail.com','minalg277@gmail.com','nondiyachb@gmail.com','pratik.more90@yahoo.com','rajb315@yahoo.co.in','rks1261@gmail.com','sagarpsinha@gmail.com','shahidaliwarsi001@gmail.com','drshaiknishan@gmail.com','ateychongthu@gmail.com','pavankumarjerpula78@gmail.com','siddeshshetty2016@yahoo.com','mind.ravi@gmail.com','apurvapawar268@gmail.com','khyati.sakhla@gmail.com','aishlonkar04@gmail.com','ankur102@gmail.com','anushree.gupta93@gmail.com','binayak003@gmail.com','chojomlama6@gmail.com','drishtiii.rastogi@gmail.com','eshan.fotedar@gmail.com','peer.karan@gmail.com','madhavtipu96@gmail.com','mohityprakash@gmail.com','beckmonish@gmail.com','ktata40560@gmail.com','spragyasolanki@gmail.com','prashanthrc627@gmail.com','dua_priya@hotmail.com','rahulsivanunni@gmail.com','ratish.61@gmail.com','riddhimodi54@gmail.com','rohinimitra1@gmail.com','kakadesaket@gmail.com','ganeshsambhavi@gmail.com','shriyathakur1896@gmail.com','mailtosiddharth.13@gmail.com','pratikkamble320@gmail.com','sujasukesan@gmail.com','svd.exams@gmail.com','madhubrsetju@gmail.com','vaibhavmeshram25@rediffmail.com','ajit.yadavindu8@gmail.com','ashharmonz@gmail.com','ashishkamra1991@gmail.com','debadrita.gupta.96@gmail.com','gladysbaite0@gmail.com','harshajith.sh@gmail.com','karishma7151@gmail.com','v.nirupama94@gmail.com','priyadarshini1634@gmail.com','bewithsameer@gmail.com','sarthaknayak12@gmail.com','shivani71196@gmail.com','shourya.singhpatel17@gmail.com','titheeg@gmail.com','akshayraonirmal@gmail.com','aparnakareepadath@gmail.com','chester.plunk@gmail.com','yaminilahare@gmail.com','deepak789.dr@gmail.com','Mike.nganjone@standardbank.com.na','aasthakumarr@gmail.com','abhilashdhabe@gmail.com','alphatoppo@yahoo.com','amita.cbaraik93@gmail.com','anantika.official@gmail.com','anjalihans95@gmail.com','aradhana.d.verma@gmail.com','dkhandagale1995@gmail.com','kanchanborkar46@gmail.com','komalmangar10@gmail.com','krantijamankar@gmail.com','madhusreemuggle@gmail.com','roypragya35@gmail.com','preetijangra710@gmail.com','prernamishra03@yahoo.co.in','phore8110@gmail.com','radhika.radhakrishnan5@gmail.com','shilanjani@gmail.com','vanita.ganesh95@gmail.com','chauhananjali1811@gmail.com','shivanigujar96@gmail.com','trisharai1310@gmail.com','shitaltatad@yahoo.com','utpal_gore@hotmail.com','adityaminocha1987@gmail.com','pamit959@gmail.com','anirudh.agarwal@akanksha.org','anshika3112@gmail.com','athunoli@gmail.com','asmitasaini95@gmail.com','chetan.kamble9730@gmail.com','darylchingsankim@gmail.com','writetoheena@gmail.com','rev.sunilkale@gmail.com','isha95joshi@gmail.com','karishmamodi600@hotmail.com','khagesh34@gmail.com','khushbugajakas@gmail.com','arunachal.ed@gmail.com','sorenlakhindar@gmail.com','nmeher121@gmail.com','neha.khemraj@gmail.com','pabitrasaha1992@gmail.com','rt021tiwar@gmail.com','rishi_mazumdar@hotmail.com','roshanrgajbhiye@gmail.com','ruhanibhatia@gmail.com','ruhimarne@gmail.com','rythem.vohra.50@gmail.com','sandeep.wade678@gmail.com','shaily.bhadauria@yahoo.com','shaliniwankhade03@gmail.com','gawarleshravani@gmail.com','suja.swaminathan@gmail.com','surekha.wag@gmail.com','tanusweet.tr@gmail.com','tushanka@gmail.com','bhoomidua@gmail.com','varshamali524@gmail.com','anasraheem830@yahoo.in','anubpaljor@gmail.com','d.singh848@gmail.com','haritha.songola@gmail.com','jyotiraowankhede@gmail.com','manahisaac1@gmail.com','parjanyajoshi92@gmail.com','pranita.kumari432@gmail.com','rishabhjha7@gmail.com','ividyashankar@gmail.com','ruchibhadke@gmail.com','sanchitadhas.iitb@gmail.com','pawarsayali60@gmail.com','shubhangi.9627@gmail.com','infinitedimensions1981@gmail.com','bewithankit@hotmail.com','ankitpalfc@gmail.com','poonamshah5@yahoo.com','shria.goel@gmail.com','soulcandour@gmail.com','DEMEUOVAKUNSULU@GMAIL.COM','abhay.vashisht@icloud.com','aishwarya_jayan@hotmail.com','akashtiwarianshuman@gmail.com','in.jyotijain@gmail.com','mediawatchmedia@gmail.com','guevaradushyant@gmail.com','garima.397@gmail.com','harikrishnadv95@gmail.com','julius.jolen@hotmail.com','jusaman534@yahoo.com','madhurima14011995@rediffmail.com','mehakbaveja@gmail.com','bragysingh@gmail.com','pradnyahpawaskar@gmail.com','premjikottar@gmail.com','priyankatajane09@gmail.com','priyanka.priyadarshini23@gmail.com','rhythmmathur19@gmail.com','sachinranvir31@rediffmail.com','sagark111091@gmail.com','lohranichakhrasi@gmail.com','saranprakashd@gmail.com','bhardwaj.shweta14@gmail.com','warbhuvans60@gmail.com','himachembiosis@gmail.com','singhsoumyakant@gmail.com','vijendra.sambhalwar@rediffmail.com','lakshmibss10@gmail.com','mahesh8796901967@gmail.com','priyanshtiwari9@gmail.com','rashikasaini09@gmail.com','soumya.mantur@gmail.com','thingujamsatish2884@gmail.com','vishvmo01@gmail.com','kaur.baljeet2195@yahoo.com','himanshujoon2015@gmail.com','ipsit13@gmail.com','santuraj9860@gmail.com','taniya.bhattuki@gmail.com','vandna.stuv@gmail.com','vaishnavikapoor5@gmail.com','','aditikelshekar@gmail.com','inamdar.ajinkya87@gmail.com','arunavchowdhury@rocketmail.com','chandrima.dona@gmail.com','divya.bhartiya@yahoo.in','kunal.chaturvedi96@gmail.com','najwa.ka@gmail.com','neelmishra@gmail.com','prachi12mahajan@yahoo.co.in','spspatranabis@gmail.com','tikshasankhe16@gmail.com','tusharanand1594@gmail.com','abhishekanil.aa@gmail.com','annabrittas@gmail.com','bellesaritha999@gmail.com','suvedh@gmail.com','abdulkadirsz100@gmail.com','anushri.094@gmail.com','bistirambasu@gmail.com','nataliachakma@gmail.com','Valentina@espaciovacio.net','adityarev9@gmail.com','advaiyc@yahoo.com','kujurakshay98@gmail.com','apurvachavan1495@gmail.com','arujapandey@gmail.com','saxenapsd@gmail.com','isido92@yahoo.in','joanshilpakiran@gmail.com','skgautam.tisshyd@gmail.com','dungdungmanish@gmail.com','ramsskedar247982@gmail.com','saurabhsmn8@gmail.com','shruthiraoy@gmail.com','akshitabansal31@gmail.com','singh.ila25@gmail.com','mail.manasvini@gmail.com','meraghavkumar@gmail.com','sahiltamrakar@yahoo.in','sarthakshukla311@gmail.com','trinayani95@gmail.com','yuvrajsingh26788@gmail.com','devashree.ragde@gmail.com','badaps27@gmail.com','sanketwairagade5@gmail.com','shubhamdahare@yahoo.com','vaishalikashyap16@gmail.com','zinnia.ju14@gmail.com','talkwithmithun@gmail.com','pranavpats@yahoo.in','pritfulzele@gmail.com','riteshcr09@gmail.com','llunayoung@gmail.com','salmanzaheer244@gmail.com','sumbresimran@gmail.com','rahulraja_93@yahoo.co.in','ashoktmd@gmail.com','aditimehra1896@gmail.com','aishwaryac30@gmail.com','anushkachoudhary712@gmail.com','bhaktisdghatole@gmail.com','devaa0601@gmail.com','dinsung1691@gmail.com','hennazyadu12@gmail.com','imalaviya@gmail.com','misra.isha@gmail.com','jasminesk1995@gmail.com','mathur.mitali11@gmail.com','official.pooja15@gmail.com','arpita.sethi@yahoo.com','sanjanaqms@gmail.com','sj98692@gmail.com','shrinidhi.deshmukh@gmail.com','snehals2710@gmail.com','suhasini.raina@gmail.com','swati23.agarwal@gmail.com','vaishnavi.pal14@gmail.com','pantvibhuti@gmail.com','leharmalhotra5@gmail.com','samreenmaariyah.sheikh@gmail.com','srishtij1996@gmail.com','dhwani.vohra@gmail.com','sandymammy1111@gmail.com','bansodepradnya1@gmail.com','Khalidahmo@yahoo.com','shraddha_dongal@hotmail.com','bhupindersinghbakshi@gmail.com','aanchal999971@gmail.com','agarwala.adi1994@gmail.com','k.ananta16@gmail.com','chikkumpeters@gmail.com','easwaran.deepika@gmail.com','kanak.kats@gmail.com','mokshamiskeen@gmail.com','nehabanik6@gmail.com','pmishra0796@gmail.com','pranesh90@ymail.com','sklokhande25@gmail.com','saniyasidhu12@gmail.com','sanjana220596@gmail.com','sanjana.mishra96@gmail.com','saraholmes16@gmail.com','heen96an@gmail.com','shivaniyd20@gmail.com','soumya.jagatdeb@gmail.com','stanzind21@gmail.com','suvrita24@gmail.com','tanisha.v286@gmail.com','poojadhepe1705@gmail.com','priyaahluwalia96@gmail.com','Snehatatapudy@gmail.com','GSWCHIA@GMAIL.COM','meera96@gmail.com','bunty.sable@gmail.com','aishwarya.vasudev07@gmail.com','chinar.dac@gmail.com','urbi0211@gmail.com','hari.hkrishnan@gmail.com','jyotinisha13@gmail.com','kavyachandel96@gmail.com','maitriya.m614@gmail.com','meghna12310@gmail.com','eternaldenitecrice@gmail.com','megh.splendour@gmail.com','pallavikhare123@gmail.com','pragya.dhama96@gmail.com','rach.alexz@gmail.com','divyakandukuri.dk@gmail.com','subodhisagar@gmail.com','tanujasingh96@gmail.com','mayotim50@gmail.com','vivekina@gmail.com','amidalicku@gmail.com','aayushchaturvedi@gmail.com','himanshuchutiasaikia@yahoo.in','medhavi.kimothi@gmail.com','nibhanupudi.yamini@gmail.com','ankit.pareek27@yahoo.com','yaswanth2907@gmail.com','jahnavi.reddy2015@teachforindia.org','kamble.bhagwan20@gmail.com','bnarzary121@gmail.com','henrymosahary123@gmail.com','lk.asonanal@gmail.com','mureddy@yahoo.com','nabiyalmanisha@gmail.com','bilalmoinjmi@gmail.com','mridula_in123@hotmail.com','nnitishsahu@gmail.com','sagiruddinahmed18@gmail.com','tripathishivani271@gmail.com','saraswatkuldeep6@gmail.com','brahmar977@gmail.com','jasodabag9@gmail.com','achintya.arora@gmail.com','animesh_arora@yahoo.co.in','ajeyrbl@gmail.com','amitvmate@gmail.com','ananya.deuri@gmail.com','kkkaniket@yahoo.co.in','aparajitaa.datto@gmail.com','dmwadekar@gmail.com','gargi01.mishra@gmail.com','jimmyjose92@gmail.com','kritikaswami03@gmail.com','kunalenfrance@gmail.com','sahaisuli@gmail.com','advrevathyas@gmail.com','sandeep93f@gmail.com','sanyukta.biswas@gmail.com','sarojnujs@gmail.com','siddharthseem@hotmail.com','sreedharkusuman@gmail.com','s.makhnotra@gmail.com','vartikaanand3@gmail.com','vasudham11@gmail.com','vikaskumar968@gmail.com','ysraraafatysr@gmail.com','akanksha.0894@gmail.com','editor.saad@outlook.com','tanvi_goyal@hotmail.com','shashwatidiksha@gmail.com','agni.shayer@gmail.com','de369@yahoo.com','vinodshree3333@gmail.com','jafreen.hussain@gmail.com','surajtelange99@gmail.com','noorameenanoor@gmail.com','arushikothari@gmail.com','saha.meheli.14@gmail.com','dongrejayashree@gmail.com','samuelgangtekahi@gmail.com','richusanil99@gmail.com','vermaaprajita03@gmail.com','nithisha.chaviti@gmail.com','mukherjeesampriti@gmail.com','dvkindo@gmail.com','tanu.singh247@gmail.com','mudgalakansha12@gmail.com','submitted1711@gmail.com','sristi.barman22@gmail.com','uditthemidas@gmail.com','sanjna.achayya@gmail.com','radhika-khanna@hotmail.com','sweta.k.gaur@gmail.com','narzary27bidintha@gmail.com','prithu003@gmail.com','veerdraveen@gmail.com','dongrejayashree@gmail.com') and student_deleted='N'

-----************ added anands.kishore@gmail.com and deleted above details ****************
update exams_mst_students set stud_sem_id=2 where stud_id in(select stud_id from exams_mst_students where stud_prog_id=96 
and stud_enrollment_number in ('2016EPGDHA002','2016EPGDHA003','2016EPGDHA004','2016EPGDHA008','2016EPGDHA009','2016EPGDHA010','2016EPGDHA011','2016EPGDHA012','2016EPGDHA013','2016EPGDHA014','2016EPGDHA015','2016EPGDHA016','2016EPGDHA017','2016EPGDHA018','2016EPGDHA019','2016EPGDHA020','2016EPGDHA021','2016EPGDHA022','2016EPGDHA024','2016EPGDHA025','2016EPGDHA027','2016EPGDHA028','2016EPGDHA029','2016EPGDHA030','2016EPGDHA031','2016EPGDHA032','2016EPGDHA033','2016EPGDHA034','2016EPGDHA035','2016EPGDHA036','2016EPGDHA037','2016EPGDHA038','2014EPGDHA014','2015EPGDHA024','2013EPGDHA002','2015EPGDHA009','2015EPGDHA015','2015EPGDHA021')
 order by stud_enrollment_number)

--dt: 02/08/2017

select rscs_stu_id,stud_enrollment_number,stud_fname,stud_lname,prog_name,cour_name, cprs_cpse_id,cprs_room_id,cprs_roombook_fromdate,
cprs_fromtime,cprs_totime,cprs_roombook_todate,cprs_fixed_classes,punch_date,punch_time
from studattendance_rel_courses_programes_room_schedule 
inner join tcourse_evaluation_rel_stu_courses on cprs_cpse_id=rscs_cpse_id
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_courses on cpse_cour_id=cour_id
inner join exams_mst_programs on cpse_prog_id=prog_id
inner join studattendance_rel_device_room on cprs_room_id=dvrm_room_id
--and dvrm_bd_id in (select cast(bd_id as text) from studattendance_mst_biometric_device where bd_deleted='N') 
inner join studattendance_mst_biometric_device on bd_deleted='N' and regex_splitedvrm_bd_id=bd_id
inner join studattendance_mst_biometric_attendance on bd_device_no=device_number --enroll_no=stud_enrollment_number
where rscs_deleted='N' and stud_deleted='N' and stud_status='OnRole' and cpse_deleted='N' and cpse_prog_id=3 and stud_acba_id=10 and stud_campus_id=1 and cpse_seme_id=3
order by stud_enrollment_number,cour_name

select rscs_stu_id,stud_fname,stud_lname,prog_name,cour_name,cprs_cpse_id,cprs_room_id,cprs_roombook_fromdate,cprs_roombook_todate,cprs_fromtime,cprs_totime,cprs_fixed_classes 
from studattendance_rel_courses_programes_room_schedule inner join tcourse_evaluation_rel_stu_courses on rscs_cpse_id=cprs_cpse_id 
inner join exams_mst_students on stud_id=rscs_stu_id inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id 
inner join exams_mst_courses on cour_id =cpse_cour_id inner join exams_mst_programs on prog_id =cpse_prog_id where cprs_deleted ='N' 
and stud_acba_id in (21) and cpse_seme_id=1 and stud_deleted='N' and stud_status='OnRole' and stud_campus_id=1 and rscs_deleted='N' and cpse_id=4879


select distinct prog_id,prog_name from exams_rel_employees_activities_permissions
inner join exams_rel_campus_school_programes_courses on emap_rcp_id=rcp_id
inner join exams_mst_programs on rcp_prog_id=prog_id
inner join exams_mst_courses on rcp_cour_id=cour_id
where emap_empl_id in (44) and emap_deleted='N' and rcp_deleted='N' 
group by prog_id having count(prog_id)>2
order by prog_id

select exams_rel_students_courses_semesters.* from exams_rel_courses_programes_semesters 
inner join tcourse_evaluation_rel_stu_courses on rscs_cpse_id=cpse_id 
inner join exams_mst_students on rscs_stu_id=stud_id
inner join exams_rel_students_courses_semesters on rscs_cpse_id=scse_cpse_id and scse_rscs_id=rscs_id
where cpse_prog_id=96 and cpse_seme_id=2 and stud_status='OnRole' and stud_deleted='N' and cpse_deleted='N' and rscs_deleted='N' and scse_isconfirm='N'

--for STP EPGDHA issue 2nd sem s1 issue (unnecessary saved)
update exams_rel_students_courses_semesters set scse_deleted='N' where scse_id in (117015,117014,117007,117006,
117003,
117002,
116999,
116998,
116997,
116994,
116993,
116977,
116978,
116989,
116990,
116986,
116985,
116982,
116981,
117010,
117011)

--query returns databases created date
SELECT (pg_stat_file('base/'||oid ||'/PG_VERSION')).modification, datname FROM pg_database;


select punch_date,device_number,count(enroll_no) from studattendance_mst_biometric_attendance 	
group by device_number,punch_date
order by punch_date


select campus_name,prog_name,stud_enrollment_number,stud_fname,stud_lname,seme_name,acba_name,cate_name,ssr_stud_isconfirm, case -- ssr_stud_isconfirm
when ssr_stud_isconfirm ='N' then 'NO'
when ssr_stud_isconfirm = 'Y' then ''
--as "Form Submitted"
else 'NO'
END as "Student Confirmed"
,case when ssr_stud_isconfirm='N' and ssr_status='Allow Editing'
then 'Allowed Editing'
else ''
END as "Reg. Form Status" 
from exams_mst_students
inner join exams_mst_programs on stud_prog_id=prog_id
inner join exams_mst_semesters on stud_sem_id=seme_id
inner join exams_mst_campus on stud_campus_id=campus_id
inner join exams_mst_categories on stud_admission_cate_id=cate_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id
left join exams_rel_stud_sem_registration on stud_id=ssr_stu_id and ssr_deleted='N'
where stud_acba_id in (10,11,3) and stud_status='OnRole' and stud_prog_type_id in (1,2) and stud_campus_id !=5 and prog_id not in (42,17)
order by campus_name,stud_prog_id,stud_enrollment_number

select exams_mst_students.* from exams_mst_students 
inner join tcourse_evaluation_stu_hallticket on stud_id=cast(sh_stu as int)
where sh_created_datetime > '2017-08-07' and stud_status='OnRole' and stud_deleted='N' and stud_campus_id=1 order by stud_enrollment_number 

--MA 16-18 & BA 16-19 to 3rd sem
update exams_mst_students set stud_sem_id=3 where stud_id in (select stud_id from exams_mst_students where stud_deleted='N' and stud_status='OnRole' and stud_campus_id=4 and stud_acba_id in (10,11) and stud_sem_id!=3
order by stud_enrollment_number)

--BA 15-18 to 5th sem
update exams_mst_students set stud_sem_id=5 where stud_id in (select stud_id from exams_mst_students where stud_deleted='N' and stud_status='OnRole' and stud_campus_id=4 and stud_acba_id=3 --and stud_sem_id!=3
order by stud_enrollment_number)


--students enrolled in multiple courses
select campus_name,stud_enrollment_number,cour_name,seme_name,acba_name--campus_name,prog_name,cour_name, stud_enrollment_number,rscs_course_type,seme_name,acba_name
from exams_mst_students inner join tcourse_evaluation_rel_stu_courses
on rscs_stu_id=stud_id and stud_acba_id=rscs_batch_id
inner join exams_mst_courses on rscs_course_id=cour_id
inner join exams_rel_courses_programes_semesters on rscs_cpse_id=cpse_id
inner join exams_mst_programs on cpse_prog_id=prog_id
inner join exams_mst_academic_batches on stud_acba_id=acba_id 
inner join exams_mst_semesters on rscs_sem_id=seme_id
inner join exams_rel_stud_sem_registration on stud_id=ssr_stu_id
inner join exams_mst_campus on stud_campus_id=campus_id
where stud_status='OnRole' and stud_deleted='N' and rscs_deleted='N' and cpse_deleted='N' and ssr_stud_isconfirm='Y'
and ((stud_acba_id=10 and rscs_sem_id=3) or (stud_acba_id=3 and rscs_sem_id=5) or(stud_acba_id=11 and rscs_sem_id=3)) --and stud_campus_id=4
group by campus_name,stud_id,stud_enrollment_number,cour_id,cour_name,seme_name,acba_name
having count(cour_name) > 1
order by campus_name,cour_name,stud_enrollment_number


