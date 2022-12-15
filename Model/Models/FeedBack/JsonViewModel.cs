using System.Collections.Generic;

namespace Model.Models.FeedBack
{
    public class JsonViewModel<T> where T : class
    {
        public int TotalCount { get; set; }
        public IEnumerable<T> Items { get; set; }
    }
}