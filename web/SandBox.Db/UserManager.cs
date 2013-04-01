using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Web.Security;
using System.Net;
using System.Web;

namespace SandBox.Db
{
    public class UserManager : DbManager 
    {
        //**********************************************************
        //* Добавление новой роли
        //**********************************************************
        public static void AddRole(String rolename)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Role role = new Role { Name = rolename };
                db.Roles.InsertOnSubmit(role);
                db.SubmitChanges();
            }
        }

        //**********************************************************
        //* Удаление роли
        //**********************************************************
        public static void DeleteRole(String rolename)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Role role = db.Roles.FirstOrDefault(r => r.Name == rolename);
                if (role == null) return;
                db.Roles.DeleteOnSubmit(role);
                db.SubmitChanges();
            }
        }

        //**********************************************************
        //* Получение списка ролей
        //**********************************************************
        public static List<String> GetRoleList()
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var roles = from r in db.Roles
                            orderby r.RoleId
                            select r.Name;
                return roles.ToList();
            }
        }

        //**********************************************************
        //* Получение роли
        //**********************************************************
        public static Role GetRole(String name)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                Role role = db.Roles.FirstOrDefault(x => x.Name == name);
                return role;
            }
        }

        //**********************************************************
        //* Получение списка ролей для пользователя
        //**********************************************************
        public static List<String> GetRolesForUser(String username)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                User user = db.Users.FirstOrDefault(x => x.Login == username);
                return user == null ? null : user.UsersInRole.Roles.Select(x => x.Name).ToList();
            }
        }

        //**********************************************************
        //* Получение списка ролей для пользователя
        //**********************************************************
        public static List<String> GetRolesForUser(Int32 userid)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                User user = db.Users.FirstOrDefault(x => x.UserId == userid);
                return user == null ? null : user.UsersInRole.Roles.Select(x => x.Name).ToList();
            }
        }

        //**********************************************************
        //* Создание соли
        //**********************************************************
        private static String CreateSalt()
        {
            RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
            byte[] buff = new byte[32];
            rng.GetBytes(buff);
            return Convert.ToBase64String(buff);
        }

        //**********************************************************
        //* Создание хеша пароля
        //**********************************************************
        private static String CreatePasswordHash(String pwd, String salt)
        {
            String saltAndPwd = String.Concat(pwd, salt);
            String hashedPwd = FormsAuthentication.HashPasswordForStoringInConfigFile(saltAndPwd, "md5");
            return hashedPwd;
        }

        //**********************************************************
        //* Получение пользователя по имени
        //**********************************************************
        public static MembershipUser GetUser(String login)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                User dbuser = db.Users.FirstOrDefault(x => x.Login == login);
                if (dbuser == null) return null;
                return new MembershipUser("CustomMembershipProvider",
                                                         dbuser.Login,
                                                         dbuser.UserId,
                                                         String.Empty,
                                                         String.Empty,
                                                         String.Empty,
                                                         true,
                                                         false,
                                                         dbuser.CreatedDate,
                                                         DateTime.Now,
                                                         DateTime.Now,
                                                         DateTime.Now,
                                                         DateTime.Now);
            }
        }

        //**********************************************************
        //* Получение пользователя по id
        //**********************************************************
        public static MembershipUser GetUser(Int32 userId)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                User dbuser = db.Users.FirstOrDefault(x => x.UserId == userId);
                if (dbuser == null) return null;
                return new MembershipUser("CustomMembershipProvider",
                                                         dbuser.Login,
                                                         dbuser.UserId,
                                                         String.Empty,
                                                         String.Empty,
                                                         String.Empty,
                                                         true,
                                                         false,
                                                         dbuser.CreatedDate,
                                                         DateTime.Now,
                                                         DateTime.Now,
                                                         DateTime.Now,
                                                         DateTime.Now);
            }
        }

        //**********************************************************
        //* Получение пользователя по id
        //**********************************************************
        public static User GetdbUser(Int32 userId)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                User dbuser = db.Users.FirstOrDefault(x => x.UserId == userId);
                if (dbuser == null) return null;
                return dbuser;
            }
        }

        //**********************************************************
        //* Получение пользователя по логину
        //**********************************************************
        public static User GetdbUser(String login)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                User dbuser = db.Users.FirstOrDefault(x => x.Login == login);
                if (dbuser == null) return null;
                return dbuser;
            }
        }

        //**********************************************************
        //* Получение полного имени пользователя по id
        //**********************************************************
        public static string GetUserFullName(Int32 userId)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                User dbuser = db.Users.FirstOrDefault(x => x.UserId == userId);
                if (dbuser == null) return null;
                return dbuser.UserName;
            }
        }

        //**********************************************************
        //* Получение полного имени пользователя по логину
        //**********************************************************
        public static string GetUserFullName(string login)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                User dbuser = db.Users.FirstOrDefault(x => x.Login == login);
                if (dbuser == null) return null;
                return dbuser.UserName;
            }
        }

        //**********************************************************
        //* Получение всех пользователей
        //**********************************************************
        public static IQueryable<User> GetUsers()
        {
            var db = new SandBoxDataContext();

            var users = from u in db.Users
                        orderby u.UserId
                        select u;
            return users;
        }

        //**********************************************************
        //* Получение всех пользователей для отображения
        //**********************************************************
        public static IQueryable GetUsersTableView()
        {
            var db = new SandBoxDataContext();

            var users = from u in db.Users
                        join ur in db.UsersInRoles
                          on u.UserId equals ur.UserId
                        join r in db.Roles
                          on ur.RoleId equals r.RoleId
                        orderby u.UserId
                        select new { u.UserId, u.UserName, u.Login, u.CreatedDate, u.LastLoginDate, r.Name };
            return users;
        }

        //**********************************************************
        //* Проверка пользователя
        //**********************************************************
        public static Boolean ValidateUser(String login, String password)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var dbuser = db.Users.FirstOrDefault(x => x.Login == login);
                return dbuser != null && dbuser.Password == CreatePasswordHash(password, dbuser.PasswordSalt);
            }
        }

        //**********************************************************
        //* Получения ip-адреса пользователя
        //**********************************************************
        private static string GetUserIP()
        {
            string ipList = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (!string.IsNullOrEmpty(ipList))
            {
                return ipList.Split(',')[0];
            }

            return System.Web.HttpContext.Current.Request.UserHostAddress;
        }

        //**********************************************************
        //* Запись времени входа и ip-адреса пользователя
        //**********************************************************
        public static void LoginLog(String login)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                User dbuser = db.Users.FirstOrDefault(x => x.Login == login);
                dbuser.LastLoginDate = DateTime.Now;
                dbuser.LastLoginIp = GetUserIP();
                db.SubmitChanges();
            }
        }

        //**********************************************************
        //* Удаление пользователя
        //**********************************************************
        public static void DeleteUser(Int32 id)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var user = db.Users.FirstOrDefault(x => x.UserId == id);
                if (user == null) return;

                db.UsersInRoles.DeleteOnSubmit(user.UsersInRole);
                db.SubmitChanges();

                db.Users.DeleteOnSubmit(user);
                db.SubmitChanges();
            }
        }

        //**********************************************************
        //* Удаление пользователя
        //**********************************************************
        public static void DeleteUser(String username)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var user = db.Users.FirstOrDefault(x => x.Login == username);
                if (user == null) return;

                db.UsersInRoles.DeleteOnSubmit(user.UsersInRole);
                db.SubmitChanges();

                db.Users.DeleteOnSubmit(user);
                db.SubmitChanges();
            }
        }

        //**********************************************************
        //* Создание пользователя
        //**********************************************************
        public static MembershipUser CreateUser(String username, String login, String password, Int32 roleId)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                var users = UserManager.GetUsers();
                if (Enumerable.Any(users, us => us.Login == login)) return null;
                
                User user = new User
                {
                    Login = login,
                    UserName = username,
                    Password = password,
                    PasswordSalt = CreateSalt(),
                    CreatedDate = DateTime.Now,
//                    LastLoginDate = DateTime.Now
                };
                user.Password = CreatePasswordHash(password, user.PasswordSalt);
                db.Users.InsertOnSubmit(user);
                db.SubmitChanges();

                var usr = db.Users.FirstOrDefault(x => x.Login == login);
                if (usr == null) return null;

                UsersInRole userInRole = new UsersInRole {UserId = usr.UserId, RoleId = roleId};
                db.UsersInRoles.InsertOnSubmit(userInRole);
                db.SubmitChanges();

                return GetUser(login);
            }
        }

        //**********************************************************
        //* Изменение пользователя
        //**********************************************************
        public static void EditUser(Int32 userid, String username, String login, String password, Int32 roleId)
        {
            using (SandBoxDataContext db = new SandBoxDataContext())
            {
                User user = db.Users.FirstOrDefault(x => x.UserId == userid);
                if (user == null) return;
                user.Login = login;
                user.UserName = username;
                if (password!=String.Empty)
                {
                    user.PasswordSalt = CreateSalt();
                    user.Password = CreatePasswordHash(password, user.PasswordSalt);
                }
                UsersInRole role = db.UsersInRoles.FirstOrDefault(x => x.UserId == user.UserId);
                db.UsersInRoles.DeleteOnSubmit(user.UsersInRole);
                UsersInRole userInRole = new UsersInRole { UserId = user.UserId, RoleId = roleId };
                db.UsersInRoles.InsertOnSubmit(userInRole);
                db.SubmitChanges();
            }
        }

    }//end UserManager class 
}
