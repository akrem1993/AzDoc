using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web.Mvc;
using Widgets.Helpers;

namespace Widgets.Components
{
    public class GridLookup
    {
        [JsonIgnore()]
        public HtmlHelper Html { get; set; }

        [JsonProperty("id", NullValueHandling = NullValueHandling.Ignore)]
        public string Id { get; set; }
        [JsonProperty("source", NullValueHandling = NullValueHandling.Ignore)]
        public string Action { get; set; }
        List<GridColumn> _columns { get; set; }

        [JsonProperty("Key", NullValueHandling = NullValueHandling.Ignore)]
        public string ValueMember { get; set; }

        [JsonProperty("display", NullValueHandling = NullValueHandling.Ignore)]
        public string DisplayMember { get; set; }

        #region Serializable Properties
        [JsonProperty("width", NullValueHandling = NullValueHandling.Ignore)]
        public string Width { get; set; }

        [JsonProperty("height", NullValueHandling = NullValueHandling.Ignore)]
        public string Height { get; set; }

        [JsonProperty("crud", NullValueHandling = NullValueHandling.Ignore)]
        public bool? Crud { get; set; }

        [JsonProperty("columnsresize", NullValueHandling = NullValueHandling.Ignore)]
        public bool? ColumnsResize { get; set; }

        [JsonProperty("columnsreorder", NullValueHandling = NullValueHandling.Ignore)]
        public bool? ColumnsReorder { get; set; }

        [JsonProperty("pageable", NullValueHandling = NullValueHandling.Ignore)]
        public bool? Pageable { get; set; }

        [JsonProperty("filterable", NullValueHandling = NullValueHandling.Ignore)]
        public bool? Filterable { get; set; }

        [JsonProperty("sortable", NullValueHandling = NullValueHandling.Ignore)]
        public bool? Sortable { get; set; }

        [JsonProperty("showfilterrow", NullValueHandling = NullValueHandling.Ignore)]
        public bool? ShowFilterRow { get; set; }

        [JsonProperty("enabletooltips", NullValueHandling = NullValueHandling.Ignore)]
        public bool? EnableTooltips { get; set; }

        [JsonProperty("columnsmenu", NullValueHandling = NullValueHandling.Ignore)]
        public bool? ColumnsMenu { get; set; }

        [JsonProperty("pageSize", NullValueHandling = NullValueHandling.Ignore)]
        public int? PageSize { get; set; }

        [JsonProperty("pagermode", NullValueHandling = NullValueHandling.Ignore)]
        public string PagerMode { get; set; }

        [JsonProperty("autoshowfiltericon", NullValueHandling = NullValueHandling.Ignore)]
        public bool? AutoShowFilterIcon { get; set; }
        #endregion

        public GridLookup()
        {
            _columns = new List<GridColumn>();
        }

        [JsonProperty("columns", NullValueHandling = NullValueHandling.Ignore)]
        public List<GridColumn> GetColumns { get { return _columns; } }

        [JsonProperty("multiselect", NullValueHandling = NullValueHandling.Ignore)]
        public bool? MultiSelect { get; set; }

        [JsonProperty("selectionmode", NullValueHandling = NullValueHandling.Ignore)]
        public string SelectionMode { get; set; }

        [JsonProperty("rowselect", NullValueHandling = NullValueHandling.Ignore)]
        [JsonConverter(typeof(PlainJsonStringConverter))]
        public string RowSelect { get; set; }

        [JsonProperty("rowUnselect", NullValueHandling = NullValueHandling.Ignore)]
        [JsonConverter(typeof(PlainJsonStringConverter))]
        public string RowUnselect { get; set; }

        [JsonProperty("rowClick", NullValueHandling = NullValueHandling.Ignore)]
        [JsonConverter(typeof(PlainJsonStringConverter))]
        public string RowClick { get; set; }

        [JsonProperty("rowdoubleclick", NullValueHandling = NullValueHandling.Ignore)]
        [JsonConverter(typeof(PlainJsonStringConverter))]
        public string RowDoubleClick { get; set; }

        [JsonProperty("altrows", NullValueHandling = NullValueHandling.Ignore)]
        public bool? AltRows { get; set; }

        [JsonProperty("scrollPopUp", NullValueHandling = NullValueHandling.Ignore)]
        public bool? ScrollPopUp { get; set; }

        public GridLookup Columns(Action<List<GridColumn>> method)
        {
            if (_columns.Count < 1)//cookieden artiq columlar doldurulub demek,actionu bosuna isletmirik
            {
                method.Invoke(_columns);
                Html.ViewContext.RequestContext.SetValue(Id, _columns);
            }

            return this;
        }

        public GridLookup AddColumns(List<GridColumn> columns)
        {
            if (columns != null)
                _columns.AddRange(columns);

            return this;
        }
    }
}