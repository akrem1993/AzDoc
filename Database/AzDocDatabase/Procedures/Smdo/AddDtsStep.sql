-- =============================================
-- Author:		Musayev Nurlan
-- Create date: 21.11.2019
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [smdo].[AddDtsStep]
@DocId int,
@StepId int,
@StepStatus bit
AS
BEGIN

INSERT smdo.DtsSteps
(
    --Id - column value is auto-generated
    DocId,
    StepId,
    StepStatus
)
VALUES
(
   @DocId ,
   @StepId ,
   @StepStatus 
)

END

