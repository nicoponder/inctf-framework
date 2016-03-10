-- MySQL Script generated by MySQL Workbench
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Table `game`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `game` ;

CREATE TABLE `game` (
  `id` INT NULL DEFAULT NULL);


-- -----------------------------------------------------
-- Table `teams`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `teams` ;

CREATE TABLE `teams` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `team_name` VARCHAR(256) NOT NULL,
  `services_ports_low` INT NOT NULL,
  `services_ports_high` INT NOT NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`id` ASC),
  UNIQUE INDEX `services_ports_low_UNIQUE` (`services_ports_low` ASC),
  UNIQUE INDEX `services_ports_high_UNIQUE` (`services_ports_high` ASC));


-- -----------------------------------------------------
-- Table `services`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `services` ;

CREATE TABLE `services` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(256) NOT NULL,
  `internal_port` INT NOT NULL,
  `description` TEXT NULL,
  `authors` VARCHAR(2048) NOT NULL,
  `flag_id_description` VARCHAR(2048) NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `offset_external_port` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`id` ASC),
  UNIQUE INDEX `internal_port_UNIQUE` (`internal_port` ASC),
  UNIQUE INDEX `offset_external_port_UNIQUE` (`offset_external_port` ASC));


-- -----------------------------------------------------
-- Table `team_service_state`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `team_service_state` ;

CREATE TABLE `team_service_state` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `team_id` INT(11) NOT NULL,
  `service_id` INT(11) NOT NULL,
  `state` TINYINT(2) NOT NULL,
  `reason` VARCHAR(256) NOT NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX (`team_id` ASC, `service_id` ASC),
  INDEX (`team_id` ASC),
  INDEX (`state` ASC),
  INDEX (`team_id` ASC, `service_id` ASC, `created_on` ASC),
  INDEX (`state` ASC, `team_id` ASC, `service_id` ASC, `created_on` ASC),
  INDEX `fk_service_id_idx` (`service_id` ASC),
  CONSTRAINT `fk_service_state_team_id`
    FOREIGN KEY (`team_id`)
    REFERENCES `teams` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_service_state_service_id`
    FOREIGN KEY (`service_id`)
    REFERENCES `services` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `team_score`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `team_score` ;

CREATE TABLE `team_score` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `team_id` INT(11) NOT NULL,
  `score` INT NOT NULL,
  `reason` VARCHAR(256) NOT NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX (`team_id` ASC),
  INDEX (`created_on` ASC),
  CONSTRAINT `fk_team_score_team_id`
    FOREIGN KEY (`team_id`)
    REFERENCES `teams` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `scripts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `scripts` ;

CREATE TABLE `scripts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NULL DEFAULT NULL,
  `is_ours` TINYINT(1) NOT NULL DEFAULT 1,
  `type` VARCHAR(24) NOT NULL,
  `team_id` INT(11) NULL DEFAULT NULL,
  `service_id` INT(11) NOT NULL,
  `is_working` TINYINT(1) NULL DEFAULT NULL,
  `is_bundle` TINYINT(1) NOT NULL DEFAULT 0,
  `latest_script` TINYINT(1) NOT NULL DEFAULT 1,
  `feedback` TEXT NULL DEFAULT NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX (`team_id` ASC),
  INDEX (`type` ASC),
  INDEX (`is_working` ASC),
  INDEX (`is_ours` ASC),
  INDEX (`service_id` ASC),
  CONSTRAINT `fk_scripts_team_id`
    FOREIGN KEY (`team_id`)
    REFERENCES `teams` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_scripts_service_id`
    FOREIGN KEY (`service_id`)
    REFERENCES `services` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `script_payload`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `script_payload` ;

CREATE TABLE `script_payload` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `script_id` INT(11) NOT NULL,
  `payload` LONGBLOB NOT NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX (`script_id` ASC),
  INDEX (`created_on` ASC),
  CONSTRAINT `fk_script_payload_script_id`
    FOREIGN KEY (`script_id`)
    REFERENCES `scripts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `ticks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ticks` ;

CREATE TABLE `ticks` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `time_to_change` VARCHAR(30) NOT NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX (`created_on` ASC));


-- -----------------------------------------------------
-- Table `team_scripts_run_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `team_scripts_run_status` ;

CREATE TABLE `team_scripts_run_status` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `team_id` INT(11) NOT NULL,
  `tick_id` INT(11) NOT NULL,
  `json_list_of_scripts_to_run` MEDIUMTEXT NOT NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX (`tick_id` ASC),
  INDEX `team_id_idx` (`team_id` ASC),
  CONSTRAINT `fk_script_run_status_team_id`
    FOREIGN KEY (`team_id`)
    REFERENCES `teams` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_scripts_run_status_tick_id`
    FOREIGN KEY (`tick_id`)
    REFERENCES `ticks` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `exploits_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `exploits_status` ;

