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
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [resolution].[spGetDirectionInfo]

@docId int,
@docTypeId int
AS
BEGIN
 SET NOCOUNT ON;

select DocId,DocDocumentstatusId,DocDoctypeId,DocTypeName ,AdrTypeId, d.DocDescription DocDescription,
--case when DocEnterdate is null then DocDocNo else 
DocEnterno ,DocUndercontrolStatusId,Isnull(DocExecutionStatusId,0) DocExecutionStatusId,
OrganizationName SendToWhere, AuthorName + ' ' +AuthorSurname  as AuthorName ,PositionName ,

                    (
                        SELECT OrganizationName
                        FROM DC_ORGANIZATION
                        WHERE OrganizationId =
                        (
                            SELECT af.AdrOrganizationId
                            FROM DOCS_ADDRESSINFO af
                            WHERE af.AdrDocId = d.DocId
                                  AND af.AdrTypeId = 3
                                  AND af.AdrAuthorId IS NOT NULL
                        )
                    ) AS OrganizationName from dbo.DOCS d

left join dbo.DOCS_ADDRESSINFO adr on adr.AdrDocId=d.DocId
left join dbo.DOC_TYPE dt on dt.DocTypeId=d.DocDoctypeId
left join dbo.DC_ORGANIZATION do on do.OrganizationId= adr.AdrOrganizationId
left join dbo.DOC_AUTHOR da on da.AuthorId=adr.AdrAuthorId
left join dbo.DC_POSITION dp on dp.PositionId=adr.AdrPositionId
where
--AdrTypeId=3 and
 DocId=@docId
 and DocTypeId=@docTypeId
END

