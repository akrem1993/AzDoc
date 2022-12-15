
-- =============================================
CREATE PROCEDURE [smdo].[AddDvcSigners]
@DocId int,
@subject nvarchar(max),
@serialNum nvarchar(max),
@ValidFrom datetime,
@ValidTo datetime,
@issuer nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from

INSERT smdo.DtsSigners
(
    --Id - column value is auto-generated
    DocId,
    subject,
    serialNumber,
    validFrom,
    validTo,
    issuer
)
VALUES
(
 @DocId ,
@subject ,
@serialNum ,
@ValidFrom, 
@ValidTo ,
@issuer 
)

END

