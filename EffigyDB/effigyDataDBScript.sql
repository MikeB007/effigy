-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema effigy
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema effigy
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `effigy` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `effigy` ;

-- -----------------------------------------------------
-- Table `effigy`.`attrib`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy`.`attrib` ;

CREATE TABLE IF NOT EXISTS `effigy`.`attrib` (
  `ATRIB_ID` INT(11) NOT NULL AUTO_INCREMENT,
  `WIDTH` INT(11) NULL DEFAULT NULL,
  `HEIGHT` INT(11) NULL DEFAULT NULL,
  `CAMERA` VARCHAR(70) NULL DEFAULT NULL,
  `MODEL` VARCHAR(70) NULL DEFAULT NULL,
  `DTTAKEN` DATE NULL DEFAULT NULL,
  `DTMODIFY` DATE NULL DEFAULT NULL,
  `FSTOP` VARCHAR(20) NULL DEFAULT NULL,
  `EXPOSURE` VARCHAR(20) NULL DEFAULT NULL,
  `ORIENTATION` VARCHAR(2) NULL DEFAULT NULL,
  `FLASH` VARCHAR(20) NULL DEFAULT NULL,
  `SHUTTER` VARCHAR(20) NULL DEFAULT NULL,
  `APERTURE` VARCHAR(20) NULL DEFAULT NULL,
  `ISOSPEED` VARCHAR(20) NULL DEFAULT NULL,
  `DIGIZOOM` VARCHAR(20) NULL DEFAULT NULL,
  `EXIF` VARCHAR(500) NULL DEFAULT NULL,
  PRIMARY KEY (`ATRIB_ID`),
  UNIQUE INDEX `ATTRIB_ID_UNIQUE` (`ATRIB_ID` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `effigy`.`loc_root`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy`.`loc_root` ;

