-- DB update 2017_12_05_00 -> 2018_01_21_00
DROP PROCEDURE IF EXISTS `updateDb`;
DELIMITER //
CREATE PROCEDURE updateDb ()
proc:BEGIN DECLARE OK VARCHAR(100) DEFAULT 'FALSE';
SELECT COUNT(*) INTO @COLEXISTS
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'version_db_auth' AND COLUMN_NAME = '2017_12_05_00';
IF @COLEXISTS = 0 THEN LEAVE proc; END IF;
START TRANSACTION;
ALTER TABLE version_db_auth CHANGE COLUMN 2017_12_05_00 2018_01_21_00 bit;
SELECT sql_rev INTO OK FROM version_db_auth WHERE sql_rev = '1515646234610593200'; IF OK <> 'FALSE' THEN LEAVE proc; END IF;
--
-- START UPDATING QUERIES
--

INSERT INTO version_db_auth (`sql_rev`) VALUES ('1515646234610593200');

DROP TABLE IF EXISTS `account_muted`;

CREATE TABLE `account_muted` (
    `guid` INT(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
    `mutedate` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `mutetime` INT(10) UNSIGNED NOT NULL DEFAULT '0',
    `mutedby` VARCHAR(50) NOT NULL,
    `mutereason` VARCHAR(255) NOT NULL,
	PRIMARY KEY (`guid`, `mutedate`)
)
COMMENT='mute List' ENGINE=InnoDB;

--
-- END UPDATING QUERIES
--
COMMIT;
END //
DELIMITER ;
CALL updateDb();
DROP PROCEDURE IF EXISTS `updateDb`;
