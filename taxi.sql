INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_taxi', 'taxi', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_taxi', 'taxi', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_taxi', 'taxi', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('taxi', 'LSPD'),
	('offtaxi', 'Off taxi')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('taxi',0,'recruit','Recrue',20,'{}','{}'),
	('taxi',1,'officer','Officier',40,'{}','{}'),
	('taxi',2,'sergeant','Sergent',60,'{}','{}'),
	('taxi',3,'lieutenant','Lieutenant',85,'{}','{}'),
	('taxi',4,'boss','Commandant',100,'{}','{}'),
;
INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('offtaxi',0,'recruit','Off Recrue',0,'{}','{}'),
	('offtaxi',1,'officer','Off Officier',0,'{}','{}'),
	('offtaxi',2,'sergeant','Off Sergent',0,'{}','{}'),
	('offtaxi',3,'lieutenant','Off Lieutenant',0,'{}','{}'),
	('offtaxi',4,'boss','Off Commandant',0,'{}','{}')
;