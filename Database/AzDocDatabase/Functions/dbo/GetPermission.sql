/*
Migrated by Kamran A-eff 07.09.2019
*/

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
-- Author:  Musayev Nurlan
-- Create date: 14.06.2019
-- Description: Istifadecinin emeliyyatin icrasina icazesine baxilmasi
-- =============================================
CREATE FUNCTION [dbo].[GetPermission]
(
@workPlaceId int,
@docType int=null,
@rightTypeId int
)
RETURNS bit
AS
BEGIN
 DECLARE @result  bit=0;
  
IF EXISTS(
    SELECT dro.RightTypeId AS RightId 
    FROM 
    dbo.DC_WORKPLACE_ROLE dwr
    JOIN dbo.DC_ROLE dr ON dwr.RoleId = dr.RoleId--USERIN ROLU   
    JOIN dbo.DC_ROLE_OPERATION dro ON dr.RoleId = dro.RoleId--MODUL NOVU
    JOIN dbo.DC_OPERATION do ON do.OperationId=dro.RoleOperationId
    JOIN dbo.DC_RIGHT dr2 ON dro.RightId = dr2.RightId--SENED NOVU
    JOIN dbo.DC_RIGHT_TYPE drt ON drt.RightTypeId = dro.RightTypeId--ICAZE  NOVU
    WHERE 
    dwr.WorkplaceId=@workPlaceId
    AND do.OperationParameter=@docType
    AND drt.RightTypeId =@rightTypeId
    and dr2.RightStatus=1
    AND drt.RightTypeStatus=1
    AND DO.OperationStatus=1
) set @result=1;


 -- Return the result of the function
 RETURN @result;

END

