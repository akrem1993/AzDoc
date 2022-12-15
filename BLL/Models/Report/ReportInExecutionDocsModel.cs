using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class ReportInExecutionDocsModel
    {
        // Sıra sayı viewda yaranır
        public int DocId { get; set; }   //Sənədin id-si
        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime DocEnterDate { get; set; }  //Sənədin sistemdə qeydiyyat tarixi
        public string DocEnterno { get; set; }  //Sənədin sistemdə qeydiyyat nömrəsi
        public string EntryFromWhere { get; set; } //Sənəd hardan daxil olub qurumun adı
        public string EntryFromWhoCitizenName { get; set; } //Senedi daxil eden sexs
        public string EntryFromWho { get; set; } //Senedi nezarete goturen sexs
        public string SocialName { get; set; }//Sənəd hardan daxil olub vetendashin sosial statusu
        public string DocFormName { get; set; } //Müraciətin daxil olma forması
        public int? ExecutionDays { get; set; }// icra muddeti teqvim gunu

        public string ApplyTypeName { get; set; }
        public string TopicTypeName { get; set; }
        public string TopicName { get; set; }

        public string DocDescription { get; set; } //Sənədin qısa nəzmunu 
        public string NotExecutedExecutorsDepartment { get; set; }  //Sənədi icra etməyən struktur bölmə
        public string NotExecutedExecutorsName { get; set; }  //Sənədi icra etməyən strukutru bölmədəki icraçının adı
        public string LastExecutorName { get; set; } //Sənədin icraçısı (şöbənin əməkdaşı)

        public string ReplyDocIds { get; set; }     //Cavab sənədlərinin id-si
        public string ReplyDocNumbers { get; set; }  //Cavab sənədlərinin nömrəsi
        public string RelationDocIds { get; set; }     //elaqeli sənədlərinin id-si
        public string RelationDocNumbers { get; set; }  //elaqeli sənədlərinin nömrəsi
        
        public string ReplyDocStatus { get; set; }

        [NotMapped]
        public Dictionary<string, string> ReplyDocNumbersForView { get; set; }     // Cavab sənədlərinin tokenlə link şəkildə göstərilməsi
        //public int? ReplyDocId { get; set; }
        [NotMapped]
        public Dictionary<string, string> RelationDocNumbersForView { get; set; }     // elaqeli sənədlərin tokenlə link şəkildə göstərilməsi
        //public string ReplyDocNumber { get; set; }

        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? PlannedDate { get; set; }  //Sənədin icra olunmalı olduğu tarix
        public string DirectionChangeNote { get; set; } // Uzadılma barədə qeyd

        public int? RemainingDay { get; set; }  //Sənədin icrasına qalan müddət
        [NotMapped]
        public string TokenForDocId { get; set; }

        public byte? DocControlStatusId { get; set; }
        public byte? DocUndercontrolStatusId { get; set; }
        public string DocUnderControlStatusValue { get; set; }

        public string ComplainedOfDocStructure { get; set; } //Shikayet olunan qurum
        public string ComplainedOfDocSubStructure { get; set; } //Shikayet olunan alt qurum


        //yeni elave edilmis properties
        public string DocumentStatusName { get; set; }  //senedin statusu
        public string VillageName { get; set; } //kend
        public string RegionName { get; set; } //sheher
        public string DocDocno { get; set; }   //Sənədin nömrəsi
        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? DocDocDate { get; set; }   //Senedin tarixi
        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? ReplyDocDate { get; set; } //Cavab senedin tarixi
        public string DocResultName { get; set; } //Müraciətlərə baxılmasının vəziyyəti


        public ReportInExecutionDocsModel()
        {
            ReplyDocNumbersForView = new Dictionary<string, string>();
            RelationDocNumbersForView = new Dictionary<string, string>();
        }

    }
}
