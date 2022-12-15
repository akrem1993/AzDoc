using InsDoc.Adapters;
using InsDoc.Common.Enums;
using InsDoc.Model.EntityModel;
using System;
using System.Collections.Generic;
using System.Linq;
using BLL.Models.Document;

namespace InsDoc.Model.ViewModel
{
    public class DocumentViewModel
    {
        /// BasicInformation - Əsas məlumatlar
        /// <summary>
        /// TypeOfDocument - Sənədin növü
        /// SubtypeOfDocument - Sənədin alt növü
        /// SignatoryPerson - İmza edən şəxs
        /// ConfirmingPerson - Təsdiq edən şəxs
        /// RelatedDocument - Əlaqəli sənəd
        /// ShortContent - Qısa məzmun
        /// </summary>

        public ChooseModel TypeOfDocument { get; set; }
        public ChooseModel SubtypeOfDocument { get; set; }
        public ChooseModel SignatoryPerson { get; set; }
        public ChooseModel ConfirmingPerson { get; set; }
        public string ShortContent { get; set; }

        ///DocumentInformation - Sənəd məlumatları
        /// <summary>
        /// Task - Tapşırıq
        /// TypeOfAssignment - Tapşırıq növü
        /// TaskCycle - Tapşırıq dövrü
        /// ExecutionPeriod - İcra dövrü
        /// PeriodOfPerformance - İcra müddəti
        /// OriginalExecutionDate - İlkin icra tarixi
        /// WhomAddressed - Kimə ünvanlanıb
        /// </summary>

        public decimal? TaskNo { get; set; }
        public string Task { get; set; }
        public ChooseModel TypeOfAssignment { get; set; }
        public ChooseModel TaskCycle { get; set; }
        public int ExecutionPeriod { get; set; }
        public int PeriodOfPerformance { get; set; }
        public DateTime OriginalExecutionDate { get; set; }
        public ChooseModel WhomAddress { get; set; }

        public IEnumerable<ChooseModel> TypeOfDocuments { get; set; }
        public IEnumerable<ChooseModel> SubtypeOfDocuments { get; set; }
        public IEnumerable<ChooseModel> SignatoryPersons { get; set; }
        public IEnumerable<ChooseModel> ConfirmingPersons { get; set; }
        public IEnumerable<ChooseModel> TypeOfAssignments { get; set; }
        public IEnumerable<ChooseModel> TaskCycles { get; set; }
        public IEnumerable<ChooseModel> RedirectPersons { get; set; }
        
        public DocumentModel DocumentModel { get; set; }
        public IEnumerable<TaskModel> TaskModels { get; set; }
        public IEnumerable<RelatedDocModel> RelatedDocModels { get; set; }
        public ChiefModel ChiefModel { get; set; }

        /// <summary>
        ///
        /// </summary>
        /// <param name="adapter"></param>
        /// <param name="docType"></param>
        /// <param name="workPlaceId"></param>
        public DocumentViewModel(DocumentAdapter adapter, int docType, int workPlaceId)
        {
            var chooseList = adapter.GetChooseModel(docType, workPlaceId);
            TypeOfDocuments = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.TypeOfDocument);
            SubtypeOfDocuments = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.SubtypeOfDocument);
            SignatoryPersons = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.SignatoryPerson);
            ConfirmingPersons = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.ConfirmingPerson);
            TypeOfAssignments = chooseList.Where(l => l.FormTypeId == (int)DocumentInformation.TypeOfAssignment);
            TaskCycles = chooseList.Where(l => l.FormTypeId == (int)DocumentInformation.TaskCycle);
            RedirectPersons = chooseList.Where(l => l.FormTypeId == (int)DocumentInformation.RedirectPersons);
            DocumentModel = new DocumentModel();
            ChiefModel = adapter.GetChiefModel(workPlaceId);
            TaskModels = new List<TaskModel>();
            RelatedDocModels = new List<RelatedDocModel>();
        }

        public DocumentViewModel(DocumentAdapter adapter, int docType, int workPlaceId, int docId)
        {
            var chooseList = adapter.GetChooseModel(docType, workPlaceId);
            TypeOfDocuments = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.TypeOfDocument);
            SubtypeOfDocuments = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.SubtypeOfDocument);
            SignatoryPersons = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.SignatoryPerson);
            ConfirmingPersons = chooseList.Where(l => l.FormTypeId == (int)BasicInformation.ConfirmingPerson);
            TypeOfAssignments = chooseList.Where(l => l.FormTypeId == (int)DocumentInformation.TypeOfAssignment);
            TaskCycles = chooseList.Where(l => l.FormTypeId == (int)DocumentInformation.TaskCycle);
            RedirectPersons = chooseList.Where(l => l.FormTypeId == (int)DocumentInformation.RedirectPersons);
            DocumentModel = adapter.GetDocumentModel(docId);
            TaskModels = adapter.GetTaskModel(docId, docType);
            RelatedDocModels = adapter.GetRelatedModel(docId, docType);

        }

        public DocumentViewModel()
        {
        }
    }
}