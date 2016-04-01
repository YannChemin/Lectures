#!/usr/bin/env python

# Data file name
f="MetDept1.csv"

# Read CSV files
import csv

# Open csv file
csvfile = open( f, "rb" )

# Sniff into 10Kb of the file to check its dialect
dialect = csv.Sniffer().sniff( csvfile.read( 10*1024 ) )
csvfile.seek(0)

# Read csv file according to dialect
reader = csv.reader( csvfile, dialect )

# Read header
header = read.next()

# Read data into memory
data = [row for row in reader]

# Close input file
csvfile.close()

print( header )
print( data[-2][:] )

# Plot some data
import datetime
import matplotlib.dates as dlt
X=[]
for i in range(len(data)):
	if(i%1000 == 0):
		print("Timestamp",i,len(data))
	#5 is GMTTime
	if(data[:][i][4] != '' and data[:][i][5] != ''):
		day,month,year=data[:][i][4].split("/")
		hour,minute,second=data[:][i][5].split(":")
		try:
			X.append(dlt.date2num(datetime.datetime(int(year),int(month),int(day),int(hour),int(minute),int(second))))
		except:
			X.append(0.0)
	else:
		X.append(0.0)

