using BLL.BaseAdapter;
using BLL.Models.Document;
using CustomHelpers;
using Newtonsoft.Json;
using Repository.Extensions;
using Repository.Infrastructure;
using ServiceLetters.Model.EntityModel;
using ServiceLetters.Model.ViewModel;
using Smdo.Api.ApiModels;
using Smdo.AzDoc.Models;
using Smdo.EmailModels;
using Smdo.Enums;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using XmlModels;

namespace Smdo.AzDoc.Adapters
{
    public class DocumentAdapter : AdapterBase
    {
        public DocumentAdapter(IUnitOfWork unitOfWork) : base(unitOfWork) { }

        public IEnumerable<GridViewDoc> GetDocs(DocReceived doc)
        {
            return UnitOfWork.ExecuteProcedure<GridViewDoc>("[smdo].[GetDocs]", Extension.Init()
                .Add("@isReceived", doc == DocReceived.Received)
                .Add("@docId", (int?)null));
        }


        public GridViewDoc GetCurrentDoc(int docId)
        {
            return UnitOfWork.ExecuteProcedure<GridViewDoc>("[smdo].[GetDocs]", Extension.Init()
                .Add("@docId", docId)).FirstOrDefault();
        }


        public void AddDtsStep(int docId, int stepId)
        {
            var parameters = Extension.Init()
                .Add("@DocId", docId)
                .Add("@StepId", stepId)
                .Add("@StepStatus", true);

            UnitOfWork.ExecuteNonQueryProcedure("[smdo].[AddDtsStep]", parameters);
        }

        public void AddDtsCheck(int docId, Checker checker)
        {
            var parameters = Extension.Init()
                .Add("@DocId", docId)
                .Add("@CheckName", checker.name)
                .Add("@CheckStatus", checker.status)
                .Add("@Indicator", checker.indicator == "+")
                .Add("@CheckDescription", checker.description);

            UnitOfWork.ExecuteNonQueryProcedure("[smdo].[AddDtsCheck]", parameters);
        }


        public void ChangeFile(string guid,string fileName)
        {
            var parameters = Extension.Init()
                .Add("@docGuid", guid)
                .Add("@fileName", fileName);

            UnitOfWork.ExecuteNonQueryProcedure("[smdo].[ChangeDocFile]", parameters);
        }

        public IEnumerable<Checker> GetChecks(int docId)
        {
            return UnitOfWork.ExecuteProcedure<Checker>("smdo.GetDtsChecks", Extension.Init().Add("@docId", docId));
        }

        public IEnumerable<DtsSteps> GetDtsSteps(int docId)
        {
            return UnitOfWork.ExecuteProcedure<DtsSteps>("smdo.GetDtsSteps", Extension.Init().Add("@docId", docId));
        }

        public IEnumerable<DvcSigner> GetDvcSubject(int docId)
        {
            return UnitOfWork.ExecuteProcedure<DvcSigner>("smdo.[GetDtsSubject]", Extension.Init().Add("@docId", docId));
        }

        public void SetDvcBase64(int docId, string dvcBase64)
        {
            var p = new SqlParameter("@dvcBase64", SqlDbType.NVarChar, int.MaxValue)
            {
                Value = dvcBase64,
                Direction = ParameterDirection.Input
            };

            var parameters = Extension.Init()
                .Add("@docId", docId);
            parameters.Add(p);


            UnitOfWork.ExecuteNonQueryProcedure("[smdo].[SetDvcBase64]", parameters);
        }

        public void SetSubject(int docId, DvcSigner signer)
        {
            var parameters = Extension.Init()
                .Add("@DocId", docId)
                .Add("@subject", signer.subject)
                .Add("@serialNum", signer.serialNumber)
                .Add("@ValidFrom", signer.validFrom)
                .Add("@ValidTo", signer.validTo);

            UnitOfWork.ExecuteNonQueryProcedure("[smdo].[AddDtsSubject]", parameters);
        }


        public void AddDvcSigner(int docId, DocumentSigner signer)
        {
            var parameters = Extension.Init()
                .Add("@DocId", docId)
                .Add("@subject", signer.subject)
                .Add("@serialNum", signer.serialNumber)
                .Add("@ValidFrom", signer.validFrom)
                .Add("@ValidTo", signer.validTo)
                .Add("@issuer",signer.issuer);

            UnitOfWork.ExecuteNonQueryProcedure("[smdo].[AddDvcSigners]", parameters);
        }

