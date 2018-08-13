import csv # imported package comma-separated values
import psycopg2 # imported package adapter for python

con_obj=psycopg2.connect(database='dumptest', user='hans', password='root', host='localhost') # connection object initialized for database
cursor_obj=con_obj.cursor() # cusror object initialized for daabase cursor

# file_obj=open('excel1file.csv')
# file opened used and closed using with and printer data and inserted into database at the same time
with open('January/08_01_2016/excel1file.csv') as reader_file :
	my_read_obj=csv.reader(reader_file)
	for rows in my_read_obj:
		print(rows)
		query_ins="insert into temp (name, gender, dob, place, age) values ('%s', '%s', '%s', '%s', '%s') " % (rows[0], rows[1], rows[2], rows[3], rows[4])
		cursor_obj.execute(query_ins) #cursor pointing to single line of database
# connection and file reader objects closed
reader_file.close()
con_obj.commit()
cursor_obj.close()

			
