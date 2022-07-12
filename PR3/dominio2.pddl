(define (domain dominioStarCraft_ej2)

(:requirements :strips :adl :fluents )

(:types
    Entidad Localizacion Recurso TipoUnidad TipoEdificio - object
    Unidad Edificio - Entidad
)

;Las constantes se usarán como tipos de datos
(:constants
    VCE - TipoUnidad
    CentroDeMando Barracon Extractor - TipoEdificio
    Mineral Gas - Recurso
)

(:predicates
    (conectado ?x - Localizacion ?y - Localizacion)

    (entidadEn ?u - Entidad ?l - Localizacion)
    (unidadExtrayendo ?u - Unidad)

    (edificioConstruido ?e - Edificio)

    (recursoEn ?l - Localizacion ?r - Recurso)
    (recursoObtenido ?r - Recurso)
    
    ;predicados para conocer el tipo de objeto
    (edificioEs ?e - Edificio ?y - TipoEdificio)
    (recursoPara ?te - TipoEdificio ?r - Recurso)
)


(:action Navegar
    :parameters (?u - Unidad ?x ?y - Localizacion)
    :precondition(and
        (not (unidadExtrayendo ?u))
        (entidadEn ?u ?x) 
        (conectado ?x ?y)
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

        ;si es un nodo de gas comprobamos primero si hay un extractor en esa ubicación
        (imply (and (recursoEn ?l Gas))
            (and (exists (?e - Edificio) (and (entidadEn ?e ?l) (edificioEs ?e Extractor) )))
        )

    )
    :effect (and
        ;si es un nodo de mineral, lo asignamos sin más
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
    :parameters (?u - Unidad ?e - Edificio ?l - Localizacion ?r - Recurso )
    :precondition (and
        ;una unidad sin asignar se encuentra ahí
        (not (unidadExtrayendo ?u))
        (entidadEn ?u ?l)
        
        ;el edificio no puede estar ya construido
        (not (edificioConstruido ?e ))

        ;no puede haber más edificios en la localización
        ;para todos los edificios, o no está construido o lo está pero en otra localización
        (forall (?ed - Edificio)
            (or 
                (not (edificioConstruido ?ed))
                (and (edificioConstruido ?e) (not (entidadEn ?ed ?l)))   
            )
        )

        ;se deben tener los recursos necesarios para el tipo de edificio
        (exists (?te - TipoEdificio) 
            (and
                (edificioEs ?e ?te)
                (recursoPara ?te ?r)
                (recursoObtenido ?r)
            )
        )
    )
    :effect (and
        ;construimos un extractor si tenemos los recursos necesarios
        (when (and (edificioEs ?e Extractor))
            (and (entidadEn ?e ?l) (edificioConstruido ?e))
        )
    )
    )
 )
 
