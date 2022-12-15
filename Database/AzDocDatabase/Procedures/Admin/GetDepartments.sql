
CREATE procedure [admin].[GetDepartments] @pageIndex INT = 1, @pageSize INT =20, @totalCount INT = NULL OUT

AS

BEGIN
SELECT dd.DepartmentId AS Id,dd.DepartmentName AS [Name], dd1.DepartmentName AS [ParentName],do.OrganizationShortname AS OrgName, dd.DepartmentIndex AS DeptIndex FROM dbo.DC_DEPARTMENT dd 
LEFT JOIN
 DC_DEPARTMENT dd1 
 ON dd.DepartmentTopId = dd1.DepartmentId 
 LEFT JOIN dbo.DC_ORGANIZATION do
  ON dd.DepartmentOrganization=do.OrganizationId

  WHERE dd.DepartmentStatus=1 

  ORDER BY dd.DepartmentId DESC OFFSET @pageSize * (@pageIndex - 1) ROWS FETCH NEXT @pageSize ROWS ONLY

SELECT @totalCount = COUNT(0) FROM DC_DEPARTMENT dd WHERE dd.DepartmentStatus=1
END









