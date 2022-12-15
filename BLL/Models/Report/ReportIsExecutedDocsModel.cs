using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Models.Report
{
    public class ReportIsExecutedDocsModel
    {
        public int DocId { get; set; }   //Sənədin id-si
        public string DocEnterno { get; set; }  //Sənədin sistemdə qeydiyyat nömrəsi

        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? DocEnterDate { get; set; }  //Sənədin sistemdə qeydiyyat tarixi
        public string DocDocno { get; set; }   //Sənədin özünün nömrəsi
        public DateTime? DocDocDate { get; set; }   //Senedin öz tarixi
        public string DocDescription { get; set; } // Qisa mezmun
        public string EntryFromWhere { get; set; } //Sənəd hardan daxil olub qurumun adı
        public string EntryFromWho { get; set; }  //Senedin qurumdaki hansi shexsenden daxil oldugu
        public string SocialName { get; set; }//Sənəd hardan daxil olub vetendashin sosial statusu
        public string DocFormName { get; set; } //Müraciətin daxil olma forması
        public string ApplyTypeName { get; set; } //Müraciətin daxil olma növü
        public string ExecutorDepartment { get; set; }  //Sənədi icraci  struktur bölmə
        public string ReplyDocIds { get; set; }
        public int? ExecutionDays { get; set; }// icra muddeti teqvim gunu
        public string RelationDocsJson { get; set; }
        public RelationDocs Relationdocs { get; set; } // elaqeli senedler//Cavab sənədlərinin id-si
        public string ReplyDocNumbers { get; set; }  //Cavab sənədlərinin nömrəsi
        public string VillageName { get; set; } //kend
        public string RegionName { get; set; } //sheher

        [NotMapped]
        public Dictionary<string, string> ReplyDocNumbersForView { get; set; }     // Cavab sənədlərinin tokenlə link şəkildə göstərilməsi
        [NotMapped]
        public Dictionary<string, string> RelationDocNumbersForView { get; set; }     // elaqeli sənədlərinin tokenlə link şəkildə göstərilməsi
        public DateTime? ReplyDocDate { get; set; }
        public int? LatelyExecutedDays { get; set; }

        public byte? DocControlStatusId { get; set; }
        public byte? DocUndercontrolStatusId { get; set; }
        public string DocUnderControlStatusValue { get; set; }

        //yeni elave edilmis sutunlar - Leyla
        public string DocumentStatusName { get; set; }  //senedin statusu
        public string NotExecutedExecutorsName { get; set; } //senedin icracisi

        public string LastExecutorName { get; set; } //Sənədin icraçısı (şöbənin əməkdaşı)
        public string ReplyDocStatus { get; set; } //cavab senedin statusu
        [Column(TypeName = "date")]
        [DisplayFormat(DataFormatString = "d")]
        public DateTime? PlannedDate { get; set; }  //Sənədin icra olunmalı olduğu tarix
        public string DirectionChangeNote { get; set; } // Uzadılma barədə qeyd

        public string EntryFromWhoCitizenName { get; set; }  //Sənəd hardan daxil olub vetendashin adı soyadi ata adi
        public string TopicTypeName { get; set; } // Movzu 
        public string TopicName { get; set; } //Alt movzu
        public string DocResultName { get; set; } //Müraciətlərə baxılmasının vəziyyəti
        public string ComplainedOfDocStructure { get; set; } //Shikayet olunan qurum
        public string ComplainedOfDocSubStructure { get; set; } //Shikayet olunan alt qurum
        public string RelationDocNumbers { get; set; } // Elaqeli senedler


        [NotMapped]
        public string TokenForDocId { get; set; }
        public ReportIsExecutedDocsModel()
        {
            ReplyDocNumbersForView = new Dictionary<string, string>();
            RelationDocNumbersForView = new Dictionary<string, string>();
        }

    }
}
