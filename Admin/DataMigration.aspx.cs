using System;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI;
using GeoCoding;
using GeoCoding.Google;
using Pollinator.DataAccess;

public partial class Admin_DataMigration : System.Web.UI.Page
{
    /// <summary>
    /// Summary description for ImportFields
    /// </summary>
    public class ImportFields
    {
        public string LineNumber;
        public string PhysicalLocation;
        public string FirstName;
        public string LastName;
        public string OrganizationName;
        public int PollinatorSize = 0;
        public int PollinatorType = 0;
        public string LandscapeStreet;
        public string LandscapeCity;
        public string LandscapeState;
        public string LandscapeZipcode;
        public string LandscapeCountry;
        public string PhotoUrl;
        public string YoutubeUrl;
        public double? Latitude = 0;
        public double? Longitude = 0;
        public string Website;
        public string UserId;
        public int isApproved = 0;
        public byte Premium = 0;
        public string Email;
        public bool FuzyLocation;
    }
    PollinatorEntities mydb = new PollinatorEntities();
    static bool IS_WRITE_CSV = true;
    static bool IS_WRITE_DB = true;
    static bool IS_GET_LOCATION = true;

    protected void Page_Load(object sender, EventArgs e)
    {
    }

    //Item 1. Convert data demo từ bản ghi của file Excel 
    protected void btnParseDemoData_Click(object sender, EventArgs e)
    {
        if (!fileDemo.HasFile)
        {
            return;
        }

       // try
       // {
            //Upload file to server                
            string uploadFolder = System.Configuration.ConfigurationManager.AppSettings["FolderPath"];
            string sDirPath = Request.PhysicalApplicationPath + uploadFolder;
            string sfilePath = sDirPath + "\\" + fileDemo.FileName;
            fileDemo.SaveAs(sfilePath);

            ParseDemoInfo(sfilePath, sDirPath);
            GoToAlertMessage(panelSuccessMessage);
      /*  }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_DataMigration).Name + "btnGetLocation_Click(). Exception:", ex);
            GoToAlertMessage(panelErrorMessage);
        }*/
    }

