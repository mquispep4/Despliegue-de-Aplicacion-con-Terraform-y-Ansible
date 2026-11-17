package com.proyecto.service;

import org.springframework.stereotype.Service;

import com.proyecto.model.Tarea;

import java.util.ArrayList;
import java.util.List;

@Service
public class TareaService {

    private final List<Tarea> tareas = new ArrayList<>();
    private Long siguienteId = 1L;

    public List<Tarea> listar() {
        return tareas;
    }

    public Tarea crear(String nombre) {

        if (nombre == null || nombre.isBlank()) {
            throw new IllegalArgumentException(
                    "El nombre de la tarea es obligatorio"
            );
        }

        Tarea tarea = new Tarea(
                siguienteId++,
                nombre.trim(),
                false
        );

        tareas.add(tarea);

        return tarea;
    }
}