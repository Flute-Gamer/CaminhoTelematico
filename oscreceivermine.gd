extends OSCReceiver

func _process(_delta):
	if target_server.incoming_messages.has(osc_address):
		var msg = target_server.incoming_messages[osc_address]

		if msg.size() > 0:
			var valor:int = int(msg[0])
			print("Valor recebido:", valor)

		# evita repetir a mesma mensagem
		##target_server.incoming_messages.erase(osc_address)
