CREATE procedure [admin].[GetDepartmentsByIdBackup] @deptId INT
AS
    BEGIN
        SET NOCOUNT ON;

		if(@deptId <> 0)
		BEGIN
		SELECT dd.DepartmentId AS Id, dd.DepartmentName AS [Name] FROM [dbo].[DC_DEPARTMENT] dd  WHERE dd.DepartmentStatus = 1 AND dd.DepartmentId = @deptId FOR JSON AUTO 
	    END

		ELSE
		BEGIN
		SELECT dd.DepartmentId AS Id, dd.DepartmentName AS [Name] FROM [dbo].[DC_DEPARTMENT] dd  WHERE dd.DepartmentStatus = 1  FOR JSON AUTO 

		END


		 
    END;

