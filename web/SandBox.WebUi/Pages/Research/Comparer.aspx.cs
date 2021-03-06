﻿using System;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using DevExpress.Web.ASPxEditors;
using SandBox.Connection;
using SandBox.Db;
using SandBox.Log;
using SandBox.WebUi.Base;
using System.Web.UI.WebControls;
using DevExpress.Web.ASPxTreeList;
using System.Collections.Generic;
using DevExpress.XtraCharts;
using System.Collections;

namespace SandBox.WebUi.Pages.Research
{
    public partial class Comparer : BaseMainPage
    {
        int i = 0;
        public Db.Research Rs, Rs2, EtalonRs;
        public Db.Research etalonRsch = null;
        CompareTrees ct = new CompareTrees();
        public Int32 researchId;
        public Int32 researchId2;

        public class Record
        {
            int id, startv, endv;
            public Record(int id, int startv, int endv)
            {
                this.id = id;
                this.startv = startv;
                this.endv = endv;
            }
            public int ID
            {
                get { return id; }
                set { id = value; }
            }
            public int Startv
            {
                get { return startv; }
                set { startv = value; }
            }
            public int Endv
            {
                get { return endv; }
                set { endv = value; }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Сравнение исследований";
            PageMenu = "~/App_Data/SideMenu/Research/ResearchMenu.xml";
            researchId = -1;
            try
            {
                researchId = (int)Session["rsId"];
            }
            catch
            {
                researchId = Convert.ToInt32(Request.QueryString["researchId"]);
            }
            researchId2 = -1;
            try
            {
                researchId2 = (int)Session["rsId2"];
            }
            catch
            {
                researchId2 = Convert.ToInt32(Request.QueryString["researchId2"]);
            }
            /*Convert.ToInt32(Request.QueryString["research"]);*/
            Rs = ResearchManager.GetResearch(researchId);
            if (Rs == null)
            {
                Response.Redirect("~/Error");
            }
            Rs2 = ResearchManager.GetResearch(researchId2);
            if (Rs2 == null)
            {
                Response.Redirect("~/Error");
            }
            var etalonRsch = ResearchManager.GetEtalonRsch(researchId);
//            UpdateTreeView(true);
            if (Rs == null)
            {
                Response.Redirect("~/Error");
            }
            //if (etalonRsch == null)
            //{
            //    lEtalonEx.Text = "Эталонного ислледования не найдено";
            //}
//            TreeViewBuilder.CompareRegTree(researchId, ResearchManager.GetRschOSId(researchId));
            Mlwr mlwrrec = ResearchManager.GetMlwrByRschId(researchId);
            if (mlwrrec != null) Mlwr.Text = mlwrrec.Name + " (" + mlwrrec.Path + ")";
            LOS.Text = ResearchManager.GetRschOS(researchId);
            LIRType.Text = ResearchManager.GetRschVmType(researchId);
            LCreateTime.Text = Rs.CreatedDate.ToString("dd MMM yyyyг. HH:mm:ss");
            if (Rs.StartedDate.HasValue) LStartTime.Text = ((DateTime)Rs.StartedDate).ToString("dd MMM yyyyг. HH:mm:ss");
            if (Rs.StoppedDate.HasValue) LStopTime.Text = ((DateTime)Rs.StoppedDate).ToString("dd MMM yyyyг. HH:mm:ss");
            if (Rs.Duration > 0) LTimerStopTime.Text = Rs.Duration.ToString() + " мин.";
            Int32 elapsedMins;
            Int32 leftMins;
            if (Rs.StartedDate.HasValue) //Сессия начата
            {
                if (Rs.StoppedDate.HasValue) //Сессия завершена
                {
                    elapsedMins = (Int32)((Rs.StoppedDate.Value - Rs.StartedDate.Value).TotalMinutes);
                    if (Rs.Duration > 0)
                    {
                        leftMins = Rs.Duration - elapsedMins;
                        if (leftMins <= 0)
                        {
                            LStatus.Text = "Завершено по таймеру";
                        }
                        else
                        {
                            LStatus.Text = "Завершено принудительно (ост. " + leftMins + " мин.)";
                        }
                    }
                    else LStatus.Text = "Завершено принудительно (через " + elapsedMins + " мин.)";
                }
                else
                {
                    elapsedMins = (Int32)((DateTime.Now - Rs.StartedDate.Value).TotalMinutes);
                    LStatus.Text = "Выполняется (" + elapsedMins + " мин.)";
                }
            }
            else
            {
                LStatus.Text = "Готово к запуску";
            }
            Session["rsch"] = researchId;

            gridAddParams.DataSource = TaskManager.GetTasksViewForRsch(researchId);//dataX;
            gridAddParams.DataBind();

            Mlwr mlwrrec2 = ResearchManager.GetMlwrByRschId(researchId2);
            if (mlwrrec2 != null) Mlwr2.Text = mlwrrec2.Name + " (" + mlwrrec2.Path + ")";
            LOS2.Text = ResearchManager.GetRschOS(researchId2);
            LIRType2.Text = ResearchManager.GetRschVmType(researchId2);
            LCreateTime2.Text = Rs2.CreatedDate.ToString("dd MMM yyyyг. HH:mm:ss");
            if (Rs2.StartedDate.HasValue) LStartTime2.Text = ((DateTime)Rs2.StartedDate).ToString("dd MMM yyyyг. HH:mm:ss");
            if (Rs2.StoppedDate.HasValue) LStopTime2.Text = ((DateTime)Rs2.StoppedDate).ToString("dd MMM yyyyг. HH:mm:ss");
            if (Rs2.Duration > 0) LTimerStopTime2.Text = Rs2.Duration.ToString() + " мин.";
            if (Rs2.StartedDate.HasValue) //Сессия начата
            {
                if (Rs2.StoppedDate.HasValue) //Сессия завершена
                {
                    elapsedMins = (Int32)((Rs2.StoppedDate.Value - Rs2.StartedDate.Value).TotalMinutes);
                    if (Rs2.Duration > 0)
                    {
                        leftMins = Rs2.Duration - elapsedMins;
                        if (leftMins <= 0)
                        {
                            LStatus2.Text = "Завершено по таймеру";
                        }
                        else
                        {
                            LStatus2.Text = "Завершено принудительно (ост. " + leftMins + " мин.)";
                        }
                    }
                    else LStatus2.Text = "Завершено принудительно (через " + elapsedMins + " мин.)";
                }
                else
                {
                    elapsedMins = (Int32)((DateTime.Now - Rs2.StartedDate.Value).TotalMinutes);
                    LStatus2.Text = "Выполняется (" + elapsedMins + " мин.)";
                }
            }
            else
            {
                LStatus2.Text = "Готово к запуску";
            }
            Session["rsch2"] = researchId2;

            gridAddParams2.DataSource = TaskManager.GetTasksViewForRsch(researchId2);//dataX;
            gridAddParams2.DataBind();

             if (!IsPostBack)
             {
                 LHeaderLink.Text = String.Format("Исследование (№{0}): {1}", Rs.Id, Rs.ResearchName);
                 LHeaderLink.NavigateUrl = "~/Pages/Research/ReportList.aspx?researchId=" + researchId.ToString();
                 LHeaderLink2.Text = String.Format("Исследование (№{0}): {1}", Rs2.Id, Rs2.ResearchName);
                 LHeaderLink2.NavigateUrl = "~/Pages/Research/ReportList.aspx?researchId=" + researchId2.ToString();
                 int rschsysid = ResearchManager.GetRschOSId(researchId);
                 int rschsysid2 = ResearchManager.GetRschOSId(researchId2);
                 if (rschsysid == rschsysid2)
                 {
                     RegTreeList.Columns[1].Caption = "Эталон " + LOS.Text;
                     RegTreeList.Columns[2].Caption = "Исследование " + researchId.ToString();
                     RegTreeList.Columns[3].Caption = "Исследование " + researchId2.ToString();
                     string RschRegRoot = TaskManager.GetRegRootForRsch(researchId);
                     string RschRegRoot2 = TaskManager.GetRegRootForRsch(researchId2);
                     Session["rschsysid"] = rschsysid;
                     //                 TreeViewBuilder.CompareRegTree(researchId, ResearchManager.GetRschOSId(researchId));
                     long eltrootid = TreeViewBuilder.GetRegsEtlRowIdByRootstr2(rschsysid, RschRegRoot, RschRegRoot2);
                     List<long> rschparids = TreeViewBuilder.GetRegsRootIDs(rschsysid, RschRegRoot);
                     List<long> rschparids2 = TreeViewBuilder.GetRegsRootIDs(rschsysid, RschRegRoot2);
                     Session["eltrootid"] = eltrootid;
                     Session["rschparids"] = rschparids;
                     Session["rschparids2"] = rschparids2;
                     lbNoComp.ClientVisible = false;
                     RegTreeList.ClientVisible = true;
                 }
                 //var rschs = ResearchManager.GetReadyResearches();
                 //foreach (var r in rschs)
                 //{
                 //    string text  = String.Format("{0}: id = {1}",r.ResearchName, r.Id);
                 //    ASPxComboBox1.Items.Add(new ListEditItem(text, r.Id));
                 //}
             }
             //if (ASPxTreeList1.Summary.Count == 0)
             //{
             //    TreeListSummaryItem siPrice = new TreeListSummaryItem();
             //    siPrice.FieldName = "KeyName";
             //    siPrice.ShowInColumn = "KeyName";
             //    ASPxTreeList1.Summary.Add(siPrice);
             //}
             //LHeader.Text = String.Format("Исследлвание (№{0}): {1}", Rs.Id, Rs.ResearchName);
             int[] FileEvs = new int[2];
             int[] RegistryEvs = new int[2];
             int[] NetEvs = new int[2];
             int[] ProcessEvs = new int[2];

             var db = new SandBoxDataContext();
             var rdof = from d in db.EventsChartCounts
                        where d.Id == researchId
                        select d;
             foreach (var rr in rdof)
             {
                 switch (rr.Module)
                 {
                     case "Файловая система":
                         switch (rr.Sign)
                         {
                             case 1: FileEvs[0] += (int)rr.Count; break;
                             default: FileEvs[1] += (int)rr.Count; break;
                         } break;
                     case "Реестр":
                         switch (rr.Sign)
                         {
                             case 1: RegistryEvs[0] += (int)rr.Count; break;
                             default: RegistryEvs[1] += (int)rr.Count; break;
                         } break;
                     case "Процессы":
                         switch (rr.Sign)
                         {
                             case 1: ProcessEvs[0] += (int)rr.Count; break;
                             default: ProcessEvs[1] += (int)rr.Count; break;
                         } break;
                     case "TDIMON":
                     case "NDISMON":
                         switch (rr.Sign)
                         {
                             case 1: NetEvs[0] += (int)rr.Count; break;
                             default: NetEvs[1] += (int)rr.Count; break;
                         } break;
                 }
             }
             string scripttxt = "drawHalfPie('chartHolder1',Array(" + FileEvs[1].ToString() + ","
                      + FileEvs[0].ToString() + ")); drawHalfPie('chartHolder2',Array(" + RegistryEvs[1].ToString() + ","
                      + RegistryEvs[0].ToString() + ")); drawHalfPie('chartHolder3',Array(" + ProcessEvs[1].ToString() + ","
                      + ProcessEvs[0].ToString() + ")); drawHalfPie('chartHolder4',Array(" + NetEvs[1].ToString() + ","
                      + NetEvs[0].ToString() + "));";
//             Page.ClientScript.RegisterStartupScript(Type.GetType("System.String"), "addScript", scripttxt, true);
             
             FileEvs[0] = 0;
             FileEvs[1] = 0;
             RegistryEvs[0] = 0;
             RegistryEvs[1] = 0;
             NetEvs[0] = 0;
             NetEvs[1] = 0;
             ProcessEvs[0] = 0;
             ProcessEvs[1] = 0;

             var rdof2 = from d in db.EventsChartCounts
                        where d.Id == researchId2
                        select d;
             foreach (var rr in rdof2)
             {
                 switch (rr.Module)
                 {
                     case "Файловая система":
                         switch (rr.Sign)
                         {
                             case 1: FileEvs[0] += (int)rr.Count; break;
                             default: FileEvs[1] += (int)rr.Count; break;
                         } break;
                     case "Реестр":
                         switch (rr.Sign)
                         {
                             case 1: RegistryEvs[0] += (int)rr.Count; break;
                             default: RegistryEvs[1] += (int)rr.Count; break;
                         } break;
                     case "Процессы":
                         switch (rr.Sign)
                         {
                             case 1: ProcessEvs[0] += (int)rr.Count; break;
                             default: ProcessEvs[1] += (int)rr.Count; break;
                         } break;
                     case "TDIMON":
                     case "NDISMON":
                         switch (rr.Sign)
                         {
                             case 1: NetEvs[0] += (int)rr.Count; break;
                             default: NetEvs[1] += (int)rr.Count; break;
                         } break;
                 }
             }
             string scripttxt2 = scripttxt+"drawHalfPie('chartHolder5',Array(" + FileEvs[1].ToString() + ","
                      + FileEvs[0].ToString() + ")); drawHalfPie('chartHolder6',Array(" + RegistryEvs[1].ToString() + ","
                      + RegistryEvs[0].ToString() + ")); drawHalfPie('chartHolder7',Array(" + ProcessEvs[1].ToString() + ","
                      + ProcessEvs[0].ToString() + ")); drawHalfPie('chartHolder8',Array(" + NetEvs[1].ToString() + ","
                      + NetEvs[0].ToString() + "));";
             Page.ClientScript.RegisterStartupScript(Type.GetType("System.String"), "addScript", scripttxt2, true);


        }

