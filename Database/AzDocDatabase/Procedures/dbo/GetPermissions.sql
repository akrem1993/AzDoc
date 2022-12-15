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
-- Create date: 15.06.2019
-- Description: Icazalerin list weklinde alinmasi alinmasi
-- =============================================
CREATE PROCEDURE [dbo].[GetPermissions] 
@workPlaceId int,
@docType int=null,
@rightTypesId [dbo].[RightsType] READONLY
AS
BEGIN
DECLARE @Rights table(RightId int)

INSERT INTO @Rights
(
    RightId
)
 SELECT dro.RightTypeId AS RightId FROM dbo.DC_WORKPLACE_ROLE dwr
    JOIN dbo.DC_ROLE dr ON dwr.RoleId = dr.RoleId--USERIN ROLU   
    JOIN dbo.DC_ROLE_OPERATION dro ON dr.RoleId = dro.RoleId--MODUL NOVU
    JOIN dbo.DC_OPERATION do ON do.OperationId=dro.RoleOperationId
    JOIN dbo.DC_RIGHT dr2 ON dro.RightId = dr2.RightId--SENED NOVU
    JOIN dbo.DC_RIGHT_TYPE drt ON drt.RightTypeId = dro.RightTypeId--ICAZE  NOVU
    WHERE 
    dwr.WorkplaceId=@workPlaceId
    AND do.OperationParameter=@docType
    AND drt.RightTypeId IN (SELECT rights.RightTypeId FROM @rightTypesId rights)
    and dr2.RightStatus=1
    AND drt.RightTypeStatus=1

    IF exists(SELECT r.RightId FROM @Rights r)
    BEGIN
        SELECT r.RightId FROM @Rights r;
        return;
   END
            
    SELECT -1 AS RightId;


END

