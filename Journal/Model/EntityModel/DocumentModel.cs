using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Journal.Model.EntityModel
{
    public class DocumentModel /*: IEnumerable<DocumentModel>*/
    {
       
        [StringLength(10)]
        public string DocEnterDate{ get; set; }

        [StringLength(30)]
        public string DocEnterNo { get; set; }

        [StringLength(100)]
        public string WhomAdressed { get; set; }

        public string ExecutorName { get; set; }

        public string SenderTo { get; set; }

        [StringLength(300)]
        public string DocDescription { get; set; }

        public string Icra_haqqda_qeyd { get; set; }
             
        public string BlankNumber { get; set; }
        
        public string Note { get; set; }

        public int DocId { get; set; }
        public string UserName { get; set; }
        public string CreateDate { get; set; }
        public string DeleteNote { get; set; }

        public string  Type { get; set; }
        public string TasksNote { get; set; }
        
        public string TasksRelatedDocsNote { get; set; }
        public string RelatedNote { get; set; }
        public string Signer { get; set; }

        //public IEnumerator<DocumentModel> GetEnumerator()
        //{
        //    throw new System.NotImplementedException();
        //}

        //IEnumerator IEnumerable.GetEnumerator()
        //{
        //    throw new System.NotImplementedException();
        //}
    }


    public class DocumentModelDto /*: IEnumerable<DocumentModel>*/
    {
        public string DocEnterInfo { get; set; }
        public string Whom { get; set; }
        public string DocDescription { get; set; }

        public string Icra_haqqda_qeyd { get; set; }

        public string BlankNumber { get; set; }

        public string NoteInfo { get; set; }

        public int DocId { get; set; }

        public string EditNote { get; set; }
    }

}