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

-- 프로시저 chat.DELETE_ROOM_IN_USER 구조 내보내기
DELIMITER //
CREATE PROCEDURE `DELETE_ROOM_IN_USER`( IN roomID INT, IN userId INT )
BEGIN
	DELETE FROM room_info WHERE ROOM_ID = roomID AND USER_ID = userID;
	
	IF (SELECT USER_ID FROM room_info WHERE ROOM_ID = roomID LIMIT 1) IS NULL THEN
		DELETE FROM room_list WHERE ROOM_ID = roomID;
		SET @sqlQuery = CONCAT('DROP TABLE room_message_', roomID);
		PREPARE DROP_TABLE FROM @sqlQuery;
		EXECUTE DROP_TABLE;
		DEALLOCATE PREPARE DROP_TABLE;
	END IF;
END//
DELIMITER ;

-- 프로시저 chat.GET_NULLTEXT 구조 내보내기
DELIMITER //
CREATE PROCEDURE `GET_NULLTEXT`(
	IN `roomId` INT,
	IN `lang` VARCHAR(5)
)
BEGIN
	SET @sqlQuery = CONCAT('SELECT MSG_NUM, ORIGINAL_MSG, FROM_LANGUAGE FROM room_message_', roomId, ' WHERE `TO_', lang, '` IS NULL AND SEND_USER_ID != 0');
	PREPARE printNullText FROM @sqlQuery;
	EXECUTE printNullText;
	DEALLOCATE PREPARE printNullText;
END//
DELIMITER ;

-- 프로시저 chat.GET_PERMISSION_CHECK 구조 내보내기
DELIMITER //
CREATE PROCEDURE `GET_PERMISSION_CHECK`( IN roomId INT, IN userID INT )
BEGIN
	SELECT users.LANGUAGE, info.ROOM_NAME FROM room_info AS info, users
	WHERE info.USER_ID = userId AND info.ROOM_ID = roomId AND info.USER_ID = users.ID;
END//
DELIMITER ;

-- 프로시저 chat.GET_ROOMUPDATE 구조 내보내기
DELIMITER //
CREATE PROCEDURE `GET_ROOMUPDATE`(
	IN `userID` INT
)
BEGIN
	SELECT UPDATE_CHECK FROM room_info
	WHERE UPDATE_CHECK = 1 AND USER_id = userid
	GROUP BY UPDATE_CHECK;
END//
DELIMITER ;

