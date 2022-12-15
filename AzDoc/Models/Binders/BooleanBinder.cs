using System.Web.Mvc;

namespace AzDoc.Models.Binders
{
    public class BooleanBinder :IModelBinder
    {
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            var value = bindingContext.ValueProvider.GetValue(bindingContext.ModelName).AttemptedValue;
            switch (value.ToLower())
            {
                case "on":
                case "true":
                    return true;
                default:
                    return false;
            }
        }
    }
}