        private void UpdateEventChart(DevExpress.XtraCharts.Web.WebChartControl wc, int rsch)
        {
            int r = rsch;
            int virtualTime = 0;
            wc.Series.Clear();
            var evts = ResearchManager.GetEventsSignByRschId(r);
            ArrayList fDS = new ArrayList();
            ArrayList rDS = new ArrayList();
            ArrayList pDS = new ArrayList();
            ArrayList sDS = new ArrayList();
            foreach (var evt in evts)
            {
                virtualTime++;
                switch (evt.module)
                {
                    case 1:
                        fDS.Add(new Record(virtualTime, evt.significance, evt.significance + 1));
                        break;
                    case 2:
                        rDS.Add(new Record(virtualTime, evt.significance, evt.significance + 1));
                        break;
                    case 3:
                        pDS.Add(new Record(virtualTime, evt.significance, evt.significance + 1));
                        break;
                    case 4:
                    case 5:
                        sDS.Add(new Record(virtualTime, evt.significance, evt.significance + 1));
                        break;
                }
            }
            Series fseries = new Series("Файловая система", ViewType.SideBySideRangeBar);
            Series rseries = new Series("Реестр", ViewType.SideBySideRangeBar);
            Series pseries = new Series("Процессы", ViewType.SideBySideRangeBar);
            Series sseries = new Series("Сеть", ViewType.SideBySideRangeBar);
            wc.Series.Add(fseries);
            wc.Series.Add(rseries);
            wc.Series.Add(pseries);
            wc.Series.Add(sseries);
            ((SideBySideRangeBarSeriesView)fseries.View).Color = Color.FromArgb(75, 89, 97);
            ((SideBySideRangeBarSeriesView)fseries.View).FillStyle.FillMode = FillMode.Solid;
            ((SideBySideRangeBarSeriesView)rseries.View).Color = Color.FromArgb(37, 119, 147);
            ((SideBySideRangeBarSeriesView)rseries.View).FillStyle.FillMode = FillMode.Solid;
            ((SideBySideRangeBarSeriesView)pseries.View).Color = Color.FromArgb(242, 148, 65);
            ((SideBySideRangeBarSeriesView)pseries.View).FillStyle.FillMode = FillMode.Solid;
            ((SideBySideRangeBarSeriesView)sseries.View).Color = Color.FromArgb(206, 72, 34);
            ((SideBySideRangeBarSeriesView)sseries.View).FillStyle.FillMode = FillMode.Solid;
            if (fDS.Count > 0) fseries.DataSource = fDS;
            fseries.ArgumentScaleType = ScaleType.Numerical;
            fseries.ValueScaleType = ScaleType.Numerical;
            fseries.ValueDataMembers[0] = "startv";
            fseries.ValueDataMembers[1] = "endv";
            fseries.ArgumentDataMember = "id";
            rseries.ArgumentScaleType = ScaleType.Numerical;
            rseries.ValueScaleType = ScaleType.Numerical;
            rseries.ValueDataMembers[0] = "startv";
            rseries.ValueDataMembers[1] = "endv";
            rseries.ArgumentDataMember = "id";
            if (rDS.Count > 0) rseries.DataSource = rDS;
            pseries.ArgumentScaleType = ScaleType.Numerical;
            pseries.ValueScaleType = ScaleType.Numerical;
            pseries.ValueDataMembers[0] = "startv";
            pseries.ValueDataMembers[1] = "endv";
            pseries.ArgumentDataMember = "id";
            if (pDS.Count > 0) pseries.DataSource = pDS;
            sseries.ArgumentScaleType = ScaleType.Numerical;
            sseries.ValueScaleType = ScaleType.Numerical;
            sseries.ValueDataMembers[0] = "startv";
            sseries.ValueDataMembers[1] = "endv";
            sseries.ArgumentDataMember = "id";
            if (sDS.Count > 0) sseries.DataSource = sDS;
            wc.DataBind();
        }

