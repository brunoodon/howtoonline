#!/bin/python3
import requests
import json
import re
import logging
import os
import datetime
import time
url = "http://misp.howtoonline.com.br/attributes/restSearch/returnFormat:json/org:TRP/tags:pandemic:covid-19=\"cyber\""
url_post = "http://localhost:9200/covid-19-indicators/_doc"
headers = {'Authorization': '0NUVtsv4Z3bnjLxfM8sEOzH3XgzsPitT5CrYYmwT', 'Content-Type': 'application/json'}
headers_post = {'Content-Type': 'application/json'}
r = requests.get(url, headers=headers, verify=False)
print(r.status_code)
json_data=json.loads(r.text)
for i in json_data['response']['Attribute']:
  timestamp=i['timestamp']
  type=i['type']
  value=i['value']
  org_id=i['Event']['orgc_id']
  info=i['Event']['info']
  uuid=i['Event']['uuid']
  json={
  'Type': str(i['type']),
  'Value': str(i['value']),
  'Info': str(i['Event']['info']),
  'UUID': str(i['Event']['uuid']),
  'Date': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime(int(i['timestamp'])))
  }
  r_post=requests.post(url_post, headers=headers_post, verify=False, json=json)
  print(r_post.status_code)


