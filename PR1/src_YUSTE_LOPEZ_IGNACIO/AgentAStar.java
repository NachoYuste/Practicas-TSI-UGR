/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tracks.singlePlayer.evaluacion.src_YUSTE_LOPEZ_IGNACIO;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.PriorityQueue;
import java.util.SortedSet;
import java.util.Stack;
import java.util.TreeSet;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.Vector2d;


public class AgentAStar extends AbstractPlayer{
    
    PriorityQueue<NodoH> abiertos;
    PriorityQueue<NodoH> cerrados;
    Vector2d fescala, portal;
    NodoH objetivo;
    
    ArrayList<Observation>[][] grid;

    int nvisitados;
    int maxMemoria;
    
    Stack<Types.ACTIONS> plan;
    boolean planEncontrado;

    
    public AgentAStar(StateObservation stateObs, ElapsedCpuTimer elapsedTime){
        
        //Inicializar las colas
        abiertos = new PriorityQueue<>();
        cerrados = new PriorityQueue<>();
        
        //Calcular valor de escala entre píxeles y puntos
        fescala = new Vector2d (stateObs.getWorldDimension().width / stateObs.getObservationGrid().length,
                                stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);
        
        //Obtención del portal más cercano
        ArrayList<Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());
        portal = posiciones[0].get(0).position;
        portal.x = Math.floor(portal.x / fescala.x);
        portal.y = Math.floor(portal.y / fescala.y);
        
        //Inicializar plan
        plan = new Stack<>();
        planEncontrado = false;
        
        //Inicializar mapa
        grid = stateObs.getObservationGrid();
        
        //Inicializar contador de memoria
        nvisitados = 0;
        maxMemoria = 0;
    }
    
    @Override
    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
        
        //Si no existe ningún plan llamamos al algoritmo para crearlo
        if(!planEncontrado){
               
            long tInicio = System.nanoTime();
            
            //Algoritmo de búsqueda
            AStar_search(stateObs);   
            
            
            long tFin = System.nanoTime();
            long tiempoTotalEnMSegundos = (tFin-tInicio)/1000000;
            
            System.out.println("Tiempo de búsqueda: "+tiempoTotalEnMSegundos);
            System.out.println("Nodos expandidos: "+nvisitados);
            System.out.println("Memoria: " +maxMemoria);
            
            return Types.ACTIONS.ACTION_NIL;
        }
        
        //Si existe devolvemos la siguiente acción del plan;
        else{
            //Si no existe ningún plan se fabrica
            if(plan.isEmpty()){
                NodoH nodo = objetivo;
                
                //Recorremos los nodos padre mientras existan y guardamos las acciones en el plan
                while(nodo != null){
                    
                    if(nodo.padre!=null){
                        plan.push(nodo.getAccion());
                    }
                    
                    nodo = nodo.padre;
                }
                 System.out.println("Tamaño de la ruta: " +plan.size());

            }
                 
            return plan.pop();
        }
    }
    
    
    private void AStar_search(StateObservation stateObs){
        Vector2d avatarPos = new Vector2d(stateObs.getAvatarPosition().x / fescala.x, stateObs.getAvatarPosition().y / fescala.y);
        int manhattan = (int) (Math.abs(avatarPos.x - portal.x) + Math.abs(avatarPos.y - portal.y));    
        NodoH inicial = new NodoH(null, Types.ACTIONS.ACTION_NIL, avatarPos, manhattan,0);
                
        abiertos.add(inicial);

        NodoH nodo;
        NodoH[] hijos;
        
        // Mientras no se encuentre el plan seguimos buscando
        while(!planEncontrado && !abiertos.isEmpty()){
            
            // Extraemos el mejor nodo de abiertos
            nodo = abiertos.poll();
            

            abiertos.remove(nodo);
            // Añadimos el nodo a la lista de visitados
            cerrados.add(nodo);
            
            if(!nodo.posicion.equals(portal)){
                nvisitados++;
                // Expandimos el nodo
                hijos = nodo.expandirNodo(portal);
                
                //Por cada hijo válido del nodo comprobamos:
                for(int i=0; i<hijos.length; i++){
                    
                    if(esNodoValido(hijos[i]) && !hijos[i].equals(nodo.padre)){

                        // Si ya lo hemos visitado pero tenemos un nuevo camino mejor lo sacamos de cerrados y lo añadimos a abiertos
                        if(cerrados.contains(hijos[i]) && mejorCaminoA(hijos[i])){
                            ArrayList<NodoH> cerrados_array= new ArrayList<NodoH>(Arrays.asList(cerrados.toArray(new NodoH[cerrados.size()])));
                            NodoH hijoCerrados = cerrados_array.get(cerrados_array.indexOf(hijos[i]));
                            if(hijoCerrados.f > hijos[i].f){
                                cerrados.remove(hijos[i]);
                                abiertos.add(hijos[i]);  //Lo quitamos de cerrados y lo añadimos a abiertos
                            }
                        }
                        
                        // Si es la primera vez que vemos el nodo lo añadimos a abiertos
                        if(!cerrados.contains(hijos[i]) && !abiertos.contains(hijos[i])){                            
                            abiertos.add(hijos[i]); 
                        }                        

                        // Si ya estaba en abiertos pero tenemos un camino mejor lo actualizamos
                        else if(abiertos.contains(hijos[i]) && mejorCaminoA(hijos[i])){
                            ArrayList<NodoH> abiertos_array= new ArrayList<NodoH>(Arrays.asList(abiertos.toArray(new NodoH[abiertos.size()])));
                            NodoH hijoAbiertos = abiertos_array.get(abiertos_array.indexOf(hijos[i]));
                            if(hijoAbiertos.f > hijos[i].f){
                                abiertos.remove(hijoAbiertos);
                                abiertos.add(hijos[i]);                                 
                            }
                        }
                    }
                }                    
            }
            else{
                planEncontrado = true;
                objetivo = nodo;

            }
            
            //Actualizacion de contador de memoria
            int max = Math.max(abiertos.size(), cerrados.size());
            if(max>maxMemoria)
                maxMemoria = max;
                        
        }
    }
    
    
    // Comprueba si un nodo lleva un mejor camino que el que ya está en abiertos
    private boolean mejorCaminoA(NodoH nuevo){
        
        var it = abiertos.iterator();
        boolean encontrado = false;
        NodoH nodoAbierto;
        while(it.hasNext() && !encontrado){
            nodoAbierto = it.next();

            if(nodoAbierto.posicion.x == nuevo.posicion.x && nodoAbierto.posicion.y == nuevo.posicion.y){
                
                if(nuevo.compareTo(nodoAbierto) == 1){
                    encontrado = true;
                    return true;    // Es mejor nodo
                }
                else{
                    return false;
                }
            }
        }

        return true;    //No está en la lista por lo que es mejor

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

}
    

