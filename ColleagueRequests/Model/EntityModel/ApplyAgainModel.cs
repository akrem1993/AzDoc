using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace ColleagueRequests.Model.EntityModel
{
    public class ApplyAgainModel
    {
        public int DocId { get; set; }
        private string docEnterno;

        public string DocEnterno
        {
            get { return docEnterno; }
            set { docEnterno = value ?? ""; }
        }

        public DateTime? DocEnterdate { get; set; }

        private int docApplytypeId;
        public int? DocApplytypeId
        {
            get { return docApplytypeId; }
            set { docApplytypeId = value ?? 0; }
        }

        private int docTopicType;
        public int? DocTopicType
        {
            get { return docTopicType; }
            set { docTopicType = value ?? 0; }
        }

        private int docTopicId;
        public int? DocTopicId
        {
            get { return docTopicId; }
            set { docTopicId = value ?? 0; }
        }

        private string appFirstName;

        public string AppFirstname
        {
            get { return appFirstName; }
            set { appFirstName = value ?? ""; }
        }

        private string appSurName;

        public string AppSurname
        {
            get { return appSurName; }
            set { appSurName = value ?? ""; }
        }


        private string appLastName;

        public string AppLastName

        {
            get { return appLastName; }
            set { appLastName = value ?? ""; }
        }

        private string countryName;
        public string CountryName
        {
            get { return countryName; }
            set { countryName = value ?? ""; }
        }

        private string regionName;
        public string RegionName
        {
            get { return regionName; }
            set { regionName = value ?? ""; }
        }

        private int appCountryId;
        public int? AppCountryId
        {
            get { return appCountryId; }
            set { appCountryId = value ?? 0; }
        }

        private int appRegionId;
        public int? AppRegionId
        {
            get { return appRegionId; }
            set { appRegionId = value ?? 0; }
        }

        public string AppSosialStatusId { get; set; }

        private int appRepresenterId;
        public int? AppRepresenterId
        {
            get { return appRepresenterId; }
            set { appRepresenterId = value ?? 0; }
        }

        private string representer;
        public string Representer
        {
            get { return representer; }
            set { representer = value ?? ""; }
        }

        private string appAddress;
        public string AppAddress
        {
            get { return appAddress; }
            set { appAddress = value ?? ""; }
        }

        private string appPhone;
        public string AppPhone
        {
            get { return appPhone; }
            set { appPhone = value ?? ""; }
        }

        private string appEmail;
        public string AppEmail
        {
            get { return appEmail; }
            set { appEmail = value ?? ""; }
        }

        private string topicName;
        public string TopicName
        {
            get { return topicName; }
            set { topicName = value ?? ""; }
        }

        private string token;
        public string Token
        {
            get { return token; }
            set { token = value ?? ""; }
        }
    }
}
