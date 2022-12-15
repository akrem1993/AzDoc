/*
Migrated by Kamran A-eff 23.08.2019
*/

/*
Migrated by Kamran A-eff 06.08.2019
*/

/*
Migrated by Kamran A-eff 11.07.2019
*/

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [resolution].[spUsers]

@workplaceId int,
@executorfullname nvarchar(200)=null,
@departmentpositionname nvarchar(200)=null

AS
BEGIN -- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET 
  NOCOUNT ON;
DECLARE @depId int;
DECLARE @pgId int DECLARE @depTypeId int;
DECLARE @depOrgId int;
SELECT 
  @depId = d.DepartmentId, 
  @pgId = PositionGroupId, 
  @depTypeId = d.DepartmentTypeId, 
  @depOrgId = d.DepartmentOrganization 
FROM 
  DC_DEPARTMENT_POSITION DP 
  INNER JOIN DC_WORKPLACE DW ON DP.DepartmentPositionId = DW.WorkplaceDepartmentPositionId 
  JOIN DC_DEPARTMENT d ON d.DepartmentId = dw.WorkplaceDepartmentId 
WHERE 
  WorkplaceId = @workplaceId IF (
    @pgId IN (33, 2, 1)
  ) BEGIN 
SELECT 
  DISTINCT A.Id AS WorkPlaceId, 
  A.Name AS PersonFullName, 
  A.PositionGroupLevel, 
  PositionGroupId, 
  dbo.DC_USER.UserId, 
  dbo.DC_USER.UserName, 
  dbo.DC_PERSONNEL.PersonnelId, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelName, 
    ''
  ) AS PersonnelName, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelSurname, 
    ''
  ) AS PersonnelSurname, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelLastname, 
    ''
  ) AS PersonnelLastname, 
  dbo.DC_DEPARTMENT.DepartmentId, 
  dbo.DC_DEPARTMENT.DepartmentName, 
  dbo.DC_ORGANIZATION.OrganizationId, 
  dbo.DC_ORGANIZATION.OrganizationName, 
  dbo.DC_DEPARTMENT_POSITION.PositionGroupId, 
  dbo.DC_DEPARTMENT_POSITION.DepartmentPositionName 
FROM 
  dbo.DC_USER 
  INNER JOIN dbo.DC_WORKPLACE AS DC_WORKPLACE_1 ON dbo.DC_USER.UserId = DC_WORKPLACE_1.WorkplaceUserId 
  INNER JOIN dbo.DC_PERSONNEL ON dbo.DC_USER.UserPersonnelId = dbo.DC_PERSONNEL.PersonnelId 
  INNER JOIN dbo.DC_DEPARTMENT ON DC_WORKPLACE_1.WorkplaceDepartmentId = dbo.DC_DEPARTMENT.DepartmentId 
  INNER JOIN dbo.DC_ORGANIZATION ON dbo.DC_DEPARTMENT.DepartmentOrganization = dbo.DC_ORGANIZATION.OrganizationId 
  INNER JOIN (
    SELECT 
      DW.WorkplaceId AS Id, 
      dbo.GET_PERSON(1, DW.WorkplaceId) AS [Name], 
      G.PositionGroupLevel 
    FROM 
      DC_DEPARTMENT_POSITION DP 
      INNER JOIN DC_WORKPLACE DW ON DP.DepartmentPositionId = DW.WorkplaceDepartmentPositionId 
      INNER JOIN DC_DEPARTMENT D ON D.DepartmentId = DP.DepartmentId 
      INNER JOIN DC_POSITION_GROUP G ON G.PositionGroupId = DP.PositionGroupId 
    WHERE 
      (
        g.PositionGroupId IN (5, 9, 36, 33, 2, 1,3) 
        AND g.PositionGroupId NOT IN (@pgId)
      ) 
      OR (
        g.PositionGroupId = 17 
        AND DepartmentOrganization = 1
      )
	 
  ) AS A ON DC_WORKPLACE_1.WorkplaceId = A.Id 
  INNER JOIN dbo.DC_DEPARTMENT_POSITION ON DC_WORKPLACE_1.WorkplaceDepartmentPositionId = dbo.DC_DEPARTMENT_POSITION.DepartmentPositionId 
