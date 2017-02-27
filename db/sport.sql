-- Adminer 4.2.5 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `calciatore`;
CREATE TABLE `calciatore` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  `ruolo` varchar(50) DEFAULT NULL,
  `squadra_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `squadra_id` (`squadra_id`),
  CONSTRAINT `calciatore_ibfk_1` FOREIGN KEY (`squadra_id`) REFERENCES `squadra` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `calciatore` (`id`, `nome`, `ruolo`, `squadra_id`) VALUES
(1,	'eta beta',	'attaccante',	NULL),
(2,	'ned flanders',	'difensore',	3),
(4,	'et ',	'portiere',	NULL),
(5,	'paperino',	'centrocampo',	4);

DROP VIEW IF EXISTS `calciatore_v`;
CREATE TABLE `calciatore_v` (`id` int(10), `nome` varchar(50), `ruolo` varchar(50), `squadra_id` int(10), `allenatore` varchar(50), `denominazione` varchar(50), `datafondazione` datetime);


DROP VIEW IF EXISTS `calciatore_view`;
CREATE TABLE `calciatore_view` (`nome` varchar(50), `ruolo` varchar(50), `squadra_id` int(10));


DROP TABLE IF EXISTS `calendario`;
CREATE TABLE `calendario` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `data` datetime NOT NULL,
  `goal_casa` int(11) NOT NULL,
  `goal_ospite` int(11) NOT NULL,
  `squadra_id` int(10) NOT NULL,
  `ospite_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `squadra_id` (`squadra_id`),
  KEY `ospite_id` (`ospite_id`),
  CONSTRAINT `calendario_ibfk_2` FOREIGN KEY (`squadra_id`) REFERENCES `squadra` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `calendario_ibfk_3` FOREIGN KEY (`ospite_id`) REFERENCES `squadra` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP VIEW IF EXISTS `calendario_v`;
CREATE TABLE `calendario_v` (`id` int(10), `data` datetime, `goal_casa` int(11), `goal_ospite` int(11), `squadra_id` int(10), `allena_casa` varchar(50), `nome_casa` varchar(50), `data_casa` datetime, `ospite_id` int(10), `allena_ospite` varchar(50), `nome_ospite` varchar(50), `data_ospite` datetime);


DROP TABLE IF EXISTS `squadra`;
CREATE TABLE `squadra` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `allenatore` varchar(50) DEFAULT NULL,
  `denominazione` varchar(50) NOT NULL,
  `datafondazione` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `squadra` (`id`, `allenatore`, `denominazione`, `datafondazione`) VALUES
(3,	'homer simpson',	'atletico springfield',	'1990-05-05 00:00:00'),
(4,	'paperoga',	'real paperopoli',	'1962-02-06 00:00:00');

DROP TABLE IF EXISTS `votazione`;
CREATE TABLE `votazione` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `calciatore_id` int(10) NOT NULL,
  `calendario_id` int(10) NOT NULL,
  `voto` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `calciatore_id` (`calciatore_id`),
  KEY `calendario_id` (`calendario_id`),
  CONSTRAINT `votazione_ibfk_1` FOREIGN KEY (`calciatore_id`) REFERENCES `calciatore` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `votazione_ibfk_2` FOREIGN KEY (`calendario_id`) REFERENCES `calendario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `calciatore_v`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `calciatore_v` AS select `c`.`id` AS `id`,`c`.`nome` AS `nome`,`c`.`ruolo` AS `ruolo`,`c`.`squadra_id` AS `squadra_id`,`s`.`allenatore` AS `allenatore`,`s`.`denominazione` AS `denominazione`,`s`.`datafondazione` AS `datafondazione` from (`calciatore` `c` left join `squadra` `s` on((`c`.`squadra_id` = `s`.`id`)));

DROP TABLE IF EXISTS `calciatore_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `calciatore_view` AS select `c`.`nome` AS `nome`,`c`.`ruolo` AS `ruolo`,`c`.`squadra_id` AS `squadra_id` from (`calciatore` `c` left join `squadra` `s` on((`c`.`squadra_id` = `s`.`id`)));

DROP TABLE IF EXISTS `calendario_v`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `calendario_v` AS select `cal`.`id` AS `id`,`cal`.`data` AS `data`,`cal`.`goal_casa` AS `goal_casa`,`cal`.`goal_ospite` AS `goal_ospite`,`cal`.`squadra_id` AS `squadra_id`,`s`.`allenatore` AS `allena_casa`,`s`.`denominazione` AS `nome_casa`,`s`.`datafondazione` AS `data_casa`,`cal`.`ospite_id` AS `ospite_id`,`o`.`allenatore` AS `allena_ospite`,`o`.`denominazione` AS `nome_ospite`,`o`.`datafondazione` AS `data_ospite` from ((`calendario` `cal` left join `squadra` `s` on((`cal`.`squadra_id` = `s`.`id`))) left join `squadra` `o` on((`cal`.`ospite_id` = `o`.`id`)));

-- 2017-02-27 23:52:04