using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SandBox.Db
{
    public class WebTables
    {
        /// <summary>
        /// Получение внешнего вида таблицы
        /// </summary>
        /// <returns></returns>
        public static Layout GetLayout(int userid, string tablename)
        {
            var db = new SandBoxDataContext();
            Layout res = db.Layouts.FirstOrDefault(x => x.UserID == userid && x.TableName == tablename);
            return res;
        }
        /// <summary>
        /// Сохранение внешнего вида таблицы
        /// </summary>
        /// <returns></returns>
        public static void SetLayout(int userid, string tablename, string userlayout)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Layout layout = db.Layouts.FirstOrDefault(x => x.UserID == userid && x.TableName == tablename);
                if (layout == null)
                {
                    layout = new Layout { UserID = userid, TableName = tablename, UserLayout = userlayout };
                    db.Layouts.InsertOnSubmit(layout);
                }
                else layout.UserLayout = userlayout;
                db.SubmitChanges();
            }
        }
    }
}
