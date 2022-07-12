/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tracks.singlePlayer.evaluacion.src_YUSTE_LOPEZ_IGNACIO;

import ontology.Types.ACTIONS;
import tools.Vector2d;

public class Nodo{
    
    protected Nodo padre;   // Padre del nodo
    protected Nodo[] hijos; // Lista de hijos del nodo
    
    protected ACTIONS accion;   // Acción para llegar al nodo
    public Vector2d posicion;   // Posición del nodo en el mapa
    
    public Nodo(Nodo padre, ACTIONS accion, Vector2d posicion){
        this.padre = padre;
        this.accion = accion;
        hijos = new Nodo[4];
        this.posicion = posicion;
    }
    
    public Nodo(Nodo otro){
        this.padre = otro.getPadre();
        this.accion = otro.getAccion();
        this.hijos = otro.getHijos();
        this.posicion = otro.posicion;
    }
    
    // Crea la lista de hijos en el orden establecido
    public Nodo [] expandirNodo(){

        //Arriba
        hijos[0] = new Nodo(this, ACTIONS.ACTION_UP, new Vector2d(posicion.x, posicion.y-1));
        
        //Abajo
        hijos[1] = new Nodo(this, ACTIONS.ACTION_DOWN, new Vector2d(posicion.x, posicion.y+1));
        
        //Izquierda
        hijos[2] = new Nodo(this, ACTIONS.ACTION_LEFT, new Vector2d(posicion.x-1, posicion.y));
        
        //Derecha
        hijos[3] = new Nodo(this, ACTIONS.ACTION_RIGHT, new Vector2d(posicion.x+1, posicion.y));
        
        return hijos;
    }

    
    public Nodo getPadre() {
        return padre;
    }

    public Nodo[] getHijos() {
        return hijos;
    }

    public ACTIONS getAccion() {
        return accion;
    }

    @Override
    public boolean equals(Object o){
        Nodo nodoC = (Nodo) o;
        
        return nodoC.posicion.x == this.posicion.x && 
               nodoC.posicion.y == this.posicion.y;
    }    
}


