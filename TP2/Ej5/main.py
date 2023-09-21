# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 2
# Ejercicio 5
# Giuliano Palmisano

'''
Este programa recibe un comando a través del puerto serie
para enviar datos del canal analógico A0 cada 5seg.
'''

### LIBRERIAS ###
import machine
from machine import Timer, Pin, ADC
import time

### FUNCIONES ###
# Función de interrupción del timer
def timer_int(timer):
    adc_A0_value = adc_A0.read_u16()
    print("$"+str(adc_A0_value*CONV_ADC)+"%")

# Función para prender o apagar el LED según el comando
def procesar_com(cmd):
    global timer_lect_A0, T_MUESTREO_MS
    if cmd == "start":
        adc_A0_value = adc_A0.read_u16()
        print("$"+str(adc_A0_value*CONV_ADC)+"%")
        # Configuración del timer
        timer_lect_A0.init(mode=Timer.PERIODIC, period=T_MUESTREO_MS, callback=timer_int)
    
### SETUP ###
Led=Pin("LED",Pin.OUT)
# Encendido del LED para identificar inciación del programa
Led.on()
time.sleep(3)
Led.off()

# Configuración de ADC
adc_pin = 26 # Corresponde a la entrada A0
adc_A0 = ADC(adc_pin)

# Creación del timer
timer_lect_A0 = Timer(-1)

CONV_ADC = 3.3/65535 # Factor de conversion del ADC
T_MUESTREO_MS = 5000 # Tiempo de muestreo

### MAIN LOOP ###
# Se espera hasta que llegue algún comando
while True:
    cmd=input(">:")
    procesar_com(cmd)    