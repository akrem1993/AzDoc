






CREATE   VIEW [outgoingdoc].[OutgoingDocs]
as
select 
d.DocId,
d.DocEnterno,--qeyd nomresi   
d.DocDocno,--layihe nomresi
d.DocDescription, --qisa mezmun
case when d.DocEnterdate is not null then d.DocEnterdate else d.DocDocdate end as DocDate,--migrate3 deyiwiklik --qeydtarixi,
dbo.GET_ADDRESSINFO(d.DocId, 1, 1) AS Signer,--imzalayan
(
  SELECT STUFF(
  (
      SELECT ' ' + OrganizationName + ''
      FROM DC_ORGANIZATION o
      WHERE o.OrganizationId IN
      (
          SELECT af.AdrOrganizationId
          FROM DOCS_ADDRESSINFO af
          WHERE af.AdrDocId = d.DocId
                AND af.AdrTypeId = 3
                AND af.AdrAuthorId IS NOT NULL
      ) FOR XML PATH('')
  ), 1, 1, '')
) AS WhomAdressedCompany, 
   --sendto
ds.DocumentstatusName  DocumentstatusName,
((select STUFF(
 (select (a.AuthorName + ' ' + a.AuthorSurname + ' ' + ISNULL(a.AuthorLastname,'')) + ''  
    from dbo.DOC_AUTHOR a
            where a.AuthorId in 
                   (select af.AdrAuthorId from DOCS_ADDRESSINFO af 
                               where af.AdrDocId=d.DocId and af.AdrTypeId in (1,3) and af.AdrAuthorId is not null)
 FOR XML PATH ('')), 1, 0, ''))) AS WhomAdressed, --kime unvanlanib--

df.FormId FormId,--senedin novu 
form.ReceivedFormId DocFormId,--gonderilme formasi  
CASE WHEN dr.DirectionCreatorWorkplaceId=e.ExecutorWorkplaceId THEN Convert(bit,1) 
     ELSE e.ExecutorControlStatus
END ExecutorControlStatus,

e.ExecutorWorkplaceId,
d.DocPeriodId,
dr.DirectionConfirmed,
af.AdrTypeId,
d.DocEnterdate,
d.DocReceivedFormId,
d.DocFormId AS DocForm,
dr.DirectionInsertedDate,
e.ExecutorReadStatus,
d.DocOrganizationId,
(dbo.fnGetPersonnelbyWorkPlaceId
(
    (
         SELECT  de.ExecutorWorkplaceId
         FROM dbo.DOCS_EXECUTOR de
         WHERE de.ExecutorDocId = d.DocId
               AND de.DirectionTypeId=4
     ), 106
)) AS CreaterPersonnelName,
e.ExecutorOrganizationId

from VW_DOC_INFO as d
join dbo.DOCS_DIRECTIONS dr on d.DocId=dr.DirectionDocId
join dbo.DOCS_EXECUTOR e on dr.DirectionId=e.ExecutorDirectionId 
join dbo.DOC_DOCUMENTSTATUS ds on  ds.DocumentstatusId=d.DocDocumentstatusId
join dbo.DOCS_ADDRESSINFO af on af.AdrDocId=d.DocId 
left join dbo.DOC_FORM df on df.FormId=d.DocFormId
left join dbo.DOC_RECEIVED_FORM form on form.ReceivedFormId=d.DocReceivedFormId
WHERE 

d.DocDoctypeId=12
and ISNULL(dr.DirectionConfirmed,0)=1
and af.AdrTypeId=1 
--AND e.ExecutorOrganizationId=[dbo].[fnGetPersonnelDetailsbyWorkPlaceId]([dbo].[GetDocSignerWorkplace](d.DocId),3)

