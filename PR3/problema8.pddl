(define (problem ejercicio8) 
    (:domain dominioStarCraft_ej8)
    (:objects 
        VCE1 VCE2 VCE3 Marine1 Marine2 Soldado1 - Unidad
        CentroDeMando1 Extractor1 Barracones1 - Edificio
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

        (entidadEn VCE1 LOC11)
        (unidadReclutada VCE1)

        (unidadEs VCE1 VCE)
        (unidadEs VCE2 VCE)
        (unidadEs VCE3 VCE)
        (unidadEs Soldado1 Soldado)
        (unidadEs Marine1 Marine)
        (unidadEs Marine2 Marine)

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

        (= (cantidadRecurso Mineral) 0)
        (= (cantidadRecurso Gas) 0)
        
        (= (cantidadParaUnidad VCE Mineral) 5)
        
        (= (cantidadParaUnidad Marine Mineral) 10)
        (= (cantidadParaUnidad Marine Gas) 15)
        
        (= (cantidadParaUnidad Soldado Mineral) 30)
        (= (cantidadParaUnidad Soldado Gas) 30)

        (= (cantidadParaEdificio Extractor Mineral) 10)
        (= (cantidadParaEdificio Extractor Gas) 0)

        (= (cantidadParaEdificio Barracones Mineral) 10)
        (= (cantidadParaEdificio Barracones Gas) 10)

        (= (costeTiempo) 0)

        (= (costeTiempoConstruirEdificio Barracones) 50)
        (= (costeTiempoConstruirEdificio Extractor) 20)

        (= (costeTiempoReclutarUnidad VCE) 10)
        (= (costeTiempoReclutarUnidad Marine) 20)
        (= (costeTiempoReclutarUnidad Soldado) 30)

        (= (costeTiempoMover VCE) 20)
        (= (costeTiempoMover Marine) 4)
        (= (costeTiempoMover Soldado) 2)


        

    )

    (:goal (and
            (entidadEn Barracones1 LOC32)
            (entidadEn Marine1 LOC31)
            (entidadEn Marine2 LOC24)
            (entidadEn Soldado1 LOC12)
            ;(< (costeTiempo) 478)
            ;(< (tamPlan) 41) ;tamaño óptimo del plan
    )
    )
    
    (:metric minimize (costeTiempo))
)