        protected void wcEventsSign_CustomCallback(object sender, DevExpress.XtraCharts.Web.CustomCallbackEventArgs e)
        {
            UpdateEventChart((DevExpress.XtraCharts.Web.WebChartControl)sender, researchId);
        }

        protected void wcEventsSign_CustomCallback2(object sender, DevExpress.XtraCharts.Web.CustomCallbackEventArgs e)
        {
            UpdateEventChart((DevExpress.XtraCharts.Web.WebChartControl)sender, researchId2);
        }

        protected void RegTree_VirtualModeNodeCreating(object sender, TreeListVirtualModeNodeCreatingEventArgs e)
        {
            RegCompareTreeItem2 rowView = e.NodeObject as RegCompareTreeItem2;
            if (rowView == null) return;
            e.NodeKeyValue = rowView.ID;
            e.SetNodeValue("Text", rowView.Text);
            e.SetNodeValue("EtlID", rowView.EtlID);
            e.SetNodeValue("RegID", rowView.RegID);
            e.SetNodeValue("RegID2", rowView.RegID2);
            if (rowView.EtlID > -1) e.SetNodeValue("Etl", rowView.EtlValue);
            if (rowView.RegID > -1) e.SetNodeValue("Reg", rowView.RegValue);
            if (rowView.RegID2 > -1) e.SetNodeValue("Reg2", rowView.RegValue2);
            if (rowView.IsKey)
            {
                e.SetNodeValue("IconName", "reg_file");
                e.IsLeaf = true;
            }
            else e.SetNodeValue("IconName", "reg_dir");
        }

