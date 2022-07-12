/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tracks.singlePlayer.evaluacion.src_YUSTE_LOPEZ_IGNACIO;

import core.game.Observation;
import core.game.StateObservation;
import core.player.AbstractPlayer;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Stack;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.Vector2d;

/**
 *
 * @author nacho
 */
public class AgentBFS extends AbstractPlayer{

    Stack<Types.ACTIONS> plan;
    Queue<Nodo> cola;
    ArrayList<Observation>[][] grid;
    
    Vector2d fescala, portal;
    
    Nodo objetivo;
    boolean planEncontrado;
    boolean[][] visitados;
    int nvisitados;
    
    public AgentBFS(StateObservation stateObs, ElapsedCpuTimer elapsedTime){
        
        //Inicializar plan y cola
        plan = new Stack<>();
        cola = new LinkedList<Nodo>();   
        
        //Iniciar plan a null
        planEncontrado = false;
        
        //Calcular valor de escala entre píxeles y puntos
        fescala = new Vector2d (stateObs.getWorldDimension().width / stateObs.getObservationGrid().length,
                                stateObs.getWorldDimension().height / stateObs.getObservationGrid()[0].length);
        
        //Obtención del portal más cercano
        ArrayList<Observation>[] posiciones = stateObs.getPortalsPositions(stateObs.getAvatarPosition());
        portal = posiciones[0].get(0).position;
        portal.x = Math.floor(portal.x / fescala.x);
        portal.y = Math.floor(portal.y / fescala.y);
        
        //Obtención del mapa y matriz de visitados
        grid = stateObs.getObservationGrid();
        visitados = new boolean[grid.length][grid[0].length];   //Rellenado a false por defecto
        nvisitados = 0;
        
    }
    
    @Override
    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {
                
        //Si no existe ningún plan llamamos al algoritmo para crearlo
        if(!planEncontrado){
            
            long tInicio = System.nanoTime();
            
            //Algoritmo de búsqueda
            BFS_Search(stateObs);   
            
            long tFin = System.nanoTime();
            long tiempoTotalEnMSegundos = (tFin-tInicio)/1000000;
            
            System.out.println("Tiempo de búsqueda: "+tiempoTotalEnMSegundos);
            System.out.println("Nodos expandidos: "+nvisitados);
            
            return Types.ACTIONS.ACTION_NIL;
        }
            
                    
        //Si existe devolvemos la siguiente acción del plan;
        else{
            
            //Si no existe ningún plan se fabrica
            if(plan.isEmpty()){
                Nodo nodo = objetivo;
                
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
    
    
    private void BFS_Search(StateObservation stateObs){
            
        Nodo inicial = new Nodo(null, Types.ACTIONS.ACTION_NIL, new Vector2d(stateObs.getAvatarPosition().x / fescala.x, stateObs.getAvatarPosition().y / fescala.y));

        visitados[(int)inicial.posicion.x][(int)inicial.posicion.y] = true;           
        cola.add(inicial);
        Nodo[] hijos;

        while(!cola.isEmpty() && !planEncontrado){
            Nodo u = cola.poll();
            
            // Si no es el portal seguimos buscando 
            if(u.posicion.x != portal.x || u.posicion.y != portal.y){

                hijos = u.expandirNodo();

                for(int i=0; i<hijos.length; i++){

                    if(esNodoValido(hijos[i])){
                        nvisitados++;
                        visitados[(int)hijos[i].posicion.x][(int)hijos[i].posicion.y] = true;
                        cola.add(hijos[i]);
                    }
                }
            }
            
            // Si es el portal guardamos el nodo cuyos padres llevan a él
            else{
                objetivo = u;
                planEncontrado = true; 
            }
        }
    }
    
    // Si el nodo está fuera del grid, es un obstaculo
    // o se ha visitado, no es un nodo válido
    private boolean esNodoValido(Nodo nodo){
        
        boolean inGrid = nodo.posicion.x>=0 && nodo.posicion.x < (grid.length) &&
                         nodo.posicion.y>=0 && nodo.posicion.y < (grid[0].length);        

        boolean esObstaculo = false;
        
        for(int i=0; i<grid[(int)nodo.posicion.x][(int)nodo.posicion.y].size() && !esObstaculo; i++)
            if(grid[(int)nodo.posicion.x][(int)nodo.posicion.y].get(i).itype == 0 || grid[(int)nodo.posicion.x][(int)nodo.posicion.y].get(i).itype == 4)
                esObstaculo = true;
        
       
        return !esObstaculo && inGrid && !visitados[(int)nodo.posicion.x][(int)nodo.posicion.y];
    }

}
