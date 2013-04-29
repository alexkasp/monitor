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

            if (!IsPostBack)
            {
                IQueryable vlirList = IsUserInRole("Administrator") ? VmManager.GetVLIRReadyForResearch() : VmManager.GetVLIRReadyForResearch(UserId);
                cbEtln.DataSource = VmManager.GetEtlnReadyForResearch();
                cbEtln.DataBind();
                cbEtln.SelectedIndex = 0;
                cbVLIR.DataSource = vlirList;
                cbVLIR.DataBind();
                if (cbVLIR.Items.Count > 0) cbVLIR.SelectedIndex = 0;
                else rbVLIR.ClientEnabled = false;
                cbLIR.DataSource = VmManager.GetLIRReadyForResearch();
                cbLIR.DataBind();
                if (cbLIR.Items.Count > 0) cbLIR.SelectedIndex = 0;
                else rbLIR.ClientEnabled = false;
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
                int researchId = 0;
                Int32.TryParse(Request.QueryString["copyfrom"], out researchId);
//                researchId = Convert.ToInt32(Request.QueryString["copyfrom"]);
                if (researchId > 0)
                {
                    Session["researchId"] = researchId;
                    FillListBoxDB(hfFS, "Файловая система");
                    FillListBoxDB(hfReg, "Реестр");
                    FillListBoxDB(hfProc, "Процессы");
                    FillListBoxDB(hfNet, "Сеть");
                    Mlwr mlwrrec = ResearchManager.GetMlwrByRschId(researchId);
                    if (mlwrrec != null) cbMalware.Text = mlwrrec.Name;
                    Vm vmach = ResearchManager.GetRschVm(researchId);
                    ListEditItem le;
                    if (vmach != null)
                    {
                        switch (vmach.Type) {
                            case 2:
                                if (vmach.EnvType == 0 || cbVLIR.Items.Count==0) 
                                {
                                    Vm etlmach = VmManager.GetVmsEtalonBySystem(vmach.System);
                                    if (etlmach != null)
                                    {
                                        le = cbEtln.Items.FindByValue(etlmach.Id);
                                        if (le!=null) cbEtln.SelectedIndex = le.Index;
                                    }
                                }
                                else 
                                {
                                    le = cbVLIR.Items.FindByText(vmach.Name);
                                    if (le != null)
                                    {
                                        rbEtln.Checked = false;
                                        rbVLIR.Checked = true;
                                        cbEtln.ClientEnabled = false;
                                        cbVLIR.ClientEnabled = true;
                                        cbLIR.ClientEnabled = false;
                                        cbVLIR.SelectedIndex = le.Index;
                                    }
                                    else
                                    {
                                        Vm etlmach = VmManager.GetVmsEtalonBySystem(vmach.System);
                                        if (etlmach != null) 
                                        {
                                            le = cbEtln.Items.FindByValue(etlmach.Id);
                                            if (le != null) cbEtln.SelectedIndex = le.Index;
                                        }
                                    }
                                }
                            
                                break;
                            case 3:
                                if (cbLIR.Items.Count > 0)
                                {
                                    rbEtln.Checked = false;
                                    rbLIR.Checked = true;
                                    cbEtln.ClientEnabled = false;
                                    cbVLIR.ClientEnabled = false;
                                    cbLIR.ClientEnabled = true;
                                    le = cbLIR.Items.FindByText(vmach.Name);
                                    if (le != null) cbLIR.SelectedIndex = le.Index;
                                }
                                else 
                                {
                                    rbEtln.Checked = true;
                                    Vm etlmach = VmManager.GetVmsEtalonBySystem(vmach.System);
                                    if (etlmach != null) 
                                    {
                                        le = cbEtln.Items.FindByValue(etlmach.Id);
                                        if (le != null) cbEtln.SelectedIndex = le.Index;
                                    }
                                }
                                break;
                        }
                    }
                    Db.Research Rs = ResearchManager.GetResearch(researchId);           
                    if (Rs != null)
                    {
                        if (Rs.Duration>0) spinTime.Value = Rs.Duration;
                        else
                        {
                            cbTimeEnd.Checked = false;
                            spinTime.ClientEnabled = false;
                        }
                    }
                    StopEvents se = ResearchManager.GetStopEvent(researchId);
                    if (se != null)
                    {
                        cbEventEnd.Checked = true;
                        int moduleid = ReportManager.GetModuleIdByEventId(se.@event);
                        string module = ReportManager.GetModuleById(moduleid);
                        cbModule.ClientEnabled = true;
                        cbEvent.ClientEnabled = true;
                        tbWho.ClientEnabled = true;
                        tbDest.ClientEnabled = true;
                        cbModule.Value = module;
                        cbEvent.DataSource = ReportManager.GetEventsDescrByModule(module);
                        cbEvent.DataBind();
                        cbEvent.Text = ReportManager.GetEventById(se.@event);
                        tbWho.Text = se.who;
                        tbDest.Text = se.dest;
                    }
                    Task ts;
                    ts = TaskManager.GetFileTasksForRsch(researchId);
                    if (ts != null)
                    {
                        cbFileRoot.Checked = true;
                        tbFileRoot.ClientEnabled = true;
                        btnSelFile.ClientEnabled = true;
                        tbFileRoot.Text = ts.Value;
                    }
                    ts = TaskManager.GetFileSigTasksForRsch(researchId);
                    if (ts != null)
                    {
                        cbSignature.Checked = true;
                        tbSignature.ClientEnabled = true;
                        tbSignature.Text = ts.Value;
                    }
                    ts = TaskManager.GetFileExtTasksForRsch(researchId);
                    if (ts != null)
                    {
                        cbExtension.Checked = true;
                        tbExtension.ClientEnabled = true;
                        tbExtension.Text = ts.Value;
                    }

                    ts = TaskManager.GetRegTasksForRsch(researchId);
                    if (ts != null)
                    {
                        cbRegRoot.Checked = true;
                        tbRegRoot.ClientEnabled = true;
                        cmbRegRoot.ClientEnabled = true;
                        btnSelReg.ClientEnabled = true;
                        switch (ts.Value[0])
                        {
                            case '0':
                                cmbRegRoot.Text = "Весь реестр";
                                break;
                            case '1':
                                cmbRegRoot.Text = "HKEY_CLASSES_ROOT";
                                break;
                            case '2':
                                cmbRegRoot.Text = "HKEY_CURRENT_USER";
                                break;
                            case '3':
                                cmbRegRoot.Text = "HKEY_LOCAL_MACHINE";
                                break;
                            case '4':
                                cmbRegRoot.Text = "HKEY_USERS";
                                break;
                            case '5':
                                cmbRegRoot.Text = "HKEY_CURRENT_CONFIG";
                                break;
                        }
                        if (ts.Value.Length > 1) tbRegRoot.Text = ts.Value.Substring(1);
                    }
                    ts = TaskManager.GetFileProcMonTasksForRsch(researchId);
                    if (ts != null) cbProcMon.Checked = true;
                    Commands cm = TaskManager.GetEmulTasksForRsch(researchId);
                    if (cm != null)
                    {
                        cbEnul.Checked = true;
                        tbEmulCommand.ClientEnabled = true;
                        tbEmulParams.ClientEnabled = true;
                        spEmulTime.ClientEnabled = true;
                        tbEmulCommand.Text = cm.Command;
                        tbEmulParams.Text = cm.CommandParams;
                        spEmulTime.Value = cm.CommandStartTime;
                    }
                }
            }
            else
            {
                FillListBox(hfFS, lbFSParams);
                FillListBox(hfReg, lbRegParams);
                FillListBox(hfProc, lbProcParams);
                FillListBox(hfNet, lbNetParams);
            }
        }

        protected void FillListBoxDB(DevExpress.Web.ASPxHiddenField.ASPxHiddenField hf, string module)
        {
            List<TaskList> moditems = TaskManager.GetTasksViewForRschByModule((int)Session["researchId"], module);
            if (moditems.Count() > 0)
            {
                object[] itemCollection = new object[moditems.Count()];
                int i = 0;
                foreach (TaskList item in moditems)
                {
                    itemCollection[i] = item.TypeX + ";" + item.ValueX;
                    i++;
                }
                hf["LoadDataList"] = itemCollection;
            }
        }

        protected void FillListBox(DevExpress.Web.ASPxHiddenField.ASPxHiddenField hf, ASPxListBox lb)
        {
            if (lb.Items.Count > 0)
            {
                object[] itemCollection = new object[lb.Items.Count];
                int i = 0;
                foreach (ListEditItem item in lb.Items)
                {
                    itemCollection[i] = item.GetValue("Task").ToString() + ";" + item.GetValue("Param").ToString();
                    i++;
                }
                hf["LoadDataList"] = itemCollection;
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
            Int32 timeLeft = 0;
            if (cbTimeEnd.Checked) timeLeft = Convert.ToInt32(spinTime.Value);
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

            if (cbEventEnd.Checked)
            {
                Int32 evt = Convert.ToInt32(cbEvent.Value);
                int module = ReportManager.GetModuleIdByEventId(evt);
                string dest = tbDest.Text;
                string who = tbWho.Text;
                    ResearchManager.InsertStopEvent(researchId, module, evt, dest, who);

            }

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
            if (cbSignature.Checked) TaskManager.AddTask(researchId, 5, tbSignature.Text);
            if (cbExtension.Checked) TaskManager.AddTask(researchId, 6, tbExtension.Text);
            if (cbFileRoot.Checked) TaskManager.AddTask(researchId, 16, tbFileRoot.Text);
            if (cbRegRoot.Checked) TaskManager.AddTask(researchId, 17, String.Format("{0}{1}", cmbRegRoot.SelectedIndex, tbRegRoot.Text));
            if (cbProcMon.Checked) TaskManager.AddTask(researchId, 15, "ON");
            foreach (ListEditItem item in lbFSParams.Items) TaskManager.AddTask(researchId, TaskManager.GetTaskTypeByDescription(item.GetValue("Task").ToString()), item.GetValue("Param").ToString());
            foreach (ListEditItem item in lbRegParams.Items) TaskManager.AddTask(researchId, TaskManager.GetTaskTypeByDescription(item.GetValue("Task").ToString()), item.GetValue("Param").ToString());
            foreach (ListEditItem item in lbProcParams.Items) TaskManager.AddTask(researchId, TaskManager.GetTaskTypeByDescription(item.GetValue("Task").ToString()), item.GetValue("Param").ToString());
            foreach (ListEditItem item in lbNetParams.Items) TaskManager.AddTask(researchId, TaskManager.GetTaskTypeByDescription(item.GetValue("Task").ToString()), item.GetValue("Param").ToString());
            
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
            return res;
        }

        private int DeleteTaskFromSession(TaskStruct task)
        {
            var session = Session["tasks"] as List<TaskStruct>;
            return session.RemoveAll(item => ((item.Description == task.Description)&&(item.Value==task.Value)));
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
            if (RegTreeList.FocusedNode != null)
            {
                string nodePath = RegTreeList.FocusedNode["KeyName"].ToString();
                var currentNode = RegTreeList.FocusedNode.ParentNode;
                while (currentNode != null && currentNode.Level > 0)
                {
                    nodePath = currentNode["KeyName"] + @"\" + nodePath;
                    currentNode = currentNode.ParentNode;
                }
                tbEtlRegRoot.Text = nodePath;
            }
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
            if (FileTreeList.FocusedNode != null)
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
        }

    }//end class
}//end namespace