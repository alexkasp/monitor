﻿using System;
using SandBox.Db;
using System.Linq;
using SandBox.WebUi.Base;
using SandBox.Connection;
using System.Text;
using System.Drawing;
using System.Collections.Generic;
using DevExpress.Web.ASPxGridView;
using DevExpress.XtraCharts;
using System.Collections;
using System.Web.Security;
using System.Web.UI;
using DevExpress.Web.ASPxTreeList;
using System.Reflection;

namespace SandBox.WebUi.Pages.Research
{
    public partial class ReportList : BaseMainPage
    {
        public Db.Research Rs;
        private Dictionary<string, int> DEventsCount = new Dictionary<string, int>();
        public Int32 researchId;
        string separator = "!!!";

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
        
        protected new void Page_Load(object sender, EventArgs e)
        {

            gridViewReports.KeyFieldName = "Id";
            base.Page_Load(sender, e);
            PageTitle = "Отчет";
            PageMenu  = "~/App_Data/SideMenu/Research/ResearchMenu.xml";
            researchId = -1;
            try
            {
                researchId = (int)Session["rsId"];
            }
            catch
            {
                researchId =  Convert.ToInt32(Request.QueryString["researchId"]);
            }
            /*Convert.ToInt32(Request.QueryString["research"]);*/
            Rs = ResearchManager.GetResearch(researchId);           
            if (Rs == null)
            {
                Response.Redirect("~/Error");
            }
            LHeader.Text = String.Format("Исследование (№{0}): {1}", Rs.Id, Rs.ResearchName);
            if (!User.IsInRole("Administrator")) 
                if (Rs.UserId!=UserId) {
                    string scriptstring = "alert(\"У Вас нет доступа к данному исследованию.\");document.location.href = '/Pages/Research/Current.aspx';";
                    ScriptManager.RegisterStartupScript(Page, Page.GetType(), "alert", scriptstring, true);
                    return;
                }
            Mlwr mlwrrec = ResearchManager.GetMlwrByRschId(researchId);
            if (mlwrrec != null) Mlwr.Text = mlwrrec.Name + " (" + mlwrrec.Path + ")";
            LOS.Text = ResearchManager.GetRschOS(researchId);
            LIRType.Text = ResearchManager.GetRschVmType(researchId);
            LCreateTime.Text = Rs.CreatedDate.ToString("dd MMM yyyyг. HH:mm:ss");
            if (Rs.StartedDate.HasValue) LStartTime.Text = ((DateTime)Rs.StartedDate).ToString("dd MMM yyyyг. HH:mm:ss");
            if (Rs.StoppedDate.HasValue) LStopTime.Text = ((DateTime)Rs.StoppedDate).ToString("dd MMM yyyyг. HH:mm:ss");
            if (Rs.Duration > 0) LTimerStopTime.Text = Rs.Duration.ToString() + " мин.";
            if (Rs.StartedDate.HasValue) //Сессия начата
            {
                Int32 elapsedMins;
                if (Rs.StoppedDate.HasValue) //Сессия завершена
                {
                    elapsedMins = (Int32)((Rs.StoppedDate.Value - Rs.StartedDate.Value).TotalMinutes);
                    if (Rs.Duration > 0)
                    {
                        Int32 leftMins = Rs.Duration - elapsedMins;
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
//            HLPorts.NavigateUrl += ("?research=" + researchId);
//            linkGetRegistryList.NavigateUrl += ("?researchId=" + researchId);
//            linkGetFileList.NavigateUrl += ("?researchId=" + researchId);
//            linkGetProcessList.NavigateUrl += ("?researchId=" + researchId);
            Session["rsch"] = researchId;
            DEventsCount.Clear();

            gridAddParams.DataSource = TaskManager.GetTasksViewForRsch(researchId);//dataX;
            gridAddParams.DataBind(); 
            
            gridViewReports.DataSource = ResearchManager.GetEventsForRsch(Rs.Id);
//            var newPageSize = (Int32)CBPagingSize.SelectedItem.Value;
//            gridViewReports.SettingsPager.PageSize = newPageSize;
            gridViewReports.DataBind();
            ProcTreeList.DataSource = TreeViewBuilder.GetProcsTableView(researchId);
            ProcTreeList.KeyFieldName = "Pid1";
            ProcTreeList.ParentFieldName = "Pid2";
            ProcTreeList.DataBind();
            ProcVPOTreeList.DataSource = TreeViewBuilder.GetResearchProcesses(researchId);
            ProcVPOTreeList.KeyFieldName = "pid";
            ProcVPOTreeList.ParentFieldName = "parentpid";
            ProcVPOTreeList.DataBind();
            gvPorts.DataSource = ResearchManager.GetPortsViewForRsch(Rs.Id);
            gvPorts.DataBind();
            if (RegTreeList.FocusedNode != null)
            {
                gvRegKeys.DataSource = TreeViewBuilder.GetKeyValues(Convert.ToInt32(RegTreeList.FocusedNode.Key));
                gvRegKeys.DataBind();
            }

            if (Rs.TrafficFileReady == (Int32)TrafficFileReady.COMPLETE)
            {
                
                String link = Rs.TrafficFileName;
                linkGetTraffic.NavigateUrl = link;
                linkGetTraffic.Visible = true;
                linkGetTraffic.Enabled = true;
                ASPxButton1.Visible = false;
                ASPxButton1.Visible = false;
            }

            if (!IsPostBack)
            {
                Layout lt = WebTables.GetLayout((int)Membership.GetUser().ProviderUserKey, "ReportTable");
                if (lt != null)
                {
                    string customState = lt.UserLayout.Substring(0, lt.UserLayout.IndexOf(separator));
                    gridViewReports.Settings.ShowFilterRow = customState[0].ToString() == "T";
                    string gridState = lt.UserLayout.Substring(customState.Length + separator.Length);
                    gridViewReports.LoadClientLayout(gridState);
                }
                TableFilterMenu.Items.FindByName("ShowFiterRow").Checked = gridViewReports.Settings.ShowFilterRow;

                RegCompTreeList.Columns[1].Caption = "Эталон " + LOS.Text;
                RegCompTreeList.Columns[2].Caption = "Исследование " + researchId.ToString();

                string RschRegRoot = TaskManager.GetRegRootForRsch(researchId);
                int rschsysid = ResearchManager.GetRschOSId(researchId);
                Session["rschsysid"] = rschsysid;
                //                 TreeViewBuilder.CompareRegTree(researchId, ResearchManager.GetRschOSId(researchId));
                long eltrootid = TreeViewBuilder.GetRegsEtlRowIdByRootstr(rschsysid, RschRegRoot);
                Session["eltrootid"] = eltrootid;

//                ReportsBuilder.RschPropsListBuilder(TreeView1, Rs.Id);
//                 ASPxHyperLink5.NavigateUrl += ("?research=" + researchId);
                if (Rs.TrafficFileReady == (Int32)TrafficFileReady.NOACTION)
                {
                    AskPCAPFile(researchId);
               }
                
            }
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
                                case 2: FileEvs[1] += (int)rr.Count; break;
                            } break;
                        case "Реестр":
                            switch (rr.Sign)
                            {
                                case 1: RegistryEvs[0] += (int)rr.Count; break;
                                case 2: RegistryEvs[1] += (int)rr.Count; break;
                            } break;
                        case "Процессы":
                            switch (rr.Sign)
                            {
                                case 1: ProcessEvs[0] += (int)rr.Count; break;
                                case 2: ProcessEvs[1] += (int)rr.Count; break;
                            } break;
                        case "Сеть":
//                        case "TDIMON":
//                        case "NDISMON":
                            switch (rr.Sign)
                            {
                                case 1: NetEvs[0] += (int)rr.Count; break;
                                case 2: NetEvs[1] += (int)rr.Count; break;
                            } break;
                    }
                }
                string scripttxt = "drawHalfPie('chartHolder1',Array(" + FileEvs[1].ToString() + ","
                         + FileEvs[0].ToString() + ")); drawHalfPie('chartHolder2',Array(" + RegistryEvs[1].ToString() + ","
                         + RegistryEvs[0].ToString() + ")); drawHalfPie('chartHolder3',Array(" + ProcessEvs[1].ToString() + ","
                         + ProcessEvs[0].ToString() + ")); drawHalfPie('chartHolder4',Array(" + NetEvs[1].ToString() + ","
                         + NetEvs[0].ToString() + "));";
                Page.ClientScript.RegisterStartupScript(Type.GetType("System.String"), "addScript", scripttxt, true);
                //gridAddParams.ClientSideEvents.Init = "function(s, e) { drawHalfPie('chartHolder1',Array(" + FileEvs[1].ToString() + ","
                //         + FileEvs[0].ToString() + ")); drawHalfPie('chartHolder2',Array(" + RegistryEvs[1].ToString() + ","
                //         + RegistryEvs[0].ToString() + ")); drawHalfPie('chartHolder3',Array(" + ProcessEvs[1].ToString() + ","
                //         + ProcessEvs[0].ToString() + ")); drawHalfPie('chartHolder4',Array(" + NetEvs[1].ToString() + ","
                //         + NetEvs[0].ToString() + "));}";
        }