WHERE 

  dbo.DC_PERSONNEL.PersonnelStatus = 1 
  and PositionGroupLevel!=1--Ramin mellimin adinin gorunmemesi ucun
  AND DC_WORKPLACE_1.WorkplaceId NOT IN (   4556,160,148,4563)
  AND ((@pgId=2 and PositionGroupLevel!=2) OR  @pgId!=2 )
  AND (@executorfullname IS NULL OR  A.Name LIKE @executorfullname+N'%')
  AND (@departmentpositionname is null or  dbo.DC_DEPARTMENT_POSITION.PositionGroupId IN (SELECT [value] FROM STRING_SPLIT(case when @departmentpositionname=-200 then '13,17,26' when @departmentpositionname =-100 then  '5,9,25'  end,',')))
  AND UserStatus!=0
  
  UNION
  SELECT 
  DISTINCT A.Id AS WorkPlaceId, 
  A.Name AS PersonFullName, 
  A.PositionGroupLevel, 
  PositionGroupId, 
  dbo.DC_USER.UserId, 
  dbo.DC_USER.UserName, 
  dbo.DC_PERSONNEL.PersonnelId, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelName, 
    ''
  ) AS PersonnelName, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelSurname, 
    ''
  ) AS PersonnelSurname, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelLastname, 
    ''
  ) AS PersonnelLastname, 
  dbo.DC_DEPARTMENT.DepartmentId, 
  dbo.DC_DEPARTMENT.DepartmentName, 
  dbo.DC_ORGANIZATION.OrganizationId, 
  dbo.DC_ORGANIZATION.OrganizationName, 
  dbo.DC_DEPARTMENT_POSITION.PositionGroupId, 
  dbo.DC_DEPARTMENT_POSITION.DepartmentPositionName 
FROM 
  dbo.DC_USER 
  INNER JOIN dbo.DC_WORKPLACE AS DC_WORKPLACE_1 ON dbo.DC_USER.UserId = DC_WORKPLACE_1.WorkplaceUserId 
  INNER JOIN dbo.DC_PERSONNEL ON dbo.DC_USER.UserPersonnelId = dbo.DC_PERSONNEL.PersonnelId 
  INNER JOIN dbo.DC_DEPARTMENT ON DC_WORKPLACE_1.WorkplaceDepartmentId = dbo.DC_DEPARTMENT.DepartmentId 
  INNER JOIN dbo.DC_ORGANIZATION ON dbo.DC_DEPARTMENT.DepartmentOrganization = dbo.DC_ORGANIZATION.OrganizationId 
  INNER JOIN (
    SELECT 
      DW.WorkplaceId AS Id, 
      dbo.GET_PERSON(1, DW.WorkplaceId) AS [Name], 
      G.PositionGroupLevel 
    FROM 
      DC_DEPARTMENT_POSITION DP 
      INNER JOIN DC_WORKPLACE DW ON DP.DepartmentPositionId = DW.WorkplaceDepartmentPositionId 
      INNER JOIN DC_DEPARTMENT D ON D.DepartmentId = DP.DepartmentId 
      INNER JOIN DC_POSITION_GROUP G ON G.PositionGroupId = DP.PositionGroupId 
    WHERE 
         DW.WorkplaceId=  468
  ) AS A ON DC_WORKPLACE_1.WorkplaceId = A.Id 
  INNER JOIN dbo.DC_DEPARTMENT_POSITION ON DC_WORKPLACE_1.WorkplaceDepartmentPositionId = dbo.DC_DEPARTMENT_POSITION.DepartmentPositionId 
WHERE 
  dbo.DC_PERSONNEL.PersonnelStatus = 1 
  and PositionGroupLevel!=1--Ramin mellimin adinin gorunmemesi ucun
   AND (@executorfullname IS NULL OR  A.Name LIKE @executorfullname+N'%')
  AND (@departmentpositionname is null or  dbo.DC_DEPARTMENT_POSITION.PositionGroupId IN (SELECT [value] FROM STRING_SPLIT(case when @departmentpositionname=-200 then '13,17,26' when @departmentpositionname =-100 then  '5,9,25'  end,',')))
    AND UserStatus!=0
ORDER BY 
  PositionGroupLevel END ELSE BEGIN IF (@depTypeId = 5) BEGIN 