        protected void RegTree_VirtualModeCreateChildren(object sender, TreeListVirtualModeCreateChildrenEventArgs e)
        {
            int eltrootid=-1;
            if (Session["eltrootid"] != null) int.TryParse(Session["eltrootid"].ToString(), out eltrootid);
            if (eltrootid > -1)
            {
                int rschsysid = -1;
                if (Session["rschsysid"]!=null) int.TryParse(Session["rschsysid"].ToString(), out rschsysid);
                int rsch = -1;
                if (Session["rsch"] != null) int.TryParse(Session["rsch"].ToString(), out rsch);
                int rsch2 = -1;
                if (Session["rsch2"] != null) int.TryParse(Session["rsch2"].ToString(), out rsch2);
                List<long> rschparids = Session["rschparids"] != null ? (List<long>)Session["rschparids"] : null;
                long rschparid = -1;
                if (rschparids != null)
                {
                    if (rschparids.Count > 0) rschparid = rschparids[rschparids.Count - 1];
                    else rschparid = 0;
                }
                List<long> rschparids2 = Session["rschparids2"] != null ? (List<long>)Session["rschparids2"] : null;
                long rschparid2 = -1;
                if (rschparids2 != null)
                {
                    if (rschparids2.Count > 0) rschparid2 = rschparids2[rschparids2.Count - 1];
                    else rschparid2 = 0;
                }
                List<RegCompareTreeItem2> children = null;
                RegCompareTreeItem2 parent = e.NodeObject as RegCompareTreeItem2;
                if (parent == null)
                {
                    children = TreeViewBuilder.GetRegsCompTableView2(RegTreeList.TotalNodeCount + 1, 0, rschparid, rschparid2, rschsysid, eltrootid, rsch, -1, rsch2, -1);
                    if (children.Count == 0) RegTreeList.ClearNodes();
                }
                else
                {
                    children = TreeViewBuilder.GetRegsCompTableView2(RegTreeList.TotalNodeCount + 1, parent.ID, rschparid, rschparid2, rschsysid, parent.EtlID, rsch, parent.RegID, rsch2, parent.RegID2);
                }
                e.Children = children;
            }
        }