    private List<ImportFields> ParseDemoInfo(string filePath, string sDirPath)
    {
        string content = File.ReadAllText(filePath);
        File.Delete(filePath);

        // Parse content
        string[] stringSeparators = new string[] { "\r\n" };
        string[] lines = content.Split(stringSeparators, StringSplitOptions.RemoveEmptyEntries);

        int numRecord = lines.Length;
        List<ImportFields> listData = new List<ImportFields>();
        List<ImportFields> notConvertList = new List<ImportFields>();
        ImportFields data;
        IGeoCoder geoCoder = new GoogleGeoCoder();

        string nameList = "Tom, Marry, Adinath, Ajitesh, Akshaj, Akshobhya, Ameyatma, Badri, Badrinath, Bhudhav, Chakradev, Chhatrabhuj, Eashan, Eha, Eka, Ekana, Evyavan, Harinarayan, Hemang, Ijay, Indivar, Ish, Jaipal, Jaithra, Kamalakar, Kamalkant, Kamalnath, Lakshmidhar, Lakshmigopal, Lakshmiraman, Liladhar, Lohitaksh, Lohitaksha, Loknath, Lokranjan, Madhuban, Mahakram, Mahatru, Namish, Narahari, Nityanta, Padmanabha, Padmapati, Padmesh, Parmesh, Phanindranath, Pramodan, Rakshan, Ramakaant, Ramashray, Ranganath, Ratannabha, Ratnabhu, Ratnanidhi, Sadabindu, Sadru, Sahishnu, Samarendra, Samarendu, Samarjit, Samavart, Samendu, Saprathas, Satanand, Satkartar, Satveer,Tommy, Denny, Herry, Nate, Yathavan, David, Aadinath, Aaditeya, Zacharry, Aamod, Zuhayr";
        string[] firstnames = nameList.Split(new char[] { '\n', ',' });

        string orgNameList = "Coca, Pollinator, Friendly Farmers, Microsoft, Hobbyist, Beekeeper, Gardener";
        string[] orgNames = orgNameList.Split(new char[] { '\n', ',' });
        int numFirstName = firstnames.Length;
        string physicalLocation;
        Random random = new Random();
        for (int i = 1; i < numRecord; i++)
        {
            data = new ImportFields();
            string[] values = ImportExportUltility.GetCsvRecord(lines[i]);
            if (values.Length > 2)
            {
                physicalLocation = values[1].Replace("See map: Google Maps ", "");
                string[] sAddress = physicalLocation.Split(new char[] { '\n', ',' }, StringSplitOptions.RemoveEmptyEntries);
                int len = sAddress.Length;
                int startDataIndex = 0;
                while (string.IsNullOrWhiteSpace(sAddress[startDataIndex]) && startDataIndex < len)
                {
                    startDataIndex++;
                }
                if (startDataIndex<len)
                    data.LandscapeStreet = sAddress[startDataIndex].Trim();
                if (startDataIndex+1 < len)
                     data.LandscapeZipcode = sAddress[startDataIndex + 1].Trim();
                if (startDataIndex +2< len)
                     data.LandscapeCity = sAddress[startDataIndex + 2].Trim();
                data.LandscapeState = values[2].Trim();
                data.Premium = 1;
                data.PollinatorSize = random.Next(1, 8);
                data.PollinatorType = random.Next(1, 9);
                data.FirstName = firstnames[random.Next(1, numFirstName - 1)];
                data.OrganizationName = orgNames[random.Next(1, 8)];
                data.PhotoUrl = "";//UploadFiles/458586204/Burts Bees logo.png";

                if (IS_GET_LOCATION)
                {
                    //Get location from address
                    physicalLocation = physicalLocation.Replace("\n", "").Trim();

                    geoCoder = new GoogleGeoCoder();
                    bool getLocation = false;
                    Address[] matchAddress = null;
                    int numTry = 0;
                    while (!getLocation && numTry < 5)
                    {
                        try
                        {
                            matchAddress = geoCoder.GeoCode(physicalLocation).ToArray();
                            getLocation = true;
                            numTry++;
                            break;
                        }
                        catch (Exception ex)
                        {
                            System.Threading.Thread.Sleep(2000);
                            //  Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_DataMigration).Name + "Get location from address. Exception:", ex);
                        }
                    }

                    if (matchAddress != null && matchAddress.Length > 0)
                    {
                        data.Latitude = matchAddress[0].Coordinates.Latitude;
                        data.Longitude = matchAddress[0].Coordinates.Longitude;
                        listData.Add(data);
                    }
                    else
                    {
                        data.LineNumber = (i + 1).ToString();
                        data.PhysicalLocation = physicalLocation;
                        notConvertList.Add(data);
                    }
                }
                else
                {
                    if (i != 29 && i != 53)
                    {
                        listData.Add(data);
                    }
                }
            }
        }

        WriteCsvFile(listData, sDirPath, @"\output.csv");

        if (IS_GET_LOCATION)
        {
            //write file to check error line (can't get location)
            var csv = new StringBuilder();
            string newLine = "LineNumber,PhysicalLocation,OrganizationName,PollinatorSize,PollinatorType, LandscapeCity,LandscapeState,LandscapeZipcode," + Environment.NewLine;
            csv.Append(newLine);
            for (int i = 0; i < notConvertList.Count; i++)
            {
                ImportFields writedata = notConvertList.ElementAt(i);
                newLine = string.Format("{0}, \"{1}\",\"{2}\",\"{3}\",\"{4}\",\"{5}\",\"{6}\",\"{7}\",{8}",
                                writedata.LineNumber,
                                writedata.PhysicalLocation,
                                writedata.OrganizationName,
                                writedata.PollinatorSize,
                                writedata.PollinatorType,
                                writedata.LandscapeCity,
                                writedata.LandscapeState,
                                writedata.LandscapeZipcode,
                                Environment.NewLine);
                csv.Append(newLine);
            }

            File.WriteAllText(sDirPath + @"\output_error.csv", csv.ToString());
        }

        return listData;
    }



