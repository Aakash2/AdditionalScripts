import xlrd
import psycopg2

# open the workbook and defining the sheet
aa= 'January/11_01_2016/excel2file.xls'
workbook_obj=xlrd.open_workbook(aa) ###errors
sheet_obj=workbook_obj.sheet_by_name('Sheet1')# number ex.0 or 1 can be specified eg. workbook_object.sheet_by_index(0)

# establish a postgres connection
conn_obj=psycopg2.connect(host='localhost', database='dumptest', user='hans', password='root')

# database cursor
curse_obj=conn_obj.cursor()

# query to insert data into table
query_ins="insert into exxlrd(name,gender,dob,place,age,nationality) values('%s', '%s', '%s', '%s', '%s', '%s') "

# for loop for entering single records in the table
for ri in range(1,sheet_obj.nrows):
	aname=sheet_obj.cell(ri,0).value
	agender=sheet_obj.cell(ri,1).value
	adob=sheet_obj.cell(ri,2).value
	aplace=sheet_obj.cell(ri,3).value
	aage=sheet_obj.cell(ri,4).value
	anationality=sheet_obj.cell(ri,5).value
	
	# asign values from each row to a variable
	var_val=(aname,agender,adob,aplace,aage,anationality)
	print var_val
	# executing the query by passing the values
	#curse_obj.execute(query_ins, var_val)
	


	#curse_obj.execute("insert into exxlrd(name,gender,dob,place,age,nationality) values('%s', '%s', '%s', '%s', '%s', '%s') " % (aname,agender,adob,aplace,aage,anationality) ) ###errors
	
	

# cursor closed
curse_obj.close()

#commit transaction and closing
conn_obj.commit()
conn_obj.close()

'''
#... printing message
print "bye!!!"
columns = str(sheet_obj.ncols)
rows = str(sheet_obj.nrows)
print "imported " %2B " columns " %2B "and " %2B rows %2B "..." '''

