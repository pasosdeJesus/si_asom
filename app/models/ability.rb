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

    #Proveniente de sivel2_gen
    can :read, [Msip::Pais, Msip::Departamento, Msip::Municipio, Msip::Clase]

    # La consulta web es publica dependiendo de
    if !usuario && Rails.application.config.x.sivel2_consulta_web_publica
      can :buscar, Sivel2Gen::Caso
      can :lista, Sivel2Gen::Caso

      # API público
      # Mostrar un caso con casos/101
      # Mostrar un caso en XML - HTML con casos/101.xml
      # Mostrar un caso en XML para descarga casos/101.xrlat
      can [:read,:show], Sivel2Gen::Caso

      #Mostrar registros limitados
      can :index4000, Sivel2Gen::Caso
    end

    initialize_cor1440_gen(usuario)
    if !usuario || !usuario.fechadeshabilitacion.nil?
      return
    end
    can :contar, Sivel2Gen::Caso
    cannot :pestanadesaparicion, Sivel2Gen::Caso

    case usuario.rol
    when Ability::ROLOPERADOR
      can :index, Cor1440Gen::Proyectofinanciero
      can :index, Cor1440Gen::Actividad

      can :manage, Cor1440Gen::Mindicadorpf

      if usuario.msip_grupo &&
          usuario.msip_grupo.pluck(:id).include?(GRUPO_ANALISTA_CASOS)

        # Proveniente de sivel2_gen
        # Hacer conteos
        can :cuenta, Sivel2Gen::Caso

        can :buscar, Sivel2Gen::Caso
        can :contar, Sivel2Gen::Caso
        can :lista, Sivel2Gen::Caso

        can [:read, :update], Mr519Gen::Encuestausuario
        can :read, Msip::Orgsocial

        can :descarga_anexo, Msip::Anexo

        can :contar, Msip::Ubicacion
        can :nuevo, Msip::Ubicacion

        can :nuevo, Sivel2Gen::Combatiente

        can :nuevo, Sivel2Gen::Presponsable
        can :manage, Sivel2Gen::Victima
        can :manage, Sivel2Gen::Victimacolectiva

        can :read, Heb412Gen::Doc
        can :read, Heb412Gen::Plantilladoc
        can :read, Heb412Gen::Plantillahcm
        can :read, Heb412Gen::Plantillahcr

        can :manage, Msip::Bitacora, usuario: { id: usuario.id }

        can [:read, :new, :edit, :update, :create],
          Msip::Orgsocial
        can :read, Msip::Bitacora
        can :manage, Msip::Persona

        can :manage, Sivel2Gen::Acto
        can :manage, Sivel2Gen::Actocolectivo
        can [:read, :new, :edit, :update, :create, :nuevo, :destroy], Sivel2Gen::Caso

        cannot :solocambiaretiquetas, Sivel2Gen::Caso
        can :refresca, Sivel2Gen::Caso
      end


    when Ability::ROLADMIN, Ability::ROLDIR

      # Proveniente de sivel2_gen
      can :manage, Heb412Gen::Doc
      can :manage, Heb412Gen::Plantilladoc
      can :manage, Heb412Gen::Plantillahcm
      can :manage, Heb412Gen::Plantillahcr

      can :manage, Mr519Gen::Formulario
      can :manage, Mr519Gen::Encuestausuario 

      can :manage, Msip::Orgsocial
      can :manage, Msip::Bitacora
      can :manage, Msip::Persona
      can :manage, Msip::Respaldo7z

      can :manage, Sivel2Gen::Acto
      can :manage, Sivel2Gen::Actocolectivo
      can :manage, Sivel2Gen::Caso
      cannot :solocambiaretiquetas, Sivel2Gen::Caso
      can :manage, Sivel2Gen::Combatiente
      can :manage, Sivel2Gen::Victima
      can :manage, Sivel2Gen::Victimacolectiva

      can :manage, Usuario
      can :manage, :tablasbasicas
      tablasbasicas.each do |t|
        c = Ability.tb_clase(t)
        can :manage, c
      end
    end

  end
end

