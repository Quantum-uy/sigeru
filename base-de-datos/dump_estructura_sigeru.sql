-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: sigeru
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administrador`
--

DROP TABLE IF EXISTS `administrador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `administrador` (
  `id_usuario` int(11) NOT NULL,
  `nivel_permiso` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_usuario`),
  CONSTRAINT `administrador_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `camion`
--

DROP TABLE IF EXISTS `camion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `camion` (
  `id_camion` int(11) NOT NULL AUTO_INCREMENT,
  `id_centro` int(11) DEFAULT NULL,
  `id_vertedero` int(11) DEFAULT NULL,
  `id_tipo_residuo` int(11) DEFAULT NULL,
  `matricula` varchar(20) NOT NULL,
  `modelo` varchar(100) DEFAULT NULL,
  `estado` varchar(30) NOT NULL DEFAULT 'disponible',
  PRIMARY KEY (`id_camion`),
  UNIQUE KEY `matricula` (`matricula`),
  KEY `id_centro` (`id_centro`),
  KEY `id_vertedero` (`id_vertedero`),
  KEY `id_tipo_residuo` (`id_tipo_residuo`),
  CONSTRAINT `camion_ibfk_1` FOREIGN KEY (`id_centro`) REFERENCES `centro_acopio` (`id_centro`) ON DELETE SET NULL,
  CONSTRAINT `camion_ibfk_2` FOREIGN KEY (`id_vertedero`) REFERENCES `vertedero` (`id_vertedero`) ON DELETE SET NULL,
  CONSTRAINT `camion_ibfk_3` FOREIGN KEY (`id_tipo_residuo`) REFERENCES `tipo_residuo` (`id_tipo_residuo`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `centro_acopio`
--

DROP TABLE IF EXISTS `centro_acopio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `centro_acopio` (
  `id_centro` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `ubicacion` varchar(255) DEFAULT NULL,
  `capacidad` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_centro`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `centro_acopio_tipo_residuo`
--

DROP TABLE IF EXISTS `centro_acopio_tipo_residuo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `centro_acopio_tipo_residuo` (
  `id_centro` int(11) NOT NULL,
  `id_tipo_residuo` int(11) NOT NULL,
  PRIMARY KEY (`id_centro`,`id_tipo_residuo`),
  KEY `id_tipo_residuo` (`id_tipo_residuo`),
  CONSTRAINT `centro_acopio_tipo_residuo_ibfk_1` FOREIGN KEY (`id_centro`) REFERENCES `centro_acopio` (`id_centro`) ON DELETE CASCADE,
  CONSTRAINT `centro_acopio_tipo_residuo_ibfk_2` FOREIGN KEY (`id_tipo_residuo`) REFERENCES `tipo_residuo` (`id_tipo_residuo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conductor`
--

DROP TABLE IF EXISTS `conductor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conductor` (
  `id_usuario` int(11) NOT NULL,
  `id_camion` int(11) DEFAULT NULL,
  `id_peon` int(11) DEFAULT NULL,
  `id_operario_asigna` int(11) DEFAULT NULL,
  `turno` varchar(20) DEFAULT NULL,
  `zona_asignada` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  KEY `id_camion` (`id_camion`),
  KEY `id_peon` (`id_peon`),
  KEY `id_operario_asigna` (`id_operario_asigna`),
  CONSTRAINT `conductor_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE,
  CONSTRAINT `conductor_ibfk_2` FOREIGN KEY (`id_camion`) REFERENCES `camion` (`id_camion`) ON DELETE SET NULL,
  CONSTRAINT `conductor_ibfk_3` FOREIGN KEY (`id_peon`) REFERENCES `peon` (`id_usuario`) ON DELETE SET NULL,
  CONSTRAINT `conductor_ibfk_4` FOREIGN KEY (`id_operario_asigna`) REFERENCES `operario` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contenedor`
--

DROP TABLE IF EXISTS `contenedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contenedor` (
  `id_contenedor` int(11) NOT NULL AUTO_INCREMENT,
  `ubicacion` varchar(255) DEFAULT NULL,
  `zona` varchar(100) DEFAULT NULL,
  `estado` varchar(30) NOT NULL DEFAULT 'funcional',
  `id_ruta` int(11) DEFAULT NULL,
  `orden_en_ruta` int(11) DEFAULT NULL,
  `id_tipo_residuo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_contenedor`),
  KEY `fk_contenedor_ruta` (`id_ruta`),
  KEY `fk_cont_tipo` (`id_tipo_residuo`),
  CONSTRAINT `fk_cont_tipo` FOREIGN KEY (`id_tipo_residuo`) REFERENCES `tipo_residuo` (`id_tipo_residuo`),
  CONSTRAINT `fk_contenedor_ruta` FOREIGN KEY (`id_ruta`) REFERENCES `ruta` (`id_ruta`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `incidencia`
--

DROP TABLE IF EXISTS `incidencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `incidencia` (
  `id_incidencia` int(11) NOT NULL AUTO_INCREMENT,
  `id_contenedor` int(11) DEFAULT NULL,
  `id_conductor_asignado` int(11) DEFAULT NULL,
  `tipo` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `ubicacion` varchar(255) DEFAULT NULL,
  `zona` varchar(100) DEFAULT NULL,
  `imagen` longtext DEFAULT NULL,
  `estado` varchar(30) NOT NULL DEFAULT 'abierta',
  `fecha_reporte` date NOT NULL,
  `fecha_resolucion` date DEFAULT NULL,
  PRIMARY KEY (`id_incidencia`),
  KEY `id_contenedor` (`id_contenedor`),
  KEY `id_conductor_asignado` (`id_conductor_asignado`),
  CONSTRAINT `incidencia_ibfk_1` FOREIGN KEY (`id_contenedor`) REFERENCES `contenedor` (`id_contenedor`) ON DELETE CASCADE,
  CONSTRAINT `incidencia_ibfk_2` FOREIGN KEY (`id_conductor_asignado`) REFERENCES `conductor` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mantenimiento`
--

DROP TABLE IF EXISTS `mantenimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mantenimiento` (
  `id_mantenimiento` int(11) NOT NULL AUTO_INCREMENT,
  `id_contenedor` int(11) NOT NULL,
  `id_operario` int(11) DEFAULT NULL,
  `fecha` date NOT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `estado` varchar(30) NOT NULL DEFAULT 'pendiente',
  PRIMARY KEY (`id_mantenimiento`),
  KEY `id_contenedor` (`id_contenedor`),
  KEY `id_operario` (`id_operario`),
  CONSTRAINT `mantenimiento_ibfk_1` FOREIGN KEY (`id_contenedor`) REFERENCES `contenedor` (`id_contenedor`) ON DELETE CASCADE,
  CONSTRAINT `mantenimiento_ibfk_2` FOREIGN KEY (`id_operario`) REFERENCES `operario` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `maquinaria`
--

DROP TABLE IF EXISTS `maquinaria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `maquinaria` (
  `id_maquinaria` int(11) NOT NULL AUTO_INCREMENT,
  `id_centro` int(11) DEFAULT NULL,
  `id_vertedero` int(11) DEFAULT NULL,
  `tipo` varchar(100) DEFAULT NULL,
  `estado` varchar(30) NOT NULL DEFAULT 'operativa',
  PRIMARY KEY (`id_maquinaria`),
  KEY `id_centro` (`id_centro`),
  KEY `id_vertedero` (`id_vertedero`),
  CONSTRAINT `maquinaria_ibfk_1` FOREIGN KEY (`id_centro`) REFERENCES `centro_acopio` (`id_centro`) ON DELETE SET NULL,
  CONSTRAINT `maquinaria_ibfk_2` FOREIGN KEY (`id_vertedero`) REFERENCES `vertedero` (`id_vertedero`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `operario`
--

DROP TABLE IF EXISTS `operario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operario` (
  `id_usuario` int(11) NOT NULL,
  `id_centro` int(11) DEFAULT NULL,
  `id_vertedero` int(11) DEFAULT NULL,
  `turno` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  KEY `id_centro` (`id_centro`),
  KEY `id_vertedero` (`id_vertedero`),
  CONSTRAINT `operario_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE,
  CONSTRAINT `operario_ibfk_2` FOREIGN KEY (`id_centro`) REFERENCES `centro_acopio` (`id_centro`) ON DELETE SET NULL,
  CONSTRAINT `operario_ibfk_3` FOREIGN KEY (`id_vertedero`) REFERENCES `vertedero` (`id_vertedero`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `peon`
--

DROP TABLE IF EXISTS `peon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `peon` (
  `id_usuario` int(11) NOT NULL,
  `turno` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  CONSTRAINT `peon_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `repuesto_contenedor`
--

DROP TABLE IF EXISTS `repuesto_contenedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `repuesto_contenedor` (
  `id_repuesto` int(11) NOT NULL AUTO_INCREMENT,
  `tipo` varchar(100) DEFAULT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 0,
  `ubicacion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_repuesto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ruta`
--

DROP TABLE IF EXISTS `ruta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruta` (
  `id_ruta` int(11) NOT NULL AUTO_INCREMENT,
  `id_conductor` int(11) DEFAULT NULL,
  `id_camion` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `zona` varchar(100) DEFAULT NULL,
  `numero` int(11) DEFAULT 1,
  `descripcion` text DEFAULT NULL,
  `color` varchar(20) NOT NULL DEFAULT '#1a5c52',
  `estado` varchar(20) NOT NULL DEFAULT 'activa',
  PRIMARY KEY (`id_ruta`),
  KEY `id_conductor` (`id_conductor`),
  KEY `fk_ruta_camion` (`id_camion`),
  CONSTRAINT `fk_ruta_camion` FOREIGN KEY (`id_camion`) REFERENCES `camion` (`id_camion`) ON DELETE SET NULL,
  CONSTRAINT `ruta_ibfk_1` FOREIGN KEY (`id_conductor`) REFERENCES `conductor` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tipo_residuo`
--

DROP TABLE IF EXISTS `tipo_residuo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipo_residuo` (
  `id_tipo_residuo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id_tipo_residuo`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'activo',
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vertedero`
--

DROP TABLE IF EXISTS `vertedero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vertedero` (
  `id_vertedero` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `ubicacion` varchar(255) DEFAULT NULL,
  `capacidad` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_vertedero`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vertedero_tipo_residuo`
--

DROP TABLE IF EXISTS `vertedero_tipo_residuo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vertedero_tipo_residuo` (
  `id_vertedero` int(11) NOT NULL,
  `id_tipo_residuo` int(11) NOT NULL,
  PRIMARY KEY (`id_vertedero`,`id_tipo_residuo`),
  KEY `id_tipo_residuo` (`id_tipo_residuo`),
  CONSTRAINT `vertedero_tipo_residuo_ibfk_1` FOREIGN KEY (`id_vertedero`) REFERENCES `vertedero` (`id_vertedero`) ON DELETE CASCADE,
  CONSTRAINT `vertedero_tipo_residuo_ibfk_2` FOREIGN KEY (`id_tipo_residuo`) REFERENCES `tipo_residuo` (`id_tipo_residuo`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-14  0:45:32
