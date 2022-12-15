using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Mvc;
using Widgets.Components;
using Widgets.Helpers;

namespace Widgets
{
    public enum TextAlign
    {
        Left,
        Center,
        Right
    }
    public enum FieldType
    {
        String,
        Number,
        Date
    }
    public enum ColumnType
    {
        TextBox,
        Number,
        CheckBox,
        CheckedList,
        ThreeStateCheckBox,
        NumberInput,
        DropDownList,
        ComboBox,
        DateTimeInput,
        Template
    }
    public enum Filtertype
    {
        TextBox,
        List,
        CheckedList,
        Date
    }
    public enum SelectionMode
    {
        Checkbox
    }

    static public partial class GridHelper
    {
        static public Grid MhmGridTest(this HtmlHelper html, string id, string json, [Optional] bool? saveInCookie)
        {
            var grid = new Grid
            {
                Id = id,
                Html = html
            };

            if (saveInCookie.HasValue && saveInCookie.Value)
            {
                //columlarin cookiede oldugunu yoxlayiriq
                var columns = JsonConvert.DeserializeObject<List<GridColumn>>(json, new JsonSerializerSettings());

                //var columns = html.ViewContext.RequestContext.HttpContext.Request.GetValue<List<GridColumn>>(id);
                if (columns != null)
                    grid.AddColumns(columns);
            }

            return grid;
        }

        static public Grid MhmGrid(this HtmlHelper html, string id, [Optional]string action, [Optional]string controller, [Optional] bool? saveInCookie, [Optional] object routeValues)
        {
            var grid = new Grid
            {
                Id = id,
                Html = html
            };
            if (action != null && controller != null)
            {
                var urlHelper = new UrlHelper(html.ViewContext.RequestContext);
                grid.Action = urlHelper.Action(action, controller, routeValues == null ? new { } : routeValues);
            }

            if (saveInCookie.HasValue && saveInCookie.Value)
            {
                //columlarin cookiede oldugunu yoxlayiriq
                var columns = html.ViewContext.RequestContext.HttpContext.Request.GetValue<List<GridColumn>>(id);
                if (columns != null)
                    grid.AddColumns(columns);
            }

            return grid;
        }
        static public GridLookup MhmGridLookup(this HtmlHelper html, string id, [Optional]string action, [Optional]string controller, [Optional] bool? saveInCookie, [Optional] object routeValues)
        {
            var lookup = new GridLookup
            {
                Id = id,
                Html = html
            };

            if (action != null && controller != null)
            {
                var urlHelper = new UrlHelper(html.ViewContext.RequestContext);

                lookup.Action = urlHelper.Action(action, controller, routeValues == null ? new { } : routeValues);
            }

            if (saveInCookie.HasValue && saveInCookie.Value)
            {
                //columlarin cookiede oldugunu yoxlayiriq
                var columns = html.ViewContext.RequestContext.HttpContext.Request.GetValue<List<GridColumn>>(id);
                if (columns != null)
                    lookup.AddColumns(columns);
            }

            return lookup;
        }
        static public MvcHtmlString GetHtml(this Grid grid)
        {
            if (grid.Detail != null)
            {
                //grid.Detail.Ready = @"if (config.rowExpand) {
                //                $(grid).on('rowexpand', function(event) {
                //                var gridId = $(event.currentTarget).attr('id');
                //                    if (grid.expanded) {
                //                        $('#' + gridId).jqxGrid('hiderowdetails', grid.expanded);
                //                        }

                //                        gridId = gridId.replace('ggrid', 'grid');
                //                                    grid.expanded = event.args.rowindex;


                //                        config.rowExpand({
                //                        rowData: $(grid).jqxGrid('getrowdata', event.args.rowindex),
                //                                        parentGridId: 'g' + gridId,
                //                                        detailGridId: 'g' + gridId + `Detail` + event.args.rowindex,
                //                                        rowIndex: event.args.rowindex
                //                                    });
                //                        });
                //                }";
                grid.InitRowDetails = $"function(index, parentElement, gridElement, record)" +
                    @"{var gridId = $(parentElement).children()[0].id; if (gridId != null){                     
                    $('#'+gridId+'').gridInit("
                    + grid.Detail.Html.Raw(JsonConvert.SerializeObject(grid.Detail, Helper.DefaultJsonSerializer)) + ");"
                    + @"var grid=$('#'+$(gridElement)[0].id).CachedGrid();
                        if(grid===null || grid===undefined){ console.error('cached grid is null'); return;}
                            if (grid.config.rowExpand) {
                                        $(grid).off('rowexpand').on('rowexpand', function (event) {
                                            var gridId = $(event.currentTarget).attr('id');
                                            if (grid.expanded) {
                                                $('#' + gridId).jqxGrid('hiderowdetails', grid.expanded);
                                            }
                            
                                            gridId = gridId.replace('ggrid', 'grid');
                                            grid.expanded = event.args.rowindex;
                            
                            
                                            grid.config.rowExpand({
                                                rowData: $(grid).jqxGrid('getrowdata', event.args.rowindex),
                                                parentGridId: 'g' + gridId,
                                                detailGridId: 'g' + gridId + `Detail` + event.args.rowindex,
                                                rowIndex: event.args.rowindex
                                            });
                                        });
                                    if(grid.expanded!==undefined && grid.expanded===index){grid.expanded=null;}
                                    $(grid).jqxGrid('showrowdetails', index);
                                    }
                    }}";
            }
            var config = grid.Html.Raw(JsonConvert.SerializeObject(grid, Helper.DefaultJsonSerializer));
            return MvcHtmlString.Create("<input type='hidden' name='" + grid.Id + "' id='" + grid.Id + "'/><div id='g" + grid.Id + "'></div><script>$(document).ready(function(){$('#g" + grid.Id + "').gridInit(" + config + ");});</script>");
        }

