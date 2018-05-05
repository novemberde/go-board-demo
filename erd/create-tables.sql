-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema go
-- -----------------------------------------------------
-- Demo Schema for go-lang demo

-- -----------------------------------------------------
-- Schema go
--
-- Demo Schema for go-lang demo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `go` DEFAULT CHARACTER SET utf8 ;
USE `go` ;

-- -----------------------------------------------------
-- Table `go`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `go`.`user` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(128) NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT current_timestamp(),
  `updatedAt` DATETIME NULL,
  `deletedAt` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `go`.`board`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `go`.`board` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `content` TEXT NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT current_timestamp(),
  `updatedAt` DATETIME NULL,
  `deletedAt` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_board_user_idx` (`user_id` ASC),
  CONSTRAINT `fk_board_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `go`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `go`.`boardreply`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `go`.`boardreply` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `board_id` BIGINT UNSIGNED NOT NULL,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `content` VARCHAR(45) NOT NULL,
  `parent` BIGINT UNSIGNED NULL COMMENT '부모 댓글',
  `depth` INT UNSIGNED NULL DEFAULT 1 COMMENT '깊이',
  `createdAt` DATETIME NOT NULL DEFAULT current_timestamp(),
  `updatedAt` DATETIME NULL,
  `deletedAt` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_boardreply_board1_idx` (`board_id` ASC),
  INDEX `fk_boardreply_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_boardreply_board1`
    FOREIGN KEY (`board_id`)
    REFERENCES `go`.`board` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_boardreply_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `go`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `go`.`photo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `go`.`photo` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `imageKey` VARCHAR(128) NOT NULL,
  `creaetdAt` DATETIME NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `go`.`board_photo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `go`.`board_photo` (
  `board_id` BIGINT UNSIGNED NOT NULL,
  `photo_id` BIGINT UNSIGNED NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT current_timestamp(),
  `deletedAt` DATETIME NULL,
  INDEX `fk_board_photo_board1_idx` (`board_id` ASC),
  INDEX `fk_board_photo_photo1_idx` (`photo_id` ASC),
  CONSTRAINT `fk_board_photo_board1`
    FOREIGN KEY (`board_id`)
    REFERENCES `go`.`board` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_board_photo_photo1`
    FOREIGN KEY (`photo_id`)
    REFERENCES `go`.`photo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `go`.`user_photo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `go`.`user_photo` (
  `user_id` BIGINT UNSIGNED NOT NULL,
  `photo_id` BIGINT UNSIGNED NOT NULL,
  `type` CHAR(1) NOT NULL DEFAULT 'a' COMMENT 'a : 아무거나\nf : 프로필 사진 타입',
  `isProfile` CHAR(1) NOT NULL DEFAULT 'n' COMMENT '‘y’: 프로필 사진 지정\n’n’: 프로필 사진 지정이 되지 않음',
  `createdAt` DATETIME NOT NULL DEFAULT current_timestamp(),
  `deletedAt` DATETIME NULL,
  INDEX `fk_user_photo_user1_idx` (`user_id` ASC),
  INDEX `fk_user_photo_photo1_idx` (`photo_id` ASC),
  CONSTRAINT `fk_user_photo_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `go`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_photo_photo1`
    FOREIGN KEY (`photo_id`)
    REFERENCES `go`.`photo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
