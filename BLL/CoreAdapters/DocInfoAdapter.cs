using BLL.BaseAdapter;
using BLL.Models.DocInfo;
using Repository.Extensions;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;

namespace BLL.CoreAdapters
{
    public class DocInfoAdapter : AdapterBase
    {
        public DocInfoAdapter(IUnitOfWork unitOfWork) : base(unitOfWork){  }

        public IEnumerable<DocFile> GetDocFiles(int docId)
        {
            var docFiles = UnitOfWork.GetDataFromSP<DocFile>("[docinfo].[DocFiles]", new { docId });

            return docFiles;
        }

        public IEnumerable<RelatedDoc> GetRelatedDocs(int docId)
        {
            var relatedDocs = UnitOfWork.GetDataFromSP<RelatedDoc>("[docinfo].[RelatedDocs]", new { docId });

            return relatedDocs;
        }

        public IEnumerable<AnswerDoc> GetAnswerDocs(int docId)
        {
            var answerDocs = UnitOfWork.GetDataFromSP<AnswerDoc>("[docinfo].[AnswerDocs]", new { docId });

            return answerDocs;
        }

        public IEnumerable<EnteredDoc> GetEnteredDocs(int docId)
        {
            var enteredDocs = UnitOfWork.GetDataFromSP<EnteredDoc>("[docinfo].[EnteredDocs]", new { docId });

            return enteredDocs;
        }

        public IEnumerable<DocHistory> GetDocHistory(int docId)
        {
            var docHistories = UnitOfWork.GetDataFromSP<DocHistory>("[docinfo].[DocHistory]", new { docId });

            return docHistories;
        }
        public IEnumerable<DeletedFromViza> GetDeletedVizaPerson(int docId)
        {
            var deletedFromVizas = UnitOfWork.GetDataFromSP<DeletedFromViza>("[docinfo].[DeletedFromViza]", new { docId });

            return deletedFromVizas;
        }
        public IEnumerable<DocTask> GetDocTasks(int docId)
        {
            var docTasks = UnitOfWork.GetDataFromSP<DocTask>("[docinfo].[GetDocTasks]", new { docId });

            return docTasks;
        }

        public T GetDocView<T>(int docId) where T : BaseDocInfo
        {
            var model = UnitOfWork.GetDataFromSP<T>("[docinfo].[GetDocView]", new { docId }).First();

            return model;
        }



        public IEnumerable<DocPlan> GetDocPlan(int docId)
        {
            var docPlan = UnitOfWork.GetDataFromQuery<DocPlan>("select * from dbo.DocVizaPlanView where DocId=@docId", new { docId });

            return docPlan;
        }



        public void SetAllBaseInfo(BaseDocInfo baseDocInfo, int docId)
        {
            var actions = new Action[]
            {
                () => baseDocInfo.DocHistory = GetDocHistory(docId),
                () => baseDocInfo.DeletedFromViza = GetDeletedVizaPerson(docId),
                () => baseDocInfo.EnteredDocs = GetEnteredDocs(docId),
                () => baseDocInfo.DocFiles = GetDocFiles(docId),
                () => baseDocInfo.AnswerDocs = GetAnswerDocs(docId),
                () => baseDocInfo.RelatedDocs = GetRelatedDocs(docId),

                () =>
                {
                    if (baseDocInfo is ITaskModel t && !t.IsTask)
                    {
                        baseDocInfo.DocTasks = GetDocTasks(docId);
                    }
                }
            };

            UnitOfWork.ExecuteAllCommandTasks(actions);
        }

    }
}
