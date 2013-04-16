using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SandBox.Db;
using System.Web.UI.WebControls;

namespace SandBox.WebUi
{
    public class CommonTreeItem
    {
        public long ParentID = -1;
        public long ID = -1;
        public string Text = String.Empty;
        public bool IsInTree = false;
        public string ParentText = String.Empty;
    }

    public class RegTreeViewItem
    {
        public long ID { get; set; }
        public long ParentID { get; set; }
        public string Text { get; set; }
        public string Value { get; set; }
    }

    public class RegCompareTreeViewItem : RegTreeViewItem
    {
        public bool inEtl { get; set; }
        public bool inRsch { get; set; }
    }

    public class RegCompareTreeItem 
    {
        public long ID { get; set; }
        public long ParentID { get; set; }
        public string Text { get; set; }
        public bool IsKey { get; set; }
        public long EtlID { get; set; }
        public long RegID { get; set; }
        public string EtlValue { get; set; }
        public string RegValue { get; set; }
    }

    public class RegCompareTreeItem2 : RegCompareTreeItem
    {
        public long RegID2 { get; set; }
        public string RegValue2 { get; set; }
    }

    class TreeViewBuilder
    {
        public static List<RegTreeViewItem> GetRegsEtlList(Int32 systemId)
        {
            var db = new SandBoxDataContext();
            return (from r in db.RegsEtls
                    where r.SystemID == systemId
                    select new RegTreeViewItem { ID = r.KeyIndex, ParentID = r.Parent, Text = r.KeyName, Value = r.keyvalue }).ToList();
        }

        public static List<RegsEtl> GetRegsEtlTableViewByRootstr(Int32 systemId, String rootstr)
        {
            var db = new SandBoxDataContext();
            int level = 0;
            long parentId = 0;
            foreach (string subPath in rootstr.Split('\\'))
            {
                parentId = level == 0 ? db.RegsEtls.FirstOrDefault<RegsEtl>(x => (x.SystemID == systemId) && (x.KeyName == subPath)).Parent:
                                        db.RegsEtls.FirstOrDefault<RegsEtl>(x => (x.SystemID == systemId) && (x.KeyName == subPath) && (x.Parent == parentId)).Parent;
                level++;
            }
            return (from r in db.RegsEtls
                    where r.SystemID == systemId && r.Parent == parentId
                    select r).ToList();
        }

        public static List<RegCompareTreeItem> GetRegsCompTableView(Int32 id, long parentid, Int32 systemId, long etlparentId, Int32 rschId, long rschparentId)
        {
            var db = new SandBoxDataContext();
            List<RegsEtl> etllst = (from r in db.RegsEtls
                                    where r.SystemID == systemId && r.Parent == etlparentId
                                    select r).ToList();
            List<Reg> reglst = (from r in db.Regs
                                where r.RschID == rschId && r.Parent == rschparentId
                                select r).ToList();
            List<RegCompareTreeItem> complist = new List<RegCompareTreeItem>();
            foreach (RegsEtl item in etllst)
            {
                Reg ritem = reglst.Find(p => p.KeyName == item.KeyName);
                if (ritem != null)
                {
                    complist.Add(new RegCompareTreeItem { ID = id, ParentID = parentid, Text = item.KeyName, IsKey = item.keytype == 1, EtlID = item.KeyIndex, EtlValue = item.keyvalue, RegID = ritem.KeyIndex, RegValue = ritem.keyvalue});
                    reglst.Remove(ritem);
                }
                else complist.Add(new RegCompareTreeItem { ID = id, ParentID = parentid, Text = item.KeyName, IsKey = item.keytype == 1, EtlID = item.KeyIndex, EtlValue = item.keyvalue, RegID = -1, RegValue = "" });
                id++;
            }
            foreach (Reg item in reglst)
            {
                complist.Add(new RegCompareTreeItem { ID = id, ParentID = parentid, Text = item.KeyName, IsKey = item.keytype == 1, EtlID = -1, EtlValue = "", RegID = item.KeyIndex, RegValue = item.keyvalue });
                id++;
            }
            return complist;
        }

