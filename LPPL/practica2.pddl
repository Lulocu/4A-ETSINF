(define (domain practica2)
(:requirements :durative-actions :typing :fluents)
(:types persona ciudad - object)
(:predicates (at ?p - persona ?c - ciudad)
             (residente ?p - person))
             (tiene-ticket ?p - person))
             (conexion-bus ?c1 - ciudad ?c2 - ciudad))
             (conexion-metro ?c1 - ciudad ?c2 - ciudad))
             (conexion-tren ?c1 - ciudad ?c2 - ciudad))
(:functions (distancia-ciudades ?c1 - ciudad ?c2 - ciudad)
            (velocidad-metro)
            (velocidad-tren)
            (velocidad-bus)
            (precio-bonometro)
            (precio-tren)
            (viajes-bono ?p - persona)
            (dinero-persona ?p - persona)
            (coste-total)
            )


(:durative-action viajar-bus
 :parameters (?p - persona ?c1 - ciudad ?c2 - ciudad)
 :duration (= ?duration (/ (distancia-ciudades ?c1 ?c2) (velocidad-bus)))
 :condition (and (at start (at ?p ?c1))
                 (and (conexion-bus ?c1 ?c2)
                 (residente ?p)))
 :effect (and (at start (not (at ?p ?c1)))
              (at end (at ?p ?c2))))

(:durative-action viajar-metro
 :parameters (?p - persona ?c1 - ciudad ?c2 - ciudad)
 :duration (= ?duration (/ (distancia-ciudades ?c1 ?c2) (velocidad-metro)))
 :condition (and (at start (at ?p ?c1))
                 (and (conexion-metro ?c1 ?c2)
                 (> (viajes-bono ?p) 0)))
 :effect (and (at start (not (at ?p ?c1)))
              (at end (at ?p ?c2))))

(:durative-action viajar-tren
 :parameters (?p - persona ?c1 - ciudad ?c2 - ciudad)
 :duration (= ?duration (/ (distancia-ciudades ?c1 ?c2) (velocidad-tren)))
 :condition (and (at start (at ?p ?c1))
                 (and (conexion-tren ?c1 ?c2)
                 (tiene-ticket ?p)))
 :effect (and (at start (not (at ?p ?c1)))
              (at end (at ?p ?c2))))

(:durative-action recargar-bono
 :parameters (?p - persona)
 :duration (= ?duration 0)
 :condition (at start (> (dinero-persona ?p) (precio-bonometro))
 :effect (and (at start (= (dinero-persona ?p) (- (dinero-persona ?p) (precio-bonometro))))
              (at end (= (viajes-bono ?p) (+ (viajes-bono ?p) 10)))))

(:durative-action comprar-ticket
 :parameters (?p - persona)
 :duration (= ?duration 0)
 :condition (at start (> (dinero-persona ?p) (precio-tren))
 :effect (and (at start (= (dinero-persona ?p) (- (dinero-persona ?p) (precio-tren))))
              (at end (tiene-ticket ?p))))


)
