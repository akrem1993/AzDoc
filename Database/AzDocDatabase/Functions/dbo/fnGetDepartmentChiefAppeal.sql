-- =============================================
-- Author:  Musayev Nurlan
-- Create date: 28.06.2019
-- Description: Departamentin shobe mudurunu tapir
-- =============================================
CREATE FUNCTION [dbo].[fnGetDepartmentChiefAppeal]
(@workPlaceId INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @result INT, @DepartmentTypeId INT, @DepartmentTopId INT, @departmentId INT, @positionGroupId INT, @currenWorkPlaceId INT;
         SELECT @departmentId = d.DepartmentId, 
                @DepartmentTypeId = d.DepartmentTypeId, 
                @DepartmentTopId = d.DepartmentTopId
         FROM DC_DEPARTMENT d
              JOIN DC_WORKPLACE w ON d.DepartmentId = w.WorkplaceDepartmentId
         WHERE w.WorkplaceId = @workPlaceId;
         SELECT @currenWorkPlaceId = w.WorkplaceId
         FROM DC_DEPARTMENT d
              JOIN DC_DEPARTMENT_POSITION dp ON d.DepartmentId = dp.DepartmentId
              JOIN DC_WORKPLACE w ON w.WorkplaceDepartmentPositionId = dp.DepartmentPositionId
         WHERE dp.PositionGroupId = @positionGroupId            --(17=SectionChief,26=SectorChief) 
               AND dp.DepartmentId = @departmentId
         ORDER BY dp.PositionGroupId DESC;
         IF @DepartmentTypeId = 6    --(DepartmentTypeId(6)='Sector')
             BEGIN
                 SET @departmentId = @DepartmentTopId;
                 SET @positionGroupId = 17;
         END;
             ELSE
             BEGIN
                 IF @DepartmentTopId IS NULL
                     RETURN @workPlaceId;
                 --set @departmentId=@DepartmentTopId; 
                 IF @DepartmentTypeId IN(2, 5)
                     SET @positionGroupId = 38;
         END;


         SELECT @result= dw.WorkplaceId
         FROM dbo.DC_WORKPLACE dw
              JOIN dbo.DC_DEPARTMENT_POSITION ddp ON dw.WorkplaceDepartmentPositionId = ddp.DepartmentPositionId
         WHERE dw.WorkplaceUserId =
         (
             SELECT dw.WorkplaceUserId
             FROM dbo.DC_WORKPLACE dw
             WHERE dw.WorkplaceId = 24
         )
               AND ddp.PositionGroupId IN(37, 38)
      ORDER BY ddp.PositionGroupId DESC;
   
         IF @result IS NULL
             RETURN @workPlaceId;
         RETURN @result;
     END;

