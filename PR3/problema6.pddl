(define (problem ejercicio6) 
    (:domain dominioStarCraft_ej6)
    (:objects 
        VCE1 VCE2 VCE3 Marine1 Marine2 Soldado1 - Unidad
        CentroDeMando1 Extractor1 Barracones1 Bahia1 - Edificio
        Inv - Investigacion
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
        (edificioEs Bahia1 BahiaIngenieria)

        (entidadEn VCE1 LOC11)
        (unidadReclutada VCE1)

        (unidadEs VCE1 VCE)
        (unidadEs VCE2 VCE)
        (unidadEs VCE3 VCE)
        (unidadEs Soldado1 Soldado)
        (unidadEs Marine1 Marine)
        (unidadEs Marine2 Marine)

        (necesitaInvestigacion Soldado)
        (investigacionEs Inv InvSoldado)
        (recursoParaInvestigar InvSoldado Mineral)
        (recursoParaInvestigar InvSoldado Gas)
        
        (seReclutaEn VCE CentroDeMando)
        (seReclutaEn Soldado Barracones)
        (seReclutaEn Marine Barracones)
        
        (recursoEn LOC22 Mineral)
        (recursoEn LOC32 Mineral)
        (recursoEn LOC44 Gas)

        (recursoParaConstruir Extractor Mineral)
        (recursoParaConstruir Barracones Mineral)
        (recursoParaConstruir Barracones Gas)

        (recursoParaReclutar VCE Mineral)
        (recursoParaReclutar Marine Mineral)
        (recursoParaReclutar Soldado Mineral)
        (recursoParaReclutar Soldado Gas)

        (= (tamPlan) 0)
        
    )

    (:goal (and
            (entidadEn Barracones1 LOC32)
            (entidadEn Marine1 LOC31)
            (entidadEn Marine2 LOC24)
            (entidadEn Soldado1 LOC12)
            ;(< (tamPlan) 29) ;tamaño óptimo del plan
    )
    )
)

