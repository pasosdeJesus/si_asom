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
    Sip::Ability::BASICAS_PROPIAS + 
      Heb412Gen::Ability::BASICAS_PROPIAS + 
      Cor1440Gen::Ability::BASICAS_PROPIAS +
      Sivel2Gen::Ability::BASICAS_PROPIAS + 
      BASICAS_PROPIAS
  end

  BASICAS_ID_NOAUTO = []

  def basicas_id_noauto 
    Sip::Ability::BASICAS_ID_NOAUTO +
      Heb412Gen::Ability::BASICAS_ID_NOAUTO +
      Cor1440Gen::Ability::BASICAS_ID_NOAUTO +
      Sivel2Gen::Ability::BASICAS_ID_NOAUTO +
      BASICAS_ID_NOAUTO
  end

  NOBASICAS_INDSEQID = [
  ]

  def nobasicas_indice_seq_con_id 
    Sip::Ability::NOBASICAS_INDSEQID +
      Heb412Gen::Ability::NOBASICAS_INDSEQID +
      Cor1440Gen::Ability::NOBASICAS_INDSEQID +
      Sivel2Gen::Ability::NOBASICAS_INDSEQID +
      NOBASICAS_INDSEQID
  end

  BASICAS_PRIO = []

  def tablasbasicas_prio 
    Sip::Ability::BASICAS_PRIO +
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
    can :read, [Sip::Pais, Sip::Departamento, Sip::Municipio, Sip::Clase]

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

      if usuario.sip_grupo &&
          usuario.sip_grupo.pluck(:id).include?(GRUPO_ANALISTA_CASOS)

        # Proveniente de sivel2_gen
        # Hacer conteos
        can :cuenta, Sivel2Gen::Caso

        can :buscar, Sivel2Gen::Caso
        can :contar, Sivel2Gen::Caso
        can :lista, Sivel2Gen::Caso

        can [:read, :update], Mr519Gen::Encuestausuario
        can :read, Sip::Orgsocial

        can :descarga_anexo, Sip::Anexo

        can :contar, Sip::Ubicacion
        can :nuevo, Sip::Ubicacion

        can :nuevo, Sivel2Gen::Combatiente

        can :nuevo, Sivel2Gen::Presponsable

        can :nuevo, Sivel2Gen::Victima

        can :nuevo, Sivel2Gen::Victimacolectiva

        can :read, Heb412Gen::Doc
        can :read, Heb412Gen::Plantilladoc
        can :read, Heb412Gen::Plantillahcm
        can :read, Heb412Gen::Plantillahcr
        can :index, Sivel2Gen::Victima

        can :manage, Sip::Bitacora, usuario: { id: usuario.id }

        can [:read, :new, :edit, :update, :create],
          Sip::Orgsocial
        can :read, Sip::Bitacora
        can :manage, Sip::Persona

        can :manage, Sivel2Gen::Acto
        can :manage, Sivel2Gen::Actocolectivo
        can [:read, :new, :edit, :update, :create, :nuevo, :destroy], Sivel2Gen::Caso

        cannot :solocambiaretiquetas, Sivel2Gen::Caso
        can :refresca, Sivel2Gen::Caso

        can :read, Sivel2Gen::Victima

      end


    when Ability::ROLADMIN, Ability::ROLDIR

      # Proveniente de sivel2_gen
      can :manage, Heb412Gen::Doc
      can :manage, Heb412Gen::Plantilladoc
      can :manage, Heb412Gen::Plantillahcm
      can :manage, Heb412Gen::Plantillahcr

      can :manage, Mr519Gen::Formulario
      can :manage, Mr519Gen::Encuestausuario 

      can :manage, Sip::Orgsocial
      can :manage, Sip::Bitacora
      can :manage, Sip::Persona
      can :manage, Sip::Respaldo7z

      can :manage, Sivel2Gen::Acto
      can :manage, Sivel2Gen::Actocolectivo
      can :manage, Sivel2Gen::Caso
      cannot :solocambiaretiquetas, Sivel2Gen::Caso
      can :read, Sivel2Gen::Victima

      can :manage, Usuario
      can :manage, :tablasbasicas
      tablasbasicas.each do |t|
        c = Ability.tb_clase(t)
        can :manage, c
      end
    end

  end
end

