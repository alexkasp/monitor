using System;
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
            Mlwr mlwrrec = ResearchManager.GetMlwrByRschId(researchId);
            if (mlwrrec != null) Mlwr.Text = mlwrrec.Name + " (" + mlwrrec.Path + ")";
            LOS.Text = ResearchManager.GetRschOS(researchId);
            LIRType.Text = ResearchManager.GetRschVmType(researchId);
            LStartTime.Text = Rs.CreatedDate.ToString("dd MMM yyyyг. HH:mm:ss");
            LStopTime.Text = Rs.Duration.ToString()+" мин.";
            if (Rs.StartedDate.HasValue) //Сессия начата
            {
                Int32 elapsedMins = (Int32)((DateTime.Now - Rs.StartedDate.Value).TotalMinutes);
                Int32 leftMins = Rs.Duration - elapsedMins;
                
                if (leftMins <= 0)
                {
                    LStatus.Text = "Завершено по таймеру";
                }
                else
                {
                    LStatus.Text = "Завершено принудительно (ост. "+ leftMins + " мин.)";
                }
            }
            else
            {
                LStatus.Text = "Готово к запуску";
            }
            LHeader.Text = String.Format("Исследование (№{0}): {1}", Rs.Id, Rs.ResearchName);
            HLPorts.NavigateUrl += ("?research=" + researchId);
            linkGetRegistryList.NavigateUrl += ("?researchId=" + researchId);
            linkGetFileList.NavigateUrl += ("?researchId=" + researchId);
            linkGetProcessList.NavigateUrl += ("?researchId=" + researchId);
            Session["rsch"] = researchId;
            DEventsCount.Clear();

            gridAddParams.DataSource = TaskManager.GetTasksViewForRsch(researchId);//dataX;
            gridAddParams.DataBind(); 
            
            gridViewReports.DataSource = ResearchManager.GetEventsForRsch(Rs.Id);
//            var newPageSize = (Int32)CBPagingSize.SelectedItem.Value;
//            gridViewReports.SettingsPager.PageSize = newPageSize;
            gridViewReports.DataBind();

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

//                ReportsBuilder.RschPropsListBuilder(TreeView1, Rs.Id);
                 ASPxHyperLink5.NavigateUrl += ("?research=" + researchId);
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
            ((SideBySideRangeBarSeriesView)fseries.View).Color = Color.FromArgb(74, 134, 153);
            ((SideBySideRangeBarSeriesView)fseries.View).FillStyle.FillMode = FillMode.Solid;
//            ((SideBySideRangeBarSeriesView)rseries.View).Color = Color.FromArgb(0, 0, 255);
            ((SideBySideRangeBarSeriesView)rseries.View).Color = Color.FromArgb(43, 83, 96);
            ((SideBySideRangeBarSeriesView)rseries.View).FillStyle.FillMode = FillMode.Solid;
//            ((SideBySideRangeBarSeriesView)pseries.View).Color = Color.FromArgb(0, 255, 0);
            ((SideBySideRangeBarSeriesView)pseries.View).Color = Color.FromArgb(163, 193, 204);
            ((SideBySideRangeBarSeriesView)pseries.View).FillStyle.FillMode = FillMode.Solid;
//            ((SideBySideRangeBarSeriesView)sseries.View).Color = Color.FromArgb(0, 255, 255);
            ((SideBySideRangeBarSeriesView)sseries.View).Color = Color.FromArgb(18, 50, 59);
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