CREATE DATABASE FailSafeIT;
GO

USE FailSafeIT;
GO 

CREATE TABLE Kunder (
    KundID INT PRIMARY KEY,
    Organisationsnummer VARCHAR(20) NOT NULL UNIQUE,
    Foretagsnamn NVARCHAR(100) NOT NULL,
    Epost VARCHAR(254) NOT NULL,
    Telefonnummer VARCHAR(30) NULL
);
GO 

CREATE TABLE Konsulter ( 
    KonsultID INT PRIMARY KEY, 
    Personnummer VARCHAR (20) NOT NULL UNIQUE, 
    Namn NVARCHAR(100) NOT NULL, 
    Timpris DECIMAL (10,2) NOT NULL,
    Specialitet NVARCHAR (100) NOT NULL

);
GO

CREATE TABLE Uppdrag ( 
    UppdragID INT PRIMARY KEY, 
    KundID INT NOT NULL, 
    KonsultID INT NOT NULL, 
    Startdatum DATE NOT NULL, 
    Slutdatum DATE NULL, 
    Rollbeskrivning NVARCHAR (255) NOT NULL, 
    CONSTRAINT FK_Uppdrag_Kunder
    FOREIGN KEY (KundID) REFERENCES Kunder (KundID), 
    CONSTRAINT FK_Uppdrag_Konsulter    
    FOREIGN KEY (KonsultID) REFERENCES Konsulter (KonsultID) 

);
GO

INSERT INTO Kunder
(KundID, Organisationsnummer, Foretagsnamn, Epost, Telefonnummer)
VALUES
(1, '556000-1111', N'Nordic Tech AB', 'kontakt@nordictech.se', '08-111111'),
(2, '556000-2222', N'Säker Data AB', 'info@sakerdata.se', '031-222222'),
(3, '556000-3333', N'Cloud Partner AB', 'kontakt@cloudpartner.se', '040-333333')
GO

INSERT INTO Konsulter
(KonsultID, Personnummer, Namn, Timpris, Specialitet)
VALUES
(1, '19850101-1234', N'Anna Andersson', 1400, N'Cybersecurity'),
(2, '19900202-2345', N'Erik Eriksson', 1100, N'Databaser'),
(3, '19780303-3456', N'Sara Svensson', 1500, N'Cloud');
GO

INSERT INTO Uppdrag
(UppdragID, KundID, KonsultID, Startdatum, Slutdatum, Rollbeskrivning)
VALUES
(1, 1, 1, '2025-01-10', NULL, N'Säkerhetsanalys'),
(2, 1, 2, '2025-02-01', '2025-04-30', N'Databasdesign'),
(3, 2, 1, '2025-03-01', NULL, N'Incidentberedskap'),
(4, 2, 3, '2025-01-15', '2025-05-15', N'Cloudmigrering'),
(5, 3, 3, '2025-04-01', '2025-06-30', N'Driftstöd');
GO

-- A. Konsulter med timpris över 1200 kr
SELECT Namn, Timpris
FROM Konsulter
WHERE Timpris > 1200
ORDER BY Timpris DESC;
GO

--B. Visa kunder, konsulter och uppdragsdatum
SELECT
    Kunder.Foretagsnamn,
    Konsulter.Namn,
    Uppdrag.Startdatum,
    Uppdrag.Slutdatum
FROM Uppdrag
INNER JOIN Kunder
    ON Uppdrag.KundID = Kunder.KundID
INNER JOIN Konsulter
    ON Uppdrag.KonsultID = Konsulter.KonsultID;
GO

-- C. Antal uppdrag per kund
SELECT
    Kunder.Foretagsnamn,
    COUNT(Uppdrag.UppdragID) AS AntalUppdrag
FROM Kunder
LEFT JOIN Uppdrag
    ON Kunder.KundID = Uppdrag.KundID
GROUP BY Kunder.KundID, Kunder.Foretagsnamn;
GO

-- D. Uppdatera timpriset för en konsult
UPDATE Konsulter
SET Timpris = 1400
WHERE KonsultID = 1;
GO

-- E. Ta bort en kund endast om kunden saknar uppdrag
DELETE FROM Kunder
WHERE KundID = 1
AND NOT EXISTS (
    SELECT 1
    FROM Uppdrag
    WHERE Uppdrag.KundID = Kunder.KundID
);
GO


