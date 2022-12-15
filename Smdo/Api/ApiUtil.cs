using Newtonsoft.Json;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace Smdo.Api
{
    public static class ApiUtil
    {
        #region async helper methods with ResponseType

        // SELECT

        public static async Task<ResponseType> Get(string endpoint)
        {
            using (var client = new HttpClient())
            {
                var response = await client.GetAsync(endpoint);
                return await Task.FromResult(ResponseType.Create(response));
            }
        }

        public static ResponseType GetWithHeader(string endpoint)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Add("ContentTransferEncoding", "base64");
                var response = client.GetAsync(endpoint).GetAwaiter().GetResult();
                return ResponseType.Create(response);
            }
        }

        // INSERT

        public static ResponseType Post(string endpoint, object data, HttpMediaType httpMediaType = HttpMediaType.Json)
        {
            using (var client = new HttpClient())
            {

                var body = JsonConvert.SerializeObject(data);
                var httpContent = new StringContent(body);
                httpContent.SetContentType(httpMediaType);
                client.DefaultRequestHeaders.Add("ContentType", "application/x-www-form-urlencoded");


                var response = client.PostAsync(endpoint, httpContent).GetAwaiter().GetResult();
                return ResponseType.Create(response);
            }
        }

        public static ResponseType PostFile(string endpoint, PostedFile fileStream, HttpMediaType httpMediaType = HttpMediaType.Json)
        {
            using (var client = new HttpClient())
            {
                using (var formData = new MultipartFormDataContent())
                {
                    formData.Add(new StreamContent(fileStream.FileStream), fileStream.Name);

                    var response = client.PostAsync(endpoint, formData).GetAwaiter().GetResult();
                    return ResponseType.Create(response);
                }
            }
        }

        // UPDATE

        public static async Task<ResponseType> Put(string endpoint, object data, HttpMediaType httpMediaType = HttpMediaType.Json)
        {
            using (var client = new HttpClient())
            {
                var httpContent = new StringContent(JsonConvert.SerializeObject(data));
                httpContent.SetContentType(httpMediaType);

                var response = await client.PutAsync(endpoint, httpContent);
                return await Task.FromResult(ResponseType.Create(response));
            }
        }

        // DELETE

        public static async Task<ResponseType> Delete(string endpoint)
        {
            using (var client = new HttpClient())
            {
                var response = await client.DeleteAsync(endpoint);
                return await Task.FromResult(ResponseType.Create(response));
            }
        }

        #endregion

        #region async helper methods with ResponseType Generic

        // SELECT

        public static ResponseType<T> Get<T>(string endpoint)
        where T : class
        {
            using (var client = new HttpClient())
            {
                var response = client.GetAsync(endpoint).GetAwaiter().GetResult();
                return ResponseType.Create<T>(response);
            }
        }

        // INSERT

        public static async Task<ResponseType<T>> Post<T>(string endpoint, object data, HttpMediaType httpMediaType = HttpMediaType.Json)
        where T : class
        {
            using (var client = new HttpClient())
            {
                var httpContent = new StringContent(JsonConvert.SerializeObject(data));
                httpContent.SetContentType(httpMediaType);

                var response = await client.PostAsync(endpoint, httpContent);
                return await Task.FromResult(ResponseType.Create<T>(response));
            }
        }

        // UPDATE

        public static async Task<ResponseType<T>> Put<T>(string endpoint, object data, HttpMediaType httpMediaType = HttpMediaType.Json)
        where T : class
        {
            using (var client = new HttpClient())
            {
                var httpContent = new StringContent(JsonConvert.SerializeObject(data));
                httpContent.SetContentType(httpMediaType);

                var response = await client.PutAsync(endpoint, httpContent);
                return await Task.FromResult(ResponseType.Create<T>(response));
            }
        }

        // DELETE

        public static async Task<ResponseType<T>> Delete<T>(string endpoint)
        where T : class
        {
            using (var client = new HttpClient())
            {
                var response = await client.DeleteAsync(endpoint);
                return await Task.FromResult(ResponseType.Create<T>(response));
            }
        }

        #endregion
    }

    public static class Extension
    {
        public static void SetContentType(this StringContent stringContent, HttpMediaType httpMediaType)
        {
            switch (httpMediaType)
            {
                case HttpMediaType.Xml:
                    stringContent.Headers.ContentType = new MediaTypeHeaderValue("application/xml");
                    break;
                case HttpMediaType.UrlEncoded:
                    stringContent.Headers.ContentType = new MediaTypeHeaderValue("application/x-www-form-urlencoded");
                    break;

                case HttpMediaType.MultiPartFormData:
                    stringContent.Headers.ContentType = new MediaTypeHeaderValue("multipart/form-data");
                    break;

                case HttpMediaType.Json:
                default:
                    stringContent.Headers.ContentType = new MediaTypeHeaderValue("application/json");
                    break;
            }
        }
    }

    public enum HttpMediaType
    {
        Json,
        Xml,
        OctetStream,
        UrlEncoded,
        MultiPartFormData
    }

    public class PostedFile
    {
        public FileStream FileStream { get; set; }

        public string Name { get; set; }
        public byte[] FileBuffer { get; set; }
    }
}