        public int SaveDocument(SmdoDocumentModel model)
        {
            var parameters = Extension.Init()
                .Add("@workPlaceId", model.DocCreatorWorkPlace)
                .Add("@docGuid", model.Guid)
                .Add("@filePath", model.FileName)
                .Add("@isReceived", !model.IsNew)
                .Add("@docDescription", model.Note)
                .Add("@outDocId", 0, ParameterDirection.Output);

            UnitOfWork.ExecuteNonQueryProcedure("[smdo].[CreateDoc]", parameters);

            return int.Parse(parameters.First(x => x.ParameterName == "@outDocId").Value.ToString());
        }


        public void CreateReceivedDoc()
        {
            var parameters = Extension.Init()
                .Add("@docGuid", Guid.NewGuid().ToString());

            UnitOfWork.ExecuteNonQueryProcedure("[smdo].[CreateReceivedDoc]", parameters);
        }

        public int XmlLog(string xml, bool status, int id)
        {
            var parameters = Extension.Init()
                .Add("@id", id)
                .Add("@xmlData", xml)
                .Add("@xmlStatus", false)
                .Add("@xmlOut", 0, ParameterDirection.Output);

            UnitOfWork.ExecuteNonQueryProcedure("[smdo].[SetXmlStatus]", parameters);

            return int.Parse(parameters.First(x => x.ParameterName == "@xmlOut").Value.ToString());
        }

        public string IsDocExist(string guid)
        {
            return UnitOfWork.ExecuteProcedure<string>("[smdo].[IsDocExist]", Extension.Init().Add("@guid", guid)).First();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="envelope"></param>
        public int CreateReceivedDoc(Envelope<Document> envelope, AttachFile attachFile)
        {
            var parameters = Extension.Init()
                .Add("@docGuid", envelope.MsgId)
                .Add("@docDescription", string.Empty)
                .Add("@relatedDoc", envelope.Body.BodyData.DocParent?.Idnumber.ToInt() ?? 0)//envelope.Body.BodyData.DocParent.Idnumber
                .Add("@sign", envelope.Body.BodyData.DocTransfer.Signature.Last()?.Text)
                .Add("@attachName", envelope.Body.BodyData.DocTransfer.Name)
                .Add("@docId", 0, ParameterDirection.Output);

            UnitOfWork.ExecuteNonQueryProcedure("[smdo].[CreateReceivedDocument]", parameters);

            return parameters.First(x => x.ParameterName == "@docId").Value.ToInt();
        }


        public void ChangeDocStatus(int docId, int status)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@status", status);

            UnitOfWork.ExecuteNonQueryProcedure("[smdo].[ChangeDocStatus]", parameters);
        }

        public void AddDocSubject(int docId,string subject)
        {
            var parameters = Extension.Init()
                .Add("@docId", docId)
                .Add("@subject", subject);

            UnitOfWork.ExecuteNonQueryProcedure("[smdo].[AddDocSubject]", parameters);
        }


        public DocumentGridViewModel GetDocumentGridModel(string docIds)
        {
            var parameters = Extension.Init()
                .Add("@docIds", docIds);

            var data = UnitOfWork.ExecuteProcedure<DocumentGridModel>("[smdo].[GetDocs]", parameters).ToList();

            return new DocumentGridViewModel
            {
                TotalCount = 0,
                Items = data
            };
        }


        public List<ChooseModel> GetChooseModel(int docType, int workPlaceId)
        {
            var parameters = Extension.Init()
                        .Add("@docType", docType)
                        .Add("@workPlaceId", workPlaceId);
            return UnitOfWork.ExecuteProcedure<ChooseModel>("[outgoingdoc].[spAddNewDocumentLoad]", parameters).ToList();
        }



        public ElectronicDocumentViewModel ElectronicDocument(int docId, int docType, int workPlaceId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@docType", docType)
                    .Add("@workPlaceId", workPlaceId);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[serviceletters].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<ElectronicDocumentViewModel>>(jsonData).First();
            }
            catch (Exception exception)
            {
                throw;
            }
        }

        public FileInfoModel ElectronicDocument(int docInfoId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docInfoId", docInfoId);

                string jsonData = UnitOfWork.ExecuteProcedure<string>("[serviceletters].[spGetElectronicDocument]", parameters).Aggregate((i, j) => i + j);
                return JsonConvert.DeserializeObject<IEnumerable<FileInfoModel>>(jsonData).First();
            }
            catch
            {
                throw;
            }
        }
    }
}