        private void UpdateEventChart(int yOfset = 0, int rsch = -1)
        {
            int r = rsch == -1 ? (int)Session["rsch"] : rsch;
            int virtualTime = 0;
            wcEventsSign.Series.Clear();

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
                        fDS.Add(new Record(virtualTime,evt.significance, evt.significance+1));
//                        DEventsCount["Файловая система"]++;
                        break;
                    case 2:
                        rDS.Add(new Record(virtualTime,evt.significance, evt.significance+1));
//                        DEventsCount["Реестр"]++;
                        break;
                    case 3:
                        pDS.Add(new Record(virtualTime,evt.significance, evt.significance+1));
//                        DEventsCount["Процессы"]++;
                        break;
                    case 4:
                    case 5:
                        sDS.Add(new Record(virtualTime,evt.significance, evt.significance+1));
//                        DEventsCount["Сеть"]++;
                        break;
                }
            }


//            wcEventsSign.DataSource = evts;
            Series fseries = new Series("Файловая система", ViewType.SideBySideRangeBar);
            Series rseries = new Series("Реестр", ViewType.SideBySideRangeBar);
            Series pseries = new Series("Процессы", ViewType.SideBySideRangeBar);
            Series sseries = new Series("Сеть", ViewType.SideBySideRangeBar);
            wcEventsSign.Series.Add(fseries);
            wcEventsSign.Series.Add(rseries);
            wcEventsSign.Series.Add(pseries);
            wcEventsSign.Series.Add(sseries);
//            ((SideBySideRangeBarSeriesView)fseries.View).Color = Color.FromArgb(255, 255, 0);
//            ((SideBySideRangeBarSeriesView)fseries.View).Color = Color.FromArgb(74, 134, 153);
            ((SideBySideRangeBarSeriesView)fseries.View).Color = Color.FromArgb(75, 89, 97);
            ((SideBySideRangeBarSeriesView)fseries.View).FillStyle.FillMode = FillMode.Solid;
//            ((SideBySideRangeBarSeriesView)rseries.View).Color = Color.FromArgb(0, 0, 255);
//            ((SideBySideRangeBarSeriesView)rseries.View).Color = Color.FromArgb(43, 83, 96);
            ((SideBySideRangeBarSeriesView)rseries.View).Color = Color.FromArgb(37, 119, 147);
            ((SideBySideRangeBarSeriesView)rseries.View).FillStyle.FillMode = FillMode.Solid;
//            ((SideBySideRangeBarSeriesView)pseries.View).Color = Color.FromArgb(0, 255, 0);
//            ((SideBySideRangeBarSeriesView)pseries.View).Color = Color.FromArgb(163, 193, 204);
            ((SideBySideRangeBarSeriesView)pseries.View).Color = Color.FromArgb(242, 148, 65);
            ((SideBySideRangeBarSeriesView)pseries.View).FillStyle.FillMode = FillMode.Solid;
//            ((SideBySideRangeBarSeriesView)sseries.View).Color = Color.FromArgb(0, 255, 255);
//            ((SideBySideRangeBarSeriesView)sseries.View).Color = Color.FromArgb(18, 50, 59);
            ((SideBySideRangeBarSeriesView)sseries.View).Color = Color.FromArgb(206, 72, 34);
            ((SideBySideRangeBarSeriesView)sseries.View).FillStyle.FillMode = FillMode.Solid;
            if (fDS.Count>0) fseries.DataSource = fDS;
            fseries.ArgumentScaleType = ScaleType.Numerical;
            fseries.ValueScaleType = ScaleType.Numerical;
            fseries.ValueDataMembers[0] = "startv";
            fseries.ValueDataMembers[1] = "endv";
//            fseries.ValueDataMembers.AddRange(new string[] { "significance", "significance2" });
            fseries.ArgumentDataMember = "id";
//            fseries.DataFilters.Add(new DataFilter("module", "System.Int32", DataFilterCondition.Equal, 1));
            rseries.ArgumentScaleType = ScaleType.Numerical;
            rseries.ValueScaleType = ScaleType.Numerical;
            rseries.ValueDataMembers[0] = "startv";
            rseries.ValueDataMembers[1] = "endv";
//            rseries.ValueDataMembers.AddRange(new string[] { "significance", "significance2" });
//            rseries.ValueDataMembers[0] = "significance";
            rseries.ArgumentDataMember = "id";
//            rseries.DataFilters.Add(new DataFilter("module", "System.Int32", DataFilterCondition.Equal, 2));
            if (rDS.Count > 0) rseries.DataSource = rDS;
            pseries.ArgumentScaleType = ScaleType.Numerical;
            pseries.ValueScaleType = ScaleType.Numerical;
            pseries.ValueDataMembers[0] = "startv";
            pseries.ValueDataMembers[1] = "endv";
//            pseries.ValueDataMembers.AddRange(new string[] { "significance", "significance2" });
//            pseries.ValueDataMembers[0] = "significance";
            pseries.ArgumentDataMember = "id";
//            pseries.DataFilters.Add(new DataFilter("module", "System.Int32", DataFilterCondition.Equal, 3));
            if (pDS.Count > 0) pseries.DataSource = pDS;
            sseries.ArgumentScaleType = ScaleType.Numerical;
            sseries.ValueScaleType = ScaleType.Numerical;
            sseries.ValueDataMembers[0] = "startv";
            sseries.ValueDataMembers[1] = "endv";
//            sseries.ValueDataMembers.AddRange(new string[] { "significance", "significance2" });
//            sseries.ValueDataMembers[0] = "significance";
            sseries.ArgumentDataMember = "id";
//            sseries.DataFiltersConjunctionMode = ConjunctionTypes.Or;
//            sseries.DataFilters.AddRange(new DataFilter[] {new DataFilter("module", "System.Int32", DataFilterCondition.Equal, 4),new DataFilter("module", "System.Int32", DataFilterCondition.Equal, 5)});
//            sseries.DataFilters.Add(new DataFilter("module", "System.Int32", DataFilterCondition.Equal, 5));
            if (sDS.Count > 0) sseries.DataSource = sDS;
            //DEventsCount.Add("Файловая система", 0);
            //DEventsCount.Add("Реестр", 0);
            //DEventsCount.Add("Процессы", 0);
            //DEventsCount.Add("Сеть", 0);
            //foreach (var evt in evts)
            //{
            //    startValue = yOfset + evt.significance;
            //    switch (evt.module)
            //    {
            //        case 1:
            //            fseries.Points.Add(new DevExpress.XtraCharts.SeriesPoint(virtualTime, new double[] { startValue, startValue + 1 }));
            //            DEventsCount["Файловая система"]++;
            //            break;
            //        case 2:
            //            rseries.Points.Add(new DevExpress.XtraCharts.SeriesPoint(virtualTime, new double[] { startValue, startValue + 1 }));
            //            DEventsCount["Реестр"]++;
            //            break;
            //        case 3:
            //            pseries.Points.Add(new DevExpress.XtraCharts.SeriesPoint(virtualTime, new double[] { startValue, startValue + 1 }));
            //            DEventsCount["Процессы"]++;
            //            break;
            //        case 4:
            //        case 5:
            //            sseries.Points.Add(new DevExpress.XtraCharts.SeriesPoint(virtualTime, new double[] { startValue, startValue + 1 }));
            //            DEventsCount["Сеть"]++;
            //            break;
            //    }
            //    virtualTime++;
            //}
            wcEventsSign.DataBind();
        }

        public static void AskPCAPFile(Int32 researchId)
        {
            var research = ResearchManager.GetResearch(researchId);
            var researchVmData = ResearchManager.GetResearchVmData(research.ResearchVmData);
            if (researchVmData == null) return;

            String ip = researchVmData.VmEnvIp;
            String beginTime = research.StartedDate.HasValue ? research.StartedDate.Value.ToString("yyyy-MM-dd HH':'mm':'ss") : DateTime.Now.ToString("yyyy-MM-dd HH':'mm':'ss");
            String endTime = research.StoppedDate.HasValue ? research.StoppedDate.Value.ToString("yyyy-MM-dd HH':'mm':'ss") : DateTime.Now.ToString("yyyy-MM-dd HH':'mm':'ss");

            Packet packet = new Packet { Type = PacketType.CMD_LOAD_TRAFFIC, Direction = PacketDirection.REQUEST };
            packet.AddParameter(Encoding.UTF8.GetBytes(ip));
            packet.AddParameter(Encoding.UTF8.GetBytes(beginTime));
            packet.AddParameter(Encoding.UTF8.GetBytes(endTime));
            SendPacket(packet);

            String filename = ip + beginTime + ".pcap";
            ResearchManager.UpdateTrafficInfo(research.Id, TrafficFileReady.EXECUTING, filename);
        }


        //protected void CBPagingSize_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    var newPageSize = (Int32)CBPagingSize.SelectedItem.Value;
        //    gridViewReports.SettingsPager.PageSize = newPageSize;
        //    gridViewReports.DataBind();

        //}

        protected void BtnGetClick(object sender, EventArgs e)
        {
            var research = ResearchManager.GetResearch(UserId, Rs.ResearchName);
            if (research == null) return;
            Session["researchId"] = research.Id;

            // UpdatePanelReports.Visible = true;
            gridViewReports.DataSource = ReportManager.GetReports(Convert.ToInt32(Session["researchId"]));
            gridViewReports.DataBind();



            linkGetTraffic.NavigateUrl = "javascript;";
            if (research.TrafficFileReady == (Int32)TrafficFileReady.COMPLETE)
            {
                String link = research.TrafficFileName;
                linkGetTraffic.NavigateUrl = link;
                linkGetTraffic.Visible = true;
                linkGetTraffic.Enabled = true;
                ASPxButton1.Visible = false;
            }

            // это наверно не надо, не пойму зачем тут этот код у него вставлен

                        //String path = Request.Path;
                        //String root = path.Substring(0, path.LastIndexOf("/"));
                        //linkGetProcessList.NavigateUrl = root + "/ProcessList.aspx?research=" + research.Id;
                        //linkGetRegistryList.NavigateUrl = root + "/RegistryList.aspx?research=" + research.Id;
                        //linkGetFileList.NavigateUrl = root + "/FileList.aspx?research=" + research.Id;

            //*/
          /*  if (research.TrafficFileReady == (Int32)TrafficFileReady.NOACTION)
            {
                var researchVmData = ResearchManager.GetResearchVmData(research.ResearchVmData);
                if (researchVmData == null) return;

                String ip = researchVmData.VmEnvIp;
                String beginTime = research.StartedDate.HasValue ? research.StartedDate.Value.ToString("yyyy-MM-dd HH':'mm':'ss") : DateTime.Now.ToString("yyyy-MM-dd HH':'mm':'ss");
                String endTime = research.StoppedDate.HasValue ? research.StoppedDate.Value.ToString("yyyy-MM-dd HH':'mm':'ss") : DateTime.Now.ToString("yyyy-MM-dd HH':'mm':'ss");

                Packet packet = new Packet { Type = PacketType.CMD_LOAD_TRAFFIC, Direction = PacketDirection.REQUEST };
                packet.AddParameter(Encoding.UTF8.GetBytes(ip));
                packet.AddParameter(Encoding.UTF8.GetBytes(beginTime));
                packet.AddParameter(Encoding.UTF8.GetBytes(endTime));
                SendPacket(packet);

                String filename = ip + beginTime + ".pcap";
                ResearchManager.UpdateTrafficInfo(research.Id, TrafficFileReady.EXECUTING, filename);
                
            }*/
            ASPxButton1.Enabled = false;
            ASPxButton1.Text = "Запрос на получение трафика отправлен";

            gridViewReports.DataSource = ResearchManager.GetEventsForRsch(Rs.Id);
            //var newPageSize = (Int32)CBPagingSize.SelectedItem.Value;
            //gridViewReports.SettingsPager.PageSize = newPageSize;
        }

        protected void ASPxButton2_Click(object sender, EventArgs e)
        {
            int sign = ASPxComboBox1.Text == "Критически важное" ? 0 : 1;
            string module = (string)this.gridViewReports.GetRowValues(this.gridViewReports.FocusedRowIndex, "ModuleId");
            string evnt = (string)this.gridViewReports.GetRowValues(this.gridViewReports.FocusedRowIndex, "EventCode");
            string dest = (string)this.gridViewReports.GetRowValues(this.gridViewReports.FocusedRowIndex, "dest");
            string who = (string)this.gridViewReports.GetRowValues(this.gridViewReports.FocusedRowIndex, "who");
            int moduleCode = ResearchManager.GetModuleIdByDescr(module);
            int eventCode = ResearchManager.GetEventIdByDescr(evnt);
            ReportManager.InsertRowDirectoriesOfEvents(sign, moduleCode, eventCode, dest,who);

        }

        protected void gridViewReports_HtmlRowPrepared(object sender, DevExpress.Web.ASPxGridView.ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != DevExpress.Web.ASPxGridView.GridViewRowType.Data) return;
            switch (Convert.ToInt32(e.GetValue("significance")))
                    {
                        case 1:
                            {
                                e.Row.BackColor = Color.SandyBrown;
                                break;
                            }
                        case 2:
                            {
                                e.Row.BackColor = Color.Salmon;
                                break;
                            }
                    }
        }

        protected void wcEventsSign_CustomCallback(object sender, DevExpress.XtraCharts.Web.CustomCallbackEventArgs e)
        {
            UpdateEventChart(0, researchId);
//            RegTreeList.VirtualModeCreateChildren += new TreeListVirtualModeCreateChildrenEventHandler(RegTree_VirtualModeCreateChildren);
//            RegTreeList.VirtualModeNodeCreating += new TreeListVirtualModeNodeCreatingEventHandler(RegTree_VirtualModeNodeCreating);
//            RegTreeList.RefreshVirtualTree();
        }

        protected void gridViewReports_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            switch (e.Parameters)
            {
                case "SaveLayout":
                    StringBuilder sb = new StringBuilder();
                    sb.Append(gridViewReports.Settings.ShowFilterRow ? "T" : "F");
                    sb.Append(separator);

                    sb.Append(gridViewReports.SaveClientLayout());

                    WebTables.SetLayout((int)Membership.GetUser().ProviderUserKey, "ReportTable", sb.ToString());
                    break;
                case "ShowFilterRow":
                    DevExpress.Web.ASPxMenu.MenuItem mitem = TableFilterMenu.Items.FindByName("ShowFiterRow");
                    mitem.Checked = !mitem.Checked;
                    gridViewReports.Settings.ShowFilterRow = mitem.Checked;
                    gridViewReports.Settings.ShowFilterRowMenu = mitem.Checked;
                    break;
            }
        }

        protected void ExportPDFBtn_Click(object sender, EventArgs e)
        {
            gridExport.PageHeader.Left = "Имя пользователя: " + Membership.GetUser().UserName + " ([Имя пользователя])";
            gridExport.WritePdfToResponse();
        }

        protected void ExportXLSBtn_Click(object sender, EventArgs e)
        {
            gridExport.PageHeader.Left = "Имя пользователя: " + Membership.GetUser().UserName + " ([Имя пользователя])";
            gridExport.WriteXlsToResponse();
        }

        protected void ExportXLSXBtn_Click(object sender, EventArgs e)
        {
            gridExport.PageHeader.Left = "Имя пользователя: " + Membership.GetUser().UserName + " ([Имя пользователя])";
            gridExport.WriteXlsxToResponse();
        }

        protected void ExportRTFBtn_Click(object sender, EventArgs e)
        {
            gridExport.PageHeader.Left = "Имя пользователя: " + Membership.GetUser().UserName + " ([Имя пользователя])";
            gridExport.WriteRtfToResponse();
        }

        protected void ExportCSVBtn_Click(object sender, EventArgs e)
        {
            gridExport.PageHeader.Left = "Имя пользователя: " + Membership.GetUser().UserName + " ([Имя пользователя])";
            gridExport.WriteCsvToResponse();
        }

        protected void FileTree_VirtualModeNodeCreating(object sender, TreeListVirtualModeNodeCreatingEventArgs e)
        {
            Files rowView = e.NodeObject as Files;
            if (rowView == null) return;
            e.NodeKeyValue = rowView.fileindex;
            e.IsLeaf = !rowView.IsDir;
            e.SetNodeValue("Name", rowView.Name);
            if (rowView.IsDir) e.SetNodeValue("IconName", "reg_dir");
            else e.SetNodeValue("IconName", "reg_file");
        }

        protected void FileTree_VirtualModeCreateChildren(object sender, TreeListVirtualModeCreateChildrenEventArgs e)
        {
            if (IsPostBack && FileTreeList.UniqueID != Page.Request.Params.Get("__EVENTTARGET")) return;
            List<Files> children = null;
            Files parent = e.NodeObject as Files;
            if (parent == null)
            {
                children = TreeViewBuilder.GetFilesTableViewByParentId((int)Session["rsch"], 0);
                if (children.Count == 0) FileTreeList.ClearNodes();
            }
            else
            {
                children = TreeViewBuilder.GetFilesTableViewByParentId((int)Session["rsch"], (int)parent.fileindex);
            }
            e.Children = children;
        }

        protected string GetIconUrl(TreeListDataCellTemplateContainer container)
        {
            return string.Format("~/Content/Images/Icons/{0}.png", container.GetValue("IconName"));
        }

        protected void RegTree_VirtualModeNodeCreating(object sender, TreeListVirtualModeNodeCreatingEventArgs e)
        {
            Reg rowView = e.NodeObject as Reg;
            if (rowView == null) return;
            e.NodeKeyValue = rowView.KeyIndex;
            e.SetNodeValue("KeyName", rowView.KeyName);
        }

        protected void RegTree_VirtualModeCreateChildren(object sender, TreeListVirtualModeCreateChildrenEventArgs e)
        {
            //ScriptManager sm = (ScriptManager)Master.Master.FindControl("ScriptManager1");
            //int i;
            //if (sm.IsInAsyncPostBack) i = 1;
            //string ctrlName = Page.Request.Params.Get("__EVENTTARGET");
            //if (RegTreeList.UniqueID == ctrlName) i = 2;
            if (IsPostBack && RegTreeList.UniqueID != Page.Request.Params.Get("__EVENTTARGET")) return;
            List<Reg> children = null;
            Reg parent = e.NodeObject as Reg;
            if (parent == null)
            {
                children = TreeViewBuilder.GetRegsTableViewByParentId((int)Session["rsch"], 0);
                if (children.Count == 0) RegTreeList.ClearNodes();
            }
            else
            {
                children = TreeViewBuilder.GetRegsTableViewByParentId((int)Session["rsch"], (int)parent.KeyIndex);
            }
            e.Children = children;
        }

        protected void RegComp_VirtualModeNodeCreating(object sender, TreeListVirtualModeNodeCreatingEventArgs e)
        {
            RegCompareTreeItem rowView = e.NodeObject as RegCompareTreeItem;
            if (rowView == null) return;
            e.NodeKeyValue = rowView.ID;
            e.SetNodeValue("Text", rowView.Text);
            e.SetNodeValue("EtlID", rowView.EtlID);
            e.SetNodeValue("RegID", rowView.RegID);
            if (rowView.EtlID > -1) e.SetNodeValue("Etl", rowView.EtlValue);
            if (rowView.RegID > -1) e.SetNodeValue("Reg", rowView.RegValue);
            e.IsLeaf = rowView.IsKey;
            if (rowView.IsKey) e.SetNodeValue("IconName", "reg_file");
            else e.SetNodeValue("IconName", "reg_dir");
        }

        protected void RegComp_VirtualModeCreateChildren(object sender, TreeListVirtualModeCreateChildrenEventArgs e)
        {
            int eltrootid = -1;
            if (Session["eltrootid"] != null) int.TryParse(Session["eltrootid"].ToString(), out eltrootid);
            if (eltrootid > -1)
            {
                int rschsysid = -1;
                if (Session["rschsysid"] != null) int.TryParse(Session["rschsysid"].ToString(), out rschsysid);
                int rsch = -1;
                if (Session["rsch"] != null) int.TryParse(Session["rsch"].ToString(), out rsch);
                List<RegCompareTreeItem> children = null;
                RegCompareTreeItem parent = e.NodeObject as RegCompareTreeItem;
                if (parent == null)
                {
                    children = TreeViewBuilder.GetRegsCompTableView(RegCompTreeList.TotalNodeCount + 1, 0, rschsysid, eltrootid, rsch, 0);
                    if (children.Count == 0) RegTreeList.ClearNodes();
                }
                else
                {
                    children = TreeViewBuilder.GetRegsCompTableView(RegCompTreeList.TotalNodeCount + 1, parent.ID, rschsysid, parent.EtlID, rsch, parent.RegID);
                }
                e.Children = children;
            }
        }

        protected void RegCompList_HtmlDataCellPrepared(object sender, TreeListHtmlDataCellEventArgs e)
        {
            if (e.Column.Name == "Etl")
            {
                TreeListNode node = RegCompTreeList.FindNodeByKeyValue(e.NodeKey);
                if (Convert.ToInt32(node["EtlID"]) > -1) e.Cell.BackColor = Color.DarkSeaGreen;
                else e.Cell.BackColor = Color.DarkSalmon;
            }
            else if (e.Column.Name == "Reg")
            {
                TreeListNode node = RegCompTreeList.FindNodeByKeyValue(e.NodeKey);
                if (Convert.ToInt32(node["RegID"]) > -1)
                {
                    if ((node["Reg"] == null && node["Etl"] == null) || (node["Reg"] != null && node["Etl"] != null && node["Reg"].ToString() == node["Etl"].ToString())) e.Cell.BackColor = Color.DarkSeaGreen;
                    else e.Cell.BackColor = Color.Gold;
                }
                else e.Cell.BackColor = Color.DarkSalmon;
            }
        }

        protected string GetRegIconUrl(TreeListDataCellTemplateContainer container)
        {
            return string.Format("~/Content/Images/Icons/{0}.png", container.GetValue("IconName"));
        }

        //protected void ProcTree_VirtualModeNodeCreating(object sender, TreeListVirtualModeNodeCreatingEventArgs e)
        //{
        //    Procs rowView = e.NodeObject as Procs;
        //    if (rowView == null) return;
        //    e.NodeKeyValue = rowView.Pid1;
        //    e.SetNodeValue("Name", rowView.Name);
        //    e.SetNodeValue("PID", rowView.Pid1);
        //    e.SetNodeValue("ThrCount", rowView.Count);
        //}

        //protected void ProcTree_VirtualModeCreateChildren(object sender, TreeListVirtualModeCreateChildrenEventArgs e)
        //{
        //    List<Procs> children = null;
        //    Procs parent = e.NodeObject as Procs;
        //    if (parent == null)
        //    {
        //        children = TreeViewBuilder.GetProcTableViewByParentId((int)Session["rsch"], 0);
        //        if (children.Count == 0) ProcTreeList.ClearNodes();
        //    }
        //    else
        //    {
        //        children = TreeViewBuilder.GetProcTableViewByParentId((int)Session["rsch"], (int)parent.Pid1);
        //    }
        //    e.Children = children;
        //}

        protected void gvPorts_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != DevExpress.Web.ASPxGridView.GridViewRowType.Data) return;
            PortList pl = ResearchManager.GetPortList((long)e.KeyValue);
            if (pl != null)
            {
                switch (pl.status)
                {
                    case "Ожидает входящих соединений.":
                        {
                            e.Row.BackColor = Color.PeachPuff;
                            break;
                        }
                    case "Соединение установлено.":
                        {
                            e.Row.BackColor = Color.Pink;
                            break;
                        }
                    default:
                        {
                            break;
                        }
                }
            }
        }

        protected void RegTreeList_FocusedNodeChanged(object sender, EventArgs e)
        {
            gvRegKeys.DataSource = TreeViewBuilder.GetKeyValues(Convert.ToInt32(RegTreeList.FocusedNode.Key));
            gvRegKeys.DataBind();
            RegKeysUpdatePanel.Update();
        }
        
        //    protected void UpdatePanel_Unload(object sender, EventArgs e)
    //    {
    //        MethodInfo methodInfo = typeof(ScriptManager).GetMethods(BindingFlags.NonPublic | BindingFlags.Instance)
    //.Where(i => i.Name.Equals("System.Web.UI.IScriptManagerInternal.RegisterUpdatePanel")).First();
    //        methodInfo.Invoke(ScriptManager.GetCurrent(Page),
    //            new object[] { sender as UpdatePanel });
    //    }

        //private void ApdateTraficLinq()
        //{
        //    var research = ResearchManager.GetResearch(UserId, Rs.ResearchName);
        //    if (research == null) return;
        //    Session["researchId"] = research.Id;

        //    // UpdatePanelReports.Visible = true;
        //    gridViewReports.DataSource = ReportManager.GetReports(Convert.ToInt32(Session["researchId"]));
        //    gridViewReports.DataBind();



        //    linkGetTraffic.NavigateUrl = "javascript;";
        //    if (research.TrafficFileReady == (Int32)TrafficFileReady.COMPLETE)
        //    {
        //        String link = research.TrafficFileName;
        //        linkGetTraffic.NavigateUrl = link;
        //        linkGetTraffic.Visible = true;
        //        linkGetTraffic.Enabled = true;
        //        ASPxButton1.Visible = false;
        //    }
        //}
    }//end class
}//end namespace