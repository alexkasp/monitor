using System;
using System.Collections.Generic;
using System.Linq;
using SandBox.Db;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web.ASPxGridView;
using DevExpress.Web.ASPxEditors;
using System.Web.Security;
using System.Text;
using System.Drawing;

namespace SandBox.WebUi.Pages.Research
{
    public partial class WebForm1 : System.Web.UI.Page
    {

        string separator = "!!!";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Layout lt = WebTables.GetLayout((int)Membership.GetUser().ProviderUserKey, "SearchTable");
                if (lt != null)
                {
                    string customState = lt.UserLayout.Substring(0, lt.UserLayout.IndexOf(separator));
                    gridSearchView.Settings.ShowFilterRow = customState[0].ToString() == "T";
                    string gridState = lt.UserLayout.Substring(customState.Length + separator.Length);
                    gridSearchView.LoadClientLayout(gridState);
                }
                SearchTableFilterMenu.Items.FindByName("ShowFiterRow").Checked = gridSearchView.Settings.ShowFilterRow;
            }
        }

        protected void gridSearchView_CustomCallback(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs e)
        {
            switch (e.Parameters)
            {
                case "ApplyFilter":
                    if (!gridSearchView.ClientVisible)
                    {
                        gridSearchView.ClientVisible = true;
                        SearchTableMenu.ClientVisible = true;
                        SearchTableFilterMenu.ClientVisible = true;
                        SearchTableExportMenu.ClientVisible = true;
                        OpenReportMenu.ClientVisible = true;
                    }
                    if (SearchTextBox.Text == "") { gridSearchView.FilterExpression = ""; }
                    else { 
                        int number;
                        if (Int32.TryParse(SearchTextBox.Text, out number)) gridSearchView.FilterExpression = string.Format("contains([Id],'{0}') or contains([timeofevent],'{0}') or contains([pid1],'{0}') or contains([pid2],'{0}') or contains([who],'{0}') or contains([dest],'{0}') or contains([adddata1],'{0}') or contains([adddata2],'{0}')", SearchTextBox.Text); 
                        else gridSearchView.FilterExpression = string.Format("contains([who],'{0}') or contains([dest],'{0}') or contains([adddata1],'{0}') or contains([adddata2],'{0}')", SearchTextBox.Text); 
                    }
                    gridSearchView.DataBind();
                    break;
                case "ApplyExtFilter":
                    if (!gridSearchView.ClientVisible)
                    {
                        gridSearchView.ClientVisible = true;
                        SearchTableMenu.ClientVisible = true;
                        SearchTableFilterMenu.ClientVisible = true;
                        SearchTableExportMenu.ClientVisible = true;
                        OpenReportMenu.ClientVisible = true;
                    }
                    gridSearchView.FilterExpression = ExtFilter.FilterExpression;
                    gridSearchView.DataBind();
                    break;
                case "SaveLayout":
                    StringBuilder sb = new StringBuilder();
                    sb.Append(gridSearchView.Settings.ShowFilterRow ? "T" : "F");
                    sb.Append(separator);

                    sb.Append(gridSearchView.SaveClientLayout());

                    WebTables.SetLayout((int)Membership.GetUser().ProviderUserKey, "SearchTable", sb.ToString());
                    break;
                case "ShowFilterRow":
                    DevExpress.Web.ASPxMenu.MenuItem mitem = SearchTableFilterMenu.Items.FindByName("ShowFiterRow");
                    mitem.Checked = !mitem.Checked;
                    gridSearchView.Settings.ShowFilterRow = mitem.Checked;
                    gridSearchView.Settings.ShowFilterRowMenu = mitem.Checked;
                    break;
            }
            //if (!gridSearchViewPager.Visible) gridSearchViewPager.Visible = true;
            //gridSearchViewPager.ItemCount = gridSearchView.VisibleRowCount;
            //gridSearchViewPager.ItemsPerPage = gridSearchView.SettingsPager.PageSize;
            //gridSearchViewPager.PageIndex = gridSearchView.PageIndex;
        }

        //protected void gridSearchViewPager_PageIndexChanged(object sender, EventArgs e)
        //{
        //    gridSearchView.PageIndex = gridSearchViewPager.PageIndex;
        //    gridSearchView.DataBind();
        //}

        //protected void gridSearchViewPager_PageSizeChanged(object sender, EventArgs e)
        //{
        //    gridSearchView.SettingsPager.PageSize = gridSearchViewPager.ItemsPerPage;
        //    gridSearchView.DataBind();
        //}

        protected void gridSearchView_CustomColumnDisplayText(object sender, ASPxGridViewColumnDisplayTextEventArgs e)
        {
            if (e.Value == null || SearchTextBox.Text == string.Empty) return;
            string searchText = SearchTextBox.Text;
            string highlightedText = e.Value.ToString();

            if (!highlightedText.Contains(searchText) || searchText == null || searchText == string.Empty)
                return;
            e.DisplayText = highlightedText.Replace(searchText, "<span class='highlight'>" + searchText + "</span>");

        }

        protected void ExportPDFBtn_Click(object sender, EventArgs e)
        {
            gridExport.PageHeader.Left = "Имя пользователя: " + Membership.GetUser().UserName + " ([Имя пользователя])";
            gridExport.WritePdfToResponse();
        }

        protected void ExportXLSBtn_Click(object sender, EventArgs e)
        {
            gridExport.PageHeader.Left = "Имя пользователя: " + Membership.GetUser().UserName + " ([Имя пользователя])";
            gridExport.WriteXlsToResponse();
        }

        protected void ExportXLSXBtn_Click(object sender, EventArgs e)
        {
            gridExport.PageHeader.Left = "Имя пользователя: " + Membership.GetUser().UserName + " ([Имя пользователя])";
            gridExport.WriteXlsxToResponse();
        }

        protected void ExportRTFBtn_Click(object sender, EventArgs e)
        {
            gridExport.PageHeader.Left = "Имя пользователя: " + Membership.GetUser().UserName + " ([Имя пользователя])";
            gridExport.WriteRtfToResponse();
        }

        protected void ExportCSVBtn_Click(object sender, EventArgs e)
        {
            gridExport.PageHeader.Left = "Имя пользователя: " + Membership.GetUser().UserName + " ([Имя пользователя])";
            gridExport.WriteCsvToResponse();
        }

        protected void gridSearchView_CustomJSProperties(object sender, ASPxGridViewClientJSPropertiesEventArgs e)
        {
            int startIndex = gridSearchView.PageIndex * gridSearchView.SettingsPager.PageSize;
            int end = Math.Min(gridSearchView.VisibleRowCount, startIndex + gridSearchView.SettingsPager.PageSize);
            object[] rschId = new object[end - startIndex];
            for (int n = startIndex; n < end; n++)
            {
                rschId[n - startIndex] = gridSearchView.GetRowValues(n, "rschId");
            }
            e.Properties["cprschId"] = rschId;
        }

        protected void gridSearchView_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != DevExpress.Web.ASPxGridView.GridViewRowType.Data) return;
            switch (Convert.ToInt32(e.GetValue("significance")))
            {
                case 1:
                    {
                        e.Row.BackColor = Color.SandyBrown;
                        break;
                    }
                case 2:
                    {
                        e.Row.BackColor = Color.Salmon;
                        break;
                    }
            }

        }

        //protected void ReportLink_Init(object sender, EventArgs e)
        //{
        //    var link = (ASPxHyperLink)sender;
        //    var templateContainer = (GridViewGroupRowTemplateContainer)link.NamingContainer;
        //    link.ID = string.Format("ReportLink{0}", templateContainer.VisibleIndex);
        //}


        //protected virtual string GetLabelText(GridViewGroupRowTemplateContainer container)
        //{
        //    return "Исследоваине № (" + container.GroupText + ") ";
        //}

        //protected void gridSearchView_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        //{
        //    if (gridSearchView.ClientVisible && e.RowType == GridViewRowType.Group)
        //    {

        //        var link = (ASPxHyperLink)gridSearchView.FindGroupRowTemplateControl(e.VisibleIndex, string.Format("ReportLink{0}", e.VisibleIndex));
        //        if (link != null) link.NavigateUrl = "/Pages/Research/ReportList.aspx?researchId=" + e.GetValue("rschId").ToString();
        //    }
        //}
    }
}