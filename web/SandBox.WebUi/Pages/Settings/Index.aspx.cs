using System;
using SandBox.WebUi.Base;

namespace SandBox.WebUi.Pages.Settings
{
    public partial class Index : BaseMainPage
    {
        protected new void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Настройки";
            PageMenu  = "~/App_Data/SideMenu/Settings/SettingsMenu.xml";

            if (IsUserInRole("Administrator") || IsUserInRole("User"))
            {
                Response.Redirect("~/Pages/Settings/Main.aspx");
            }
            else
            {
                Response.Redirect("~/Account/Login.aspx");
            }
        }
    }//end Index class
}//end namespace