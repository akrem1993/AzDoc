using LogHelpers;
using Renci.SshNet;
using Renci.SshNet.Common;
using Renci.SshNet.Sftp;
using System;
using System.Configuration;
using System.IO;
using System.Net.NetworkInformation;
using System.Web.Configuration;

namespace DocFileHelper.SFTP
{
    public static class SFTPHelper
    {
        public static readonly string FileServerPath;
        public static readonly string EdocServerPath;
        public static string GetFilePath() => $"{DateTime.Now.Year}/{1}/{DateTime.Now.Month}/{DateTime.Now.Day}";

        //Birin yerine organization id olmalidir Sessiya olmadigina gore bura oturulmur SessionHelper.OrganizationId
        public static SFTPUser SFTPUser { get; set; }

        static SFTPHelper()
        {
            Configuration rootWebConfig1 = WebConfigurationManager.OpenWebConfiguration("/");

            if (rootWebConfig1.AppSettings.Settings.Count > 0)
            {
                KeyValueConfigurationElement host = rootWebConfig1.AppSettings.Settings["SFTPHost"];
                KeyValueConfigurationElement userName = rootWebConfig1.AppSettings.Settings["SFTPUserName"];
                KeyValueConfigurationElement password = rootWebConfig1.AppSettings.Settings["SFTPPassword"];
                KeyValueConfigurationElement port = rootWebConfig1.AppSettings.Settings["SFTPPort"];

                FileServerPath= rootWebConfig1.AppSettings.Settings["FileServerPath"].Value;
                EdocServerPath = rootWebConfig1.AppSettings.Settings["EdocServerPath"].Value;

                SFTPUser = new SFTPUser()
                {
                    UserName = userName.Value,
                    Password = password.Value,
                    Host = host.Value,
                    Port = Convert.ToInt32(port.Value)
                };
            }
        }

        /// <summary>
        /// Faylın sftp-yə yazılması
        /// </summary>
        /// <param name="workingdirectory">Faylın sftp-də hansı kataloqa yazılaçağı yol</param>
        /// <param name="fileLocalPath">Yazılacaq faylın cari yolu</param>
        /// <param name="fileName">Faylın sftp-də hansı adla yazılacağı ad</param>
        /// <returns></returns>
        public static void UploadLocalTempFile(string fileLocalPath, string fileName)
        {
            try
            {
                //Fayl oxunur
                using(FileStream fs = File.OpenRead(fileLocalPath))
                {
                    //Sftp client hazırlanır
                    using(var client = new SftpClient(SFTPUser.Host, SFTPUser.Port, SFTPUser.UserName, SFTPUser.Password))
                    {
                        //Sftp-yə qoşulur
                        client.OperationTimeout = new TimeSpan(0, 10, 0);
                        client.Connect();
                        //Faylın sft-də hansı qovluğa yazılacağı yol hazırlanır: (Helper.FileServerPath: DMS_FILE/)/ (workingdirectory:2018/1/4/9)
                        string path = string.Concat(FileServerPath, '/' + GetFilePath());
                        //Faylın yazılacağı kataloqlar yoxdursa yaradılır
                        client.CreateDirectoryRecursively(path);

                        client.BufferSize = 4 * 1024;
                        //Fayı sft-yə yazılır
                        client.UploadFile(fs, string.Concat(path, '/', fileName), null);
                        client.Disconnect();
                        //Fayl müvəqqəti qovluqdan silinir
                    }
                }
                File.Delete(fileLocalPath);
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, ex.Source, "UploadFile");
                throw;
            }
        }