    protected void btnImportDemo_Click(object sender, EventArgs e)
    {
        if (!fileDemo.HasFile)
        {
            return;
        }

     //   try
       // {
            List<ImportFields> listData = new List<ImportFields>();

            //Upload file to server                
            string uploadFolder = System.Configuration.ConfigurationManager.AppSettings["FolderPath"];
            string sDirPath = Request.PhysicalApplicationPath + uploadFolder;
            string sfilePath = sDirPath + "\\" + fileDemo.FileName;
            if (!File.Exists(sfilePath))
                fileDemo.SaveAs(sfilePath);

            if (!fileDemo.FileName.Contains("outputfull"))//not parse yet, pasrse data
            {
                listData = ParseDemoInfo(sfilePath, sDirPath);
            }
            else//has parse, just read parsed data
            {
                string[] lines = File.ReadAllLines(sfilePath);
                int numRecord = lines.Length;
                ImportFields data;

                for (int i = 1; i < numRecord; i++)
                {
                    data = new ImportFields();
                    string[] values = ImportExportUltility.GetCsvRecord(lines[i]);
                    if (values.Length > 11)
                    {
                        data.FirstName = values[0].Trim();
                        data.OrganizationName = values[1].Trim();
                        data.PollinatorSize = Int32.Parse(values[3].Trim());
                        data.PollinatorType = Int32.Parse(values[4].Trim());
                        data.LandscapeStreet = values[5].Trim();
                        data.LandscapeCity = values[6].Trim();
                        data.LandscapeState = values[7].Trim();
                        data.LandscapeCountry = values[8].Trim();
                        data.LandscapeZipcode = values[9].Trim();                      
                        data.PhotoUrl = values[10].Trim();
                        data.Latitude = double.Parse(values[11].Trim());
                        data.Longitude = double.Parse(values[12].Trim());
                        data.FuzyLocation = bool.Parse(values[13].Trim());
                        data.Premium =byte.Parse(values[14].Trim());
                        if (values.Length > 15)
                        {
                            //  data.RowId = int.Parse(values[12]);
                            data.UserId = values[15];
                        }
                        listData.Add(data);
                    }
                }
            }

            WriteDB(listData, "Demo");

            GoToAlertMessage(panelSuccessMessage);
       /* }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_DataMigration).Name + "btnImportDemo_Click(). Exception:", ex);
            GoToAlertMessage(panelErrorMessage);
        }*/
    }

