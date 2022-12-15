
CREATE procedure [admin].[GetPositions] @pageIndex INT = 1, @pageSize INT =20, @totalCount INT = NULL OUT

AS

BEGIN
SELECT dd.DepartmentName, ddp.DepartmentPositionId, ddp.DepartmentPositionName, ddp.DepartmentPositionIndex,dpg.PositionGroupName
 FROM dbo.DC_DEPARTMENT_POSITION ddp
 LEFT JOIN DC_DEPARTMENT dd  ON ddp.DepartmentId = dd.DepartmentId 
 LEFT JOIN DC_POSITION_GROUP dpg ON ddp.PositionGroupId=dpg.PositionGroupId
 WHERE ddp.DepartmentPositionStatus=1 

  ORDER BY ddp.DepartmentPositionId DESC OFFSET @pageSize * (@pageIndex - 1) ROWS FETCH NEXT @pageSize ROWS ONLY

SELECT @totalCount = COUNT(0) FROM dbo.DC_DEPARTMENT_POSITION ddp WHERE ddp.DepartmentPositionStatus=1
END







