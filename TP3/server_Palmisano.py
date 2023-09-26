import socket
from threading import Thread, Lock
from datetime import datetime
from time import sleep

HOST = ""
PORT = 40002

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #AF_INET es que usamos protocolo IPv4 --- SOCK_STREAM es que usamos TCP
s.bind((HOST, PORT)) #Asigna el socket a la PC que corre el script en el puerto PORT
s.listen() # Lo abre y queda escuchando el puerto PORT

print('Servidor iniciado...')

def connection(sc,addrc):
    ok_message = "OK"
    print('Cliente: ',addrc, ok_message) #Imprimo quien se conectó
    client_socket.sendall(ok_message.encode())
    while True:
        dato = sc.recv(1024) #Leo los datos
        if not dato:
            print(f'Cliente {addrc} desconectado')
            break #Si el cliente se desconecta cierro el hilo
        else:
            try:
                mensaje = dato.decode('utf-8') #Paso los bytes a string
            except:
                mensaje = dato
            print(f'{datetime.now().strftime("%H:%M:%S")}: {mensaje}')#Muestro la hora y lo que llega
            file = open("/home/moviles/Desktop/Moviles2023/Palmisano_G_40002/dataPalmisano.txt", "a")
            file.write(f'{datetime.now().strftime("%H:%M:%S")}: {mensaje}')
            file.close()

while True:
    client_socket, client_address = s.accept() #Cuando llega una conección la acepto el ingreso del cliente
    t = Thread(target = connection, args=(client_socket, client_address)) #Abro un hilo y ejecuto las tareas hasta que el cliente cierra el socket
    t.start() #Inicio el hilo
