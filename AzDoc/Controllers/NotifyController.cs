using System.Threading.Tasks;
using System.Web.Mvc;
using AzDoc.Helpers;
using BLL.Adapters;
using BLL.Models.Notify;
using Repository.Infrastructure;

namespace AzDoc.Controllers
{
    public class NotifyController : Controller
    {
        private readonly IUnitOfWork unitOfWork;
        public NotifyController(IUnitOfWork unitOfWork) => this.unitOfWork = unitOfWork;

        [HttpGet]
        public  JsonResult GetNotifications()
        {
            using (NotifyAdapter adapter=new NotifyAdapter(unitOfWork))
            {
                NotifyModel model =adapter.GetNotify(SessionHelper.WorkPlaceId);

                return Json(new
                {
                    feedBack = model.FeedBackMessagesCount,
                    unreadDocuments = model.UnreadDocumentsCount

                }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}