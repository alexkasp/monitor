using System;
using System.Diagnostics;
using SandBox.Db;
using SandBox.Log;
using SandBox.WebUi.Base;
using DevExpress.Web.ASPxTreeList;
using System.Collections.Generic;

namespace SandBox.WebUi.Pages.Research
{
    public partial class FilesTree : BaseMainPage
    {
        public Int32 researchId;

        protected void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Образ файловой системы";
            PageMenu = "~/App_Data/SideMenu/Research/ResearchMenu.xml";
            researchId = Convert.ToInt32(Request.QueryString["researchId"]);
            if (researchId == 0)
            {
                try
                {
                    researchId = (int)Session["rsch"];
                }
                catch
                {
                }
            }
            Session["rsch"] = researchId;
            Db.Research rsch = ResearchManager.GetResearch(researchId);
            if (rsch == null)
            {
                Response.Redirect("~/Error");
            }
            ResearchTitle.Text = String.Format("Исследование (№{0}): {1}", rsch.Id, rsch.ResearchName);
            LOS.Text = ResearchManager.GetRschOS(researchId);
            FilesRoot.Text = TaskManager.GetFileRootForRsch(researchId);
            if (!IsPostBack)
            {
                Debug.Print("Get research id = " + researchId);
            }
        }


        protected void FileTree_VirtualModeNodeCreating(object sender, TreeListVirtualModeNodeCreatingEventArgs e)
        {
            Files rowView = e.NodeObject as Files;
            if (rowView == null) return;
            e.NodeKeyValue = rowView.fileindex;
            e.IsLeaf = !rowView.IsDir;
            e.SetNodeValue("Name", rowView.Name);
            if (rowView.IsDir) e.SetNodeValue("IconName", "reg_dir");
            else e.SetNodeValue("IconName", "reg_file");
        }

        protected void FileTree_VirtualModeCreateChildren(object sender, TreeListVirtualModeCreateChildrenEventArgs e)
        {
            List<Files> children = null;
            Files parent = e.NodeObject as Files;
            if (parent == null)
            {
                children = TreeViewBuilder.GetFilesTableViewByParentId((int)Session["rsch"], 0);
                if (children.Count == 0) FileTreeList.ClearNodes();
            }
            else
            {
                children = TreeViewBuilder.GetFilesTableViewByParentId((int)Session["rsch"], (int)parent.fileindex);
            }
            e.Children = children;
        }

        protected string GetIconUrl(TreeListDataCellTemplateContainer container)
        {
            return string.Format("~/Content/Images/Icons/{0}.png", container.GetValue("IconName"));
        }
    }
}