CREATE TABLE `exploits_status` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `service_id` INT(11) NOT NULL,
  `defending_team_id` INT(11) NOT NULL,
  `attacking_team_id` INT(11) NOT NULL,
  `is_attack_success` TINYINT(1) NOT NULL,
  `exploit_stdout` VARCHAR(2048) NULL,
  `exploit_stderr` VARCHAR(2048) NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX (`is_attack_success` ASC),
  INDEX (`created_on` ASC),
  INDEX (`defending_team_id` ASC, `service_id` ASC, `created_on` ASC),
  INDEX `fk_exploit_service_id_idx` (`service_id` ASC),
  INDEX `fk_exploit_att_team_id_idx` (`attacking_team_id` ASC),
  CONSTRAINT `fk_exploit_service_id`
    FOREIGN KEY (`service_id`)
    REFERENCES `services` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exploit_def_team_id`
    FOREIGN KEY (`defending_team_id`)
    REFERENCES `teams` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_exploit_att_team_id`
    FOREIGN KEY (`attacking_team_id`)
    REFERENCES `teams` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `script_runs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `script_runs` ;

CREATE TABLE `script_runs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `script_id` INT(11) NOT NULL,
  `defending_team_id` INT(11) NOT NULL,
  `error` INT(11) NOT NULL,
  `error_msg` VARCHAR(2048) NULL DEFAULT NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_script_runs_script_id_idx` (`script_id` ASC),
  INDEX `fk_script_runs_team_id_idx` (`defending_team_id` ASC),
  CONSTRAINT `fk_script_runs_script_id`
    FOREIGN KEY (`script_id`)
    REFERENCES `scripts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_script_runs_team_id`
    FOREIGN KEY (`defending_team_id`)
    REFERENCES `teams` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `flags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flags` ;

CREATE TABLE `flags` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `team_id` INT(11) NOT NULL,
  `service_id` INT(11) NOT NULL,
  `flag` VARCHAR(128) NOT NULL,
  `flag_id` VARCHAR(128) NULL DEFAULT NULL,
  `cookie` VARCHAR(128) NULL DEFAULT NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX (`flag` ASC),
  INDEX (`team_id` ASC),
  INDEX (`service_id` ASC),
  INDEX (`team_id` ASC, `service_id` ASC),
  INDEX (`created_on` ASC),
  CONSTRAINT `fk_flags_team_id`
    FOREIGN KEY (`team_id`)
    REFERENCES `teams` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flags_service_id`
    FOREIGN KEY (`service_id`)
    REFERENCES `services` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `flag_submission`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `flag_submission` ;

CREATE TABLE `flag_submission` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `team_id` INT(11) NOT NULL,
  `flag` VARCHAR(128) NOT NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX (`team_id` ASC),
  INDEX (`flag` ASC),
  UNIQUE INDEX (`team_id` ASC, `flag` ASC),
  INDEX (`created_on` ASC),
  CONSTRAINT `fk_flag_submission_team_id`
    FOREIGN KEY (`team_id`)
    REFERENCES `teams` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_flag_submission_flag`
    FOREIGN KEY (`flag`)
    REFERENCES `flags` (`flag`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `containers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `containers` ;

CREATE TABLE `containers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `registry_namespace` VARCHAR(45) NOT NULL,
  `team_id` INT NOT NULL,
  `service_id` INT NOT NULL,
  `type` ENUM('SERVICE', 'EXPLOIT') NOT NULL,
  `update_required` TINYINT(1) NOT NULL DEFAULT 0,
  `latest_digest` VARCHAR(80) NULL DEFAULT NULL,
  `created_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_containers_team_id_idx` (`team_id` ASC),
  INDEX `fk_containers_service_id_idx` (`service_id` ASC),
  CONSTRAINT `fk_containers_team_id`
    FOREIGN KEY (`team_id`)
    REFERENCES `teams` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_containers_service_id`
    FOREIGN KEY (`service_id`)
    REFERENCES `services` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `services_locations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `services_locations` ;

CREATE TABLE `services_locations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `team_id` INT NOT NULL,
  `service_id` INT NOT NULL,
  `host_ip` VARCHAR(45) NOT NULL,
  `host_port` INT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_services_locations_1_idx` (`team_id` ASC),
  INDEX `fk_services_locations_service_id_idx` (`service_id` ASC),
  CONSTRAINT `fk_services_locations_team_id`
    FOREIGN KEY (`team_id`)
    REFERENCES `teams` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_services_locations_service_id`
    FOREIGN KEY (`service_id`)
    REFERENCES `services` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
