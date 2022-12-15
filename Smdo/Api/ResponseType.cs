using Newtonsoft.Json;
using System.Net.Http;

namespace Smdo.Api
{
    public class ResponseType
    {
        internal ResponseType(HttpResponseMessage response)
        {
            this.Response = response;
            this.Data = response.Content.ReadAsStringAsync().Result;
        }
        public HttpResponseMessage Response { get; private set; }
        public string Data { get; private set; }

        protected internal static ResponseType Create(HttpResponseMessage response)
        {
            return new ResponseType(response);
        }

        protected internal static ResponseType<T> Create<T>(HttpResponseMessage response) where T : class
        {
            return new ResponseType<T>(response);
        }
    }

    public class ResponseType<T> : ResponseType where T : class
    {
        internal ResponseType(HttpResponseMessage response)
            : base(response)
        {
            this.Model = JsonConvert.DeserializeObject<T>(Data);
        }

        public T Model { get; private set; }
    }
}
