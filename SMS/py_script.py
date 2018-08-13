import subprocess #,xlrd
import pandas as pd

df = pd.read_excel('Final_edit.xls', sheetname='Sheet1')


enrollment_nos = df['STUD_ENROLLMENT_NUMBER']

counter=1
for ind in enrollment_nos:
    print ind
    file_name=str(ind)+'.jpg'
    command='cp ../'+file_name+' .'
    print command
    subprocess.call(command,shell=True)
    counter=counter+1
print 'No. of iterations:',counter