SELECT 
  DISTINCT A.Id AS WorkPlaceId, 
  A.Name AS PersonFullName, 
  A.PositionGroupLevel, 
  PositionGroupId, 
  dbo.DC_USER.UserId, 
  dbo.DC_USER.UserName, 
  dbo.DC_PERSONNEL.PersonnelId, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelName, 
    ''
  ) AS PersonnelName, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelSurname, 
    ''
  ) AS PersonnelSurname, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelLastname, 
    ''
  ) AS PersonnelLastname, 
  dbo.DC_DEPARTMENT.DepartmentId, 
  dbo.DC_DEPARTMENT.DepartmentName, 
  dbo.DC_ORGANIZATION.OrganizationId, 
  dbo.DC_ORGANIZATION.OrganizationName, 
  dbo.DC_DEPARTMENT_POSITION.PositionGroupId, 
  dbo.DC_DEPARTMENT_POSITION.DepartmentPositionName 
FROM 
  dbo.DC_USER 
  INNER JOIN dbo.DC_WORKPLACE AS DC_WORKPLACE_1 ON dbo.DC_USER.UserId = DC_WORKPLACE_1.WorkplaceUserId 
  INNER JOIN dbo.DC_PERSONNEL ON dbo.DC_USER.UserPersonnelId = dbo.DC_PERSONNEL.PersonnelId 
  INNER JOIN dbo.DC_DEPARTMENT ON DC_WORKPLACE_1.WorkplaceDepartmentId = dbo.DC_DEPARTMENT.DepartmentId 
  INNER JOIN dbo.DC_ORGANIZATION ON dbo.DC_DEPARTMENT.DepartmentOrganization = dbo.DC_ORGANIZATION.OrganizationId 
  INNER JOIN (
    SELECT 
      DW.WorkplaceId AS Id, 
      dbo.GET_PERSON(1, DW.WorkplaceId) AS [Name], 
      G.PositionGroupLevel 
    FROM 
      DC_DEPARTMENT_POSITION DP 
      INNER JOIN DC_WORKPLACE DW ON DP.DepartmentPositionId = DW.WorkplaceDepartmentPositionId 
      INNER JOIN DC_DEPARTMENT D ON D.DepartmentId = DP.DepartmentId 
      INNER JOIN DC_POSITION_GROUP G ON G.PositionGroupId = DP.PositionGroupId 
    WHERE 
      (
        (D.DepartmentTopId = @depId 
        OR D.DepartmentId = @depId)
		AND WorkplaceId NOT IN (80,4592)
		--AND (WorkplaceId=4571 AND @workplaceId=458)
      ) 
      AND g.PositionGroupId NOT IN (@pgId)
	  union
	  SELECT 
      DW.WorkplaceId AS Id, 
      dbo.GET_PERSON(1, DW.WorkplaceId) AS [Name], 
      G.PositionGroupLevel 
    FROM 
      DC_DEPARTMENT_POSITION DP 
      INNER JOIN DC_WORKPLACE DW ON DP.DepartmentPositionId = DW.WorkplaceDepartmentPositionId 
      INNER JOIN DC_DEPARTMENT D ON D.DepartmentId = DP.DepartmentId 
      INNER JOIN DC_POSITION_GROUP G ON G.PositionGroupId = DP.PositionGroupId 
    WHERE 
      @workplaceId = 458 
      AND WorkplaceId IN ( 4571)
	  union
	  SELECT 
      DW.WorkplaceId AS Id, 
      dbo.GET_PERSON(1, DW.WorkplaceId) AS [Name], 
      G.PositionGroupLevel 
    FROM 
      DC_DEPARTMENT_POSITION DP 
      INNER JOIN DC_WORKPLACE DW ON DP.DepartmentPositionId = DW.WorkplaceDepartmentPositionId 
      INNER JOIN DC_DEPARTMENT D ON D.DepartmentId = DP.DepartmentId 
      INNER JOIN DC_POSITION_GROUP G ON G.PositionGroupId = DP.PositionGroupId 
    WHERE 
      @workplaceId = 24 
      AND WorkplaceId IN ( 4568)
  ) AS A ON DC_WORKPLACE_1.WorkplaceId = A.Id 
  INNER JOIN dbo.DC_DEPARTMENT_POSITION ON DC_WORKPLACE_1.WorkplaceDepartmentPositionId = dbo.DC_DEPARTMENT_POSITION.DepartmentPositionId 
