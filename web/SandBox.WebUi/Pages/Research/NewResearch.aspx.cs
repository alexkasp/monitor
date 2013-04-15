using System;
using System.Collections.Generic;
using SandBox.Db;
using SandBox.Log;
using SandBox.WebUi.Base;
using System.Linq;
using DevExpress.Web.ASPxGridView;
using System.Security.Cryptography;
using SandBox.Connection;
using System.Text;
using DevExpress.Web.ASPxEditors;
using System.Data;
using DevExpress.Web.ASPxTreeList;

namespace SandBox.WebUi.Pages.Research
{
    public partial class NewResearch : BaseMainPage
    {
        
        protected new void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);
            PageTitle = "Создание исследования";
            PageMenu = "~/App_Data/SideMenu/Research/ResearchMenu.xml";
            //   List<string> vmList = IsUserInRole("Administrator") ? VmManager.GetVmReadyNameList() : VmManager.GetVmReadyNameList(UserId);

            //ASPxComboBox2.Items.Clear();
            //if (vlirList.Count() < 1)
            //{
            //    cbVLIR.Enabled = false;
            //}
            //else
            //{
            //    cbVLIR.Enabled = true;
            //    cbVLIR.DataSource = vlirList;
            //    cbVLIR.DataBind();
            //}
            if (!IsPostBack)
            {
                //ASPxComboBox3.DataSource = from item in new List<string> { "HKEY_CLASSES_ROOT", "HKEY_CURRENT_USER", "HKEY_LOCAL_MACHINE", "HKEY_USERS", "HKEY_CURRENT_CONFIG" }
                //                           select new { hkey = item };
                //ASPxComboBox3.DataBind();
                IQueryable vlirList = IsUserInRole("Administrator") ? VmManager.GetVLIRReadyForResearch() : VmManager.GetVLIRReadyForResearch(UserId);
                cbEtln.DataSource = VmManager.GetEtlnReadyForResearch();
                cbEtln.DataBind();
                cbEtln.SelectedIndex = 0;
                cbVLIR.DataSource = vlirList;
                cbVLIR.DataBind();
                if (cbVLIR.Items.Count > 0) cbVLIR.SelectedIndex = 0;
                else rbVLIR.Enabled = false;
                cbLIR.DataSource = VmManager.GetLIRReadyForResearch();
                cbLIR.DataBind();
                if (cbLIR.Items.Count > 0) cbLIR.SelectedIndex = 0;
                else rbLIR.Enabled = false;
                CBNetActiv.Items.AddRange(TaskManager.GetTasksDescrByClassification(1).ToList());
                CBNetActiv.SelectedIndex = 0;
                CBFileActiv.Items.AddRange(TaskManager.GetTasksDescrByClassification(2).ToList());
                CBFileActiv.SelectedIndex = 0;
                CBRegActiv.Items.AddRange(TaskManager.GetTasksDescrByClassification(3).ToList());
                CBRegActiv.SelectedIndex = 0;
                CBProcActiv.Items.AddRange(TaskManager.GetTasksDescrByClassification(4).ToList());
                CBProcActiv.SelectedIndex = 0;

                cbModule.DataSource = ReportManager.GetModules();
                cbModule.DataBind();
                cbModule.SelectedIndex = 0;
                cbEvent.DataSource = ReportManager.GetEventsDescrByModule(cbModule.Value.ToString());
                cbEvent.DataBind();
                cbEvent.SelectedIndex = 0;

                List<string> mlwrList = MlwrManager.GetMlwrNameList();


                cbMalware.DataSource = mlwrList;
                cbMalware.DataBind();
                cbMalware.SelectedIndex = 0;

                Session["tasks"] = new List<TaskStruct>();
                rschName.Text = "Исследование_"+DateTime.Now.ToShortDateString();
                lbFSParams.DataSource = dsFSParams;
                lbFSParams.DataBind();
                lbRegParams.DataSource = dsRegParams;
                lbRegParams.DataBind();
                lbProcParams.DataSource = dsProcParams;
                lbProcParams.DataBind();
                lbNetParams.DataSource = dsNetParams;
                lbNetParams.DataBind();

            }

        }

        protected DataTable dsFSParams
        {
            get
            {
                if (Session["dsFSParams"] == null)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("ID");
                    dt.Columns.Add("Task");
                    dt.Columns.Add("Param");
                    Session["dsFSParams"] = dt;
                }
                return Session["dsFSParams"] as DataTable;
            }
        }

        protected DataTable dsRegParams
        {
            get
            {
                if (Session["dsRegParams"] == null)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("ID");
                    dt.Columns.Add("Task");
                    dt.Columns.Add("Param");
                    Session["dsRegParams"] = dt;
                }
                return Session["dsRegParams"] as DataTable;
            }
        }

        protected DataTable dsProcParams
        {
            get
            {
                if (Session["dsProcParams"] == null)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("ID");
                    dt.Columns.Add("Task");
                    dt.Columns.Add("Param");
                    Session["dsProcParams"] = dt;
                }
                return Session["dsProcParams"] as DataTable;
            }
        }

        protected DataTable dsNetParams
        {
            get
            {
                if (Session["dsNetParams"] == null)
                {
                    DataTable dt = new DataTable();
                    dt.Columns.Add("ID");
                    dt.Columns.Add("Task");
                    dt.Columns.Add("Param");
                    Session["dsNetParams"] = dt;
                }
                return Session["dsNetParams"] as DataTable;
            }
        }

        protected void BtnCreateClick(object sender, EventArgs e)
        {

            Int32 vmid = -1;
            if (rbEtln.Checked) vmid = Convert.ToInt32(cbEtln.Value);
            else if (rbLIR.Checked) vmid = Convert.ToInt32(cbLIR.Value);
            else if (rbVLIR.Checked) vmid = Convert.ToInt32(cbVLIR.Value);
            Vm vm = VmManager.GetVm(vmid);
            Mlwr mlwr = MlwrManager.GetMlwrByName(cbMalware.Value.ToString());
            Int32 timeLeft = Convert.ToInt32(spinTime.Value);

            String NewName="";
            Int32 researchVmData = 0;
            Int32 researchId = 0;
            if (vm.Type == 1)
            {
                NewName = GenRandString(20);
                VmManager.AddVm(NewName, 2, vm.System, UserId, 0);
                Vm newvm = VmManager.GetVm(NewName);
                researchVmData = ResearchManager.AddResearchVmData(NewName, 2, newvm.System, 0, newvm.EnvMac, newvm.EnvIp, newvm.Description);
                researchId = ResearchManager.AddResearch(UserId, mlwr.Id, newvm.Id, researchVmData, timeLeft, rschName.Text);
            }
            else
            {
                researchVmData = ResearchManager.AddResearchVmData(vm.Name, vm.Type, vm.System, vm.EnvType, vm.EnvMac, vm.EnvIp, vm.Description);
                researchId = ResearchManager.AddResearch(UserId, mlwr.Id, vm.Id, researchVmData, timeLeft, rschName.Text);
            }
          

            AddTasks(researchId, vm.EnvId);

            #region добавление события на остановку исследования
            if (cbEventEnd.Checked)
            {
                //int sign = ASPxComboBox1.Text == "Критически важное" ? 0 : 1;
//                int module = ResearchManager.GetModuleIdByDescr(cbModule.Text);
                Int32 evt = Convert.ToInt32(cbEvent.Value);
                int module = ReportManager.GetModuleIdByEventId(evt);
                string dest = tbDest.Text;
                string who = tbWho.Text;
                //if (module != -1 && evt != -1 && dest != String.Empty && who != String.Empty)
                //{
                    ReportManager.InsertStopEvent(researchId, module, evt, dest, who);

                //}
            }
            #endregion

            MLogger.LogTo(Level.TRACE, false, "Create research '" + rschName.Text + "' by user '" + UserManager.GetUser(UserId).UserName + "'");
            MLogger.LogTo(Level.TRACE, false, "Create or start vm '" + vm.Name + "' with name '" + NewName + "'");
            if (CreateOrStartVm(vm.Name, NewName))
                Current.StartResearch(String.Format("{0}", researchId));
            Response.Redirect("~/Pages/Research/Current.aspx");
        }

        private int GetSelectedSystemId()
        {
            Int32 vmid = -1; 
            if (rbEtln.Checked) vmid = Convert.ToInt32(cbEtln.Value);
            else if (rbLIR.Checked) vmid = Convert.ToInt32(cbLIR.Value);
            else if (rbVLIR.Checked) vmid = Convert.ToInt32(cbVLIR.Value);
            Vm vm = VmManager.GetVm(vmid);
            return vm.System;
        }

        public static string GenRandString(int length)
        {
            byte[] randBuffer = new byte[length];
            RandomNumberGenerator.Create().GetBytes(randBuffer);
            String prepare = System.Convert.ToBase64String(randBuffer).Remove(length).Replace("+", "p");
            prepare = prepare.Replace("/","s");
            prepare = prepare.Replace("\\","w");
            return prepare;
        }

        protected bool CreateOrStartVm(String VmName,String NewName)
        {
            Vm baseVm = VmManager.GetVm(VmName);

            if (baseVm.Type == 1)
            {

                String newName = NewName;// 
               
                Packet packet = new Packet { Type = PacketType.CMD_VM_CREATE, Direction = PacketDirection.REQUEST };
                packet.AddParameter(Encoding.UTF8.GetBytes(VmName));
                packet.AddParameter(Encoding.UTF8.GetBytes(newName));
                SendPacket(packet.ToByteArray());
                //Vm newVm = VmManager.GetVm(newName);
                VmManager.UpdateVmState(newName, (int)VmManager.State.UNAVAILABLE);
                return false;
            }
            else
            {
                if (baseVm.State == Convert.ToInt32(VmManager.State.STARTED))
                {
                    return true;
                }
                else
                {
                    Packet packet = new Packet { Type = PacketType.CMD_VM_START, Direction = PacketDirection.REQUEST };
                    packet.AddParameter(Encoding.UTF8.GetBytes(VmName));
                    SendPacket(packet.ToByteArray());
                    return false;
                }
            }

        }

        private void AddTasks(Int32 researchId, int EnvId)
        {
            //String hideFilePar = tbHideFile.Text;
            //String lockFilePar = tbLockDelete.Text;
            //String hideRegistryPar = tbHideRegistry.Text;
            //String hideProcessPar = tbHideProcess.Text;
            //String setBandwidthPar = tbSetBandwidth.Text;

            //if (hideFilePar != String.Empty) TaskManager.AddTask(researchId, 1, hideFilePar);
            //if (lockFilePar != String.Empty) TaskManager.AddTask(researchId, 2, lockFilePar);
            //if (hideRegistryPar != String.Empty) TaskManager.AddTask(researchId, 3, hideRegistryPar);
            //if (hideProcessPar != String.Empty) TaskManager.AddTask(researchId, 4, hideProcessPar);
            if (cbSignature.Checked) TaskManager.AddTask(researchId, 5, tbSignature.Text);
            if (cbExtension.Checked) TaskManager.AddTask(researchId, 6, tbExtension.Text);
            //if (setBandwidthPar != String.Empty) TaskManager.AddTask(researchId, 7, setBandwidthPar);
            if (cbFileRoot.Checked) TaskManager.AddTask(researchId, 16, tbFileRoot.Text);
            if (cbRegRoot.Checked) TaskManager.AddTask(researchId, 17, String.Format("{0}{1}", cmbRegRoot.SelectedIndex, tbRegRoot.Text));
            if (cbProcMon.Checked) TaskManager.AddTask(researchId, 15, "ON");
            foreach (ListEditItem item in lbFSParams.Items) TaskManager.AddTask(researchId, TaskManager.GetTaskTypeByDescription(item.GetValue("Task").ToString()), item.GetValue("Param").ToString());
            foreach (ListEditItem item in lbRegParams.Items) TaskManager.AddTask(researchId, TaskManager.GetTaskTypeByDescription(item.GetValue("Task").ToString()), item.GetValue("Param").ToString());
            foreach (ListEditItem item in lbProcParams.Items) TaskManager.AddTask(researchId, TaskManager.GetTaskTypeByDescription(item.GetValue("Task").ToString()), item.GetValue("Param").ToString());
            foreach (ListEditItem item in lbNetParams.Items) TaskManager.AddTask(researchId, TaskManager.GetTaskTypeByDescription(item.GetValue("Task").ToString()), item.GetValue("Param").ToString());
            
            //var session = Session["tasks"] as List<TaskStruct>;
            //foreach (var task in session)
            //{
            //    if (task.Description != String.Empty && task.Value!=String.Empty/*ASPxTextBox1.Text != task.Value*/)
            //        TaskManager.AddTask(researchId, TaskManager.GetTaskTypeByDescription(task.Description), task.Value);
            //}
            //if (ASPxComboBox2.SelectedItem!=null)
            //if (ASPxComboBox2.SelectedItem.Text != String.Empty && ASPxTextBox1.Text != String.Empty)
            //    TaskManager.AddTask(researchId, TaskManager.GetTaskTypeByDescription(ASPxComboBox2.SelectedItem.Text), ASPxTextBox1.Text);
            try
            {
                MLogger.LogTo(Level.TRACE, false, "Add Command: " + tbEmulCommand.Text + tbEmulParams.Text);
                TaskManager.AddCommand(researchId, tbEmulCommand.Text, tbEmulParams.Text, Int32.Parse(spEmulTime.Text));
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        protected void BAddNetTask_Click(object sender, EventArgs e)
        {
            if (CBNetActiv.SelectedItem.Text != String.Empty && TBNetTaskValue.Text != String.Empty)
            {
                BAddTask(CBNetActiv.SelectedItem.Text, TBNetTaskValue.Text);
                Page.DataBind();
            }
        }

        private void BAddTask(string description, string value)
        {
            var session = Session["tasks"] as List<TaskStruct>;
            if (session != null)
                session.Add(new TaskStruct { Description = description, Value = value });
            else
            {
                Session["tasks"] = new List<TaskStruct>();
                session.Add(new TaskStruct { Description = CBNetActiv.SelectedItem.Text, Value = TBNetTaskValue.Text });
            }
            switch (TaskManager.GetClassTypeByTaskType(TaskManager.GetTaskTypeByDescription(description)))
            {
                //case 1:
                //    {
                //        FillGridView(ASPxGridView1, 1);
                //        break;
                //    }
                //case 2:
                //    {
                //        FillGridView(ASPxGridView2, 2);
                //        break;
                //    }
                //case 3:
                //    {
                //        FillGridView(ASPxGridView3, 3);
                //        break;
                //    }
                //case 4:
                //    {
                //        FillGridView(ASPxGridView4, 4);
                //        break;
                //    }
                default:
                    {
//                        FillGridView(ASPxGridView1, 1);
//                        FillGridView(ASPxGridView2, 2);
//                        FillGridView(ASPxGridView3, 3);
//                        FillGridView(ASPxGridView4, 4);
                        break;
                    }
            }
            Page.DataBind();
        }

        private List<TaskStruct> GetTableLookFromSession(int taskClassType)
        {
            List<TaskStruct> res = new List<TaskStruct>();
            var session = Session["tasks"] as List<TaskStruct>;
            if (session == null) return null;
            var tasks = from t in session
                        select new { type = TaskManager.GetTaskTypeByDescription(t.Description), value = t.Value, description = t.Description };
            foreach (var t in tasks)
            {
                if (TaskManager.GetClassTypeByTaskType(t.type) == taskClassType)
                {
                    res.Add(new TaskStruct { Description = t.description, Value = t.value });
                }
            }
            return res;
        }

        private void FillGridView(ASPxGridView gv, int taskClassType)
        {
            try
            {
                IQueryable<TaskStruct> test = GetTableLookFromSession(taskClassType).AsQueryable();
                gv.DataSource = from t in test
                                select new { f1 = t.Description, f2 = t.Value };
                gv.DataBind();
            }
            catch { }
        }

        private void FillAllGridViews()
        {
//            FillGridView(ASPxGridView1, 1);
//            FillGridView(ASPxGridView2, 2);
//            FillGridView(ASPxGridView3, 3);
//            FillGridView(ASPxGridView4, 4);
        }

        protected void ASPxGridView1_RowDeleting(object sender, DevExpress.Web.Data.ASPxDataDeletingEventArgs e)
        {
            string value = String.Format("{0}", e.Keys["Value"]);
            Page.DataBind();

        }

        protected void BAddFileTask_Click(object sender, EventArgs e)
        {
            if (CBFileActiv.SelectedItem.Text != String.Empty && TBNFileTaskValue.Text != String.Empty)
            {
                BAddTask(CBFileActiv.SelectedItem.Text, TBNFileTaskValue.Text);
                Page.DataBind();
            }

        }

        protected void BAddRegTask_Click(object sender, EventArgs e)
        {
            if (CBRegActiv.SelectedItem.Text != String.Empty && TBNRegTaskValue.Text != String.Empty)
            {
                BAddTask(CBRegActiv.SelectedItem.Text, TBNRegTaskValue.Text);
                Page.DataBind();
            }

        }

        protected void BAddProcTask_Click(object sender, EventArgs e)
        {
            if (CBProcActiv.SelectedItem.Text != String.Empty && TBProcTaskValue.Text != String.Empty)
            {
                BAddTask(CBProcActiv.SelectedItem.Text, TBProcTaskValue.Text);
                Page.DataBind();
            }
        }

        private TaskStruct GetSelectedTask(int p)
        {
            TaskStruct res = new TaskStruct();
            switch (p)
            {
                case 1:
                    {
                        res = GetTSFromGV(lbNetParams);
                        break;
                    }
                case 2:
                    {
                        res = GetTSFromGV(lbFSParams);
                        break;
                    }
                case 3:
                    {
                        res = GetTSFromGV(lbRegParams);
                        break;
                    }
                case 4:
                    {
                        res = GetTSFromGV(lbProcParams);
                        break;
                    }
                default:
                    {
                        return res;
                    }
            }
            return res;
        }

        private TaskStruct GetTSFromGV(ASPxGridView gridView)
        {
            TaskStruct res = new TaskStruct();
            res.Description = (string)gridView.GetRowValues(gridView.FocusedRowIndex, "f1");
            res.Value = (string)gridView.GetRowValues(gridView.FocusedRowIndex, "f2");
            Page.DataBind();
            return res;
        }

        private TaskStruct GetTSFromGV(ASPxListBox lb)
        {
            TaskStruct res = new TaskStruct();
            //res.Description = (string)gridView.GetRowValues(gridView.FocusedRowIndex, "f1");
            //res.Value = (string)gridView.GetRowValues(gridView.FocusedRowIndex, "f2");
            //Page.DataBind();
            return res;
        }

        private int DeleteTaskFromSession(TaskStruct task)
        {
            var session = Session["tasks"] as List<TaskStruct>;
            return session.RemoveAll(item => ((item.Description == task.Description)&&(item.Value==task.Value)));
        }

        protected void BDelNetTask_Click(object sender, EventArgs e)
        {
            TaskStruct task = GetSelectedTask(1);
            if (DeleteTaskFromSession(task) > 0)
            {
                //FillGridView(ASPxGridView1, 1);
                FillAllGridViews();
            }
            Page.DataBind();

        }

        protected void BDelFileTask_Click(object sender, EventArgs e)
        {
            TaskStruct task = GetSelectedTask(2);
            if (DeleteTaskFromSession(task) > 0)
            {
                FillAllGridViews(); //FillGridView(ASPxGridView2, 2);
            }
            Page.DataBind();
        }

        protected void BDelRegTask_Click(object sender, EventArgs e)
        {
            TaskStruct task = GetSelectedTask(3);
            if (DeleteTaskFromSession(task) > 0)
            {
                FillAllGridViews(); //FillGridView(ASPxGridView3, 3);
            }
            Page.DataBind();
        }

        protected void BDelProcTask_Click(object sender, EventArgs e)
        {
            TaskStruct task = GetSelectedTask(4);
            if (DeleteTaskFromSession(task) > 0)
            {
                FillAllGridViews(); //FillGridView(ASPxGridView4, 4);
            }
            Page.DataBind();
        }

        protected void cbEvent_Callback(object sender, DevExpress.Web.ASPxClasses.CallbackEventArgsBase e)
        {
            if (string.IsNullOrEmpty(e.Parameter)) return;
            cbEvent.DataSource = ReportManager.GetEventsDescrByModule(e.Parameter);
            cbEvent.DataBind();
            cbEvent.SelectedIndex = 0;
        }

        protected void RegTree_VirtualModeNodeCreating(object sender, TreeListVirtualModeNodeCreatingEventArgs e)
        {
            RegsEtl rowView = e.NodeObject as RegsEtl;
            if (rowView == null) return;
            e.NodeKeyValue = rowView.KeyIndex;
            e.SetNodeValue("KeyName", rowView.KeyName);
        }

        protected void RegTree_VirtualModeCreateChildren(object sender, TreeListVirtualModeCreateChildrenEventArgs e)
        {
            List<RegsEtl> children = null;
            RegsEtl parent = e.NodeObject as RegsEtl;
            if (parent == null)
            {
                children = TreeViewBuilder.GetRegsEtlTableViewByParentId(GetSelectedSystemId(), 0);
                if (children.Count == 0) RegTreeList.ClearNodes();
            }
            else
            {
                children = TreeViewBuilder.GetRegsEtlTableViewByParentId(GetSelectedSystemId(), (int)parent.KeyIndex);
            }
            e.Children = children;
        }

        protected void RegTreeList_FocusedNodeChanged(object sender, EventArgs e)
        {
            string nodePath = RegTreeList.FocusedNode["KeyName"].ToString();
            var currentNode = RegTreeList.FocusedNode.ParentNode;
            while (currentNode != null && currentNode.Level > 0)
            {
                nodePath = currentNode["KeyName"] +@"\" + nodePath;
                currentNode = currentNode.ParentNode;
            }
            tbEtlRegRoot.Text = nodePath;
        }

        protected void FileTree_VirtualModeNodeCreating(object sender, TreeListVirtualModeNodeCreatingEventArgs e)
        {
            FilesEtl rowView = e.NodeObject as FilesEtl;
            if (rowView == null) return;
            e.NodeKeyValue = rowView.KeyIndex;
            e.SetNodeValue("KeyName", rowView.KeyName);
        }

        protected void FileTree_VirtualModeCreateChildren(object sender, TreeListVirtualModeCreateChildrenEventArgs e)
        {
            List<FilesEtl> children = null;
            FilesEtl parent = e.NodeObject as FilesEtl;
            if (parent == null)
            {
                children = TreeViewBuilder.GetFilesEtlTableViewByParentId(GetSelectedSystemId(), 0);
                if (children.Count == 0) FileTreeList.ClearNodes();
            }
            else
            {
                children = TreeViewBuilder.GetFilesEtlTableViewByParentId(GetSelectedSystemId(), (int)parent.KeyIndex);
            }
            e.Children = children;
        }

        protected void FileTreeList_FocusedNodeChanged(object sender, EventArgs e)
        {
            string nodePath = FileTreeList.FocusedNode["KeyName"].ToString();
            var currentNode = FileTreeList.FocusedNode.ParentNode;
            while (currentNode != null && currentNode.Level > 0)
            {
                nodePath = currentNode["KeyName"] + @"\" + nodePath;
                currentNode = currentNode.ParentNode;
            }
            tbEtlFileRoot.Text = nodePath;
        }

    }//end class
}//end namespace