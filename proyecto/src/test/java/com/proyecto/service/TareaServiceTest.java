package com.proyecto.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.proyecto.model.Tarea;

public class TareaServiceTest {
    


    private TareaService tareaService;

    @BeforeEach
    void setUp() {
        tareaService = new TareaService();
    }

    @Test
    void debeCrearUnaTarea() {

        Tarea tarea = tareaService.crear("Aprender Spring Boot");

        assertNotNull(tarea);
        assertEquals(1L, tarea.getId());
        assertEquals("Aprender Spring Boot", tarea.getNombre());
        assertFalse(tarea.isCompletada());
    }

    @Test
    void debeListarLasTareas() {

        tareaService.crear("Aprender Java");
        tareaService.crear("Aprender Terraform");

        List<Tarea> tareas = tareaService.listar();

        assertEquals(2, tareas.size());
    }

    @Test
    void debeRechazarUnNombreVacio() {

        assertThrows(
                IllegalArgumentException.class,
                () -> tareaService.crear("")
        );
    }


}
