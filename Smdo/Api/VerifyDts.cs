
using Newtonsoft.Json;
using Smdo.Api.ApiModels;
using System;
using System.IO;

namespace Smdo.Api
{
    public class VerifyDts
    {
        public string Location;
        public readonly string signP7SLocation;
        public readonly string dataP7SLocation;
        public string DvcBase64 { get; set; }
        public Status VerifyStatus { get; private set; }

        public const string endpointUrl = "http://dtsrsa.avest.by/client/api/request/v1";
        public const string endpointDtsParser = "https://localhost:10288/api/sign/verifydvc";

        public VerifyDts(string serverPath, string docGuid, string dataFileName)
        {
            string docPath = $"{serverPath}/{docGuid}";

            signP7SLocation = $"{docPath}/sign.p7s";
            dataP7SLocation = $"{docPath}/{dataFileName}";
        }

        public void Initialize()
        {
            VerifyStatus = new Status();

            var response = RestApi.PostInitilize(endpointUrl + "?type=vsd");

            if (response.StatusCode != System.Net.HttpStatusCode.Created) Throw("Dts Rsa not created" + response);

            Location = response.Headers.Get("Location");

            VerifyStatus.Initialize = true;
        }

        public void UploadSignedFile()
        {
            using (var fileStream = System.IO.File.Open(signP7SLocation, FileMode.Open))
            {
                var response = RestApi.PostFile($"{Location}/files/sign", fileStream);

                if (response.StatusCode != System.Net.HttpStatusCode.OK) Throw("Sign not uploaded");

                VerifyStatus.UploadSign = true;
            }
        }

        public void UploadDataFile()
        {
            using (var fileStream = System.IO.File.Open(dataP7SLocation, FileMode.Open))
            {
                var response = RestApi.PostFile($"{Location}/files/data", fileStream);

                if (response.StatusCode != System.Net.HttpStatusCode.OK) Throw("Data not uploaded");

                VerifyStatus.UploadData = true;
            }
        }

        public DvcsModel GetDtsStatus()
        {
            var response = ApiUtil.Get<DvcsModel>(Location);

            if (response.Response.StatusCode != System.Net.HttpStatusCode.OK)
                Throw("GetDtsStatus is failed");

            return response.Model;
        }

        public void DownloadDvc()
        {
            //var dvcBase64 = ApiUtil.GetWithHeader($"{Location}/files/dvc");

            var dvcBase64 = RestApi.GetDvc($"{Location}/files/dvc");

            if (dvcBase64.StatusCode != System.Net.HttpStatusCode.OK)
                Throw("DownloadSignedFile is failed");

            var responseString = new StreamReader(dvcBase64.GetResponseStream()).ReadToEnd();
            DvcBase64 = responseString;

            VerifyStatus.DownloadDvc = true;
        }

        public static byte[] ReadFully(Stream input)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                input.CopyTo(ms);
                return ms.ToArray();
            }
        }

        public DvcParse ParseDvc()
        {
            using (var signStream = System.IO.File.Open(signP7SLocation, FileMode.Open))
            {
                var signedBuffer = Convert.ToBase64String(ReadFully(signStream));

                var response = RestApi.Post(endpointDtsParser, new
                {
                    signedFileRawData = signedBuffer,
                    dvcRawData = DvcBase64
                });

                if (response.StatusCode != System.Net.HttpStatusCode.OK)
                    Throw("Parse Dts is failed");
                
                if (VerifyStatus != null) VerifyStatus.DownloadDvc = true;

                var responseString = new StreamReader(response.GetResponseStream()).ReadToEnd();

                return JsonConvert.DeserializeObject<DvcParse>(responseString);
            }
        }


        static void Throw(string msg = null) => throw new Exception(msg);

    }

    public class Status
    {
        public bool Initialize { get; set; }

        public bool UploadSign { get; set; }

        public bool UploadData { get; set; }

        public bool DownloadDvc { get; set; }

    }

}