CREATE TABLE IF NOT EXISTS `effigy`.`loc_root` (
  `ROOT_ID` INT(11) NOT NULL AUTO_INCREMENT,
  `ROOT` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`ROOT_ID`),
  UNIQUE INDEX `LOC_ID_UNIQUE` (`ROOT_ID` ASC) VISIBLE,
  UNIQUE INDEX `ROOT_UNIQUE` (`ROOT` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `effigy`.`loc_folder`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy`.`loc_folder` ;

CREATE TABLE IF NOT EXISTS `effigy`.`loc_folder` (
  `FOLDER_ID` INT(11) NOT NULL AUTO_INCREMENT,
  `ROOT_ID` INT(11) NOT NULL,
  `ROOT` VARCHAR(500) NOT NULL,
  `FOLDER` VARCHAR(100) NOT NULL,
  `FOLDER_PATH` VARCHAR(600) NOT NULL,
  PRIMARY KEY (`FOLDER_ID`),
  UNIQUE INDEX `LOC_FID_UNIQUE` (`FOLDER_ID` ASC) VISIBLE,
  INDEX `FK_ROOT_ID_idx` (`ROOT_ID` ASC) VISIBLE,
  UNIQUE INDEX `FOLDER_PATH_UNIQUE` (`FOLDER_PATH` ASC) VISIBLE,
  CONSTRAINT `FK_ROOT_ID`
    FOREIGN KEY (`ROOT_ID`)
    REFERENCES `effigy`.`loc_root` (`ROOT_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `effigy`.`supported_ext`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy`.`supported_ext` ;

CREATE TABLE IF NOT EXISTS `effigy`.`supported_ext` (
  `EXTENSION` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`EXTENSION`),
  UNIQUE INDEX `SUPPORTED_TYPE_ID_UNIQUE` (`EXTENSION` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy`.`media_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy`.`media_type` ;

CREATE TABLE IF NOT EXISTS `effigy`.`media_type` (
  `MEDIA_TYPE_ID` VARCHAR(1) NOT NULL,
  `MEDIA DESC` VARCHAR(45) NULL,
  PRIMARY KEY (`MEDIA_TYPE_ID`),
  UNIQUE INDEX `ID_UNIQUE` (`MEDIA_TYPE_ID` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `effigy`.`media`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy`.`media` ;

CREATE TABLE IF NOT EXISTS `effigy`.`media` (
  `MEDIA_ID` INT(11) NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(100) NOT NULL,
  `MEDIA_TYPE_ID` VARCHAR(1) NOT NULL,
  `FOLDER_ID` INT(11) NOT NULL,
  `PATH` VARCHAR(500) NOT NULL,
  `PARENT_FOLDER_ID` INT(11) NOT NULL,
  `PARENT_FOLDER` INT(11) NOT NULL,
  `ATRIB_ID` INT(11) NOT NULL,
  `SHORT_DESC` VARCHAR(100) NULL,
  `DESC` VARCHAR(300) NULL,
  `FAV_COUNT` INT(11) NULL,
  `EXTENSION` VARCHAR(10) NOT NULL,
  `UPDATE_DT` DATE NULL DEFAULT NULL,
  `INSERTED_DT` DATE NOT NULL,
  PRIMARY KEY (`MEDIA_ID`),
  UNIQUE INDEX `ID_UNIQUE` (`MEDIA_ID` ASC) VISIBLE,
  INDEX `attrib_idx` (`ATRIB_ID` ASC) INVISIBLE,
  INDEX `FP_PARENT_FOLDER_ID_idx` (`PARENT_FOLDER_ID` ASC) VISIBLE,
  INDEX `FP_EXTENSION_idx` (`EXTENSION` ASC) VISIBLE,
  INDEX `FK_MEDIA_TYPE_ID_idx` (`MEDIA_TYPE_ID` ASC) VISIBLE,
  INDEX `FK_FOLDER_ID_idx` (`FOLDER_ID` ASC) VISIBLE,
  CONSTRAINT `FK_MEDIA_ATRIB`
    FOREIGN KEY (`ATRIB_ID`)
    REFERENCES `effigy`.`attrib` (`ATRIB_ID`),
  CONSTRAINT `FK_PARENT_FOLDER_ID`
    FOREIGN KEY (`PARENT_FOLDER_ID`)
    REFERENCES `effigy`.`loc_folder` (`FOLDER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FP_EXTENSION`
    FOREIGN KEY (`EXTENSION`)
    REFERENCES `effigy`.`supported_ext` (`EXTENSION`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_MEDIA_TYPE_ID`
    FOREIGN KEY (`MEDIA_TYPE_ID`)
    REFERENCES `effigy`.`media_type` (`MEDIA_TYPE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_FOLDER1_ID`
    FOREIGN KEY (`FOLDER_ID`)
    REFERENCES `effigy`.`loc_folder` (`FOLDER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `effigy`.`comments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy`.`comments` ;

CREATE TABLE IF NOT EXISTS `effigy`.`comments` (
  `COMMENT_ID` INT(11) NOT NULL AUTO_INCREMENT,
  `MEDIA_ID` INT(100) NOT NULL,
  `COMMENTS` VARCHAR(1000) NOT NULL,
  `INSERT_DT` INT NOT NULL,
  `INSERT_BY` VARCHAR(45) NOT NULL,
  `NAME` VARCHAR(200) NOT NULL,
  `PATH` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`COMMENT_ID`),
  UNIQUE INDEX `comment_id_UNIQUE` (`COMMENT_ID` ASC) VISIBLE,
  INDEX `FP_MEDIA_ID_idx` (`MEDIA_ID` ASC) VISIBLE,
  CONSTRAINT `FP_MEDIA_ID`
    FOREIGN KEY (`MEDIA_ID`)
    REFERENCES `effigy`.`media` (`MEDIA_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy`.`fav_type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy`.`fav_type` ;

CREATE TABLE IF NOT EXISTS `effigy`.`fav_type` (
  `FAV_TYPE_ID` INT(11) NOT NULL AUTO_INCREMENT,
  `COMMENTS` VARCHAR(45) NOT NULL,
  `SRC` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`FAV_TYPE_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy`.`favourites`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy`.`favourites` ;

CREATE TABLE IF NOT EXISTS `effigy`.`favourites` (
  `FAVOURITE_ID` INT(11) NOT NULL AUTO_INCREMENT,
  `FAV_TYPE_ID` INT(11) NOT NULL,
  `MEDIA_ID` INT(11) NOT NULL,
  `NAME` VARCHAR(200) NOT NULL,
  `PATH` VARCHAR(500) NOT NULL,
  `INSERTED_DT` DATETIME NOT NULL,
  `INSERTED_BY` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`FAVOURITE_ID`),
  INDEX `FK_MEDIA_ID_idx` (`MEDIA_ID` ASC) VISIBLE,
  INDEX `FK_FAV_TYPE_ID_idx` (`FAV_TYPE_ID` ASC) VISIBLE,
  CONSTRAINT `FK_MEDIA_ID`
    FOREIGN KEY (`MEDIA_ID`)
    REFERENCES `effigy`.`media` (`MEDIA_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_FAV_TYPE_ID`
    FOREIGN KEY (`FAV_TYPE_ID`)
    REFERENCES `effigy`.`fav_type` (`FAV_TYPE_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy`.`collection_year`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy`.`collection_year` ;

CREATE TABLE IF NOT EXISTS `effigy`.`collection_year` (
  `COLLECTION_ID` INT(11) NOT NULL AUTO_INCREMENT,
  `FOLDER_ID` INT(11) NOT NULL,
  `YEAR` DATE NULL,
  `PERCANTEGE` INT(11) NULL,
  PRIMARY KEY (`COLLECTION_ID`),
  UNIQUE INDEX `COLLECTION_ID_UNIQUE` (`COLLECTION_ID` ASC) VISIBLE,
  INDEX `FK_FOLDER_ID_idx` (`FOLDER_ID` ASC) VISIBLE,
  CONSTRAINT `FK_FOLDER_ID`
    FOREIGN KEY (`FOLDER_ID`)
    REFERENCES `effigy`.`loc_folder` (`FOLDER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy`.`skip_root`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy`.`skip_root` ;

CREATE TABLE IF NOT EXISTS `effigy`.`skip_root` (
  `SKIP_ROOT_ID` INT NOT NULL AUTO_INCREMENT,
  `SKIP_ROOT` VARCHAR(500) NULL,
  UNIQUE INDEX `SKIP_ROOT_ID_UNIQUE` (`SKIP_ROOT_ID` ASC) VISIBLE,
  PRIMARY KEY (`SKIP_ROOT_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `effigy`.`excluded_ext`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `effigy`.`excluded_ext` ;

CREATE TABLE IF NOT EXISTS `effigy`.`excluded_ext` (
  `EXTENSION` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`EXTENSION`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
