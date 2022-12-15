using BLL.Models.Report;
using BLL.Models.Report.Filter;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.draw;
using System;
using System.Collections.Generic;
using System.IO;

namespace AzDoc.Helpers
{
    class PdfHelper
    {
        static readonly BaseFont baseFont = BaseFont.CreateFont("c:\\WINDOWS\\fonts\\times.ttf", BaseFont.IDENTITY_H, true);

        #region AllDocsToPdf
        internal static void ExportAllDocsToPdf(IEnumerable<ReportAllDocsModel> reportAllDocs, List<string> objHeaders, string pdfPath, ReportPdfHeading pdfHeading,
            DateTime startDate, DateTime endDate, ReportAllDocsFilter reportAllDocsFilter)
        {
            FileStream fs = new FileStream(pdfPath, FileMode.Create, FileAccess.Write, FileShare.None);
            Document document = new Document();
            document.SetPageSize(PageSize.A4.Rotate());
            PdfWriter writer = PdfWriter.GetInstance(document, fs);
            document.Open();

            //Report Header

            ////Create a base font object making sure to specify IDENTITY-H
            Font fntHead = new Font(baseFont, 16, 2, BaseColor.GRAY);
            Paragraph prgHeading = new Paragraph();
            prgHeading.Alignment = Element.ALIGN_CENTER;
            prgHeading.Add(new Chunk(pdfHeading.CurrentOrganizationName, fntHead));
            if (!string.IsNullOrWhiteSpace(pdfHeading.TargetName))
            {
                prgHeading.Add(new Chunk("\n\n" + pdfHeading.TargetName, fntHead));
            }
            prgHeading.Add(new Chunk("\n\nHesabat", fntHead));
            document.Add(prgHeading);

            var department = SessionHelper.DepartmentPositionName;
            //Author
            Paragraph prgAuthor = new Paragraph();
            Font fntAuthor = new Font(baseFont, 8, 2, BaseColor.GRAY);
            prgAuthor.Alignment = Element.ALIGN_RIGHT;

            switch (reportAllDocsFilter.docTypeId)
            {
                case 1: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Təşkilat müraciətləri", fntAuthor)); break;
                case 2: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Vətəndaş müraciətləri", fntAuthor)); break;
                case 3: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Sərəncamverici sənədlər", fntAuthor)); break;
                case 12: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Xaric olan sənədlər", fntAuthor)); break;
                case 18: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Xidməti məktublar", fntAuthor)); break;
                case 27: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Əməkdaş müraciətləri", fntAuthor)); break;
                default:
                    break;
            }

            prgAuthor.Add(new Chunk(("\nBütün Sənədlər" + " (" + startDate.ToShortDateString()+ "-" + endDate.ToShortDateString()+") "), fntAuthor));
            // prgAuthor.Add(new Chunk("\nBaşlanğıc tarix : " + startDate.ToShortDateString(), fntAuthor));
            // prgAuthor.Add(new Chunk("\nYekun tarix : " + endDate.ToShortDateString(), fntAuthor));
            document.Add(prgAuthor);

            //Add a line seperation
            Paragraph p = new Paragraph(new Chunk(new LineSeparator(0.0F, 100.0F, BaseColor.BLACK, Element.ALIGN_LEFT, 1)));
            document.Add(p);

            //Add line break
            document.Add(new Chunk("\n", fntHead));

            //Write the table
            PdfPTable table = new PdfPTable(objHeaders.Count);

            table.HorizontalAlignment = 0;
            table.TotalWidth = 770f;
            table.LockedWidth = true;
            float[] widths = new float[objHeaders.Count];

            #region GetObjectHeaders

            for (int i = 0; i < objHeaders.Count; i++)
            {
                if (reportAllDocsFilter.docTypeId == 1)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "İcra müddəti": widths[i] = 100f; break;
                        case "İcra müddəti(təqvim günü)": widths[i] = 100f; break;
                        case "Uzadılma barədə qeyd": widths[i] = 200f; break;
                        case "İcraya qalan müddət": widths[i] = 100f; break;
                        case "Neçə gün gecikmə ilə icra olunub": widths[i] = 100f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "Sənədin nömrəsi": widths[i] = 100f; break;
                        case "Sənədin tarixi": widths[i] = 100f; break;
                        case "Haradan daxil olub": widths[i] = 110f; break;
                        case "Sənədin növü": widths[i] = 100f; break;
                        case "Mövzu": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                        case "Sənədin icraçısı": widths[i] = 100f; break;
                        case "Sənədin icraçısı (şöbənin əməkdaşı)": widths[i] = 100f; break;
                        case "Cavab sənədinin nömrəsi": widths[i] = 100f; break;
                        case "Cavab sənədinin tarixi": widths[i] = 100f; break;
                        case "Cavab sənədinin statusu": widths[i] = 100f; break;
                        case "Əlaqəli sənədlər": widths[i] = 100f; break;
                        case "Nəzarət": widths[i] = 80f; break;
                        default:
                            widths[i] = 70f;
                            break;
                    }
                }
                else if (reportAllDocsFilter.docTypeId == 2)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "İcra müddəti": widths[i] = 100f; break;
                        case "İcra müddəti(təqvim günü)": widths[i] = 100f; break;
                        case "Uzadılma barədə qeyd": widths[i] = 200f; break;
                        case "İcraya qalan müddət": widths[i] = 100f; break;
                        case "Neçə gün gecikmə ilə icra olunub": widths[i] = 100f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "Sənədin nömrəsi": widths[i] = 100f; break;
                        case "Sənədin tarixi": widths[i] = 100f; break;
                        case "Haradan daxil olub": widths[i] = 110f; break;
                        case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)": widths[i] = 100f; break;
                        case "Nəzarətə götürən şəxs": widths[i] = 100f; break;
                        case "Vətəndaşın sosial statusu": widths[i] = 100f; break;
                        case "Müraciətin forması": widths[i] = 100f; break;
                        case "Müraciətin növü": widths[i] = 100f; break;
                        case "Mövzu": widths[i] = 100f; break;
                        case "Alt Mövzu": widths[i] = 100f; break;
                        case "Şikayət olunan qurum": widths[i] = 100f; break;
                        case "Şikayət olunan alt qurum": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                        case "Sənədin icraçısı": widths[i] = 100f; break;
                        case "Sənədin icraçısı (şöbənin əməkdaşı)": widths[i] = 100f; break;
                    
                        case "Cavab sənədinin nömrəsi": widths[i] = 100f; break;
                        case "Cavab sənədinin tarixi": widths[i] = 100f; break;
                        case "Cavab sənədinin statusu": widths[i] = 100f; break;
                        case "Əlaqəli sənədlər": widths[i] = 100f; break;
                        case "Müraciətlərə baxılmasının vəziyyəti": widths[i] = 100f; break;
                        case "Rayon/Şəhər": widths[i] = 100f; break;
                        case "Kənd": widths[i] = 100f; break;
                        case "Nəzarət": widths[i] = 80f; break;

