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

CREATE PROCEDURE UPS_GetGroupByName @name NVARCHAR(100)
AS
SELECT * FROM Groups
WHERE @name = Name 


CREATE PROCEDURE UPS_GetStudentsByMinAge @age INT
AS
SELECT * FROM Students
WHERE @age < Age

CREATE PROCEDURE UPS_GetStudentsByMaxAge @age INT
AS
SELECT * FROM Students
WHERE @age > Age

CREATE TRIGGER TR_InititalAdulthood ON Students
AFTER INSERT
AS
BEGIN
	UPDATE Students
	SET Adulthood = 1
	WHERE (SELECT Age FROM inserted) > 17 AND Id = (SELECT Id FROM inserted)
END