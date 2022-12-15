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


 CREATE   VIEW [dbo].[VW_ROLES]
AS
SELECT 
DO.OperationId,
DO.OperationParameter,
OT.OperationtypeId,
DR.RightId, 
RT.RightTypeId,
WR.WorkplaceId
FROM DC_WORKPLACE_ROLE WR
LEFT JOIN DC_ROLE_OPERATION RO ON RO.RoleId=WR.RoleId
INNER JOIN DC_OPERATION DO ON DO.OperationId=RO.OperationId
INNER JOIN DC_OPERATIONTYPE OT ON OT.OperationtypeId=DO.OperationTypeId
INNER JOIN DC_RIGHT DR ON DR.RightId=RO.RightId
INNER JOIN DC_RIGHT_TYPE RT ON RT.RightTypeId=RO.RightTypeId WHERE
DR.RightStatus=1 AND RT.RightTypeStatus=1 AND DO.OperationStatus=1
AND OT.OperationtypeStatus=1

