import mensajes.*

/*
 * Nombre: Petronacci, Lautaro
 * Legajo: 172.777-1
 * 
 * Puntos de Entrada: 
 * const chatVelezano = new Chats(mensajes = [], participantes = [alf, rasta, lautaro]
 * const alf = new Usuario(nombre = "alfredo", espacioLibre = 1000, chats = [chatVelezano])
 * const audioAVelez = new Mensaje(emisor = "alfredo", contenidos = [new Audio(duracion = 15)])
 * 
 * Punto 1: chatVelezano.pesoChat()
 * Punto 2: alf.enviarMensaje(audioAVelez,chatVelezano)
 * Punto 3: alf.busquedaDeTexto("alfredo")
 * Punto 4: alf.mensajeMasPesadoDeCadaChat()
 * Punto 5a: alf.recibirMensaje(mensaje, chat)  => la notificacion recibida para el usuario pasa dentro de este metodo y es: alf.recibirNotificacion(mensaje)
 * Punto 5b: alf.leerChat(chatVelezano)
 * Punto 5c: alf.notificacionesSinLeer()
 */

class Usuario{
	const property nombre = new String()
	var property espacioLibre = new Number()
	const property chats = new List()
	const property mensajesSinLeer = new List()
	
	method puedeRecibirMensaje(mensaje, chat) =chats.contains(chat) and espacioLibre - mensaje.peso() >= 0

	method recibirMensaje(mensaje, chat){
		espacioLibre -= mensaje.peso()
		self.recibirNotificacion(mensaje)
	}
	
	method enviarMensaje(mensaje, chat){
		if(self.puedeRecibirMensaje(mensaje,chat) and chat.restriccionesReciboMensaje(self, mensaje)){
		chat.recibirMensaje(mensaje)
		chat.enviarNotificacion(mensaje)
		}
		else self.error("no se puede enviar el mensaje")
	}
	
	method busquedaDeTexto(texto) = chats.filter({unChat => unChat.tieneElTexto(texto)})
	
	method mensajeMasPesadoDeCadaChat() = chats.map({unChat => unChat.mensajeMasPesado()})

	method recibirNotificacion(mensaje){
		mensajesSinLeer.add(mensaje)
	}
	
	method leerChat(chat){
		if(not chats.contains(chat)) self.error("ese chat no es tuyo")
		else mensajesSinLeer.removeAllSuchThat({unMensaje => chat.mensajes().contains(unMensaje)})
	}
	
	method notificacionesSinLeer() = mensajesSinLeer
}


class Chats{
	const property mensajes = new List()
	const property participantes = new List()
		
	method pesoChat() = mensajes.map({unMensaje => unMensaje.peso()}).sum()
	
	method restriccionesReciboMensaje(usuario, mensaje) = participantes.contains(usuario)

	method recibirMensaje(mensaje){
		mensajes.add(mensaje)
	}
	
	method tieneElTexto(texto) = mensajes.any({unMensaje => unMensaje.contieneTexto(texto)})

	method mensajeMasPesado() = mensajes.max({unMensaje => unMensaje.peso()})

	method enviarNotificacion(mensaje) = participantes.forEach({participante => participante.recibirNotificacion(mensaje)})
}

class ChatsPremiums inherits Chats{
	var property restriccion
	const property creador
	
	override method restriccionesReciboMensaje(usuario, mensaje) = super(usuario, mensaje) and restriccion.restriccion(self, usuario, mensaje)
	
}

object difusion{
	
	method restriccion(chat, emisor, mensaje) = chat.creador() == emisor
}

class Restringido{
	var property limite
	method restriccion(chat, emisor, mensaje) = chat.mensajes().size() < limite
	
/*	method restriccion(chat, emisor, mensaje){
		if(chat.mensajes().size() < limite){	
			self.bajarLimite()
			return true
		}
	}
	method bajarLimite(){
		limite  -= 1
	}*/                                           // aca no supe como hacer que retorne true segun la condicion 
												//  y que baje el limite a la vez
}

class Ahorro{
	var property pesoMaximo
	
	method restriccion(chat, emisor, mensaje) = mensaje.peso() < pesoMaximo
}
