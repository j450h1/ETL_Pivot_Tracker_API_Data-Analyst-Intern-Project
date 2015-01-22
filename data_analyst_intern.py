# -*- coding: utf-8 -*-
"""
Created on Wed Jan 21 23:00:25 2015

@author: user
"""
import requests
from pprint import pprint

#provided in instructions
api_token = "0a1021e3dce4529136474517da486062"
project_id = "1151258"

r = requests.get('https://www.pivotaltracker.com/services/v5/projects/{}/stories/'.format(project_id), headers={'X-TrackerToken':api_token})
all_stories = r.json() # all stories - converted to json format and python dictionary

#create a list of dictionaries with only the fields we need - one per story 

#initialize empty lists
table1 = []]
table2 = []
count = 1
for story in all_stories:
#    pprint(story)
#    print "\n"
#    print count
#    count += 1
#    print "\n"
    if 'estimate' not in story: #Note #2 as per instructions, stories without estimates should have a value of 0
        story['estimate'] = 0
    table1_row = "story_id" : story['id'],
                  "story_name" : story['name'],
                  "story_type" : story['story_type'],
                  "estimate" : story['estimate']
                  }
    table2_row = { "story_id" : story['id'],
                  "requested_by_id" : story['requested_by_id'],
                  "owner_by_id" : story['owned_by_id'],
                  }
    pprint(table1_row)  
    print "\n"
    pprint(table2_row)
    print "\n"
    table1.append(table1_row)
    table2.append(table2_row)
f = csv.writer(open("test.csv", "wb+"))
f.writerow(["pk", "model", "codename", "name", "content_type"])

#lets convert the list of dictionaries to a csv file to be imported into SQL Server - table 1 first
import csv
import csv
import json

x="""[ 
    { "pk": 22, "model": "auth.permission", "fields": 
        { "codename": "add_logentry", "name": "Can add log entry", "content_type": 8 } 
    }, 
    { "pk": 23, "model": "auth.permission", "fields": 
        { "codename": "change_logentry", "name": "Can change log entry", "content_type": 8 } 
    },
    { "pk": 24, "model": "auth.permission", "fields": 
        { "codename": "delete_logentry", "name": "Can delete log entry", "content_type": 8 } 
    }
]"""
type(x)

x = json.loads(x)

	
I am not sure this question is solved already or not, but let me paste what I have done for reference.

First, your JSON has nested objects, so it normally cannot be directly converted to CSV. You need to change that to something like this:

[{ 
"pk": 22, "model": "auth.permission", "codename": "add_logentry", "name": "Can add log entry", "content_type": 8 
},
......]



#SQL Database
#Use MySQL
#story_id and story_type has foreign key constrain from trble 1