        #region #GridColumn# Fluent Extensions
        static public GridColumn Column(this List<GridColumn> columns, Action<GridColumn> columnSetting)
        {
            var column = new GridColumn();
            column.Filterable = false;
            columns.Add(column);
            columnSetting.Invoke(column);
            return column;
        }

        static public GridColumn SetText(this GridColumn column, string value)
        {
            column.Text = value;
            return column;
        }

        static public GridColumn IsCrud(this GridColumn column, string popupAction, string clickMethod)
        {
            if (string.IsNullOrWhiteSpace(popupAction) || string.IsNullOrWhiteSpace(clickMethod))
                throw new NullReferenceException();
            column.Pinned = true;
            column.Crud = true;
            column.Action = popupAction;
            column.Onclick = clickMethod;
            return column.IsPinned();
        }

        static public GridColumn SetHidden(this GridColumn column, bool hidden = true)
        {
            column.Hidden = hidden;
            return column;
        }

        static public GridColumn SetDataField(this GridColumn column, string fieldName, FieldType fieldType = FieldType.String, string cellFormat = null)
        {
            column.Editable = false;
            column.FieldType = fieldType.ToString().ToLower();
            column.DataField = fieldName;
            column.CellsFormat = cellFormat;
            return column;
        }

        static public GridColumn SetColumnType(this GridColumn column, ColumnType columnType)
        {
            column.ColumnType = columnType.ToString().ToLower();
            return column;
        }

        static public GridColumn SetHeaderAlign(this GridColumn column, TextAlign value = TextAlign.Left)
        {
            column.Align = value.ToString().ToLower();
            return column;
        }

        static public GridColumn SetCellsAlign(this GridColumn column, TextAlign value = TextAlign.Left)
        {
            column.CellsAlign = value.ToString().ToLower();
            return column;
        }

        static public GridColumn SetWidth(this GridColumn column, uint value)
        {
            if (value >= 0)
                column.Width = value.ToString();
            return column;
        }
        static public GridColumn SetWidth(this GridColumn column, string value)
        {
            if (!string.IsNullOrEmpty(value))
            {
                if (!value.EndsWith("%") && !value.EndsWith("px"))
                    value += "%";
                column.Width = value;
            }
            return column;
        }

        static public GridColumn SetMinWidth(this GridColumn column, uint value)
        {
            if (value >= 0)
                column.MinWidth = value;
            return column;
        }

        static public GridColumn SetMaxWidth(this GridColumn column, uint value)
        {
            if (value >= 0)
                column.MaxWidth = value;
            return column;
        }


        /// <summary>
        /// Filtering
        /// </summary>
        /// <param name="column"></param>
        /// <param name="filterType"></param>
        /// <param name="filterItems"></param>
        /// <param name="filterField"></param>
        /// <returns></returns>
        static public GridColumn IsFilterable(this GridColumn column, Filtertype filterType = Filtertype.TextBox, string filterItems = null, string filterField = null, short filterDelay = 0)
        {
            column.Filterable = true;
            column.FilterType = filterType.ToString().ToLower();

            if (filterDelay >= 100)
                column.FilterDelay = filterDelay;

            if (!string.IsNullOrWhiteSpace(filterItems))
            {
                column.FilterItems = filterItems;
                column.FilterSource = "{ source: " + filterItems + ", value: 'value', name: 'text' }";

                switch (filterType)
                {
                    case Filtertype.CheckedList:
                        column.CreateFilterWidget = "function(column, columnElement, widget) {widget.jqxDropDownList({displayMember: 'text', valueMember: 'value'});}";
                        break;
                    case Filtertype.Date:
                    case Filtertype.List:
                    case Filtertype.TextBox:
                    default:
                        break;
                }
            }


            if (!string.IsNullOrWhiteSpace(filterField))
                column.FilterField = filterField;

            return column;
        }
        static public GridColumn IsSortable(this GridColumn column)
        {
            column.Sortable = true;
            return column;
        }

