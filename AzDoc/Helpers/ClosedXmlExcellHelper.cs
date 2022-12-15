﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace AzDoc.Helpers
{
    internal class ClosedXmlExcellHelper
    {
        #region inExecutionDocsForExcel
        internal string GetFieldNameForAllDocTypesInExecutionDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "İcra müddəti":
                    return "PlannedDate";
                case "İcra müddəti(təqvim günü)":
                    return "ExecutionDays";
                case "Uzadılma barədə qeyd":
                    return "DirectionChangeNote";
                case "İcraya qalan müddət":
                    return "RemainingDay";

                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";

                case "Haradan daxil olub":
                    return "EntryFromWhere";
                case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)":
                    return "EntryFromWhoCitizenName";
                case "Nəzarətə götürən şəxs":
                    return "EntryFromWho";


                case "Vətəndaşın sosial statusu":
                    return "SocialName";
                case "Müraciətin forması":
                    return "DocFormName";
                case "Müraciətin növü":
                    return "ApplyTypeName";


                case "Mövzu":
                    return "TopicTypeName";
                case "Alt mövzu":
                    return "TopicName";

                case "Şikayət olunan qurum":
                    return "ComplainedOfDocStructure";
                case "Şikayət olunan alt qurum":
                    return "ComplainedOfDocSubStructure";

                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "İcraçı struktur bölmə":
                    return "NotExecutedExecutorsDepartment";
                case "Sənədin icraçısı":
                    return "NotExecutedExecutorsName";
                case "Sənədin icraçısı (şöbənin əməkdaşı)":
                    return "LastExecutorName";

             


                case "Cavab sənədinin nömrəsi":
                    return "ReplyDocNumbers";
                case "Cavab sənədinin tarixi":
                    return "ReplyDocDate";
                case "Cavab sənədinin statusu":
                    return "ReplyDocStatus";

                case "Əlaqəli sənədlər":
                    return "RelationDocNumbers";
                case "Müraciətlərə baxılmasının vəziyyəti":
                    return "DocResultName";
                case "Rayon/Şəhər":
                    return "RegionName";
                case "Kənd":
                    return "VillageName";
                case "Nəzarət":
                    return "DocUnderControlStatusValue";
                default:
                    break;
            }
            return "";
        }

        internal string GetFieldNameForCitizenRequestInExecutionDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "İcra müddəti":
                    return "PlannedDate";
                case "İcra müddəti(təqvim günü)":
                    return "ExecutionDays";
                case "Uzadılma barədə qeyd":
                    return "DirectionChangeNote";
                case "İcraya qalan müddət":
                    return "RemainingDay";

                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";

                case "Haradan daxil olub":
                    return "EntryFromWhere";               
                case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)":
                    return "EntryFromWhoCitizenName";
                case "Nəzarətə götürən şəxs":
                    return "EntryFromWho";


                case "Vətəndaşın sosial statusu":
                    return "SocialName";
                case "Müraciətin forması":
                    return "DocFormName";
                case "Müraciətin növü":
                    return "ApplyTypeName";


                case "Mövzu":
                    return "TopicTypeName";
                case "Alt mövzu":
                    return "TopicName";

                case "Şikayət olunan qurum":
                    return "ComplainedOfDocStructure";
                case "Şikayət olunan alt qurum":
                    return "ComplainedOfDocSubStructure";

                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "İcraçı struktur bölmə":
                    return "NotExecutedExecutorsDepartment";
                case "Sənədin icraçısı":
                    return "NotExecutedExecutorsName";
                case "Sənədin icraçısı (şöbənin əməkdaşı)":
                    return "LastExecutorName";

          


                case "Cavab sənədinin nömrəsi":
                    return "ReplyDocNumbers";
                case "Cavab sənədinin tarixi":
                    return "ReplyDocDate";
                case "Cavab sənədinin statusu":
                    return "ReplyDocStatus";

                case "Əlaqəli sənədlər":
                    return "RelationDocNumbers";
                case "Müraciətlərə baxılmasının vəziyyəti":
                    return "DocResultName";
                case "Rayon/Şəhər":
                    return "RegionName";
                case "Kənd":
                    return "VillageName";
                case "Nəzarət":
                    return "DocUnderControlStatusValue";
                default:
                    break;
            }
            return "";
        }

        internal string GetFieldNameForOrganizationInExecutionDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "İcra müddəti":
                    return "PlannedDate";
                case "İcra müddəti(təqvim günü)":
                    return "ExecutionDays";
                case "Uzadılma barədə qeyd":
                    return "DirectionChangeNote";
                case "İcraya qalan müddət":
                    return "RemainingDay";
                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";
                case "Haradan daxil olub":
                    return "EntryFromWhere";
                case "Sənədin növü":
                    return "DocFormName";
                case "Mövzu":
                    return "TopicTypeName";
                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "İcraçı struktur bölmə":
                    return "NotExecutedExecutorsDepartment";
                case "Sənədin icraçısı":
                    return "NotExecutedExecutorsName";
                case "Sənədin icraçısı (şöbənin əməkdaşı)":
                    return "LastExecutorName";

                case "Cavab sənədinin nömrəsi":
                    return "ReplyDocNumbers";
                case "Cavab sənədinin tarixi":
                    return "ReplyDocDate";
                case "Cavab sənədinin statusu":
                    return "ReplyDocStatus";
                case "Əlaqəli sənədlər":
                    return "RelationDocNumbers";
                case "Nəzarət":
                    return "DocUnderControlStatusValue";
                default:
                    break;
            }
            return "";
        }

        internal string GetFieldNameForEmployeeAppealsInExecutionDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "İcra müddəti":
                    return "PlannedDate";
                case "İcra müddəti(təqvim günü)":
                    return "ExecutionDays";
                case "Uzadılma barədə qeyd":
                    return "DirectionChangeNote";

                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";
                case "Haradan daxil olub":
                    return "EntryFromWhere";
                case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)":
                    return "EntryFromWhoCitizenName";
                case "Vətəndaşın sosial statusu":
                    return "SocialName";
                case "Müraciətin forması":
                    return "DocFormName";
                case "Müraciətin növü":
                    return "ApplyTypeName";
                case "Mövzu":
                    return "TopicTypeName";
                case "Alt mövzu":
                    return "TopicName";
                case "Şikayət olunan qurum":
                    return "ComplainedOfDocStructure";
                case "Şikayət olunan alt qurum":
                    return "ComplainedOfDocSubStructure";
                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "İcraçı struktur bölmə":
                    return "NotExecutedExecutorsDepartment";
            
                case "Cavab sənədinin nömrəsi":
                    return "ReplyDocNumbers";
                case "Cavab sənədinin tarixi":
                    return "ReplyDocDate";
                case "Müraciətlərə baxılmasının vəziyyəti":
                    return "DocResultName";
                case "Rayon/Şəhər":
                    return "RegionName";
                case "Kənd":
                    return "VillageName";
                default:
                    break;
            }
            return "";
        }

        #endregion

        #region IsExecutedDocsForExcel
        //Vetendas
        internal string GetFieldNameForCitizenRequestsReportIsExecutedDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "İcra müddəti":
                    return "PlannedDate";
                case "İcra müddəti(təqvim günü)":
                    return "ExecutionDays";
                case "Uzadılma barədə qeyd":
                    return "DirectionChangeNote";
                case "Neçə gün gecikmə ilə icra olunub":
                    return "LatelyExecutedDays";

                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";
                case "Haradan daxil olub":
                    return "EntryFromWhere";
                case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)":
                    return "EntryFromWhoCitizenName";
                case "Nəzarətə götürən şəxs":
                    return "EntryFromWho";
                case "Vətəndaşın sosial statusu":
                    return "SocialName";
                case "Müraciətin forması":
                    return "DocFormName";
                case "Müraciətin növü":
                    return "ApplyTypeName";
                case "Mövzu":
                    return "TopicTypeName";
                case "Alt mövzu":
                    return "TopicName";
                case "Şikayət olunan qurum":
                    return "ComplainedOfDocStructure";
                case "Şikayət olunan alt qurum":
                    return "ComplainedOfDocSubStructure";
                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "İcraçı struktur bölmə":
                    return "ExecutorDepartment";
                case "Sənədin icraçısı":
                    return "NotExecutedExecutorsName";
                case "Sənədin icraçısı (şöbənin əməkdaşı)":
                    return "LastExecutorName";
              
                case "Cavab sənədinin nömrəsi":
                    return "ReplyDocNumbers";
                case "Cavab sənədinin tarixi":
                    return "ReplyDocDate";
                case "Cavab sənədinin statusu":
                    return "ReplyDocStatus";
                case "Əlaqəli sənədlər":
                    return "RelationDocNumbers";
                case "Müraciətlərə baxılmasının vəziyyəti":
                    return "DocResultName";
                case "Rayon/Şəhər":
                    return "RegionName";
                case "Kənd":
                    return "VillageName";
                case "Nəzarət":
                    return "DocUnderControlStatusValue";
                default:
                    break;
            }
            return "";
        }
        //Teskilat
        internal string GetFieldNameForOrganizationReportIsExecutedDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "İcra müddəti":
                    return "PlannedDate";
                case "İcra müddəti(təqvim günü)":
                    return "ExecutionDays";
                case "Uzadılma barədə qeyd":
                    return "DirectionChangeNote";
                case "Neçə gün gecikmə ilə icra olunub":
                    return "LatelyExecutedDays";

                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";
                case "Haradan daxil olub":
                    return "EntryFromWhere";
                case "Sənədin növü":
                    return "DocFormName";
                case "Mövzu":
                    return "TopicTypeName";              
                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "İcraçı struktur bölmə":
                    return "ExecutorDepartment";
                case "Sənədin icraçısı":
                    return "NotExecutedExecutorsName";
                case "Sənədin icraçısı (şöbənin əməkdaşı)":
                    return "LastExecutorName";
             
                case "Cavab sənədinin nömrəsi":
                    return "ReplyDocNumbers";
                case "Cavab sənədinin tarixi":
                    return "ReplyDocDate";
                case "Cavab sənədinin statusu":
                    return "ReplyDocStatus";               
                case "Əlaqəli sənədlər":
                    return "RelationDocNumbers";
                case "Nəzarət":
                    return "DocUnderControlStatusValue";
                default:
                    break;
            }
            return "";
        }
        //Emekdas
        internal string GetFieldNameForEmployeeAppealsReportIsExecutedDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "İcra müddəti":
                    return "PlannedDate";
                case "İcra müddəti(təqvim günü)":
                    return "ExecutionDays";
                case "Uzadılma barədə qeyd":
                    return "DirectionChangeNote";

                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";
                case "Haradan daxil olub":
                    return "EntryFromWhere";
                case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)":
                    return "EntryFromWhoCitizenName";              
                case "Vətəndaşın sosial statusu":
                    return "SocialName";
                case "Müraciətin forması":
                    return "DocFormName";
                case "Müraciətin növü":
                    return "ApplyTypeName";
                case "Mövzu":
                    return "TopicTypeName";
                case "Alt mövzu":
                    return "TopicName";
                case "Şikayət olunan qurum":
                    return "ComplainedOfDocStructure";
                case "Şikayət olunan alt qurum":
                    return "ComplainedOfDocSubStructure";
                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "İcraçı struktur bölmə":
                    return "ExecutorDepartment";              
              
                case "Cavab sənədinin nömrəsi":
                    return "ReplyDocNumbers";
                case "Cavab sənədinin tarixi":
                    return "ReplyDocDate";             
                case "Müraciətlərə baxılmasının vəziyyəti":
                    return "DocResultName";
                case "Rayon/Şəhər":
                    return "RegionName";
                case "Kənd":
                    return "VillageName";
                default:
                    break;
            }
            return "";
        }
        #endregion
        
        #region ForInformationDocForExcel
        //Vetendas
        internal string GetFieldNameForCitizenForInformationDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";
                case "Haradan daxil olub":
                    return "EntryFromWhere";
                case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)":
                    return "EntryFromWhoCitizenName";
                case "Vətəndaşın sosial statusu":
                    return "SocialName";
                case "Müraciətin forması":
                    return "FormName";
                case "Müraciətin növü":
                    return "ApplyTypeName";
                case "Mövzu":
                    return "TopicTypeName";
                case "Alt Mövzu":
                    return "TopicName";
                case "Şikayət olunan qurum":
                    return "ComplainedOfDocStructure";
                case "Şikayət olunan alt qurum":
                    return "ComplainedOfDocSubStructure";
                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "Struktur bölmə":
                    return "ExecutorsDepartments";
                case "Rayon/Şəhər":
                    return "RegionName";
                case "Kənd":
                    return "VillageName";
                case "Əlaqəli sənədlər":
                    return "RelationDocNumbers";
                default:
                    break;
            }
            return "";
        }

        //Teskilat
        internal string GetFieldNameForOrganizationForInformationDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";
                case "Haradan daxil olub":
                    return "EntryFromWhere";
                case "Sənədin növü":
                    return "FormName";
                case "Mövzu":
                    return "TopicTypeName";
                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "Struktur bölmə":
                    return "ExecutorsDepartments";
                case "Əlaqəli sənədlər":
                    return "RelationDocNumbers";
                default:
                    break;
            }
            return "";
        }

        //Emekdas
        internal string GetFieldNameForEmployeeAppealsForInformationDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";
                case "Haradan daxil olub":
                    return "EntryFromWhere";
                case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)":
                    return "EntryFromWhoCitizenName";
                case "Vətəndaşın sosial statusu":
                    return "SocialName";
                case "Müraciətin forması":
                    return "FormName";
                case "Müraciətin növü":
                    return "ApplyTypeName";
                case "Mövzu":
                    return "TopicTypeName";
                case "Alt Mövzu":
                    return "TopicName";
                case "Şikayət olunan qurum":
                    return "ComplainedOfDocStructure";
                case "Şikayət olunan alt qurum":
                    return "ComplainedOfDocSubStructure";
                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "Struktur bölmə":
                    return "ExecutorsDepartments";
                default:
                    break;
            }
            return "";
        }

        #endregion

        #region AllDocsForExcel
        //Vetendas
        internal string GetFieldNameForCitizenAllDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "İcra müddəti":
                    return "PlannedDate";
                case "İcra müddəti(təqvim günü)":
                    return "ExecutionDays";
                case "Uzadılma barədə qeyd":
                    return "DirectionChangeNote";
                case "İcraya qalan müddət":
                    return "RemainingDay";
                case "Neçə gün gecikmə ilə icra olunub":
                    return "LatelyExecutedDays";

                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";
                case "Haradan daxil olub":
                    return "EntryFromWhere";
                case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)":
                    return "EntryFromWhoCitizenName";
                case "Nəzarətə götürən şəxs":
                    return "EntryFromWho";
                case "Vətəndaşın sosial statusu":
                    return "SocialName";
                case "Müraciətin forması":
                    return "FormName";
                case "Müraciətin növü":
                    return "ApplyTypeName";
                case "Mövzu":
                    return "TopicTypeName";
                case "Alt Mövzu":
                    return "TopicName";
                case "Şikayət olunan qurum":
                    return "ComplainedOfDocStructure";
                case "Şikayət olunan alt qurum":
                    return "ComplainedOfDocSubStructure";
                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "İcraçı struktur bölmə":
                    return "ExecutorsDepartments";
                case "Sənədin icraçısı":
                    return "ExecutorsName";
                case "Sənədin icraçısı (şöbənin əməkdaşı)":
                    return "LastExecutorName";
              
                case "Cavab sənədinin nömrəsi":
                    return "ReplyDocNumbers";
                case "Cavab sənədinin tarixi":
                    return "ReplyDocDate";
                case "Cavab sənədinin statusu":
                    return "ReplyDocStatus";
                case "Əlaqəli sənədlər":
                    return "RelationDocNumbers";
                case "Müraciətlərə baxılmasının vəziyyəti":
                    return "DocResultName";
                case "Rayon/Şəhər":
                    return "RegionName";
                case "Kənd":
                    return "VillageName";
                case "Nəzarət":
                    return "DocUnderControlStatusValue";
                default:
                    break;
            }
            return "";
        }

        //Teskilat
        internal string GetFieldNameForOrganizationAllDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "İcra müddəti":
                    return "PlannedDate";
                case "İcra müddəti(təqvim günü)":
                    return "ExecutionDays";
                case "Uzadılma barədə qeyd":
                    return "DirectionChangeNote";
                case "İcraya qalan müddət":
                    return "RemainingDay";
                case "Neçə gün gecikmə ilə icra olunub":
                    return "LatelyExecutedDays";

                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";
                case "Haradan daxil olub":
                    return "EntryFromWhere";
                case "Sənədin növü":
                    return "FormName";
                case "Mövzu":
                    return "TopicTypeName";
                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "İcraçı struktur bölmə":
                    return "ExecutorsDepartments";
                case "Sənədin icraçısı":
                    return "ExecutorsName";
                case "Sənədin icraçısı (şöbənin əməkdaşı)":
                    return "LastExecutorName";
           
                case "Cavab sənədinin nömrəsi":
                    return "ReplyDocNumbers";
                case "Cavab sənədinin tarixi":
                    return "ReplyDocDate";
                case "Cavab sənədinin statusu":
                    return "ReplyDocStatus";
                case "Əlaqəli sənədlər":
                    return "RelationDocNumbers";
                case "Nəzarət":
                    return "DocUnderControlStatusValue";
                default:
                    break;
            }
            return "";
        }

        //Emekdas
        internal string GetFieldNameForEmployeeAppealsAllDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "İcra müddəti":
                    return "PlannedDate";
                case "İcra müddəti(təqvim günü)":
                    return "ExecutionDays";
                case "Uzadılma barədə qeyd":
                    return "DirectionChangeNote";

                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "Sənədin nömrəsi":
                    return "DocDocno";
                case "Sənədin tarixi":
                    return "DocDocDate";
                case "Haradan daxil olub":
                    return "EntryFromWhere";
                case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)":
                    return "EntryFromWhoCitizenName";
                case "Vətəndaşın sosial statusu":
                    return "SocialName";
                case "Müraciətin forması":
                    return "FormName";
                case "Müraciətin növü":
                    return "ApplyTypeName";
                case "Mövzu":
                    return "TopicTypeName";
                case "Alt Mövzu":
                    return "TopicName";
                case "Şikayət olunan qurum":
                    return "ComplainedOfDocStructure";
                case "Şikayət olunan alt qurum":
                    return "ComplainedOfDocSubStructure";
                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "İcraçı struktur bölmə":
                    return "ExecutorsDepartments";
             
                case "Cavab sənədinin nömrəsi":
                    return "ReplyDocNumbers";
                case "Cavab sənədinin tarixi":
                    return "ReplyDocDate";
                case "Müraciətlərə baxılmasının vəziyyəti":
                    return "DocResultName";
                case "Rayon/Şəhər":
                    return "RegionName";
                case "Kənd":
                    return "VillageName";
                default:
                    break;
            }
            return "";
        }
        //Xaric olan 
        internal string GetFieldNameForOutGoingAllDocs(string caption)
        {
            caption = caption.Trim();
            switch (caption)
            {
                case "Sıra sayı №":
                    return "DocId";
                case "Qeydiyyat nömrəsi":
                    return "DocEnterno";
                case "Qeydiyyat tarixi":
                    return "DocEnterDate";
                case "Göndərilən təşkilat":
                    return "WhomAdressedCompany";
                case "Göndərilən şəxs":
                    return "WhomAdressedPerson";
                case "Sənədin növü":
                    return "FormName";
                case "Sənədin qısa məzmunu":
                    return "DocDescription";
                case "Kimə ünvanlanıb":
                    return "WhomAdress";
                case "İmzalayan şəxs":
                    return "Signer";
                case "Sənədin statusu":
                    return "DocumentStatusName";
                case "İcraçı struktur bölmə":
                    return "ExecutorsDepartments";
                case "Sənədin icraçısı":
                    return "ExecutorsName";
                case "Daxil olan sənədin nömrəsi":
                    return "IncomingDocNumbers";
                case "Daxil olan sənədin tarixi":
                    return "IncomingDocDates";
                case "Əlaqəli sənədlər":
                    return "RelationDocNumbers";
                default:
                    break;
            }
            return "";
        }
        #endregion
    }
}
