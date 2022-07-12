
(define (domain dominioStarCraft_ej1)

(:requirements :strips :adl :fluents )

(:types 
    Entidad Localizacion Recurso TipoUnidad TipoEdificio - object
    Unidad Edificio - Entidad
)

(:constants
    VCE - TipoUnidad
    CentroDeMando Barracon - TipoEdificio
    Mineral Gas - Recurso
)

(:predicates
    (conectado ?x -Localizacion ?y - Localizacion)

    (entidadEn ?x - Entidad ?y - Localizacion)
    (edificioConstruido ?e - Edificio)
    (unidadExtrayendo ?x - Unidad)             
    (recursoEn ?x - Localizacion ?y - Recurso)
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

 :(:action Asignar
    :parameters (?u - Unidad ?l - Localizacion ?r - Recurso)
    :precondition (and 
        ;Solo asignamos unidades sin asignar si están en un nodo con recursos
        (recursoEn ?l ?r)
        (entidadEn ?u ?l)  
        (not (unidadExtrayendo ?u))
    )
    :effect (and 
        (unidadExtrayendo ?u)
    )
 )

)