break *0x10074
break 22
break 24
break 27
run

db threads -output /dev/null
db stack -output /dev/null
db history -output /dev/null

db exp watch *(((int*)$sp) + 0)
db exp watch *(((int*)$sp) + 1)
db exp watch *(((int*)$sp) + 2)
db exp watch *(((int*)$sp) + 3)