                        default:
                            widths[i] = 70f;
                            break;
                    }
                }
                else if (reportAllDocsFilter.docTypeId == 12)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "Göndərilən təşkilat" : widths[i] = 100f; break;
                        case "Göndərilən şəxs" : widths[i] = 100f; break;
                        case "Sənədin növü": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "Kimə ünvanlanıb": widths[i] = 200f; break;
                        case "İmzalayan şəxs": widths[i] = 200f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                        case "Sənədin icraçısı": widths[i] = 100f; break;
                        case "Daxil olan sənədin nömrəsi": widths[i] = 100f; break;
                        case "Daxil olan sənədin tarixi": widths[i] = 100f; break;
                        case "Əlaqəli sənədlər": widths[i] = 100f; break;
                        default:
                            widths[i] = 70f;
                            break;
                    }
                }
                else if (reportAllDocsFilter.docTypeId == 27)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "İcra müddəti": widths[i] = 100f; break;
                        case "İcra müddəti(təqvim günü)": widths[i] = 100f; break;
                        case "Uzadılma barədə qeyd": widths[i] = 200f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "Sənədin nömrəsi": widths[i] = 100f; break;
                        case "Sənədin tarixi": widths[i] = 100f; break;
                        case "Haradan daxil olub": widths[i] = 110f; break;
                        case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)": widths[i] = 100f; break;
                        case "Vətəndaşın sosial statusu": widths[i] = 100f; break;
                        case "Müraciətin forması": widths[i] = 100f; break;
                        case "Müraciətin növü": widths[i] = 100f; break;
                        case "Mövzu": widths[i] = 100f; break;
                        case "Alt Mövzu": widths[i] = 100f; break;
                        case "Şikayət olunan qurum": widths[i] = 100f; break;
                        case "Şikayət olunan alt qurum": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                        case "Sənədin icraçısı": widths[i] = 100f; break;
                       
                        case "Cavab sənədinin nömrəsi": widths[i] = 100f; break;
                        case "Cavab sənədinin tarixi": widths[i] = 100f; break;
                        case "Müraciətlərə baxılmasının vəziyyəti": widths[i] = 100f; break;
                        case "Rayon/Şəhər": widths[i] = 100f; break;
                        case "Kənd": widths[i] = 100f; break;
                        default:
                            widths[i] = 70f;
                            break;
                    }
                }
                else
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "İcra müddəti": widths[i] = 100f; break;
                        case "İcra müddəti(təqvim günü)": widths[i] = 100f; break;
                        case "Uzadılma barədə qeyd": widths[i] = 200f; break;
                        case "İcraya qalan müddət": widths[i] = 100f; break;
                        case "Neçə gün gecikmə ilə icra olunub": widths[i] = 100f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "Sənədin nömrəsi": widths[i] = 100f; break;
                        case "Sənədin tarixi": widths[i] = 100f; break;
                        case "Haradan daxil olub": widths[i] = 110f; break;
                        case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)": widths[i] = 100f; break;
                        case "Nəzarətə götürən şəxs": widths[i] = 100f; break;
                        case "Vətəndaşın sosial statusu": widths[i] = 100f; break;
                        case "Müraciətin forması": widths[i] = 100f; break;
                        case "Müraciətin növü": widths[i] = 100f; break;
                        case "Mövzu": widths[i] = 100f; break;
                        case "Alt Mövzu": widths[i] = 100f; break;
                        case "Şikayət olunan qurum": widths[i] = 100f; break;
                        case "Şikayət olunan alt qurum": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                        case "Sənədin icraçısı": widths[i] = 100f; break;
                        case "Sənədin icraçısı (şöbənin əməkdaşı)": widths[i] = 100f; break;
                     
                        case "Cavab sənədinin nömrəsi": widths[i] = 100f; break;
                        case "Cavab sənədinin tarixi": widths[i] = 100f; break;
                        case "Cavab sənədinin statusu": widths[i] = 100f; break;
                        case "Əlaqəli sənədlər": widths[i] = 100f; break;
                        case "Müraciətlərə baxılmasının vəziyyəti": widths[i] = 100f; break;
                        case "Rayon/Şəhər": widths[i] = 100f; break;
                        case "Kənd": widths[i] = 100f; break;
                        case "Nəzarət": widths[i] = 80f; break;

                        default:
                            widths[i] = 70f;
                            break;
                    }
                }

            }
            #endregion

            table.SetWidths(widths);
            //Table header
            Font fntColumnHeader = new Font(baseFont, 6, 1, BaseColor.WHITE);
            for (int i = 0; i < objHeaders.Count; i++)
            {
                addCell(table, objHeaders[i], 2);
            }

            #region AddingDataToPdfGrid
            int counter = 0;
            foreach (var item in reportAllDocs)
            {
                counter++;
                if (reportAllDocsFilter.docTypeId == 1)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToString("dd.MM.yyyy"), 1);
                    addCell(table, item.PlannedDate.HasValue ? item.PlannedDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.ExecutionDays.ToString(), 1);
                    addCell(table, item.DirectionChangeNote, 1);
                    addCell(table, item.RemainingDay.ToString(), 1);
                    addCell(table, Convert.ToString(item.LatelyExecutedDays), 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.FormName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.ExecutorsDepartments) ? "" : item.ExecutorsDepartments.Replace(',', '\n'), 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.ExecutorsName) ? "" : item.ExecutorsName.Replace(',', '\n'), 1);
                    addCell(table, item.LastExecutorName, 1);
                    addCell(table, item.ReplyDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, Convert.ToString(item.ReplyDocDate), 1);
                    addCell(table, item.ReplyDocStatus?.Replace(',', '\n'), 1);
                    addCell(table, item.RelationDocNumbers, 1);
                    addCell(table, item.DocUnderControlStatusValue, 1);
                }
                else if (reportAllDocsFilter.docTypeId == 2)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToString("dd.MM.yyyy"), 1);
                    addCell(table, item.PlannedDate.HasValue ? item.PlannedDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.ExecutionDays.ToString(), 1);
                    addCell(table, item.DirectionChangeNote, 1);
                    addCell(table, item.RemainingDay.ToString(), 1);
                    addCell(table, Convert.ToString(item.LatelyExecutedDays), 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.EntryFromWhoCitizenName, 1);
                    addCell(table, item.EntryFromWho, 1);
                    addCell(table, item.SocialName, 1);
                    addCell(table, item.FormName, 1);
                    addCell(table, item.ApplyTypeName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.TopicName, 1);
                    addCell(table, item.ComplainedOfDocStructure, 1);
                    addCell(table, item.ComplainedOfDocSubStructure, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.ExecutorsDepartments) ? "" : item.ExecutorsDepartments.Replace(',', '\n'), 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.ExecutorsName) ? "" : item.ExecutorsName.Replace(',', '\n'), 1);
                    addCell(table, item.LastExecutorName, 1);
                 
                    addCell(table, item.ReplyDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, Convert.ToString(item.ReplyDocDate), 1);
                    addCell(table, item.ReplyDocStatus?.Replace(',', '\n'), 1);
                    addCell(table, item.RelationDocNumbers, 1);
                    addCell(table, item.DocResultName, 1);
                    addCell(table, item.RegionName, 1);
                    addCell(table, item.VillageName, 1);
                    addCell(table, item.DocUnderControlStatusValue, 1);

                }
                else if (reportAllDocsFilter.docTypeId == 12)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToString("dd.MM.yyyy"), 1);
                    addCell(table, item.WhomAdressedCompany, 1);
                    addCell(table, item.WhomAdressedPerson, 1);
                    addCell(table, item.FormName, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, item.WhomAdress, 1);
                    addCell(table, item.Signer, 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.ExecutorsDepartments) ? "" : item.ExecutorsDepartments.Replace(',', '\n'), 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.ExecutorsName) ? "" : item.ExecutorsName.Replace(',', '\n'), 1);
                    addCell(table, item.IncomingDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, Convert.ToString(item.IncomingDocDates), 1);
                    addCell(table, item.RelationDocNumbers, 1);
                }
                else if (reportAllDocsFilter.docTypeId == 27)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToString("dd.MM.yyyy"), 1);
                    addCell(table, item.PlannedDate.HasValue ? item.PlannedDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.ExecutionDays.ToString(), 1);
                    addCell(table, item.DirectionChangeNote, 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.EntryFromWhoCitizenName, 1);
                    addCell(table, item.SocialName, 1);
                    addCell(table, item.FormName, 1);
                    addCell(table, item.ApplyTypeName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.TopicName, 1);
                    addCell(table, item.ComplainedOfDocStructure, 1);
                    addCell(table, item.ComplainedOfDocSubStructure, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.ExecutorsDepartments) ? "" : item.ExecutorsDepartments.Replace(',', '\n'), 1);
                 
                    addCell(table, item.ReplyDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, Convert.ToString(item.ReplyDocDate), 1);
                    addCell(table, item.DocResultName, 1);
                    addCell(table, item.RegionName, 1);
                    addCell(table, item.VillageName, 1);
                }
                else
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToShortDateString(), 1);
                    addCell(table, item.PlannedDate.HasValue ? item.PlannedDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.ExecutionDays.ToString(), 1);
                    addCell(table, item.DirectionChangeNote, 1);
                    addCell(table, item.RemainingDay.ToString(), 1);
                    addCell(table, Convert.ToString(item.LatelyExecutedDays), 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.EntryFromWhoCitizenName, 1);
                    addCell(table, item.EntryFromWho, 1);
                    addCell(table, item.SocialName, 1);
                    addCell(table, item.FormName, 1);
                    addCell(table, item.ApplyTypeName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.TopicName, 1);
                    addCell(table, item.ComplainedOfDocStructure, 1);
                    addCell(table, item.ComplainedOfDocSubStructure, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.ExecutorsDepartments) ? "" : item.ExecutorsDepartments.Replace(',', '\n'), 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.ExecutorsName) ? "" : item.ExecutorsName.Replace(',', '\n'), 1);
                    addCell(table, item.LastExecutorName, 1);
                   
                    addCell(table, item.ReplyDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, Convert.ToString(item.ReplyDocDate), 1);
                    addCell(table, item.ReplyDocStatus?.Replace(',', '\n'), 1);
                    addCell(table, item.RelationDocNumbers, 1);
                    addCell(table, item.DocResultName, 1);
                    addCell(table, item.RegionName, 1);
                    addCell(table, item.VillageName, 1);
                    addCell(table, item.DocUnderControlStatusValue, 1);

                }

            }
            #endregion

            document.Add(table);
            document.Close();
            writer.Close();
            fs.Close();
        }
        #endregion

        #region InExecutionDocsToPdf
        internal static void ExportInExecutionDocsToPdf(IEnumerable<ReportInExecutionDocsModel> reportInExecutionDocs, List<string> objHeaders, string pdfPath, ReportPdfHeading pdfHeading,
                    DateTime startDate, DateTime endDate, ReportInExecutionDocsFilter reportInExecutionDocsFilter)
        {
            FileStream fs = new FileStream(pdfPath, FileMode.Create, FileAccess.Write, FileShare.None);
            Document document = new Document();
            document.SetPageSize(PageSize.A4.Rotate());
            PdfWriter writer = PdfWriter.GetInstance(document, fs);
            document.Open();

            //Report Header
            ////Create a base font object making sure to specify IDENTITY-H
            Font fntHead = new Font(baseFont, 16, 2, BaseColor.GRAY);
            Paragraph prgHeading = new Paragraph();
            prgHeading.Alignment = Element.ALIGN_CENTER;
            prgHeading.Add(new Chunk(pdfHeading.CurrentOrganizationName, fntHead));
            if (!string.IsNullOrWhiteSpace(pdfHeading.TargetName))
            {
                prgHeading.Add(new Chunk("\n\n" + pdfHeading.TargetName, fntHead));
            }
            prgHeading.Add(new Chunk("\n\nHesabat", fntHead));
            document.Add(prgHeading);

            //Author
            Paragraph prgAuthor = new Paragraph();
            Font fntAuthor = new Font(baseFont, 8, 2, BaseColor.GRAY);
            prgAuthor.Alignment = Element.ALIGN_RIGHT;

            switch (reportInExecutionDocsFilter.docTypeId.Value)
            {
                case 1: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Təşkilat müraciətləri", fntAuthor)); break;
                case 2: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Vətəndaş müraciətləri", fntAuthor)); break;
                case 3: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Sərəncamverici sənədlər", fntAuthor)); break;
                case 4: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Xaric olan sənədlər", fntAuthor)); break;
                case 18: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Xidməti məktublar", fntAuthor)); break;
                case 27: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Əməkdaş müraciətləri", fntAuthor)); break;
                default:
                    break;
            }

            // switch (reportInExecutionDocsFilter.remaningDay)
            // {
            //     case -1: prgAuthor.Add(new Chunk("\nİcrada olan sənədlər", fntAuthor)); break;
            //     case 1: prgAuthor.Add(new Chunk("\nİcra vaxtının bitməsinə 1 gün qalmış sənədlər", fntAuthor)); break;
            //     case 3: prgAuthor.Add(new Chunk("\nİcra vaxtının bitməsinə 3 gün qalmış sənədlər", fntAuthor)); break;
            //     case 5: prgAuthor.Add(new Chunk("\nİcra vaxtının bitməsinə 5 gün qalmış sənədlər", fntAuthor)); break;
            //     case 6: prgAuthor.Add(new Chunk("\nİcraatda olan sənədlər", fntAuthor)); break;
            //     case 0: prgAuthor.Add(new Chunk("\nGecikmiş sənədlər", fntAuthor)); break;
            //     default:
            //         break;
            // }

            prgAuthor.Add(new Chunk(("\nİcrada olan sənədlər" +" (" +startDate.ToShortDateString()+ "-" + endDate.ToShortDateString() +")"), fntAuthor));
            // prgAuthor.Add(new Chunk("\nBaşlanğıc tarix : " + startDate.ToShortDateString(), fntAuthor));
            // prgAuthor.Add(new Chunk("\nYekun tarix : " + endDate.ToShortDateString(), fntAuthor));
            document.Add(prgAuthor);

            //Add a line seperation
            Paragraph p = new Paragraph(new Chunk(new LineSeparator(0.0F, 100.0F, BaseColor.BLACK, Element.ALIGN_LEFT, 1)));
            document.Add(p);

            //Add line break
            document.Add(new Chunk("\n", fntHead));

            //Write the table
            PdfPTable table = new PdfPTable(objHeaders.Count);

            table.HorizontalAlignment = 0;
            table.TotalWidth = 770f;
            table.LockedWidth = true;
            float[] widths = new float[objHeaders.Count];
            {/* 90f, 90f, 90f, 90f, 90f, 90f, 90f, 90f, 90f, 90f, 90f*/ };

            #region GetObjectHeaders

            for (int i = 0; i < objHeaders.Count; i++)
            {
                if (reportInExecutionDocsFilter.docTypeId == 1)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "İcra müddəti": widths[i] = 100f; break;
                        case "İcra müddəti(təqvim günü)": widths[i] = 100f; break;
                        case "Uzadılma barədə qeyd": widths[i] = 200f; break;
                        case "İcraya qalan müddət": widths[i] = 100f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "Sənədin nömrəsi": widths[i] = 100f; break;
                        case "Sənədin tarixi": widths[i] = 100f; break;
                        case "Haradan daxil olub": widths[i] = 110f; break;
                        case "Sənədin növü": widths[i] = 100f; break;
                        case "Mövzu": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                        case "Sənədin icraçısı": widths[i] = 100f; break;
                        case "Sənədin icraçısı (şöbənin əməkdaşı)": widths[i] = 100f; break;
                      
                        case "Cavab sənədinin nömrəsi": widths[i] = 100f; break;
                        case "Cavab sənədinin tarixi": widths[i] = 100f; break;
                        case "Cavab sənədinin statusu": widths[i] = 100f; break;
                        case "Əlaqəli sənədlər": widths[i] = 100f; break;
                        case "Nəzarət": widths[i] = 80f; break;

                        default:
                            widths[i] = 100f;
                            break;
                    }
                }
                else if (reportInExecutionDocsFilter.docTypeId == 2)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "İcra müddəti": widths[i] = 100f; break;
                        case "İcra müddəti(təqvim günü)": widths[i] = 100f; break;
                        case "Uzadılma barədə qeyd": widths[i] = 200f; break;
                        case "İcraya qalan müddət": widths[i] = 100f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "Sənədin nömrəsi": widths[i] = 100f; break;
                        case "Sənədin tarixi": widths[i] = 100f; break;
                        case "Haradan daxil olub": widths[i] = 110f; break;
                        case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)": widths[i] = 100f; break;
                        case "Nəzarətə götürən şəxs": widths[i] = 100f; break;
                        case "Vətəndaşın sosial statusu": widths[i] = 100f; break;
                        case "Müraciətin forması": widths[i] = 100f; break;
                        case "Müraciətin növü": widths[i] = 100f; break;
                        case "Mövzu": widths[i] = 100f; break;
                        case "Alt Mövzu": widths[i] = 100f; break;
                        case "Şikayət olunan qurum": widths[i] = 100f; break;
                        case "Şikayət olunan alt qurum": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                        case "Sənədin icraçısı": widths[i] = 100f; break;
                        case "Sənədin icraçısı (şöbənin əməkdaşı)": widths[i] = 100f; break;
                       
                        case "Cavab sənədinin nömrəsi": widths[i] = 100f; break;
                        case "Cavab sənədinin tarixi": widths[i] = 100f; break;
                        case "Cavab sənədinin statusu": widths[i] = 100f; break;
                        case "Müraciətlərə baxılmasının vəziyyəti": widths[i] = 100f; break;
                        case "Əlaqəli sənədlər": widths[i] = 100f; break;
                        case "Rayon/Şəhər": widths[i] = 100f; break;
                        case "Kənd": widths[i] = 100f; break;
                        case "Nəzarət": widths[i] = 80f; break;

                        default:
                            widths[i] = 100f;
                            break;
                    }
                }
                else if (reportInExecutionDocsFilter.docTypeId == 27)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "İcra müddəti": widths[i] = 100f; break;
                        case "İcra müddəti(təqvim günü)": widths[i] = 100f; break;
                        case "Uzadılma barədə qeyd": widths[i] = 200f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "Sənədin nömrəsi": widths[i] = 100f; break;
                        case "Sənədin tarixi": widths[i] = 100f; break;
                        case "Haradan daxil olub": widths[i] = 110f; break;
                        case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)": widths[i] = 100f; break;
                        case "Vətəndaşın sosial statusu": widths[i] = 100f; break;
                        case "Müraciətin forması": widths[i] = 100f; break;
                        case "Müraciətin növü": widths[i] = 100f; break;
                        case "Mövzu": widths[i] = 100f; break;
                        case "Alt Mövzu": widths[i] = 100f; break;
                        case "Şikayət olunan qurum": widths[i] = 100f; break;
                        case "Şikayət olunan alt qurum": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                       
                        case "Cavab sənədinin nömrəsi": widths[i] = 100f; break;
                        case "Cavab sənədinin tarixi": widths[i] = 100f; break;
                        case "Müraciətlərə baxılmasının vəziyyəti": widths[i] = 100f; break;
                        case "Rayon/Şəhər": widths[i] = 100f; break;
                        case "Kənd": widths[i] = 100f; break;
                        default:
                            widths[i] = 100f;
                            break;
                    }
                }
                else
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "İcra müddəti": widths[i] = 100f; break;
                        case "İcra müddəti(təqvim günü)": widths[i] = 100f; break;
                        case "Uzadılma barədə qeyd": widths[i] = 200f; break;
                        case "İcraya qalan müddət": widths[i] = 100f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "Sənədin nömrəsi": widths[i] = 100f; break;
                        case "Sənədin tarixi": widths[i] = 100f; break;
                        case "Haradan daxil olub": widths[i] = 110f; break;
                        case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)": widths[i] = 100f; break;
                        case "Nəzarətə götürən şəxs": widths[i] = 100f; break;
                        case "Vətəndaşın sosial statusu": widths[i] = 100f; break;
                        case "Müraciətin forması": widths[i] = 100f; break;
                        case "Müraciətin növü": widths[i] = 100f; break;
                        case "Mövzu": widths[i] = 100f; break;
                        case "Alt Mövzu": widths[i] = 100f; break;
                        case "Şikayət olunan qurum": widths[i] = 100f; break;
                        case "Şikayət olunan alt qurum": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                        case "Sənədin icraçısı": widths[i] = 100f; break;
                        case "Sənədin icraçısı (şöbənin əməkdaşı)": widths[i] = 100f; break;
                      
                        case "Cavab sənədinin nömrəsi": widths[i] = 100f; break;
                        case "Cavab sənədinin tarixi": widths[i] = 100f; break;
                        case "Cavab sənədinin statusu": widths[i] = 100f; break;
                        case "Əlaqəli sənədlər": widths[i] = 100f; break;
                        case "Müraciətlərə baxılmasının vəziyyəti": widths[i] = 100f; break;
                        case "Rayon/Şəhər": widths[i] = 100f; break;
                        case "Kənd": widths[i] = 100f; break;
                        case "Nəzarət": widths[i] = 80f; break;

                        default:
                            widths[i] = 100f;
                            break;
                    }
                }               
            }

            #endregion

            table.SetWidths(widths);
            //Table header
            Font fntColumnHeader = new Font(baseFont, 6, 1, BaseColor.WHITE);
            for (int i = 0; i < objHeaders.Count; i++)
            {
                addCell(table, objHeaders[i], 2);
            }

            #region AddDataToPDFGrid

            int counter = 0;
            foreach (var item in reportInExecutionDocs)
            {               
                counter++;
                if (reportInExecutionDocsFilter.docTypeId == 1)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToString("dd.MM.yyyy"), 1);
                    addCell(table, item.PlannedDate.HasValue ? item.PlannedDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.ExecutionDays.ToString(), 1);
                    addCell(table, item.DirectionChangeNote, 1);
                    addCell(table, item.RemainingDay.ToString(), 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.DocFormName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.NotExecutedExecutorsDepartment) ? "" : item.NotExecutedExecutorsDepartment.Replace(',', '\n'), 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.NotExecutedExecutorsName) ? "" : item.NotExecutedExecutorsName.Replace(',', '\n'), 1);
                    addCell(table, item.LastExecutorName, 1);
                   
                    addCell(table, item.ReplyDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, Convert.ToString(item.ReplyDocDate), 1);
                    addCell(table, item.ReplyDocStatus?.Replace(',', '\n'), 1);
                    addCell(table, item.RelationDocNumbers, 1);
                    addCell(table, item.DocUnderControlStatusValue, 1);

                }
                else if (reportInExecutionDocsFilter.docTypeId == 2)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToString("dd.MM.yyyy"), 1);
                    addCell(table, item.PlannedDate.HasValue ? item.PlannedDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.ExecutionDays.ToString(), 1);
                    addCell(table, item.DirectionChangeNote, 1);
                    addCell(table, item.RemainingDay.Value.ToString(), 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.EntryFromWhoCitizenName, 1);
                    addCell(table, item.EntryFromWho, 1);
                    addCell(table, item.SocialName, 1);
                    addCell(table, item.DocFormName, 1);
                    addCell(table, item.ApplyTypeName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.TopicName, 1);
                    addCell(table, item.ComplainedOfDocStructure, 1);
                    addCell(table, item.ComplainedOfDocSubStructure, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.NotExecutedExecutorsDepartment) ? "" : item.NotExecutedExecutorsDepartment.Replace(',', '\n'), 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.NotExecutedExecutorsName) ? "" : item.NotExecutedExecutorsName.Replace(',', '\n'), 1);
                    addCell(table, item.LastExecutorName, 1);
                   
                    addCell(table, item.ReplyDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, Convert.ToString(item.ReplyDocDate), 1);
                    addCell(table, item.ReplyDocStatus?.Replace(',', '\n'), 1);
                    addCell(table, item.DocResultName, 1);
                    addCell(table, item.RelationDocNumbers, 1);
                    addCell(table, item.RegionName, 1);
                    addCell(table, item.VillageName, 1);
                    addCell(table, item.DocUnderControlStatusValue, 1);

                }
                else if (reportInExecutionDocsFilter.docTypeId == 27)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToString("dd.MM.yyyy"), 1);
                    addCell(table, item.PlannedDate.HasValue ? item.PlannedDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.ExecutionDays.ToString(), 1);
                    addCell(table, item.DirectionChangeNote, 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.EntryFromWhoCitizenName, 1);
                    addCell(table, item.SocialName, 1);
                    addCell(table, item.DocFormName, 1);
                    addCell(table, item.ApplyTypeName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.TopicName, 1);
                    addCell(table, item.ComplainedOfDocStructure, 1);
                    addCell(table, item.ComplainedOfDocSubStructure, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.NotExecutedExecutorsDepartment) ? "" : item.NotExecutedExecutorsDepartment.Replace(',', '\n'), 1);
                   
                    addCell(table, item.ReplyDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, Convert.ToString(item.ReplyDocDate), 1);
                    addCell(table, item.DocResultName, 1);
                    addCell(table, item.RegionName, 1);
                    addCell(table, item.VillageName, 1);
                }
                else
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToShortDateString(), 1);
                    addCell(table, item.PlannedDate.HasValue ? item.PlannedDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.ExecutionDays.ToString(), 1);
                    addCell(table, item.DirectionChangeNote, 1);
                    addCell(table, item.RemainingDay.Value.ToString(), 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.EntryFromWhoCitizenName, 1);
                    addCell(table, item.EntryFromWho, 1);
                    addCell(table, item.SocialName, 1);
                    addCell(table, item.DocFormName, 1);
                    addCell(table, item.ApplyTypeName, 1);
                    addCell(table, item.TopicName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.ComplainedOfDocStructure, 1);
                    addCell(table, item.ComplainedOfDocSubStructure, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.NotExecutedExecutorsDepartment) ? "" : item.NotExecutedExecutorsDepartment.Replace(',', '\n'), 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.NotExecutedExecutorsName) ? "" : item.NotExecutedExecutorsName.Replace(',', '\n'), 1);
                    addCell(table, item.LastExecutorName, 1);
                 
                    addCell(table, item.ReplyDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, Convert.ToString(item.ReplyDocDate), 1);
                    addCell(table, item.ReplyDocStatus?.Replace(',', '\n'), 1);
                    addCell(table, item.RelationDocNumbers, 1);
                    addCell(table, item.DocResultName, 1);
                    addCell(table, item.RegionName, 1);
                    addCell(table, item.VillageName, 1);
                    addCell(table, item.DocUnderControlStatusValue, 1);

                }
            }

            #endregion

            document.Add(table);
            document.Close();
            writer.Close();
            fs.Close();
        }
        #endregion

        #region IsExecutedDocsToPdf

        internal static void ExportIsExecutedDocsToPdf(IEnumerable<ReportIsExecutedDocsModel> reportIsExecutedDocs, List<string> objHeaders, string pdfPath, int docType, ReportPdfHeading pdfHeading,
                   DateTime startDate, DateTime endDate, ReportIsExecutedDocsFilter reportIsExecutionDocsFilter)
        {
            FileStream fs = new FileStream(pdfPath, FileMode.Create, FileAccess.Write, FileShare.None);
            Document document = new Document();
            document.SetPageSize(PageSize.A4.Rotate());
            PdfWriter writer = PdfWriter.GetInstance(document, fs);
            document.Open();

            //Report Header

            ////Create a base font object making sure to specify IDENTITY-H
            Font fntHead = new Font(baseFont, 16, 2, BaseColor.GRAY);
            Paragraph prgHeading = new Paragraph();
            prgHeading.Alignment = Element.ALIGN_CENTER;
            prgHeading.Add(new Chunk(pdfHeading.CurrentOrganizationName, fntHead));
            if (!string.IsNullOrWhiteSpace(pdfHeading.TargetName))
            {
                prgHeading.Add(new Chunk("\n\n" + pdfHeading.TargetName, fntHead));
            }
            prgHeading.Add(new Chunk("\n\nHesabat", fntHead));
            document.Add(prgHeading);

            var department = SessionHelper.DepartmentPositionName;
            //Author
            Paragraph prgAuthor = new Paragraph();
            Font fntAuthor = new Font(baseFont, 8, 2, BaseColor.GRAY);
            prgAuthor.Alignment = Element.ALIGN_RIGHT;

            switch (reportIsExecutionDocsFilter.docTypeId.Value)
            {
                case 1: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Təşkilat müraciətləri", fntAuthor)); break;
                case 2: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Vətəndaş müraciətləri", fntAuthor)); break;
                case 3: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Sərəncamverici sənədlər", fntAuthor)); break;
                case 4: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Xaric olan sənədlər", fntAuthor)); break;
                case 18: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Xidməti məktublar", fntAuthor)); break;
                case 27: prgAuthor.Add(new Chunk("\nSənədin növü: " + "Əməkdaş müraciətləri", fntAuthor)); break;
                default:
                    break;
            }
            prgAuthor.Add(new Chunk(("\nİcra olunmuş sənədlər" +" (" +startDate.ToShortDateString()+ "-" + endDate.ToShortDateString() +")"), fntAuthor));
            
            // prgAuthor.Add(new Chunk("\nİcra olunmuş sənədlər", fntAuthor));
            // prgAuthor.Add(new Chunk("\nBaşlanğıc tarix : " + startDate.ToShortDateString(), fntAuthor));
            // prgAuthor.Add(new Chunk("\nYekun tarix : " + endDate.ToShortDateString(), fntAuthor));

            document.Add(prgAuthor);

            //Add a line seperation
            Paragraph p = new Paragraph(new Chunk(new LineSeparator(0.0F, 100.0F, BaseColor.BLACK, Element.ALIGN_LEFT, 1)));
            document.Add(p);

            //Add line break
            document.Add(new Chunk("\n", fntHead));

            //Write the table
            PdfPTable table = new PdfPTable(objHeaders.Count);

            table.HorizontalAlignment = 0;
            table.TotalWidth = 770f;
            table.LockedWidth = true;
            float[] widths = new float[objHeaders.Count];
            //{ 90f, 90f, 90f, 90f, 90f, 90f, 90f, 90f, 90f, 90f, 90f};

            #region GetObjectHeaders

            for (int i = 0; i < objHeaders.Count; i++)
            {
                if (reportIsExecutionDocsFilter.docTypeId == 1)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "İcra müddəti": widths[i] = 100f; break;
                        case "İcra müddəti(təqvim günü)": widths[i] = 100f; break;
                        case "Uzadılma barədə qeyd": widths[i] = 200f; break;
                        case "Neçə gün gecikmə ilə icra olunub": widths[i] = 100f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "Sənədin nömrəsi": widths[i] = 100f; break;
                        case "Sənədin tarixi": widths[i] = 100f; break;
                        case "Haradan daxil olub": widths[i] = 110f; break;
                        case "Sənədin növü": widths[i] = 100f; break;
                        case "Mövzu": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                        case "Sənədin icraçısı": widths[i] = 100f; break;
                        case "Sənədin icraçısı (şöbənin əməkdaşı)": widths[i] = 100f; break;

                      
                        case "Cavab sənədinin nömrəsi": widths[i] = 100f; break;
                        case "Cavab sənədinin tarixi": widths[i] = 100f; break;
                        case "Cavab sənədinin statusu": widths[i] = 100f; break;
                        case "Əlaqəli sənədlər": widths[i] = 100f; break;
                        case "Nəzarət": widths[i] = 80f; break;

                        default:
                            widths[i] = 70f;
                            break;
                    }
                }
                else if (reportIsExecutionDocsFilter.docTypeId == 2)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "İcra müddəti": widths[i] = 100f; break;
                        case "İcra müddəti(təqvim günü)": widths[i] = 100f; break;
                        case "Uzadılma barədə qeyd": widths[i] = 200f; break;
                        case "Neçə gün gecikmə ilə icra olunub": widths[i] = 100f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "Sənədin nömrəsi": widths[i] = 100f; break;
                        case "Sənədin tarixi": widths[i] = 100f; break;
                        case "Haradan daxil olub": widths[i] = 110f; break;
                        case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)": widths[i] = 100f; break;
                        case "Nəzarətə götürən şəxs": widths[i] = 100f; break;
                        case "Vətəndaşın sosial statusu": widths[i] = 100f; break;
                        case "Müraciətin forması": widths[i] = 100f; break;
                        case "Müraciətin növü": widths[i] = 100f; break;
                        case "Mövzu": widths[i] = 100f; break;
                        case "Alt Mövzu": widths[i] = 100f; break;
                        case "Şikayət olunan qurum": widths[i] = 100f; break;
                        case "Şikayət olunan alt qurum": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                        case "Sənədin icraçısı": widths[i] = 100f; break;
                        case "Sənədin icraçısı (şöbənin əməkdaşı)": widths[i] = 100f; break;

                      
                        case "Cavab sənədinin nömrəsi": widths[i] = 100f; break;
                        case "Cavab sənədinin tarixi": widths[i] = 100f; break;
                        case "Cavab sənədinin statusu": widths[i] = 100f; break;
                        case "Əlaqəli sənədlər": widths[i] = 100f; break;
                        case "Müraciətlərə baxılmasının vəziyyəti": widths[i] = 100f; break;
                        case "Rayon/Şəhər": widths[i] = 100f; break;
                        case "Kənd": widths[i] = 100f; break;
                        case "Nəzarət": widths[i] = 80f; break;

                        default:
                            widths[i] = 70f;
                            break;
                    }
                }
                else if (reportIsExecutionDocsFilter.docTypeId == 27)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "İcra müddəti": widths[i] = 100f; break;
                        case "İcra müddəti(təqvim günü)": widths[i] = 100f; break;
                        case "Uzadılma barədə qeyd": widths[i] = 200f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "Sənədin nömrəsi": widths[i] = 100f; break;
                        case "Sənədin tarixi": widths[i] = 100f; break;
                        case "Haradan daxil olub": widths[i] = 110f; break;
                        case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)": widths[i] = 100f; break;
                        case "Vətəndaşın sosial statusu": widths[i] = 100f; break;
                        case "Müraciətin forması": widths[i] = 100f; break;
                        case "Müraciətin növü": widths[i] = 100f; break;
                        case "Mövzu": widths[i] = 100f; break;
                        case "Alt Mövzu": widths[i] = 100f; break;
                        case "Şikayət olunan qurum": widths[i] = 100f; break;
                        case "Şikayət olunan alt qurum": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                        case "Sənədin icraçısı": widths[i] = 100f; break;
                      
                        case "Cavab sənədinin nömrəsi": widths[i] = 100f; break;
                        case "Cavab sənədinin tarixi": widths[i] = 100f; break;
                        case "Müraciətlərə baxılmasının vəziyyəti": widths[i] = 100f; break;
                        case "Rayon/Şəhər": widths[i] = 100f; break;
                        case "Kənd": widths[i] = 100f; break;
                        default:
                            widths[i] = 70f;
                            break;
                    }
                }
                else
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №": widths[i] = 50f; break;
                        case "Qeydiyyat nömrəsi": widths[i] = 100f; break;
                        case "Qeydiyyat tarixi": widths[i] = 100f; break;
                        case "İcra müddəti": widths[i] = 100f; break;
                        case "İcra müddəti(təqvim günü)": widths[i] = 100f; break;
                        case "Uzadılma barədə qeyd": widths[i] = 200f; break;
                        case "Neçə gün gecikmə ilə icra olunub": widths[i] = 100f; break;
                        case "Sənədin statusu": widths[i] = 100f; break;
                        case "Sənədin nömrəsi": widths[i] = 100f; break;
                        case "Sənədin tarixi": widths[i] = 100f; break;
                        case "Haradan daxil olub": widths[i] = 110f; break;
                        case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)": widths[i] = 100f; break;
                        case "Nəzarətə götürən şəxs": widths[i] = 100f; break;
                        case "Vətəndaşın sosial statusu": widths[i] = 100f; break;
                        case "Müraciətin forması": widths[i] = 100f; break;
                        case "Müraciətin növü": widths[i] = 100f; break;
                        case "Mövzu": widths[i] = 100f; break;
                        case "Alt Mövzu": widths[i] = 100f; break;
                        case "Şikayət olunan qurum": widths[i] = 100f; break;
                        case "Şikayət olunan alt qurum": widths[i] = 100f; break;
                        case "Sənədin qısa məzmunu": widths[i] = 200f; break;
                        case "İcraçı struktur bölmə": widths[i] = 150f; break;
                        case "Sənədin icraçısı": widths[i] = 100f; break;
                        case "Sənədin icraçısı (şöbənin əməkdaşı)": widths[i] = 100f; break;

                        
                        case "Cavab sənədinin nömrəsi": widths[i] = 100f; break;
                        case "Cavab sənədinin tarixi": widths[i] = 100f; break;
                        case "Cavab sənədinin statusu": widths[i] = 100f; break;
                        case "Əlaqəli sənədlər": widths[i] = 100f; break;
                        case "Müraciətlərə baxılmasının vəziyyəti": widths[i] = 100f; break;
                        case "Rayon/Şəhər": widths[i] = 100f; break;
                        case "Kənd": widths[i] = 100f; break;
                        case "Nəzarət": widths[i] = 80f; break;

                        default:
                            widths[i] = 70f;
                            break;
                    }
                }
                
            }
            #endregion

            table.SetWidths(widths);
            //Table header
            Font fntColumnHeader = new Font(baseFont, 6, 1, BaseColor.WHITE);
            for (int i = 0; i < objHeaders.Count; i++)
            {
                addCell(table, objHeaders[i], 2);
            }

            #region AddDataToPDFGrid
            int counter = 0;
            foreach (var item in reportIsExecutedDocs)
            {
                counter++;
                if (reportIsExecutionDocsFilter.docTypeId == 1)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.HasValue ? item.DocEnterDate.Value.ToShortDateString() : "", 1);
                    addCell(table, item.PlannedDate.HasValue ? item.PlannedDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.ExecutionDays.ToString(), 1);
                    addCell(table, item.DirectionChangeNote, 1);
                    addCell(table, item.LatelyExecutedDays.HasValue ? item.LatelyExecutedDays.Value.ToString() : "", 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.DocFormName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, item.ExecutorDepartment, 1);
                    addCell(table, item.NotExecutedExecutorsName, 1);
                    addCell(table, item.LastExecutorName, 1);
                   
                    addCell(table, item.ReplyDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, item.ReplyDocDate.HasValue ? item.ReplyDocDate.Value.ToShortDateString() : "", 1);
                    //addCell(table, Convert.ToString(item.ReplyDocDate), 1);
                    addCell(table, item.ReplyDocStatus?.Replace(',', '\n'), 1);
                    addCell(table, item.RelationDocNumbers, 1);
                    addCell(table, item.DocUnderControlStatusValue, 1);

                }
                else if (reportIsExecutionDocsFilter.docTypeId == 2)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.HasValue ? item.DocEnterDate.Value.ToShortDateString() : "", 1);
                    addCell(table, item.PlannedDate.HasValue ? item.PlannedDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.ExecutionDays.ToString(), 1);
                    addCell(table, item.DirectionChangeNote, 1);
                    addCell(table, item.LatelyExecutedDays.HasValue ? item.LatelyExecutedDays.Value.ToString() : "", 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.EntryFromWhoCitizenName) ? "" : item.EntryFromWhoCitizenName.Replace(',', '\n'), 1);
                    addCell(table, item.EntryFromWho, 1);
                    addCell(table, item.SocialName, 1);
                    addCell(table, item.DocFormName, 1);
                    addCell(table, item.ApplyTypeName, 1);
                    addCell(table, item.TopicName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.ComplainedOfDocStructure, 1);
                    addCell(table, item.ComplainedOfDocSubStructure, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, item.ExecutorDepartment, 1);
                    addCell(table, item.NotExecutedExecutorsName, 1);
                    addCell(table, item.LastExecutorName, 1);

                    addCell(table, item.ReplyDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, item.ReplyDocDate.HasValue ? item.ReplyDocDate.Value.ToShortDateString() : "", 1);
                    //addCell(table, Convert.ToString(item.ReplyDocDate), 1);
                    addCell(table, item.ReplyDocStatus?.Replace(',', '\n'), 1);
                    addCell(table, item.RelationDocNumbers, 1);
                    addCell(table, item.DocResultName, 1);
                    addCell(table, item.RegionName, 1);
                    addCell(table, item.VillageName, 1);
                    addCell(table, item.DocUnderControlStatusValue, 1);


                }
                else if (reportIsExecutionDocsFilter.docTypeId == 27)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.HasValue ? item.DocEnterDate.Value.ToShortDateString() : "", 1);
                    addCell(table, item.PlannedDate.HasValue ? item.PlannedDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.ExecutionDays.ToString(), 1);
                    addCell(table, item.DirectionChangeNote, 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.EntryFromWhoCitizenName) ? "" : item.EntryFromWhoCitizenName.Replace(',', '\n'), 1);
                    addCell(table, item.SocialName, 1);
                    addCell(table, item.DocFormName, 1);
                    addCell(table, item.ApplyTypeName, 1);
                    addCell(table, item.TopicName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.ComplainedOfDocStructure, 1);
                    addCell(table, item.ComplainedOfDocSubStructure, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, item.ExecutorDepartment, 1);
                 
                    addCell(table, item.ReplyDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, item.ReplyDocDate.HasValue ? item.ReplyDocDate.Value.ToShortDateString() : "", 1);
                    //addCell(table, Convert.ToString(item.ReplyDocDate), 1);
                    addCell(table, item.DocResultName, 1);
                    addCell(table, item.RegionName, 1);
                    addCell(table, item.VillageName, 1);
                }
                else
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.HasValue ? item.DocEnterDate.Value.ToShortDateString() : "", 1);
                    addCell(table, item.LastExecutorName, 1);
                    addCell(table, item.PlannedDate.HasValue ? item.PlannedDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.ExecutionDays.ToString(), 1);
                    addCell(table, item.DirectionChangeNote, 1);
                    addCell(table, item.LatelyExecutedDays.HasValue ? item.LatelyExecutedDays.Value.ToString() : "", 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, string.IsNullOrWhiteSpace(item.EntryFromWhoCitizenName) ? "" : item.EntryFromWhoCitizenName.Replace(',', '\n'), 1);
                    addCell(table, item.EntryFromWho, 1);
                    addCell(table, item.SocialName, 1);
                    addCell(table, item.DocFormName, 1);
                    addCell(table, item.ApplyTypeName, 1);
                    addCell(table, item.TopicName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.ComplainedOfDocStructure, 1);
                    addCell(table, item.ComplainedOfDocSubStructure, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table, item.ExecutorDepartment, 1);
                    addCell(table, item.NotExecutedExecutorsName, 1);
                 
                    addCell(table, item.ReplyDocNumbers?.Replace(',', '\n'), 1);
                    addCell(table, item.ReplyDocDate.HasValue ? item.ReplyDocDate.Value.ToShortDateString() : "", 1);
                    //addCell(table, Convert.ToString(item.ReplyDocDate), 1);
                    addCell(table, item.ReplyDocStatus?.Replace(',', '\n'), 1);
                    addCell(table, item.RelationDocNumbers, 1);
                    addCell(table, item.DocResultName, 1);
                    addCell(table, item.RegionName, 1);
                    addCell(table, item.VillageName, 1);
                    addCell(table, item.DocUnderControlStatusValue, 1);
                }
            }
            #endregion

            document.Add(table);
            document.Close();
            writer.Close();
            fs.Close();
        }
        #endregion
        #region ForInformation

        internal static void ExportForInformationDocsToPdf(IEnumerable<ReportForInformationDocsModel> reportForInformationDocs, List<string> objHeaders,
            string pdfPath, ReportPdfHeading pdfHeading,
            DateTime startDate, DateTime endDate, ReportForInformationDocsFilter reportForInformationDocsFilter)
        {
            FileStream fs = new FileStream(pdfPath, FileMode.Create, FileAccess.Write, FileShare.None);
            Document document = new Document();
            document.SetPageSize(PageSize.A4.Rotate());
            PdfWriter writer = PdfWriter.GetInstance(document, fs);
            document.Open();

            //Report Header

            ////Create a base font object making sure to specify IDENTITY-H
            Font fntHead = new Font(baseFont, 16, 2, BaseColor.GRAY);
            Paragraph prgHeading = new Paragraph();
            prgHeading.Alignment = Element.ALIGN_CENTER;
            prgHeading.Add(new Chunk(pdfHeading.CurrentOrganizationName, fntHead));
            if (!string.IsNullOrWhiteSpace(pdfHeading.TargetName))
            {
                prgHeading.Add(new Chunk("\n\n" + pdfHeading.TargetName, fntHead));
            }

            prgHeading.Add(new Chunk("\n\nHesabat", fntHead));
            document.Add(prgHeading);

            var department = SessionHelper.DepartmentPositionName;
            //Author
            Paragraph prgAuthor = new Paragraph();
            Font fntAuthor = new Font(baseFont, 8, 2, BaseColor.GRAY);
            prgAuthor.Alignment = Element.ALIGN_RIGHT;

            switch (reportForInformationDocsFilter.docTypeId)
            {
                case 1:
                    prgAuthor.Add(new Chunk("\nSənədin növü: " + "Təşkilat müraciətləri", fntAuthor));
                    break;
                case 2:
                    prgAuthor.Add(new Chunk("\nSənədin növü: " + "Vətəndaş müraciətləri", fntAuthor));
                    break;
                case 3:
                    prgAuthor.Add(new Chunk("\nSənədin növü: " + "Sərəncamverici sənədlər", fntAuthor));
                    break;
                case 4:
                    prgAuthor.Add(new Chunk("\nSənədin növü: " + "Xaric olan sənədlər", fntAuthor));
                    break;
                case 18:
                    prgAuthor.Add(new Chunk("\nSənədin növü: " + "Xidməti məktublar", fntAuthor));
                    break;
                case 27:
                    prgAuthor.Add(new Chunk("\nSənədin növü: " + "Əməkdaş müraciətləri", fntAuthor));
                    break;
                default:
                    break;
            }

            prgAuthor.Add(new Chunk(
                ("\nMəlumat xarakterli sənədlər" + " (" + startDate.ToShortDateString() + "-" + endDate.ToShortDateString() + ") "),
                fntAuthor));
            // prgAuthor.Add(new Chunk("\nBaşlanğıc tarix : " + startDate.ToShortDateString(), fntAuthor));
            // prgAuthor.Add(new Chunk("\nYekun tarix : " + endDate.ToShortDateString(), fntAuthor));
            document.Add(prgAuthor);

            //Add a line seperation
            Paragraph p =
                new Paragraph(new Chunk(new LineSeparator(0.0F, 100.0F, BaseColor.BLACK, Element.ALIGN_LEFT, 1)));
            document.Add(p);

            //Add line break
            document.Add(new Chunk("\n", fntHead));

            //Write the table
            PdfPTable table = new PdfPTable(objHeaders.Count);

            table.HorizontalAlignment = 0;
            table.TotalWidth = 770f;
            table.LockedWidth = true;
            float[] widths = new float[objHeaders.Count];

            #region GetObjectHeaders

            for (int i = 0; i < objHeaders.Count; i++)
            {
                if (reportForInformationDocsFilter.docTypeId == 1)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №":
                            widths[i] = 50f;
                            break;
                        case "Qeydiyyat nömrəsi":
                            widths[i] = 100f;
                            break;
                        case "Qeydiyyat tarixi":
                            widths[i] = 100f;
                            break;

                        case "Sənədin statusu":
                            widths[i] = 100f;
                            break;
                        case "Sənədin nömrəsi":
                            widths[i] = 100f;
                            break;
                        case "Sənədin tarixi":
                            widths[i] = 100f;
                            break;
                        case "Haradan daxil olub":
                            widths[i] = 110f;
                            break;
                        case "Sənədin növü":
                            widths[i] = 100f;
                            break;
                        case "Mövzu":
                            widths[i] = 100f;
                            break;
                        case "Sənədin qısa məzmunu":
                            widths[i] = 200f;
                            break;
                        case "Struktur bölmə":
                            widths[i] = 150f;
                            break;
                        case "Əlaqəli sənədlər":
                            widths[i] = 100f;
                            break;
                        default:
                            widths[i] = 70f;
                            break;
                    }
                }
                else if (reportForInformationDocsFilter.docTypeId == 2)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №":
                            widths[i] = 50f;
                            break;
                        case "Qeydiyyat nömrəsi":
                            widths[i] = 100f;
                            break;
                        case "Qeydiyyat tarixi":
                            widths[i] = 100f;
                            break;

                        case "Sənədin statusu":
                            widths[i] = 100f;
                            break;
                        case "Sənədin nömrəsi":
                            widths[i] = 100f;
                            break;
                        case "Sənədin tarixi":
                            widths[i] = 100f;
                            break;
                        case "Haradan daxil olub":
                            widths[i] = 110f;
                            break;
                        case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)":
                            widths[i] = 100f;
                            break;

                        case "Vətəndaşın sosial statusu":
                            widths[i] = 100f;
                            break;
                        case "Müraciətin forması":
                            widths[i] = 100f;
                            break;
                        case "Müraciətin növü":
                            widths[i] = 100f;
                            break;
                        case "Mövzu":
                            widths[i] = 100f;
                            break;
                        case "Alt Mövzu":
                            widths[i] = 100f;
                            break;
                        case "Şikayət olunan qurum":
                            widths[i] = 100f;
                            break;
                        case "Şikayət olunan alt qurum":
                            widths[i] = 100f;
                            break;
                        case "Sənədin qısa məzmunu":
                            widths[i] = 200f;
                            break;
                        case "Struktur bölmə":
                            widths[i] = 150f;
                            break;
                        case "Rayon/Şəhər":
                            widths[i] = 100f;
                            break;
                        case "Kənd":
                            widths[i] = 100f;
                            break;
                        case "Əlaqəli sənədlər":
                            widths[i] = 100f;
                            break;
                        default:
                            widths[i] = 70f;
                            break;
                    }
                }
                else if (reportForInformationDocsFilter.docTypeId == 27)
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №":
                            widths[i] = 50f;
                            break;
                        case "Qeydiyyat nömrəsi":
                            widths[i] = 100f;
                            break;
                        case "Qeydiyyat tarixi":
                            widths[i] = 100f;
                            break;
                        case "Sənədin statusu":
                            widths[i] = 100f;
                            break;
                        case "Sənədin nömrəsi":
                            widths[i] = 100f;
                            break;
                        case "Sənədin tarixi":
                            widths[i] = 100f;
                            break;
                        case "Haradan daxil olub":
                            widths[i] = 110f;
                            break;
                        case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)":
                            widths[i] = 100f;
                            break;
                        case "Vətəndaşın sosial statusu":
                            widths[i] = 100f;
                            break;
                        case "Müraciətin forması":
                            widths[i] = 100f;
                            break;
                        case "Müraciətin növü":
                            widths[i] = 100f;
                            break;
                        case "Mövzu":
                            widths[i] = 100f;
                            break;
                        case "Alt Mövzu":
                            widths[i] = 100f;
                            break;
                        case "Şikayət olunan qurum":
                            widths[i] = 100f;
                            break;
                        case "Şikayət olunan alt qurum":
                            widths[i] = 100f;
                            break;
                        case "Sənədin qısa məzmunu":
                            widths[i] = 200f;
                            break;
                        case "Struktur bölmə":
                            widths[i] = 150f;
                            break;
                        default:
                            widths[i] = 70f;
                            break;
                    }
                }
                else
                {
                    switch (objHeaders[i])
                    {
                        case "Sıra sayı №":
                            widths[i] = 50f;
                            break;
                        case "Qeydiyyat nömrəsi":
                            widths[i] = 100f;
                            break;
                        case "Qeydiyyat tarixi":
                            widths[i] = 100f;
                            break;
                        case "Sənədin statusu":
                            widths[i] = 100f;
                            break;
                        case "Sənədin nömrəsi":
                            widths[i] = 100f;
                            break;
                        case "Sənədin tarixi":
                            widths[i] = 100f;
                            break;
                        case "Haradan daxil olub":
                            widths[i] = 110f;
                            break;
                        case "Kimdən daxil olub (Vətəndaşın adı, soyadı, ata adı)":
                            widths[i] = 100f;
                            break;
                        case "Vətəndaşın sosial statusu":
                            widths[i] = 100f;
                            break;
                        case "Müraciətin forması":
                            widths[i] = 100f;
                            break;
                        case "Müraciətin növü":
                            widths[i] = 100f;
                            break;
                        case "Mövzu":
                            widths[i] = 100f;
                            break;
                        case "Alt Mövzu":
                            widths[i] = 100f;
                            break;
                        case "Şikayət olunan qurum":
                            widths[i] = 100f;
                            break;
                        case "Şikayət olunan alt qurum":
                            widths[i] = 100f;
                            break;
                        case "Sənədin qısa məzmunu":
                            widths[i] = 200f;
                            break;
                        case "Struktur bölmə":
                            widths[i] = 150f;
                            break;
                        case "Əlaqəli sənədlər":
                            widths[i] = 100f;
                            break;
                        case "Rayon/Şəhər":
                            widths[i] = 100f;
                            break;
                        case "Kənd":
                            widths[i] = 100f;
                            break;
                        default:
                            widths[i] = 70f;
                            break;
                    }
                }
            }
            #endregion

            table.SetWidths(widths);
            //Table header
            Font fntColumnHeader = new Font(baseFont, 6, 1, BaseColor.WHITE);
            for (int i = 0; i < objHeaders.Count; i++)
            {
                addCell(table, objHeaders[i], 2);
            }

            #region AddingDataToPdfGrid

            int counter = 0;
            foreach (var item in reportForInformationDocs)
            {
                counter++;
                if (reportForInformationDocsFilter.docTypeId == 1)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToString("dd.MM.yyyy"), 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.FormName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table,
                        string.IsNullOrWhiteSpace(item.ExecutorsDepartments)
                            ? ""
                            : item.ExecutorsDepartments.Replace(',', '\n'), 1);
                    addCell(table, item.RelationDocNumbers, 1);
                }
                else if (reportForInformationDocsFilter.docTypeId == 2)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToString("dd.MM.yyyy"), 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.EntryFromWhoCitizenName, 1);
                    addCell(table, item.SocialName, 1);
                    addCell(table, item.FormName, 1);
                    addCell(table, item.ApplyTypeName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.TopicName, 1);
                    addCell(table, item.ComplainedOfDocStructure, 1);
                    addCell(table, item.ComplainedOfDocSubStructure, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table,
                        string.IsNullOrWhiteSpace(item.ExecutorsDepartments)
                            ? ""
                            : item.ExecutorsDepartments.Replace(',', '\n'), 1);

                    addCell(table, item.RegionName, 1);
                    addCell(table, item.VillageName, 1);
                    addCell(table, item.RelationDocNumbers, 1);
                }
                else if (reportForInformationDocsFilter.docTypeId == 27)
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToString("dd.MM.yyyy"), 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.EntryFromWhoCitizenName, 1);
                    addCell(table, item.SocialName, 1);
                    addCell(table, item.FormName, 1);
                    addCell(table, item.ApplyTypeName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.TopicName, 1);
                    addCell(table, item.ComplainedOfDocStructure, 1);
                    addCell(table, item.ComplainedOfDocSubStructure, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table,
                        string.IsNullOrWhiteSpace(item.ExecutorsDepartments)
                            ? ""
                            : item.ExecutorsDepartments.Replace(',', '\n'), 1);
                }
                else
                {
                    addCell(table, counter.ToString(), 1);
                    addCell(table, item.DocEnterno.ToString(), 1);
                    addCell(table, item.DocEnterDate.ToShortDateString(), 1);
                    addCell(table, item.DocumentStatusName, 1);
                    addCell(table, item.DocDocno, 1);
                    addCell(table, item.DocDocDate.HasValue ? item.DocDocDate.Value.ToString("dd.MM.yyyy") : "", 1);
                    addCell(table, item.EntryFromWhere, 1);
                    addCell(table, item.EntryFromWhoCitizenName, 1);
                    addCell(table, item.SocialName, 1);
                    addCell(table, item.FormName, 1);
                    addCell(table, item.ApplyTypeName, 1);
                    addCell(table, item.TopicTypeName, 1);
                    addCell(table, item.TopicName, 1);
                    addCell(table, item.ComplainedOfDocStructure, 1);
                    addCell(table, item.ComplainedOfDocSubStructure, 1);
                    addCell(table, item.DocDescription, 1);
                    addCell(table,
                        string.IsNullOrWhiteSpace(item.ExecutorsDepartments)
                            ? ""
                            : item.ExecutorsDepartments.Replace(',', '\n'), 1);
                    addCell(table, item.RegionName, 1);
                    addCell(table, item.VillageName, 1);
                    addCell(table, item.RelationDocNumbers, 1);
                }
            }

            #endregion

            document.Add(table);
            document.Close();
            writer.Close();
            fs.Close();
        }

        #endregion

        #region Methods
        internal static float[] GetHeaderWidths(Font font, params string[] headers)
        {
            var total = 0;
            var columns = headers.Length;
            var widths = new int[columns];
            for (var i = 0; i < columns; ++i)
            {
                var w = font.GetCalculatedBaseFont(true).GetWidth(headers[i]);
                total += w;
                widths[i] = w;
            }
            var result = new float[columns];
            for (var i = 0; i < columns; ++i)
            {
                result[i] = (float)widths[i] / total * 100;
            }
            return result;
        }

        static void addCell(PdfPTable table, string text, int rowspan)
        {
            Font times = new Font(baseFont, 6, Font.NORMAL, BaseColor.BLACK);

            PdfPCell cell = new PdfPCell(new Phrase(text, times));
            cell.Rowspan = rowspan;
            cell.HorizontalAlignment = PdfPCell.ALIGN_CENTER;

            cell.VerticalAlignment = PdfPCell.ALIGN_MIDDLE;
            table.AddCell(cell);
        }
        #endregion
    }
}
