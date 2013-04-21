using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SandBox.Db;
using SandBox.WebUi.Base;
using DevExpress.Web.ASPxEditors;

namespace SandBox.WebUi.Pages.Information
{
    public partial class CreateNewVlir : BaseMainPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Добавление ЛИР";
            PageMenu = "~/App_Data/SideMenu/Information/InformationMenu.xml";
            cbSystem.DataSource = VmManager.GetVmSystemDescriptionList();
            cbSystem.SelectedIndex = 0;
            cbSystem.DataBind();
        }

        protected void BAdd_Click(object sender, EventArgs e)
        {
            String newName = (tbLir.Text).Replace(" ", "_");
            String macstr = tbLirMac.Text;
            bool ValidPass = true;
            if (tbLir.Text == String.Empty || IsNameInBase(newName))
            {
                LValidation.Visible = true;
                LValidation.ForeColor = System.Drawing.Color.Red;
                LValidation.Text = tbLir.Text == String.Empty ? "Необходимо ввести имя ЛИР!" : "Такое имя уже сущеcтвует!";
                ValidPass = false;
            }
            if (tbLirMac.Text == String.Empty || IsMACInBase(tbLirMac.Text) || tbLirMac.Text == "00-00-00-00-00-00")
            {
                LValidation2.Visible = true;
                LValidation2.ForeColor = System.Drawing.Color.Red;
                LValidation2.Text = tbLirMac.Text == String.Empty ? "Неверный MAC-адрес!" : tbLirMac.Text == "00-00-00-00-00-00" ? "Неверный MAC-адрес!" : "Такой MAC-адрес уже сущеcтвует!";
                ValidPass = false;
            }
            if (!ValidPass) return;
            if (ASPxEdit.AreEditorsValid(tbLirMac))
            {
                List<String> list = VmManager.GetVmSystemDescriptionList();
                String value = list[cbSystem.SelectedIndex];
                Int32 system = VmManager.GetSystem(value).System;
                VmManager.AddVm(newName, 3, system, UserId, 1, VmManager.State.STOPPED, "null", tbLirMac.Text);
                Response.Redirect("/Pages/Information/Resources.aspx");
            }
        }

        protected void tbLir_TextChanged(object sender, EventArgs e)
        {
            if (LValidation.Visible) LValidation.Visible = false;
        }

        private bool IsNameInBase(string p)
        {
            var vm = VmManager.GetLIRNameList();
            return vm.Contains(p);
        }

        private bool IsMACInBase(string p)
        {
            var vm = VmManager.GetVmMACList();
            return vm.Contains(p);
        }

    }
}