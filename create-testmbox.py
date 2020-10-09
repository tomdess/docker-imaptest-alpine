#!/usr/bin/env python

import mailbox, random, string, os
from email.mime.text import MIMEText
from email.utils import formatdate

mbox_out = 'testmbox'
mbox_tmp = '/tmp/testmbox'

mbox = mailbox.mbox(mbox_tmp)

mailfrom = 'sender@example.com'
mailto = 'recipient@example.com'
subject = 'Testmsg of %s kB'

# You might want to adjust your size_distribution dictionary according to your needs.
# The following will create an mbox with 5 mails of 10kB, 80kB, 150kB and 250kB each
# in a randomized order. Imaptest will go through the mbox sequentially so the
# randomness has to be in the mbox file.
#size_distribution = {}
#size_distribution[10] = 5
#size_distribution[80] = 5
#size_distribution[150] = 5
#size_distribution[250] = 5

size_distribution = {}
size_distribution[5] = 5
size_distribution[10] = 10
size_distribution[20] = 25
size_distribution[40] = 15
size_distribution[60] = 13
size_distribution[80] = 10
size_distribution[150] = 5
size_distribution[250] = 4
size_distribution[500] = 5
#size_distribution[15000] = 0



def splitrow(string, linelen):
   step = linelen
   out = []
   for i in range(0, len(string), linelen):
       out.append(string[i:step])
       step += linelen
   return '\n'.join(out)

date = formatdate()
mails = []
for key, val in size_distribution.items():

 for mail in range(0, val):
  mails.append(key)

random.shuffle(mails)

for val in mails:
   body = ''.join(random.choice(string.ascii_lowercase + string.ascii_uppercase + string.digits + " .-") for _ in range(0, val*1024))
   body = splitrow(body, 76)
   msg = MIMEText(body + '\n')
   msg.set_unixfrom('From %s %s' % (mailfrom, date))
   msg['Date'] = date
   msg['Subject'] = subject % val
   msg['To'] = mailto
   msg['From'] = mailfrom
   msg['Message-ID'] = '<' + ''.join(random.choice(string.ascii_lowercase + string.ascii_uppercase + string.digits) for _ in range(0, 24)) + '>'
   print 'Creating message of size {0} KB'.format(val)
   mbox.add(msg)

with open(mbox_tmp, 'r') as tmpmbox:
   with open(mbox_out, 'w') as mbox:
    for line in tmpmbox.readlines():
     mbox.write(line.replace('\n', '\r\n'))

tmpmbox.close();
os.unlink(mbox_tmp);

print 'Wrote mailbox to "{0}"'.format(mbox_out)
