CREATE procedure [admin].[UserInfoWithDetails] @userId INT
AS
    BEGIN
        SET NOCOUNT ON;

		

		if(@userId <> 0)
		BEGIN

        SELECT *
        FROM
        (
            SELECT dp.PersonnelName, 
                   dp.PersonnelSurname, 
                   dp.PersonnelLastname,
				   du.UserName,
				   du.UserStatus,
                   dp.PersonnelBirthdate,
                   dp.PersonnelSexId, 
				   dp.PersonnelPhone,
				   --case when dp.PersonnelEmail <>null then dp.PersonnelEmail ELSE '' END AS PersonnelEmail,
				   dp.PersonnelEmail,
				   dp.PersonnelMobile,

                
            (
                SELECT *
                FROM
                (
                    SELECT do.OrganizationId, 
                          -- dd.DepartmentId, 
						   case when dd.DepartmentTypeId = 6 then dd.DepartmentTopId ELSE dd.DepartmentId END AS DepartmentId,
						   case when dd.DepartmentTypeId = 6 then dd.DepartmentId ELSE '' END AS SectorId,
                           ddp.DepartmentPositionId,
						   dw.WorkplaceId,
						   dw.WorkPlaceStatus,
                    (
                        
                            SELECT dr.RoleId, dr.RoleName
                            FROM dbo.DC_WORKPLACE_ROLE dwr
                                 LEFT JOIN dbo.DC_ROLE dr ON dwr.RoleId = dr.RoleId
                            WHERE dwr.WorkplaceId = dw.WorkplaceId AND dwr.Status=1 FOR JSON AUTO
                        
                    ) AS Roles,
					(
                        
                            SELECT dr.RoleId, dr.RoleName
                            FROM  dbo.DC_ROLE dr  FOR JSON AUTO
                        
                    ) AS AllRoles,
					(
                        
                            SELECT o.OrganizationId AS Id, o.OrganizationShortname AS [Name] FROM DC_ORGANIZATION o 
							WHERE o.OrganizationStatus = 1  FOR JSON AUTO
                        
                    ) AS Organisations,
					(
                        
                            SELECT d.DepartmentId AS Id, d.DepartmentName AS [Name] FROM DC_DEPARTMENT d 
							WHERE d.DepartmentOrganization = do.OrganizationId 
							AND  d.DepartmentStatus = 1
							AND d.DepartmentTypeId <> 6
							  FOR JSON AUTO
                        
                    ) AS Departments,
					(
                        
                            SELECT d.DepartmentId AS Id, d.DepartmentName AS [Name] FROM DC_DEPARTMENT d 
							WHERE d.DepartmentOrganization = do.OrganizationId 
							AND  d.DepartmentStatus = 1 
							AND d.DepartmentTypeId = 6
							 FOR JSON AUTO
                        
                    ) AS Sectors,
					(
							SELECT dp.DepartmentPositionId AS Id, dp.DepartmentPositionName AS [Name] 
							FROM DC_DEPARTMENT_POSITION dp
							WHERE dp.DepartmentId = dd.DepartmentId  FOR JSON AUTO
					)AS DepartmentPositions


                    FROM dbo.DC_WORKPLACE dw
                         LEFT JOIN dbo.DC_ORGANIZATION do ON dw.WorkplaceOrganizationId = do.OrganizationId
                         LEFT JOIN dbo.DC_DEPARTMENT dd ON dw.WorkplaceDepartmentId = dd.DepartmentId
                         LEFT JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
                    WHERE dw.WorkplaceUserId = du.UserId 
                ) d FOR JSON AUTO
            ) AS JsonWorkPlace
            FROM dbo.DC_USER du
                 JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                 JOIN dbo.DC_SEX ds ON dp.PersonnelSexId = ds.SexId
            WHERE du.UserId = @userId
        ) AS UserDetailsWithWorkplaces

		 FOR JSON AUTO
		 END

		 
    END;