        public static List<RegCompareTreeItem2> GetRegsCompTableView2(Int32 id, long eltrootid, long rschrootid, long rschrootid2, Int32 systemId, long etlparentId, Int32 rschId, long rschparentId, Int32 rschId2, long rschparentId2)
        {
            var db = new SandBoxDataContext();
            List<RegsEtl> etllst = (from r in db.RegsEtls
                                    where r.SystemID == systemId && r.Parent == etlparentId
                                    select r).ToList();
            List<Reg> reglst = new List<Reg>();
            if (rschrootid == etlparentId || rschparentId > -1)
            {
                if (rschparentId == -1) rschparentId = 0;
                reglst = (from r in db.Regs
                          where r.RschID == rschId && r.Parent == rschparentId
                          select r).ToList();
            }
            List<Reg> reglst2 = new List<Reg>();
            if (rschrootid2 == etlparentId || rschparentId2 > -1)
            {
                if (rschparentId2 == -1) rschparentId2 = 0;
                reglst2 = (from r in db.Regs
                           where r.RschID == rschId2 && r.Parent == rschparentId2
                           select r).ToList();
            }
            List<RegCompareTreeItem2> complist = new List<RegCompareTreeItem2>();
            foreach (RegsEtl item in etllst)
            {
                Reg ritem = reglst.Find(p => p.KeyName == item.KeyName);
                Reg ritem2 = reglst2.Find(p => p.KeyName == item.KeyName);
                if (ritem != null && ritem2 != null)
                {
                    complist.Add(new RegCompareTreeItem2 { ID = id, ParentID = eltrootid, Text = item.KeyName, IsKey = item.keytype == 1, EtlID = item.KeyIndex, EtlValue = item.keyvalue, RegID = ritem.KeyIndex, RegValue = ritem.keyvalue, RegID2 = ritem2.KeyIndex, RegValue2 = ritem2.keyvalue });
                    reglst.Remove(ritem);
                    reglst2.Remove(ritem2);
                }
                else if (ritem != null)
                {
                    complist.Add(new RegCompareTreeItem2 { ID = id, ParentID = eltrootid, Text = item.KeyName, IsKey = item.keytype == 1, EtlID = item.KeyIndex, EtlValue = item.keyvalue, RegID = ritem.KeyIndex, RegValue = ritem.keyvalue, RegID2 = -1, RegValue2 = "" });
                    reglst.Remove(ritem);
                }
                else if (ritem2 != null)
                {
                    complist.Add(new RegCompareTreeItem2 { ID = id, ParentID = eltrootid, Text = item.KeyName, IsKey = item.keytype == 1, EtlID = item.KeyIndex, EtlValue = item.keyvalue, RegID = -1, RegValue = "", RegID2 = ritem2.KeyIndex, RegValue2 = ritem2.keyvalue });
                    reglst2.Remove(ritem2);
                }
                else complist.Add(new RegCompareTreeItem2 { ID = id, ParentID = eltrootid, Text = item.KeyName, IsKey = item.keytype == 1, EtlID = item.KeyIndex, EtlValue = item.keyvalue, RegID = -1, RegValue = "", RegID2 = -1, RegValue2 = "" });
                id++;
            }
            foreach (Reg item in reglst)
            {
                Reg ritem2 = reglst2.Find(p => p.KeyName == item.KeyName);
                if (ritem2 != null)
                {
                    complist.Add(new RegCompareTreeItem2 { ID = id, ParentID = eltrootid, Text = item.KeyName, IsKey = item.keytype == 1, EtlID = -1, EtlValue = "", RegID = item.KeyIndex, RegValue = item.keyvalue, RegID2 = ritem2.KeyIndex, RegValue2 = ritem2.keyvalue });
                    reglst2.Remove(ritem2);
                }
                else complist.Add(new RegCompareTreeItem2 { ID = id, ParentID = eltrootid, Text = item.KeyName, IsKey = item.keytype == 1, EtlID = -1, EtlValue = "", RegID = item.KeyIndex, RegValue = item.keyvalue, RegID2 = -1, RegValue2 = "" });
                id++;
            }
            foreach (Reg item2 in reglst2)
            {
                Reg ritem = reglst.Find(p => p.KeyName == item2.KeyName);
                if (ritem != null)
                {
                    complist.Add(new RegCompareTreeItem2 { ID = id, ParentID = eltrootid, Text = item2.KeyName, IsKey = item2.keytype == 1, EtlID = -1, EtlValue = "", RegID2 = item2.KeyIndex, RegValue2 = item2.keyvalue, RegID = ritem.KeyIndex, RegValue = ritem.keyvalue });
                    reglst.Remove(ritem);
                }
                else complist.Add(new RegCompareTreeItem2 { ID = id, ParentID = eltrootid, Text = item2.KeyName, IsKey = item2.keytype == 1, EtlID = -1, EtlValue = "", RegID2 = item2.KeyIndex, RegValue2 = item2.keyvalue, RegID = -1, RegValue = "" });
                id++;
            }
            return complist;
        }

