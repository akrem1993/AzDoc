CREATE procedure [admin].[UserInfo] @userId INT
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT *
        FROM
        (
            SELECT dp.PersonnelName, 
                   dp.PersonnelSurname, 
                   dp.PersonnelLastname, 
                   dp.PersonnelBirthdate, 
                   ds.SexName, 
                   dp.PersonnelPhone, 
                   dp.PersonnelEmail, 
                   dp.PersonnelMobile, 
            (
                SELECT *
                FROM
                (
                    SELECT do.OrganizationName, 
                           dd.DepartmentName, 
                           ddp.DepartmentPositionName, 
                    (
                        SELECT STUFF(
                        (
                            SELECT ' ' + dr.RoleComment + ','
                            FROM dbo.DC_WORKPLACE_ROLE dwr
                                 LEFT JOIN dbo.DC_ROLE dr ON dwr.RoleId = dr.RoleId
                            WHERE dwr.WorkplaceId = dw.WorkplaceId AND dwr.Status=1 FOR XML PATH('')
                        ), 1, 1, '')
                    ) AS RoleComment
                    FROM dbo.DC_WORKPLACE dw
                         LEFT JOIN dbo.DC_ORGANIZATION do ON dw.WorkplaceOrganizationId = do.OrganizationId
                         LEFT JOIN dbo.DC_DEPARTMENT dd ON dw.WorkplaceDepartmentId = dd.DepartmentId
                         LEFT JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
                    WHERE dw.WorkplaceUserId = du.UserId
					AND dw.WorkPlaceStatus=1
                ) d FOR JSON AUTO
            ) AS JsonWorkPlace
            FROM dbo.DC_USER du
                 JOIN dbo.DC_PERSONNEL dp ON du.UserPersonnelId = dp.PersonnelId
                 JOIN dbo.DC_SEX ds ON dp.PersonnelSexId = ds.SexId
            WHERE du.UserId = @userId
        ) s FOR JSON AUTO;
    END;

