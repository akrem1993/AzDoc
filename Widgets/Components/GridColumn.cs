using Newtonsoft.Json;
using System.Collections.Generic;
using System.Web.Mvc;
using Widgets.Helpers;

namespace Widgets
{
    public class GridColumn
    {
        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public bool? Nullable { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string Action { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string Onclick { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public bool? Filterable { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public bool? Sortable { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public bool? Hideable { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public bool? Groupable { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string Width { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string Align { get; set; }

        [JsonProperty("filteritems", NullValueHandling = NullValueHandling.Ignore)]
        [JsonConverter(typeof(PlainJsonStringConverter))]
        public string FilterItems { get; set; }

        [JsonProperty("createfilterwidget", NullValueHandling = NullValueHandling.Ignore, Order = 0)]
        [JsonConverter(typeof(PlainJsonStringConverter))]
        public string CreateFilterWidget { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string FilterType { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public bool? Editable { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public uint? MinWidth { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public uint? MaxWidth { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public bool? Resizeable { get; set; }

        [JsonProperty("renderer", NullValueHandling = NullValueHandling.Ignore, Order = 0)]
        [JsonConverter(typeof(PlainJsonStringConverter))]
        public string HeaderRenderer { get; set; }

        [JsonProperty("cellsrenderer", NullValueHandling = NullValueHandling.Ignore, Order = 0)]
        [JsonConverter(typeof(PlainJsonStringConverter))]
        public string CellsRenderer { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string DataField { get; set; }

        [JsonProperty("value", NullValueHandling = NullValueHandling.Ignore)]
        public string FilterField { get; set; }

        [JsonProperty("values", NullValueHandling = NullValueHandling.Ignore, Order = 0)]
        [JsonConverter(typeof(PlainJsonStringConverter))]
        public string FilterSource { get; set; }

        [JsonProperty("filterdelay", NullValueHandling = NullValueHandling.Ignore, Order = 0)]
        public short? FilterDelay { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string Text { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public bool? Exportable { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public bool? Pinned { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string ColumnType { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string FieldType { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string ClassName { get; set; }

        [JsonProperty("cellclassname", NullValueHandling = NullValueHandling.Ignore)]
        [JsonConverter(typeof(PlainJsonStringConverter))]
        public string CellClassName { get; set; }

        [JsonProperty("enabletooltips", NullValueHandling = NullValueHandling.Ignore)]
        public bool? EnableTooltips { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public bool? Crud { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string CellsFormat { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public string CellsAlign { get; set; }

        [JsonProperty(NullValueHandling = NullValueHandling.Ignore)]
        public bool? Hidden { get; set; }
    }
}