        /// <summary>
        /// Edoc Faylın sftp-yə yazılması
        /// </summary>
        /// <param name="fileLocalPath">Yazılacaq faylın cari yolu</param>
        /// <param name="fileName">Faylın sftp-də hansı adla yazılacağı ad</param>
        /// <returns></returns>
        public static void UploadEDocTempFile(string fileLocalPath, string fileName)
        {
            try
            {
                using(FileStream fs = File.OpenRead(fileLocalPath)) //Fayl oxunur
                {
                    using(var client = new SftpClient(SFTPUser.Host, SFTPUser.Port, SFTPUser.UserName, SFTPUser.Password)) //Sftp client hazırlanır
                    {
                        client.OperationTimeout = new TimeSpan(0, 10, 0); //Sftp-yə qoşulur
                        client.Connect();
                        string path = string.Concat(EdocServerPath, '/' + GetFilePath());//Faylın sft-də hansı qovluğa yazılacağı yol hazırlanır: (Helper.FileServerPath: DMS_FILE/)/ (workingdirectory:2018/1/4/9)
                        client.CreateDirectoryRecursively(path); //Faylın yazılacağı kataloqlar yoxdursa yaradılır

                        client.BufferSize = 4 * 1024;
                        client.UploadFile(fs, string.Concat(path, '/', fileName), null); //Fayı sft-yə yazılır
                        client.Disconnect();
                    }
                }
                File.Delete(fileLocalPath);//Fayl müvəqqəti qovluqdan silinir
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, ex.Source, "UploadFile");
                throw;
            }
        }

        /// <summary>
        /// Faylın sftp-yə yazılması
        /// </summary>
        /// <param name="workingdirectory">Faylın sftp-də hansı kataloqa yazılaçağı yol</param>
        /// <param name="filePath">Yazılacaq faylın cari yolu</param>
        /// <param name="fileName">Faylın sftp-də hansı adla yazılacağı ad</param>
        /// <returns></returns>
        public static void UploadFile(string fileName, byte[] buffer)
        {
            try
            {
                using(var client = new SftpClient(SFTPUser.Host, SFTPUser.Port, SFTPUser.UserName,
                    SFTPUser.Password))
                {
                    client.OperationTimeout = new TimeSpan(0, 10, 0);
                    client.Connect();

                    string path = string.Concat(FileServerPath, '/', GetFilePath());
                    client.CreateDirectoryRecursively(path);

                    client.BufferSize = 4 * 1024;

                    client.WriteAllBytes(path + "/" + fileName, buffer);
                    client.Disconnect();
                }
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, ex.Source, "UploadFile");
                throw;
            }
        }

        public static void DeleteFile(string fileFullName)
        {
            try
            {
                //Sftp client hazırlanır
                using(var client = new SftpClient(SFTPUser.Host, SFTPUser.Port, SFTPUser.UserName, SFTPUser.Password))
                {
                    //Sftp-yə qoşulur
                    client.Connect();

                    client.DeleteFile(fileFullName);
                    client.Disconnect();
                }
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, ex.Source, "DeleteFile");
                throw ex;
            }
        }

        public static void CreateDirectoryRecursively(this SftpClient client, string path)
        {
            string current = "";

            if(path[0] == '/')
            {
                path = path.Substring(1);
            }

            while(!string.IsNullOrEmpty(path))
            {
                int p = path.IndexOf('/');
                current += '/';
                if(p >= 0)
                {
                    current += path.Substring(0, p);
                    path = path.Substring(p + 1);
                }
                else
                {
                    current += path;
                    path = "";
                }

                try
                {
                    SftpFileAttributes attrs = client.GetAttributes(current);
                    if(!attrs.IsDirectory)
                    {
                        throw new Exception("not directory");
                    }
                }
                catch(SftpPathNotFoundException)
                {
                    client.CreateDirectory(current);
                }
            }
        }

        public static bool DownloadToLocal(string pathRemoteFile, string pathLocalFile)
        {
            try
            {
                using(var client = new SftpClient(SFTPUser.Host, SFTPUser.Port, SFTPUser.UserName, SFTPUser.Password))
                {
                    client.Connect();

                    using(Stream fileStream = File.OpenWrite(pathLocalFile))
                    {
                        client.DownloadFile(pathRemoteFile, fileStream);
                    }

                    client.Disconnect();
                    return true;
                }
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, ex.Source, "Download");
                return false;
                //throw ex;
            }
        }

        public static byte[] DownloadFileBuffer(string sftpFilePath)
        {
            try
            {
                using(var client = new SftpClient(SFTPUser.Host, SFTPUser.Port, SFTPUser.UserName, SFTPUser.Password))
                {
                    client.Connect();

                    string fileFullPath = string.Concat(FileServerPath, "/", sftpFilePath);

                    byte[] buffer = client.ReadAllBytes(fileFullPath);

                    client.Disconnect();

                    return buffer;
                }
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, ex.Source, "DownloadFile Sftp");
                throw;
            }
        }

        public static byte[] DownloadEDocFileBuffer(string sftpFilePath)
        {
            try
            {
                using(var client = new SftpClient(SFTPUser.Host, SFTPUser.Port, SFTPUser.UserName, SFTPUser.Password))
                {
                    client.Connect();

                    string fileFullPath = string.Concat(EdocServerPath, sftpFilePath).Replace(@"\", "/");

                    byte[] buffer = client.ReadAllBytes(fileFullPath);

                    client.Disconnect();

                    return buffer;
                }
            }
            catch(Exception ex)
            {
                Log.AddError(ex.Message, ex.Source, "DownloadFile Sftp");
                throw;
            }
        }

        /// <summary>
        /// SFTP serverin islek olub olmamasini yoxlamaq ucun istifade olunur
        /// </summary>
        /// <returns></returns>
        public static bool CheckSftpServer()
        {
            try
            {
                PingReply reply = new Ping().Send(SFTPUser.Host, 5000, new byte[32], new PingOptions(64, true));

                if(reply?.Status == IPStatus.Success)
                {
                    Log.AddInfo(
                        $"Address: {reply.Address}; " +
                        $"RoundTrip time: {reply.RoundtripTime};" +
                        $"Time to live: {reply.Options.Ttl}; " +
                        $"Don't fragment: {reply.Options.DontFragment}; " +
                        $"Buffer size: {reply.Buffer.Length};",
                        "Ping Properties",
                        "CheckSFTPServer - success");

                    return true;
                }
            }
            catch(PingException ex)
            {
                Log.AddError(ex.Message, ex.Source, "CheckSFTPServer - error");
            }

            return false;
        }
    }

}