        static public GridColumn IsEditable(this GridColumn column, bool editable = true)
        {
            column.Editable = editable;
            return column;
        }

        static public GridColumn EnableTooltips(this GridColumn column, bool enableToolTip = true)
        {
            column.EnableTooltips = enableToolTip;
            return column;
        }

        static public GridColumn IsResizeable(this GridColumn column)
        {
            column.Resizeable = true;
            return column;
        }

        static public GridColumn IsPinned(this GridColumn column)
        {
            column.Pinned = true;
            return column;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="column">ColumnOfGrid or LookupGrid</param>
        /// <param name="rendererElement">html tag format</param>
        /// <param name="exceptValues">Array Of Excepted Values</param>
        /// <param name="exceptColumnKey">Excepted Key</param>
        /// <param name="htmlAttributes">Html Attributes for element</param>
        /// <returns></returns>
        static public GridColumn SetRenderer(this GridColumn column, string rendererElement, [Optional] string exceptValues, [Optional] string exceptColumnKey, [Optional] object htmlAttributes)
        {
            if (string.IsNullOrEmpty(rendererElement))
                throw new NullReferenceException();
            if (!rendererElement.StartsWith("<"))
                rendererElement = "<" + rendererElement;

            if (!rendererElement.EndsWith(">"))
                rendererElement += ">";

            var builder = new StringBuilder();
            var attrs = htmlAttributes.ReadAttributes();

            var inLabelMatch = Regex.Match(rendererElement, @"<label>(?<context>.+)<\/label>");
            bool inLabel = inLabelMatch.Success;
            if (inLabel)
                rendererElement = inLabelMatch.Groups["context"].Value;

            builder.Append("<$1");
            foreach (var attr in attrs)
            {
                if (attr.Key.Contains("fn-"))
                {
                    builder.AppendFormat(" {0}='javascript:{1}(this,$boundData)'", attr.Key.Replace("fn-", ""), attr.Value);
                    continue;
                }
                builder.AppendFormat(" {0}='{1}'", attr.Key, attr.Value);
            }
            if (inLabel)
                builder.Append(" id='item-$relative'");

            builder.Append("$2>");

            if (inLabel)
                builder.AppendFormat("<label class='operation-label {0}' for='item-$relative'></label>", attrs.ContainsKey("class") ? attrs["class"] : "");

            //@"^<(\w+)(?<tagAttributes>[^>,\.*]+)*>"
            column.CellsRenderer = "function " + column.DataField + "Renderer(Id, dataField, t, s, prop, boundData){" +
                (string.IsNullOrWhiteSpace(exceptColumnKey) && string.IsNullOrWhiteSpace(exceptValues) ? "" : "try{if((" + exceptValues
                + ").indexOf(boundData['" + exceptColumnKey + "'])!==-1) return '';} catch{};")
                + " return (\"" + Regex.Replace(rendererElement, @"^<(\w+)(?<tagAttributes>[^>,\.*]+)*>", builder.ToString()) + "\").replace(/\\$relative/g,Id).replace('$boundData', boundDataClear(boundData));}";
            return column;
        }

        static public GridColumn SetCustomRenderFunction(this GridColumn column, string customRenderFunction)
        {
            if (string.IsNullOrEmpty(customRenderFunction))
                return column;

            column.CellsRenderer = "function(Id, dataField, t, s, prop, boundData){return " + customRenderFunction + "(Id, dataField, t, s, prop, boundData);}";
            return column;
        }
        static public GridColumn SetHeaderRender(this GridColumn column, string renderHtml)
        {
            if (string.IsNullOrEmpty(renderHtml))
                return column;

            column.HeaderRenderer = "function(){return `" + renderHtml + "`;}";
            return column;
        }
        #endregion

        #region #Grid# Fluent Extensions
        //static public Grid SetRowDetails(this Grid grid, string function)
        //{
        //    if (!string.IsNullOrWhiteSpace(function))
        //        grid.InitRowDetails = function;
        //    return grid;
        //}
        static public Grid SetUnRead(this Grid grid, string function)
        {
            if (!string.IsNullOrWhiteSpace(function))
            {
                grid.CheckUnRead = function;               
            }

            return grid;
        }

        static public Grid SetCellsClass(this Grid grid, string function)
        {
            if (!string.IsNullOrWhiteSpace(function))
            {
                grid.GetColumns.ForEach(x => x.CellClassName = function);
            }

            return grid;
        }

        static public Grid SetOnFilter(this Grid grid, string filter)
        {
            if (!string.IsNullOrWhiteSpace(filter))
                grid.Filter = filter;
            return grid;
        }
        static public Grid SetOnReady(this Grid grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value))
                grid.Ready = value;
            return grid;
        }
        static public Grid AllowPaging(this Grid grid, bool value)
        {
            grid.Pageable = value ? (bool?)value : null;
            return grid;
        }

        static public Grid AllowFilterRow(this Grid grid, bool value)
        {
            grid.ShowFilterRow = value ? (bool?)value : null;
            return grid;
        }

        static public Grid AllowSorting(this Grid grid, bool value)
        {
            grid.Sortable = value ? (bool?)value : null;
            return grid;
        }

        static public Grid AllowFiltering(this Grid grid, bool value)
        {
            grid.Filterable = value ? (bool?)value : null;
            return grid;
        }

        static public Grid AllowColumnOrdering(this Grid grid, bool value)
        {
            grid.ColumnsReorder = value ? (bool?)value : null;
            return grid;
        }

        static public Grid ColumnCustomizer(this Grid grid, bool value = false)
        {
            grid.ColumnCustomizer = value;
            return grid;
        }

        static public Grid AllowColumnResizing(this Grid grid, bool value)
        {
            grid.ColumnsResize = value ? (bool?)value : null;
            return grid;
        }

        static public Grid AllowTooltips(this Grid grid, bool value)
        {
            grid.EnableTooltips = value ? (bool?)value : null;
            return grid;
        }

        static public Grid AllowColumnMenu(this Grid grid, bool value)
        {
            grid.ColumnsMenu = value ? (bool?)value : null;
            return grid;
        }

        static public Grid SetAutoShowFilterIcon(this Grid grid, bool value)
        {
            grid.AutoShowFilterIcon = value ? (bool?)value : null;
            return grid;
        }

        static public Grid AllowCrud(this Grid grid)
        {
            grid.Crud = true;
            return grid;
        }

        static public Grid SetAction(this Grid grid, string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new NullReferenceException();

            grid.Action = value;
            return grid;
        }

        static public Grid SetValueMember(this Grid grid, string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new NullReferenceException();

            grid.ValueMember = value;
            return grid;
        }

        static public Grid SetWidth(this Grid grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value) && int.Parse(value.Replace(".", "").Replace(",", "").Replace("%", "").Replace("px", "")) > 0)
                grid.Width = value;
            return grid;
        }

        static public Grid SetHeight(this Grid grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value) && int.Parse(value.Replace(".", "").Replace(",", "").Replace("%", "").Replace("px", "").Replace("vh", "")) > 0)
                grid.Height = value;
            return grid;
        }

        static public Grid SetRowSelectChanged(this Grid grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value))
                grid.RowSelect = value;
            return grid;
        }

        static public Grid SetRowClick(this Grid grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value))
                grid.RowClick = value;
            return grid;
        }

        static public Grid SetRowDoubleClick(this Grid grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value))
                grid.RowDoubleClick = value;
            return grid;
        }

        static public Grid SetCellClick(this Grid grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value))
                grid.CellClick = value;
            return grid;
        }

        /// <summary>
        /// Detail Grid Acilanda isleyir
        /// </summary>

        static public Grid SetRowExpand(this Grid grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value))
                grid.RowExpand = value;
            return grid;
        }

        /// <summary>
        /// Detail Grid Qapananda isleyir
        /// </summary>
        static public Grid SetRowCollapse(this Grid grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value))
                grid.RowCollapse = value;
            return grid;
        }

        static public Grid SetPageSize(this Grid grid, int value)
        {
            grid.PageSize = value < 5 ? 5 : value;
            return grid;
        }

        static public Grid SetPageMode(this Grid grid, string value = "simple")
        {
            grid.PagerMode = value;
            return grid;
        }
        static public Grid SetSelectionMode(this Grid grid, SelectionMode value = SelectionMode.Checkbox)
        {
            grid.SelectionMode = value.ToString();
            return grid;
        }
        static public Grid SetEditable(this Grid grid, bool value = true)
        {
            grid.IsEditable = value;
            return grid;
        }
        #endregion

        #region #GridLookup# Fluent Extensions
        static public GridLookup AllowPaging(this GridLookup grid, bool value)
        {
            grid.Pageable = value ? (bool?)value : null;
            return grid;
        }

        static public GridLookup AllowFilterRow(this GridLookup grid, bool value)
        {
            grid.ShowFilterRow = value ? (bool?)value : null;
            return grid;
        }

        static public GridLookup AllowSorting(this GridLookup grid, bool value)
        {
            grid.Sortable = value ? (bool?)value : null;
            return grid;
        }

        static public GridLookup AllowFiltering(this GridLookup grid, bool value)
        {
            grid.Filterable = value ? (bool?)value : null;
            return grid;
        }

        static public GridLookup AllowColumnOrdering(this GridLookup grid, bool value)
        {
            grid.ColumnsReorder = value ? (bool?)value : null;
            return grid;
        }

        static public GridLookup AllowColumnResizing(this GridLookup grid, bool value)
        {
            grid.ColumnsResize = value ? (bool?)value : null;
            return grid;
        }

        static public GridLookup AllowTooltips(this GridLookup grid, bool value)
        {
            grid.EnableTooltips = value ? (bool?)value : null;
            return grid;
        }

        static public GridLookup AllowColumnMenu(this GridLookup grid, bool value)
        {
            grid.ColumnsMenu = value ? (bool?)value : null;
            return grid;
        }

        static public GridLookup SetAutoShowFilterIcon(this GridLookup grid, bool value)
        {
            grid.AutoShowFilterIcon = value ? (bool?)value : null;
            return grid;
        }

        static public GridLookup AllowCrud(this GridLookup grid)
        {
            grid.Crud = true;
            return grid;
        }

        static public GridLookup SetAction(this GridLookup grid, string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new NullReferenceException();

            grid.Action = value;
            return grid;
        }

        static public GridLookup SetValueMember(this GridLookup grid, string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new NullReferenceException();

            grid.ValueMember = value;
            return grid;
        }



        static public GridLookup SetDisplayMember(this GridLookup grid, string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new NullReferenceException();

            grid.DisplayMember = value;
            return grid;
        }


        static public GridLookup SetWidth(this GridLookup grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value) && int.Parse(value.Replace(".", "").Replace(",", "").Replace("%", "").Replace("px", "")) > 0)
                grid.Width = value;
            return grid;
        }

        static public GridLookup SetHeight(this GridLookup grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value) && int.Parse(value.Replace(".", "").Replace(",", "").Replace("%", "").Replace("px", "")) > 0)
                grid.Height = value;
            return grid;
        }

        static public GridLookup SetRowSelectChanged(this GridLookup grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value))
                grid.RowSelect = value;
            return grid;
        }

        static public GridLookup SetRowClick(this GridLookup grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value))
                grid.RowClick = value;
            return grid;
        }

        static public GridLookup SetRowDoubleClick(this GridLookup grid, string value)
        {
            if (!string.IsNullOrWhiteSpace(value))
                grid.RowDoubleClick = value;
            return grid;
        }

        static public GridLookup SetPageSize(this GridLookup grid, int value)
        {
            grid.PageSize = value < 5 ? 5 : value;
            return grid;
        }

        static public GridLookup SetPageMode(this GridLookup grid, string value = "simple")
        {
            grid.PagerMode = value;
            return grid;
        }
        static public GridLookup SetSelectionMode(this GridLookup grid, SelectionMode value = SelectionMode.Checkbox)
        {
            grid.SelectionMode = value.ToString();
            return grid;
        }

        static public MvcHtmlString GetHtml(this GridLookup grid)
        {
            var config = grid.Html.Raw(JsonConvert.SerializeObject(grid, Helper.DefaultJsonSerializer));
            return MvcHtmlString.Create("<div class='dropdown'><input class='form-control dropdown-toggle lookup-editor' type='text' id='t" + grid.Id
                + "' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false' /><label class='lookup-editor' for='t" + grid.Id
                + "'></label><div class='dropdown-menu mhm-hidden-display' aria-labelledby='t" + grid.Id + "' style='min-width:850px;padding: 0'><input type='hidden' name='" + grid.Id
                + "' id='" + grid.Id + "'/><div id='gl" + grid.Id + "'></div></div></div><script>$(document).ready(function(){$('#gl" + grid.Id
                + "').gridInit(" + config + ");});</script>");
        }
        #endregion
    }
}