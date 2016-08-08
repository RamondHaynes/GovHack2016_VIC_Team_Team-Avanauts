CREATE VIEW [GovHackVic].[VwPatent]
AS
(
SELECT PL.[ApplicationNo]
      ,PL.[Name]
      ,PL.[Latitude]
      ,PL.[Longitude]
      ,PL.[ApplicantType]
      ,PL.[PatentType]
      ,PL.[ApplicationYear]
	  ,PS.[ApplicationDate]
      ,PS.[Country]
      ,PS.[State]
      ,PS.[Postcode]
      ,PS.[Status]
      ,PS.[ApplicantNo]
      ,PS.[Australian]
      ,PS.[Entity]
      ,PS.[Big]
FROM [GovHackVic].[PatentLocation] AS PL
JOIN
(SELECT [ApplicationNo]
      ,[ApplicationDate]
      ,[Country]
      ,[State]
      ,[Postcode]
      ,[Status]
      ,[ApplicantNo]
      ,[Australian]
      ,[Entity]
      ,[Big] FROM [GovHackVic].[IPSummary] 
WHERE [ApplicationYear] IS NOT NULL
AND [Postcode] IS NOT NULL
AND [ApplicationDate] IS NOT NULL) AS PS
ON
(PL.[ApplicationNo] = PS.[ApplicationNo])
)

CREATE VIEW [GovHackVic].[VwPatentJoinBankrupcy]
AS
SELECT Pvt.*, B.[Bankruptcies],B.[DebtAgreements],B.[Insolvencies] 
FROM
(SELECT * FROM
(SELECT [ApplicationNo],[Postcode],[State],[ApplicationYear],[ApplicantType]
FROM [GovHackVic].[VwPatent] WHERE [PatentType]='Innovation') AS SourceTable
PIVOT
(
COUNT([ApplicationNo])
FOR [ApplicantType] IN ([Large firm],[SME],[Private applicant])) AS PivotTable
)
AS Pvt
JOIN
[dbo].[vw_Bakrupcy] AS B
ON(
Pvt.[Postcode] = B.[Postcode] AND
Pvt.[State] = B.[State] AND
Pvt.[ApplicationYear] = B.[Year]
)
