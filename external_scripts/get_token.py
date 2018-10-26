#!/usr/bin/python

import sys
import json 
import subprocess

cluster = json.load(sys.stdin)['cluster']
token = json.loads(subprocess.check_output([
    'aws-iam-authenticator',
    'token',
    '-i',
    cluster]))['status']
print(json.dumps(token))
