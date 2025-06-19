class Paciente {
  var edad
  var fortalezaMuscular
  var dolor
  const property rutina = []
  method cumplirAños(){edad+=1}
  method edad() = edad
  method fortalezaMuscular() = fortalezaMuscular
  method dolor() = dolor
  method agregarAparato(unAparato){rutina.add(unAparato)}
  method quitarAparato(unAparato){
    if(!rutina.contains(unAparato)){
      self.error("El aparato "+ unAparato +" no forma parte de la rutina del paciente")
    }
    rutina.remove(unAparato)
  }

  method puedeUsar(unAparato) {return unAparato.puedeSerUsadoPor(self)}
  method disminuirDolor(unValor) {dolor=(dolor-unValor).max(0)}
  method aumentarFortaleza(unValor) {fortalezaMuscular=fortalezaMuscular+unValor}
  method usar(unAparato) {
    if(!self.puedeUsar(unAparato)) {
      self.error("El paciente no puede usar ese aparato")
    }
    unAparato.esUsadoPor(self)
  }
  method concurrirAlCentro(){
    if(!self.puedeHacerRutina()){
      self.error("El paciente no puede realizar la rutina asignada")
    }
    rutina.forEach({a=>a.esUsadoPor(self)})
  }
  method puedeHacerRutina(){return rutina.all({a=>a.puedeSerUsadoPor(self)})}
}

class Resistente inherits Paciente{
  override method concurrirAlCentro(){
    if(!self.puedeHacerRutina()){
      self.error("El paciente resistente no puede realizar la rutina asignada")
    }
    rutina.forEach({a=>a.esUsadoPor(self)})
    self.aumentarFortaleza(self.cantidadAparatos())
  }
  method cantidadAparatos(){return rutina.size()}
}

class Caprichoso inherits Paciente{
  override method concurrirAlCentro(){
    if(!self.puedeHacerRutina() || self.ningunAparatoEsRojo()){
      self.error("El paciente caprichoso no puede realizar la rutina asignada")
    }
    rutina.forEach({a=>a.esUsadoPor(self)})
    rutina.forEach({a=>a.esUsadoPor(self)})
  }
  method ningunAparatoEsRojo(){return rutina.all({a=>!a.esRojo()})}
}

class Recuperacion inherits Paciente{
  override method concurrirAlCentro(){
    if(!self.puedeHacerRutina()){
      self.error("El paciente genéticamente modificado no puede realizar la rutina asignada, de alguna manera")
    }
    rutina.forEach({a=>a.esUsadoPor(self)})
    self.disminuirDolor(self.valor())
  }
  method valor(){return valorRapidaRec.valor()}
}

object valorRapidaRec {
  var property valor = 3
}

class Magneto {
  var color = "blanco"
  var inmantacion = 800
  method color() = color
  method pintar(unColor){color = unColor}
  method esRojo(){return color == "rojo"}

  method esUsadoPor(unPaciente){
    unPaciente.disminuirDolor(unPaciente.dolor() * 0.1)
    inmantacion=0.max(inmantacion-1)
  } 
  method puedeSerUsadoPor(unPaciente) {return true}

  method hacerMantenimiento(){if(self.necesitaMantenimiento()) inmantacion+=500}
  method necesitaMantenimiento(){return inmantacion < 100}
}

class Bici {
  var color = "blanco"
  var desajustarTornillos = 0
  var pierdeAceite = 0

  method color() = color
  method pintar(unColor){color = unColor}
  method esRojo(){return color == "rojo"}

  method esUsadoPor(unPaciente) {
    unPaciente.disminuirDolor(4)
    unPaciente.aumentarFortaleza(3)
    self.desajustarTornillosSiDolor(30, unPaciente)
    self.pierdeAceiteSiEdad(50, unPaciente)
  }
  method puedeSerUsadoPor(unPaciente) {return unPaciente.edad() > 8}
  method desajustarTornillosSiDolor(unDolor, unPaciente){if(unPaciente.dolor() > unDolor) desajustarTornillos += 1}
  method pierdeAceiteSiEdad(unaEdad, unPaciente){if(unPaciente.edad() > unaEdad) pierdeAceite += 1}

  method hacerMantenimiento(){
    if(self.necesitaMantenimiento()){
      desajustarTornillos=0
      pierdeAceite=0
    }
  }
  method necesitaMantenimiento(){return desajustarTornillos > 10 || pierdeAceite > 5}
}

class Minitramp {
  var color = "blanco"
  method color() = color
  method pintar(unColor){color = unColor}
  method esRojo(){return color == "rojo"}

  method esUsadoPor(unPaciente) {unPaciente.aumentarFortaleza(unPaciente.edad() * 0.1)}
  method puedeSerUsadoPor(unPaciente) {return unPaciente.dolor() < 20}

  method hacerMantenimiento(){}
  method necesitaMantenimiento(){return false}
}

object centro{
  const listaAparatos = #{}
  const listaPacientes = #{}

  method agregarAparatoAlCentro(unAparato){listaAparatos.add(unAparato)}
  method agregarPacienteAlCentro(unPaciente){listaPacientes.add(unPaciente)}

  method coloresAparatosSinRepetir(){return self.coloresAparatos().asSet()}
  method coloresAparatos(){return listaAparatos.map({a=>a.color()})}

  method pacientesMenores(){return listaPacientes.filter({p=>self.pacienteEsMenor(p)})}
  method pacienteEsMenor(unPaciente){return unPaciente.edad() < 8}

  method pacientesIncapaces(){return listaPacientes.filter({p=>self.pacienteEsIncapaz(p)})}
  method pacienteEsIncapaz(unPaciente){return !unPaciente.puedeHacerRutina()}

  method estanEnCondiciones(){return listaAparatos.all({a=>self.estaEnCondiciones(a)})}
  method estaEnCondiciones(unAparato){return !unAparato.necesitaMantenimiento()}

  method listaEstanEnCondiciones(){return listaAparatos.filter({a=>self.estaEnCondiciones(a)})}
  method visitaAlTecnico(){!self.listaEstanEnCondiciones().forEach({a=>a.hacerMantenimiento()})}

  method cantidadEnCondiciones(){return self.listaEstanEnCondiciones().size()}
  method estaComplicado(){return self.cantidadEnCondiciones() * 2 < self.cantidadAparatos()}
  method cantidadAparatos(){return listaAparatos.size()}
}