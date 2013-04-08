using System;
using System.Collections.Generic;
using SandBox.Db;
using SandBox.Log;
using SandBox.WebUi.Base;

namespace SandBox.WebUi.Account
{
    public partial class AddUser : BaseMainPage
    {
        protected new void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Добавление нового пользователя";
            PageMenu = "~/App_Data/SideMenu/Settings/SettingsMenu.xml";

            if (!IsPostBack)
            {
                List<string> rolesList = UserManager.GetRoleList();
                //cbRole.DataSource = rolesList;
                //cbRole.DataBind();
                cblRole.DataSource = rolesList;
                cblRole.DataBind();
            }
        }

        protected void BtnCreateClick(object sender, EventArgs e)
        {
            String login = tbLogin.Text;
            User user = UserManager.GetdbUser(login);
            if (user != null)
            {
                tbLogin.ValidationSettings.ErrorText = "Такой логин уже существует";
                tbLogin.IsValid = false;
                return;
            }
            String username = tbUserName.Text;
            String password = tbPassword.Text;
            String confirmPassword = tbPasswordConfirm.Text;
            if (password!=confirmPassword)
            {
                tbPasswordConfirm.IsValid=false;
                return;
            }
            String role = cblRole.SelectedItems[0].ToString();
            Int32 roleId = UserManager.GetRole(role).RoleId;
            if (cblRole.SelectedItems.Count > 1)
            {
                String role2 = cblRole.SelectedItems[1].ToString();
                Int32 roleId2 = UserManager.GetRole(role2).RoleId;
                UserManager.CreateUser(username, login, password, roleId, roleId2);
            }
            else UserManager.CreateUser(username, login, password, roleId);
            Response.Redirect("~/Pages/Settings/Main.aspx");
        }
    }//end class
}//end namespace