        public static long GetRegsEtlRowIdByRootstr(Int32 systemId, String rootstr)
        {
            if (String.IsNullOrEmpty(rootstr)) return 0;
            var db = new SandBoxDataContext();
            int level = 0;
            long parentId = 0;
            foreach (string subPath in rootstr.Split('\\'))
            {
                parentId = level == 0 ? db.RegsEtls.FirstOrDefault<RegsEtl>(x => (x.SystemID == systemId) && (x.KeyName == subPath)).KeyIndex :
                                        db.RegsEtls.FirstOrDefault<RegsEtl>(x => (x.SystemID == systemId) && (x.KeyName == subPath) && (x.Parent == parentId)).KeyIndex;
                level++;
            }
            return parentId;
        }

        public static long GetRegsEtlRowIdByRootstr2(Int32 systemId, String rootstr, String rootstr2)
        {
            if (String.IsNullOrEmpty(rootstr) && String.IsNullOrEmpty(rootstr2)) return 0;
            var db = new SandBoxDataContext();
            int level = 0;
            long parentId = 0;
            string[] root1 = rootstr.Split('\\');
            string[] root2 = rootstr2.Split('\\');
            int len = root1.Length > root2.Length ? root2.Length : root1.Length;
            for (int i = 0; i < len; i++)
            {
                if (root1[i] == root2[i])
                {
                    parentId = level == 0 ? db.RegsEtls.FirstOrDefault<RegsEtl>(x => (x.SystemID == systemId) && (x.KeyName == root1[i])).KeyIndex :
                                            db.RegsEtls.FirstOrDefault<RegsEtl>(x => (x.SystemID == systemId) && (x.KeyName == root1[i]) && (x.Parent == parentId)).KeyIndex;
                    level++;
                }
                else break;
            }
            return parentId; 
        }

        public static List<long> GetRegsRootIDs(Int32 systemId, String rootstr)
        {
            List<long> parentId = new List<long>();
            if (String.IsNullOrEmpty(rootstr)) return parentId;
            var db = new SandBoxDataContext();
            int level = 0;
            foreach (string subPath in rootstr.Split('\\'))
            {
                parentId.Add(level == 0 ? db.RegsEtls.FirstOrDefault<RegsEtl>(x => (x.SystemID == systemId) && (x.KeyName == subPath)).KeyIndex :
                                        db.RegsEtls.FirstOrDefault<RegsEtl>(x => (x.SystemID == systemId) && (x.KeyName == subPath) && (x.Parent == parentId[level-1])).KeyIndex);
                level++;
            }

            return parentId;
        }

        public static List<RegTreeViewItem> GetRegsRschList(Int32 rschId)
        {
            var db = new SandBoxDataContext();
            return (from r in db.Regs
                    where r.RschID == rschId
                    select new RegTreeViewItem { ID = r.KeyIndex, ParentID = r.Parent, Text = r.KeyName, Value = r.keyvalue }).ToList();
        }

        private static TreeNode PopulateRegTreeView(TreeNode treeNode, List<RegTreeViewItem> treeViewList, long parentId)
        {
            TreeNode childNode;
            var filteredItems = treeViewList.Where(item => item.ParentID == parentId);

            foreach (var i in filteredItems.ToList())
            {
                childNode = new TreeNode(i.Text);
                childNode = PopulateRegTreeView(childNode, treeViewList, i.ID);
                treeNode.ChildNodes.Add(childNode);
            }

            return treeNode;
        }

        private static long GetRootNodeId(List<RegTreeViewItem> treeViewList, string rootstr)
        {
            int level = 0;
            long parentId = 0;
            string nodeText = "";
            RegTreeViewItem chitem;
            foreach (string subPath in rootstr.Split('\\'))
            {
                chitem = level == 0 ? treeViewList.Find(p => p.Text == subPath) :
                                      treeViewList.Find(p => p.Text == subPath && p.ParentID == parentId);
                if (chitem != null)
                {
                    nodeText = chitem.Text;
                    parentId = chitem.ID;
                }
                else
                {
                    parentId = 0;
                    break;
                }
                level++;
            }
            return parentId;
            //if (parentId == 0) return null;
            //else
            //{
            //    TreeNode resNode = new TreeNode(nodeText);
            //    return PopulateRegTreeView(resNode, treeViewList, parentId);
            //}
        }

