package com.proyecto.model;

import lombok.AllArgsConstructor;

import lombok.Data;

@Data 
@AllArgsConstructor
public class Tarea {
    
    private Long id;
    
    private String nombre;
    
    private boolean completada;

}