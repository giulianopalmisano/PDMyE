# Clase 1
import machine, time
from machine import ADC

# file=open("data.csv","w")	# creation and opening of a CSV file in Write mode
# # Type Program Logic Here
# file.write(str(value)+",")	# Writing data in the opened file
# # file.flush()			# Internal buffer is flushed (not necessary if close() function is used)
# file.close()			# The file is closed

rtc = machine.RTC()
#rtc.datetime((2020, 1, 21, 2, 10, 32, 36, 0))
print(rtc.datetime())

value_ad = ADC(26)


print("Starting...")
file = open("data/data.txt","w") # creation and opening of a CSV file in Write mode
led = machine.Pin(25, machine.Pin.OUT)

while True:
    n = value_ad.read_u16()
    print(n)
    file.write(str(n)+",") # Writing data in the opened file
    file.flush() # Internal buffer is flushed (not necessary if close() function is used)
    time.sleep(1)
file.close()			# The file is closed

    