        public static List<RegCompareTreeViewItem> CompareRegTree(Int32 researchId, Int32 systemId)
        {
            List<RegTreeViewItem> EtlRegList = GetRegsEtlList(systemId);
            List<RegTreeViewItem> RschRegList = GetRegsRschList(researchId);
            string RschRegRoot = TaskManager.GetRegRootForRsch(researchId);
            string RegRoot = "";
            switch (RschRegRoot[0]) {
                case '1':
                    RegRoot = @"HKEY_CLASSES_ROOT";
                    break;
                case '2':
                    RegRoot = @"HKEY_CURRENT_USER";
                    break;
                case '3':
                    RegRoot = @"HKEY_LOCAL_MACHINE";
                    break;
                case '4':
                    RegRoot = @"HKEY_USERS";
                    break;
                case '5':
                    RegRoot = @"HKEY_CURRENT_CONFIG";
                    break;
            }
            if (RschRegRoot.Length > 1) RschRegRoot = RegRoot + RschRegRoot.Substring(1);
            else RschRegRoot = RegRoot;
//            TreeNode EtlTreeNode = GetRootNodeId(EtlRegList, RschRegRoot);
            return null;
        }

        public static IQueryable<Reg> GetRegsTableView(Int32 researchId)
        {
            var db = new SandBoxDataContext();
            return from r in db.Regs
                       where r.RschID == researchId
                       select r;
        }

        public static IQueryable<Procs> GetProcsTableView(Int32 researchId)
        {
            var db = new SandBoxDataContext();
            return from r in db.Procs
                   where r.RschId == researchId
                   select r;
        }

        public static IQueryable<ProcessLifeView> GetResearchProcesses(int rschId)
        {
            var db = new SandBoxDataContext();
            return from prc in db.ProcessLifeViews
                   where prc.rschId == rschId
                   select prc;
        }

        public static List<RegsEtl> GetRegsEtlTableViewByParentId(Int32 systemId, Int32 parentId)
        {
            var db = new SandBoxDataContext();
            return (from r in db.RegsEtls
                    where r.SystemID == systemId && r.Parent == parentId
                    select r).ToList();
        }

        public static IQueryable<Reg> GetKeyValues(int parentid)
        {
            var db = new SandBoxDataContext();
            return from r in db.Regs
                   where r.Parent == parentid && r.keytype == 1
                   select r;
        }

        public static List<Reg> GetRegsTableViewByParentId(Int32 researchId, Int32 parentId)
        {
            var db = new SandBoxDataContext();
            return (from r in db.Regs
                   where r.RschID == researchId && r.Parent == parentId
                   select r).ToList();
        }

        public static List<FilesEtl> GetFilesEtlTableViewByParentId(Int32 systemId, Int32 parentId)
        {
            var db = new SandBoxDataContext();
            return (from r in db.FilesEtls
                    where r.SystemID == systemId && r.Parent == parentId
                    select r).ToList();
        }

        public static List<Files> GetFilesTableViewByParentId(Int32 researchId, Int32 parentId)
        {
            var db = new SandBoxDataContext();
            return (from r in db.Files
                    where r.RschId == researchId && r.parent == parentId
                    orderby r.IsDir descending, r.Name
                    select r).ToList();
        }

        public static List<Procs> GetProcTableViewByParentId(Int32 researchId, Int32 parentId)
        {
            var db = new SandBoxDataContext();
            return (from r in db.Procs
                    where r.RschId == researchId && r.Pid2 == parentId
                    select r).ToList();
        }

        //pid2 идентификатор родительского процесса
        public List<CommonTreeItem> GetCommonTreeItemsFromProcs(int rschId)
        {
            List<CommonTreeItem> res = new List<CommonTreeItem>();
            var rProcs = ReportManager.GetRowProcesses(rschId);
            foreach (var p in rProcs)
            {
                var item = new CommonTreeItem() 
                {
                    ID = p.Pid1,
                    ParentID = p.Pid2!=null? (int)p.Pid2: -1,
                    Text = String.Format("{0} (pid={1}; число потоков={2})", p.Name, p.Pid1,p.Count)
                };
                res.Add(item);
            }
            return res;
        }

