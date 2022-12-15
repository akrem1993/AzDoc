using AzDoc.BaseControllers;
using AzDoc.Helpers;
using BLL.Adapters;
using CustomHelpers;
using Repository.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AzDoc.Controllers
{
    public class VizaController : BaseController
    {
        public VizaController(IUnitOfWork unitOfWork) : base(unitOfWork) { }

        /// <summary>
        /// Mesul sexleri qaytarir
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public JsonResult GetResponsePerson()
        {
            using (VizaAdapter fileAdapter = new VizaAdapter(unitOfWork))
            {
                return Json(fileAdapter.GetResPersonByOrgId(SessionHelper.WorkPlaceId), JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// daxil olan senedin musterek icracilarini qaytarir
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public JsonResult GetJointExecutors(string answerDocs, string currentDocid)
        {
            var token = CustomHelper.Decrypt(HttpUtility.UrlDecode(currentDocid));
            var tokenData = token.Split('-');
            var splitDocId = Convert.ToInt32(tokenData[2]);
            using (VizaAdapter fileAdapter = new VizaAdapter(unitOfWork))
            {
                return Json(fileAdapter.GetJointExecutors(SessionHelper.WorkPlaceId, splitDocId, answerDocs), JsonRequestBehavior.AllowGet);
            }
        }
        

        [HttpGet]
        public JsonResult IsSameDepartment(int vizaWorkplaceid)
        {
            using (VizaAdapter fileAdapter = new VizaAdapter(unitOfWork))
            {
                return Json(fileAdapter.IsSameDepartment(vizaWorkplaceid, SessionHelper.WorkPlaceId), JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// cavab senedini yaradai qaytarir
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public JsonResult GetDocumentCreator(string currentDocid)
        {
            var token = CustomHelper.Decrypt(HttpUtility.UrlDecode(currentDocid));
            var tokenData = token.Split('-');
            var splitDocId = Convert.ToInt32(tokenData[2]);
                using (VizaAdapter fileAdapter = new VizaAdapter(unitOfWork))
                {
                    return Json(fileAdapter.GetDocumentCreator(splitDocId), JsonRequestBehavior.AllowGet);
                }
        }
    }
}