-- 테이블 chat.relations 구조 내보내기
CREATE TABLE IF NOT EXISTS `relations` (
  `USER_ID` int(11) NOT NULL,
  `TARGET_ID` int(11) NOT NULL,
  `RELATION_TYPE` varchar(8) NOT NULL DEFAULT 'FRIEND',
  PRIMARY KEY (`USER_ID`,`TARGET_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.relations:~16 rows (대략적) 내보내기
/*!40000 ALTER TABLE `relations` DISABLE KEYS */;
INSERT INTO `relations` (`USER_ID`, `TARGET_ID`, `RELATION_TYPE`) VALUES
	(1, 2, 'FRIEND'),
	(1, 3, 'FRIEND'),
	(1, 4, 'FRIEND'),
	(1, 5, 'FRIEND'),
	(1, 8, 'FRIEND'),
	(2, 1, 'FRIEND'),
	(3, 1, 'FRIEND'),
	(4, 1, 'FRIEND'),
	(5, 1, 'FRIEND'),
	(5, 7, 'FRIEND'),
	(5, 8, 'FRIEND'),
	(7, 5, 'FRIEND'),
	(7, 8, 'FRIEND'),
	(8, 1, 'FRIEND'),
	(8, 5, 'FRIEND'),
	(8, 7, 'FRIEND');
/*!40000 ALTER TABLE `relations` ENABLE KEYS */;

-- 테이블 chat.room_info 구조 내보내기
CREATE TABLE IF NOT EXISTS `room_info` (
  `ROOM_ID` int(11) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  `ROOM_NAME` varchar(15) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'Room',
  `NOTICE_TYPE` varchar(8) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'notice',
  `FAVORITES` tinyint(1) NOT NULL DEFAULT 0,
  `UPDATE_CHECK` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`ROOM_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.room_info:~10 rows (대략적) 내보내기
/*!40000 ALTER TABLE `room_info` DISABLE KEYS */;
INSERT INTO `room_info` (`ROOM_ID`, `USER_ID`, `ROOM_NAME`, `NOTICE_TYPE`, `FAVORITES`, `UPDATE_CHECK`) VALUES
	(1, 1, '테스트 룸 2', 'notice', 0, 0),
	(1, 2, 'Room', 'notice', 0, 1),
	(1, 3, 'Room', 'notice', 0, 1),
	(1, 4, 'Room', 'notice', 0, 1),
	(1, 5, 'Room', 'notice', 0, 1),
	(2, 1, '테스트 룸 1', 'notice', 0, 0),
	(3, 1, '테스트 룸 3', 'notice', 0, 0),
	(3, 5, '테스트방', 'notice', 0, 0),
	(3, 7, 'Room', 'notice', 0, 1),
	(3, 8, 'ROOM@@@', 'notice', 0, 0);
/*!40000 ALTER TABLE `room_info` ENABLE KEYS */;

-- 테이블 chat.room_list 구조 내보내기
CREATE TABLE IF NOT EXISTS `room_list` (
  `ROOM_ID` int(11) NOT NULL AUTO_INCREMENT,
  `LAST_MSG` varchar(1000) NOT NULL DEFAULT 'No Messages.',
  `LAST_SEND_TIME` datetime DEFAULT NULL,
  PRIMARY KEY (`ROOM_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- 테이블 데이터 chat.room_list:~3 rows (대략적) 내보내기
/*!40000 ALTER TABLE `room_list` DISABLE KEYS */;
INSERT INTO `room_list` (`ROOM_ID`, `LAST_MSG`, `LAST_SEND_TIME`) VALUES
	(1, '아 됐다', '2022-11-20 00:28:04'),
	(2, 'No Messages.', NULL),
	(3, 'hi', '2022-11-20 16:49:19');
/*!40000 ALTER TABLE `room_list` ENABLE KEYS */;

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.room_message_1:~10 rows (대략적) 내보내기
/*!40000 ALTER TABLE `room_message_1` DISABLE KEYS */;
INSERT INTO `room_message_1` (`MSG_NUM`, `SEND_USER_ID`, `ORIGINAL_MSG`, `SEND_TIME`, `FROM_LANGUAGE`, `TO_ko`, `TO_ja`, `TO_en`, `TO_zh-CN`, `TO_zh-TW`) VALUES
	(1, 3, 'Hello.', '2022-11-17 21:48:31', 'en', '안녕하세요.', 'お早う。', 'Hello.', NULL, NULL),
	(2, 1, '반갑습니다.', '2022-11-17 21:48:42', 'ko', '반갑습니다.', '嬉しいです.', 'Nice to meet you.', NULL, NULL),
	(3, 3, 'are you korean?', '2022-11-17 22:01:41', 'en', '한국인이니?', 'あなたは韓国人ですか？', 'are you korean?', NULL, NULL),
	(4, 1, '네네 맞아요', '2022-11-17 22:01:48', 'ko', '네네 맞아요', 'はいはい、そうです。', 'Yes, that&#39;s right', NULL, NULL),
	(5, 1, '어디사세요?', '2022-11-17 22:05:52', 'ko', '어디사세요?', 'どこに住んでいますか？', 'Where do you live?', NULL, NULL),
	(6, 3, 'I live in Brighton.', '2022-11-17 22:07:24', 'en', '저는 브라이튼에 살아요.', '私はブライトンに住んでいます。', 'I live in Brighton.', NULL, NULL),
	(7, 3, 'How about you?', '2022-11-17 22:08:03', 'en', '당신은요?', 'あなたはどう？', 'How about you?', NULL, NULL),
	(8, 1, '들어도 모르실걸요?', '2022-11-17 22:08:28', 'ko', '들어도 모르실걸요?', '聞いても分からないと思いますよ？', 'You won&#39;t know even if you hear it', NULL, NULL),
	(9, 0, '"user" has entered.', '2022-11-17 21:48:31', 'en', NULL, NULL, NULL, NULL, NULL),
	(10, 0, 'test1 has Entered.', '2022-11-20 00:27:55', 'en', NULL, NULL, NULL, NULL, NULL),
	(11, 1, '아 됐다', '2022-11-20 00:28:04', 'ko', '아 됐다', NULL, NULL, NULL, NULL),
	(12, 0, '황준연 has Entered.', '2022-11-20 19:56:06', 'en', NULL, NULL, NULL, NULL, NULL);
/*!40000 ALTER TABLE `room_message_1` ENABLE KEYS */;

-- 테이블 chat.room_message_2 구조 내보내기
CREATE TABLE IF NOT EXISTS `room_message_2` (
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.room_message_2:~2 rows (대략적) 내보내기
/*!40000 ALTER TABLE `room_message_2` DISABLE KEYS */;
INSERT INTO `room_message_2` (`MSG_NUM`, `SEND_USER_ID`, `ORIGINAL_MSG`, `SEND_TIME`, `FROM_LANGUAGE`, `TO_ko`, `TO_ja`, `TO_en`, `TO_zh-CN`, `TO_zh-TW`) VALUES
	(1, 0, '황준연 has Entered.', '2022-11-20 16:44:09', 'en', NULL, NULL, NULL, NULL, NULL),
	(2, 0, '박상도 has Entered.', '2022-11-20 16:44:09', 'en', NULL, NULL, NULL, NULL, NULL);
/*!40000 ALTER TABLE `room_message_2` ENABLE KEYS */;

-- 테이블 chat.room_message_3 구조 내보내기
CREATE TABLE IF NOT EXISTS `room_message_3` (
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.room_message_3:~13 rows (대략적) 내보내기
/*!40000 ALTER TABLE `room_message_3` DISABLE KEYS */;
INSERT INTO `room_message_3` (`MSG_NUM`, `SEND_USER_ID`, `ORIGINAL_MSG`, `SEND_TIME`, `FROM_LANGUAGE`, `TO_ko`, `TO_ja`, `TO_en`, `TO_zh-CN`, `TO_zh-TW`) VALUES
	(1, 0, '황준연 has Entered.', '2022-11-20 16:45:09', 'en', NULL, NULL, NULL, NULL, NULL),
	(2, 0, 'SANGDOMAN has Entered.', '2022-11-20 16:45:09', 'en', NULL, NULL, NULL, NULL, NULL),
	(3, 5, 'hi', '2022-11-20 16:45:16', 'ko', 'hi', NULL, 'hi', NULL, NULL),
	(4, 5, '안녕하세요', '2022-11-20 16:45:19', 'ko', '안녕하세요', NULL, 'Hello', NULL, NULL),
	(5, 8, 'hello', '2022-11-20 16:45:22', 'en', '안녕하세요.', NULL, 'hello', NULL, NULL),
	(6, 8, 'where are you from', '2022-11-20 16:45:28', 'en', '어디서 오셨나요?', NULL, 'where are you from', NULL, NULL),
	(7, 5, '한국에서 왔습니다.', '2022-11-20 16:45:33', 'ko', '한국에서 왔습니다.', NULL, 'I am from Korea.', NULL, NULL),
	(8, 8, 'ah ok', '2022-11-20 16:45:36', 'en', '아, 알았어요', NULL, 'ah ok', NULL, NULL),
	(9, 0, '박상도 has Entered.', '2022-11-20 16:46:02', 'en', NULL, NULL, NULL, NULL, NULL),
	(10, 5, 'ㅁㄴㅇㄹ', '2022-11-20 16:46:06', 'ko', 'ㅁㄴㅇㄹ', NULL, 'ㄴㅇㄹㅁ', NULL, NULL),
	(11, 5, '반갑습니다', '2022-11-20 16:46:11', 'ko', '반갑습니다', NULL, 'Nice to meet you.', NULL, NULL),
	(12, 0, '박상도 has Entered.', '2022-11-20 16:46:21', 'en', NULL, NULL, NULL, NULL, NULL),
	(13, 8, 'hi', '2022-11-20 16:49:19', 'en', '안녕하세요.', NULL, 'hi', NULL, NULL);
/*!40000 ALTER TABLE `room_message_3` ENABLE KEYS */;

-- 프로시저 chat.UPDATE_CHANGES 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_CHANGES`( IN roomId INT )
BEGIN
	UPDATE room_info SET UPDATE_CHECK = 1
	WHERE ROOM_ID = roomId;
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_CONFIRM 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_CONFIRM`( IN userId INT )
BEGIN
	UPDATE room_info SET UPDATE_CHECK = 0
	WHERE USER_ID = userId;
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_FRIEND_REGISTER 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_FRIEND_REGISTER`( IN userId INT, IN targetId INT )
BEGIN
	INSERT INTO relations (USER_ID, TARGET_ID)
	VALUE (userId, targetId), (targetId, userId);
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_INVITE_ROOM 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_INVITE_ROOM`(
	IN `roomId` INT,
	IN `userId` INT
)
BEGIN
	INSERT INTO room_info (ROOM_ID, USER_ID) VALUE (roomId, userId);
	SET @joinMsg = CONCAT((SELECT NAME FROM users WHERE ID = userId), ' has Entered.');
	CALL UPDATE_SEND_ALERT(roomId, @joinMsg);
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_MAKEROOM 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_MAKEROOM`()
BEGIN
	INSERT INTO room_list () VALUE ();
	SELECT @roomId := ROOM_ID AS ROOM_ID FROM room_list ORDER BY ROOM_ID DESC LIMIT 1;
	SET @sqlQuery = CONCAT('CREATE TABLE room_message_', @roomId, ' ('
									'MSG_NUM int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,',
									'SEND_USER_ID int(11) NOT NULL,',
	                        'ORIGINAL_MSG varchar(1000) CHARACTER SET utf8mb4 NOT NULL,',
	                        'SEND_TIME datetime NOT NULL DEFAULT current_timestamp(),',
	                        'FROM_LANGUAGE varchar(5) NOT NULL,',
	                        'TO_ko varchar(1000) CHARACTER SET utf8mb4,',
	                        'TO_ja varchar(1000) CHARACTER SET utf8mb4,',
	                        'TO_en varchar(1000) CHARACTER SET utf8mb4,',
	                        '`TO_zh-CN` varchar(1000) CHARACTER SET utf8mb4,',
	                        '`TO_zh-TW` varchar(1000) CHARACTER SET utf8mb4) CHARSET=utf8;');
	PREPARE MAKE_ROOM FROM @sqlQuery;
	EXECUTE MAKE_ROOM;
	DEALLOCATE PREPARE MAKE_ROOM;
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_ROOM_TITLE 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_ROOM_TITLE`(
	IN `roomId` INT,
	IN `userId` INT,
	IN `title` VARCHAR(15) CHARACTER SET UTF8MB4
)
BEGIN
	UPDATE room_info SET ROOM_NAME = title
	WHERE ROOM_ID = roomId AND USER_ID = userId;
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_SEND_ALERT 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_SEND_ALERT`( IN roomId INT, IN msg VARCHAR(100) )
BEGIN
	SET @sqlQuery = CONCAT('INSERT INTO room_message_', roomId, ' (SEND_USER_ID, ORIGINAL_MSG, FROM_LANGUAGE) VALUES (0, "', msg, '", "en")');
	PREPARE addMsg FROM @sqlQuery;
	EXECUTE addMsg;
	DEALLOCATE PREPARE addMsg;
	
	SET @sqlQuery = CONCAT('SELECT MSG_NUM FROM room_message_', roomId, ' ORDER BY MSG_NUM DESC LIMIT 1');
	PREPARE getLastMsg FROM @sqlQuery;
	EXECUTE getLastMsg;
	DEALLOCATE PREPARE getLastMsg;
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_SEND_MESSAGE 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_SEND_MESSAGE`(
	IN `roomId` INT,
	IN `userId` INT,
	IN `msg` VARCHAR(1000) CHARACTER SET utf8mb4
)
BEGIN
	SET @sqlQuery = CONCAT('INSERT INTO room_message_', roomId, ' (SEND_USER_ID, ORIGINAL_MSG, FROM_LANGUAGE) '
						, 'SELECT ID, "', msg, '", LANGUAGE FROM users WHERE ID = ', userId);
	PREPARE addMsg FROM @sqlQuery;
	EXECUTE addMsg;
	DEALLOCATE PREPARE addMsg;
	
	SET @sqlQuery = CONCAT('UPDATE room_list AS a, (SELECT ORIGINAL_MSG AS msg, SEND_TIME FROM room_message_', roomId, ' AS b ORDER BY MSG_NUM DESC LIMIT 1) AS b'
						, ' SET a.LAST_MSG = b.msg, a.LAST_SEND_TIME = b.SEND_TIME WHERE a.ROOM_ID = ', roomId);
	PREPARE updatePreview FROM @sqlQuery;
	EXECUTE updatePreview;
	DEALLOCATE PREPARE updatePreview;
	
	SET @sqlQuery = CONCAT('SELECT MSG_NUM FROM room_message_', roomId, ' ORDER BY MSG_NUM DESC LIMIT 1');
	PREPARE getLastMsg FROM @sqlQuery;
	EXECUTE getLastMsg;
	DEALLOCATE PREPARE getLastMsg;
	
	CALL UPDATE_CHANGES(roomId);
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_TRANSLATION 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_TRANSLATION`(
	IN `roomId` INT,
	IN `msgNum` INT,
	IN `lang` VARCHAR(5),
	IN `translation` VARCHAR(1000) CHARACTER SET UTF8MB4
)
BEGIN
	SET @sqlQuery = CONCAT('UPDATE room_message_', roomId, ' SET `TO_', lang, '` = "', translation, '" WHERE MSG_NUM = ', msgNum);
	PREPARE updateText FROM @sqlQuery;
	EXECUTE updateText;
	DEALLOCATE PREPARE updateText;
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_USER_REGISTER 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_USER_REGISTER`( IN email VARCHAR(64), IN pw VARCHAR(65), IN NAME VARCHAR(30) CHARACTER SET UTF8MB4, IN lang VARCHAR(5))
BEGIN
	INSERT INTO users(EMAIL, PASSWORD, NAME, LANGUAGE) VALUE (email, pw, NAME, lang);
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_USER_REGISTER_cEnd 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_USER_REGISTER_cEnd`( IN email VARCHAR(64), IN cEnd TIME )
BEGIN
	SET @sqlQuery = CONCAT('UPDATE users SET COMPANY_END = "', cEnd, '" WHERE EMAIL LIKE "', email, '"');
	PREPARE UPDATE_INFO FROM @sqlQuery;
	EXECUTE UPDATE_INFO;
	DEALLOCATE PREPARE UPDATE_INFO;
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_USER_REGISTER_cName 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_USER_REGISTER_cName`( IN email VARCHAR(64), IN cName VARCHAR(50) CHARACTER SET UTF8MB4 )
BEGIN
	SET @sqlQuery = CONCAT('UPDATE users SET COMPANY_NAME = "', cName, '" WHERE EMAIL LIKE "', email, '"');
	PREPARE UPDATE_INFO FROM @sqlQuery;
	EXECUTE UPDATE_INFO;
	DEALLOCATE PREPARE UPDATE_INFO;
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_USER_REGISTER_cStart 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_USER_REGISTER_cStart`( IN email VARCHAR(64), IN cStart TIME )
BEGIN
	SET @sqlQuery = CONCAT('UPDATE users SET COMPANY_START = "', cStart, '" WHERE EMAIL LIKE "', email, '"');
	PREPARE UPDATE_INFO FROM @sqlQuery;
	EXECUTE UPDATE_INFO;
	DEALLOCATE PREPARE UPDATE_INFO;
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_USER_REGISTER_IMG 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_USER_REGISTER_IMG`( IN email VARCHAR(64), IN imgUrl VARCHAR(200) )
BEGIN
	SET @sqlQuery = CONCAT('UPDATE users SET IMG_URL = "', imgUrl, '" WHERE EMAIL LIKE "', email, '"');
	PREPARE UPDATE_INFO FROM @sqlQuery;
	EXECUTE UPDATE_INFO;
	DEALLOCATE PREPARE UPDATE_INFO;
END//
DELIMITER ;

-- 테이블 chat.users 구조 내보내기
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `EMAIL` varchar(64) NOT NULL,
  `PASSWORD` varchar(65) NOT NULL,
  `NAME` varchar(30) NOT NULL,
  `LANGUAGE` varchar(5) NOT NULL,
  `COMPANY_NAME` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `IMG_URL` varchar(200) NOT NULL DEFAULT 'default_profile.jpg',
  `COMPANY_START` time DEFAULT NULL,
  `COMPANY_END` time DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `EMAIL` (`EMAIL`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.users:~7 rows (대략적) 내보내기
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`ID`, `EMAIL`, `PASSWORD`, `NAME`, `LANGUAGE`, `COMPANY_NAME`, `IMG_URL`, `COMPANY_START`, `COMPANY_END`) VALUES
	(1, '1812105@du.ac.kr', 'a49932b7fe6e0bc17dd7f5aefb5cf59c15967767f858a3904afac5892a2235c7', '박상도', 'ko', '동서울대', 'default_profile.jpg', '09:00:00', '18:00:00'),
	(2, 'aa55235490@gmail.com', '55daf76ebb48896ce06ae11eac5cf86dc975ced67f0ab9ce1c57efe6a5ca010b', 'パク·サンド', 'ja', NULL, '1668688775674neko.jpg', '08:00:00', '11:00:00'),
	(3, 'englishman@gmail.com', '7c8eec2d35d8cacbb70d5d79f61a2906f89a6f625c4aaa261622601e6aef100d', 'Homens', 'en', 'East Empire Company', '1668689027579englishMan.png', '00:00:00', '23:59:00'),
	(4, 'test1', '7c8eec2d35d8cacbb70d5d79f61a2906f89a6f625c4aaa261622601e6aef100d', 'test1', 'en', 'East Empire Company', '1668689027579englishMan.png', '00:00:00', '23:59:00'),
	(5, '1812062@du.ac.kr', '7df857adb66501698de7a6735b3ef7a1e4153c080c2ea4ab99b81ccdf7acbaa1', '황준연', 'ko', '동서울대학교', 'default_profile.jpg', '09:00:00', '18:00:00'),
	(7, 'tkdeh129@naver.com', '55daf76ebb48896ce06ae11eac5cf86dc975ced67f0ab9ce1c57efe6a5ca010b', '박상도', 'zh-CN', 'DONGSEOULUNIVERCITY', 'default_profile.jpg', NULL, NULL),
	(8, 'reaui19@naver.com', '55daf76ebb48896ce06ae11eac5cf86dc975ced67f0ab9ce1c57efe6a5ca010b', '박상도', 'zh-CN', 'DONGSEOULUNIVERCITY', '1668931113000neko.jpg', NULL, NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- 프로시저 chat.VIEW_ALL_MESSAGES 구조 내보내기
DELIMITER //
CREATE PROCEDURE `VIEW_ALL_MESSAGES`(
	IN `roomId` INT,
	IN `lang` VARCHAR(5)
)
BEGIN
	SET @sqlQuery = CONCAT('SELECT msg.MSG_NUM, msg.SEND_USER_ID, users.NAME, users.LANGUAGE, users.IMG_URL, ',
									'msg.ORIGINAL_MSG, IFNULL(msg.`TO_', lang, '`, ORIGINAL_MSG) AS MSG, msg.SEND_TIME FROM users ', 
									'RIGHT OUTER JOIN room_message_', roomId, ' AS msg ON users.ID = msg.SEND_USER_ID');
	PREPARE CALL_MESSAGES FROM @sqlQuery;
	EXECUTE CALL_MESSAGES;
	DEALLOCATE PREPARE CALL_MESSAGES;
END//
DELIMITER ;

-- 프로시저 chat.VIEW_FRIENDS 구조 내보내기
DELIMITER //
CREATE PROCEDURE `VIEW_FRIENDS`( IN userId INT )
BEGIN
	SELECT ID, NAME, EMAIL, LANGUAGE, IMG_URL FROM users
	WHERE ID = userId;
	
	SELECT u.ID, u.NAME, u.EMAIL, u.LANGUAGE, u.IMG_URL FROM users AS u, relations AS r
	WHERE r.USER_ID = userId AND u.ID = r.TARGET_ID AND r.RELATION_TYPE = 'FRIEND';
END//
DELIMITER ;

-- 프로시저 chat.VIEW_ROOMSLIST 구조 내보내기
DELIMITER //
CREATE PROCEDURE `VIEW_ROOMSLIST`(
	IN `userId` INT
)
BEGIN
	SET @sqlQuery = CONCAT('SELECT room_info.ROOM_ID, ROOM_NAME, FAVORITES, LAST_MSG, LAST_SEND_TIME FROM '
						, 'room_info, room_list WHERE room_info.ROOM_ID = room_list.ROOM_ID AND USER_ID = ', userId
						, ' ORDER BY LAST_SEND_TIME DESC');
	PREPARE viewJoinRoom FROM @sqlQuery;
	EXECUTE viewJoinRoom;
	DEALLOCATE PREPARE viewJoinRoom;

	CALL UPDATE_CONFIRM(userId);
END//
DELIMITER ;

-- 프로시저 chat.VIEW_ROOM_IN_USER 구조 내보내기
DELIMITER //
CREATE PROCEDURE `VIEW_ROOM_IN_USER`( IN roomId INT )
BEGIN
	SELECT ID, NAME, LANGUAGE, IMG_URL
	FROM users, room_info
	WHERE users.ID = room_info.USER_ID AND room_info.ROOM_ID = roomId;
END//
DELIMITER ;

-- 프로시저 chat.VIEW_SEARCH_EMAIL 구조 내보내기
DELIMITER //
CREATE PROCEDURE `VIEW_SEARCH_EMAIL`(
	IN `userId` INT,
	IN `factor` VARCHAR(1000) CHARACTER SET UTF8MB4
)
BEGIN
	SET @sqlQuery = CONCAT('SELECT ID, EMAIL, NAME, LANGUAGE, IMG_URL FROM users ',
					'LEFT OUTER JOIN (SELECT * FROM relations WHERE USER_ID = ', userId, ') AS relations ',
					'ON ID = TARGET_ID WHERE EMAIL LIKE "%', factor, '%" AND ID != ', userId, ' AND TARGET_ID IS NULL');
	PREPARE SEARCH_EMAIL FROM @sqlQuery;
	EXECUTE SEARCH_EMAIL;
	DEALLOCATE PREPARE SEARCH_EMAIL;
END//
DELIMITER ;

-- 프로시저 chat.VIEW_SEARCH_FRIENDS 구조 내보내기
DELIMITER //
CREATE PROCEDURE `VIEW_SEARCH_FRIENDS`(
	IN `userId` INT,
	IN `factor` VARCHAR(1000) CHARACTER SET UTF8MB4
)
BEGIN
	SET @sqlQuery = CONCAT('SELECT users.ID, users.EMAIL, users.NAME, users.LANGUAGE, users.IMG_URL FROM users, relations ',
                    'WHERE ((users.EMAIL LIKE "%', factor, '%") OR (users.NAME LIKE "%', factor, '%")) ',
                    'AND (users.ID = relations.TARGET_ID AND RELATION_TYPE = "FRIEND" AND USER_ID = ', userId, ')');
	PREPARE SEARCH_FRIENDS FROM @sqlQuery;
	EXECUTE SEARCH_FRIENDS;
	DEALLOCATE PREPARE SEARCH_FRIENDS;
END//
DELIMITER ;

-- 프로시저 chat.VIEW_SEARCH_NOTINVITED 구조 내보내기
DELIMITER //
CREATE PROCEDURE `VIEW_SEARCH_NOTINVITED`( IN roomId INT, IN userId INT, IN factor VARCHAR(1000) CHARACTER SET UTF8MB4 )
BEGIN
	SET @sqlQuery = CONCAT('SELECT u.ID, u.EMAIL, u.NAME, u.IMG_URL ',
								'FROM users AS u, relations AS r ',
								'LEFT OUTER JOIN (SELECT * FROM room_info WHERE ROOM_ID = ', roomId,') AS i ',
								'ON r.TARGET_ID = i.USER_ID ',
								'WHERE (u.EMAIL LIKE "%', factor,'%" OR u.NAME LIKE "%', factor,'%") AND r.USER_ID = ', userId,
								' AND (u.ID = r.TARGET_ID AND r.RELATION_TYPE = "FRIEND" AND i.USER_ID IS NULL)');
	PREPARE SEARCH_FRIENDS FROM @sqlQuery;
	EXECUTE SEARCH_FRIENDS;
	DEALLOCATE PREPARE SEARCH_FRIENDS;
END//
DELIMITER ;

-- 프로시저 chat.VIEW_SINGLE_MESSAGE 구조 내보내기
DELIMITER //
CREATE PROCEDURE `VIEW_SINGLE_MESSAGE`(
	IN `roomId` INT,
	IN `lang` VARCHAR(5),
	IN `msgNum` INT
)
BEGIN
	SET @sqlQuery = CONCAT('SELECT msg.MSG_NUM, msg.SEND_USER_ID, users.NAME, users.LANGUAGE, users.IMG_URL, ',
									'msg.ORIGINAL_MSG, IFNULL(msg.`TO_', lang, '`, ORIGINAL_MSG) AS MSG, msg.SEND_TIME FROM users ', 
									'RIGHT OUTER JOIN room_message_', roomId, ' AS msg ON users.ID = msg.SEND_USER_ID ',
									'WHERE msg.MSG_NUM = ', msgNum);
	PREPARE CALL_MESSAGES FROM @sqlQuery;
	EXECUTE CALL_MESSAGES;
	DEALLOCATE PREPARE CALL_MESSAGES;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
