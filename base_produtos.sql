-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           10.4.28-MariaDB - mariadb.org binary distribution
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              12.5.0.6677
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Copiando estrutura do banco de dados para base_produtos
CREATE DATABASE IF NOT EXISTS `base_produtos` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `base_produtos`;

-- Copiando estrutura para tabela base_produtos.cad_produtos
CREATE TABLE IF NOT EXISTS `cad_produtos` (
  `Ean` varchar(20) NOT NULL,
  `Nome` varchar(255) NOT NULL,
  `Ncm` int(11) NOT NULL,
  `valor` double DEFAULT NULL,
  `avg` double DEFAULT NULL,
  `ex` int(11) DEFAULT 0,
  `marca` varchar(255) DEFAULT NULL,
  `pais` varchar(100) DEFAULT NULL,
  `categoria` varchar(255) DEFAULT NULL,
  `valor_medio` double DEFAULT 0,
  `atualizado` int(11) DEFAULT 0,
  `link_foto` longtext DEFAULT NULL,
  `Cest_codigo` varchar(7) DEFAULT NULL,
  `dh_update` datetime DEFAULT NULL,
  `erro` int(11) DEFAULT 0,
  `embalagem` varchar(10) DEFAULT NULL,
  `quantidade_embalagem` double DEFAULT NULL,
  `tributacao` varchar(15) DEFAULT NULL,
  `produto_acento` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Ean`,`Ncm`),
  KEY `fk_ncm_produtos` (`Ncm`),
  KEY `descricao` (`Nome`),
  KEY `produtos_idx1` (`Ean`),
  KEY `produtos_idx3` (`Ean`,`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela base_produtos.entregas
CREATE TABLE IF NOT EXISTS `entregas` (
  `id_motorista` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `competencia` varchar(7) NOT NULL,
  `acumulado` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Exportação de dados foi desmarcado.

-- Copiando estrutura para tabela base_produtos.unidade_medida
CREATE TABLE IF NOT EXISTS `unidade_medida` (
  `id` varchar(10) NOT NULL,
  `nome` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Exportação de dados foi desmarcado.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
