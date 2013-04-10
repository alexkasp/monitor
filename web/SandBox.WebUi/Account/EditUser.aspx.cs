using System;
using System.Collections.Generic;
using SandBox.Db;
using SandBox.Log;
using SandBox.WebUi.Base;
using System.Web.Security;
using System.Web.UI;
using System.Collections;

namespace SandBox.WebUi.Account
{
    public partial class EditUser : BaseMainPage
    {
        public Int32 userId;

        protected new void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Редактирование пользователя";
            PageMenu = "~/App_Data/SideMenu/Settings/SettingsMenu.xml";
            userId = Convert.ToInt32(Request.QueryString["userId"]);
            if (userId == 0)
            {
                try
                {
                    userId = (int)Session["userId"];
                }
                catch
                {
                }
            }
            Session["userId"] = userId;
            Db.User user = UserManager.GetdbUser(userId);
            if (user == null)
            {
                Response.Redirect("~/Error");
            }

            if (!IsPostBack)
            {
                tbUserName.Text = user.UserName;
                tbLogin.Text = user.Login;
                List<string> rolesList = UserManager.GetRoleList();
                cblRole.DataSource = rolesList;
                cblRole.DataBind();
                List<string> userroles = UserManager.GetRolesForUser(userId);
                foreach (string role in userroles)
                {
                    cblRole.Items.FindByText(role).Selected = true;
                }
                //cbRole.Text = UserManager.GetRolesForUser(userId)[0];
                //List<string> rolesList = UserManager.GetRoleList();
                //cbRole.DataSource = rolesList;
                //cbRole.DataBind();
            }
        }

        protected void BtnEditClick(object sender, EventArgs e)
        {
            String login = tbLogin.Text;
            User user = UserManager.GetdbUser(login);
            if (user != null && user.UserId != userId)
            {
                tbLogin.ValidationSettings.ErrorText = "Такой логин уже существует";
                tbLogin.IsValid = false;
                return;
            }
            String username = tbUserName.Text;
            String password = tbPassword.Text;
            String confirmPassword = tbPasswordConfirm.Text;
            if (password != confirmPassword)
            {
                tbPasswordConfirm.IsValid = false;
                return;
            }
            ArrayList sections = new ArrayList();

            //now loop through all the sections
            for (int i = 0; i < cblRole.Items.Count; i++)
            {
                if (cblRole.Items[i].Selected)
                {
                    sections.Add(cblRole.Items[i].Value);
                }
            }
            String role = sections[0].ToString();
            Int32 roleId = UserManager.GetRole(role).RoleId;
            if (sections.Count > 1)
            {
                String role2 = sections[1].ToString();
                Int32 roleId2 = UserManager.GetRole(role2).RoleId;
                UserManager.EditUser((Int32)Session["userId"], username, login, password, roleId, roleId2);
            }
            else UserManager.EditUser((Int32)Session["userId"], username, login, password, roleId);
            Boolean CurrentUser = (int)Membership.GetUser(User.Identity.Name).ProviderUserKey == userId;
            if (CurrentUser)
            {
                string scriptstring = "alert(\"Изменен Ваш логин. Необходимо пройти аутентификацию.\");document.location.href = '/Account/Login.aspx?ReturnUrl=/Pages/Settings/Main.aspx';";
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "alert", scriptstring, true);
                FormsAuthentication.SignOut();
                Session.Clear();
//                Response.Redirect("~/Account/Login.aspx?ReturnUrl=/Pages/Settings/Main.aspx");
            }
            else Response.Redirect("~/Pages/Settings/Main.aspx");
        }
    }//end class
}//end namespace