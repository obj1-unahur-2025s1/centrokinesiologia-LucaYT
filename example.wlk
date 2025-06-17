class Paciente{
  var edad
  var fortalezaMuscular
  var dolor

  const property listaAparatos = []
  method agregarAparato(unAparato){listaAparatos.add(unAparato)}
  method quitarAparato(unAparato){
    if(!listaAparatos.contains(unAparato)){
      self.error("El paciente no tiene asignado el aparato" + unAparato)
    }
    listaAparatos.remove(unAparato)
  }

  method edad()=edad
  method dolor()=dolor
  method fortalezaMuscular()=fortalezaMuscular

  method usar(unAparato){
    if (self.puedeUsar(unAparato)){
      unAparato.efecto(self)
      }
    else{
      self.error("El paciente no puede usar el aparato " + unAparato)
    }
  }
  method puedeUsar(unAparato){return unAparato.requerimiento(self)}

  method disminuirDolor(cantidad){dolor -= cantidad}
  method aumentarFortalezaMuscular(cantidad){fortalezaMuscular == fortalezaMuscular + cantidad}
}

class Aparato{
  method efecto()
  method requerimiento()
}

class Magneto{
  method efecto(unPaciente){return unPaciente.disminuirDolor(unPaciente.dolor() * 0.1)}
  method requerimiento(unPaciente){return true}
}

class Bicicleta{
  method efecto(unPaciente){return 
    unPaciente.disminuirDolor(4)
    unPaciente.aumentarFortalezaMuscular(3)
  }
  method requerimiento(unPaciente){return unPaciente.edad() > 8}
}

class Minitramp{
  method efecto(unPaciente){return unPaciente.aumentarFortalezaMuscular(unPaciente.edad() * 0.1)}
  method requerimiento(unPaciente){return unPaciente.dolor() < 20}
}