    //2.Convert dữ liệu thật từ hơn 600 bản ghi của hệ thống cũ.
    protected void btnImportOld_Click(object sender, EventArgs e)
    {
       // try
      //  {
            if (!FileUpload1.HasFile || !FileUpload2.HasFile)
            {
                return;
            }

            //Upload file to server  
            string uploadFolder = System.Configuration.ConfigurationManager.AppSettings["FolderPath"];
            string sDirPath = Request.PhysicalApplicationPath + uploadFolder;
            string path1 = sDirPath + "\\" + FileUpload1.FileName;
            FileUpload1.SaveAs(path1);

            string path2 = sDirPath + "\\" + FileUpload2.FileName;
            FileUpload2.SaveAs(path2);

            string[] lines1 = File.ReadAllLines(path1);

            // Parse content
            string content2 = File.ReadAllText(path2);
            string[] stringSeparators = new string[] { "\r\n" };
            string[] lines2 = content2.Split(stringSeparators, StringSplitOptions.RemoveEmptyEntries);

            // string[] lines2 = File.ReadAllLines(path2);
            File.Delete(path1);
            File.Delete(path2);

            ImportFields data;

            List<ImportFields> listData1 = new List<ImportFields>();
            int numRecord = lines1.Length;
            if (numRecord > 662)
                numRecord = 662;

            for (int i = 1; i < numRecord; i++)
            {
                data = new ImportFields();
                string[] values = ImportExportUltility.GetCsvRecord(lines1[i]);
                if (values.Length > 12)
                {
                    data.FirstName = values[0].Trim();
                    data.PollinatorSize = Int32.Parse(values[2].Trim());
                    data.PollinatorType = Int32.Parse(values[3].Trim());
                    data.LandscapeCity = values[5].Trim();
                    data.LandscapeCountry = values[6].Trim();
                    if (data.LandscapeCountry == "US")
                        data.LandscapeCountry = "USA";
                    else if (data.LandscapeCountry == "BR")
                        data.LandscapeCountry = "BRA";
                    data.PhotoUrl = values[9].Trim();
                    data.Latitude = double.Parse(values[10].Trim());
                    data.Longitude = double.Parse(values[11].Trim());
                    data.Premium = 0;
                    listData1.Add(data);
                }
            }

            var listData1D = listData1.GroupBy(d => new
            {
                d.FirstName,
                d.PollinatorSize,
                d.PollinatorType,
                d.LandscapeCity,
                d.PhotoUrl,
                //  d.Latitude,
                //  d.Longitude,
                d.Premium,
            }).Select(group => group.First()).ToList();


            List<ImportFields> listData2 = new List<ImportFields>();
            numRecord = lines2.Length;
            for (int i = 1; i < numRecord; i++)
            {
                data = new ImportFields();
                string[] values = ImportExportUltility.GetCsvRecord(lines2[i]);
                //{
                // if (values.Length > 8 && !string.IsNullOrEmpty(values[1]))
                data.FirstName = values[0].Trim();
                data.OrganizationName = values[1].Trim();
                data.Email = values[2].Trim();
                data.LandscapeCity = values[3].Trim();
                data.LandscapeState = values[4].Trim();               
                data.LandscapeCountry = values[5].Trim();
                if (data.LandscapeCountry == "Brazil")
                    data.LandscapeCountry = "BRA";
                else if (data.LandscapeCountry == "Canada")
                    data.LandscapeCountry = "CA";
                else if (data.LandscapeCountry == "France")
                    data.LandscapeCountry = "FR";

                data.LandscapeZipcode = values[6].Trim();
                data.LandscapeStreet = values[7].Trim();

                if (values[9].Contains("Small planter"))
                    data.PollinatorSize = 1;
                else if (values[9].Contains("Small garden"))
                    data.PollinatorSize = 2;
                else if (values[9].Contains("Large garden"))
                    data.PollinatorSize = 3;
                else if (values[9].Contains("Small Yard"))
                    data.PollinatorSize = 4;
                else if (values[9].Contains("Medium Yard"))
                    data.PollinatorSize = 5;
                else if (values[9].Contains("Large Yard"))
                    data.PollinatorSize = 6;
                else if (values[9].Contains("Large Filed"))
                    data.PollinatorSize = 8;
                else if (values[9].Contains("Filed"))
                    data.PollinatorSize = 7;
                else
                    data.PollinatorSize = 9;
                //  data.PhotoUrl = values[10];
                data.PollinatorType = 0;//temp set  because no data
                listData2.Add(data);
                // }
            }

            var listData2D = listData2.GroupBy(d => new
            {
                d.FirstName,
                d.OrganizationName,
                d.Email,
                d.LandscapeCity,
                d.LandscapeState,
                d.LandscapeZipcode,
                d.LandscapeCountry,
                d.PollinatorSize
            }).Select(group => group.First()).ToList();

            var mergelist = (from pi1 in listData2D
                             join pi2 in listData1D
                                on new { pi1.FirstName, pi1.LandscapeCity, pi1.LandscapeCountry } equals new { pi2.FirstName, pi2.LandscapeCity, pi2.LandscapeCountry }
                                into ords
                             from pi2 in ords.DefaultIfEmpty()
                             // from pi2 in listData2
                             //  where pi1.FirstName == pi2.FirstName
                             select new ImportFields
                             {
                                 FirstName = pi1.FirstName,
                                 Email = pi1.Email,
                                 OrganizationName = pi1.OrganizationName,
                                 PhotoUrl = pi1.PhotoUrl,
                                 LandscapeStreet = pi1.LandscapeStreet,
                                 LandscapeCity = pi1.LandscapeCity,
                                 LandscapeState = pi1.LandscapeState,
                                 LandscapeCountry = pi1.LandscapeCountry,
                                 LandscapeZipcode = pi1.LandscapeZipcode,

                                 PollinatorSize = pi1.PollinatorSize,
                                 PollinatorType = pi2 != null ? pi2.PollinatorType : pi1.PollinatorType,

                                 Premium = pi1.Premium,
                                 Latitude = pi2 != null ? pi2.Latitude : null,
                                 Longitude = pi2 != null ? pi2.Longitude : null,
                             }
                         ).ToList();

            /*   var mergelistD = mergelist.GroupBy(d => new
               {
                   d.FirstName,
                   d.OrganizationName,
                   d.LandscapeCity,
                   d.LandscapeState,
                   d.LandscapeZipcode,
                   d.PollinatorSize,
                   d.PollinatorType,
                  // d.PhotoUrl,
                   d.Premium,
                   d.Latitude,
                   d.Longitude,
               })
               .Select(group => group.First()).ToList();*/

            WriteCsvFile(listData1D, sDirPath, @"\file1.csv");
            WriteCsvFile(listData2D, sDirPath, @"\file2.csv");
            WriteCsvFile(mergelist, sDirPath, @"\mergefile.csv");
            //  WriteCsvFile(mergelistD, sDirPath, @"\mergefileD.csv");
            if (IS_GET_LOCATION)
            {
                mergelist = GetLocationForOldData(mergelist);
                WriteCsvFile(mergelist, sDirPath, @"\mergefile2.csv");
            }

            WriteDB(mergelist, "OldSystem");

            GoToAlertMessage(panelSuccessMessage);

       /* }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_ImportData).Name + ".btnImportOld_Click(). Exception:", ex);
            GoToAlertMessage(panelErrorMessage);
        }*/
    }

