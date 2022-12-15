CREATE procedure [admin].[GetPositionsByDeptId] @deptId INT
AS
    BEGIN
        SET NOCOUNT ON;

		if(@deptId <> 0)
		BEGIN
		     SELECT dp.DepartmentPositionId AS Id, dp.DepartmentPositionName AS [Name] 
		     FROM [dbo].[DC_DEPARTMENT_POSITION] dp
		     WHERE dp.DepartmentPositionStatus = 1 AND dp.DepartmentId = @deptId FOR JSON AUTO 
	         END
		 
    END;