        protected void ASPxButton1_Click(object sender, EventArgs e)
        {
            //if (etalonRsch == null)
            //{
            //    ASPxTreeList1.Columns.Clear();

            //    //tl.Columns[0].Caption = "Customer";

            //    TreeView1.Nodes.Clear();
            //    int rschId;
            //    if (ASPxComboBox1.SelectedItem.Text != "")
            //    {
            //        ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn("KeyName", "Имя ключя"));
            //        ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn("IsNodeInRsch", Rs.ResearchName));
            //        ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn("IsNodeInCompared", ASPxComboBox1.SelectedItem.Text));
            //    }
            //    Int32.TryParse((string)ASPxComboBox1.SelectedItem.Value, out rschId);
            //    CompareTrees ct = new CompareTrees();
            //    try
            //    {
            //        ASPxTreeList1.ClearNodes();
            //        var nodes = ct.GetRschTree(Rs.Id, rschId);
            //        for (int i = 0; i < nodes.Nodes.Count; i++) //TreeNode tn in nodes.Nodes)
            //            TreeView1.Nodes.Add(nodes.Nodes[i]);
            //        //TreeView1.Nodes[0].Text = "Сравнение ветвей реестра";
            //        List<TreeNode> res = new List<TreeNode>();
            //        ct.GetNodesList(nodes.Nodes[0], res);
            //        List<string> pathList = new List<string>();
            //        foreach (TreeNode tn in res)
            //        {
            //            string path = String.Empty;
            //            ct.GetFullPathForNode(tn, ref path, true);
            //            pathList.Add(path);
            //        }

            //        ConvertTreeViewToTreeList(pathList, TreeView1.Nodes[0], null, ct);
            //        ASPxTreeList1.ExpandAll();
            //    }
            //    catch
            //    {
            //        TreeView1.Nodes.Add(new TreeNode("Нет этементов для сравнения"));
            //    }
            //}
            //else
            //{
                
            //}
        }