    private static List<ImportFields> GetLocationForOldData(List<ImportFields> listdata)
    {
        int numRecord = listdata.Count;
        List<ImportFields> outputList = new List<ImportFields>();
        GoogleGeoCoder geoCoder;
        ImportFields writedata;
        string physicalLocation;
        for (int i = 0; i < numRecord; i++)
        {
            writedata = listdata.ElementAt(i);
            if (!writedata.Longitude.HasValue)
            {
                geoCoder = new GoogleGeoCoder();
                bool getLocation = false;
                Address[] matchAddress = null;
                int numTry = 0;
                while (!getLocation && numTry < 5)
                {
                    try
                    {
                        numTry++;
                        physicalLocation = writedata.LandscapeStreet + " " +
                            writedata.LandscapeZipcode + " " +
                            writedata.LandscapeCity + " " +
                            writedata.LandscapeState + " " +
                            writedata.LandscapeCountry;
                        matchAddress = geoCoder.GeoCode(physicalLocation).ToArray();
                        getLocation = true;
                        break;
                    }
                    catch (Exception ex)
                    {
                        System.Threading.Thread.Sleep(2000);
                        //  Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_ImportData).Name + "Get location from address. Exception:", ex);
                    }

                }
                if (matchAddress != null && matchAddress.Length > 0)
                {
                    writedata.Latitude = matchAddress[0].Coordinates.Latitude;
                    writedata.Longitude = matchAddress[0].Coordinates.Longitude;
                    if (matchAddress.Length > 1)
                        writedata.FuzyLocation = true;

                }
            }
            outputList.Add(writedata);
        }
        return outputList;
    }


