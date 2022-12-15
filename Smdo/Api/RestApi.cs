using Newtonsoft.Json;
using RestSharp;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;

namespace Smdo.Api
{
    class RestApi
    {

        public static HttpWebResponse PostInitilize(string relativeUri)
        {
            var request = (HttpWebRequest)WebRequest.Create(relativeUri);

            request.Method = "POST";
            request.ContentType = "application/x-www-form-urlencoded";

            var response = (HttpWebResponse)request.GetResponse();

            return response;
        }

        public static HttpWebResponse GetDvc(string relativeUri)
        {
            var request = (HttpWebRequest)WebRequest.Create(relativeUri);

            request.Method = "GET";
            request.ContentType = "application/x-www-form-urlencoded";
            request.Headers.Add("Content-Transfer-Encoding", "base64");


            var response = (HttpWebResponse)request.GetResponse();

            return response;
        }

        public static IRestResponse PostFile(string relativeUri, FileStream stream)
        {
            var client = new RestClient(relativeUri);

            var request = new RestRequest("", Method.POST);

            request.RequestFormat = DataFormat.Json;
            request.AlwaysMultipartFormData = true;

            using (MemoryStream ms = new MemoryStream())
            {
                stream.CopyTo(ms);

                var buffer = ms.ToArray();

                request.Files.Add(FileParameter.Create("file", buffer, stream.Name));
            }

            var response = client.Execute(request);

            return response;
        }

        public static IRestResponse ParseDvc(string relativeUri, List<PostedFile> files)
        {
            var client = new RestClient(relativeUri);

            var request = new RestRequest("", Method.POST)
            {
                RequestFormat = DataFormat.Json,
                AlwaysMultipartFormData = true
            };

            foreach (var file in files)
            {
                request.AddFile(file.Name, x => new MemoryStream(file.FileBuffer),
                    string.Empty,
                    file.FileBuffer.Length,
                    "application/binary");
            }

            var response = client.Execute(request);

            return response;
        }

        public static HttpWebResponse Post(string relativeUri, object data)
        {
            var request = (HttpWebRequest)WebRequest.Create(relativeUri);

            request.Method = "POST";
            request.ContentType = "application/json";
            
            var dataJson = JsonConvert.SerializeObject(data);
            var buffer = Encoding.UTF8.GetBytes(dataJson);

            Stream stream = request.GetRequestStream();
            stream.Write(buffer, 0, buffer.Length);
            stream.Close();



            var response = (HttpWebResponse)request.GetResponse();

            return response;
        }




    }
}
