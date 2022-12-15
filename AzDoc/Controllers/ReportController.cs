using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using AppCore.Interfaces;
using AzDoc.App_Start;
using AzDoc.Attributes;
using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Adapters;
using BLL.Models.Report;
using BLL.Models.Report.Filter;
using ClosedXML.Excel;
using Newtonsoft.Json;
using Repository.Infrastructure;

namespace AzDoc.Controllers
{
    public class ReportController : BaseController
    {

        private int _CurrentPage = 1;

        public ReportController(IUnitOfWork unitOfWork) : base(unitOfWork) { }

        // GET: Report
        public ActionResult Home()
        {
            //if (!new int[] { 2, 23, 430, 431, 24, 480, 270, 5017 }.Contains(SessionHelper.WorkPlaceId))
            //{
            //    return Redirect("/Logout");
            //}
            //else
            //{
            //}

            return View();
        }

        [HttpGet]
        public ActionResult DashBoard(int? docTypeId)
        {
            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                DashboardViewModel model = new DashboardViewModel(adapter, docTypeId, SessionHelper.WorkPlaceId);

                ViewBag.json = JsonConvert.SerializeObject(model);
                //return Json(model, JsonRequestBehavior.AllowGet);
                return PartialView("Dashboard", model);
            }
        }

        [HttpGet]
        public ActionResult Reports()
        {
            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                ReportsViewModel model = new ReportsViewModel(adapter, SessionHelper.WorkPlaceId);
                return PartialView("Reports", model);
            }

        }

        [HttpGet]
        public ActionResult ReportsDoc(DateInterval interval, int? docTypeId, int? documentStatus, int? resultOfExecution)
        {

            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                ReportsViewModel model = new ReportsViewModel(adapter, SessionHelper.WorkPlaceId, interval.Start, interval.End, docTypeId, documentStatus, resultOfExecution);
                if (interval.Start != null && interval.End != null)
                {
                    ViewData["ReportsSelect"] = interval.Start.Value.ToShortDateString() + " - " + interval.End.Value.ToShortDateString();

                }

                return PartialView("ReportGrid", model);
            }
        }

        [HttpGet]
        public ActionResult ReportsForm(DateInterval interval, int reportId)
        {

            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                ReportsViewModel model = new ReportsViewModel(adapter, SessionHelper.WorkPlaceId, interval.Start, interval.End, reportId);
                if (interval.Start != null && interval.End != null)
                {
                    ViewData["ReportsSelect"] = interval.Start.Value.ToShortDateString() + " - " + interval.End.Value.ToShortDateString();
                }

                if (reportId == 2)
                    return PartialView("ReportGridForm1", model);
                else
                    return PartialView("ReportGridForm2", model);
            }
        }

        #region ReportDocsMain

        [HttpGet]
        public JsonResult GetReportDropDownModel(/*int executorOrganizationType = -1*/)
        {
            int executorOrganizationType = -1;
            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                ReportDropDownModel model = new ReportDropDownModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, executorOrganizationType);
                var jsonResult = Json(model, JsonRequestBehavior.AllowGet);
                jsonResult.MaxJsonLength = int.MaxValue;
                return jsonResult;
            }
        }

        [HttpGet]
        public FileResult Download(string filename)
        {
            var path = Server.MapPath("~/App_Data/ReportDataExcell");

            if (string.IsNullOrWhiteSpace(filename))
                throw new ArgumentNullException();
            else if (!System.IO.File.Exists(Path.Combine(path, filename + ".xlsx")))
                throw new ArgumentNullException();

            using (var workbook = new XLWorkbook(Path.Combine(path, filename + ".xlsx")))
            using (var stream = new MemoryStream())
            {
                workbook.SaveAs(stream);
                var buffer = stream.ToArray();
                //   System.IO.File.Delete(Path.Combine(path, filename + ".xlsx"));

                HttpContext.Response.Headers.Add("Content-Disposition", "attachment; filename=\"HesabatExcell.xlsx\"");
                return File(buffer, System.Net.Mime.MediaTypeNames.Application.Octet);
            }
        }
        [HttpGet]
        public ActionResult DownloadPdf(string filename)
        {
            var path = Server.MapPath("~/App_Data/ReportDataPDF");


            if (string.IsNullOrWhiteSpace(filename))
                throw new ArgumentNullException();
            else if (!System.IO.File.Exists(Path.Combine(path, filename + ".pdf")))
                throw new ArgumentNullException();

            string fileFullPath = Path.Combine(path, filename + ".pdf");
            Response.ClearContent();
            Response.Clear();
            Response.AddHeader("Content-Disposition", "attachment; filename=" + "HesabatPdf.pdf");
            Response.ContentType = "application/download";
            Response.WriteFile(fileFullPath);
            Response.End();
            return null;
        }
        #endregion

        #region ReportInExecutionDocs

        [HttpGet]
        public ActionResult ReportInExecutionDocsMain()
        {
            return PartialView("_ReportInExecutionDocsMain");
        }
        [HttpGet]
        public ActionResult ReportInExecutionDocs(DateInterval intervalDate, ReportInExecutionDocsFilter reportInExecutionDocsFilter)
        {
            if (reportInExecutionDocsFilter.currentPage == null || !int.TryParse(reportInExecutionDocsFilter.currentPage, out _CurrentPage))
            {
                _CurrentPage = 1;
            }
            reportInExecutionDocsFilter.beginDate = intervalDate.Start;
            reportInExecutionDocsFilter.endDate = intervalDate.End;

            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                ReportInExecutionDocsBodyViewModel model = new ReportInExecutionDocsBodyViewModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, reportInExecutionDocsFilter, _CurrentPage);

                if (reportInExecutionDocsFilter.docTypeId == 1)
                {
                    return PartialView("_ReportOrganizationtInExecutionDocsBody", model);
                }
                else if (reportInExecutionDocsFilter.docTypeId == 2)
                {
                    return PartialView("_ReportInExecutionDocsBody", model);
                }
                else if (reportInExecutionDocsFilter.docTypeId == 27)
                {
                    return PartialView("_ReportInExecutionDocsEmployeeAppealsDocsBody", model);
                }
                else
                {
                    return PartialView("_ReportInExecutionDocsBody", model);
                }               
            }
        }

        #region Excell or PDF

        [HttpGet]
        public ActionResult ReportInExecutionDocsExcellServerSide(List<string> objHeaders, DateInterval intervalDate, ReportInExecutionDocsFilter reportInExecutionDocsFilter)
        {
            reportInExecutionDocsFilter.beginDate = intervalDate.Start;
            reportInExecutionDocsFilter.endDate = intervalDate.End;

            ClosedXmlExcellHelper excellHelper = new ClosedXmlExcellHelper();
            ReportInExecutionDocsBodyViewModel result = new ReportInExecutionDocsBodyViewModel();
            ReportPdfOrExcelModel excelHeading = new ReportPdfOrExcelModel();
            ReportPdfHeading reportExcel = new ReportPdfHeading();


            var filename = "";
            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                result = new ReportInExecutionDocsBodyViewModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, reportInExecutionDocsFilter);
                #region excelHeading
                excelHeading = new ReportPdfOrExcelModel(adapter, SessionHelper.OrganizationId, reportInExecutionDocsFilter.executorOrganizationType, reportInExecutionDocsFilter.organizationDepartmentOrOrganizations); // qurumun adini goturub oba uygun olaraq hansi qurumdan hansi quruma hesabat chixarildigini teyin edirem
                #endregion
            }

            if (result.ReportInExecutionDocsModel.Count() == 0)
                throw new Exception("Heç bir məlumat tapılmadı.");

            #region excell
            List<string> headers = objHeaders;

            using (var workbook = new XLWorkbook())
            using (var stream = new MemoryStream())
            {
                var sheet = workbook.AddWorksheet("Hesabat İcrada olan sənədlər");


                if (!string.IsNullOrWhiteSpace(excelHeading.ReportPdf.TargetName))
                {
                    sheet.Cell("A1").Value = excelHeading.ReportPdf.CurrentOrganizationName + "(" + excelHeading.ReportPdf.TargetName + ")"; 
                }
                else
                {
                    sheet.Cell("A1").Value = excelHeading.ReportPdf.CurrentOrganizationName;
                }

                switch (reportInExecutionDocsFilter.docTypeId)
                {
                    case 1: sheet.Cell("C1").Value = "(" + "Təşkilat müraciətləri" + ")"; break;
                    case 2: sheet.Cell("C1").Value = "(" + "Vətəndaş müraciətləri" + ")"; break;
                    case 3: sheet.Cell("C1").Value = "(" + "Sərəncamverici sənədlər" + ")"; break;
                    case 4: sheet.Cell("C1").Value = "(" + "Xaric olan sənədlər" + ")"; break;
                    case 18: sheet.Cell("C1").Value = "(" + "Xidməti məktublar" + ")"; break;
                    case 27: sheet.Cell("C1").Value = "(" + "Əməkdaş müraciətləri" + ")"; break;
                    default:
                        break;
                }

                //switch (reportInExecutionDocsFilter.remaningDay)
                //{
                //    case -1: sheet.Cell("C1").Value = "İcrada olan sənədlər"; break;
                //    case 1: sheet.Cell("C1").Value = "İcra vaxtının bitməsinə 1 gün qalmış sənədlər"; break;
                //    case 3: sheet.Cell("C1").Value = "İcra vaxtının bitməsinə 3 gün qalmış sənədlər"; break;
                //    case 5: sheet.Cell("C1").Value = "İcra vaxtının bitməsinə 5 gün qalmış sənədlər"; break;
                //    case 6: sheet.Cell("C1").Value = "Icraatda olan sənədlər"; break;
                //    case 0: sheet.Cell("C1").Value = "Gecikmiş sənədlər"; break;
                //    default:
                //        break;
                //}

                sheet.Cell("A2").Value = "İcrada olan sənədlər " + "(" + reportInExecutionDocsFilter.beginDate.Value.ToShortDateString()
                                         + " - " + reportInExecutionDocsFilter.endDate.Value.ToShortDateString() + ")";

                sheet.Range("A1:B1").Merge();
                sheet.Range("C1:D1").Merge();

                sheet.Rows(1,2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                sheet.Rows(1,2).Style.Font.Bold = true;
                sheet.Rows(1,2).Style.Font.Italic = true;
                sheet.Columns().Width = 20;


                int rowStart = 3;

                for (int i = 0; i < headers.Count; i++)
                {
                    sheet.Cell(rowStart, i + 1).Value = headers[i];
                    sheet.Cell(rowStart, i + 1).Style = XLWorkbook.DefaultStyle;
                    sheet.Cell(rowStart, i + 1).Style.Fill.BackgroundColor = XLColor.Gray;
                    sheet.Cell(rowStart, i + 1).Style.Font.Bold = true;

                }
                sheet.Columns().AdjustToContents();
                sheet.Rows().AdjustToContents();
                rowStart++;
                int counter = 0;
                foreach (var item in result.ReportInExecutionDocsModel)
                {
                    for (int i = 0; i < headers.Count; i++)
                    {
                        var fieldName = "";
                        if (reportInExecutionDocsFilter.docTypeId == 1)
                        {
                            fieldName = excellHelper.GetFieldNameForOrganizationInExecutionDocs(headers[i]);
                        }
                        else if (reportInExecutionDocsFilter.docTypeId == 2)
                        {
                            fieldName = excellHelper.GetFieldNameForCitizenRequestInExecutionDocs(headers[i]);
                        }
                        else if (reportInExecutionDocsFilter.docTypeId == 27)
                        {
                            fieldName = excellHelper.GetFieldNameForEmployeeAppealsInExecutionDocs(headers[i]);
                        }
                        else
                        {
                            fieldName = excellHelper.GetFieldNameForAllDocTypesInExecutionDocs(headers[i]);
                        }
                        var data = item.GetType().GetProperty(fieldName).GetValue(item)?.ToString();


                        if (fieldName.ToString() == "DocEnterno" || fieldName.ToString() == "ReplyDocNumbers")
                        {
                            sheet.Cell(rowStart, i + 1).SetValue(Convert.ToString(data));
                        }
                        else if (fieldName.ToString() == "DocId")
                        {
                            sheet.Cell(rowStart, i + 1).Value = ++counter;
                        }
                        else
                        {
                            sheet.Cell(rowStart, i + 1).Value = data;
                        }

                    }
                    rowStart++;
                }

                var folderNameWithPath = Path.Combine(Server.MapPath("~/App_Data"), "ReportDataExcell");

                if (!Directory.Exists(folderNameWithPath))
                {
                    Directory.CreateDirectory(folderNameWithPath);
                }

                string guid = Guid.NewGuid().ToString();
                filename = guid;
                string fileFullPath = Path.Combine(folderNameWithPath, guid + ".xlsx");
                /*Server.MapPath($"~/App_Data/{fileName}.xlsx")*/
                workbook.SaveAs(fileFullPath);
            }
            #endregion
            return Json(new { fileName = filename, Error = false }, JsonRequestBehavior.AllowGet);
        }

       

        [HttpGet]
        public ActionResult ReportInExecutionDocsPdfServerSide(List<string> objHeaders, DateInterval intervalDate, ReportInExecutionDocsFilter reportInExecutionDocsFilter)
        {
            reportInExecutionDocsFilter.beginDate = intervalDate.Start;
            reportInExecutionDocsFilter.endDate = intervalDate.End;
            ReportInExecutionDocsBodyViewModel result = new ReportInExecutionDocsBodyViewModel();
            ReportPdfOrExcelModel pdfHeading = new ReportPdfOrExcelModel();
            var filename = "";
            try
            {
                using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
                {
                    result = new ReportInExecutionDocsBodyViewModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, reportInExecutionDocsFilter);
                    #region pdfHeading
                    pdfHeading = new ReportPdfOrExcelModel(adapter, SessionHelper.OrganizationId, reportInExecutionDocsFilter.executorOrganizationType, reportInExecutionDocsFilter.organizationDepartmentOrOrganizations); // qurumun adini goturub oba uygun olaraq hansi qurumdan hansi quruma hesabat chixarildigini teyin edirem
                    #endregion
                }

                if (result.ReportInExecutionDocsModel.Count() == 0)
                    throw new Exception("Heç bir məlumat tapılmadı.");

                var folderNameWithPath = Path.Combine(Server.MapPath("~/App_Data"), "ReportDataPDF");
                if (!Directory.Exists(folderNameWithPath))
                {
                    Directory.CreateDirectory(folderNameWithPath);
                }
                string guid = Guid.NewGuid().ToString();
                filename = guid;
                string fileFullPath = Path.Combine(folderNameWithPath, guid + ".pdf");

                PdfHelper.ExportInExecutionDocsToPdf(result.ReportInExecutionDocsModel, objHeaders, fileFullPath, pdfHeading.ReportPdf, intervalDate.Start.Value, intervalDate.End.Value,
                    reportInExecutionDocsFilter);
            }
            catch (Exception ex)
            {
                throw;
            }
            return Json(new { fileName = filename, Error = false }, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #endregion

        #region  isExecutedDocs

        [HttpGet]
        public ActionResult ReportIsExecutedDocsMain()
        {
            return PartialView("_ReportIsExecutedDocsMain");
        }

        public ActionResult ReportIsExecutedDocs(DateInterval intervalDate, ReportIsExecutedDocsFilter reportIsExecutedDocsFilter)
        {
            if (reportIsExecutedDocsFilter.currentPage == null || !int.TryParse(reportIsExecutedDocsFilter.currentPage, out _CurrentPage))
            {
                _CurrentPage = 1;
            }
            reportIsExecutedDocsFilter.beginDate = intervalDate.Start;
            reportIsExecutedDocsFilter.endDate = intervalDate.End;

            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                var model = new ReportIsExecutedDocsBodyViewModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, reportIsExecutedDocsFilter, _CurrentPage);

                if (reportIsExecutedDocsFilter.docTypeId == 1)
                {
                    return PartialView("_ReportOrganizationIsExecutedDocsBody", model);
                }
                else if (reportIsExecutedDocsFilter.docTypeId == 2)
                {
                    return PartialView("_ReportIsExecutedDocsBody", model);
                }
                else if (reportIsExecutedDocsFilter.docTypeId == 27)
                { 
                    return PartialView("_ReportIsExecutedDocsEmployeeAppealsDocsBody", model);
                }
                else
                {
                    return PartialView("_ReportIsExecutedDocsBody", model);
                }               
            }
        }

        #region Excell or PDF

        [HttpGet]
        public ActionResult ReportIsExecutedDocsExcellServerSide(List<string> objHeaders, DateInterval intervalDate, ReportIsExecutedDocsFilter reportIsExecutedDocsFilter)
        {
            reportIsExecutedDocsFilter.beginDate = intervalDate.Start;
            reportIsExecutedDocsFilter.endDate = intervalDate.End;

            ClosedXmlExcellHelper excellHelper = new ClosedXmlExcellHelper();

            ReportIsExecutedDocsBodyViewModel result = new ReportIsExecutedDocsBodyViewModel();
            ReportPdfOrExcelModel excelHeading = new ReportPdfOrExcelModel();
            ReportPdfHeading reportExcel = new ReportPdfHeading();

            var filename = "";

            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                result = new ReportIsExecutedDocsBodyViewModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, reportIsExecutedDocsFilter);
                #region excelHeading
                excelHeading = new ReportPdfOrExcelModel(adapter, SessionHelper.OrganizationId, reportIsExecutedDocsFilter.executorOrganizationType, reportIsExecutedDocsFilter.organizationDepartmentOrOrganizations); // qurumun adini goturub oba uygun olaraq hansi qurumdan hansi quruma hesabat chixarildigini teyin edirem
                #endregion
            }

            if (result.IsExecutedDocs.Count() == 0)
                throw new Exception("Heç bir məlumat tapılmadı.");

            #region excell

            List<string> headers = objHeaders;

            using (var workbook = new XLWorkbook())
            using (var stream = new MemoryStream())
            {
                var sheet = workbook.AddWorksheet("Hesabat İcra olunmuş sənədlər");

                if (!string.IsNullOrWhiteSpace(excelHeading.ReportPdf.TargetName))
                {
                    sheet.Cell("A1").Value = excelHeading.ReportPdf.CurrentOrganizationName + "(" + excelHeading.ReportPdf.TargetName + ")";
                }
                else
                {
                    sheet.Cell("A1").Value = excelHeading.ReportPdf.CurrentOrganizationName;
                }

           
                switch (reportIsExecutedDocsFilter.docTypeId)
                {
                    case 1: sheet.Cell("C1").Value = "(" + "Təşkilat müraciətləri" + ")"; break;
                    case 2: sheet.Cell("C1").Value = "(" + "Vətəndaş müraciətləri" + ")"; break;
                    case 3: sheet.Cell("C1").Value = "(" + "Sərəncamverici sənədlər" + ")"; break;
                    case 4: sheet.Cell("C1").Value = "(" + "Xaric olan sənədlər" + ")"; break;
                    case 18: sheet.Cell("C1").Value = "(" + "Xidməti məktublar" + ")"; break;
                    case 27: sheet.Cell("C1").Value = "(" + "Əməkdaş müraciətləri" + ")"; break;
                    default:
                        break;
                }

                sheet.Cell("A2").Value = "İcra olunmuş sənədlər " + "(" + reportIsExecutedDocsFilter.beginDate.Value.ToShortDateString()
                                         + " - " + reportIsExecutedDocsFilter.endDate.Value.ToShortDateString() + ")";

                sheet.Range("A1:B1").Merge();
                sheet.Range("C1:D1").Merge();

                sheet.Rows(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                sheet.Rows(1, 2).Style.Font.Bold = true;
                sheet.Rows(1, 2).Style.Font.Italic = true;
                sheet.Columns().Width = 20;


                int rowStart = 3;

                for (int i = 0; i < headers.Count; i++)
                {
                    sheet.Cell(rowStart, i + 1).Value = headers[i];
                    sheet.Cell(rowStart, i + 1).Style = XLWorkbook.DefaultStyle;
                    sheet.Cell(rowStart, i + 1).Style.Fill.BackgroundColor = XLColor.Gray;
                    sheet.Cell(rowStart, i + 1).Style.Font.Bold = true;

                }
                sheet.Columns().AdjustToContents();
                sheet.Rows().AdjustToContents();
                rowStart++;
                int counter = 0;
                foreach (var item in result.IsExecutedDocs)
                {
                    for (int i = 0; i < headers.Count; i++)
                    {
                        var fieldName = "";
                        if (reportIsExecutedDocsFilter.docTypeId == 1)
                        {
                            fieldName = excellHelper.GetFieldNameForOrganizationReportIsExecutedDocs(headers[i]);
                        }
                        else if (reportIsExecutedDocsFilter.docTypeId == 2)
                        {
                            fieldName = excellHelper.GetFieldNameForCitizenRequestsReportIsExecutedDocs(headers[i]);
                        }
                        else if (reportIsExecutedDocsFilter.docTypeId == 27)
                        {
                            fieldName = excellHelper.GetFieldNameForEmployeeAppealsReportIsExecutedDocs(headers[i]);
                        }
                        else
                        {
                            fieldName = null;
                        }
                        var data = item.GetType().GetProperty(fieldName).GetValue(item)?.ToString();


                        if (fieldName.ToString() == "DocEnterno" || fieldName.ToString() == "ReplyDocNumbers")
                        {
                            sheet.Cell(rowStart, i + 1).SetValue<string>(Convert.ToString(data));
                        }
                        else if (fieldName.ToString() == "DocId")
                        {
                            sheet.Cell(rowStart, i + 1).Value = ++counter;
                        }
                        else
                        {
                            sheet.Cell(rowStart, i + 1).Value = data;
                        }

                    }
                    rowStart++;
                }

                var folderNameWithPath = Path.Combine(Server.MapPath("~/App_Data"), "ReportDataExcell");

                if (!Directory.Exists(folderNameWithPath))
                {
                    Directory.CreateDirectory(folderNameWithPath);
                }

                string guid = Guid.NewGuid().ToString();
                filename = guid;
                string fileFullPath = Path.Combine(folderNameWithPath, guid + ".xlsx");

                /*Server.MapPath($"~/App_Data/{fileName}.xlsx")*/
                workbook.SaveAs(fileFullPath);
            }

            #endregion
            return Json(new { fileName = filename, Error = false }, JsonRequestBehavior.AllowGet);
        }
        [HttpGet]
        public ActionResult ReportIsExecutedDocsPdfServerSide(List<string> objHeaders, DateInterval intervalDate, ReportIsExecutedDocsFilter reportIsExecutedDocsFilter)
        {
            reportIsExecutedDocsFilter.beginDate = intervalDate.Start;
            reportIsExecutedDocsFilter.endDate = intervalDate.End;
            ReportIsExecutedDocsBodyViewModel result = new ReportIsExecutedDocsBodyViewModel();
            ReportPdfOrExcelModel pdfHeading = new ReportPdfOrExcelModel();
            var filename = "";
            try
            {
                using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
                {
                    result = new ReportIsExecutedDocsBodyViewModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, reportIsExecutedDocsFilter);
                    #region pdfHeading
                    pdfHeading = new ReportPdfOrExcelModel(adapter, SessionHelper.OrganizationId, reportIsExecutedDocsFilter.executorOrganizationType, reportIsExecutedDocsFilter.organizationDepartmentOrOrganizations); // qurumun adini goturub oba uygun olaraq hansi qurumdan hansi quruma hesabat chixarildigini teyin edirem
                    #endregion
                }

                if (result.IsExecutedDocs.Count() == 0)
                    throw new Exception("Heç bir məlumat tapılmadı.");

                var folderNameWithPath = Path.Combine(Server.MapPath("~/App_Data"), "ReportDataPDF");
                if (!Directory.Exists(folderNameWithPath))
                {
                    Directory.CreateDirectory(folderNameWithPath);
                }
                string guid = Guid.NewGuid().ToString();
                filename = guid;
                string fileFullPath = Path.Combine(folderNameWithPath, guid + ".pdf");

                PdfHelper.ExportIsExecutedDocsToPdf(result.IsExecutedDocs, objHeaders, fileFullPath, reportIsExecutedDocsFilter.docTypeId.Value, pdfHeading.ReportPdf,
                    intervalDate.Start.Value, intervalDate.End.Value, reportIsExecutedDocsFilter);
            }
            catch (Exception ex)
            {
                throw;
            }
            return Json(new { fileName = filename, Error = false }, JsonRequestBehavior.AllowGet);
        }

        #endregion

        #endregion

        #region ReportForInformationDocs

        [HttpGet]
        public ActionResult ReportForInformationDocsMain()
        {
            return PartialView("_ReportForInformationDocsMain");
        }

        [HttpGet]
        public ActionResult ReportForInformationDocs(DateInterval intervalDate, ReportForInformationDocsFilter reportForInformationDocsFilter)
        {
            if (reportForInformationDocsFilter.currentPage == null || !int.TryParse(reportForInformationDocsFilter.currentPage, out _CurrentPage))
            {
                _CurrentPage = 1;
            }
            reportForInformationDocsFilter.beginDate = intervalDate.Start;
            reportForInformationDocsFilter.endDate = intervalDate.End;

            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                var model = new ReportForInformationDocsBodyViewModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, reportForInformationDocsFilter, _CurrentPage);

                if (reportForInformationDocsFilter.docTypeId == 1)
                {
                    return PartialView("_ReportForInformationOrganizationDocsBody", model);
                }
                else if (reportForInformationDocsFilter.docTypeId == 2)
                {
                    return PartialView("_ReportForInformationDocsBody", model);
                }
                else if (reportForInformationDocsFilter.docTypeId == 4)
                {
                    return PartialView("_ReportForInformationDocsBody", model);
                }
                else if (reportForInformationDocsFilter.docTypeId == 18)
                {
                    return PartialView("_ReportForInformationDocsBody", model);
                }
                else if (reportForInformationDocsFilter.docTypeId == 27)
                {
                    return PartialView("_ReportForInformationDocsEmployeeAppealsDocsBody", model);
                }
                else
                {
                    return PartialView("_ReportForInformationDocsBody", model);
                }
            }
        }

        [HttpGet]
        public ActionResult ReportForInformationDocsExcellServerSide(List<string> objHeaders, DateInterval intervalDate, ReportForInformationDocsFilter reportForInformationDocsFilter)
        {
            reportForInformationDocsFilter.beginDate = intervalDate.Start;
            reportForInformationDocsFilter.endDate = intervalDate.End;

            ClosedXmlExcellHelper excellHelper = new ClosedXmlExcellHelper();
            ReportForInformationDocsBodyViewModel result = new ReportForInformationDocsBodyViewModel();
            ReportPdfOrExcelModel excelHeading = new ReportPdfOrExcelModel();
            ReportPdfHeading reportExcel = new ReportPdfHeading();

            var filename = "";

            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                result = new ReportForInformationDocsBodyViewModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, reportForInformationDocsFilter);
                #region excelHeading
                excelHeading = new ReportPdfOrExcelModel(adapter, SessionHelper.OrganizationId, reportForInformationDocsFilter.executorOrganizationType, reportForInformationDocsFilter.organizationDepartmentOrOrganizations); // qurumun adini goturub oba uygun olaraq hansi qurumdan hansi quruma hesabat chixarildigini teyin edirem
                #endregion
            }

            if (result.ForInformationDocs.Count() == 0)
                throw new Exception("Heç bir məlumat tapılmadı.");

            #region excell

            List<string> headers = objHeaders;

            using (var workbook = new XLWorkbook())
            using (var stream = new MemoryStream())
            {
                var sheet = workbook.AddWorksheet("Bütün sənədlər hesabat");

                if (!string.IsNullOrWhiteSpace(excelHeading.ReportPdf.TargetName))
                {
                    sheet.Cell("A1").Value = excelHeading.ReportPdf.CurrentOrganizationName + "(" + excelHeading.ReportPdf.TargetName + ")";
                }
                else
                {
                    sheet.Cell("A1").Value = excelHeading.ReportPdf.CurrentOrganizationName;
                }

                switch (reportForInformationDocsFilter.docTypeId)
                {
                    case 1: sheet.Cell("C1").Value = "(" + "Təşkilat müraciətləri" + ")"; break;
                    case 2: sheet.Cell("C1").Value = "(" + "Vətəndaş müraciətləri" + ")"; break;
                    case 3: sheet.Cell("C1").Value = "(" + "Sərəncamverici sənədlər" + ")"; break;
                    case 4: sheet.Cell("C1").Value = "(" + "Xaric olan sənədlər" + ")"; break;
                    case 18: sheet.Cell("C1").Value = "(" + "Xidməti məktublar" + ")"; break;
                    case 27: sheet.Cell("C1").Value = "(" + "Əməkdaş müraciətləri" + ")"; break;
                    default:
                        break;
                }

                sheet.Cell("A2").Value = "Məlumat xarakterli sənədlər " + "(" + reportForInformationDocsFilter.beginDate.Value.ToShortDateString()
                                          + " - " + reportForInformationDocsFilter.endDate.Value.ToShortDateString() + ")";

                sheet.Range("A1:B1").Merge();
                sheet.Range("C1:D1").Merge();


                sheet.Rows(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                sheet.Rows(1, 2).Style.Font.Bold = true;
                sheet.Rows(1, 2).Style.Font.Italic = true;
                sheet.Columns().Width = 20;

                int rowStart = 3;

                for (int i = 0; i < headers.Count; i++)
                {
                    sheet.Cell(rowStart, i + 1).Value = headers[i];
                    sheet.Cell(rowStart, i + 1).Style = XLWorkbook.DefaultStyle;
                    sheet.Cell(rowStart, i + 1).Style.Fill.BackgroundColor = XLColor.Gray;
                    sheet.Cell(rowStart, i + 1).Style.Font.Bold = true;

                }
                sheet.Columns().AdjustToContents();
                sheet.Rows().AdjustToContents();
                rowStart++;
                int counter = 0;

                foreach (var item in result.ForInformationDocs)
                {
                    for (int i = 0; i < headers.Count; i++)
                    {
                        var fieldName = "";
                        if (reportForInformationDocsFilter.docTypeId == 1)
                        {
                            fieldName = excellHelper.GetFieldNameForOrganizationForInformationDocs(headers[i]);
                        }
                        else if (reportForInformationDocsFilter.docTypeId == 2)
                        {
                            fieldName = excellHelper.GetFieldNameForCitizenForInformationDocs(headers[i]);
                        }
                        else if (reportForInformationDocsFilter.docTypeId == 27)
                        {
                            fieldName = excellHelper.GetFieldNameForEmployeeAppealsForInformationDocs(headers[i]);
                        }
                        else
                        {
                            fieldName = null;
                        }

                        var data = item.GetType().GetProperty(fieldName).GetValue(item)?.ToString();


                        if (fieldName.ToString() == "DocEnterno" || fieldName.ToString() == "ReplyDocNumbers")
                        {
                            sheet.Cell(rowStart, i + 1).SetValue<string>(Convert.ToString(data));
                        }
                        else if (fieldName.ToString() == "DocId")
                        {
                            sheet.Cell(rowStart, i + 1).Value = ++counter;
                        }
                        else
                        {
                            sheet.Cell(rowStart, i + 1).Value = data;
                        }
                    }
                    rowStart++;
                }

                var folderNameWithPath = Path.Combine(Server.MapPath("~/App_Data"), "ReportDataExcell");

                if (!Directory.Exists(folderNameWithPath))
                {
                    Directory.CreateDirectory(folderNameWithPath);
                }

                string guid = Guid.NewGuid().ToString();
                filename = guid;
                string fileFullPath = Path.Combine(folderNameWithPath, guid + ".xlsx");

                workbook.SaveAs(fileFullPath);
            }

            #endregion
            return Json(new { fileName = filename, Error = false }, JsonRequestBehavior.AllowGet);
        }

        #region ForInformationDocsPDFSide
        [HttpGet]
        public ActionResult ReportForInformationDocsPdfServerSide(List<string> objHeaders, DateInterval intervalDate, ReportForInformationDocsFilter reportForInformationDocsFilter)
        {
            reportForInformationDocsFilter.beginDate = intervalDate.Start;
            reportForInformationDocsFilter.endDate = intervalDate.End;
            ReportForInformationDocsBodyViewModel result = new ReportForInformationDocsBodyViewModel();
            ReportPdfOrExcelModel pdfHeading = new ReportPdfOrExcelModel();
            var filename = "";
            try
            {
                using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
                {
                    result = new ReportForInformationDocsBodyViewModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, reportForInformationDocsFilter);


                    #region pdfHeading
                    pdfHeading = new ReportPdfOrExcelModel(adapter, SessionHelper.OrganizationId, reportForInformationDocsFilter.executorOrganizationType, reportForInformationDocsFilter.organizationDepartmentOrOrganizations); // qurumun adini goturub oba uygun olaraq hansi qurumdan hansi quruma hesabat chixarildigini teyin edirem
                    #endregion

                }

                if (result.ForInformationDocs.Count() == 0)
                    throw new Exception("Heç bir məlumat tapılmadı.");

                var folderNameWithPath = Path.Combine(Server.MapPath("~/App_Data"), "ReportDataPDF");
                if (!Directory.Exists(folderNameWithPath))
                {
                    Directory.CreateDirectory(folderNameWithPath);
                }
                string guid = Guid.NewGuid().ToString();
                filename = guid;
                string fileFullPath = Path.Combine(folderNameWithPath, guid + ".pdf");

                PdfHelper.ExportForInformationDocsToPdf(result.ForInformationDocs, objHeaders, fileFullPath, pdfHeading.ReportPdf, intervalDate.Start.Value, intervalDate.End.Value, reportForInformationDocsFilter);
            }
            catch (Exception ex)
            {
                throw;
            }
            return Json(new { fileName = filename, Error = false }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #endregion

        #region ReportAll

        [HttpGet]
        public ActionResult ReportAllDocsMain()
        {
            return PartialView("_ReportAllDocsMain");
        }

        [HttpGet]
        public ActionResult ReportAllDocs(DateInterval intervalDate, ReportAllDocsFilter reportAllDocsFilter)
        {
            if (reportAllDocsFilter.currentPage == null || !int.TryParse(reportAllDocsFilter.currentPage, out _CurrentPage))
            {
                _CurrentPage = 1;
            }
            reportAllDocsFilter.beginDate = intervalDate.Start;
            reportAllDocsFilter.endDate = intervalDate.End;

            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                var model = new ReportAllDocsBodyViewModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, reportAllDocsFilter, _CurrentPage);

                if (reportAllDocsFilter.docTypeId == 1)
                {
                    return PartialView("_ReportAllDocsOrganizationDocsBody", model);
                }         
                else if (reportAllDocsFilter.docTypeId == 2)
                {
                    return PartialView("_ReportAllDocsBody", model);
                }
                else if (reportAllDocsFilter.docTypeId == 12)
                {
                    return PartialView("_ReportAllOutGoingDocsBody", model);
                }
                else if (reportAllDocsFilter.docTypeId == 18)
                {
                    return PartialView("_ReportAllDocsBody", model);
                }
                else if (reportAllDocsFilter.docTypeId == 27)
                {
                    return PartialView("_ReportAllDocsEmployeeAppealsDocsBody", model);
                }
                else
                {
                    return PartialView("_ReportAllDocsBody", model);
                }
            }
        }

        [HttpGet]
        public ActionResult ReportAllDocsExcellServerSide(List<string> objHeaders, DateInterval intervalDate, ReportAllDocsFilter reportAllDocsFilter)
        {
            reportAllDocsFilter.beginDate = intervalDate.Start;
            reportAllDocsFilter.endDate = intervalDate.End;

            ClosedXmlExcellHelper excellHelper = new ClosedXmlExcellHelper();
            ReportAllDocsBodyViewModel result = new ReportAllDocsBodyViewModel();
            ReportPdfOrExcelModel excelHeading = new ReportPdfOrExcelModel();
            ReportPdfHeading reportExcel = new ReportPdfHeading();

            var filename = "";

            using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
            {
                result = new ReportAllDocsBodyViewModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, reportAllDocsFilter);
                #region excelHeading
                excelHeading = new ReportPdfOrExcelModel(adapter, SessionHelper.OrganizationId, reportAllDocsFilter.executorOrganizationType, reportAllDocsFilter.organizationDepartmentOrOrganizations); // qurumun adini goturub oba uygun olaraq hansi qurumdan hansi quruma hesabat chixarildigini teyin edirem
                #endregion
            }

            if (result.AllDocs.Count() == 0)
                throw new Exception("Heç bir məlumat tapılmadı.");

            #region excell

            List<string> headers = objHeaders;

            using (var workbook = new XLWorkbook())
            using (var stream = new MemoryStream())
            {
                var sheet = workbook.AddWorksheet("Bütün sənədlər hesabat");

                if (!string.IsNullOrWhiteSpace(excelHeading.ReportPdf.TargetName))
                {
                    sheet.Cell("A1").Value = excelHeading.ReportPdf.CurrentOrganizationName + "(" + excelHeading.ReportPdf.TargetName + ")";
                }
                else
                {
                    sheet.Cell("A1").Value = excelHeading.ReportPdf.CurrentOrganizationName;
                }

                switch (reportAllDocsFilter.docTypeId)
                {
                    case 1: sheet.Cell("C1").Value =  "(" + "Təşkilat müraciətləri" + ")"; break;
                    case 2: sheet.Cell("C1").Value =  "("  + "Vətəndaş müraciətləri" + ")"; break;
                    case 3: sheet.Cell("C1").Value =  "("  + "Sərəncamverici sənədlər" + ")"; break;
                    case 12: sheet.Cell("C1").Value =  "("  + "Xaric olan sənədlər" + ")"; break;
                    case 18: sheet.Cell("C1").Value = "("  + "Xidməti məktublar" + ")"; break;
                    case 27: sheet.Cell("C1").Value = "("  + "Əməkdaş müraciətləri" + ")"; break;
                    default:
                        break;
                }

                sheet.Cell("A2").Value = "Bütün sənədlər " + "("+ reportAllDocsFilter.beginDate.Value.ToShortDateString()
                                          + " - " + reportAllDocsFilter.endDate.Value.ToShortDateString() + ")";

                sheet.Range("A1:B1").Merge();
                sheet.Range("C1:D1").Merge();


                sheet.Rows(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Left;
                sheet.Rows(1, 2).Style.Font.Bold = true;
                sheet.Rows(1, 2).Style.Font.Italic = true;
                sheet.Columns().Width = 20;

                int rowStart = 3;

                for (int i = 0; i < headers.Count; i++)
                {
                    sheet.Cell(rowStart, i + 1).Value = headers[i];
                    sheet.Cell(rowStart, i + 1).Style = XLWorkbook.DefaultStyle;
                    sheet.Cell(rowStart, i + 1).Style.Fill.BackgroundColor = XLColor.Gray;
                    sheet.Cell(rowStart, i + 1).Style.Font.Bold = true;

                }
                sheet.Columns().AdjustToContents();
                sheet.Rows().AdjustToContents();
                rowStart++;
                int counter = 0;
                
                foreach (var item in result.AllDocs)
                {
                    for (int i = 0; i < headers.Count; i++)
                    {
                        var fieldName = "";
                        if (reportAllDocsFilter.docTypeId == 1)
                        {
                            fieldName = excellHelper.GetFieldNameForOrganizationAllDocs(headers[i]);
                        }
                        else if (reportAllDocsFilter.docTypeId == 2)
                        {
                            fieldName = excellHelper.GetFieldNameForCitizenAllDocs(headers[i]);
                        }
                        else if (reportAllDocsFilter.docTypeId == 12)
                        {
                            fieldName = excellHelper.GetFieldNameForOutGoingAllDocs(headers[i]);
                        }
                        else if (reportAllDocsFilter.docTypeId == 27)
                        {
                            fieldName = excellHelper.GetFieldNameForEmployeeAppealsAllDocs(headers[i]);
                        }
                        else
                        {
                            fieldName = null;
                        }
                        
                        var data = item.GetType().GetProperty(fieldName).GetValue(item)?.ToString();


                        if (fieldName.ToString() == "DocEnterno" || fieldName.ToString() == "ReplyDocNumbers"
                                                                 || filename.ToString() == "RelationDocNumbers" || fieldName.ToString() == "IncomingDocNumbers")
                        {
                            sheet.Cell(rowStart, i + 1).SetValue<string>(Convert.ToString(data));
                        }
                        else if (fieldName.ToString() == "DocId")
                        {
                            sheet.Cell(rowStart, i + 1).Value = ++counter;
                        }
                        else
                        {
                            sheet.Cell(rowStart, i + 1).Value = data;
                        }
                    }
                    rowStart++;
                }

                var folderNameWithPath = Path.Combine(Server.MapPath("~/App_Data"), "ReportDataExcell");

                if (!Directory.Exists(folderNameWithPath))
                {
                    Directory.CreateDirectory(folderNameWithPath);
                }

                string guid = Guid.NewGuid().ToString();
                filename = guid;
                string fileFullPath = Path.Combine(folderNameWithPath, guid + ".xlsx");

                workbook.SaveAs(fileFullPath);
            }

            #endregion
            return Json(new { fileName = filename, Error = false }, JsonRequestBehavior.AllowGet);
        }

        #region AllDocsPDFSide
        [HttpGet]
        public ActionResult ReportAllDocsPdfServerSide(List<string> objHeaders, DateInterval intervalDate, ReportAllDocsFilter reportAllDocsFilter)
        {
            reportAllDocsFilter.beginDate = intervalDate.Start;
            reportAllDocsFilter.endDate = intervalDate.End;
            ReportAllDocsBodyViewModel result = new ReportAllDocsBodyViewModel();
            ReportPdfOrExcelModel pdfHeading = new ReportPdfOrExcelModel();
            var filename = "";
            try
            {
                using (ReportAdapter adapter = new ReportAdapter(unitOfWork))
                {
                    result = new ReportAllDocsBodyViewModel(adapter, SessionHelper.OrganizationId, SessionHelper.WorkPlaceId, reportAllDocsFilter);


                    #region pdfHeading
                    pdfHeading = new ReportPdfOrExcelModel(adapter, SessionHelper.OrganizationId, reportAllDocsFilter.executorOrganizationType, reportAllDocsFilter.organizationDepartmentOrOrganizations); // qurumun adini goturub oba uygun olaraq hansi qurumdan hansi quruma hesabat chixarildigini teyin edirem
                    #endregion

                }

                if (result.AllDocs.Count() == 0)
                    throw new Exception("Heç bir məlumat tapılmadı.");

                var folderNameWithPath = Path.Combine(Server.MapPath("~/App_Data"), "ReportDataPDF");
                if (!Directory.Exists(folderNameWithPath))
                {
                    Directory.CreateDirectory(folderNameWithPath);
                }
                string guid = Guid.NewGuid().ToString();
                filename = guid;
                string fileFullPath = Path.Combine(folderNameWithPath, guid + ".pdf");

                PdfHelper.ExportAllDocsToPdf(result.AllDocs, objHeaders, fileFullPath, pdfHeading.ReportPdf, intervalDate.Start.Value, intervalDate.End.Value, reportAllDocsFilter);
            }
            catch (Exception ex)
            {
                throw;
            }
            return Json(new { fileName = filename, Error = false }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #endregion
    }
}
