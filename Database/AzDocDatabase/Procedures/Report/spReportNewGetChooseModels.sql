
Create PROCEDURE  [report].[spReportNewGetChooseModels]
										 @workPlaceId int,
										 --@docType int = NULL,
										 @executorOrganizationId int,
										 @executorOrganizationType int

AS
   SET NOCOUNT ON;

SELECT	1 AS FormType, -- nazirliyin departamentleri
		dd.DepartmentId As [Id],
		dd2.DepartmentId AS [TopId],
		dd.DepartmentName As [Name]
		FROM dbo.DC_DEPARTMENT dd
		LEFT JOIN dbo.DC_DEPARTMENT dd2  ON dd.DepartmentTopId = dd2.DepartmentId
		LEFT JOIN dbo.DC_DEPARTMENT dd3  ON dd.DepartmentSectionId = dd3.DepartmentId
		WHERE dd.DepartmentStatus=1 AND dd.DepartmentOrganization=1
UNION
SELECT  2 AS FormType,
	    do.OrganizationId AS [Id],
		NULL [TopId],
	    do.OrganizationName AS [Name]  
	    FROM dbo.DC_ORGANIZATION do  -- nazirlik qurumlari
	    WHERE do.OrganizationTopId=1
UNION					
SELECT  3 AS FormType,  -- Movzular 
	 	dtt.TopicTypeId AS [Id],
		NULL [TopId],
		dtt.TopicTypeName AS [Name]
		FROM dbo.DOC_TOPIC_TYPE dtt 
UNION
SELECT  4 FormType,   -- alt movuzlar
		dt.TopicId AS [Id],
		dt.TopicTypeId as [TopId],
		dt.TopicName AS [Name]
		FROM dbo.DOC_TOPIC dt

--UNION
--SELECT  5 FormType,  -- hardan daxil olub 
--	 	do.OrganizationId AS [Id], 
--		NULL [TopId],
--		do.OrganizationName AS [Name]
--		FROM dbo.DC_ORGANIZATION do WHERE do.OrganizationStatus=1





--AS
--   SET NOCOUNT ON;

--   IF (@executorOrganizationId IN (1,2))-- nazirlik ve helelik mhm uchun 
--   BEGIN 

--		IF (@executorOrganizationType=1)     
--		BEGIN
			
--					SELECT 	dd2.DepartmentId AS [TopId],
--							dd.DepartmentId As [Id],
--							dd.DepartmentName As [Name]
--							FROM dbo.DC_DEPARTMENT dd
--			     			LEFT JOIN dbo.DC_DEPARTMENT dd2  ON dd.DepartmentTopId = dd2.DepartmentId
--							LEFT JOIN dbo.DC_DEPARTMENT dd3  ON dd.DepartmentSectionId = dd3.DepartmentId
--							WHERE dd.DepartmentStatus=1 AND dd.DepartmentOrganization=1

--					ORDER BY  dd2.DepartmentId ASC
--        END
       
--	    IF  (@executorOrganizationType=0)   -- 0 olanda demeli  nazirlikdi ve tabeli qurumlar nezere alinir 
--		BEGIN


--		     	    SELECT 
--						   do.OrganizationId AS [Id],
--					       do.OrganizationName AS [Name]  
--						   FROM dbo.DC_ORGANIZATION do  -- nazirlik qurumlari
--						   WHERE do.OrganizationTopId=1
--		END

--   END


--	 ELSE  -- demeli qurumdu ve qurumlar uchun yalniz department chixardilir

--	 BEGIN 
--		 SELECT
--					 dd2.DepartmentId AS [TopId],
--					 dd.DepartmentId As [Id],
--				     dd.DepartmentName As [Name]
--					 FROM dbo.DC_DEPARTMENT dd
--				     LEFT JOIN dbo.DC_DEPARTMENT dd2  ON dd.DepartmentTopId = dd2.DepartmentId
--					 LEFT JOIN dbo.DC_DEPARTMENT dd3  ON dd.DepartmentSectionId = dd3.DepartmentId
--				     WHERE dd.DepartmentStatus=1 AND dd.DepartmentOrganization=@executorOrganizationId
--					 ORDER BY  dd2.DepartmentId asc
--    END
 

