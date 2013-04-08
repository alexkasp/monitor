using System;
using System.Collections.Generic;
using SandBox.Db;
using SandBox.Log;
using SandBox.WebUi.Base;

namespace SandBox.WebUi.Account
{
    public partial class EditEvent : BaseMainPage
    {
        public Int32 dofid;

        protected new void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Редактирование события";
            PageMenu = "~/App_Data/SideMenu/Settings/SettingsMenu.xml";
            dofid = Convert.ToInt32(Request.QueryString["dofid"]);
            if (dofid == 0)
            {
                try
                {
                    dofid = (int)Session["dofid"];
                }
                catch
                {
                }
            }
            Session["dofid"] = dofid;
            DirectoryOfEvents dof = ReportManager.GetDirectorysOfEvent(dofid);
            if (dof == null)
            {
                Response.Redirect("~/Error");
            }

            if (!IsPostBack)
            {
                cbModule.DataSource = ReportManager.GetModules();
                cbModule.DataBind();
                cbModule.SelectedItem = cbModule.Items.FindByText(ReportManager.GetModuleById(dof.module));
                cbEvent.DataSource = ReportManager.GetEventsDescrByModuleId(dof.module);
                cbEvent.DataBind();
                cbEvent.SelectedItem=cbEvent.Items.FindByValue(dof.@event.ToString());
                tbDest.Text = dof.dest;
                tbWho.Text = dof.who;
                cbSign.SelectedIndex = dof.significance - 1;
            }
        }

        protected void BtnEditClick(object sender, EventArgs e)
        {
            dofid = (int)Session["dofid"];
            int sign = Convert.ToInt32(cbSign.Value)+1;
            Int32 evt = Convert.ToInt32(cbEvent.Value);
            int module = ReportManager.GetModuleIdByEventId(evt);
            string dest = tbDest.Text;
            string who = tbWho.Text;
            if (module != -1 && evt != -1 && dest != String.Empty && who != String.Empty)
            {
                ReportManager.UpdateRowDirectoriesOfEvents(dofid, sign, module, evt, dest, who);
            }
            Response.Redirect("~/Pages/Settings/Main.aspx");
        }

        protected void cbEvent_Callback(object sender, DevExpress.Web.ASPxClasses.CallbackEventArgsBase e)
        {
            if (string.IsNullOrEmpty(e.Parameter)) return;
            cbEvent.DataSource = ReportManager.GetEventsDescrByModule(e.Parameter);
            cbEvent.DataBind();
            cbEvent.SelectedIndex = 0;
        }

    }//end class
}//end namespace