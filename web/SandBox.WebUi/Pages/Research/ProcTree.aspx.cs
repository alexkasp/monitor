using System;
using System.Diagnostics;
using SandBox.Db;
using SandBox.Log;
using SandBox.WebUi.Base;
using DevExpress.Web.ASPxTreeList;
using System.Collections.Generic;

namespace SandBox.WebUi.Pages.Research
{
    public partial class ProcTree : BaseMainPage
    {
        public Int32 researchId;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Список процессов";
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
            ProcTreeList.DataSource = TreeViewBuilder.GetProcsTableView(researchId);
            ProcTreeList.KeyFieldName = "Pid1";
            ProcTreeList.ParentFieldName = "Pid2";
            ProcTreeList.DataBind();
        }
        protected void ProcTree_VirtualModeNodeCreating(object sender, TreeListVirtualModeNodeCreatingEventArgs e)
        {
            Procs rowView = e.NodeObject as Procs;
            if (rowView == null) return;
            e.NodeKeyValue = rowView.Pid1;
            e.SetNodeValue("Name", rowView.Name);
            e.SetNodeValue("PID", rowView.Pid1);
            e.SetNodeValue("ThrCount", rowView.Count);
        }

        protected void ProcTree_VirtualModeCreateChildren(object sender, TreeListVirtualModeCreateChildrenEventArgs e)
        {
            List<Procs> children = null;
            Procs parent = e.NodeObject as Procs;
            if (parent == null)
            {
                children = TreeViewBuilder.GetProcTableViewByParentId((int)Session["rsch"], 0);
                if (children.Count == 0) ProcTreeList.ClearNodes();
            }
            else
            {
                children = TreeViewBuilder.GetProcTableViewByParentId((int)Session["rsch"], (int)parent.Pid1);
            }
            e.Children = children;
        }
    }
}