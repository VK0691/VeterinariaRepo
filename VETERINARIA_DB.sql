SELECT c.id_consulta, m.nombre_mascota, v.nombres AS veterinario, e.nombre_especialidad
FROM CONSULTA c
JOIN MASCOTA m ON c.id_mascota = m.id_mascota
JOIN VETERINARIO v ON c.id_veterinario = v.id_veterinario
JOIN ESPECIALIDAD e ON v.id_especialidad = e.id_especialidad;