
CREATE procedure [admin].[GetRoles] @pageIndex INT = 1, @pageSize INT =20, @totalCount INT = NULL OUT

AS

BEGIN
SELECT r.RoleId, r.RoleComment AS RoleName FROM DC_Role r WHERE r.RoleStatus=1 

  ORDER BY r.RoleId DESC OFFSET @pageSize * (@pageIndex - 1) ROWS FETCH NEXT @pageSize ROWS ONLY

SELECT @totalCount = COUNT(0) FROM DC_Role dr WHERE dr.RoleStatus=1
END