    private void WriteCsvFile(List<ImportFields> listdata, string sDirPath, string filename)
    {
        if (IS_WRITE_CSV)
        {
            var csv = new StringBuilder();
            var newLine = "FirstName,OrganizationName,Email,PollinatorSize,PollinatorType,LandscapeStreet,LandscapeCity,LandscapeState,LandscapeCountry,LandscapeZipcode,PhotoUrl,Latitude,Longitude,FuzyLocation,Premium," + Environment.NewLine;
            csv.Append(newLine);
            ImportFields writedata;
            for (int i = 0; i < listdata.Count; i++)
            {
                writedata = listdata.ElementAt(i);
                newLine = string.Format("\"{0}\",\"{1}\",\"{2}\",\"{3}\",\"{4}\",\"{5}\",\"{6}\",\"{7}\",\"{8}\",\"{9}\",\"{10}\",\"{11}\",\"{12}\",\"{13}\",\"{14}\",{15}",
                                writedata.FirstName,
                                writedata.OrganizationName,
                                writedata.Email,
                                writedata.PollinatorSize,
                                writedata.PollinatorType,
                                writedata.LandscapeStreet,
                                writedata.LandscapeCity,
                                writedata.LandscapeState,
                                writedata.LandscapeCountry,
                                writedata.LandscapeZipcode,
                                writedata.PhotoUrl,
                                writedata.Latitude,
                                writedata.Longitude,
                                writedata.FuzyLocation,
                                writedata.Premium,
                                Environment.NewLine);
                csv.Append(newLine);
            }

            //write file to check merge result
            File.WriteAllText(sDirPath + filename, csv.ToString());
        }

    }


