/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tracks.singlePlayer.evaluacion.src_YUSTE_LOPEZ_IGNACIO;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import java.util.ArrayList;
import java.util.Stack;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.Vector2d;


public class AgentIDAStar extends AbstractPlayer{
    Stack<Types.ACTIONS> plan;
    Stack<NodoH> ruta;
    int cota, t;
    int nvisitados;
    
    Vector2d fescala, portal;
    ArrayList<Observation>[][] grid;

    
    NodoH objetivo;
    boolean planEncontrado;

    
    public AgentIDAStar(StateObservation stateObs, ElapsedCpuTimer elapsedTime){
        
        //Inicializar pilas y cota;
        plan = new Stack<>();
        ruta = new Stack<>();
        cota = -1;  // Usaremos -1 como valor infinito
        
        //Calcular valor de escala entre píxeles y puntos
        fescala = new Vector2d (stateObs.getWorldDimension().width / stateObs.getObservationGrid().length,
                                stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);
        
        //Obtención del portal más cercano
        ArrayList<Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());
        portal = posiciones[0].get(0).position;
        portal.x = Math.floor(portal.x / fescala.x);
        portal.y = Math.floor(portal.y / fescala.y);
        
        //Inicializar mapa
        grid = stateObs.getObservationGrid();        

        planEncontrado = false;  
        nvisitados = 0;
    }
    
    @Override
    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
     if(!planEncontrado){
            
            long tInicio = System.nanoTime();
            
            Vector2d avatarPos = new Vector2d(stateObs.getAvatarPosition().x / fescala.x, stateObs.getAvatarPosition().y / fescala.y);
            double manhattan = Math.abs(avatarPos.x - portal.x) + Math.abs(avatarPos.y - portal.y);      
            NodoH inicial = new NodoH(null, Types.ACTIONS.ACTION_NIL, new Vector2d(stateObs.getAvatarPosition().x / fescala.x, stateObs.getAvatarPosition().y / fescala.y), (int) manhattan, 0);
                    
            // Iniciamos la primera cota al valor heurístico del nodo inicial y lo añadimos a la ruta
            cota = inicial.h;
            ruta.push(inicial);            

            // Cada vez que se llegue a la cota y no se encuentre el objetivo
            // actualizamos la cota y volvemos a buscar con la nueva cota
            while(!planEncontrado){              
                t = IDAStar_search();
                cota = t;
            }
                                
            long tFin = System.nanoTime();
            long tiempoTotalEnMSegundos = (tFin-tInicio)/1000000;

            System.out.println("Tiempo de búsqueda: "+tiempoTotalEnMSegundos);
            System.out.println("Memoria: "+ t);
            System.out.println("Nodos expandidos: "+nvisitados);
            
            NodoH nodo = objetivo;
            int tamRuta = 0;
            while(nodo!=null){
                tamRuta++;
                nodo = nodo.padre;
            }
            System.out.println("Tamaño de la ruta: " +tamRuta);
            return Types.ACTIONS.ACTION_NIL;
        }
                    
        //Si existe devolvemos la siguiente acción del plan;
        else{
            
            //Si no existe el plan se fabrica
            if(plan.isEmpty()){
                NodoH nodo = objetivo;
                
                //Recorremos los nodos padre mientras existan y guardamos las acciones en el plan
                while(nodo != null){
                    
                    if(nodo.getPadre() != null){
                        plan.push(nodo.getAccion());
                    }
                    nodo = nodo.getPadre();
                }
                System.out.println("Tamaño de la ruta: " +plan.size());
            }

            return plan.pop();
            
        }
    }
    
    
    
    private int IDAStar_search(){
        NodoH nodo = ruta.lastElement();
        
        nvisitados++;
        
        // Si encontramos el portal guardamos el nodo objetivo y devolvemos la cota actual
        if(nodo.posicion.equals(portal)){
            objetivo = nodo;
            planEncontrado = true;
            return cota;
        }
        
        // Si superamos la cota devolvemos el valor que la ha superado
        if(nodo.f > cota){
            return nodo.f;
        }
        
        int min = Integer.MAX_VALUE;
        
        //Expando el nodo y ordeno los hijos
        NodoH[] hijos = ordenaVector(nodo.expandirNodo(portal));
        
        for(NodoH v : hijos){
            
            if(!ruta.contains(v) && esNodoValido(v)){
                ruta.push(v);

                t = IDAStar_search();
                
                // Si encontramos el objetivo no actualizamos el mínimo y devolvemos el t actual
                if(planEncontrado)
                    return t;
                
                // Calculamos el valor mínimo de los hijos para actualizar la cota 
                if(t < min)
                    min =(int) t;
                
                ruta.pop();
            }
            
        }
        
        // Devolvemos el valor mínimo alcanzado
        return min;        
    }
    
    
    // Si el nodo está fuera del grid, es un obstaculo
    // o se ha visitado, no es un nodo válido
    private boolean esNodoValido(NodoH nodo){
        
        boolean inGrid = nodo.posicion.x>=0 && nodo.posicion.x < (grid.length) &&
                         nodo.posicion.y>=0 && nodo.posicion.y < (grid[0].length);        

        boolean esObstaculo = false;
        
        for(int i=0; i<grid[(int)nodo.posicion.x][(int)nodo.posicion.y].size() && !esObstaculo; i++)
            if(grid[(int)nodo.posicion.x][(int)nodo.posicion.y].get(i).itype == 0 || grid[(int)nodo.posicion.x][(int)nodo.posicion.y].get(i).itype == 4)
                esObstaculo = true;
        
       
        return !esObstaculo && inGrid;
    }
    
    
    //Algoritmo bubble sort para ordenar los hijos de los nodos
    private NodoH[] ordenaVector(NodoH[] v){
        boolean ordenado = false;
        NodoH aux;
        
        while(!ordenado){
            ordenado = true;
            
            for(int i=0; i<v.length-1; i++){
                if(v[i].f > v[i+1].f){
                    aux = v[i];
                    v[i] = v[i+1];
                    v[i+1] = aux;
                    ordenado = false;
                }
            }
        }
        
        return v;
    }
    
}
