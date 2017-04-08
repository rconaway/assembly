break *0x10074
run 10

db threads -output /dev/null
db stack -output /dev/null
db history -output /dev/null
db mem watch &usage_text 32
db mem watch &display_buffer 32

db ass -style opcodes 'true'

db exp watch (int)life
db exp watch *(((int*)$sp) + 0)
db exp watch *(((int*)$sp) + 1)
db exp watch *(((int*)$sp) + 2)
db exp watch *(((int*)$sp) + 3)