        protected void RegTreeList_HtmlDataCellPrepared(object sender, TreeListHtmlDataCellEventArgs e)
        {
            TreeListNode node = RegTreeList.FindNodeByKeyValue(e.NodeKey);
            if (node == null) return;
            switch (e.Column.Name)
            {
                case "Text":
                    List<long> rschparids = Session["rschparids"] != null ? (List<long>)Session["rschparids"] : null;
                    List<long> rschparids2 = Session["rschparids2"] != null ? (List<long>)Session["rschparids2"] : null;
                    if ((rschparids != null && rschparids.Contains(Convert.ToInt64(node["EtlID"]))) || (rschparids2 != null && rschparids2.Contains(Convert.ToInt64(node["EtlID"])))) e.Cell.BackColor = Color.LightBlue;
                    break;
                case "Etl":
                    if (Convert.ToInt32(node["EtlID"])>-1) e.Cell.BackColor = Color.DarkSeaGreen;
                    else e.Cell.BackColor = Color.DarkSalmon;
                    break;
                case "Reg":
                    if (Convert.ToInt32(node["RegID"]) > -1)
                    {
                        if ((node["Reg"] == null && node["Etl"] == null)||(node["Reg"] != null && node["Etl"] != null && node["Reg"].ToString() == node["Etl"].ToString())) e.Cell.BackColor = Color.DarkSeaGreen;
                        else e.Cell.BackColor = Color.Gold; 
                    }
                    else e.Cell.BackColor = Color.DarkSalmon;
                    break;
                case "Reg2":
                    if (Convert.ToInt32(node["RegID2"]) > -1)
                    {
                        if ((node["Reg2"] == null && node["Etl"] == null) || (node["Reg2"] != null && node["Etl"] != null && node["Reg2"].ToString() == node["Etl"].ToString())) e.Cell.BackColor = Color.DarkSeaGreen;
                        else e.Cell.BackColor = Color.Gold;
                    }
                    else e.Cell.BackColor = Color.DarkSalmon;
                    break;
            }
        }

