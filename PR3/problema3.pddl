(define (problem ejercicio3) 
    (:domain dominioStarCraft_ej3)
    (:objects 
        VCE1 VCE2 VCE3 - Unidad
        CentroDeMando1 Extractor1 Barracones1 - Edificio
        LOC11 LOC12 LOC13 LOC14 LOC21 LOC22 LOC23 LOC24 LOC31 LOC32 LOC33 LOC34 LOC44 - Localizacion
    )

    (:init
        ;MAPA
        (conectado LOC11 LOC12) (conectado LOC12 LOC11)
        (conectado LOC11 LOC21) (conectado LOC21 LOC11)
        (conectado LOC12 LOC22) (conectado LOC22 LOC12)
        (conectado LOC21 LOC31) (conectado LOC31 LOC21)
        (conectado LOC31 LOC32) (conectado LOC32 LOC31)
        (conectado LOC32 LOC22) (conectado LOC22 LOC32)
        (conectado LOC22 LOC23) (conectado LOC23 LOC22)
        (conectado LOC23 LOC13) (conectado LOC13 LOC23)
        (conectado LOC13 LOC14) (conectado LOC14 LOC13)
        (conectado LOC14 LOC24) (conectado LOC24 LOC14)
        (conectado LOC24 LOC34) (conectado LOC34 LOC24)
        (conectado LOC34 LOC44) (conectado LOC44 LOC24) (conectado LOC34 LOC33) (conectado LOC33 LOC34)
        (conectado LOC33 LOC23) (conectado LOC23 LOC33)

        (entidadEn CentroDeMando1 LOC11)
        (edificioConstruido CentroDeMando1)

        (edificioEs Extractor1 Extractor)
        (edificioEs CentroDeMando1 CentroDeMando)
        (edificioEs Barracones1 Barracones)

        (entidadEn VCE1 LOC11)
        (entidadEn VCE2 LOC11)
        (entidadEn VCE3 LOC11)

        (unidadEs VCE1 VCE)
        (unidadEs VCE2 VCE)
        (unidadEs VCE3 VCE)
        
        (recursoEn LOC22 Mineral)
        (recursoEn LOC32 Mineral)
        (recursoEn LOC44 Gas)

        (recursoPara Extractor Mineral)
        (recursoPara Barracones Mineral)
        (recursoPara Barracones Gas)
        
    )

    (:goal (and
            (entidadEn Barracones1 LOC33)
        )
    )
)