WHERE 
  dbo.DC_PERSONNEL.PersonnelStatus = 1 
     AND (@executorfullname IS NULL OR  A.Name LIKE @executorfullname+N'%')
	  AND (@departmentpositionname is null or  dbo.DC_DEPARTMENT_POSITION.PositionGroupId IN (SELECT [value] FROM STRING_SPLIT(case when @departmentpositionname=-200 then '13,17,26' when @departmentpositionname =-100 then  '5,9,25'  end,',')))
	    AND UserStatus!=0
ORDER BY 
  PositionGroupLevel END
   ELSE IF (@depTypeId = 1) BEGIN 
  if(@workplaceId in (474,2495,162,163,154,165,499,159))
  BEGIN 
  SELECT   DISTINCT A.Id AS WorkPlaceId, 
  A.Name AS PersonFullName, 
  A.PositionGroupLevel, 
  PositionGroupId, 
  dbo.DC_USER.UserId, 
  dbo.DC_USER.UserName, 
  dbo.DC_PERSONNEL.PersonnelId, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelName, 
    ''
  ) AS PersonnelName, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelSurname, 
    ''
  ) AS PersonnelSurname, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelLastname, 
    ''
  ) AS PersonnelLastname, 
  dbo.DC_DEPARTMENT.DepartmentId, 
  dbo.DC_DEPARTMENT.DepartmentName, 
  dbo.DC_ORGANIZATION.OrganizationId, 
  dbo.DC_ORGANIZATION.OrganizationName, 
  dbo.DC_DEPARTMENT_POSITION.PositionGroupId, 
  dbo.DC_DEPARTMENT_POSITION.DepartmentPositionName 
FROM 
  dbo.DC_USER 
  INNER JOIN dbo.DC_WORKPLACE AS DC_WORKPLACE_1 ON dbo.DC_USER.UserId = DC_WORKPLACE_1.WorkplaceUserId 
  INNER JOIN dbo.DC_PERSONNEL ON dbo.DC_USER.UserPersonnelId = dbo.DC_PERSONNEL.PersonnelId 
  INNER JOIN dbo.DC_DEPARTMENT ON DC_WORKPLACE_1.WorkplaceDepartmentId = dbo.DC_DEPARTMENT.DepartmentId 
  INNER JOIN dbo.DC_ORGANIZATION ON dbo.DC_DEPARTMENT.DepartmentOrganization = dbo.DC_ORGANIZATION.OrganizationId 
  INNER JOIN (
    SELECT 
      DW.WorkplaceId AS Id, 
      dbo.GET_PERSON(1, DW.WorkplaceId) AS [Name], 
      G.PositionGroupLevel 
    FROM 
      DC_DEPARTMENT_POSITION DP 
      INNER JOIN DC_WORKPLACE DW ON DP.DepartmentPositionId = DW.WorkplaceDepartmentPositionId 
      INNER JOIN DC_DEPARTMENT D ON D.DepartmentId = DP.DepartmentId 
      INNER JOIN DC_POSITION_GROUP G ON G.PositionGroupId = DP.PositionGroupId 
    WHERE 
      (
 DW.WorkplaceId= case when @workplaceId=474 THEN 160 WHEN @workplaceId=2495 THEN 148 WHEN @workplaceId=162 THEN 164 WHEN @workplaceId=163 then 497  when @workplaceId=154 then 5006
  when @workplaceId=165 then 3511 WHEN @workplaceId=499  then  3517 WHEN @workplaceId=159 THEN 4607 end

      )
  ) AS A ON DC_WORKPLACE_1.WorkplaceId = A.Id 
  INNER JOIN dbo.DC_DEPARTMENT_POSITION ON DC_WORKPLACE_1.WorkplaceDepartmentPositionId = dbo.DC_DEPARTMENT_POSITION.DepartmentPositionId 