    private void WriteDB(List<ImportFields> listdata, string sourceData)
    {
        if (IS_WRITE_DB)
        {
            var csv = new StringBuilder();
            var newLine = "FirstName,OrganizationName,Email,PollinatorSize,PollinatorType,LandscapeStreet,LandscapeCity,LandscapeState,LandscapeCountry,LandscapeZipcode,PhotoUrl,Latitude,Longitude,Premium,FuzyLocation,UserId" + Environment.NewLine; csv.Append(newLine);

            ImportFields writedata;
            UserDetail userDetail;
            PolinatorInformation polinatorInformation;
          
            Guid userId;
            int numRecord = listdata.Count;
            for (int i = 0; i < numRecord; i++)
            {
                writedata = listdata.ElementAt(i);

                /* if (writedata.PollinatorSize == 0)
                     writedata.PollinatorSize = 1;
                 if (writedata.PollinatorType == 0)
                     writedata.PollinatorType = 1;*/

                if (writedata.LandscapeZipcode.Length > 15)
                    writedata.LandscapeZipcode = writedata.LandscapeZipcode.Substring(0, 15);

                userDetail = new UserDetail();
                polinatorInformation = new PolinatorInformation();
             

                if (string.IsNullOrEmpty(writedata.UserId))
                {
                    /* if (!string.IsNullOrEmpty(writedata.Email))
                     {
                         string usename = writedata.FirstName + "Username";
                         string password = writedata.FirstName + "Password";

                         var usr = Membership.GetUser(usename);
                         if (usr == null)
                         {
                             usr = Membership.CreateUser(usename, password, writedata.Email);
                             //  userId = (Guid)usr.ProviderUserKey;
                         }

                         userId = (Guid)usr.ProviderUserKey;
                     }
                     else*/
                    userId = Guid.NewGuid();
                }
                else
                {
                    userId = new Guid(writedata.UserId);
                }

                userDetail.UserId = userId;
                userDetail.FirstName = writedata.FirstName;
                userDetail.MembershipLevel = writedata.Premium;

                //Table 2: polinatorInformation
                polinatorInformation.UserId = userId;
                polinatorInformation.OrganizationName = writedata.OrganizationName;
                polinatorInformation.PollinatorSize = writedata.PollinatorSize;
                polinatorInformation.PollinatorType = writedata.PollinatorType;
                polinatorInformation.LandscapeStreet = writedata.LandscapeStreet;
                if (polinatorInformation.LandscapeStreet == null)
                    polinatorInformation.LandscapeStreet = string.Empty;
                polinatorInformation.LandscapeCity = writedata.LandscapeCity;
                polinatorInformation.LandscapeState = writedata.LandscapeState;
                polinatorInformation.LandscapeZipcode = writedata.LandscapeZipcode;
                polinatorInformation.LandscapeCountry = writedata.LandscapeCountry;
                polinatorInformation.PhotoUrl = writedata.PhotoUrl;
                polinatorInformation.YoutubeUrl = writedata.YoutubeUrl;
                polinatorInformation.IsApproved = true;
                polinatorInformation.IsNew = false;
                polinatorInformation.LastUpdated = DateTime.Now;

                polinatorInformation.FuzyLocation = writedata.FuzyLocation;
                if (writedata.Latitude.HasValue && writedata.Longitude.HasValue)
                {
                    polinatorInformation.Latitude = (decimal)writedata.Latitude;
                    polinatorInformation.Longitude = (decimal)writedata.Longitude;
                }
                else
                    polinatorInformation.FuzyLocation = true;

                polinatorInformation.SourceData = sourceData;

                if (string.IsNullOrEmpty(writedata.UserId))
                {
                    //int RowId = objPollinatorDA.Insert(TABLE_ID, objPollinator);
                    //  polinatorInformation.RowId = RowId;
                    writedata = listdata.ElementAt(i);
                    newLine = string.Format("\"{0}\",\"{1}\",\"{2}\",\"{3}\",\"{4}\",\"{5}\",\"{6}\",\"{7}\",\"{8}\",\"{9}\",\"{10}\",\"{11}\",\"{12}\",\"{13}\",\"{14}\",\"{15}\",{16}",
                                 writedata.FirstName,
                                 writedata.OrganizationName,
                                 writedata.Email,
                                 writedata.PollinatorSize,
                                 writedata.PollinatorType,
                                 writedata.LandscapeStreet,
                                 writedata.LandscapeCity,
                                 writedata.LandscapeState,
                                   writedata.LandscapeCountry,
                                 writedata.LandscapeZipcode,
                                 writedata.PhotoUrl,
                                 writedata.Latitude,
                                 writedata.Longitude,
                                 writedata.Premium,
                                 writedata.FuzyLocation,
                                 userId,
                                 Environment.NewLine);
                    csv.Append(newLine);
                }


                mydb.UserDetails.Add(userDetail);
                mydb.PolinatorInformations.Add(polinatorInformation);
            }

            string uploadFolder = System.Configuration.ConfigurationManager.AppSettings["FolderPath"];
            string sDirPath = Request.PhysicalApplicationPath + uploadFolder;
            File.WriteAllText(sDirPath + @"\oldSystem_writeDBresult.csv", csv.ToString());

            try
            {
                mydb.SaveChanges();
            }
            catch (DbEntityValidationException e)
            {
                foreach (var eve in e.EntityValidationErrors)
                {
                    Console.WriteLine("Entity of type \"{0}\" in state \"{1}\" has the following validation errors:",
                        eve.Entry.Entity.GetType().Name, eve.Entry.State);
                    foreach (var ve in eve.ValidationErrors)
                    {
                        Console.WriteLine("- Property: \"{0}\", Error: \"{1}\"",
                            ve.PropertyName, ve.ErrorMessage);
                    }
                }
                throw;
            }
        }

    }

   

    private void GoToAlertMessage(Control alert)
    {
        alert.Visible = true;

        //This script will scroll page to the location of message
        string scrollIntoView = @"
             $(document).ready(function () {
                //The element doesn't show up immediately, must set latency for it to bring up
                setTimeout(goToAlertMessage, 10);
            });

            function goToAlertMessage()
            {
                var el = document.getElementById('" + alert.ClientID + @"');
                el.scrollIntoView(true);
            }
        ";
        ScriptManager.RegisterStartupScript(this, this.GetType(), "scrollIntoView_script", scrollIntoView, true);
    }
    #region Properties



    #endregion
}