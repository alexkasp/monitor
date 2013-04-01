using System;
using System.Diagnostics;
using SandBox.Db;
using SandBox.Log;
using SandBox.WebUi.Base;
using DevExpress.Web.ASPxTreeList;
using System.Collections.Generic;

namespace SandBox.WebUi.Pages.Research
{
    public partial class RegsTree : BaseMainPage
    {
        public Int32 researchId;

        protected void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Образ реестра";
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
            RegRoot.Text = TaskManager.GetRegRootForRsch(researchId);
            if (!IsPostBack)
            {
                Debug.Print("Get research id = " + researchId);
            }
        }


        protected void RegTree_VirtualModeNodeCreating(object sender, TreeListVirtualModeNodeCreatingEventArgs e)
        {
            Regs rowView = e.NodeObject as Regs;
            if (rowView == null) return;
            e.NodeKeyValue = rowView.KeyIndex;
            e.SetNodeValue("KeyName", rowView.KeyName);
        }

        protected void RegTree_VirtualModeCreateChildren(object sender, TreeListVirtualModeCreateChildrenEventArgs e)
        {
            List<Regs> children = null;
            Regs parent = e.NodeObject as Regs;
            if (parent == null)
            {
                children = TreeViewBuilder.GetRegsTableViewByParentId((int)Session["rsch"], 0);
                if (children.Count == 0) RegTreeList.ClearNodes();
            }
            else
            {
                children = TreeViewBuilder.GetRegsTableViewByParentId((int)Session["rsch"], (int)parent.KeyIndex);
            }
            e.Children = children;
        }

    }
}