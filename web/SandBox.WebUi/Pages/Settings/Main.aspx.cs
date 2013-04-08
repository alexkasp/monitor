using System;
using System.Diagnostics;
using SandBox.Db;
using NLog;
using SandBox.WebUi.Base;
using DevExpress.Web.ASPxGridView;
using System.Drawing;
using System.Linq;
using System.Collections.Generic;

namespace SandBox.WebUi.Pages.Settings
{
    public partial class Main : BaseMainPage
    {
        private static readonly Logger Log = LogManager.GetCurrentClassLogger();

        protected new void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Настройки";
            PageMenu = "~/App_Data/SideMenu/Settings/SettingsMenu.xml";

            if (!User.IsInRole("Administrator")) pcSettings.TabPages.FindByName("UserTab").ClientVisible = false;   

            if (!IsPostBack)
            {
                gridViewUsers.DataSource = UserManager.GetUsersTableView();
                gridViewUsers.DataBind();
                gridClEvView.DataSource = ReportManager.GetDirectoriesOfEvents();
                gridClEvView.DataBind();
                gridClVPOView.DataSource = MlwrManager.GetMlwrClassItems();
                gridClVPOView.DataBind();
            }
            
            UpdateTableView();
        }

        private void UpdateTableView()
        {
            switch (pcSettings.ActiveTabIndex)
            {
                case 0:
                    gridViewUsers.DataSource = UserManager.GetUsersTableView();
                    gridViewUsers.DataBind();
                    break;
                case 1:
                    gridClEvView.DataSource = ReportManager.GetDirectoriesOfEvents();
                    gridClEvView.DataBind();
                    break;
                case 2:
                    gridClVPOView.DataSource = MlwrManager.GetMlwrClassItems();
                    gridClVPOView.DataBind();
                    break;
            }
        }

        protected void gridViewUsers_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            Int32 userId = 0;
            try
            {
                userId = (Int32)gridViewUsers.GetRowValues(e.VisibleIndex, new[] { "UserId" });
            }
            catch (Exception)
            {
                userId = 0;
            }

            if (userId == 0) return;
            if (e.ButtonID == "cbEdit")
            {
                EditUser(userId);
                return;
            }
            if (e.ButtonID == "cbDelete")
            {
                DeleteUser(userId);
                gridViewUsers.DataSource = UserManager.GetUsersTableView();
                gridViewUsers.DataBind();
                return;
            }
        }

        private void EditUser(Int32 userId)
        {
            Debug.Print("Edit user id: " + userId);
        }

        private void DeleteUser(Int32 userId)
        {
            UserManager.DeleteUser(userId);
        }

        protected void gridViewUsers_CustomCallback(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs e)
        {
            string[] Params = e.Parameters.Split(',');
            Int32 id = Convert.ToInt32(Params[1]);
            switch (Params[0])
            {
                case "cbDelete":
                    DeleteUser(id);
                    UpdateTableView();

                    break;
            }

        }

        protected void gridClEvView_CustomCallback(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs e)
        {
            string[] Params = e.Parameters.Split(',');
            Int32 id = Convert.ToInt32(Params[1]);
            switch (Params[0])
            {
                case "cbEvDelete":
                    ReportManager.DeleteDirectorysOfEvent(id);
                    UpdateTableView();
                    break;
            }
        }

        protected void gridClVPOView_CustomCallback(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs e)
        {
            string[] Params = e.Parameters.Split(',');
            Int32 id = Convert.ToInt32(Params[1]);
            switch (Params[0])
            {
                case "cbClDelete":
                    MlwrClass mlcl = MlwrManager.GetClassByItemId(id);
                    MlwrManager.DeleteMlwrClassItem(id);
                    if (MlwrManager.GetClassItemsCount(mlcl.id)==0) MlwrManager.DeleteMlwrClass(mlcl.id);
                    UpdateTableView();
                    break;
            }
        }

        protected void gridClVPOView_HtmlRowPrepared(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType == GridViewRowType.Group && gridClVPOView.GetRowLevel(e.VisibleIndex) == 0)
                e.Row.BackColor = Color.FromArgb(204, 204, 204);
        }

        protected void RefreshVPOClass()
        {
            MlwrManager.ClearVPOClassTable();
            IQueryable<Mlwr> mlwrs = MlwrManager.GetMlwrs();
            IQueryable<MlwrClass> mlwrcls = MlwrManager.GetClasses();
            foreach (Mlwr mlwr in mlwrs) {
                IEnumerable<int> mlwrvpoclitms = MlwrManager.GetVPOClassItemsId(mlwr.Id);
                if (mlwrvpoclitms.Count() > 0)
                    foreach (MlwrClass mlwrcl in mlwrcls)
                    {
                        IEnumerable<int> mlwrclitms = MlwrManager.GetClassItemsId(mlwrcl.id);
                        if (mlwrclitms.Count() > 0)
                            if (mlwrclitms.Except(mlwrvpoclitms).Count() == 0) MlwrManager.AddVPOClass(mlwr.Id, mlwrcl.id);
                    }
            } 
        }

        protected void btnRefreshVPO_Click(object sender, EventArgs e)
        {
            RefreshVPOClass();
        }


    }//end class
}//end namespace