WHERE 
  dbo.DC_PERSONNEL.PersonnelStatus = 1 
  AND (@executorfullname IS NULL OR  A.Name LIKE @executorfullname+N'%')
	  AND (@departmentpositionname is null or  dbo.DC_DEPARTMENT_POSITION.PositionGroupId IN (SELECT [value] FROM STRING_SPLIT(case when @departmentpositionname=-200 then '13,17,26' when @departmentpositionname =-100 then  '5,9,25'  end,',')))

    --  AND ((@pgId=3 and PositionGroupLevel!=2) OR  @pgId!=3 )
  UNION
  SELECT   DISTINCT A.Id AS WorkPlaceId, 
  A.Name AS PersonFullName, 
  A.PositionGroupLevel, 
  PositionGroupId, 
  dbo.DC_USER.UserId, 
  dbo.DC_USER.UserName, 
  dbo.DC_PERSONNEL.PersonnelId, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelName, 
    ''
  ) AS PersonnelName, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelSurname, 
    ''
  ) AS PersonnelSurname, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelLastname, 
    ''
  ) AS PersonnelLastname, 
  dbo.DC_DEPARTMENT.DepartmentId, 
  dbo.DC_DEPARTMENT.DepartmentName, 
  dbo.DC_ORGANIZATION.OrganizationId, 
  dbo.DC_ORGANIZATION.OrganizationName, 
  dbo.DC_DEPARTMENT_POSITION.PositionGroupId, 
  dbo.DC_DEPARTMENT_POSITION.DepartmentPositionName 
FROM 
  dbo.DC_USER 
  INNER JOIN dbo.DC_WORKPLACE AS DC_WORKPLACE_1 ON dbo.DC_USER.UserId = DC_WORKPLACE_1.WorkplaceUserId 
  INNER JOIN dbo.DC_PERSONNEL ON dbo.DC_USER.UserPersonnelId = dbo.DC_PERSONNEL.PersonnelId 
  INNER JOIN dbo.DC_DEPARTMENT ON DC_WORKPLACE_1.WorkplaceDepartmentId = dbo.DC_DEPARTMENT.DepartmentId 
  INNER JOIN dbo.DC_ORGANIZATION ON dbo.DC_DEPARTMENT.DepartmentOrganization = dbo.DC_ORGANIZATION.OrganizationId 
  INNER JOIN (
    SELECT 
      DW.WorkplaceId AS Id, 
      dbo.GET_PERSON(1, DW.WorkplaceId) AS [Name], 
      G.PositionGroupLevel 
    FROM 
      DC_DEPARTMENT_POSITION DP 
      INNER JOIN DC_WORKPLACE DW ON DP.DepartmentPositionId = DW.WorkplaceDepartmentPositionId 
      INNER JOIN DC_DEPARTMENT D ON D.DepartmentId = DP.DepartmentId 
      INNER JOIN DC_POSITION_GROUP G ON G.PositionGroupId = DP.PositionGroupId 
    WHERE 
      (
        D.DepartmentId = @depId 
        AND g.PositionGroupId NOT IN (@pgId)
      ) 
      OR (
        D.DepartmentOrganization = @depOrgId 
        AND g.PositionGroupId = 17
      )
  ) AS A ON DC_WORKPLACE_1.WorkplaceId = A.Id 
  INNER JOIN dbo.DC_DEPARTMENT_POSITION ON DC_WORKPLACE_1.WorkplaceDepartmentPositionId = dbo.DC_DEPARTMENT_POSITION.DepartmentPositionId 
WHERE 
  dbo.DC_PERSONNEL.PersonnelStatus = 1 
   -- AND ((@pgId=3 and PositionGroupLevel!=2) OR  @pgId!=3 )
    AND (@executorfullname IS NULL OR  A.Name LIKE @executorfullname+N'%')
	  AND (@departmentpositionname is null or  dbo.DC_DEPARTMENT_POSITION.PositionGroupId IN (SELECT [value] FROM STRING_SPLIT(case when @departmentpositionname=-200 then '13,17,26' when @departmentpositionname =-100 then  '5,9,25'  end,',')))
	    AND UserStatus!=0
ORDER BY 
  PositionGroupLevel

  END ELSE
   BEGIN    
