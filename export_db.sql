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
  `RELATION_TYPE` varchar(8) NOT NULL DEFAULT 'FRIEND',
  PRIMARY KEY (`USER_ID`,`TARGET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.relations:~4 rows (대략적) 내보내기
/*!40000 ALTER TABLE `relations` DISABLE KEYS */;
INSERT INTO `relations` (`USER_ID`, `TARGET_ID`, `RELATION_TYPE`) VALUES
	(1, 2, 'FRIEND'),
	(1, 3, 'FRIEND'),
	(2, 1, 'FRIEND'),
	(3, 1, 'FRIEND');
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
	(1, 1, '변경 후 타이틀', 'notice', 0),
	(1, 2, 'Room', 'notice', 0);
/*!40000 ALTER TABLE `room_info` ENABLE KEYS */;

-- 테이블 chat.room_message_1 구조 내보내기
CREATE TABLE IF NOT EXISTS `room_message_1` (
  `MSG_NUM` int(11) NOT NULL AUTO_INCREMENT,
  `SEND_USER_ID` int(11) NOT NULL,
  `ORIGINAL_MSG` varchar(1000) CHARACTER SET utf8mb4 NOT NULL,
  `SEND_TIME` datetime NOT NULL DEFAULT current_timestamp(),
  `FROM_LANGUAGE` varchar(5) NOT NULL,
  `TO_ko` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TO_ja` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TO_en` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TO_zh-CN` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TO_zh-TW` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`MSG_NUM`)
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.room_message_1:~166 rows (대략적) 내보내기
/*!40000 ALTER TABLE `room_message_1` DISABLE KEYS */;
INSERT INTO `room_message_1` (`MSG_NUM`, `SEND_USER_ID`, `ORIGINAL_MSG`, `SEND_TIME`, `FROM_LANGUAGE`, `TO_ko`, `TO_ja`, `TO_en`, `TO_zh-CN`, `TO_zh-TW`) VALUES
	(1, 1, '안녕', '2022-11-08 22:22:05', 'ko', '안녕', 'こんにちは', 'Hi.', '你好。', '你好。'),
	(2, 6, '잘 가', '2022-11-08 22:43:46', 'ko', '잘 가', 'じゃね', 'See you later', '走好。', '走好。'),
	(3, 1, 'ㅅㄱ', '2022-11-09 22:58:43', 'ko', 'ㅅㄱ', NULL, 'gg', NULL, NULL),
	(4, 1, '하이요', '2022-11-10 23:21:05', 'ko', '하이요', NULL, 'Hello', NULL, NULL),
	(5, 1, '뭐지', '2022-11-10 23:24:23', 'ko', '뭐지', NULL, 'What is it?', NULL, NULL),
	(6, 1, '아오', '2022-11-11 00:20:34', 'ko', '아오', NULL, 'Oh, my', NULL, NULL),
	(7, 1, '어휴', '2022-11-11 00:21:19', 'ko', '어휴', NULL, 'Oh, my', NULL, NULL),
	(8, 1, '이번엔', '2022-11-11 00:24:35', 'ko', '이번엔', NULL, 'This time,', NULL, NULL),
	(9, 1, '어때?', '2022-11-11 00:27:22', 'ko', '어때?', NULL, 'How is it?', NULL, NULL),
	(10, 1, '이번에야말로', '2022-11-11 00:31:56', 'ko', '이번에야말로', NULL, 'This time,', NULL, NULL),
	(11, 1, '음..', '2022-11-11 00:33:35', 'ko', '음..', NULL, 'Well ..', NULL, NULL),
	(12, 1, '다시 한번', '2022-11-11 00:34:36', 'ko', '다시 한번', NULL, 'Once again,', NULL, NULL),
	(13, 1, '상도야 다시 한번 해보자', '2022-11-11 00:36:18', 'ko', '상도야 다시 한번 해보자', NULL, 'Sangdo, let\'s do it again', NULL, NULL),
	(14, 1, '이젠', '2022-11-11 00:36:41', 'ko', '이젠', NULL, 'Now', NULL, NULL),
	(15, 1, '될까나', '2022-11-11 00:36:43', 'ko', '될까나', NULL, 'Will it work?', NULL, NULL),
	(16, 1, '헤헤 ㅋㅋ', '2022-11-11 00:36:44', 'ko', '헤헤 ㅋㅋ', NULL, 'Hehe', NULL, NULL),
	(17, 1, '너무 빠른가', '2022-11-11 00:37:02', 'ko', '너무 빠른가', NULL, 'Is it too fast?', NULL, NULL),
	(18, 1, '그런 것도 아니었나벼', '2022-11-11 00:37:17', 'ko', '그런 것도 아니었나벼', NULL, 'I think it wasn\'t like that', NULL, NULL),
	(19, 1, '엥', '2022-11-11 00:37:30', 'ko', '엥', NULL, 'What?', NULL, NULL),
	(20, 1, '뭐지요', '2022-11-11 00:37:32', 'ko', '뭐지요', NULL, 'What is it?', NULL, NULL),
	(21, 1, '어랍쇼', '2022-11-11 00:37:35', 'ko', '어랍쇼', NULL, 'Come on', NULL, NULL),
	(22, 1, '이러면', '2022-11-11 00:37:54', 'ko', '이러면', NULL, 'If I do this', NULL, NULL),
	(23, 1, 'ㅋㅋ', '2022-11-11 00:38:12', 'ko', 'ㅋㅋ', NULL, 'lol', NULL, NULL),
	(24, 1, '예 뭐', '2022-11-11 00:38:34', 'ko', '예 뭐', NULL, 'Yeah, well.', NULL, NULL),
	(25, 1, '이번에야말로', '2022-11-11 00:38:35', 'ko', '이번에야말로', NULL, 'This time,', NULL, NULL),
	(26, 1, '성공했네요', '2022-11-11 00:38:37', 'ko', '성공했네요', NULL, 'I succeeded', NULL, NULL),
	(27, 1, '예', '2022-11-11 00:38:56', 'ko', '예', NULL, 'Yes', NULL, NULL),
	(28, 1, '예', '2022-11-11 00:38:56', 'ko', '예', NULL, 'Yes', NULL, NULL),
	(29, 1, '성공했네요', '2022-11-11 00:38:57', 'ko', '성공했네요', NULL, 'I succeeded', NULL, NULL),
	(30, 1, '드디어', '2022-11-11 00:38:58', 'ko', '드디어', NULL, 'At last.', NULL, NULL),
	(31, 1, '아마 버녕ㄱ하는', '2022-11-11 00:39:00', 'ko', '아마 버녕ㄱ하는', NULL, 'I think it\'s Bernyeong-ha', NULL, NULL),
	(32, 1, '시간이', '2022-11-11 00:39:01', 'ko', '시간이', NULL, 'Time', NULL, NULL),
	(33, 1, '좀 걸려서', '2022-11-11 00:39:02', 'ko', '좀 걸려서', NULL, 'It took some time', NULL, NULL),
	(34, 1, '그런 것 같은데', '2022-11-11 00:39:04', 'ko', '그런 것 같은데', NULL, 'I think so', NULL, NULL),
	(35, 1, 'ㄹㅇ', '2022-11-11 00:39:06', 'ko', 'ㄹㅇ', NULL, 'Really', NULL, NULL),
	(36, 1, 'ㄴㅁㄹ', '2022-11-11 00:39:06', 'ko', 'ㄴㅁㄹ', NULL, 'ㅁㄹㄴ', NULL, NULL),
	(37, 1, 'ㅇㄴㅁㄹ', '2022-11-11 00:39:07', 'ko', 'ㅇㄴㅁㄹ', NULL, 'ㄴㅁㄹㅇ', NULL, NULL),
	(38, 1, 'ㅇㄴㅁ', '2022-11-11 00:39:07', 'ko', 'ㅇㄴㅁ', NULL, 'O and N and M', NULL, NULL),
	(39, 1, 'ㄹㅇ', '2022-11-11 00:39:07', 'ko', 'ㄹㅇ', NULL, 'Really', NULL, NULL),
	(40, 1, 'ㄴㅁㄹ', '2022-11-11 00:39:07', 'ko', 'ㄴㅁㄹ', NULL, 'ㅁㄹㄴ', NULL, NULL),
	(41, 1, 'ㅇㄴㅁ', '2022-11-11 00:39:07', 'ko', 'ㅇㄴㅁ', NULL, 'O and N and M', NULL, NULL),
	(42, 1, 'ㄹ', '2022-11-11 00:39:07', 'ko', 'ㄹ', NULL, 'L.', NULL, NULL),
	(43, 1, 'ㅇㄴㅁ', '2022-11-11 00:39:07', 'ko', 'ㅇㄴㅁ', NULL, 'O and N and M', NULL, NULL),
	(44, 1, 'ㄹㅇㄴ', '2022-11-11 00:39:07', 'ko', 'ㄹㅇㄴ', NULL, 'Really', NULL, NULL),
	(45, 1, 'ㅁㄹ', '2022-11-11 00:39:08', 'ko', 'ㅁㄹ', NULL, 'Md', NULL, NULL),
	(46, 1, 'ㅇㄴㅁ', '2022-11-11 00:39:08', 'ko', 'ㅇㄴㅁ', NULL, 'O and N and M', NULL, NULL),
	(47, 1, 'ㄹㅇㄴ', '2022-11-11 00:39:08', 'ko', 'ㄹㅇㄴ', NULL, 'Really', NULL, NULL),
	(48, 1, 'ㅁㅎㄹㅇㄴ므힐ㅇ므호ㅠㄹ', '2022-11-11 00:39:08', 'ko', 'ㅁㅎㄹㅇㄴ므힐ㅇ므호ㅠㄹ', NULL, '(Singing Mu-Hil-Mu-Ho)', NULL, NULL),
	(49, 1, 'ㅇ모ㅠㅜㅎ;.\'ㄹ', '2022-11-11 00:39:09', 'ko', 'ㅇ모ㅠㅜㅎ;.\'ㄹ', NULL, '모ㅠ.\';\'ㄹ', NULL, NULL),
	(50, 1, 'ㅇ노;', '2022-11-11 00:39:09', 'ko', 'ㅇ노;', NULL, 'No;', NULL, NULL),
	(51, 1, 'ㅎ\'ㄹ너', '2022-11-11 00:39:09', 'ko', 'ㅎ\'ㄹ너', NULL, 'H\'r', NULL, NULL),
	(52, 1, '\'ㅎㄹㄴ', '2022-11-11 00:39:09', 'ko', '\'ㅎㄹㄴ', NULL, 'LOL', NULL, NULL),
	(53, 1, 'ㅓㅎ', '2022-11-11 00:39:09', 'ko', 'ㅓㅎ', NULL, 'ㅎㅓ', NULL, NULL),
	(54, 1, 'ㄹ너', '2022-11-11 00:39:09', 'ko', 'ㄹ너', NULL, 'You', NULL, NULL),
	(55, 1, 'ㅎㅇ', '2022-11-11 00:39:10', 'ko', 'ㅎㅇ', NULL, 'H.O', NULL, NULL),
	(56, 1, '모', '2022-11-11 00:39:10', 'ko', '모', NULL, 'Moe.', NULL, NULL),
	(57, 1, 'ㄹㅇㅁ', '2022-11-11 00:39:10', 'ko', 'ㄹㅇㅁ', NULL, 'Really', NULL, NULL),
	(58, 1, '번역하는 시간이번역하는 시간이번역하는 시간이', '2022-11-11 00:39:14', 'ko', '번역하는 시간이번역하는 시간이번역하는 시간이', NULL, 'Translation time... Translation time... Translation time', NULL, NULL),
	(59, 1, '번역하는 시간이번역하는 시간이', '2022-11-11 00:39:15', 'ko', '번역하는 시간이번역하는 시간이', NULL, 'The translation time... The translation time', NULL, NULL),
	(60, 1, '번역하는 시간이번역하는 시간이', '2022-11-11 00:39:15', 'ko', '번역하는 시간이번역하는 시간이', NULL, 'The translation time... The translation time', NULL, NULL),
	(61, 1, '번역하는 시간이', '2022-11-11 00:39:15', 'ko', '번역하는 시간이', NULL, 'Translation time', NULL, NULL),
	(62, 1, '번역하는 시간이', '2022-11-11 00:39:16', 'ko', '번역하는 시간이', NULL, 'Translation time', NULL, NULL),
	(63, 1, '번역하는 시간이번역하는 시간이번역하는 시간이번역하는 시간이', '2022-11-11 00:39:17', 'ko', '번역하는 시간이번역하는 시간이번역하는 시간이번역하는 시간이', NULL, 'Translating time... Translating time... Translating time... Translating time', NULL, NULL),
	(64, 1, '번역하는 시간이', '2022-11-11 00:39:17', 'ko', '번역하는 시간이', NULL, 'Translation time', NULL, NULL),
	(65, 1, '번역하는 시간이', '2022-11-11 00:39:17', 'ko', '번역하는 시간이', NULL, 'Translation time', NULL, NULL),
	(66, 1, '번역하는 시간이', '2022-11-11 00:39:18', 'ko', '번역하는 시간이', NULL, 'Translation time', NULL, NULL),
	(67, 1, '번역하는 시간이', '2022-11-11 00:39:18', 'ko', '번역하는 시간이', NULL, 'Translation time', NULL, NULL),
	(68, 1, '번역하는 시간이', '2022-11-11 00:39:18', 'ko', '번역하는 시간이', NULL, 'Translation time', NULL, NULL),
	(69, 1, '번역하는 시간이', '2022-11-11 00:39:19', 'ko', '번역하는 시간이', NULL, 'Translation time', NULL, NULL),
	(70, 1, '번역하는 시간이', '2022-11-11 00:39:19', 'ko', '번역하는 시간이', NULL, 'Translation time', NULL, NULL),
	(71, 1, '이제 안정권인 듯', '2022-11-11 00:39:21', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(72, 1, '이제 안정권인 듯', '2022-11-11 00:39:44', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(73, 1, '이제 안정권인 듯', '2022-11-11 00:39:45', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(74, 1, '이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯', '2022-11-11 00:39:46', 'ko', '이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯', NULL, 'As if it\'s a stabilization zone, as if it\'s a stabilization zone, as if it\'s a stabilization zone', NULL, NULL),
	(75, 1, '이제 안정권인 듯', '2022-11-11 00:39:46', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(76, 1, '이제 안정권인 듯', '2022-11-11 00:39:46', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(77, 1, '이제 안정권인 듯', '2022-11-11 00:39:47', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(78, 1, '이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯', '2022-11-11 00:39:48', 'ko', '이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯', NULL, 'Now, as if it\'s a stable area, as if it\'s a stable area, as if it\'s a stable area, as if it\'s a stable zone, as if it\'s a stable zone', NULL, NULL),
	(79, 1, '이제 안정권인 듯', '2022-11-11 00:39:48', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(80, 1, '이제 안정권인 듯', '2022-11-11 00:39:49', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(81, 1, '이제 안정권인 듯', '2022-11-11 00:39:49', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(82, 1, '이제 안정권인 듯', '2022-11-11 00:39:49', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(83, 1, '이제 안정권인 듯', '2022-11-11 00:39:49', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(84, 1, '이제 안정권인 듯', '2022-11-11 00:39:50', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(85, 1, '이제 안정권인 듯', '2022-11-11 00:39:50', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(86, 1, '이제 안정권인 듯', '2022-11-11 00:39:50', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(87, 1, '이제 안정권인 듯', '2022-11-11 00:39:50', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(88, 1, '이제 안정권인 듯', '2022-11-11 00:39:50', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(89, 1, '이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯', '2022-11-11 00:39:51', 'ko', '이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯이제 안정권인 듯', NULL, 'As if it\'s a stabilization zone, as if it\'s a stabilization zone, as if it\'s a stabilization zone', NULL, NULL),
	(90, 1, '이제 안정권인 듯', '2022-11-11 00:39:52', 'ko', '이제 안정권인 듯', NULL, 'I think I\'m in the stable zone now', NULL, NULL),
	(91, 1, '휴', '2022-11-11 01:17:02', 'ko', '휴', NULL, 'Phew', NULL, NULL),
	(92, 2, 'what?', '2022-11-11 01:17:41', 'en', '라고', NULL, 'what?', NULL, NULL),
	(93, 2, 'who', '2022-11-11 01:18:44', 'en', 'who', NULL, 'who', NULL, NULL),
	(94, 1, '?', '2022-11-11 01:18:49', 'ko', '?', NULL, '?', NULL, NULL),
	(95, 2, 'ggg', '2022-11-11 01:20:17', 'en', 'g', NULL, 'ggg', NULL, NULL),
	(96, 1, '왜그래', '2022-11-11 01:20:39', 'ko', '왜그래', NULL, 'You\'re acting strange.', NULL, NULL),
	(97, 2, 'ibun', '2022-11-11 01:21:22', 'en', '우', NULL, 'ibun', NULL, NULL),
	(98, 2, 'fuck', '2022-11-11 01:21:32', 'en', '길', NULL, 'fuck', NULL, NULL),
	(99, 1, '다시 해보자', '2022-11-11 01:24:01', 'ko', '다시 해보자', NULL, 'Let\'s do it again', NULL, NULL),
	(100, 1, '진짜 다시', '2022-11-11 01:25:33', 'ko', '진짜 다시', NULL, 'Really, again', NULL, NULL),
	(101, 1, '대체 언제쯤', '2022-11-11 01:26:39', 'ko', '대체 언제쯤', NULL, 'When on earth?', NULL, NULL),
	(102, 1, '크아아악', '2022-11-11 01:27:38', 'ko', '크아아악', NULL, '(Screaming)', NULL, NULL),
	(103, 1, '아니', '2022-11-11 01:28:22', 'ko', '아니', NULL, 'No.', NULL, NULL),
	(104, 1, '뭔데', '2022-11-11 01:29:30', 'ko', '뭔데', NULL, 'What is it', NULL, NULL),
	(105, 1, '대체', '2022-11-11 01:29:31', 'ko', '대체', NULL, 'substitution', NULL, NULL),
	(106, 1, '언제쯤', '2022-11-11 01:33:29', 'ko', '언제쯤', NULL, 'When', NULL, NULL),
	(107, 1, '되는거야잇', '2022-11-11 01:33:37', 'ko', '되는거야잇', NULL, 'It\'s working', NULL, NULL),
	(108, 2, 'fgdsa', '2022-11-11 13:54:38', 'en', 'fgdsa', NULL, 'fgdsa', NULL, NULL),
	(109, 2, 'what??', '2022-11-11 13:54:45', 'en', '뭐?', NULL, 'what??', NULL, NULL),
	(110, 2, 'ggg', '2022-11-11 14:23:13', 'en', 'ggg', NULL, 'ggg', NULL, NULL),
	(111, 2, '헤헤', '2022-11-11 14:23:14', 'en', '헤헤', NULL, '헤헤', NULL, NULL),
	(112, 2, 'hey', '2022-11-11 14:25:09', 'en', '이봐.', NULL, 'hey', NULL, NULL),
	(113, 1, '왜?', '2022-11-11 14:25:11', 'ko', '왜?', NULL, 'Why?', NULL, NULL),
	(114, 2, 'nothing', '2022-11-11 14:25:21', 'en', '아무 것도 없어요.', NULL, 'nothing', NULL, NULL),
	(115, 1, '아무것도 아니라고?', '2022-11-11 14:25:25', 'ko', '아무것도 아니라고?', NULL, 'Nothing?', NULL, NULL),
	(116, 2, 'yes', '2022-11-11 14:25:28', 'en', '네.', NULL, 'yes', NULL, NULL),
	(117, 1, '알았다잉', '2022-11-11 14:25:32', 'ko', '알았다잉', NULL, 'I got it', NULL, NULL),
	(118, 1, '와 진짜', '2022-11-11 14:25:49', 'ko', '와 진짜', NULL, 'Wow, seriously', NULL, NULL),
	(119, 1, '개잘해ㅋㅋ', '2022-11-11 14:25:51', 'ko', '개잘해ㅋㅋ', NULL, 'He\'s so good', NULL, NULL),
	(120, 1, '미친놈', '2022-11-11 14:25:53', 'ko', '미친놈', NULL, 'Lunatic.', NULL, NULL),
	(121, 2, 'fantastic', '2022-11-11 14:25:58', 'en', '환상적이에요.', NULL, 'fantastic', NULL, NULL),
	(122, 1, '그러니깐 ㅋㅋ', '2022-11-11 14:26:02', 'ko', '그러니깐 ㅋㅋ', NULL, 'That\'s what I\'m saying', NULL, NULL),
	(123, 1, '유후', '2022-11-11 14:35:30', 'ko', '유후', NULL, 'yoo-hoo', NULL, NULL),
	(124, 1, 'ㅇㄹㅇㄴㅁ', '2022-11-11 14:35:30', 'ko', 'ㅇㄹㅇㄴㅁ', NULL, 'It\'s true', NULL, NULL),
	(125, 1, 'ㄹㅇ', '2022-11-11 14:35:30', 'ko', 'ㄹㅇ', NULL, 'Really', NULL, NULL),
	(126, 1, 'ㄴㅁㄹ', '2022-11-11 14:35:30', 'ko', 'ㄴㅁㄹ', NULL, 'ㅁㄹㄴ', NULL, NULL),
	(127, 1, 'ㅇㄴㅁ', '2022-11-11 14:35:30', 'ko', 'ㅇㄴㅁ', NULL, 'O and N and M', NULL, NULL),
	(128, 1, 'ㄹㅇㄴ', '2022-11-11 14:35:30', 'ko', 'ㄹㅇㄴ', NULL, 'Really', NULL, NULL),
	(129, 1, 'ㅁㄹ', '2022-11-11 14:35:30', 'ko', 'ㅁㄹ', NULL, 'Md', NULL, NULL),
	(130, 1, 'ㅇㄴㅁ', '2022-11-11 14:35:31', 'ko', 'ㅇㄴㅁ', NULL, 'O and N and M', NULL, NULL),
	(131, 1, 'ㄹㅇ', '2022-11-11 14:35:31', 'ko', 'ㄹㅇ', NULL, 'Really', NULL, NULL),
	(132, 1, 'ㄴㅁㄹ', '2022-11-11 14:35:31', 'ko', 'ㄴㅁㄹ', NULL, 'ㅁㄹㄴ', NULL, NULL),
	(133, 1, 'ㅇㅁ', '2022-11-11 14:35:31', 'ko', 'ㅇㅁ', NULL, 'O and M', NULL, NULL),
	(134, 1, 'ㄹㅇ', '2022-11-11 14:35:31', 'ko', 'ㄹㅇ', NULL, 'Really', NULL, NULL),
	(135, 1, 'ㄴㅁㄹ', '2022-11-11 14:35:31', 'ko', 'ㄴㅁㄹ', NULL, 'ㅁㄹㄴ', NULL, NULL),
	(136, 1, 'ㅇ', '2022-11-11 14:35:31', 'ko', 'ㅇ', NULL, 'H', NULL, NULL),
	(137, 2, 'fdhsapofzdksaf', '2022-11-11 14:35:38', 'en', 'fdhsapofzdksaf', NULL, 'fdhsapofzdksaf', NULL, NULL),
	(138, 2, 'dsa', '2022-11-11 14:35:38', 'en', 'dsa', NULL, 'dsa', NULL, NULL),
	(139, 2, 'fds', '2022-11-11 14:35:38', 'en', 'Fds.', NULL, 'fds', NULL, NULL),
	(140, 2, 'af', '2022-11-11 14:35:38', 'en', 'af의', NULL, 'af', NULL, NULL),
	(141, 2, 'dsa', '2022-11-11 14:35:38', 'en', 'dsa', NULL, 'dsa', NULL, NULL),
	(142, 2, 'fd', '2022-11-11 14:35:38', 'en', 'fd', NULL, 'fd', NULL, NULL),
	(143, 2, 'sa', '2022-11-11 14:35:38', 'en', '사', NULL, 'sa', NULL, NULL),
	(144, 2, 'fdsa', '2022-11-11 14:35:38', 'en', 'fdsa', NULL, 'fdsa', NULL, NULL),
	(145, 2, 'fd', '2022-11-11 14:35:38', 'en', 'fd', NULL, 'fd', NULL, NULL),
	(146, 2, 'af', '2022-11-11 14:35:38', 'en', 'af의', NULL, 'af', NULL, NULL),
	(147, 2, 'd', '2022-11-11 14:35:38', 'en', 'd', NULL, 'd', NULL, NULL),
	(148, 2, 'fdsa', '2022-11-11 14:41:26', 'en', 'fdsa', NULL, 'fdsa', NULL, NULL),
	(149, 2, 'fdsa', '2022-11-11 14:41:26', 'en', 'fdsa', NULL, 'fdsa', NULL, NULL),
	(150, 2, 'fdsa', '2022-11-11 14:41:26', 'en', 'fdsa', NULL, 'fdsa', NULL, NULL),
	(151, 2, 'fdsaf', '2022-11-11 14:41:27', 'en', 'fdsaf', NULL, 'fdsaf', NULL, NULL),
	(152, 2, 'dsa', '2022-11-11 14:41:27', 'en', 'dsa', NULL, 'dsa', NULL, NULL),
	(153, 2, 'fdsa', '2022-11-11 14:41:27', 'en', 'fdsa', NULL, 'fdsa', NULL, NULL),
	(154, 2, 'fdsafdsaf', '2022-11-11 14:41:28', 'en', 'fdsafdsaf', NULL, 'fdsafdsaf', NULL, NULL),
	(155, 1, '와우', '2022-11-11 14:41:56', 'ko', '와우', NULL, 'Wow!', NULL, NULL),
	(156, 1, '워우', '2022-11-11 14:41:57', 'ko', '워우', NULL, 'Wow', NULL, NULL),
	(157, 1, '효', '2022-11-11 14:41:57', 'ko', '효', NULL, 'filial duty', NULL, NULL),
	(158, 1, '우휴', '2022-11-11 14:41:58', 'ko', '우휴', NULL, 'Whoo-hoo!', NULL, NULL),
	(159, 1, '우휴', '2022-11-11 14:41:59', 'ko', '우휴', NULL, 'Whoo-hoo!', NULL, NULL),
	(160, 1, '유후', '2022-11-11 14:42:00', 'ko', '유후', NULL, 'yoo-hoo', NULL, NULL),
	(161, 1, '헤헤헤헤ㅔ', '2022-11-11 14:42:01', 'ko', '헤헤헤헤ㅔ', NULL, 'Hehehehe', NULL, NULL),
	(162, 2, 'ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ', '2022-11-11 23:37:18', 'en', 'ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ', NULL, 'ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ', NULL, NULL),
	(163, 2, '여긴 어디여', '2022-11-11 23:43:13', 'en', '여긴 어디여', NULL, '여긴 어디여', NULL, NULL),
	(164, 2, '갸앙아악', '2022-11-12 00:01:32', 'en', '갸앙아악', NULL, '갸앙아악', NULL, NULL),
	(165, 2, '어휴', '2022-11-12 00:01:37', 'en', '어휴', NULL, '어휴', NULL, NULL),
	(166, 1, '안 되나요', '2022-11-12 17:40:01', 'ko', '안 되나요', NULL, NULL, NULL, NULL);
/*!40000 ALTER TABLE `room_message_1` ENABLE KEYS */;

-- 테이블 chat.users 구조 내보내기
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `EMAIL` varchar(64) NOT NULL,
  `PASSWORD` varchar(65) NOT NULL,
  `NAME` varchar(30) NOT NULL,
  `LANGUAGE` varchar(5) NOT NULL,
  `COMPANY_NAME` varchar(30) DEFAULT NULL,
  `IMG_URL` varchar(50) NOT NULL DEFAULT 'default_profile.jpg',
  `COMPANY_START` time DEFAULT NULL,
  `COMPANY_END` time DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `EMAIL` (`EMAIL`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.users:~3 rows (대략적) 내보내기
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`ID`, `EMAIL`, `PASSWORD`, `NAME`, `LANGUAGE`, `COMPANY_NAME`, `IMG_URL`, `COMPANY_START`, `COMPANY_END`) VALUES
	(1, '1812105@du.ac.kr', 'acd202bb391b4712518fe87bb26775053b3d55171a80bcb6b5ab7a9e44a914f9', '박상도', 'ko', NULL, 'default_profile.jpg', NULL, NULL),
	(2, 'tkdeh129@naver.com', 'acd202bb391b4712518fe87bb26775053b3d55171a80bcb6b5ab7a9e44a914f9', '상도박', 'en', NULL, 'default_profile.jpg', NULL, NULL),
	(3, 'aa55235490@gmail.com', '55daf76ebb48896ce06ae11eac5cf86dc975ced67f0ab9ce1c57efe6a5ca010b', '박상도', 'ja', NULL, '1668317182850KakaoTalk_20221113_141205219.jpg', NULL, NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
