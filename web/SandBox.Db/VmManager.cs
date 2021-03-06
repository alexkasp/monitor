﻿using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace SandBox.Db
{
    public class VmManager : DbManager
    {
        public enum LIRType : int
        {
            ETALON = 1,
            VLIR = 2,
            LIR = 3
        }

        public enum State
        {
            UPDATING = 1,
            STOPPED = 2,
            STARTED = 3,
            STOPPING = 4,
            STARTING = 5,
            UNAVAILABLE = 6,
            ERROR = 7,
            RESEARCHING = 8,
            DELETED = 9
        }

        public static Dictionary<string, List<int>> GetOsChart()
        {
            Dictionary<string, List<int>> res = new Dictionary<string, List<int>>();
            var db = new SandBoxDataContext();
            var preRes = from t in db.vpotoos
                         join vd in db.ResearchesVmDatas on t.name equals vd.VmName
                         join os in db.VmSystems on vd.VmSystem equals os.System
                         select new { Name = t.name, OS = os.ShortDest };
            var preRes2 = from t in db.vpotoos
                          select t;
            foreach (var test in preRes)
            {
                string name = test.GetType().GetProperty("Name").GetValue(test, null) as string;
                string os = test.GetType().GetProperty("OS").GetValue(test, null) as string;
                if (name != null && os != null)
                {
                    foreach (var t in preRes2)
                    {
                        if (t.name == name)
                        {
                            if (res.ContainsKey(os))
                            {
                                res[os][0]++;
                                res[os][1] += t.danger ?? 0;
                            }
                            else
                            {
                                res.Add(os, new List<int> { 1, t.danger ?? 0 });
                            }
                        }
                    }
                }
            }
            var test2 = res.OrderByDescending(x => x.Value[1]);
            return test2.ToDictionary(x => x.Key, x => x.Value);
        }

        public static stats GetFullStats()
        {
            var db = new SandBoxDataContext();
            var res = db.stats.FirstOrDefault<stats>(x => true);
            return res;
        }

        public static string GetCpuInfo()
        {
            var db = new SandBoxDataContext();
            var res = db.stats.FirstOrDefault<stats>(x => true);
            return String.Format("CPU:{0}%", res.cpu);
        }

        public static string GetCpuInfo2()
        {
            var db = new SandBoxDataContext();
            var res = db.stats.FirstOrDefault<stats>(x => true);
            return String.Format("{0}%", res.cpu);
        }

        public static string GetMemImfo()
        {
            var db = new SandBoxDataContext();
            var res = db.stats.FirstOrDefault<stats>(x => true);
            UInt64 parsedMem = 0;
            UInt64.TryParse(res.meminfo, out parsedMem);
            double rowMem = parsedMem / 1024;
            parsedMem = (ulong)Math.Round(rowMem);
            return String.Format("ОЗУ:{0}МБ", parsedMem);
        }

        public static string GetMemImfo2()
        {
            var db = new SandBoxDataContext();
            var res = db.stats.FirstOrDefault<stats>(x => true);
            UInt64 parsedMem = 0;
            UInt64.TryParse(res.meminfo, out parsedMem);
            double rowMem = parsedMem / 1024;
            parsedMem = (ulong)Math.Round(rowMem);
            return String.Format("{0}Mb", parsedMem);
        }

        //**********************************************************
        //* Получение всех элементов Vm
        //**********************************************************
        public static IQueryable<Vm> GetVms()
        {
            var db = new SandBoxDataContext();

            var vms = from v in db.Vms
                      orderby v.Id
                      select v;
            return vms;


        }

        /// <summary>
        /// Получение числа ЛИРов для соответствующих типов. 
        /// </summary>
        /// <returns></returns>
        public static Dictionary<string, int> GetVmCountForeachType()
        {
            var db = new SandBoxDataContext();
            var res = new Dictionary<string, int>();
            var items = from v in db.Vms
                        //join vs in db.VmStates
                        //    on v.State equals vs.State
                        join vt in db.VmTypes
                            on v.Type equals vt.Type
                        //join vst in db.VmSystems
                        //    on v.System equals vst.System
                        select new { v.Id, Type = vt.Description };
            foreach (var item in items)
            {
                if (res.Keys.Contains(item.Type))
                {
                    res[item.Type]++;
                }
                else
                {
                    res.Add(item.Type, 1);
                }
            }
            return res;
        }


        //**********************************************************
        //* Получение всех элементов Vm для userId
        //**********************************************************
        public static IQueryable<Vm> GetVms(Int32 userId)
        {
            var db = new SandBoxDataContext();

            var vms = from v in db.Vms
                      where v.CreatedBy == userId
                      orderby v.Id
                      select v;
            return vms;
        }

        //**********************************************************
        //* Получение Vm по имени
        //**********************************************************
        public static Vm GetVm(String name)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                return db.Vms.FirstOrDefault(x => x.Name == name);
            }
        }

        //**********************************************************
        //* Получение Vm по id
        //**********************************************************
        public static Vm GetVm(Int32 id)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                return db.Vms.FirstOrDefault(x => x.Id == id);
            }
        }

        //**********************************************************
        //* Получение Vm по id
        //**********************************************************
        public static Vm GetVmByEnvId(Int32 envId)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                return db.Vms.FirstOrDefault(x => x.EnvId == envId);
            }
        }

        //**********************************************************
        //* Получение Vm по mac
        //**********************************************************
        public static Vm GetVmByMac(String mac)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                return db.Vms.FirstOrDefault(x => x.EnvMac == mac);
            }
        }

        //**********************************************************
        //* Получение количества Vm для отображения
        //**********************************************************
        public static Int32 GetVmsTableViewCount(bool ShowEtalon = false, bool ShowTemp = false)
        {
            var db = new SandBoxDataContext();
            if (!ShowEtalon && !ShowTemp)
            {
                return (from v in db.Vms
                        where v.Type == 2 || v.Type == 3
                        where v.EnvType != 0 && v.State != (int)VmManager.State.DELETED
                        select v).Count();
            }
            else if (ShowEtalon && !ShowTemp)
            {
                return (from v in db.Vms
                        where v.EnvType != 0 && v.State != (int)VmManager.State.DELETED
                        select v).Count();
            }
            else if (!ShowEtalon && ShowTemp)
            {
                return (from v in db.Vms
                        where v.Type == 2 || v.Type == 3
                        where v.State != (int)VmManager.State.DELETED
                        select v).Count();
            }
            else
            {
                return (from v in db.Vms
                        where v.State != (int)VmManager.State.DELETED
                        select v).Count();
            }
        }

        //**********************************************************
        //* Получение количества Vm для отображения для пользователя c Id
        //**********************************************************
        public static Int32 GetVmsTableViewCount(Int32 userId)
        {
            var db = new SandBoxDataContext();

            var itemsForUser = from v in db.Vms
                               where ((v.CreatedBy == userId && v.Type == 2) || v.Type == 3) && v.State != (int)VmManager.State.DELETED
                               select v;
            return itemsForUser.Count();
        }

        //**********************************************************
        //* Получение Vm для отображения
        //**********************************************************
        public static IQueryable GetVmsTableView(bool ShowEtalon = false, bool ShowTemp = false)
        {
            var db = new SandBoxDataContext();
            if (!ShowEtalon && !ShowTemp)
            {
                return from v in db.Vms
                       join vs in db.VmStates
                           on v.State equals vs.State
                       join vt in db.VmTypes
                           on v.Type equals vt.Type
                       join vst in db.VmSystems
                           on v.System equals vst.System
                       where v.Type == 2 || v.Type == 3
                       where v.EnvType != 0 && v.State != (int)VmManager.State.DELETED
                       select new { v.Id, v.Name, State = vs.Description, Type = vt.Description, System = vst.Description, v.EnvType, EnvState = v.EnvId == 0 ? "не готова" : "готова", EnvMac = v.EnvMac == "null" ? "не определен" : v.EnvMac, EnvIp = v.EnvIp == "null" ? "не определен" : v.EnvIp };
            }
            else if (ShowEtalon && !ShowTemp)
            {
                return from v in db.Vms
                       join vs in db.VmStates
                           on v.State equals vs.State
                       join vt in db.VmTypes
                           on v.Type equals vt.Type
                       join vst in db.VmSystems
                           on v.System equals vst.System
                       where v.EnvType != 0 && v.State != (int)VmManager.State.DELETED
                       select new { v.Id, v.Name, State = vs.Description, Type = vt.Description, System = vst.Description, v.EnvType, EnvState = v.EnvId == 0 ? "не готова" : "готова", EnvMac = v.EnvMac == "null" ? "не определен" : v.EnvMac, EnvIp = v.EnvIp == "null" ? "не определен" : v.EnvIp };
            }
            else if (!ShowEtalon && ShowTemp)
            {
                return from v in db.Vms
                       join vs in db.VmStates
                           on v.State equals vs.State
                       join vt in db.VmTypes
                           on v.Type equals vt.Type
                       join vst in db.VmSystems
                           on v.System equals vst.System
                       where v.Type == 2 || v.Type == 3
                       where v.State != (int)VmManager.State.DELETED
                       select new { v.Id, v.Name, State = vs.Description, Type = vt.Description, System = vst.Description, v.EnvType, EnvState = v.EnvId == 0 ? "не готова" : "готова", EnvMac = v.EnvMac == "null" ? "не определен" : v.EnvMac, EnvIp = v.EnvIp == "null" ? "не определен" : v.EnvIp };
            }
            else
            {
                return from v in db.Vms
                       join vs in db.VmStates
                           on v.State equals vs.State
                       join vt in db.VmTypes
                           on v.Type equals vt.Type
                       join vst in db.VmSystems
                           on v.System equals vst.System
                       where v.State != (int)VmManager.State.DELETED
                       select new { v.Id, v.Name, State = vs.Description, Type = vt.Description, System = vst.Description, v.EnvType, EnvState = v.EnvId == 0 ? "не готова" : "готова", EnvMac = v.EnvMac == "null" ? "не определен" : v.EnvMac, EnvIp = v.EnvIp == "null" ? "не определен" : v.EnvIp };
            }
        }

        //**********************************************************
        //* Получение Vm для отображения для пользователя c Id
        //**********************************************************
        public static IQueryable GetVmsTableView(Int32 userId)
        {
            var db = new SandBoxDataContext();
            var itemsForUser = from v in db.Vms
                               join vs in db.VmStates
                                   on v.State equals vs.State
                               join vt in db.VmTypes
                                   on v.Type equals vt.Type
                               join vst in db.VmSystems
                                   on v.System equals vst.System
                               where ((v.CreatedBy == userId && v.Type == 2) || v.Type == 3) && v.State != (int)VmManager.State.DELETED
                               select new { v.Id, v.Name, State = vs.Description, Type = vt.Description, System = vst.Description, v.EnvType, EnvState = v.EnvId == 0 ? "не готова" : "готова", EnvMac = v.EnvMac == "null" ? "не определен" : v.EnvMac, EnvIp = v.EnvIp == "null" ? "не определен" : v.EnvIp };
            return itemsForUser;
        }

        //**********************************************************
        //* Получение всех имен Vm
        //**********************************************************
        public static List<String> GetVmNameList()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var names = from v in db.Vms
                            where v.State != (int)VmManager.State.DELETED
                            orderby v.Name
                            select v.Name;
                return names.ToList();
            }
        }
        public static List<String> GetLIRNameList()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var names = from v in db.Vms
                            where v.Type == 3 && v.State != (int)VmManager.State.DELETED
                            orderby v.Name
                            select v.Name;
                return names.ToList();
            }
        }
        public static List<String> GetVmMACList()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var macs = from v in db.Vms
                           where v.State != (int)VmManager.State.DELETED
                           orderby v.EnvMac
                           select v.EnvMac;
                return macs.ToList();
            }
        }

        public static IQueryable GetEtlnReadyForResearch()
        {
            var db = new SandBoxDataContext();
            var names = from v in db.Vms
                        join vst in db.VmSystems
                        on v.System equals vst.System
                        orderby v.Name
                        where v.Type == 1
                        where v.State != Convert.ToInt32(VmManager.State.DELETED)
                        select new { v.Id, v.Name, System = vst.Description };
            return names;
        }

        public static IQueryable GetLIRReadyForResearch()
        {
            var db = new SandBoxDataContext();
            var names = from v in db.Vms
                        join vst in db.VmSystems
                        on v.System equals vst.System
                        orderby v.Name
                        where v.Type == 3
                        where v.State == Convert.ToInt32(VmManager.State.STARTED)
                        select new { v.Id, v.Name, System = vst.Description };
            return names;
        }

        public static IQueryable GetVLIRReadyForResearch()
        {
            var db = new SandBoxDataContext();
            var names = from v in db.Vms
                        join vst in db.VmSystems
                        on v.System equals vst.System
                        orderby v.Name
                        where v.Type == 2
                        where v.EnvType != 0
                        where v.State != Convert.ToInt32(VmManager.State.RESEARCHING)
                        where v.State != Convert.ToInt32(VmManager.State.DELETED)
                        where v.State != Convert.ToInt32(VmManager.State.ERROR)
                        where v.State != Convert.ToInt32(VmManager.State.UNAVAILABLE)
                        select new { v.Id, v.Name, System = vst.Description };
            return names;
        }
        public static IQueryable GetVLIRReadyForResearch(Int32 userId)
        {
            var db = new SandBoxDataContext();
            var names = from v in db.Vms
                        join vst in db.VmSystems
                        on v.System equals vst.System
                        orderby v.Name
                        where v.Type == 2
                        where v.EnvType != 0
                        where v.State != Convert.ToInt32(VmManager.State.RESEARCHING)
                        where v.State != Convert.ToInt32(VmManager.State.DELETED)
                        where v.State != Convert.ToInt32(VmManager.State.ERROR)
                        where v.State != Convert.ToInt32(VmManager.State.UNAVAILABLE)
                        where v.CreatedBy == userId
                        select new { v.Id, v.Name, System = vst.Description };
            return names;
        }

        //**********************************************************
        //* Получение всех имен Vm
        //**********************************************************
        public static List<String> GetVmNameList(Int32 userId)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var names = from v in db.Vms
                            orderby v.Name
                            where v.CreatedBy == userId && v.State != (int)VmManager.State.DELETED
                            select v.Name;
                return names.ToList();
            }
        }

        //**********************************************************
        //* Получение всех имен Vm, готовых для исследования
        //**********************************************************
        public static List<String> GetVmReadyNameList()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var names = from v in db.Vms
                            orderby v.Name
                            where v.EnvId != 0
                            select v.Name;
                return names.ToList();
            }
        }

        //**********************************************************
        //* Получение всех имен Vm, готовых для исследования
        //**********************************************************
        public static List<String> GetVmReadyNameList(Int32 userId)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var names = from v in db.Vms
                            orderby v.Name
                            where v.CreatedBy == userId
                            where v.EnvId != 0
                            select v.Name;
                return names.ToList();
            }
        }

        //**********************************************************
        //* Получение эталонных Vm для отображения
        //**********************************************************
        public static List<String> GetVmsEtalonList()
        {
            var db = new SandBoxDataContext();

            var items = from v in db.Vms
                        join vs in db.VmStates
                            on v.State equals vs.State
                        join vt in db.VmTypes
                            on v.Type equals vt.Type
                        join vst in db.VmSystems
                            on v.System equals vst.System
                        where v.Type == 1 && v.State != (int)VmManager.State.DELETED
                        select new { Etalon = v.Name + ", " + vst.Description };
            return items.Select(vr => vr.Etalon).ToList();
        }

        public static IQueryable<Vm> GetAllEtalonVmst()
        {
            var db = new SandBoxDataContext();
            return from v in db.Vms
                   where v.Type == 1 && v.State != (int)VmManager.State.DELETED
                   select v;
        }

        //**********************************************************
        //* Получение эталонной Vm по id системы
        //**********************************************************
        public static Vm GetVmsEtalonBySystem(Int32 system)
        {
            var db = new SandBoxDataContext();

            return (from v in db.Vms
                    where v.Type == 1
                    select v).FirstOrDefault<Vm>(x => x.System == system);
        }

        //**********************************************************
        //* Получение эталонных Vm для отображения
        //**********************************************************
        public static Vm GetVmsEtalonByNumber(Int32 number)
        {
            var db = new SandBoxDataContext();

            var items = from v in db.Vms
                        where v.Type == 1
                        select v;
            return items.ToList()[number];
        }

        //**********************************************************
        //* Получение имени Vm по id
        //**********************************************************
        public static String GetVmName(Int32 id)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var vm = db.Vms.FirstOrDefault(x => x.Id == id);
                if (vm == null) return null;
                return vm.Name;
            }
        }

        //**********************************************************
        //* Получение названий всех типов Vm
        //**********************************************************
        public static List<String> GetVmTypeDescriptionList()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var types = from t in db.VmTypes
                            orderby t.Description
                            select t.Description;
                return types.ToList();
            }
        }

        //**********************************************************
        //* Получение системы Vm по описанию
        //**********************************************************
        public static VmSystem GetSystem(String description)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                return db.VmSystems.FirstOrDefault(x => x.Description == description);
            }
        }

        //**********************************************************
        //* Получение названий всех систем Vm
        //**********************************************************
        public static List<String> GetVmSystemDescriptionList()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var systems = from s in db.VmSystems
                              orderby s.Description
                              select s.Description;
                return systems.ToList();
            }
        }

        //**********************************************************
        //* Получение названий всех состояний Vm
        //**********************************************************
        public static List<String> GetVmTypeStateList()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var states = from s in db.VmStates
                             orderby s.Description
                             select s.Description;
                return states.ToList();
            }
        }

        //**********************************************************
        //* Получение списка свободных EnvId
        //**********************************************************
        public static List<Int32> GetFreeEnvTypes()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var envTypes = from d in db.Vms
                               select new { EnvType = (Int32)d.EnvType };

                var envTypesDist = envTypes.Select(dr => dr.EnvType).Distinct().ToList();
                var nums = new List<Int32> { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 };

                return nums.Except(envTypesDist).ToList();
            }
        }

        //**********************************************************
        //* Добавление новой системы Vm
        //**********************************************************
        public static void AddSystem(String description)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Int32 maxSystem = (from s in db.VmSystems orderby s.System select s.System).Max();
                VmSystem vmSystem = new VmSystem { System = maxSystem + 1, Description = description };
                db.VmSystems.InsertOnSubmit(vmSystem);
                db.SubmitChanges();
            }
        }

        //**********************************************************
        //* Добавление нового типа Vm
        //**********************************************************
        public static void AddType(String description)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Int32 maxType = (from t in db.VmTypes orderby t.Type select t.Type).Max();
                VmType vmType = new VmType { Type = maxType + 1, Description = description };
                db.VmTypes.InsertOnSubmit(vmType);
                db.SubmitChanges();
            }
        }

        //**********************************************************
        //* Добавление нового состояния Vm
        //**********************************************************
        public static void AddState(String description)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Int32 maxState = (from s in db.VmStates orderby s.State select s.State).Max();
                VmState vmState = new VmState { State = maxState + 1, Description = description };
                db.VmStates.InsertOnSubmit(vmState);
                db.SubmitChanges();
            }
        }

        //**********************************************************
        //* Добавление новой Vm
        //**********************************************************
        public static void AddVm(String name, Int32 type, Int32 system, Int32 userId, Int32 envType, VmManager.State state = VmManager.State.UPDATING, String description = "null", string envMac = "null")
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Vm vm = new Vm
                {
                    Name = name,
                    Type = type,
                    System = system,
                    State = Convert.ToInt32(state),
                    CreatedBy = userId,
                    CreatedDate = DateTime.Now,
                    EnvId = 0,
                    EnvType = envType,
                    EnvMac = envMac,
                    EnvIp = "null",
                    Description = description
                };

                db.Vms.InsertOnSubmit(vm);
                db.SubmitChanges();
            }
            //TableUpdated(Table.VMS);
        }

        //**********************************************************
        //* Обновление состояния Vm по имени
        //**********************************************************
        public static void UpdateVmState(String vmname, Int32 state)
        {
            try
            {
                using (SandBoxDataContext db = new SandBoxDataContext())
                {
                    Vm vm = db.Vms.FirstOrDefault(m => m.Name == vmname);
                    if (vm == null) return;
                    vm.State = state;
                    db.SubmitChanges();
                }
                TableUpdated(Table.VMS);
            }
            catch (Exception)
            {
                Debug.Print("exx");
            }

        }

        //**********************************************************
        //* Обновление состояния Vm по id
        //**********************************************************
        public static void UpdateVmState(Int32 vmid, Int32 state)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Vm vm = db.Vms.FirstOrDefault(m => m.Id == vmid);
                if (vm == null) return;
                vm.State = state;
                db.SubmitChanges();
            }
            TableUpdated(Table.VMS);
        }

        //**********************************************************
        //* Обновление EnvId Vm по имени
        //**********************************************************
        public static void UpdateVmEnvId(String vmName, Int32 envId)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Vm vm = db.Vms.FirstOrDefault(m => m.Name == vmName);
                if (vm == null) return;
                vm.EnvId = envId;
                db.SubmitChanges();
            }
            TableUpdated(Table.VMS);
        }

        //**********************************************************
        //* Обновление EnvMac
        //**********************************************************
        public static void UpdateVmEnvMac(Int32 vmId, String envMac)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Vm vm = db.Vms.FirstOrDefault(m => m.Id == vmId);
                if (vm == null) return;
                vm.EnvMac = envMac;
                db.SubmitChanges();
            }
            //TableUpdated(Table.VMS);
        }

        //**********************************************************
        //* Обновление EnvData
        //**********************************************************
        public static void UpdateEnvData(Int32 vmId, Int32 envId, String envIp)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Vm vm = db.Vms.FirstOrDefault(m => m.Id == vmId);
                if (vm == null) return;
                vm.EnvId = envId;
                vm.EnvIp = envIp;
                db.SubmitChanges();
            }
            //TableUpdated(Table.VMS);
        }

        //**********************************************************
        //* Сброс EnvData
        //**********************************************************
        public static void ResetEnvData(Int32 envId)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Vm vm = db.Vms.FirstOrDefault(m => m.EnvId == envId);
                if (vm == null) return;
                vm.EnvId = 0;
                vm.EnvIp = "null";
                //vm.EnvMac = "null";
                db.SubmitChanges();
            }
            //TableUpdated(Table.VMS);
        }

        //**********************************************************
        //* Удаление Vm по id
        //**********************************************************
        public static void DeleteVm(Int32 id)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Vm vm = db.Vms.FirstOrDefault(x => x.Id == id);
                if (vm == null) return;
                vm.State = Convert.ToInt32(VmManager.State.DELETED);
                db.SubmitChanges();
            }
        }

        //**********************************************************
        //* Удаление Vm по имени
        //**********************************************************
        public static void DeleteVm(String vmname)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Vm vm = db.Vms.FirstOrDefault(x => x.Name == vmname);
                if (vm == null) return;
                db.Vms.DeleteOnSubmit(vm);
                db.SubmitChanges();
            }
        }



    }//end class VmManager
}//end namespace
