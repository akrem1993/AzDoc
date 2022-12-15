using System;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using DocFileHelper.Modifier.Services;

namespace DocHelperApi.Controllers
{
    [RoutePrefix("ocr")]
    public class OcrController : BaseApiController
    {
        [HttpPost]
        [Route("readFile")]
        public async Task<HttpResponseMessage> ReadFromFile(string fileLang = "aze")
        {
            var file = HttpContext.Current.Request.Files.Count > 0 ? HttpContext.Current.Request.Files[0] : null;

            if (file == null || file.ContentLength == 0)
                return Request.CreateResponse(HttpStatusCode.ExpectationFailed, "File not exist");
            try
            {
                var fileTempPath = _appSettingPath.UploadTemp + $"/{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
                file.SaveAs(fileTempPath);
                var convertResult =await new FileConverter().GetStringFromFile(fileTempPath,file.InputStream, file.FileName, fileLang);

                var result = new HttpResponseMessage(HttpStatusCode.OK)
                {
                    Content = new StringContent(convertResult)
                };

                return result;
            }
            catch (Exception ex)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, ex.Message+ex.InnerException?.Message);
            }
        }
    }
}