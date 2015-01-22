# -*- coding: utf-8 -*-
"""
Created on Wed Jan 21 23:00:25 2015

@author: user
"""
import requests
#from pprint import pprint
import os

os.getcwd()
os.chdir('C:\Users\user\Documents\Python Scripts')
os.getcwd()

#provided in instructions
api_token = "0a1021e3dce4529136474517da486062"
project_id = "1151258"

r = requests.get('https://www.pivotaltracker.com/services/v5/projects/{}/stories/'.format(project_id), headers={'X-TrackerToken':api_token})
all_stories = r.json() # all stories - converted to json format and python dictionary

#initialize empty lists
table1 = []
table2 = []
for story in all_stories:
    if 'estimate' not in story: #Note #2 as per instructions, stories without estimates should have a value of 0
        story['estimate'] = 0
    table1_row =  [ story['id'], story['name'], story['story_type'], story['estimate'] ]
    table2_row =  [ story['id'], story['requested_by_id'], story['owned_by_id'] ]
    table1.append(table1_row)
    table2.append(table2_row)
import csv
#Write out csv file for table 1
f = csv.writer(open("table1.csv", "w"))
table1_columns = ["story_id", "story_name", "story_type", "estimate"]
f.writerow(table1_columns) #first row in csv file which has column names
for row in table1:
    f.writerow(row)
#Write out csv file for table 2
g = csv.writer(open("table2.csv", "w"))
table2_columns = ["story_id", "requested_by_id", "owner_id"]
g.writerow(table2_columns) #first row in csv file which has column names
for row in table2:
    g.writerow(row)

#SQL Database
#Use SQL Server 2012 Management Studio
#story_id and story_type has foreign key constrain from trble 1