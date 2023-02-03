class Ability  < Cor1440Gen::Ability

  ROLADMIN    = 1
  ROLDIR      = 3
  ROLOPERADOR = 5


  GRUPO_ANALISTA_CASOS = 20
  GRUPO_OBSERVADOR_CASOS = 21
  GRUPO_OBSERVADOR_PARTE_CASOS = 22

  ROLES = [
    ["Administrador", ROLADMIN], 
    ["", 0], 
    ["Directivo", ROLDIR], 
    ["", 0], 
    ["Operador", ROLOPERADOR],
    ["", 0 ],
    ["", 0]
  ]

  BASICAS_PROPIAS =  [
  ]
  
  def tablasbasicas 
    Msip::Ability::BASICAS_PROPIAS + 
      Heb412Gen::Ability::BASICAS_PROPIAS + 
      Cor1440Gen::Ability::BASICAS_PROPIAS +
      Sivel2Gen::Ability::BASICAS_PROPIAS + 
      BASICAS_PROPIAS
  end

  BASICAS_ID_NOAUTO = []

  def basicas_id_noauto 
    Msip::Ability::BASICAS_ID_NOAUTO +
      Heb412Gen::Ability::BASICAS_ID_NOAUTO +
      Cor1440Gen::Ability::BASICAS_ID_NOAUTO +
      Sivel2Gen::Ability::BASICAS_ID_NOAUTO +
      BASICAS_ID_NOAUTO
  end

  NOBASICAS_INDSEQID = [
  ]

  def nobasicas_indice_seq_con_id 
    Msip::Ability::NOBASICAS_INDSEQID +
      Heb412Gen::Ability::NOBASICAS_INDSEQID +
      Cor1440Gen::Ability::NOBASICAS_INDSEQID +
      Sivel2Gen::Ability::NOBASICAS_INDSEQID +
      NOBASICAS_INDSEQID
  end

  BASICAS_PRIO = []

  def tablasbasicas_prio 
    Msip::Ability::BASICAS_PRIO +
      Heb412Gen::Ability::BASICAS_PRIO +
      Sivel2Gen::Ability::BASICAS_PRIO +
      Cor1440Gen::Ability::BASICAS_PRIO +
      BASICAS_PRIO
  end

  CAMPOS_PLANTILLAS_PROPIAS = {}

  def campos_plantillas
    Heb412Gen::Ability::CAMPOS_PLANTILLAS_PROPIAS.clone.
      merge(Cor1440Gen::Ability::CAMPOS_PLANTILLAS_PROPIAS.clone).
      merge(Sivel2Gen::Ability::CAMPOS_PLANTILLAS_PROPIAS.clone).
      merge(CAMPOS_PLANTILLAS_PROPIAS.clone)
  end


  # Establece autorizaciones con CanCanCan
  # Operadores solo puede ver y editar actividades de sus proyectos, pero no
  # pueden ver ni editar casos.  Por si lo requieren a futuro, se deja grupo 
  # Analista de Casos para ver y editar casos --aunque inicialmente no tiene 
  # usuarios.
  def initialize(usuario = nil)
    Sivel2Gen::Ability.initialize_sivel2_gen(self, usuario)
    Cor1440Gen::Ability.initialize_cor1440_gen(self, usuario)

    if !usuario || !usuario.fechadeshabilitacion.nil?
      return
    end
    can :contar, Sivel2Gen::Caso
    cannot :pestanadesaparicion, Sivel2Gen::Caso

  end
end

