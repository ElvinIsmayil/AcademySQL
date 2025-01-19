CREATE DATABASE PB503Academy

USE PB503Academy

CREATE TABLE Academies
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(100) UNIQUE
)

CREATE TABLE Groups
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(100),
	AcademyId INT FOREIGN KEY REFERENCES Academies(Id)
)

CREATE TABLE Students
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(100),
	Surname NVARCHAR(100),
	Age INT,
	Adulthood BIT,
	GroupId INT FOREIGN KEY REFERENCES Groups(Id)
)

ALTER TABLE Students ADD CONSTRAINT DF_Students_Adulthood DEFAULT 0 FOR Adulthood;




CREATE TABLE DeletedStudents
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(100),
	Surname NVARCHAR(100),
	GroupId INT 
)

CREATE TABLE DeletedGroups
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Name NVARCHAR(100),
	AcademyId INT 
)

CREATE VIEW VW_Academy
AS
SELECT * 
FROM Academies

SELECT * FROM VW_Academy

CREATE VIEW VW_Group
AS 
SELECT A.Id AS 'Academy Id', A.Name AS 'Academy Name', G.Id AS 'Group Id', G.Name AS 'Group name'
FROM Groups AS G
JOIN Academies AS A
ON A.Id = AcademyId

SELECT * FROM VW_Group

CREATE VIEW VW_Student
AS
SELECT S.Id AS 'Student Id', S.Name AS 'Student name',
S.Surname AS 'Student Surname', 
S.Age AS 'Student Age', S.Adulthood AS 'Student Adulthood',A.Id AS 'Academy Id',
A.Name AS 'Academy Name', G.Id AS 'Group Id', G.Name AS 'Group name' 
FROM Students AS S
JOIN Groups AS G
ON G.Id = GroupId
JOIN Academies AS A
ON A.Id = AcademyId

SELECT * FROM VW_Student

CREATE PROCEDURE UPS_GetGroupByName @name NVARCHAR(100)
AS
SELECT * FROM Groups
WHERE @name = Name 

EXEC UPS_GetGroupByName 'Sports Training'


CREATE PROCEDURE UPS_GetStudentsAboveAge @age INT
AS
SELECT * FROM Students
WHERE Age >= @age

EXEC UPS_GetStudentsAboveAge 17

CREATE PROCEDURE UPS_GetStudentsBelowAge @age INT
AS
SELECT * FROM Students
WHERE Age <= @age

EXEC UPS_GetStudentsBelowAge 20


CREATE TRIGGER TR_AdulthoodSetter ON Students
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE S
    SET Adulthood = 1
    FROM Students S
    INNER JOIN inserted I 
	ON S.Id = I.Id
    WHERE I.Age >= 18

    
    UPDATE S
    SET Adulthood = 0
    FROM Students S
    INNER JOIN inserted I
	ON S.Id = I.Id
    WHERE I.Age < 18
END


CREATE TRIGGER TR_StudentDeletedDataStorer ON Students
AFTER DELETE
AS 
BEGIN
	
	INSERT INTO DeletedStudents (Name, Surname, GroupId)
	SELECT Name, Surname, GroupId FROM deleted

END


CREATE TRIGGER TR_GroupDeletedDataStorer ON Groups
AFTER DELETE
AS 
BEGIN
	
	INSERT INTO DeletedGroups (Name, AcademyId)
	SELECT Name, AcademyId FROM deleted

END



INSERT INTO Academies (Name)
VALUES 
('Oxford Academy'),
('Horizon Institute'),
('Future Leaders Academy');

INSERT INTO Groups (Name, AcademyId)
VALUES 
('Science Club', 1),
('Art and Design', 1),
('Business Studies', 2),
('Music and Performance', 2),
('Sports Training', 3);

INSERT INTO Students (Name, Surname, Age, GroupId) 
VALUES 
('Daniel', 'Williams', 16, 1),
('Sophia', 'Brown', 18, 2),
('Ethan', 'Taylor', 20, 3),
('Olivia', 'Martinez', 15, 4),
('James', 'Anderson', 22, 5)

TRUNCATE TABLE Students