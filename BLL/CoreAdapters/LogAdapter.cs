using BLL.BaseAdapter;
using Model.Models.Log;
using Repository.Extensions;
using Repository.Infrastructure;

namespace BLL.Adapters
{
    public class LogAdapter : AdapterBase
    {
        public LogAdapter(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        public void LogData(LogModel model)
        {
            var parameters = Extension.Init();

            parameters.Add("@LogType", model.LogType);
            parameters.Add("@Url", model.Url);
            parameters.Add("@DocId", model.DocId);
            parameters.Add("@Controller", model.ControllerName);
            parameters.Add("@ControllerAction", model.ActionName);
            parameters.Add("@RequestData", model.RequestData);
            parameters.Add("@RequestParams", model.RequestParams);
            parameters.Add("@Message", model.Message);
            parameters.Add("@UserName", model.UserName);
            parameters.Add("@WorkPlace", model.WorkPlace);
            parameters.Add("@UserIp", model.UserIp);

            UnitOfWork.ExecuteNonQueryProcedure("dbo.LogRequests", parameters);
        }
    }
}