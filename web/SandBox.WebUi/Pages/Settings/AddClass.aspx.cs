using System;
using System.Collections.Generic;
using SandBox.Db;
using SandBox.Log;
using SandBox.WebUi.Base;
using System.Linq;
using DevExpress.Web.ASPxGridView;
using System.Security.Cryptography;
using SandBox.Connection;
using System.Text;
using DevExpress.Web.ASPxEditors;
using System.Data;
using System.Web.UI;

namespace SandBox.WebUi.Account
{
    public partial class AddClass : BaseMainPage
    {
        protected new void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Добавление класса ВПО";
            PageMenu = "~/App_Data/SideMenu/Settings/SettingsMenu.xml";

            if (!IsPostBack)
            {
                CBNetActiv.Items.AddRange(ReportManager.GetEventsDescrByModuleList("Сеть"));
                CBNetActiv.SelectedIndex = 0;
                CBFileActiv.Items.AddRange(ReportManager.GetEventsDescrByModuleList("Файловая система"));
                CBFileActiv.SelectedIndex = 0;
                CBRegActiv.Items.AddRange(ReportManager.GetEventsDescrByModuleList("Реестр"));
                CBRegActiv.SelectedIndex = 0;
                CBProcActiv.Items.AddRange(ReportManager.GetEventsDescrByModuleList("Процессы"));
                CBProcActiv.SelectedIndex = 0;
                lbFSParams.DataSource = dsFSParams;
                lbFSParams.DataBind();
                lbRegParams.DataSource = dsRegParams;
                lbRegParams.DataBind();
                lbProcParams.DataSource = dsProcParams;
                lbProcParams.DataBind();
                lbNetParams.DataSource = dsNetParams;
                lbNetParams.DataBind();
            }
        }

        protected DataTable dsFSParams
        {
            get
            {
                if (Session["dsFSParams"] == null)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("ID");
                    dt.Columns.Add("Task");
                    dt.Columns.Add("Param");
                    Session["dsFSParams"] = dt;
                }
                return Session["dsFSParams"] as DataTable;
            }
        }

        protected DataTable dsRegParams
        {
            get
            {
                if (Session["dsRegParams"] == null)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("ID");
                    dt.Columns.Add("Task");
                    dt.Columns.Add("Param");
                    Session["dsRegParams"] = dt;
                }
                return Session["dsRegParams"] as DataTable;
            }
        }

        protected DataTable dsProcParams
        {
            get
            {
                if (Session["dsProcParams"] == null)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("ID");
                    dt.Columns.Add("Task");
                    dt.Columns.Add("Param");
                    Session["dsProcParams"] = dt;
                }
                return Session["dsProcParams"] as DataTable;
            }
        }

        protected DataTable dsNetParams
        {
            get
            {
                if (Session["dsNetParams"] == null)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("ID");
                    dt.Columns.Add("Task");
                    dt.Columns.Add("Param");
                    Session["dsNetParams"] = dt;
                }
                return Session["dsNetParams"] as DataTable;
            }
        }

        protected void BtnCreateClick(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(tbClass.Text))
            {
                tbClass.IsValid = false;
                return;
            }
            MlwrClass mlcl = MlwrManager.GetClass(tbClass.Text);
            if (mlcl != null)
            {
                tbClass.ValidationSettings.ErrorText = "Такой класс уже существует";
                tbClass.IsValid = false;
                return;
            }

            //int sign = Convert.ToInt32(cbSign.Value)+1;
            //Int32 evt = Convert.ToInt32(cbEvent.Value);
            //int module = ReportManager.GetModuleIdByEventId(evt);
            //string dest = tbDest.Text;
            //string who = tbWho.Text;
            //if (module != -1 && evt != -1 && dest != String.Empty && who != String.Empty)
            //{
            //    ReportManager.InsertRowDirectoriesOfEvents(sign, module, evt, dest, who);
            //}
            if (lbFSParams.Items.Count == 0 && lbRegParams.Items.Count == 0 && lbProcParams.Items.Count == 0 && lbNetParams.Items.Count == 0)
            {
                string scriptstring = "alert(\"Необходимо указать хотя бы один параметр класса.\");";
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "alert", scriptstring, true);
            }
            else
            {
                Int32 classid = MlwrManager.AddMlwrClass(tbClass.Text,mmClass.Text);
                foreach (ListEditItem item in lbFSParams.Items) MlwrManager.AddMlwrClassItem(classid, item.GetValue("Task").ToString(), item.GetValue("Param").ToString());
                foreach (ListEditItem item in lbRegParams.Items) MlwrManager.AddMlwrClassItem(classid, item.GetValue("Task").ToString(), item.GetValue("Param").ToString());
                foreach (ListEditItem item in lbProcParams.Items) MlwrManager.AddMlwrClassItem(classid, item.GetValue("Task").ToString(), item.GetValue("Param").ToString());
                foreach (ListEditItem item in lbNetParams.Items) MlwrManager.AddMlwrClassItem(classid, item.GetValue("Task").ToString(), item.GetValue("Param").ToString());
                Response.Redirect("~/Pages/Settings/Main.aspx");
            }
        }

    }//end class
}//end namespace