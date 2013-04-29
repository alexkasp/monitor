using System;
using System.Collections.Generic;
using System.Linq;

namespace SandBox.Db
{

    public class MlwrManager : DbManager
    {

        //**********************************************************
        //* Получение класса Mlwr по id
        //**********************************************************
        public static IQueryable<MlwrClass> GetClasses()
        {
            var db = new SandBoxDataContext();
            return from c in db.MlwrClasses
                   select c; 
        }

        public static MlwrClass GetClass(Int32 mlwrclid)
        {
            SandBoxDataContext db = new SandBoxDataContext();
            return db.MlwrClasses.FirstOrDefault<MlwrClass>(x => x.id == mlwrclid);
        }

        public static MlwrClass GetClass(String name)
        {
            SandBoxDataContext db = new SandBoxDataContext();
            return db.MlwrClasses.FirstOrDefault<MlwrClass>(x => x.Name == name);
        }

        public static MlwrClass GetClassByItemId(Int32 Itemid)
        {
            SandBoxDataContext db = new SandBoxDataContext();
            return (from c in db.MlwrClassItems
                    where c.id == Itemid
                   join d in db.MlwrClasses on c.MlwrClassId equals d.id
                   
                    select d).FirstOrDefault<MlwrClass>(); 
        }

        public static Int32 GetClassItemsCount(Int32 mlwrclid)
        {
            SandBoxDataContext db = new SandBoxDataContext();
            return (from c in db.MlwrClassViews
                   where c.MlwrId == mlwrclid
                   select c).Count();
        }

        public static IEnumerable<int> GetClassItemsId(Int32 mlwrclid)
        {
            var db = new SandBoxDataContext();
            return from c in db.MlwrClassItems
                   where c.MlwrClassId == mlwrclid
                   select c.id;
        }

        public static IQueryable<MlwrClassView> GetClassModuleItems(Int32 mlwrclid, string moduleDesctiption)
        {
            var db = new SandBoxDataContext();
            return from c in db.MlwrClassViews
                   where c.MlwrId == mlwrclid && c.Module == moduleDesctiption
                   select c;
        }

        public static IEnumerable<int> GetVPOClassItemsId(Int32 mlwrid)
        {
            var db = new SandBoxDataContext();
            return (from c in db.MlwrVPOClassItems
                   where c.MlwrId == mlwrid
                   select c.id).ToList();
        }

        public static void ClearVPOClassTable()
        {
            var db = new SandBoxDataContext();
            db.ExecuteCommand("TRUNCATE TABLE MlwrCl");
        }

        public static void AddVPOClass(Int32 mlwrid, Int32 mlwrclid)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                MlwrCl mlwrcl = new MlwrCl()
                {
                    MlwrId = mlwrid,
                    ClMlwrId = mlwrclid
                };
                db.MlwrCls.InsertOnSubmit(mlwrcl);
                db.SubmitChanges();
            }
        }

        public static IQueryable<MlwrClass> GetVPOClasses(Int32 mlwrid)
        {
            var db = new SandBoxDataContext();
            return from c in db.MlwrCls
                   join d in db.MlwrClasses on c.ClMlwrId equals d.id
                   where c.MlwrId == mlwrid
                   orderby d.Name
                   select d;
        }

        //**********************************************************
        //* Добавление нового класса Mlwr
        //**********************************************************
        public static Int32 AddMlwrClass(String name)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                MlwrClass mlwrcl = new MlwrClass()
                {
                    Name = name,
                    Comment = null
                };
                db.MlwrClasses.InsertOnSubmit(mlwrcl);
                db.SubmitChanges();
                return db.MlwrClasses.FirstOrDefault<MlwrClass>(x => x.Name == name).id;
            }
