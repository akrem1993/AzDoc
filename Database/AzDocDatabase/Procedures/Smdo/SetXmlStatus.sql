-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 18.11.2019
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [smdo].[SetXmlStatus]
@id int,
@xmlData nvarchar(max)=null,
@xmlStatus bit=0,
@xmlOut int OUTPUT
AS
BEGIN

if(@id=0)
BEGIN
INSERT smdo.ReceivedXmlStatus
(
    --id - column value is auto-generated
    XmlData,
    XmlStatus
)
VALUES
(
    -- id - int
    @xmlData, -- XmlData - nvarchar
    0 -- XmlStatus - bit -- ReceivedDate - datetime
)

SET @xmlOut=SCOPE_IDENTITY()
END
ELSE BEGIN
	UPDATE smdo.ReceivedXmlStatus SET smdo.ReceivedXmlStatus.XmlStatus=1 WHERE smdo.ReceivedXmlStatus.id=@id;
END

END

