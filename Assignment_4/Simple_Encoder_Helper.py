#!/usr/bin/env python

def encode():
n = raw_input("[<->] Input Your Insertion value to be used in encoding the shellcode: \n")
shellcode = raw_input("[<->] Now Input Your full shellcode in hex in online to encode it : \n")
#n = 13 # rot-n
max_value_without_wrapping = 256 - int(n)
encoded_shellcode = ""
db_shellcode = []
for i in bytearray(shellcode):
if i < max_value_without_wrapping:
encoded_shellcode += '\\x%02x' % (i + int(n))
db_shellcode.append('0x%02x' % (i + int(n))) 
else:
encoded_shellcode += '\\x%02x' % (int(n) - 256 + i)
db_shellcode.append('0x%02x' % (int(n) - 256 + i))
print "Your Insertion Value: %s" % n
print "Your Encoded shellcode: \n%s" % encoded_shellcode
print "DB formatted :\n%s\n" % ','.join(db_shellcode)

encode()

 
