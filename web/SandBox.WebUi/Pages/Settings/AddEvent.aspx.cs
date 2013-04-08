using System;
using System.Collections.Generic;
using SandBox.Db;
using SandBox.Log;
using SandBox.WebUi.Base;

namespace SandBox.WebUi.Account
{
    public partial class AddEvent : BaseMainPage
    {
        protected new void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Добавление события";
            PageMenu = "~/App_Data/SideMenu/Settings/SettingsMenu.xml";

            if (!IsPostBack)
            {
                cbModule.DataSource = ReportManager.GetModules();
                cbModule.DataBind();
                cbModule.SelectedIndex = 0;
                cbEvent.DataSource = ReportManager.GetEventsDescrByModule(cbModule.Value.ToString());
                cbEvent.DataBind();
                cbEvent.SelectedIndex = 0;
            }
        }

        protected void BtnCreateClick(object sender, EventArgs e)
        {
            int sign = Convert.ToInt32(cbSign.Value)+1;
            Int32 evt = Convert.ToInt32(cbEvent.Value);
            int module = ReportManager.GetModuleIdByEventId(evt);
            string dest = tbDest.Text;
            string who = tbWho.Text;
            if (module != -1 && evt != -1 && dest != String.Empty && who != String.Empty)
            {
                ReportManager.InsertRowDirectoriesOfEvents(sign, module, evt, dest, who);
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