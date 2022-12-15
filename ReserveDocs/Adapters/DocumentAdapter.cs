using BLL.Models.Direction.Common;
using BLL.Models.Document;
using Repository.Extensions;
using Repository.Infrastructure;
using ReserveDocs.Common.Enum;
using ReserveDocs.Model.EntityModel;
using ReserveDocs.Model.FormModel;
using ReserveDocs.Model.ViewModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReserveDocs.Adapters
{
    public static class DocumentAdapter
    {
        public static GridViewModel<DocumentGridModel> GetDocumentGridModel(this IUnitOfWork unitOfWork, int workPlaceId, int? periodId, int docType, int? pageIndex, int pageSize, out int totalCount)
        {
            try
            {
                var parameters = Extension.Init()
                 .Add("@workPlaceId", workPlaceId)
                 .Add("@periodId", periodId)
                 .Add("@pageIndex", pageIndex)
                 .Add("@pageSize", pageSize)
                 .Add("@docTypeId", docType)
                 .Add("@totalCount", 0, ParameterDirection.InputOutput);

                var data = unitOfWork.ExecuteProcedure<DocumentGridModel>("[reserve].[GetDocsReserved]", parameters).ToList();
                totalCount = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@totalCount").Value);
                return new GridViewModel<DocumentGridModel>
                {
                    TotalCount = totalCount,
                    Items = data
                };
            }
            catch
            {
                throw;
            }
        }      

        public static DocumentViewModel GetOutgoingReserveDocViewModel(this IUnitOfWork unitOfWork, int docType, int workPlaceId)
        {
            var parameters = Extension.Init()
                      .Add("@docType", docType)
                      .Add("@workPlaceId", workPlaceId);

            var chooseList = unitOfWork.ExecuteProcedure<ChooseModel>("[reserve].[AddNewReserveDoc]", parameters);
            var model = new DocumentViewModel();
            model.SignatoryPersons = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.SignatoryPerson);
            model.Departments = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.Department);
            model.DocTypes = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.TypeOfDocument);
            model.DocForms = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.FormOfDocument);

            return model;
        }
        public static int SaveReserveDocument(this IUnitOfWork unitOfWork, int workPlaceId, int docType, DocumentFormModel model, int? docId, out int result)
        {
            try
            {
                var parameters = Extension.Init()

                        .Add("@operationType", (int)DocSaveStatus.Save)
                        .Add("@workPlaceId", workPlaceId)
                        .Add("@departmentId", model.Department.Id)
                        .Add("@docTypeId", docType)
                        .Add("@docReserveTypeId", model.DocType.Id)
                        .Add("@formTypeId", model.DocForm.Id)
                        .Add("@docDeleted", (int)DocSaveStatus.Save)
                        .Add("@documentStatusId", (int)DocumentStatus.Draft)
                        .Add("@signatoryPersonId", model.SignatoryPerson.Id)
                        .Add("@docEnterDate", model.DocumentModel.DocEnterDate)
                        .Add("@shortContent", model.DocumentModel.ShortContent)
                        .Add("@docId", docId)
                        .Add("@result", 0, direction: ParameterDirection.InputOutput);
                unitOfWork.ExecuteNonQueryProcedure("[reserve].[CreateReserveDocument]", parameters);

                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public static  List<ReserveNumbers> GetReserveNumbers(this IUnitOfWork unitOfWork,int workplaceId,int docId)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@workplaceId", workplaceId)
                    .Add("@docId", docId);
                return unitOfWork.ExecuteProcedure<ReserveNumbers>("[reserve].[GetReservedNumbers]",parameters).ToList();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
        public  static int  SetReserveNumbers(this IUnitOfWork unitOfWork, ReserveNumbers model,int docId, out int result)
        {
            try
            {
                var parameters = Extension.Init()
                    .Add("@docId", docId)
                    .Add("@eserveNumber", model.ReserveNumber)
                    .Add("@reserveId", model.ReservedId)
                    .Add("@result", 0, direction: ParameterDirection.InputOutput);
               unitOfWork.ExecuteProcedure<ReserveNumbers>("[reserve].[SetReservedNumbers]", parameters);
               
                return result = Convert.ToInt32(parameters.FirstOrDefault(p => p.ParameterName == "@result")?.Value);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
    }
}