        protected string GetIconUrl(TreeListDataCellTemplateContainer container)
        {
            return string.Format("~/Content/Images/Icons/{0}.png", container.GetValue("IconName"));
        }

        //private void UpdateTreeView(bool testMode = false)
        //{
        //    #region testing


        //    #endregion

        //    if (etalonRsch == null&&!testMode)
        //    {
               
        //        if (ASPxComboBox1.SelectedItem.Text != "")
        //        {
        //            #region
        //            TreeView1.Nodes.Clear();
        //            int rschId;

        //            ASPxTreeList1.Columns.Clear();
        //            ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn("KeyName", "Имя ключя"));
        //            ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn("IsNodeInRsch", Rs.ResearchName));
        //            ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn("IsNodeInCompared", ASPxComboBox1.SelectedItem.Text));
                   
                    
        //            ct._rschFullPathesDict.Clear();
        //            try
        //            {

        //                ASPxTreeList1.ClearNodes();
        //                Int32.TryParse((string)ASPxComboBox1.SelectedItem.Value, out rschId);
        //                var nodes = ct.GetRschTree(Rs.Id, rschId);
        //                for (int i = 0; i < nodes.Nodes.Count; i++) //TreeNode tn in nodes.Nodes)
        //                    TreeView1.Nodes.Add(nodes.Nodes[i]);

        //                List<TreeNode> res = new List<TreeNode>();
        //                ct.GetNodesList(nodes.Nodes[0], res);
        //                List<string> pathList = new List<string>();
        //                foreach (TreeNode tn in res)
        //                {
        //                    string path = String.Empty;
        //                    ct.GetFullPathForNode(tn, ref path, true);
        //                    pathList.Add(path);
        //                }

        //                ConvertTreeViewToTreeList(pathList,TreeView1.Nodes[0], null, ct);
        //                ASPxTreeList1.ExpandAll();
        //            }
        //            catch
        //            {
        //                TreeView1.Nodes.Add(new TreeNode("Нет этементов для сравнения"));
        //            }
        //            #endregion
        //        }
               
        //    }
        //    else
        //    {
        //        if (/*ASPxComboBox1.SelectedItem.Text == "" &&*/ !testMode)
        //        {
        //            #region
        //            ct._rschFullPathesDict.Clear();
        //            TreeView1.Nodes.Clear();
        //            int rschId = etalonRsch.Id;

        //            ASPxTreeList1.Columns.Clear();
        //            ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn("KeyName", "Имя ключя"));
        //            ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn("IsNodeInRsch", Rs.ResearchName));
        //            ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn("IsNodeInCompared", ASPxComboBox1.SelectedItem.Text));

        //            try
        //            {
        //                ASPxTreeList1.ClearNodes();
        //                var nodes = ct.GetRschTree(Rs.Id, rschId);
        //                for (int i = 0; i < nodes.Nodes.Count; i++) //TreeNode tn in nodes.Nodes)
        //                    TreeView1.Nodes.Add(nodes.Nodes[i]);
        //                //TreeView1.Nodes[0].Text = "Сравнение ветвей реестра";

        //                List<TreeNode> res = new List<TreeNode>();
        //                ct.GetNodesList(nodes.Nodes[0], res);
        //                List<string> pathList = new List<string>();
        //                foreach (TreeNode tn in res)
        //                {
        //                    string path = String.Empty;
        //                    ct.GetFullPathForNode(tn, ref path, true);
        //                    pathList.Add(path);
        //                }

        //                ConvertTreeViewToTreeList(pathList, TreeView1.Nodes[0], null, ct);
        //                ASPxTreeList1.ExpandAll();
        //            }
        //            catch
        //            {
        //                TreeView1.Nodes.Add(new TreeNode("Нет этементов для сравнения"));
        //            }
        //            #endregion
        //        }
        //        else
        //        { 
                    
