import usuariosYChats.*

class Mensajes{
	const property emisor = new String()
	const datosFijosTransf = 5
	const factorDeLaRed = 1.3
	const property contenido
	
	method peso() = datosFijosTransf + self.pesoContenido() * factorDeLaRed

	method pesoContenido() = contenido.pesoPropio()

	method contieneTexto(texto) = contenido.tieneElTexto(self, texto)
}

class Contenidos{
	method tieneElTexto(mensaje, texto) = mensaje.emisor().contains(texto)
}


class Texto inherits Contenidos{
	var property caracteres = new String()
	
	method pesoPropio() = 1* caracteres.size()

	override method tieneElTexto(mensaje,texto) = super(mensaje,texto) or caracteres.contains(texto)
}

class Audio inherits Contenidos{
	var property duracion = new Number()
	
	method pesoPropio() = 1.2 * duracion
}

class Contacto inherits Contenidos{
	var property usuarioEnviado
	
	method pesoPropio() = 3
	
	override method tieneElTexto(mensaje,texto) = super(mensaje,texto) or usuarioEnviado.nombre().contains(texto)
}

class Imagen inherits Contenidos{
	var property ancho
	var property largo
	var property tipoComprension
	method pesoPropio() = 2 * tipoComprension.pesoSegunComprension(ancho, largo)
} 

class Gifs inherits Imagen{
	var property cantCuadros
	
	override method pesoPropio() = super() * cantCuadros
}

object comprensionOriginal{
	method pesoSegunComprension(ancho,largo) = ancho * largo
}

class ComprensionVariable{
	var property porcentaje
	
	method pesoSegunComprension(ancho,largo) = ((ancho*largo) * porcentaje) / 100
}

object comprensionMaxima{
	method pesoSegunComprension(ancho,largo) = (ancho*largo).min(10000)
}