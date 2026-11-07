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
-- Dumping data for table `administrador`
--

LOCK TABLES `administrador` WRITE;
/*!40000 ALTER TABLE `administrador` DISABLE KEYS */;
INSERT INTO `administrador` VALUES (1,1);
/*!40000 ALTER TABLE `administrador` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `camion`
--

LOCK TABLES `camion` WRITE;
/*!40000 ALTER TABLE `camion` DISABLE KEYS */;
INSERT INTO `camion` VALUES (2,NULL,NULL,1,'SBA1234','Volkswagen 24.280','disponible'),(4,NULL,NULL,2,'SBA1352','Volkswagen','disponible'),(6,NULL,NULL,NULL,'TST0001','Test Truck','disponible');
/*!40000 ALTER TABLE `camion` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `centro_acopio`
--

LOCK TABLES `centro_acopio` WRITE;
/*!40000 ALTER TABLE `centro_acopio` DISABLE KEYS */;
INSERT INTO `centro_acopio` VALUES (2,'Centro Test','Av. Test 456',100),(3,'Centro Test','Av. Test 456',100);
/*!40000 ALTER TABLE `centro_acopio` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `centro_acopio_tipo_residuo`
--

LOCK TABLES `centro_acopio_tipo_residuo` WRITE;
/*!40000 ALTER TABLE `centro_acopio_tipo_residuo` DISABLE KEYS */;
/*!40000 ALTER TABLE `centro_acopio_tipo_residuo` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `conductor`
--

LOCK TABLES `conductor` WRITE;
/*!40000 ALTER TABLE `conductor` DISABLE KEYS */;
INSERT INTO `conductor` VALUES (3,2,4,NULL,'manana','Centro'),(6,NULL,NULL,NULL,NULL,NULL),(8,NULL,NULL,NULL,NULL,NULL),(12,NULL,NULL,NULL,NULL,NULL),(13,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `conductor` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `contenedor`
--

LOCK TABLES `contenedor` WRITE;
/*!40000 ALTER TABLE `contenedor` DISABLE KEYS */;
INSERT INTO `contenedor` VALUES (2,'Av. Rivera y Soca','Pocitos','funcional',NULL,NULL,1),(3,'Av Buceo y Carrasco','MALVIN','funcional',NULL,NULL,2),(4,'18 de Julio y Yi','Centro','funcional',NULL,NULL,1),(5,'Av. Brasil y Echevarriarza','Pocitos','funcional',NULL,NULL,7),(6,'Rivera y Solano Garcia','Buceo','funcional',NULL,NULL,7),(7,'Sarandi y Zabala','Ciudad Vieja','funcional',NULL,NULL,1),(8,'Bulevar Artigas y Rondeau','Cordon','danado',NULL,NULL,1),(9,'18 de Julio y Ejido','Centro','funcional',1,1,1),(10,'18 de Julio y Yaguaron','Centro','funcional',1,2,2),(11,'Av. del Libertador y Palermo','Palermo','funcional',1,3,1),(12,'Constitucion y Colonia','Cordon','funcional',1,4,4),(13,'Bv. Artigas y Rivera','Cordon','danado',1,5,1),(14,'Av. Brasil y Benito Blanco','Pocitos','funcional',2,1,1),(15,'Rbla. Republica del Peru y Miraflores','Pocitos','funcional',2,2,2),(16,'Rbla. OHiggins y Jose Ellauri','Punta Carretas','funcional',2,3,3),(17,'Av. Saldanha da Gama y Golfarini','Buceo','funcional',2,4,1),(18,'Av. Gral. Rivera y Bv. Batlle','Buceo','funcional',2,5,4),(19,'Av. del Puerto y Rambla','Ciudad Vieja','funcional',3,1,1),(20,'Cerrito y Colonia','Ciudad Vieja','danado',3,2,2),(21,'Av. Italia y Bulevar Artigas','Aguada','funcional',3,3,1),(22,'Bv. Artigas y Tres Cruces','Tres Cruces','funcional',3,4,5),(23,'Rivera y Paraguay','Tres Cruces','funcional',3,5,1),(25,'Calle Test 123','Centro','funcional',NULL,NULL,1),(26,'Calle Test 123','Centro','funcional',NULL,NULL,1);
/*!40000 ALTER TABLE `contenedor` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `incidencia`
--

LOCK TABLES `incidencia` WRITE;
/*!40000 ALTER TABLE `incidencia` DISABLE KEYS */;
INSERT INTO `incidencia` VALUES (1,NULL,NULL,'desborde','Contenedor desbordado en la esquina','Av. Rivera y Soca','Pocitos',NULL,'en_proceso','2026-07-22',NULL),(2,NULL,NULL,'rotura','Tapa rota','18 de Julio 1234','Centro','data:image/png;base64,iVBORw0KGgoAAAANSUhEUg==','abierta','2026-07-22',NULL),(3,NULL,NULL,'desborde','Contenedor lleno','Constitucion y Andes','Aguada',NULL,'abierta','2026-07-23',NULL),(4,NULL,NULL,'rotura','Tapa rota','Bvar. Espana y Jackson','Palermo',NULL,'abierta','2026-07-23',NULL),(5,NULL,NULL,'desborde','Contenedor desbordado, residuos en la vereda','Rbla. Gandhi y Benito Blanco','Pocitos',NULL,'en_proceso','2026-07-23',NULL),(6,NULL,NULL,'desborde','Test incidencia','Test 123','Centro',NULL,'abierta','2026-09-11',NULL),(7,NULL,NULL,'desborde','Test incidencia','Test 123','Centro',NULL,'abierta','2026-09-13',NULL),(8,NULL,NULL,'desborde','Test incidencia','Test 123','Centro',NULL,'abierta','2026-09-13',NULL);
/*!40000 ALTER TABLE `incidencia` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `mantenimiento`
--

LOCK TABLES `mantenimiento` WRITE;
/*!40000 ALTER TABLE `mantenimiento` DISABLE KEYS */;
/*!40000 ALTER TABLE `mantenimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mantenimiento_camion`
--

DROP TABLE IF EXISTS `mantenimiento_camion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mantenimiento_camion` (
  `id_mantenimiento` int(11) NOT NULL AUTO_INCREMENT,
  `id_camion` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `tipo` varchar(50) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `estado` varchar(30) NOT NULL DEFAULT 'pendiente',
  PRIMARY KEY (`id_mantenimiento`),
  KEY `id_camion` (`id_camion`),
  CONSTRAINT `mant_camion_fk1` FOREIGN KEY (`id_camion`) REFERENCES `camion` (`id_camion`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mantenimiento_camion`
--

LOCK TABLES `mantenimiento_camion` WRITE;
/*!40000 ALTER TABLE `mantenimiento_camion` DISABLE KEYS */;
/*!40000 ALTER TABLE `mantenimiento_camion` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `maquinaria`
--

LOCK TABLES `maquinaria` WRITE;
/*!40000 ALTER TABLE `maquinaria` DISABLE KEYS */;
INSERT INTO `maquinaria` VALUES (2,NULL,NULL,'Prensa hidraulica','operativa'),(3,NULL,NULL,'Prensa hidraulica','operativa');
/*!40000 ALTER TABLE `maquinaria` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `operario`
--

LOCK TABLES `operario` WRITE;
/*!40000 ALTER TABLE `operario` DISABLE KEYS */;
INSERT INTO `operario` VALUES (2,NULL,NULL,'manana'),(7,NULL,NULL,NULL),(11,NULL,NULL,NULL);
/*!40000 ALTER TABLE `operario` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `peon`
--

LOCK TABLES `peon` WRITE;
/*!40000 ALTER TABLE `peon` DISABLE KEYS */;
INSERT INTO `peon` VALUES (4,'tarde'),(5,NULL),(14,NULL),(15,NULL),(16,NULL);
/*!40000 ALTER TABLE `peon` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `repuesto_contenedor`
--

LOCK TABLES `repuesto_contenedor` WRITE;
/*!40000 ALTER TABLE `repuesto_contenedor` DISABLE KEYS */;
/*!40000 ALTER TABLE `repuesto_contenedor` ENABLE KEYS */;
UNLOCK TABLES;

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
  `id_centro_destino` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_ruta`),
  KEY `id_conductor` (`id_conductor`),
  KEY `fk_ruta_camion` (`id_camion`),
  KEY `fk_ruta_centro` (`id_centro_destino`),
  CONSTRAINT `fk_ruta_camion` FOREIGN KEY (`id_camion`) REFERENCES `camion` (`id_camion`) ON DELETE SET NULL,
  CONSTRAINT `fk_ruta_centro` FOREIGN KEY (`id_centro_destino`) REFERENCES `centro_acopio` (`id_centro`) ON DELETE SET NULL,
  CONSTRAINT `ruta_ibfk_1` FOREIGN KEY (`id_conductor`) REFERENCES `conductor` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ruta`
--

LOCK TABLES `ruta` WRITE;
/*!40000 ALTER TABLE `ruta` DISABLE KEYS */;
INSERT INTO `ruta` VALUES (1,3,2,'Ruta Centro','Centro / Cordon / Palermo',1,'Recorrido diario zona centro de Montevideo','#1a5c52','activa',1),(2,NULL,NULL,'Ruta Costera','Pocitos / Buceo / Punta Carretas',1,'Recorrido zona costera este','#2a7a6e','activa',2),(3,12,4,'Ruta Norte','Aguada / Ciudad Vieja / Tres Cruces',1,'Recorrido zona norte y puerto','#3d6b59','activa',NULL),(8,NULL,NULL,'Ruta Test','Centro',1,'Ruta de prueba','#1a5c52','activa',NULL),(9,NULL,NULL,'Ruta Test','Centro',1,'Ruta de prueba','#1a5c52','activa',NULL);
/*!40000 ALTER TABLE `ruta` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `tipo_residuo`
--

LOCK TABLES `tipo_residuo` WRITE;
/*!40000 ALTER TABLE `tipo_residuo` DISABLE KEYS */;
INSERT INTO `tipo_residuo` VALUES (1,'Org├ínico'),(2,'Pl├ístico'),(3,'Vidrio'),(4,'Papel/Cart├│n'),(5,'Metal'),(6,'Electr├│nico'),(7,'Reciclable');
/*!40000 ALTER TABLE `tipo_residuo` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'Admin','SiGeRU','admin@sigeru.uy','$2y$10$hoPF89CVtQnykid2QRXL9.0T0oLbNrei6BwK3BvzT2ibj.9awrzHy','099123456','activo'),(2,'Carlos','Perez','carlos@sigeru.uy','$2y$10$P2KJDQYBz9ERJZOWd7sR6Oj.zxJlNGEfVm8.f1a0wsrC37jpiFMrW','099111222','activo'),(3,'Martin','Gomez','martin@sigeru.uy','$2y$10$yhaxOnd6SsXqPZiqYqP5JuPY7wDImjhn9z69SJovR9ZadXbAt.iO6','099333444','activo'),(4,'Diego','Acosta','diego@sigeru.uy','$2y$10$0e1I7SniV6dfg6BObFw5DeQGK.Um8lebrvRTzqs97YIlTxUMZV5M.','099555666','activo'),(5,'Mateo','blanco','mateo@gmail.com','$2y$10$5pB7MZb5cL2NQwpeAxGn6ueJju5jKes1Im11.cF59N.NOTzmqucBe',NULL,'activo'),(6,'maximo','maxi','maximo@gmail.com','$2y$10$3rEV5xkaVmgU3TmvgOthoOz3AdWhuQd34/kg5pczxaVtEsUGlF.G6',NULL,'activo'),(7,'Juan','Lopez','juan@test.com','$2y$10$Jaj9kTT4wnx7zxcMWEEmtu88a/gwqCIxxr3F7WBMK.y/hSNsF83oy',NULL,'inactivo'),(8,'bruno','acosta','brunoacosta@gmail.com','$2y$10$78j.a4zzga3BBl8mtH7Ylu..iYCiVYHoolJSq2lwA4S8/8eO.kErm',NULL,'activo'),(9,'Admin','SiGeRU','admin@sigeru.com','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',NULL,'activo'),(11,'carlote','ca','operario@sigeru.com','$2y$10$plBPDX.HAh7RXjkjjBXOOOdENXlf.CwYjTLlKpJs1tKVyjTkDIbwW',NULL,'activo'),(12,'fede','delvalle','fedefalle@gmail.com','$2y$10$aI/mSVl6ovNVpeCW0Q.Ahe5IwKYLr1LwpIyKbPhLpsKjx1Hyxf7m2',NULL,'activo'),(13,'Test','Conductor','test@conductor.uy','$2y$10$qOSDEJPTVaIRuR92odm9wOsCFp2q6cfzV/98/Hm2kwLtR8bsxlNYa',NULL,'activo'),(14,'carlote','ca','peon@gmail.com','$2y$10$Qww9VNQvdBCnfHYzoiCxPuP1AlfrrmCTXmcuh6L0N4U0/6ZfgkMNm',NULL,'activo'),(15,'Test','Testing','test_api@test.com','$2y$10$LlEBX8VozIIsSz4bnr0YaeyLvmTKSREhE1RrV0dnMJZtoGMyHZRFa','099123456','activo'),(16,'Test','Testing','test_api2@test.com','$2y$10$.qchibQMqlGIWuFV7kBWuuaXjexYEMAb8b2O4.gQcl0BUHX1Qz8Ga','099123456','activo');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `vertedero`
--

LOCK TABLES `vertedero` WRITE;
/*!40000 ALTER TABLE `vertedero` DISABLE KEYS */;
/*!40000 ALTER TABLE `vertedero` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Dumping data for table `vertedero_tipo_residuo`
--

LOCK TABLES `vertedero_tipo_residuo` WRITE;
/*!40000 ALTER TABLE `vertedero_tipo_residuo` DISABLE KEYS */;
/*!40000 ALTER TABLE `vertedero_tipo_residuo` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-14  0:45:41

-- Contrasenas de prueba conocidas (admin@sigeru.uy = admin123; los demas = test1234)
UPDATE usuario SET contrasena = '$2y$10$Q9el.DDOMM6rec6esiCnoOFc/uT6bM9L/ka2wAApgAJYr2v/rYOMW' WHERE id_usuario IN (2, 3, 4);
