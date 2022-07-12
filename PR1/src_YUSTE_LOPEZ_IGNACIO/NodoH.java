/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tracks.singlePlayer.evaluacion.src_YUSTE_LOPEZ_IGNACIO;

import java.util.Objects;
import ontology.Types.ACTIONS;
import tools.Vector2d;

public class NodoH implements Comparable<NodoH>{
    
    protected int f; //Coste total del nodo
    protected int g; //Coste estimado del nodo
    protected int h; //Valor heurístico
    
    protected NodoH padre;  // Padre del nodo
    protected NodoH[] hijos;    // Lista de hijos del nodo
    
    protected ACTIONS accion;   // Acción para llegar al nodo
    public Vector2d posicion;   // Posición en el mapa
    
    public NodoH(NodoH padre, ACTIONS accion, Vector2d posicion, int h, int g){
        this.padre = padre;
        this.accion = accion;
        hijos = new NodoH[4];
        this.posicion = posicion;
        
        f = g+h;
    }
    
    public NodoH(NodoH otro){
        this.padre = otro.getPadre();
        this.accion = otro.getAccion();
        this.hijos = otro.getHijos();
        this.posicion = otro.posicion;
        this.f = otro.f;
        this.g = otro.g;
        this.h = otro.h;
    }
    
    // Crea la lista de hijos en el orden establecido
    // calcula el coste y el valor heurístico de cada hijo
    public NodoH[] expandirNodo(Vector2d pos_objetivo){
        
        Vector2d vecAux;
        
        //Arriba
        vecAux = new Vector2d(posicion.x, posicion.y-1);
        hijos[0] = new NodoH(this, ACTIONS.ACTION_UP, vecAux,(int)distanciaManhattan(vecAux, pos_objetivo), this.g+1);
        
        //Abajo
        vecAux = new Vector2d(posicion.x, posicion.y+1);
        hijos[1] = new NodoH(this, ACTIONS.ACTION_DOWN, vecAux, (int)distanciaManhattan(vecAux, pos_objetivo), this.g+1);
        
        //Izquierda
        vecAux = new Vector2d(posicion.x-1, posicion.y);
        hijos[2] = new NodoH(this, ACTIONS.ACTION_LEFT, vecAux, (int)distanciaManhattan(vecAux, pos_objetivo), this.g+1);
        
        //Derecha
        vecAux = new Vector2d(posicion.x+1, posicion.y);
        hijos[3] = new NodoH(this, ACTIONS.ACTION_RIGHT, vecAux, (int)distanciaManhattan(vecAux, pos_objetivo), this.g+1);
        
        return hijos;
    }
    
    // Método auxiliar para calcular la distancia manhattan
    private double distanciaManhattan(Vector2d v1, Vector2d v2){
        return (Math.abs(v1.x - v2.x) + Math.abs(v1.y - v2.y));
    }
    
    public NodoH getPadre() {
        return padre;
    }

    public NodoH[] getHijos() {
        return hijos;
    }

    public ACTIONS getAccion() {
        return accion;
    }
    
    
    @Override
    public boolean equals(Object o){
        if(o==null)  return false;
        return this.posicion.equals(((NodoH)o).posicion);
    }

    @Override
    public int compareTo(NodoH o) {
        
        if(this.f < this.f)
            return -1;
        if(this.f > o.f)
            return 1;
        return 0;
    }   
}

    

    



