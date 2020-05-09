-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema effigy2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema effigy2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `effigy2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `effigy2` ;

-- -----------------------------------------------------
-- Table `effigy2`.`loc_root`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`loc_root` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`loc_root` (
  `ROOT_ID` INT NOT NULL AUTO_INCREMENT,
  `ROOT` VARCHAR(500) NOT NULL,
  `ROOT_STORY` VARCHAR(10000) NULL,
  `COLLECTION_ID` INT NOT NULL,
  `COLLECTION_DESC` VARCHAR(200) NOT NULL,
  `INSERTED_DT` DATETIME NOT NULL,
  PRIMARY KEY (`ROOT_ID`),
  UNIQUE INDEX `LOC_ID_UNIQUE` (`ROOT_ID` ASC) VISIBLE,
  UNIQUE INDEX `ROOT_UNIQUE` (`ROOT` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `effigy2`.`loc_folder`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`loc_folder` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`loc_folder` (
  `FOLDER_ID` INT NOT NULL AUTO_INCREMENT,
  `ROOT_ID` INT NOT NULL,
  `ROOT` VARCHAR(500) NOT NULL,
  `FOLDER` VARCHAR(100) NOT NULL,
  `FOLDER_PATH` VARCHAR(600) NOT NULL,
  `FOLDER_STORY` VARCHAR(1000) NULL,
  `INSERTED_DT` DATETIME NOT NULL,
  PRIMARY KEY (`FOLDER_ID`),
  UNIQUE INDEX `LOC_FID_UNIQUE` (`FOLDER_ID` ASC) VISIBLE,
  INDEX `FK_ROOT_ID_idx` (`ROOT_ID` ASC) VISIBLE,
  UNIQUE INDEX `FOLDER_PATH_UNIQUE` (`FOLDER_PATH` ASC) VISIBLE,
  CONSTRAINT `FK_ROOT_ID`
    FOREIGN KEY (`ROOT_ID`)
    REFERENCES `effigy2`.`loc_root` (`ROOT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `effigy2`.`supported_ext`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`supported_ext` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`supported_ext` (
  `EXTENSION` VARCHAR(10) NOT NULL,
  `DESC` VARCHAR(45) NULL,
  PRIMARY KEY (`EXTENSION`),
  UNIQUE INDEX `SUPPORTED_TYPE_ID_UNIQUE` (`EXTENSION` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`media_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`media_type` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`media_type` (
  `MEDIA_TYPE_ID` VARCHAR(1) NOT NULL,
  `MEDIA DESC` VARCHAR(45) NULL,
  PRIMARY KEY (`MEDIA_TYPE_ID`),
  UNIQUE INDEX `ID_UNIQUE` (`MEDIA_TYPE_ID` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `effigy2`.`media`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`media` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`media` (
  `MEDIA_ID` INT NOT NULL AUTO_INCREMENT,
  `MEDIA_KEY` VARCHAR(200) NULL,
  `NAME` VARCHAR(100) NOT NULL,
  `MEDIA_TYPE_ID` VARCHAR(1) NOT NULL,
  `FOLDER_ID` INT NOT NULL,
  `PATH` VARCHAR(500) NOT NULL,
  `PARENT_FOLDER_ID` INT NOT NULL,
  `PARENT_FOLDER` VARCHAR(500) NOT NULL,
  `SHORT_DESC` VARCHAR(100) NULL,
  `DESC` VARCHAR(300) NULL,
  `FAV_COUNT` INT NULL,
  `EXTENSION` VARCHAR(10) NOT NULL,
  `SIZE` INT NULL,
  `DTTAKEN` DATETIME NULL,
  `DTMODIFY` DATETIME NULL,
  `UPDATE_DT` DATETIME NULL DEFAULT NULL,
  `INSERTED_DT` DATETIME NOT NULL,
  PRIMARY KEY (`MEDIA_ID`),
  UNIQUE INDEX `ID_UNIQUE` (`MEDIA_ID` ASC) VISIBLE,
  INDEX `FP_EXTENSION_idx` (`EXTENSION` ASC) VISIBLE,
  INDEX `FK_MEDIA_TYPE_ID_idx` (`MEDIA_TYPE_ID` ASC) VISIBLE,
  INDEX `FK_FOLDER1_ID_idx` (`PARENT_FOLDER_ID` ASC) VISIBLE,
  UNIQUE INDEX `MEDIA_KEY_UNIQUE` (`MEDIA_KEY` ASC) VISIBLE,
  CONSTRAINT `FK_PARENT_FOLDER_ID`
    FOREIGN KEY (`FOLDER_ID`)
    REFERENCES `effigy2`.`loc_folder` (`FOLDER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FP_EXTENSION`
    FOREIGN KEY (`EXTENSION`)
    REFERENCES `effigy2`.`supported_ext` (`EXTENSION`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_MEDIA_TYPE_ID`
    FOREIGN KEY (`MEDIA_TYPE_ID`)
    REFERENCES `effigy2`.`media_type` (`MEDIA_TYPE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_FOLDER1_ID`
    FOREIGN KEY (`PARENT_FOLDER_ID`)
    REFERENCES `effigy2`.`loc_folder` (`ROOT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `effigy2`.`attrib`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`attrib` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`attrib` (
  `ATTRIB_ID` INT NOT NULL AUTO_INCREMENT,
  `WIDTH` INT NULL DEFAULT NULL,
  `HEIGHT` INT NULL,
  `CAMERA` VARCHAR(70) NULL DEFAULT NULL,
  `MODEL` VARCHAR(70) NULL DEFAULT NULL,
  `DTTAKEN` DATETIME NULL DEFAULT NULL,
  `DTMODIFY` DATETIME NULL DEFAULT NULL,
  `FSTOP` VARCHAR(40) NULL DEFAULT NULL,
  `EXPOSURE` VARCHAR(20) NULL DEFAULT NULL,
  `ORIENTATION` VARCHAR(20) NULL DEFAULT NULL,
  `FLASH` VARCHAR(20) NULL DEFAULT NULL,
  `SHUTTER` VARCHAR(20) NULL DEFAULT NULL,
  `APERTURE` VARCHAR(20) NULL DEFAULT NULL,
  `ISOSPEED` VARCHAR(20) NULL DEFAULT NULL,
  `DIGIZOOM` VARCHAR(20) NULL DEFAULT NULL,
  `EXIF` VARCHAR(5000) NULL DEFAULT NULL,
  `MEDIA_ID` INT NOT NULL,
  `MEDIA_KEY` VARCHAR(200) NOT NULL,
  `INSERTED_DT` DATETIME NOT NULL,
  PRIMARY KEY (`ATTRIB_ID`),
  UNIQUE INDEX `ATTRIB_ID_UNIQUE` (`ATTRIB_ID` ASC) VISIBLE,
  UNIQUE INDEX `MEDIA_ID_UNIQUE` (`MEDIA_ID` ASC) VISIBLE,
  UNIQUE INDEX `MEDIA_KEY_UNIQUE` (`MEDIA_KEY` ASC) VISIBLE,
  CONSTRAINT `FK_MEDIA2_ID`
    FOREIGN KEY (`MEDIA_ID`)
    REFERENCES `effigy2`.`media` (`MEDIA_ID`)
    ON DELETE NO ACTION
    ON UPDATE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `effigy2`.`comments_root`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`comments_root` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`comments_root` (
  `COMMENTS_ROOT_ID` INT NOT NULL AUTO_INCREMENT,
  `COMMENTS_SRC_ID` INT NOT NULL,
  `COMMENTS_SRC` VARCHAR(4) NULL,
  `INSERTED_DT` DATETIME NOT NULL,
  PRIMARY KEY (`COMMENTS_ROOT_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`comments_thread`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`comments_thread` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`comments_thread` (
  `COMMENTS_THREAD_ID` INT NOT NULL AUTO_INCREMENT,
  `COMMENTS` VARCHAR(1000) NOT NULL,
  `INSERTED_DT` DATETIME NOT NULL,
  `INSERTBY_BY` VARCHAR(45) NOT NULL,
  `COMMENTS_ROOT_ID` INT NOT NULL,
  PRIMARY KEY (`COMMENTS_THREAD_ID`),
  UNIQUE INDEX `comment_id_UNIQUE` (`COMMENTS_THREAD_ID` ASC) VISIBLE,
  CONSTRAINT `FP_COMMENT_THREAD_ID`
    FOREIGN KEY (`COMMENTS_THREAD_ID`)
    REFERENCES `effigy2`.`comments_root` (`COMMENTS_ROOT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`fav_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`fav_type` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`fav_type` (
  `FAV_TYPE_ID` INT NOT NULL AUTO_INCREMENT,
  `COMMENTS` VARCHAR(45) NOT NULL,
  `SRC` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`FAV_TYPE_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`favourites`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`favourites` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`favourites` (
  `FAVOURITE_ID` INT NOT NULL AUTO_INCREMENT,
  `FAV_TYPE_ID` INT NOT NULL,
  `MEDIA_ID` INT NOT NULL,
  `NAME` VARCHAR(200) NOT NULL,
  `PATH` VARCHAR(500) NOT NULL,
  `INSERTED_DT` DATETIME NOT NULL,
  `INSERTED_BY` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`FAVOURITE_ID`),
  INDEX `FK_MEDIA_ID_idx` (`MEDIA_ID` ASC) VISIBLE,
  INDEX `FK_FAV_TYPE_ID_idx` (`FAV_TYPE_ID` ASC) VISIBLE,
  CONSTRAINT `FK_MEDIA_ID`
    FOREIGN KEY (`MEDIA_ID`)
    REFERENCES `effigy2`.`media` (`MEDIA_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_FAV_TYPE_ID`
    FOREIGN KEY (`FAV_TYPE_ID`)
    REFERENCES `effigy2`.`fav_type` (`FAV_TYPE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`collection_year`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`collection_year` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`collection_year` (
  `COLLECTION_ID` INT NOT NULL AUTO_INCREMENT,
  `FOLDER_ID` INT NOT NULL,
  `YEAR` DATE NULL,
  `PERCENTAGE` INT NULL,
  PRIMARY KEY (`COLLECTION_ID`),
  UNIQUE INDEX `COLLECTION_ID_UNIQUE` (`COLLECTION_ID` ASC) VISIBLE,
  INDEX `FK_FOLDER_ID_idx` (`FOLDER_ID` ASC) VISIBLE,
  CONSTRAINT `FK_FOLDER_ID`
    FOREIGN KEY (`FOLDER_ID`)
    REFERENCES `effigy2`.`loc_folder` (`FOLDER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`skip_root`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`skip_root` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`skip_root` (
  `SKIP_ROOT_ID` INT NOT NULL AUTO_INCREMENT,
  `SKIP_ROOT` VARCHAR(500) NULL,
  UNIQUE INDEX `SKIP_ROOT_ID_UNIQUE` (`SKIP_ROOT_ID` ASC) VISIBLE,
  PRIMARY KEY (`SKIP_ROOT_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`excluded_ext`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`excluded_ext` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`excluded_ext` (
  `EXTENSION` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`EXTENSION`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`search`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`search` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`search` (
  `SEARCH_ID` INT NOT NULL AUTO_INCREMENT,
  `KEYWORD` VARCHAR(100) NOT NULL,
  `MEDIA_TYPE` VARCHAR(1) NULL,
  `SEARCH_SCOPE` VARCHAR(45) NULL,
  `SEARCHED_BY` VARCHAR(45) NOT NULL,
  `SEARCH_DT` DATE NULL,
  PRIMARY KEY (`SEARCH_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`user` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`user` (
  `USER_ID` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(45) NOT NULL,
  `HANDLE` VARCHAR(45) NOT NULL,
  `INSERTED_DT` DATETIME NULL,
  UNIQUE INDEX `USER_ID_UNIQUE` (`USER_ID` ASC) VISIBLE,
  PRIMARY KEY (`USER_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`face`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`face` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`face` (
  `FACE_ID` INT NOT NULL,
  `NAME` VARCHAR(45) NOT NULL,
  `HANDLE` VARCHAR(45) NOT NULL,
  `FACE_TYPE_FAMILY_FRIEND` INT NOT NULL,
  `INSERTED_DT` DATETIME NOT NULL,
  PRIMARY KEY (`FACE_ID`),
  UNIQUE INDEX `FACE_ID_UNIQUE` (`FACE_ID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`media_face`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`media_face` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`media_face` (
  `MEDIA_FACE_ID` INT NOT NULL AUTO_INCREMENT,
  `MEDIA_ID` INT NOT NULL,
  `FACE_ID` INT NOT NULL,
  PRIMARY KEY (`MEDIA_FACE_ID`),
  UNIQUE INDEX `MEDIA_FACE_ID_UNIQUE` (`MEDIA_FACE_ID` ASC) VISIBLE,
  INDEX `FK_FACE_idx` (`FACE_ID` ASC) VISIBLE,
  INDEX `FK_MEDIA_idx` (`MEDIA_ID` ASC) VISIBLE,
  UNIQUE INDEX `INX_FACE_MEDIA` (`MEDIA_ID` ASC, `FACE_ID` ASC) VISIBLE,
  CONSTRAINT `FK_FACE`
    FOREIGN KEY (`FACE_ID`)
    REFERENCES `effigy2`.`face` (`FACE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_MEDIA`
    FOREIGN KEY (`MEDIA_ID`)
    REFERENCES `effigy2`.`media` (`MEDIA_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`media_type_ext`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`media_type_ext` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`media_type_ext` (
  `MEDIA_TYPE_EXT_ID` INT NOT NULL AUTO_INCREMENT,
  `MEDIA_TYPE_ID` VARCHAR(1) NOT NULL,
  `EXTENSION` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`MEDIA_TYPE_EXT_ID`),
  UNIQUE INDEX `MEDIA_TYPE_EXT_ID_UNIQUE` (`MEDIA_TYPE_EXT_ID` ASC) VISIBLE,
  INDEX `FK_MEDIA_TYPE_idx` (`MEDIA_TYPE_ID` ASC) VISIBLE,
  INDEX `FK_EXTENSION_idx` (`EXTENSION` ASC) INVISIBLE,
  CONSTRAINT `FK_MEDIA_TYPE`
    FOREIGN KEY (`MEDIA_TYPE_ID`)
    REFERENCES `effigy2`.`media_type` (`MEDIA_TYPE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_EXTENSION`
    FOREIGN KEY (`EXTENSION`)
    REFERENCES `effigy2`.`supported_ext` (`EXTENSION`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`likes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`likes` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`likes` (
  `LIKE_ID` INT NOT NULL AUTO_INCREMENT,
  `PARENT_ID` INT NOT NULL,
  `PARENT_SRC` VARCHAR(4) NOT NULL,
  `LIKE_TYPE` VARCHAR(45) NOT NULL,
  `INSERTED_BY` VARCHAR(45) NULL,
  `INSERTED_DT` DATETIME NULL,
  PRIMARY KEY (`LIKE_ID`),
  UNIQUE INDEX `LIKE_ID_UNIQUE` (`LIKE_ID` ASC) VISIBLE,
  INDEX `FP_LIKE_PARENT_ID_idx` (`PARENT_ID` ASC) VISIBLE,
  CONSTRAINT `FP_LIKE_PARENT_ID`
    FOREIGN KEY (`PARENT_ID`)
    REFERENCES `effigy2`.`media` (`MEDIA_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`location`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`location` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`location` (
  `LOCATION_ID` INT NOT NULL,
  `PARENT_ID` INT NULL,
  `PARENT_SRC` VARCHAR(4) NULL,
  `LOCATION` VARCHAR(500) NULL,
  `LOCATION COMMENTS` VARCHAR(1000) NULL,
  `INSERTED_DT` DATETIME NULL,
  PRIMARY KEY (`LOCATION_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`default_locations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`default_locations` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`default_locations` (
  `DEF_LOC_ID` INT NOT NULL,
  `LOCATION` VARCHAR(200) NULL,
  PRIMARY KEY (`DEF_LOC_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`tag_root`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`tag_root` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`tag_root` (
  `TAG_ROOT_ID` INT NOT NULL AUTO_INCREMENT,
  `TAG_SRC_ID` INT NOT NULL,
  `TAG_SRC` VARCHAR(4) NOT NULL,
  `INSERTED_DT` DATETIME NULL,
  PRIMARY KEY (`TAG_ROOT_ID`),
  UNIQUE INDEX `tag_root_id_UNIQUE` (`TAG_ROOT_ID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy2`.`tag_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy2`.`tag_list` ;

CREATE TABLE IF NOT EXISTS `effigy2`.`tag_list` (
  `TAG_LIST_ID` INT NOT NULL,
  `TAG_ROOT_ID` INT NOT NULL,
  `TAG` VARCHAR(45) NULL,
  PRIMARY KEY (`TAG_LIST_ID`),
  UNIQUE INDEX `TAG_LIST_ID_UNIQUE` (`TAG_LIST_ID` ASC) VISIBLE,
  INDEX `FK_TAG_ROOT_ID_idx` (`TAG_ROOT_ID` ASC) VISIBLE,
  CONSTRAINT `FK_TAG_ROOT_ID`
    FOREIGN KEY (`TAG_ROOT_ID`)
    REFERENCES `effigy2`.`tag_root` (`TAG_ROOT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