        public List<CommonTreeItem> GetCommonTreeItemsFromRegs(int rschId)
        {
            List<CommonTreeItem> res = new List<CommonTreeItem>();
            var rRegs = ReportManager.GetRowRegs(rschId);
            foreach (var r in rRegs)
            {
                var item = new CommonTreeItem()
                {
                    ID = r.KeyIndex,
                    ParentID = r.Parent != null ? (int)r.Parent : -1,
                    Text = String.Format("{0} (Индекс ключа={1})",r.KeyName, r.KeyIndex)
                };
                res.Add(item);
            }
            return res;
        }

        public List<CommonTreeItem> GetRawCommonTreeItemsFromRegs(int rschId)
        {
            List<CommonTreeItem> res = new List<CommonTreeItem>();
            var rRegs = ReportManager.GetRowRegs(rschId);
            foreach (var r in rRegs)
            {
                var item = new CommonTreeItem()
                {
                    ID = r.KeyIndex,
                    ParentID = r.Parent != null ? (int)r.Parent : -1,
                    Text = r.KeyName
                };
                res.Add(item);
            }
            return res;
        }

        public List<CommonTreeItem> GetRootElements(List<CommonTreeItem> commonTreeItems)
        {
            List<CommonTreeItem> res = new List<CommonTreeItem>();
            foreach (var item in commonTreeItems)
            {
                bool isRoot = true;
                foreach (var itm in commonTreeItems)
                {
                    if (itm.ID == item.ParentID && (item.Text!=itm.Text && item.ID!=itm.ID)) { isRoot = false; break; }
                }
                if (isRoot) res.Add(item);
            }
            return res;
        }

        public void TreeListViewGenerator(TreeView tv, List<CommonTreeItem> commonTreeItems, List<CommonTreeItem> rootItems, string header = "Дерево процессов")
        {
            tv.Nodes.AddAt(0, new TreeNode(header));
            for(int j=0; j<rootItems.Count(); j++)
            {
                tv.Nodes[0].ChildNodes.Add(new TreeNode(rootItems[j].Text));
                for (int k = 0; k < commonTreeItems.Count; k++ )
                {
                    if (commonTreeItems[k].ID == rootItems[j].ID) { commonTreeItems[k].IsInTree = true; }
                }
            }
            while (!IsReady(commonTreeItems))
            {
                foreach (var item in commonTreeItems)
                {
                    if (!item.IsInTree)
                    {
                        if (item.ParentText == String.Empty)
                        {
                            foreach (var it in commonTreeItems)
                            {
                                if (item.ParentID == it.ID)
                                {
                                    item.ParentText = it.Text;
                                }
                            }
                        }
                        ObxodDereva(tv.Nodes[0], item);
                    }
                }
            }
        }

        
        public void TreeListNodeGenerator(TreeNode tn, List<CommonTreeItem> commonTreeItems, List<CommonTreeItem> rootItems)
        {
           
            for (int j = 0; j < rootItems.Count(); j++)
            {
                tn.ChildNodes.Add(new TreeNode(rootItems[j].Text));
                for (int k = 0; k < commonTreeItems.Count; k++)
                {
                    if (commonTreeItems[k].ID == rootItems[j].ID) { commonTreeItems[k].IsInTree = true; }
                }
            }
            while (!IsReady(commonTreeItems))
            {
                foreach (var item in commonTreeItems)
                {
                    if (!item.IsInTree)
                    {
                        if (item.ParentText == String.Empty)
                        {
                            foreach (var it in commonTreeItems)
                            {
                                if (item.ParentID == it.ID)
                                {
                                    item.ParentText = it.Text;
                                }
                            }
                        }
                        ObxodDereva(tn, item);
                    }
                }
            }
        }    
        
        
        
        private bool IsReady(List<CommonTreeItem> commonTreeItems)
        {
            foreach (var item in commonTreeItems)
            {
                if (!item.IsInTree) return false;
            }
            return true;
        }

        private void ObxodDereva(TreeNode a, CommonTreeItem item)
        {
            
            if (a.Text == item.ParentText)
            {
                a.ChildNodes.Add(new TreeNode(item.Text));
                item.IsInTree = true;
                return;
            }
            if (a.ChildNodes.Count>0)//a.ChildNodes != null) //дочерние элементы есть
            {
                foreach (TreeNode childNode in a.ChildNodes) //не зацикливаеться ли от родителя к 1 ребенку и обратно?
                {
                    a = childNode; //посетить ребенка
                    ObxodDereva(a, item);
                }
            }
        }
    }
}