        //            #region
        //            ct._rschFullPathesDict.Clear();
              
        //            TreeView1.Nodes.Clear();
        //            int rschId;
        //            if (!testMode)
        //                rschId = etalonRsch.Id;
        //            else
        //            {
        //                rschId = 105;
        //                Rs = ResearchManager.GetResearch(104);
        //                etalonRsch = ResearchManager.GetResearch(105);

        //            }
        //            ASPxTreeList1.Columns.Clear();
        //            ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn("KeyName", "Имя ключя"));
        //            ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn(Rs.ResearchName, Rs.ResearchName));
        //            ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn(etalonRsch.ResearchName, etalonRsch.ResearchName));

        //            try
        //            {
        //                ASPxTreeList1.ClearNodes();
        //                var nodes = ct.GetRschTree(Rs.Id, etalonRsch.Id);
        //                for (int i = 0; i < nodes.Nodes.Count; i++) //TreeNode tn in nodes.Nodes)
        //                    TreeView1.Nodes.Add(nodes.Nodes[i]);

        //                if (!testMode) Int32.TryParse((string)ASPxComboBox1.SelectedItem.Value, out rschId);
        //                else rschId = 105;
        //                ct.AddRschToTreeView(nodes, ResearchManager.GetResearch(rschId));
        //                ASPxTreeList1.Columns.Add(new DevExpress.Web.ASPxTreeList.TreeListDataColumn( ResearchManager.GetResearch(rschId).ResearchName, ResearchManager.GetResearch(rschId).ResearchName));

        //                List<TreeNode> res = new List<TreeNode>();
        //                ct.GetNodesList(nodes.Nodes[0], res);
        //                List<string> pathList = new List<string>();
        //                foreach (TreeNode tn in res)
        //                {
        //                    string path = String.Empty;
        //                    ct.GetFullPathForNode(tn, ref path, true);
        //                    pathList.Add(path);
        //                }

        //                ConvertTreeViewToTreeList(pathList, nodes.Nodes[0], null, ct);

        //                ASPxTreeList1.ExpandAll();
        //            }
        //            catch
        //            {
        //                TreeView1.Nodes.Add(new TreeNode("Нет этементов для сравнения"));
        //            }
        //            #endregion
        //        }

        //    }
        //}

        //TreeListNode CreateNodeCore(List<string> treeFullPathes, TreeNode tvn, TreeListNode tln, CompareTrees ctt)
        //{
        //    i++;
        //    TreeListNode node = ASPxTreeList1.AppendNode(i, tln);
        //    node["KeyName"] = tvn.Text;
        //    foreach (var key in ct._rschFullPathesDict.Keys)
        //    {
        //        string test = key.ResearchName;
        //        string nodeFullPath=String.Empty;
        //        ct.GetFullPathForNode(tvn, ref nodeFullPath);
        //        if(ct._rschFullPathesDict[key].Contains(nodeFullPath))
        //            node[test] = "+";
        //        else
        //            node[test] = "-";
        //    }
        //    return node;
        //}

        //void ConvertTreeViewToTreeList(List<string> treeFullPathes, TreeNode tvn, TreeListNode tln, CompareTrees ctt)
        //{
        //    var ttln = CreateNodeCore(treeFullPathes, tvn, tln,ct);
        //    if (tvn.ChildNodes != null) //дочерние элементы есть
        //    {
        //        foreach (TreeNode childNode in tvn.ChildNodes) //не зацикливаеться ли от родителя к 1 ребенку и обратно?
        //        {
        //            tln = ttln;
        //            tvn = childNode; //посетить ребенка
        //            ConvertTreeViewToTreeList(treeFullPathes, tvn, tln, ct);
        //        }

        //    }
        //}

        //protected void ASPxTreeList1_HtmlDataCellPrepared(object sender, TreeListHtmlDataCellEventArgs e)
        //{
        //    string value = (string)e.CellValue;
        //    if (value == "+")
        //    {
        //        e.Cell.BackColor = Color.Green;
        //    }
        //    if (value == "-")
        //    {
        //        e.Cell.BackColor = Color.Red;
        //    }
        //}
    }
}