SELECT   DISTINCT A.Id AS WorkPlaceId, 
  A.Name AS PersonFullName, 
  A.PositionGroupLevel, 
  PositionGroupId, 
  dbo.DC_USER.UserId, 
  dbo.DC_USER.UserName, 
  dbo.DC_PERSONNEL.PersonnelId, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelName, 
    ''
  ) AS PersonnelName, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelSurname, 
    ''
  ) AS PersonnelSurname, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelLastname, 
    ''
  ) AS PersonnelLastname, 
  dbo.DC_DEPARTMENT.DepartmentId, 
  dbo.DC_DEPARTMENT.DepartmentName, 
  dbo.DC_ORGANIZATION.OrganizationId, 
  dbo.DC_ORGANIZATION.OrganizationName, 
  dbo.DC_DEPARTMENT_POSITION.PositionGroupId, 
  dbo.DC_DEPARTMENT_POSITION.DepartmentPositionName 
FROM 
  dbo.DC_USER 
  INNER JOIN dbo.DC_WORKPLACE AS DC_WORKPLACE_1 ON dbo.DC_USER.UserId = DC_WORKPLACE_1.WorkplaceUserId 
  INNER JOIN dbo.DC_PERSONNEL ON dbo.DC_USER.UserPersonnelId = dbo.DC_PERSONNEL.PersonnelId 
  INNER JOIN dbo.DC_DEPARTMENT ON DC_WORKPLACE_1.WorkplaceDepartmentId = dbo.DC_DEPARTMENT.DepartmentId 
  INNER JOIN dbo.DC_ORGANIZATION ON dbo.DC_DEPARTMENT.DepartmentOrganization = dbo.DC_ORGANIZATION.OrganizationId 
  INNER JOIN (
    SELECT 
      DW.WorkplaceId AS Id, 
      dbo.GET_PERSON(1, DW.WorkplaceId) AS [Name], 
      G.PositionGroupLevel 
    FROM 
      DC_DEPARTMENT_POSITION DP 
      INNER JOIN DC_WORKPLACE DW ON DP.DepartmentPositionId = DW.WorkplaceDepartmentPositionId 
      INNER JOIN DC_DEPARTMENT D ON D.DepartmentId = DP.DepartmentId 
      INNER JOIN DC_POSITION_GROUP G ON G.PositionGroupId = DP.PositionGroupId 
    WHERE 
      (
        D.DepartmentId = @depId 
        AND g.PositionGroupId NOT IN (@pgId)
      ) 
    OR (
        D.DepartmentOrganization = @depOrgId AND  @depOrgId!=11---BTRIBT
        AND g.PositionGroupId =  17
      )
	  OR (
        D.DepartmentOrganization = @depOrgId AND  @depOrgId=11--BTRIBT
        AND g.PositionGroupId  IN ( 13 ,26,17) 
		AND ( D.DepartmentTopId = @depId )
       -- AND g.PositionGroupId NOT IN (@pgId)) 
      )
  ) AS A ON DC_WORKPLACE_1.WorkplaceId = A.Id 
  INNER JOIN dbo.DC_DEPARTMENT_POSITION ON DC_WORKPLACE_1.WorkplaceDepartmentPositionId = dbo.DC_DEPARTMENT_POSITION.DepartmentPositionId 
WHERE 
  dbo.DC_PERSONNEL.PersonnelStatus = 1 
   --  AND ((@pgId=3 and PositionGroupLevel!=2) OR  @pgId!=3 )
	 AND (@executorfullname IS NULL OR  A.Name LIKE @executorfullname+N'%')
	  AND (@departmentpositionname is null or  dbo.DC_DEPARTMENT_POSITION.PositionGroupId IN (SELECT [value] FROM STRING_SPLIT(case when @departmentpositionname=-200 then '13,17,26' when @departmentpositionname =-100 then  '5,9,25'  end,',')))
	    AND UserStatus!=0
ORDER BY 
  PositionGroupLevel
   END 
  END 
  ELSE BEGIN 

SELECT 
  DISTINCT A.Id AS WorkPlaceId, 
  A.Name AS PersonFullName, 
  A.PositionGroupLevel, 
  PositionGroupId, 
  dbo.DC_USER.UserId, 
  dbo.DC_USER.UserName, 
  dbo.DC_PERSONNEL.PersonnelId, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelName, 
    ''
  ) AS PersonnelName, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelSurname, 
    ''
  ) AS PersonnelSurname, 
  ISNULL(
    dbo.DC_PERSONNEL.PersonnelLastname, 
    ''
  ) AS PersonnelLastname, 
  dbo.DC_DEPARTMENT.DepartmentId, 
  dbo.DC_DEPARTMENT.DepartmentName, 
  dbo.DC_ORGANIZATION.OrganizationId, 
  dbo.DC_ORGANIZATION.OrganizationName, 
  dbo.DC_DEPARTMENT_POSITION.PositionGroupId, 
  dbo.DC_DEPARTMENT_POSITION.DepartmentPositionName 
