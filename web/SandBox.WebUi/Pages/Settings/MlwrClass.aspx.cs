﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SandBox.Db;

namespace SandBox.WebUi.Pages.Malware
{
    public partial class MlwrClass : System.Web.UI.Page
    {
        private int mlwrID = -1;
        protected void Page_Load(object sender, EventArgs e)
        {
            mlwrID = Convert.ToInt32(Request.QueryString["mlwrID"]);
            //int mlwrID = Convert.ToInt32(Session["mlwrID"]);
            //if (Session["mlwrID"] != null)
            //{
                this.ASPxLabel1.Text = "Критерии для ВПО: " + MlwrManager.GetMlwr(mlwrID).Name;
            //}
            if (!User.IsInRole("Administrator"))
            {
                if (!User.IsInRole("FileManager"))
                {
                    Response.Redirect("~/Account/Login.aspx");
                }
            }
            if (Master != null) ((MainMaster)Master).SetMenuFile("~/App_Data/SideMenu/Malware/MalwareMenu.xml");

        }

        protected void ASPxButton1_Click(object sender, EventArgs e)
        {
            MlwrManager.AddMlwrFeature(/*Convert.ToInt32(Session["mlwrID"])*/mlwrID, "Сетевая активность", this.DropDownList5.SelectedValue, this.ASPxTextBox1.Text);
            this.Page.DataBind();
        }

        protected void ASPxButton2_Click(object sender, EventArgs e)
        {
            MlwrManager.AddMlwrFeature(/*Convert.ToInt32(Session["mlwrID"])*/mlwrID, "Файловая система", this.DropDownList6.SelectedValue, this.ASPxTextBox2.Text);
            this.Page.DataBind();
        }

        protected void ASPxButton3_Click(object sender, EventArgs e)
        {
            MlwrManager.AddMlwrFeature(/*Convert.ToInt32(Session["mlwrID"])*/mlwrID, "Реестр", this.DropDownList7.SelectedValue, this.ASPxTextBox3.Text);
            this.Page.DataBind();


        }

        protected void ASPxButton4_Click(object sender, EventArgs e)
        {
            MlwrManager.AddMlwrFeature(/*Convert.ToInt32(Session["mlwrID"])*/mlwrID, "Процессы", this.DropDownList8.SelectedValue, this.ASPxTextBox4.Text);
            this.Page.DataBind();
        }
    }
}