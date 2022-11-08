-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        10.11.0-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- chat 데이터베이스 구조 내보내기
CREATE DATABASE IF NOT EXISTS `chat` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `chat`;

-- 테이블 chat.relations 구조 내보내기
CREATE TABLE IF NOT EXISTS `relations` (
  `USER_ID` int(11) NOT NULL,
  `TARGET_ID` int(11) NOT NULL,
  `RELATION_TYPE` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.relations:~4 rows (대략적) 내보내기
/*!40000 ALTER TABLE `relations` DISABLE KEYS */;
INSERT INTO `relations` (`USER_ID`, `TARGET_ID`, `RELATION_TYPE`) VALUES
	(1, 6, 'FRIEND'),
	(1, 8, 'FRIEND'),
	(6, 1, 'FRIEND'),
	(8, 1, 'FRIEND');
/*!40000 ALTER TABLE `relations` ENABLE KEYS */;

-- 테이블 chat.users 구조 내보내기
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `EMAIL` varchar(64) NOT NULL,
  `PASSWORD` varchar(65) NOT NULL,
  `NAME` varchar(30) NOT NULL,
  `LANGUEGE` varchar(5) NOT NULL,
  `COMPANY_NAME` varchar(30) DEFAULT NULL,
  `IMG_URL` varchar(50) NOT NULL DEFAULT 'default_profile.png',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `EMAIL` (`EMAIL`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.users:~4 rows (대략적) 내보내기
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`ID`, `EMAIL`, `PASSWORD`, `NAME`, `LANGUEGE`, `COMPANY_NAME`, `IMG_URL`) VALUES
	(1, '1812105@du.ac.kr', 'acd202bb391b4712518fe87bb26775053b3d55171a80bcb6b5ab7a9e44a914f9', '박상도', 'ko', NULL, 'default_profile.png'),
	(6, 'tkdeh129@naver.com', '1812105', '상도박', 'ko', NULL, 'default_profile.png'),
	(7, 'aa55235490@gmail.com', '1812105', '도상박', 'ko', NULL, 'default_profile.png'),
	(8, 'psd00012911@gmail.com', '1812105', 'PARKSANGDO', 'ko', NULL, 'default_profile.png'),
	(9, 'reaui19@naver.com', '55daf76ebb48896ce06ae11eac5cf86dc975ced67f0ab9ce1c57efe6a5ca010b', 'name', 'ko', NULL, 'default_profile.png');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
