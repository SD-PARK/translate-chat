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

-- 프로시저 chat.GET_NULLTEXT 구조 내보내기
DELIMITER //
CREATE PROCEDURE `GET_NULLTEXT`( IN roomId INT, IN lang VARCHAR(5) )
BEGIN
	SET @sqlQuery = CONCAT('SELECT MSG_NUM, ORIGINAL_MSG, FROM_LANGUAGE FROM room_message_', roomId, ' WHERE TO_', lang, ' IS NULL');
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
	(1, 6, 'FRIEND'),
	(1, 7, 'FRIEND'),
	(1, 8, 'FRIEND'),
	(2, 1, 'FRIEND'),
	(2, 7, 'FRIEND'),
	(3, 1, 'FRIEND'),
	(4, 1, 'FRIEND'),
	(5, 1, 'FRIEND'),
	(6, 1, 'FRIEND'),
	(7, 1, 'FRIEND'),
	(7, 2, 'FRIEND'),
	(8, 1, 'FRIEND');
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

-- 테이블 데이터 chat.room_info:~3 rows (대략적) 내보내기
/*!40000 ALTER TABLE `room_info` DISABLE KEYS */;
INSERT INTO `room_info` (`ROOM_ID`, `USER_ID`, `ROOM_NAME`, `NOTICE_TYPE`, `FAVORITES`, `UPDATE_CHECK`) VALUES
	(1, 1, 'Room', 'notice', 0, 1),
	(1, 2, 'Room', 'notice', 0, 1),
	(1, 3, 'Room', 'notice', 0, 1);
/*!40000 ALTER TABLE `room_info` ENABLE KEYS */;

