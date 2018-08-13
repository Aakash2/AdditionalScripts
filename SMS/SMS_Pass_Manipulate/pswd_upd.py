import re, os, sys, django,xlrd
sys.path.append('/var/Educational_Assessment/')
os.environ['DJANGO_SETTINGS_MODULE'] = 'Educational_Assessment.settings'
django.setup()

from django.contrib.auth.models import User

from datetime import datetime,date


def reset_password(rp_username,rp_password):
    userobj=User.objects.get(username=rp_username)
    print userobj.password,' ',rp_password
    userobj.set_password(rp_password)
    userobj.save()
    return 'Done'

if __name__ == "__main__":
    workbook_obj=xlrd.open_workbook('update_pswd.xls')
    sheet_obj=workbook_obj.sheet_by_name('Sheet1')

    cout=0

    for row in range(1,sheet_obj.nrows):

            #registration
            regis_newline = sheet_obj.cell(row,0).value.replace('\n','')
            regis_val= regis_newline.replace("'","''")
            regis = re.sub(' +',' ',regis_val).strip()

            #paswd_newline = sheet_obj.cell(row,1).value.replace('\n','')
            #paswd_val= paswd_newline.replace("'","''")
            #password = str(sheet_obj.cell(row,1).value) #re.sub(' +',' ',paswd_val).strip()

	    #dob= xlrd.xldate_as_tuple(sheet_obj.cell(row,1).value, workbook_obj.datemode)
            #dob = datetime(*dob)
	    password=sheet_obj.cell(row,1).value

            rdata=reset_password(regis,password)
            if rdata=='Done':
                cout=cout+1
                print 'Execution in progress..'
print 'Updated Count : ',cout




