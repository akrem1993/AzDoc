using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DocHelperApi.Models.Concrete
{
    public enum ResponseStatus
    {
        OK,
        InputError,
        ServerError
    }

    public class Response<T>
    {
        [JsonProperty(Order = 1)]
        [JsonConverter(typeof(StringEnumConverter))]
        public ResponseStatus Status { get; set; }

        [JsonProperty(Order = 2)]
        public string StatusMessage { get; set; }

        [JsonProperty(Order = 3)]
        public T ResponseData { get; set; }
    }
}