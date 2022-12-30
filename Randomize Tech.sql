CREATE TABLE "RandomizedTechnologies" (
    "TechnologyType" TEXT NOT NULL,
    PRIMARY KEY(TechnologyType)
);

CREATE TABLE "SwappedTechnologies" (
    "Original" TEXT NOT NULL UNIQUE,
    "Swapped" TEXT NOT NULL UNIQUE,
    PRIMARY KEY (Original, Swapped)
);

CREATE TABLE BackupTechnologies AS SELECT TechnologyType, Cost, EraType, UITreeRow FROM Technologies;

CREATE TRIGGER OnTechnologyQuotes BEFORE INSERT ON TechnologyQuotes
BEGIN

	INSERT INTO BackupTechnologies (TechnologyType, Cost, EraType, UITreeRow)
	SELECT TechnologyType, Cost, EraType, UITreeRow FROM Technologies
	WHERE NOT EXISTS(SELECT * FROM TechnologyQuotes);

	INSERT INTO RandomizedTechnologies (TechnologyType)
	SELECT TechnologyType FROM Technologies
	WHERE NOT EXISTS(SELECT * FROM TechnologyQuotes)
	ORDER BY RANDOM();

	INSERT INTO SwappedTechnologies (Original, Swapped)
	SELECT t.TechnologyType, r.TechnologyType FROM Technologies t
	JOIN RandomizedTechnologies r ON t.RowId = r.RowId
	WHERE NOT EXISTS(SELECT * FROM TechnologyQuotes);

	UPDATE Technologies SET
		Cost = (
			SELECT b.Cost FROM BackupTechnologies b JOIN SwappedTechnologies s ON s.Original = Technologies.TechnologyType AND b.TechnologyType = s.Swapped
		),
		EraType = (
			SELECT b.EraType FROM BackupTechnologies b JOIN SwappedTechnologies s ON s.Original = Technologies.TechnologyType AND b.TechnologyType = s.Swapped
		),
		UITreeRow = (
			SELECT b.UITreeRow FROM BackupTechnologies b JOIN SwappedTechnologies s ON s.Original = Technologies.TechnologyType AND b.TechnologyType = s.Swapped
		)
	WHERE NOT EXISTS(SELECT * FROM TechnologyQuotes);

	UPDATE TechnologyPrereqs SET
		Technology = IFNULL(
				(SELECT ' ' || s.Original FROM SwappedTechnologies s WHERE s.Swapped = TechnologyPrereqs.Technology),
			TechnologyPrereqs.Technology),
		PrereqTech = IFNULL(
			(SELECT ' ' || s.Original FROM SwappedTechnologies s WHERE s.Swapped = TechnologyPrereqs.PrereqTech)
			, TechnologyPrereqs.PrereqTech)
	WHERE NOT EXISTS(SELECT * FROM TechnologyQuotes);

	UPDATE TechnologyPrereqs SET
		Technology = TRIM(Technology),
		PrereqTech = TRIM(PrereqTech)
	WHERE NOT EXISTS(SELECT * FROM TechnologyQuotes);

END;

CREATE TABLE "RandomizedCivics" (
    "CivicType" TEXT NOT NULL,
    PRIMARY KEY(CivicType)
);

CREATE TABLE "SwappedCivics" (
    "Original" TEXT NOT NULL UNIQUE,
    "Swapped" TEXT NOT NULL UNIQUE,
    PRIMARY KEY (Original, Swapped)
);

CREATE TABLE BackupCivics AS SELECT CivicType, Cost, EraType, UITreeRow FROM Civics;

CREATE TRIGGER OnCivicQuotes BEFORE INSERT ON CivicQuotes
BEGIN

	INSERT INTO BackupCivics (CivicType, Cost, EraType, UITreeRow)
	SELECT CivicType, Cost, EraType, UITreeRow FROM Civics
	WHERE NOT EXISTS(SELECT * FROM CivicQuotes);

	INSERT INTO RandomizedCivics (CivicType)
	SELECT CivicType FROM Civics
	WHERE NOT EXISTS(SELECT * FROM CivicQuotes)
	ORDER BY RANDOM();

	INSERT INTO SwappedCivics (Original, Swapped)
	SELECT t.CivicType, r.CivicType FROM Civics t
	JOIN RandomizedCivics r ON t.RowId = r.RowId
	WHERE NOT EXISTS(SELECT * FROM CivicQuotes);

	UPDATE Civics SET
		Cost = (
			SELECT b.Cost FROM BackupCivics b JOIN SwappedCivics s ON s.Original = Civics.CivicType AND b.CivicType = s.Swapped
		),
		EraType = (
			SELECT b.EraType FROM BackupCivics b JOIN SwappedCivics s ON s.Original = Civics.CivicType AND b.CivicType = s.Swapped
		),
		UITreeRow = (
			SELECT b.UITreeRow FROM BackupCivics b JOIN SwappedCivics s ON s.Original = Civics.CivicType AND b.CivicType = s.Swapped
		)
	WHERE NOT EXISTS(SELECT * FROM CivicQuotes);

	UPDATE CivicPrereqs SET
		Civic = IFNULL(
				(SELECT ' ' || s.Original FROM SwappedCivics s WHERE s.Swapped = CivicPrereqs.Civic),
			CivicPrereqs.Civic),
		PrereqCivic = IFNULL(
			(SELECT ' ' || s.Original FROM SwappedCivics s WHERE s.Swapped = CivicPrereqs.PrereqCivic)
			, CivicPrereqs.PrereqCivic)
	WHERE NOT EXISTS(SELECT * FROM CivicQuotes);

	UPDATE CivicPrereqs SET
		Civic = TRIM(Civic),
		PrereqCivic = TRIM(PrereqCivic)
	WHERE NOT EXISTS(SELECT * FROM CivicQuotes);

END;