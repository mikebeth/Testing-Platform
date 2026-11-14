# Testing-Platform

Plataforma modular en MATLAB para realizar pruebas a algoritmos de optimización. Su diseño es similar al formato de las competencias GECCO.

## Estructura

- `DE-isl/`, `QDDE/`, `VIEDA/`: los algoritmos. Cada uno está en una carpeta con su nombre.
- `functions/`: las funciones a optimizar y la función `save_results`, que muestra y guarda los resultados.
- `results/`: almacena los resultados de las distintas pruebas.
- `main.m`: en este archivo se seleccionan los algoritmos y las funciones a optimizar.