FROM 
  dbo.DC_USER 
  INNER JOIN dbo.DC_WORKPLACE AS DC_WORKPLACE_1 ON dbo.DC_USER.UserId = DC_WORKPLACE_1.WorkplaceUserId 
  INNER JOIN dbo.DC_PERSONNEL ON dbo.DC_USER.UserPersonnelId = dbo.DC_PERSONNEL.PersonnelId 
  INNER JOIN dbo.DC_DEPARTMENT ON DC_WORKPLACE_1.WorkplaceDepartmentId = dbo.DC_DEPARTMENT.DepartmentId 
  INNER JOIN dbo.DC_ORGANIZATION ON dbo.DC_DEPARTMENT.DepartmentOrganization = dbo.DC_ORGANIZATION.OrganizationId 
  INNER JOIN (
    SELECT 
      DW.WorkplaceId AS Id, 
      dbo.GET_PERSON(1, DW.WorkplaceId) AS [Name], 
      G.PositionGroupLevel 
    FROM 
      DC_DEPARTMENT_POSITION DP 
      INNER JOIN DC_WORKPLACE DW ON DP.DepartmentPositionId = DW.WorkplaceDepartmentPositionId 
      INNER JOIN DC_DEPARTMENT D ON D.DepartmentId = DP.DepartmentId 
      INNER JOIN DC_POSITION_GROUP G ON G.PositionGroupId = DP.PositionGroupId 
    WHERE 
      ( (D.DepartmentId = @depId AND @depOrgId!=11 )OR--BTRIB
	  	  (@depOrgId=11 and D.DepartmentTopId=@depId) --and g.PositionGroupId = 22
      AND g.PositionGroupId NOT IN (@pgId) )
	AND  DW.WorkplaceId != case when @workplaceId=119 then  (5023) else 0 end
	 -- AND (@workplaceId=119 AND DW.WorkplaceId not IN (5023)  )

    UNION ALL 
      ---Gulten xanimda istisan hal olarag Yelmarin adinin cixmasi ucun
    SELECT 
      DW.WorkplaceId AS Id, 
      dbo.GET_PERSON(1, DW.WorkplaceId) AS [Name], 
      G.PositionGroupLevel 
    FROM 
      DC_DEPARTMENT_POSITION DP 
      INNER JOIN DC_WORKPLACE DW ON DP.DepartmentPositionId = DW.WorkplaceDepartmentPositionId 
      INNER JOIN DC_DEPARTMENT D ON D.DepartmentId = DP.DepartmentId 
      INNER JOIN DC_POSITION_GROUP G ON G.PositionGroupId = DP.PositionGroupId 
    WHERE 
      @workplaceId = 24 
        AND WorkplaceId IN ( 4568,150)
  ) AS A ON DC_WORKPLACE_1.WorkplaceId = A.Id 
  INNER JOIN dbo.DC_DEPARTMENT_POSITION ON DC_WORKPLACE_1.WorkplaceDepartmentPositionId = dbo.DC_DEPARTMENT_POSITION.DepartmentPositionId 
WHERE 
  dbo.DC_PERSONNEL.PersonnelStatus = 1 
    AND (@executorfullname IS NULL OR  A.Name LIKE @executorfullname+N'%')
	  AND (@departmentpositionname is null or  dbo.DC_DEPARTMENT_POSITION.PositionGroupId IN (SELECT [value] FROM STRING_SPLIT(case when @departmentpositionname=-200 then '13,17,26' when @departmentpositionname =-100 then  '5,9,25'  end,',')))
	    AND UserStatus!=0
	--	AND (@workplaceId=119 and DC_WORKPLACE_1.WorkplaceId NOT IN (5023) )
		
	
ORDER BY 
  PositionGroupLevel 
  END
   END 
   END
  
