CREATE procedure [admin].[GetDepartmentsByOrgId] @orgId INT
AS
    BEGIN
        SET NOCOUNT ON;

		if(@orgId <> 0)
		BEGIN
		SELECT dd.DepartmentId AS Id, dd.DepartmentName AS [Name]
		FROM  [dbo].[DC_DEPARTMENT] dd  
		WHERE dd.DepartmentStatus = 1 AND dd.DepartmentOrganization = @orgId AND dd.DepartmentTypeId NOT IN (6) FOR JSON AUTO 
	    END
		 
    END;

