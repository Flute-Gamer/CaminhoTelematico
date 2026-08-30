from pythonosc.udp_client import SimpleUDPClient

# IP e porta do Godot
ip = "127.0.0.1"
porta = 4646

client = SimpleUDPClient(ip, porta)

# envia 
client.send_message("/volume", 0.95)
print("Enviado!")

client.send_message("/pitch", 2500)
print("Enviado!")