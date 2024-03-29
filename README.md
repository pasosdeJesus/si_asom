# si_asom


[![Revisado por Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg)](https://houndci.com) Pruebas y seguridad:[![Estado Construcción](https://gitlab.com/pasosdeJesus/si_asom/badges/main/pipeline.svg)](https://gitlab.com/pasosdeJesus/si_asom/-/pipelines?page=1&scope=all&ref=main) [![Clima del Código](https://codeclimate.com/github/pasosdeJesus/si_asom/badges/gpa.svg)](https://codeclimate.com/github/pasosdeJesus/si_asom) [![Cobertura de Pruebas](https://codeclimate.com/github/pasosdeJesus/si_asom/badges/coverage.svg)](https://codeclimate.com/github/pasosdeJesus/si_asom)


Sistema de Información de ASOM


### Requerimientos
* Ruby version >= 3.0
* PostgreSQL >= 13 con extensión unaccent disponible
* node.js >= 12
* Recomendado sobre adJ 6.8 (que incluye todos los componentes mencionados).  
  Las siguientes instrucciones suponen que opera en este ambiente.

Puede consultar como instalar estos componentes en: 
<https://github.com/pasosdeJesus/msip/wiki/Requisitos>


### Arquitectura

Es una aplicación que emplea los siguientes motores:
*  genérico para sistemas de información ```msip``` 
  <https://github.com/pasosdeJesus/msip>
*  genérico para manejo de casos ```sivel2_gen``` 
  <https://github.com/pasosdeJesus/sivel2_gen>
*  genérico para proyectos con marco lógico y actividades ```cor1440_gen``` 
  <https://github.com/pasosdeJesus/cor1440_gen>


### Configuración y uso de servidor de desarrollo

Su configuración y uso es similar al de SIVeL2 se invita a ver
las instrucciones dle mismo en
<https://github.com/pasosdeJesus/sivel2/>

