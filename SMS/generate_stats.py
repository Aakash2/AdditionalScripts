import os


gender_dict = {}
fp = open('gender_2018.csv','r')
for i in fp.readlines():
    i = i.replace('\n','')
    i = i.split(';')
    if i[0] not in gender_dict:
        gender_dict[i[0]] = i[1]
fp.close()


basepath='2018/'
listdir = os.listdir(basepath)

print listdir

def findpos(row):
    """
    """
    for i in reversed(range(len(row))):
        if row[i] <> '':
            return i 

#cnt = 0

prog_letter_grade = {}
prog_no_of_students = {}
male_female_appeared = {}
male_female_failed = {}
male_female_sixty_percent = {}

listdir=['2018.csv']
for csvfile in listdir:
    cnt = 0
    fp = open(basepath+csvfile,'r')
    for i in fp.readlines():
        i = i.replace('\n','')
        i = i.split(';')

        pos = findpos(i)
        status = i[pos]
        letter_grade = i[pos-1]
        try:
            gpa = float(i[pos-2])
        except:
            gpa=0
        prog_name = i[0]+'_'+i[1]

        if prog_name not in prog_letter_grade:
            prog_letter_grade[prog_name]={'A+':0,'A':0,'A-':0,'B+':0,'B':0,'B-':0,'C+':0,'C':0,'F':0}
            male_female_appeared[prog_name] = {'Male':0,'Female':0}
            male_female_failed[prog_name] = {'Male':0,'Female':0}
            male_female_sixty_percent[prog_name] = {'Male':0,'Female':0}
            cnt = 1
        else:
            cnt = cnt + 1

        prog_no_of_students[prog_name] = cnt
        #print i
        try:
            gender_value = gender_dict[i[2]]
        except:
            #gender_value = 'Male'
            print i

        if status=='F' or status=='-' or status=='AB':
            letter_grade='F'
            male_female_failed[prog_name][gender_value] = male_female_failed[prog_name][gender_value] + 1 
        
        if letter_grade not in prog_letter_grade[prog_name]:
            prog_letter_grade[prog_name].update({letter_grade:1})
            male_female_appeared[prog_name][gender_value] = male_female_appeared[prog_name][gender_value] +  1 
        else:
            prog_letter_grade[prog_name][letter_grade] = prog_letter_grade[prog_name][letter_grade] + 1 
            male_female_appeared[prog_name][gender_value] = male_female_appeared[prog_name][gender_value] +  1 

        if gpa >= 6:
            male_female_sixty_percent[prog_name][gender_value] = male_female_sixty_percent[prog_name][gender_value] + 1 

    fp.close()


print prog_letter_grade
print prog_no_of_students
#print male_female_appeared
#print male_female_failed
#print male_female_sixty_percent


list_of_grades = ['A+','A','A-','B+','B','B-','C+','C','F']
fp1=open('stats1_2018.csv','a')
fp1.write('Sr. No;Campus;Programme;No. of Students;No.of students appeared for exam;No. of students passed;No. of students failed;count with A+;% with A+;count with A;% with A;count with A-;% with A-;count with B+;% with B+;count with B;% with B;count with B-;% with B-;count with C+;% with C+;count with C;% with C;count with F;% with F\n')
for prog in prog_no_of_students:
    no_of_students = prog_no_of_students[prog]
    prog_split = prog.split('_')
    campus = prog_split[0]
    programme = prog_split[1]
    filewrite_str = ';'+campus+';'+programme+';'+str(no_of_students)+';'+str(no_of_students)+';;'+str(prog_letter_grade[prog]['F'])

    for grade in list_of_grades:
        filewrite_str = filewrite_str + ';' + str(prog_letter_grade[prog][grade]) + ';' + str(round(prog_letter_grade[prog][grade]/float(no_of_students)*100)) 
    filewrite_str = filewrite_str + '\n' 
    fp1.write(filewrite_str)

fp1.close()



fp2 = open('stats2_2018.csv','a')
fp2.write('Sr. No;Campus;Programme;No. of Boys appeared;No.of girls appeared;Total appeared;No. of boys failed;No of girls failed;Total failed;No.of boys scoring 60%;No. of girls scoring 60%;Total scoring 60%\n')
for prog in prog_no_of_students:
    prog_split = prog.split('_')
    campus = prog_split[0]
    programme = prog_split[1]
    filewrite_str = ';'+campus+';'+programme+';'+str(male_female_appeared[prog]['Male'])+';'+str(male_female_appeared[prog]['Female'])+';'+str(male_female_appeared[prog]['Male']+male_female_appeared[prog]['Female'])+';'+str(male_female_failed[prog]['Male'])+';'+str(male_female_failed[prog]['Female'])+';'+str(male_female_failed[prog]['Male']+male_female_failed[prog]['Female'])+';'+str(male_female_sixty_percent[prog]['Male'])+';'+str(male_female_sixty_percent[prog]['Female'])+';'+str(male_female_sixty_percent[prog]['Male']+male_female_sixty_percent[prog]['Female'])+'\n'
    fp2.write(filewrite_str)
fp2.close()    


# grade_list = ['A+','A','A-','B+','B','B-','C+','C','F']

# fp1 = open('stats1.csv','a'):
# for j in prog_letter_grade:
#     print prog_no_of_students
