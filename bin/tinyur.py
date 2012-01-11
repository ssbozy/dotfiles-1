#!/usr/bin/python

#TODO crashes if imagemagick is not installed
"""TODO

$ bin/tinyur.py 
http://i.imgur.com/NEhW5.jpg @ 2011-08-22 17:34:12 from /Users/pavel/Temp/Screen Shot 2011-08-22 at 17.29.07.png.jpg
Unable to parse JSON response:
Traceback (most recent call last):
File "bin/tinyur.py", line 109, in <module>
print "Unable to parse JSON response:", err.error
AttributeError: 'exceptions.OSError' object has no attribute 'error'
"""

import os, re, pycurl, simplejson, pprint, subprocess, datetime, time

import sys
import os
import re
import subprocess
import datetime
import time
import simplejson

# https://github.com/kennethreitz/requests
import requests

regex = re.compile("^Screen shot.*\.png$", re.I)
log_file = '/Users/pavel/tinyur.log'
searchdir = '/Users/pavel/Desktop/'
storedir = '/Users/pavel/Temp/'
imgur_url = 'http://imgur.com/api/upload.json'
imgur_key = '2ed98178160882e2570722d158adad06'

def getClipboardData():
  p = subprocess.Popen(['pbpaste'], stdout=subprocess.PIPE)
  retcode = p.wait()
  data = p.stdout.read()
  return data

def setClipboardData(data):
  p = subprocess.Popen(['pbcopy'], stdin=subprocess.PIPE)
  p.stdin.write(data)
  p.stdin.close()
  retcode = p.wait()

def log(line, growl = True):
  t = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

  try:
    f = open( log_file, 'a' )
    f.write( "%s %s\n" % (t, line) )
    f.close()
  except IOError as err:
    #print "Warning: unable to open log file %s" % (filepath,)
    pass

  if growl:
    args = [ '/usr/local/bin/growlnotify',
             '-t', 'tinyur',
             '-m', '%s' % (line, ),
             '--sticky' ]
    p = subprocess.call( args = args, stdout = None, stderr = None )

while True:
  time.sleep(1)

  for filename in os.listdir( searchdir ):

    if regex.search( filename ) is None:
      # Not a screenshot
      continue

    try:

      # Move file off the desktop
      os.rename( os.path.join(searchdir, filename),
                 os.path.join(storedir, filename ))

      filepath = os.path.join( storedir, filename )

      data = { 'key' : imgur_key }
      files = { 'image' : open( filepath, 'rb') }

      r = requests.post( imgur_url, data=data, files=files )

      if r.status_code is not requests.codes.ok:
        # bad HTTP response code
        raise Exception("Invalid response from imgur: %s %s" % (r.status_code, r.content))

      j = simplejson.loads(r.content)
      if j['rsp']['stat'] != 'ok':
        raise Exception("Unable to upload image: %s %s" % (j['rsp']['image']['error_code'],
                                                           j['rsp']['image']['error_msg']))

      log("Uploaded %s" % ( j['rsp']['image']['original_image'], ))
      log("Delete hash: %s" % ( j['rsp']['image']['delete_hash'], ), False) # no growl
      log("Delete page: %s" % ( j['rsp']['image']['delete_page'], ), False) # no growl
      setClipboardData( j['rsp']['image']['original_image'] )
      os.remove( filepath )
    except simplejson.JSONDecodeError as e:
      log("Invalid JSON received from imgur: %s" % ( r.content, ))
    except OSError:
      log("Unable to move or remove file %s" % ( filepath, ))
    except Exception as e:
      log("Unable to upload screenshot: %s" % ( e, ))
