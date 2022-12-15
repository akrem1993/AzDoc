using BLL.BaseAdapter;
using BLL.Models.Notify;
using Repository.Extensions;
using Repository.Infrastructure;

namespace BLL.Adapters
{
    public class NotifyAdapter : AdapterBase
    {
        public NotifyAdapter(IUnitOfWork unitOfWork) : base(unitOfWork) { }

        public NotifyModel GetNotify(int workPlaceId)
        {
            var parameters = Extension.Init().Add("@workPlaceId", workPlaceId);

            return UnitOfWork.ExecuteValueProcedure<NotifyModel>("[dbo].[GetNotify]", parameters);
        }
    }
}
