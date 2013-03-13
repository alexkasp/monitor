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

namespace SandBox.WebUi.Pages.Research
{
    public partial class ReportList : BaseMainPage
    {
        public Db.Research Rs;
        private Dictionary<string, int> DEventsCount = new Dictionary<string, int>();

        protected new void Page_Load(object sender, EventArgs e)
        {

            gridViewReports.KeyFieldName = "Id";
            base.Page_Load(sender, e);
            PageTitle = "Отчет";
            PageMenu  = "~/App_Data/SideMenu/Research/ResearchMenu.xml";
            Int32 researchId = -1;
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
            ASPxHyperLink4.NavigateUrl += ("?research=" + researchId);
            Session["rsch"] = researchId;
            DEventsCount.Clear();
            UpdateEventChart(0, researchId);

            gridAddParams.DataSource = TaskManager.GetTasksViewForRsch(researchId);//dataX;
            gridAddParams.DataBind(); 
            
            gridViewReports.DataSource = ResearchManager.GetEventsForRsch(Rs.Id);
            var newPageSize = (Int32)CBPagingSize.SelectedItem.Value;
            gridViewReports.SettingsPager.PageSize = newPageSize;
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
            int startValue = 0;
            wcEventsSign.Series.Clear();
            wcEventsSign.Series.Add("Файловая система", DevExpress.XtraCharts.ViewType.SideBySideRangeBar);
            wcEventsSign.Series.Add("Реестр", DevExpress.XtraCharts.ViewType.SideBySideRangeBar);
            wcEventsSign.Series.Add("Процессы", DevExpress.XtraCharts.ViewType.SideBySideRangeBar);
            wcEventsSign.Series.Add("Сеть", DevExpress.XtraCharts.ViewType.SideBySideRangeBar);
            DEventsCount.Add("Файловая система", 0);
            DEventsCount.Add("Реестр", 0);
            DEventsCount.Add("Процессы", 0);
            DEventsCount.Add("Сеть", 0);
            DevExpress.XtraCharts.Series fseries = wcEventsSign.GetSeriesByName("Файловая система");
            DevExpress.XtraCharts.Series rseries = wcEventsSign.GetSeriesByName("Реестр");
            DevExpress.XtraCharts.Series pseries = wcEventsSign.GetSeriesByName("Процессы");
            DevExpress.XtraCharts.Series sseries = wcEventsSign.GetSeriesByName("Сеть");
            ((SideBySideRangeBarSeriesView)fseries.View).Color = Color.FromArgb(74, 134, 153);
            ((SideBySideRangeBarSeriesView)fseries.View).FillStyle.FillMode = FillMode.Solid;
            ((SideBySideRangeBarSeriesView)rseries.View).Color = Color.FromArgb(43, 83, 96);
            ((SideBySideRangeBarSeriesView)rseries.View).FillStyle.FillMode = FillMode.Solid;
            ((SideBySideRangeBarSeriesView)pseries.View).Color = Color.FromArgb(163, 193, 204);
            ((SideBySideRangeBarSeriesView)pseries.View).FillStyle.FillMode = FillMode.Solid;
            ((SideBySideRangeBarSeriesView)sseries.View).Color = Color.FromArgb(18, 50, 59);
            ((SideBySideRangeBarSeriesView)sseries.View).FillStyle.FillMode = FillMode.Solid;
            var evts = ResearchManager.GetEventsSignByRschId(r);
            foreach (var evt in evts)
            {
                startValue = yOfset + GetOfsetForEvent(evt.significance);
                switch (evt.module)
                {
                    case 1:
                        fseries.Points.Add(new DevExpress.XtraCharts.SeriesPoint(virtualTime, new double[] { startValue, startValue + 1 }));
                        DEventsCount["Файловая система"]++;
                        break;
                    case 2:
                        rseries.Points.Add(new DevExpress.XtraCharts.SeriesPoint(virtualTime, new double[] { startValue, startValue + 1 }));
                        DEventsCount["Реестр"]++;
                        break;
                    case 3:
                        pseries.Points.Add(new DevExpress.XtraCharts.SeriesPoint(virtualTime, new double[] { startValue, startValue + 1 }));
                        DEventsCount["Процессы"]++;
                        break;
                    case 4:
                    case 5:
                        sseries.Points.Add(new DevExpress.XtraCharts.SeriesPoint(virtualTime, new double[] { startValue, startValue + 1 }));
                        DEventsCount["Сеть"]++;
                        break;
                }
                virtualTime++;
            }
        }

        private int GetOfsetForEvent(int evtSignif)
        {
            switch (evtSignif)
            {
                case 0:
                    {
                        return 2;
                    }
                case 1:
                    {
                        return 1;
                    }
                default:
                    {
                        return 0;
                    }
            }
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


        protected void CBPagingSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            var newPageSize = (Int32)CBPagingSize.SelectedItem.Value;
            gridViewReports.SettingsPager.PageSize = newPageSize;
            gridViewReports.DataBind();

        }

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
            var newPageSize = (Int32)CBPagingSize.SelectedItem.Value;
            gridViewReports.SettingsPager.PageSize = newPageSize;
            gridViewReports.DataBind();
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
            if (e.KeyValue != null)
            {
                long key = (long)e.KeyValue;
                var evt = ResearchManager.GetEventById(key);
                if (evt != null)
                {
                    int evtSignif = ReportManager.GetEvtSignif(evt);
                    switch (evtSignif)
                    {
                        case 0:
                            {
                                e.Row.BackColor = Color.Salmon;
                                break;
                            }
                        case 1:
                            {
                                e.Row.BackColor = Color.SandyBrown;
                                break;
                            }
                        default:
                            {
                                break;
                            }
                    }
                    //e.Row.BackColor = Color.Yellow;
                }
            }
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