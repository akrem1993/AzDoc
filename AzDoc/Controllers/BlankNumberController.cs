using AzDoc.Helpers;
using BLL.CoreAdapters;
using BLL.Models.BlankNumber;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using AzDoc.BaseControllers;
using System.Data.SqlClient;
using Repository.Extensions;

namespace AzDoc.Controllers
{
    public class BlankNumberController : BaseController
    {
        public BlankNumberController(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        // GET: BlankNumber
        public ActionResult BlankModal(int docId)
        {
            var info = unitOfWork.GetBlankNumber<DocBlankTypes>();
            return PartialView("~/Views/BlankNumber/_BlankNumberPanel.cshtml",info);
     
        }
        [HttpPost]
        public ActionResult AddBlankNumber(List<BlankNumberModel> blanks)
        {
            DocBlankNumbers model = new DocBlankNumbers();
            int blankDocId= SessionHelper.ResolutionDocId;            
            var data = unitOfWork.AddBlankNumber<DocBlankNumbers>(blanks, blankDocId);
            return Json(true, JsonRequestBehavior.AllowGet); ;

        }
    }
}