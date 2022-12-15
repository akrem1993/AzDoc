using System.IO;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using DocFileHelper.Modifier.Services;

namespace DocHelperApi.Controllers
{
    [RoutePrefix("converter")]
    public class ConverterController : ApiController
    {
        [HttpGet]
        [Route("fileToPdf")]
        public HttpResponseMessage ConvertFileToPdf(HttpPostedFile file)
        {
            if (file == null || file.ContentLength == 0)
                return Request.CreateResponse(HttpStatusCode.ExpectationFailed, "File not exist");

            var convertResult = new FileConverter().ConvertTo(file.InputStream, Path.GetFileName(file.FileName));

            var result = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StreamContent(File.OpenRead(convertResult.TempPath))
            };

            result.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/pdf");

            return result;
        }
    }
}