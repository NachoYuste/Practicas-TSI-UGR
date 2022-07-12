(define (domain dominioStarCraft_ej4)

(:requirements :strips :adl :fluents )

(:types
    Entidad Localizacion Recurso TipoUnidad TipoEdificio - object
    Unidad Edificio - Entidad
)

;Las constantes se usarán como tipos de datos
(:constants
    VCE Marine Soldado - TipoUnidad
    CentroDeMando Barracones Extractor - TipoEdificio
    Mineral Gas - Recurso
)

(:predicates
    ;conecta dos ubicaciones del mapa
    (conectado ?x - Localizacion ?y - Localizacion)

    ;un edificio o unidad está en una localización
    (entidadEn ?u - Entidad ?l - Localizacion)
    
    ;la unidad está asignada a un nodo y extrayendo minerales
    (unidadExtrayendo ?u - Unidad)

    (unidadReclutada ?u - Unidad)
    (edificioConstruido ?e - Edificio)

    ;un recurso se encuentra en una localización
    (recursoEn ?l - Localizacion ?r - Recurso)

    ;se ha asignado un VCE a un nodo de recurso por lo que se dispone de él
    (recursoObtenido ?r - Recurso)
    
    ;predicados para definir el tipo de entidad
    (edificioEs ?e - Edificio ?y - TipoEdificio)
    (unidadEs ?u - Unidad ?tu - TipoUnidad)

    ;recurso necesario para la construcción de un tipo de edificio
    (recursoParaConstruir ?te - TipoEdificio ?r - Recurso)
    (recursoParaReclutar ?tu - TipoUnidad ?r - Recurso)

    ;definir donde se reclutan las unidades
    (seReclutaEn ?tu - TipoUnidad ?te - TipoEdificio)
)


(:action Navegar
    :parameters (?u - Unidad ?x ?y - Localizacion)
    :precondition(and
        (not (unidadExtrayendo ?u))
        (entidadEn ?u ?x) 
        (conectado ?x ?y)
        (unidadReclutada ?u)

    )
    :effect (and 
        (entidadEn ?u ?y)
        (not (entidadEn ?u ?x))
    )
)

 (:action Asignar
    :parameters (?u - Unidad ?l - Localizacion ?r - Recurso)
    :precondition (and
        ;Solo asignamos unidades sin asignar si están en un nodo con recursos
        (recursoEn ?l ?r)
        (not (unidadExtrayendo ?u))
        (entidadEn ?u ?l)
        (unidadReclutada ?u)

        ;si es un nodo de gas comprobamos primero si hay un extractor en esa ubicación
        (imply (and (recursoEn ?l Gas))
            (and (exists (?e - Edificio) (and (entidadEn ?e ?l) (edificioEs ?e Extractor) )))
        )

    )
    :effect (and
        ;asignamos la unidad al nodo y empezamos a extraer recursos
        (when (recursoEn ?l Mineral)
            (and
                (unidadExtrayendo ?u)
                (recursoObtenido ?r)
            )
        )
        (when (and (recursoEn ?l Gas))
            (and
                (unidadExtrayendo ?u)
                (recursoObtenido ?r)
            )
        )     
    )
 )

(:action Construir
    :parameters (?u - Unidad ?e - Edificio ?l - Localizacion)
    :precondition (and
        ;una unidad sin asignar se encuentra ahí
        (not (unidadExtrayendo ?u))
        (entidadEn ?u ?l)
        (unidadReclutada ?u)
        
        ;precondicion "redundante" que puede acotar el espacio de búsqueda
        (not (entidadEn ?e ?l)) 
        
        ;el edificio no puede estar ya construido
        (not (edificioConstruido ?e ))

        ;el extractor debe estar en un nodo con gas vespeno
        (imply (edificioEs ?e Extractor)
            (and (recursoEn ?l Gas))
        )

        ;no puede haber más edificios en la localización
        ;para todos los edificios, o no está construido o lo está pero en otra localización
        (forall (?ed - Edificio)
            (or 
                (not (edificioConstruido ?ed))
                (and (edificioConstruido ?ed) (not (entidadEn ?ed ?l)))   
            )
        )

        ;se deben tener los recursos necesarios para el tipo de edificio
        (exists (?te - TipoEdificio) 
            (and
                (edificioEs ?e ?te)

                ;para todos los recursos, el edificio no necesita el recurso o lo necesita y se está extrayendo
                (forall (?r - Recurso)
                    (or
                        (not (recursoParaConstruir ?te ?r))
                        (and
                            (recursoParaConstruir ?te ?r)
                            (recursoObtenido ?r)
                        )
                    )
                )
            )
        )
    )

    :effect (and
        ;construimos el edificio que se solicite
        (entidadEn ?e ?l)
        (edificioConstruido ?e)
    )
      
)  


(:action Reclutar
    :parameters (?e - Edificio ?u - Unidad ?l - Localizacion)
    :precondition (and
        (entidadEn ?e ?l)
        
        ;el edificio donde se recluta se ha construido
        (edificioConstruido ?e)
        

        ;comprobamos si la unidad ya ha sido reclutada
        (not (unidadReclutada ?u))
        (not (entidadEn ?u ?l)) ;comprobación "redundante" que puede acotar el espacio de búsqueda

        (exists (?tu - TipoUnidad)
            (and
                (unidadEs ?u ?tu)

                ;el edificio es del tipo que la unidad necesita
                (exists (?te - TipoEdificio) (and (edificioEs ?e ?te) (seReclutaEn ?tu ?te)))                
                
                ;para todos los recursos, la unidad no lo necesita o lo necesita y se está extrayendo
                (forall (?r - Recurso)
                    (or
                        (not (recursoParaReclutar ?tu ?r))
                        (and
                            (recursoParaReclutar ?tu ?r)
                            (recursoObtenido ?r)
                        )
                    )
                )
            )
        )

    )
    :effect (and
       (unidadReclutada ?u)
       (entidadEn ?u ?l)
    )
)


)