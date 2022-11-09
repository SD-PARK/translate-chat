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
  `RELATION_TYPE` varchar(8) NOT NULL,
  PRIMARY KEY (`USER_ID`,`TARGET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.relations:~4 rows (대략적) 내보내기
/*!40000 ALTER TABLE `relations` DISABLE KEYS */;
INSERT INTO `relations` (`USER_ID`, `TARGET_ID`, `RELATION_TYPE`) VALUES
	(1, 6, 'FRIEND'),
	(1, 8, 'FRIEND'),
	(6, 1, 'FRIEND'),
	(8, 1, 'FRIEND');
/*!40000 ALTER TABLE `relations` ENABLE KEYS */;

-- 테이블 chat.room_info 구조 내보내기
CREATE TABLE IF NOT EXISTS `room_info` (
  `ROOM_ID` int(11) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  `ROOM_NAME` varchar(15) NOT NULL DEFAULT 'Room',
  `NOTICE_TYPE` varchar(8) NOT NULL DEFAULT 'notice',
  `FAVORITES` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ROOM_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.room_info:~2 rows (대략적) 내보내기
/*!40000 ALTER TABLE `room_info` DISABLE KEYS */;
INSERT INTO `room_info` (`ROOM_ID`, `USER_ID`, `ROOM_NAME`, `NOTICE_TYPE`, `FAVORITES`) VALUES
	(1, 1, 'Room', 'notice', 0),
	(1, 2, 'Room', 'notice', 0);
/*!40000 ALTER TABLE `room_info` ENABLE KEYS */;

-- 테이블 chat.room_message_1 구조 내보내기
CREATE TABLE IF NOT EXISTS `room_message_1` (
  `MSG_NUM` int(11) NOT NULL AUTO_INCREMENT,
  `SEND_USER_ID` int(11) NOT NULL,
  `ORIGINAL_MSG` varchar(1000) CHARACTER SET utf8mb4 NOT NULL,
  `READ_COUNT` int(11) NOT NULL,
  `SEND_TIME` datetime NOT NULL DEFAULT current_timestamp(),
  `FROM_LANGUAGE` varchar(5) NOT NULL,
  `TO_ko` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TO_ja` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TO_en` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TO_zh-CN` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TO_zh-TW` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`MSG_NUM`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.room_message_1:~3 rows (대략적) 내보내기
/*!40000 ALTER TABLE `room_message_1` DISABLE KEYS */;
INSERT INTO `room_message_1` (`MSG_NUM`, `SEND_USER_ID`, `ORIGINAL_MSG`, `READ_COUNT`, `SEND_TIME`, `FROM_LANGUAGE`, `TO_ko`, `TO_ja`, `TO_en`, `TO_zh-CN`, `TO_zh-TW`) VALUES
	(1, 1, '안녕', 0, '2022-11-08 22:22:05', 'ko', '안녕', 'こんにちは', 'Hi.', '你好。', '你好。'),
	(2, 6, '잘 가', 0, '2022-11-08 22:43:46', 'ko', '잘 가', 'じゃね', 'See you later', '走好。', '走好。'),
	(3, 1, 'ㅅㄱ', 1, '2022-11-09 22:58:43', 'ko', 'ㅅㄱ', NULL, NULL, NULL, NULL);
/*!40000 ALTER TABLE `room_message_1` ENABLE KEYS */;

-- 테이블 chat.users 구조 내보내기
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `EMAIL` varchar(64) NOT NULL,
  `PASSWORD` varchar(65) NOT NULL,
  `NAME` varchar(30) NOT NULL,
  `LANGUAGE` varchar(5) NOT NULL,
  `COMPANY_NAME` varchar(30) DEFAULT NULL,
  `IMG_URL` varchar(50) NOT NULL DEFAULT 'default_profile.png',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `EMAIL` (`EMAIL`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.users:~7 rows (대략적) 내보내기
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`ID`, `EMAIL`, `PASSWORD`, `NAME`, `LANGUAGE`, `COMPANY_NAME`, `IMG_URL`) VALUES
	(1, '1812105@du.ac.kr', 'acd202bb391b4712518fe87bb26775053b3d55171a80bcb6b5ab7a9e44a914f9', '박상도', 'ko', NULL, 'default_profile.png'),
	(6, 'tkdeh129@naver.com', '1812105', '상도박', 'ko', NULL, 'default_profile.png'),
	(7, 'aa55235490@gmail.com', '1812105', '도상박', 'ko', NULL, 'default_profile.png'),
	(8, 'psd00012911@gmail.com', '1812105', 'PARKSANGDO', 'ko', NULL, 'default_profile.png'),
	(9, 'reaui19@naver.com', '55daf76ebb48896ce06ae11eac5cf86dc975ced67f0ab9ce1c57efe6a5ca010b', 'name', 'ko', NULL, 'default_profile.png'),
	(10, 'rlagusqls@naver.com', '1f0bfbb53b0d63fd9d54ffb976039f71e2b96a7f8f47faa960ad07b1624f32e9', '김현빈', 'ko', '백석대학교', 'default_profile.png'),
	(13, 'urung15@naver.com', 'a49932b7fe6e0bc17dd7f5aefb5cf59c15967767f858a3904afac5892a2235c7', 'urung', 'en', 'afdsafdsafdsa', 'default_profile.png');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
