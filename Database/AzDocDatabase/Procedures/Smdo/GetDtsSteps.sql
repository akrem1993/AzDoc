-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [smdo].[GetDtsSteps]
@docId int
AS
BEGIN
SELECT ds.Id, 
       ds.DocId, 
       ds.StepId, 
      dst.StepName,
       ds.StepStatus, 
       ds.StepDescription
FROM smdo.DtsSteps ds
JOIN smdo.DtsStepType dst ON ds.StepId=dst.Id WHERE ds.DocId=@docId;	

END