//            TableUpdated(Table.MLWRS);
        }

        public static void UpdateMlwrClass(Int32 mlwrclassid, String name)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                MlwrClass mlwrcl = db.MlwrClasses.FirstOrDefault(x => x.id == mlwrclassid);
                if (mlwrcl == null) return;
                mlwrcl.Name = name;
                db.SubmitChanges();
            }
            //            TableUpdated(Table.MLWRS);
        }

        public static void UpdateMlwrClass(Int32 mlwrclassid, String name, String comment)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                MlwrClass mlwrcl = db.MlwrClasses.FirstOrDefault(x => x.id == mlwrclassid);
                if (mlwrcl == null) return;
                mlwrcl.Name = name;
                mlwrcl.Comment = comment;
                db.SubmitChanges();
            }
            //            TableUpdated(Table.MLWRS);
        }

        public static void DeleteMlwrClass(Int32 mlwrclassid)
        {
            var db = new SandBoxDataContext();
            var mlwrcl = db.MlwrClasses.FirstOrDefault<MlwrClass>(x => x.id == mlwrclassid);
            if (mlwrcl != null) db.MlwrClasses.DeleteOnSubmit(mlwrcl);
            db.SubmitChanges();
        }

        public static void DeleteMlwrClassItem(Int32 itemid)
        {
            var db = new SandBoxDataContext();
            var clitem = db.MlwrClassItems.FirstOrDefault<MlwrClassItem>(x => x.id == itemid);
            if (clitem != null) db.MlwrClassItems.DeleteOnSubmit(clitem);
            db.SubmitChanges();
        }

        public static void DeleteMlwrClassItems(Int32 mlwrclassid)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var mlcltems =
                    from c in db.MlwrClassItems
                    where c.MlwrClassId == mlwrclassid
                    select c;

                foreach (var item in mlcltems)
                {
                    db.MlwrClassItems.DeleteOnSubmit(item);
                }

                try
                {
                    db.SubmitChanges();
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                }
            }
        }

        public static Int32 AddMlwrClass(String name, String comment)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                MlwrClass mlwrcl = new MlwrClass()
                {
                    Name = name,
                    Comment = comment
                };
                db.MlwrClasses.InsertOnSubmit(mlwrcl);
                db.SubmitChanges();
                return db.MlwrClasses.FirstOrDefault<MlwrClass>(x => x.Name == name).id;
            }
            //            TableUpdated(Table.MLWRS);
        }

        public static void AddMlwrClassItem(Int32 mlwrclassid, String evdesk, String evparam)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Int32 eventid = db.EventsEventDescriptions.FirstOrDefault<EventsEventDescriptions>(x => x.EventsEventDescription == evdesk).EventID;
                Int32 moduleid = db.ModulesVsEvents.FirstOrDefault<ModulesVsEvents>(x => x.Event == eventid).Module;
                MlwrClassItem mlwrclitm = new MlwrClassItem()
                {
                    MlwrClassId = mlwrclassid,
                    ModuleId = moduleid,
                    EventId = eventid,
                    Param = evparam
                };
                db.MlwrClassItems.InsertOnSubmit(mlwrclitm);
                db.SubmitChanges();
            }
            //            TableUpdated(Table.MLWRS);
        }

        public static IQueryable GetMlwrClassItems()
        {
            var db = new SandBoxDataContext();
            return from c in db.MlwrClassViews
                   select c;
        }

        public static string GetStrMlwrClassification(int mlwrId)
        {
            String res = "Не классифицировано";
            SandBoxDataContext db = new SandBoxDataContext();
          
            string prrRes = (from clmlwr in db.MlwrCls
                          join d in db.ClMlwrs on clmlwr.ClMlwrId equals d.Id
                          where clmlwr.MlwrId == mlwrId
                          select d.Description).FirstOrDefault<string>();
            if (prrRes != null)
            {
                res = prrRes;
            }
            return res;
        }

        public static MlwrReport GetNetReportById(int mlwrReportId)
        {
            SandBoxDataContext db = new SandBoxDataContext();
            return db.MlwrReport.FirstOrDefault<MlwrReport>(x => x.Id == mlwrReportId);
        }

        public static MlwrReport GetNetReport(int mlwrId)
        {
            SandBoxDataContext db = new SandBoxDataContext();
            return db.MlwrReport.FirstOrDefault<MlwrReport>(x => x.mlwrId == mlwrId);
        }

        public static IQueryable GetNetRep(int mlwrId)
        {
            SandBoxDataContext db = new SandBoxDataContext();
            return from ml in db.MlwrReport
                   where ml.mlwrId == mlwrId
                   select new { Str = ml.message };
        }

        public static List<string> GetSCByFCName(string FCName)
        {
            SandBoxDataContext db = new SandBoxDataContext();
            var sl = from sc in db.RootClassificationScheme
                     where sc.RootElementOfClassification == FCName
                     select sc.SecondaryElementOfClassification;
            List<string> res = new List<string>();
            res.AddRange(sl.ToArray());
            return res;
        }


        public static int AddMlwrFeature(int mlwrId, string fclass, string sclass, string value)
        {
            int newMlwrId = -1;
             
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var fm = from f in db.MlwrFeature
                                select f.Id;
                int ewMlwrId = fm.Max() + 1;
                MlwrFeature mlwrF = new MlwrFeature()
                {
                    Id = ewMlwrId,
                    MlwrId = mlwrId,
                    FClass = fclass,
                    SClass = sclass,
                    Value = value
                };
                db.MlwrFeature.InsertOnSubmit(mlwrF);
                db.SubmitChanges();

            }
            return newMlwrId;
 
        }


        /// <summary>
        /// Получение  всех кооментариев в ВПО по его Id
        /// </summary>
        /// <param name="MlwrID"></param>
        /// <returns></returns>
        public static IQueryable<MlwrComments> GetCommentsById(int MlwrID)
        {
            var db = new SandBoxDataContext();
            var res = from c in db.MlwrComments
                      where c.MlwrId == MlwrID
                      select c;
            return res;
        }

        public static void InsertComment(int mlwrId, string comment)
        {
            var db = new SandBoxDataContext();
            db.MlwrComments.InsertOnSubmit(new MlwrComments() { CommentValue = comment, MlwrId = mlwrId });
            db.SubmitChanges();
        }

         /// <summary>
        /// Получение записей с направлениями воздействия СПО
        /// TODO: Перенести MlwrManager
        /// </summary>
        /// <param name="MlwrID">Id СПО</param>
        /// <returns></returns>
        public static IQueryable<MlwrTargeting> GetTargetingOfMlwr(int MlwrID)
        {
            var db = new SandBoxDataContext();
            var res = from t in db.MlwrTargeting
                      where t.MlwrId == MlwrID
                      select t;
            return res;
        }


        /// <summary>
        /// Получение всех элементов Research для заданного ВПО (по Id ВПО)
        /// TODO: Перенести MlwrManager
        /// </summary>
        /// <param name="MlwrID">Id ВПО</param>
        /// <returns></returns>
        public static IQueryable GetResearchesByMlwr(int MlwrID)
        {
            var db = new SandBoxDataContext();
            var researches = from r in db.Researches
                             join v in db.Vms on r.VmId equals v.Id
                             join vmd in db.ResearchesVmDatas on r.ResearchVmData equals vmd.Id
                             where r.MlwrId == MlwrID
                             select new
                             {
                                 r.Id,
                                 vmType = v.EnvType,
                                 r.Duration,
                                 r.State,
                                 r.ResearchName,
                                 vmName = vmd.VmName
                             };
            return researches;
        }

        public static IQueryable<Research> GetRrschsByMlwr(int MlwrID)
        {
            var db = new SandBoxDataContext();
            var researches = from r in db.Researches
                             join v in db.Vms on r.VmId equals v.Id
                             join vmd in db.ResearchesVmDatas on r.ResearchVmData equals vmd.Id
                             where r.MlwrId == MlwrID
                             select r;
            return researches;
        }

        //**********************************************************
        //* Получение всех элементов Mlwr
        //**********************************************************
        public static IQueryable<Mlwr> GetMlwrs()
        {
            var db = new SandBoxDataContext();

            var mlwrs = from m in db.Mlwrs
                        where m.IsDeleted != 1
                        orderby m.Id
                      select m;
            return mlwrs;
        }

        //**********************************************************
        //* Получение Mlwr по имени
        //**********************************************************
        public static Mlwr GetMlwr(String path)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                return db.Mlwrs.FirstOrDefault(x => x.Path == path && x.IsDeleted != 1);
            }
        }

        //**********************************************************
        //* Получение Mlwr по hash
        //**********************************************************
        public static Mlwr GetMlwr(string md5, string sha1, string sha256)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                return db.Mlwrs.FirstOrDefault(x => x.md5 == md5 && x.sha1 == sha1 && x.sha256 == sha256 && x.IsDeleted != 1);
            }
        }

        //**********************************************************
        //* Получение Mlwr по id
        //**********************************************************
        public static Mlwr GetMlwr(Int32 id)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                return db.Mlwrs.FirstOrDefault(x => x.Id == id && x.IsDeleted != 1);
            }
        }

        public static Mlwr GetMlwrById(Int32 id)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                return db.Mlwrs.FirstOrDefault(x => x.Id == id && x.IsDeleted != 1);
            }
        }

        public static Mlwr GetMlwrByName(String name)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                return db.Mlwrs.FirstOrDefault(x => x.Name == name && x.IsDeleted != 1);
            }
        }

        public static void UpdateMlwr(Int32 id, String name, String mlwrcl, String comment)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Mlwr mlwr = db.Mlwrs.FirstOrDefault(x => x.Id == id);
                if (mlwr == null) return;
                mlwr.Name = name;
                mlwr.Class = mlwrcl;
                mlwr.Comment = comment;
                db.SubmitChanges();
            }
        }

        //**********************************************************
        //* Проверка существования имени файла ВПО
        //**********************************************************
        public static bool IsVPOFileExist(string filename)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                return db.Mlwrs.FirstOrDefault(x => x.Path == filename && x.IsDeleted != 1) != null;
            }
        }

        //**********************************************************
        //* Получение Mlwr для отображения
        //**********************************************************
        public static IQueryable GetMlwrsTableView()
        {
            var db = new SandBoxDataContext();

            return from m in db.MlwrsTableViews
                   select m;
        }

        /// <summary>
        /// Получение всех значений описаний из таблицы с классификацией ВПО
        /// </summary>
        /// <param name="mlwrId"></param>
        /// <returns></returns>
        //public static IQueryable GetMlwrClass(int mlwrId)
        //{ 
        //    var db = new SandBoxDataContext();
        //    var items = from m in db.Mlwrs
        //                join mc in db.MlwrClasses
        //                    on m.Class equals mc.id
        //                where m.Id == mlwrId
        //                select mc.Name;               
        //    return items;

        //}


        //**********************************************************
        //* Получение количества неудаленных Mlwr
        //**********************************************************
        public static Int32 GetMlwrsCount()
        {
            var db = new SandBoxDataContext();

            var mlwrs = from m in db.Mlwrs
                        orderby m.Id
                        where m.IsDeleted != 1
                        select m;
            return mlwrs.Count();
        }

        //**********************************************************
        //* Получение количества неудаленных неисследованных Mlwr
        //**********************************************************
        public static Int32 GetMlwrsUnresearchedCount()
        {
            var db = new SandBoxDataContext();

            var mlwrs = from m in db.Mlwrs
                        orderby m.Id
                        where m.IsDeleted != 1
                        where m.ResearchCount == 0
                        select m;
            return mlwrs.Count();
        }

        //**********************************************************
        //* Получение Path по id
        //**********************************************************
        public static String GetPath(Int32 id)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Mlwr mlwr = db.Mlwrs.FirstOrDefault(x => x.Id == id && x.IsDeleted != 1);
                return mlwr == null ? null : mlwr.Path;
            }
        }

        //**********************************************************
        //* Получение всех классов Mlwrs
        //**********************************************************
        public static List<String> GetMlwrClassList()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var classes = from mc in db.MlwrClasses
                            orderby mc.Name
                            select mc.Name;
                return classes.ToList();
            }
        }

        //**********************************************************
        //* Получение всех имен Mlwr
        //**********************************************************
        public static List<String> GetMlwrNameList()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var names = from m in db.Mlwrs
                            where m.IsDeleted != 1
                            orderby m.Name
                            select m.Name;
                return names.ToList();
            }
        }

        //**********************************************************
        //* Получение всех путей Mlwr
        //**********************************************************
        public static List<String> GetMlwrPathList()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var pathes = from m in db.Mlwrs
                             where m.IsDeleted != 1
                             orderby m.Path
                            select m.Path;
                return pathes.ToList();
            }
        }

        //**********************************************************
        //* Получение списка дополнительной информации Mlwr
        //**********************************************************
        public static List<String> GetMlwrLoadedList()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var items = from m in db.Mlwrs
                                join u in db.Users
                                    on m.LoadedBy equals u.UserId
                            where m.IsDeleted != 1
                            select new { Loaded = "Загружено " + m.LoadedDate + " пользователем " + u.Login };
                return items.Select(vr => vr.Loaded).ToList();
            }
        }

        //**********************************************************
        //* Добавление нового Mlwr
        //**********************************************************
        public static void AddMlwr(String name, String path, Int32 loadedBy, String md5, String sha1, String sha256)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Mlwr mlwr = new Mlwr()
                              {
                                  Name = name,
                                  Path = path,
                                  ResearchCount = 0,
                                  Class = null,
                                  LoadedDate = DateTime.Now,
                                  LoadedBy = loadedBy,
                                  md5 = md5,
                                  sha1 = sha1,
                                  sha256 = sha256,
                                  IsDeleted = 0
                };
                db.Mlwrs.InsertOnSubmit(mlwr);
                db.SubmitChanges();
            }
            TableUpdated(Table.MLWRS);
        }

        //**********************************************************
        //* Отметка Mlwr по имени как удаленного
        //**********************************************************
        public static void DeleteMlwr(String name)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var mlwr =  db.Mlwrs.FirstOrDefault(x => x.Name == name);
                if (mlwr == null) return;
                mlwr.IsDeleted = 1;
                db.SubmitChanges();
            }
        }

        //**********************************************************
        //* Отметка Mlwr по id как удаленного
        //**********************************************************
        public static void DeleteMlwr(Int32 id)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var mlwr = db.Mlwrs.FirstOrDefault(x => x.Id == id);
                if (mlwr == null) return;
                mlwr.IsDeleted = 1;
                db.SubmitChanges();
            }
        }


    }//end class MlwrManager
}//end namespace
