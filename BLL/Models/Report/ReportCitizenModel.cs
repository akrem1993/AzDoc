using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class ReportCitizenModel
    {

        public int DocId { get; set; }   //Sənədin id-si

        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime DocEnterDate { get; set; }  //Sənədin sistemdə qeydiyyat tarixi
        public string DocEnterno { get; set; }  //Sənədin sistemdə qeydiyyat nömrəsi
        public string DocumentStatusName { get; set; } // sənədin statusu
        public string DocResultName { get; set; } //
        public string EntryFromWhere { get; set; } //Sənəd hardan daxil olub qurumun adı
        public string EntryFromWho { get; set; } //Sənəd kimdən daxil olub
        public string EntryFromWhoCitizenName { get; set; } //Sənəd hardan daxil olub vetendashin adı soyadi ata adi
        public string SocialName { get; set; }//Sənəd hardan daxil olub vetendashin sosial statusu
        public string FormName { get; set; } //Müraciətin daxil olma forması
        public string DocDescription { get; set; } //Sənədin qısa nəzmunu 

        //public string NotExecutedExecutorsDepartment { get; set; }  //Sənədi icra etməyən struktur bölmə
        //public string NotExecutedExecutorsName { get; set; }  //Sənədi icra etməyən strukutru bölmədəki icraçının adı
        //public string ReplyDocIds { get; set; }     //Cavab sənədlərinin id-si
        //public string ReplyDocNumbers { get; set; }  //Cavab sənədlərinin nömrəsi
        //public string ReplyDocStatus { get; set; }

        //[NotMapped]
        //public Dictionary<string, string> ReplyDocNumbersForView { get; set; }     // Cavab sənədlərinin tokenlə link şəkildə göstərilməsi
        //public int? ReplyDocId { get; set; }

        //public string ReplyDocNumber { get; set; }

        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? PlannedDate { get; set; }  //Sənədin icra olunmalı olduğu tarix
        //public int? RemainingDay { get; set; }  //Sənədin icrasına qalan müddət
        [NotMapped]
        public string TokenForDocId { get; set; }

        //public byte? DocControlStatusId { get; set; }
        //public byte? DocUndercontrolStatusId { get; set; }

        public ReportCitizenModel()
        {

        }
        //public ReportInExecutionDocsModel()
        //{
        //    ReplyDocNumbersForView = new Dictionary<string, string>();
        //}
    }
}
