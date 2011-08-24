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

# regex = re.compile("^Picture [\d()]+.png$")
regex = re.compile("^Screen shot.*\.png$", re.I)
searchdir = '/Users/pavel/Desktop/'
storedir = '/Users/pavel/Temp/'

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

def openClipboard():
  pass # no-op on the mac

def closeClipboard():
  pass # no-op on the mac

class Buffer:
    def __init__(self):
        self.contents = ''

    def write(self, buf):
        self.contents = self.contents + buf

while 1:
    time.sleep(1)

    for filename in os.listdir( searchdir ):

        if not regex.search( filename ) == None:
            
            # move file to ~/Temp to get it out of my site
            os.rename( searchdir + filename, storedir + filename )

            filename_jpg = filename + '.jpg'

            # Let's find out if a JPEG would suit our purposes better.
            args = [ '/usr/bin/env', 'convert', storedir + filename, storedir + filename_jpg ]
            p = subprocess.call( args = args, stdout = None, stderr = None )
        
            png_size = float(os.path.getsize(storedir + filename))
            jpg_size = float(os.path.getsize(storedir + filename_jpg))

            upload_file = storedir + filename
            if jpg_size < png_size * .5:
                upload_file = storedir + filename_jpg
            
            c = pycurl.Curl()
            values = [ 
                ("key", "2ed98178160882e2570722d158adad06"),
                ("image", (c.FORM_FILE, upload_file))
            ]

            b = Buffer()

            c.setopt(c.URL, "http://imgur.com/api/upload.json")
            c.setopt(c.WRITEFUNCTION, b.write)
            c.setopt(c.HTTPPOST, values)

            try:
                c.perform()
            except pycurl.error:
                # I guess we couldn't connect.
                print "CURL Error:", pycurl.error
                continue
        

            if b.contents == "":
                print "imgur returned empty string, unable to parse."
                continue

            try:
                j = simplejson.loads(b.contents)

                if j['rsp']['stat'] == 'ok':

                    # print date and time here as well
                    t = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                    url = j['rsp']['image']['original_image']
                    print url, "@", t, "from", upload_file

                    setClipboardData( j['rsp']['image']['original_image'] ) # copy to buffer

                    # Notify us
                    args = [ '/usr/local/bin/growlnotify', '-t', 'Screenshot Uploaded', '-m', '%s uploaded from %s' % (url, upload_file), '--sticky' ]
                    p = subprocess.call( args = args, stdout = None, stderr = None )

                    try:
                        os.remove( storedir + filename )     # delete png file
                        os.remove( storedir + filename_jpg ) # delete jpg file
                    except OSError:
                        # Maybe two copies of pfuploader running at the same time? Weird.
                        pass

            except Exception as err: # simplejson.decoder.JSONDecodeError ?
                # I guess we couldn't connect.
                print "Unable to parse JSON response:", err.error
                print "JSON response: ", b.contents
                os.remove( storedir + filename )     # delete png file
                os.remove( storedir + filename_jpg ) # delete jpg file
                continue

    
            c.close()