-- 테이블 chat.room_list 구조 내보내기
CREATE TABLE IF NOT EXISTS `room_list` (
  `ROOM_ID` int(11) NOT NULL AUTO_INCREMENT,
  `LAST_MSG` varchar(1000) NOT NULL DEFAULT 'No Messages.',
  `LAST_SEND_TIME` datetime DEFAULT NULL,
  PRIMARY KEY (`ROOM_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- 테이블 데이터 chat.room_list:~1 rows (대략적) 내보내기
/*!40000 ALTER TABLE `room_list` DISABLE KEYS */;
INSERT INTO `room_list` (`ROOM_ID`, `LAST_MSG`, `LAST_SEND_TIME`) VALUES
	(1, '됐다', '2022-11-16 22:48:49');
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.room_message_1:~21 rows (대략적) 내보내기
/*!40000 ALTER TABLE `room_message_1` DISABLE KEYS */;
INSERT INTO `room_message_1` (`MSG_NUM`, `SEND_USER_ID`, `ORIGINAL_MSG`, `SEND_TIME`, `FROM_LANGUAGE`, `TO_ko`, `TO_ja`, `TO_en`, `TO_zh-CN`, `TO_zh-TW`) VALUES
	(1, 1, '옘병', '2022-11-16 22:00:07', 'ko', '옘병', '鋭敏病', NULL, NULL, NULL),
	(2, 1, 'say&#39;', '2022-11-16 22:00:13', 'ko', 'say&#39;', 'say&#39;', NULL, NULL, NULL),
	(3, 1, '&quot;&quot;&quot;', '2022-11-16 22:00:20', 'ko', '&quot;&quot;&quot;', '&quot;&quot;&quot;', NULL, NULL, NULL),
	(4, 1, 'ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ', '2022-11-16 22:01:20', 'ko', 'ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ', 'ㅁㅁㅁㅁㅁㅁ', NULL, NULL, NULL),
	(5, 1, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', '2022-11-16 22:01:24', 'ko', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', NULL, NULL, NULL),
	(6, 3, '?', '2022-11-16 22:02:32', 'ja', '?', '?', NULL, NULL, NULL),
	(7, 3, 'メッセージが移るんですよ。メッセージが移るんですよ。メッセージが移るんですよ。メッセージが移るんですよ。メッセージが移るんですよ。', '2022-11-16 22:02:47', 'ja', '문자가 넘어가거든요.문자가 넘어가거든요.문자가 넘어가거든요.문자가 넘어가거든요.문자가 넘어가거든요.', 'メッセージが移るんですよ。メッセージが移るんですよ。メッセージが移るんですよ。メッセージが移るんですよ。メッセージが移るんですよ。', NULL, NULL, NULL),
	(8, 1, 'I guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just English', '2022-11-16 22:03:07', 'ko', 'I guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just English', 'I guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just English', NULL, NULL, NULL),
	(9, 1, '??', '2022-11-16 22:03:10', 'ko', '??', '??', NULL, NULL, NULL),
	(10, 1, 'cmdslkafmdklsafm;dlsamfkdlsamfkld;samfdsanfjkldsnajklfdnsajkl', '2022-11-16 22:03:17', 'ko', 'cmdslkafmdklsafm;dlsamfkdlsamfkld;samfdsanfjkldsnajklfdnsajkl', 'cmdslkafmdklsafm;dlsamfkdlsamfkld;samfdsanfjkldsnajklfdnsajkl', NULL, NULL, NULL),
	(11, 1, 'I guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just English', '2022-11-16 22:03:21', 'ko', 'I guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just English', 'I guess it&#39;s just EnglishI guess it&#39;s just EnglishI guess it&#39;s just English', NULL, NULL, NULL),
	(12, 1, 'I guess it&#39;s just English?? I guess it&#39;s just English?? I guess it&#39;s just English??', '2022-11-16 22:03:43', 'ko', 'I guess it&#39;s just English?? I guess it&#39;s just English?? I guess it&#39;s just English??', 'I guess it&#39;s just English?? I guess it&#39;s just English?? I guess it&#39;s just English??', NULL, NULL, NULL),
	(13, 1, 'fdsmaklfdmslka fmdkslafmkdlsa fdsal', '2022-11-16 22:03:50', 'ko', 'fdsmaklfdmslka fmdkslafmkdlsa fdsal', 'fdsmaklfdmslka fmdkslafmkdlsa fdsal', NULL, NULL, NULL),
	(14, 1, 'mflkdsamfkldsmalkfdmsalkfdmkslafmdlksa', '2022-11-16 22:03:52', 'ko', 'mflkdsamfkldsmalkfdmsalkfdmkslafmdlksa', 'mflkdsamfkldsmalkfdmsalkfdmkslafmdlksa', NULL, NULL, NULL),
	(15, 1, 'fmdklsamfdklsamflkdsamfkldsmalkfdsa ', '2022-11-16 22:03:54', 'ko', 'fmdklsamfdklsamflkdsamfkldsmalkfdsa ', 'fmdklsamfdklsamflkdsamfkldsmalkfdsa', NULL, NULL, NULL),
	(16, 1, 'fmdslkafmdklsamfdklsamflkdsamfkldsmaklfdmsaklfmdsklafmdkslafmdklsamfdk ', '2022-11-16 22:03:57', 'ko', 'fmdslkafmdklsamfdklsamflkdsamfkldsmaklfdmsaklfmdsklafmdkslafmdklsamfdk ', 'fmdslkafmdklsamfdklsamflkdsamfkldsmaklfdmsaklfmdsklafmdkslafmdklsamfdk', NULL, NULL, NULL),
	(17, 1, 'fdmsklaf fdmsklafmdkslafmdklsamfkldsamfkldsamfkldsmaklfdmsaklfdsa', '2022-11-16 22:04:01', 'ko', 'fdmsklaf fdmsklafmdkslafmdklsamfkldsamfkldsamfkldsmaklfdmsaklfdsa', 'fdmsklaf fdmsklafmdkslafmdklsamfkldsamfkldsamfkldsmaklfdmsaklfdsa', NULL, NULL, NULL),
	(18, 1, 'fdmsklafmdklsafmkdlsamflkdsamflkdsmalkfdmsaklfdmsaklfmdsaklfmdkslafmdklsafmdlksamfdklsamfdlksamfkldsmafkldsmalkfdmsaklfmdkslafd', '2022-11-16 22:04:06', 'ko', 'fdmsklafmdklsafmkdlsamflkdsamflkdsmalkfdmsaklfdmsaklfmdsaklfmdkslafmdklsafmdlksamfdklsamfdlksamfkldsmafkldsmalkfdmsaklfmdkslafd', 'fdmsklafmdklsafmkdlsamflkdsamflkdsmalkfdmsaklfdmsaklfmdsaklfmdkslafmdklsafmdlksamfdklsamfdlksamfkldsmafkldsmalkfdmsaklfmdkslafd', NULL, NULL, NULL),
	(19, 1, 'fmkldsamfkdls fmdklsafmdklsamfdklsafm mfkdlsamfdklsamfdklsa fmdkslafmdlksa', '2022-11-16 22:04:11', 'ko', 'fmkldsamfkdls fmdklsafmdklsamfdklsafm mfkdlsamfdklsamfdklsa fmdkslafmdlksa', 'fmkldsamfkdls fmdklsafmdklsamfdklsafm mfkdlsamfdklsamfdklsa fmdkslafmdlksa', NULL, NULL, NULL),
	(20, 1, '휴', '2022-11-16 22:48:48', 'ko', '휴', 'ヒュー', NULL, NULL, NULL),
	(21, 1, '됐다', '2022-11-16 22:48:49', 'ko', '됐다', 'よし。', NULL, NULL, NULL);
/*!40000 ALTER TABLE `room_message_1` ENABLE KEYS */;

-- 프로시저 chat.SEND_MESSAGE 구조 내보내기
DELIMITER //
CREATE PROCEDURE `SEND_MESSAGE`(
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
CREATE PROCEDURE `UPDATE_INVITE_ROOM`( IN roomId INT, IN userId INT )
BEGIN
	INSERT INTO room_info (ROOM_ID, USER_ID) VALUE (roomId, userId);
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
CREATE PROCEDURE `UPDATE_ROOM_TITLE`( IN roomId INT, IN userId INT, IN title VARCHAR(15) CHARSET UTF8MB4 )
BEGIN
	UPDATE room_info SET ROOM_NAME = title
	WHERE ROOM_ID = roomId AND USER_ID = userId;
END//
DELIMITER ;

-- 프로시저 chat.UPDATE_TRANSLATION 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_TRANSLATION`( IN roomId INT, IN msgNum INT, IN lang VARCHAR(5), IN translation VARCHAR(1000) CHARACTER SET UTF8MB4)
BEGIN
	SET @sqlQuery = CONCAT('UPDATE room_message_', roomId, ' SET TO_', lang, ' = "', translation, '" WHERE MSG_NUM = ', msgNum);
	PREPARE updateText FROM @sqlQuery;
	EXECUTE updateText;
	DEALLOCATE PREPARE updateText;
END//
DELIMITER ;

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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;

-- 테이블 데이터 chat.users:~8 rows (대략적) 내보내기
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`ID`, `EMAIL`, `PASSWORD`, `NAME`, `LANGUAGE`, `COMPANY_NAME`, `IMG_URL`, `COMPANY_START`, `COMPANY_END`) VALUES
	(1, '1812105@du.ac.kr', 'acd202bb391b4712518fe87bb26775053b3d55171a80bcb6b5ab7a9e44a914f9', '박상도', 'ko', NULL, 'default_profile.jpg', NULL, NULL),
	(2, 'tkdeh129@naver.com', 'acd202bb391b4712518fe87bb26775053b3d55171a80bcb6b5ab7a9e44a914f9', '상도박', 'en', NULL, 'default_profile.jpg', NULL, NULL),
	(3, 'aa55235490@gmail.com', '55daf76ebb48896ce06ae11eac5cf86dc975ced67f0ab9ce1c57efe6a5ca010b', '박상도', 'ja', NULL, '1668317182850KakaoTalk_20221113_141205219.jpg', NULL, NULL),
	(4, 'test1', 'test', 'test1', 'en', NULL, 'default_profile.jpg', NULL, NULL),
	(5, 'test2', 'test', 'test2', 'ko', NULL, 'default_profile.jpg', NULL, NULL),
	(6, 'test3', 'test', 'test3', 'ja', NULL, 'default_profile.jpg', NULL, NULL),
	(7, 'test4', 'test', 'test4', 'zh-CN', NULL, 'default_profile.jpg', NULL, NULL),
	(8, 'test5', 'test', 'test5', 'zh-TW', NULL, 'default_profile.jpg', NULL, NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

-- 프로시저 chat.VIEW_ALL_MESSAGES 구조 내보내기
DELIMITER //
CREATE PROCEDURE `VIEW_ALL_MESSAGES`( IN roomId INT, IN lang VARCHAR(5) )
BEGIN
	SET @sqlQuery = CONCAT('SELECT msg.MSG_NUM, msg.SEND_USER_ID, users.NAME, users.IMG_URL, ',
									'msg.ORIGINAL_MSG, msg.TO_', lang, ' AS MSG, msg.SEND_TIME FROM users ', 
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

-- 프로시저 chat.VIEW_JOINROOM 구조 내보내기
DELIMITER //
CREATE PROCEDURE `VIEW_JOINROOM`( IN userId INT )
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

-- 프로시저 chat.VIEW_SEARCH_EMAIL 구조 내보내기
DELIMITER //
CREATE PROCEDURE `VIEW_SEARCH_EMAIL`( IN userId INT, IN factor VARCHAR(1000) CHARACTER SET UTF8MB4 )
BEGIN
	SET @sqlQuery = CONCAT('SELECT ID, EMAIL, NAME, LANGUAGE, IMG_URL FROM users ',
					'LEFT OUTER JOIN (SELECT * FROM relations WHERE USER_ID = 1) AS relations ',
					'ON ID = TARGET_ID WHERE EMAIL LIKE "%', factor, '%" AND ID != ', userId, ' AND TARGET_ID IS NULL');
	PREPARE SEARCH_EMAIL FROM @sqlQuery;
	EXECUTE SEARCH_EMAIL;
	DEALLOCATE PREPARE SEARCH_EMAIL;
END//
DELIMITER ;

-- 프로시저 chat.VIEW_SEARCH_FRIENDS 구조 내보내기
DELIMITER //
CREATE PROCEDURE `VIEW_SEARCH_FRIENDS`( IN userId INT, IN factor VARCHAR(1000) CHARACTER SET UTF8MB4 )
BEGIN
	SET @sqlQuery = CONCAT('SELECT users.ID, users.EMAIL, users.NAME, users.IMG_URL FROM users, relations ',
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
CREATE PROCEDURE `VIEW_SINGLE_MESSAGE`( IN roomId INT, IN lang VARCHAR(5), IN msgNum INT )
BEGIN
	SET @sqlQuery = CONCAT('SELECT msg.MSG_NUM, msg.SEND_USER_ID, users.NAME, users.IMG_URL, ',
									'msg.ORIGINAL_MSG, msg.TO_', lang, ' AS MSG, msg.SEND_TIME FROM users ', 
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
