﻿using System;
using System.Collections.Generic;
using System.Linq;
using SandBox.Db;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DevExpress.Web.ASPxGridView;
using DevExpress.Web.ASPxEditors;
using System.Web.Security;


namespace SandBox.WebUi.Pages.Research
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Layout lt = WebTables.GetLayout((int)Membership.GetUser().ProviderUserKey, "SearchTable");
                if (lt != null)
                    gridSearchView.LoadClientLayout(lt.UserLayout);
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
                    }
                    if (SearchTextBox.Text == "") { gridSearchView.FilterExpression = ""; }
                    else { gridSearchView.FilterExpression = string.Format("contains([who],'{0}') or contains([dest],'{0}')", SearchTextBox.Text); }
                    gridSearchView.DataBind();
                    break;
                case "ApplyExtFilter":
                    if (!gridSearchView.ClientVisible)
                    {
                        gridSearchView.ClientVisible = true;
                        SearchTableMenu.ClientVisible = true;
                        SearchTableFilterMenu.ClientVisible = true;
                        SearchTableExportMenu.ClientVisible = true;
                    }
                    gridSearchView.FilterExpression = ExtFilter.FilterExpression;
                    gridSearchView.DataBind();
                    break;
                case "SaveLayout":
                    WebTables.SetLayout((int)Membership.GetUser().ProviderUserKey, "SearchTable", gridSearchView.SaveClientLayout());
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
            if (e.Column.FieldName != "who" && e.Column.FieldName != "dest") return;
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