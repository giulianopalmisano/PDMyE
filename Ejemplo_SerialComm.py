from machine import UART,Timer,Pin,ADC
import time


def interrupcion(timer):
    Led.toggle()

def comando(cmd):
    print(cmd)
    comando_str=str(cmd).split(" ")
    print(comando_str)

#SETUP
uart0=UART(0, baudrate=9600, tx=Pin(16), rx=Pin(17))
ADC1=ADC(26)
Led=Pin(25,Pin.OUT)
timer1=Timer(period=1000, mode=Timer.PERIODIC, callback= interrupcion )


while True:
    #an0=ADC1.read_u16()
    #uart0.write('holaaa\n')
    #print(an0)
    cmd=input(">:")
    comando(cmd)
    #time.sleep(1)
    
    