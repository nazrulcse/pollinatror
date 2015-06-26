using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;
using ClosedXML.Excel;

/// <summary>
/// Summary description for ImportFields
/// </summary>
/// 
[Serializable]
public class ImportExportFields
{
    public int LineNumber { get; set; }//0
    public Guid UserId { get; set; }//1
    public string FirstName { get; set; }//2
    public string LastName { get; set; }//3
    public string OrganizationName { get; set; }//4
    public string Website { get; set; }//5
    public string PhoneNumber { get; set; }//6
    public string Email { get; set; }//7
    public string PollinatorTypeName { get; set; }//8
    public string OrganizationDescription { get; set; }//9
    public string PollinatorSizeName { get; set; }//10
    public string LandscapeStreet { get; set; }//11
    public string LandscapeCity { get; set; }//12
    public string LandscapeState { get; set; }//13
    public string LandscapeZipcode { get; set; }//14
    public string LandscapeCountryName { get; set; }//15
    public byte Premium { get; set; }//16
    public int isApproved { get; set; }//17

    //ID was get by name
    public int PollinatorType { get; set; }
    public int PollinatorSize { get; set; }
    public string LandscapeCountry { get; set; }

    //existed data
    public bool IsExistedData { get; set; }
    public string ActionForExistedData { get; set; }
    public Guid ExistedUserId { get; set; }
    public string ExistedDataDescription { get; set; }//18

    public string Geolocation { get; set; }
    //public string PhotoUrl;
    //public string YoutubeUrl;
    public decimal? Latitude { get; set; }
    public decimal? Longitude { get; set; }
    //public bool FuzyLocation;
    //public string PollinatorDesc;
    //public string PhysicalLocation;
}

[Serializable]
public class OrginalDataField
{
    public int LineNumber { get; set; }//0
    public string ID { get; set; }//1
    public string FirstName { get; set; }//2
    public string LastName { get; set; }//3
    public string OrganizationName { get; set; }//4
    public string Website { get; set; }//5
    public string PhoneNumber { get; set; }//6
    public string Email { get; set; }//7
    public string PollinatorType { get; set; }//8
    public string OrganizationDescription { get; set; }//9
    public string PollinatorSize { get; set; }//10
    public string Address { get; set; }//11
    public string City { get; set; }//12
    public string State { get; set; }//13
    public string ZIP { get; set; }//14
    public string Country { get; set; }//15
    public string Geolocation { get; set; }//16

    public string ErrorDescription { get; set; }//18
}

public class DataItem
{
    public string ID { get; set; }
    public string Name { get; set; }
}

public class ImportExportUltility
{
    public static int numFieldOfImportFile = 16;//number column of import file


    private static void BuildExcelHeader(string[] columnNames, int[] columnWidths, out Table tb, out TableRow tableRow)
    {

        StringBuilder builder = new StringBuilder();
        tb = new Table();
        tb.CellPadding = 4;
        tb.GridLines = GridLines.Both;
        tb.CellSpacing = 0;
        tb.Width = Unit.Percentage(100);

        TableCell tableCell;
        tableRow = new TableRow();

        var columnscount = columnNames.Length;
        for (int i = 0; i < columnscount; i++)
        {
            tableCell = new TableCell();
            tableCell.Height = 50;
            tableCell.BackColor = System.Drawing.Color.FromName("lightgreen");
            tableCell.Width = columnWidths[i];
            tableCell.Text = "<b>" + columnNames[i] + "</b>";
            tableCell.HorizontalAlign = HorizontalAlign.Center;
            tableRow.Cells.Add(tableCell);
            tb.Rows.Add(tableRow);
        }
    }

    private static void WriteExcelData(Table tb, TableRow tableRow, string value, string styleClass = "", bool nowrap = false)
    {
        TableCell cell = new TableCell();
        cell.Text = value;
        cell.VerticalAlign = VerticalAlign.Top;
        cell.HorizontalAlign = HorizontalAlign.Left;
        if (nowrap)
        {
            cell.Attributes.Add("nowrap", "true");
        }
        if (!string.IsNullOrEmpty(styleClass))
        {
            cell.Attributes.Add("class", styleClass);
        }
        tableRow.Cells.Add(cell);
        tb.Rows.Add(tableRow);
    }

    private static string AddExcelStyling()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("<html xmlns:o='urn:schemas-microsoft-com:office:office'" + Environment.NewLine +
        "xmlns:x='urn:schemas-microsoft-com:office:excel'" + Environment.NewLine +
        "xmlns='http://www.w3.org/TR/REC-html40'>" + Environment.NewLine +
        "<head>");
        sb.Append("<style>" + Environment.NewLine);

        sb.Append("@page");
        sb.Append("{margin:.25in .25in .25in .25in;" + Environment.NewLine);

        sb.Append("mso-header-margin:.025in;" + Environment.NewLine);
        sb.Append("mso-footer-margin:.025in;" + Environment.NewLine);

        sb.Append("mso-page-orientation:landscape;}" + Environment.NewLine);
        sb.Append("</style>" + Environment.NewLine);

        sb.Append("<!--[if gte mso 9]><xml>" + Environment.NewLine);
        sb.Append("<x:ExcelWorkbook>" + Environment.NewLine);

        sb.Append("<x:ExcelWorksheets>" + Environment.NewLine);
        sb.Append("<x:ExcelWorksheet>" + Environment.NewLine);
        sb.Append("<x:WorksheetOptions>" + Environment.NewLine);

        sb.Append("<x:Selected/>" + Environment.NewLine);
        sb.Append("<x:FreezePanes/>" + Environment.NewLine);
        sb.Append("<x:FrozenNoSplit/>" + Environment.NewLine);
        sb.Append("<x:SplitHorizontal>1</x:SplitHorizontal>" + Environment.NewLine);
        sb.Append("<x:TopRowBottomPane>1</x:TopRowBottomPane>" + Environment.NewLine);
        sb.Append("<x:ActivePane>2</x:ActivePane>" + Environment.NewLine);

        sb.Append("<x:Panes>" + Environment.NewLine);
        sb.Append("<x:Panes>" + Environment.NewLine);
        sb.Append("<x:Number>3</x:Number>" + Environment.NewLine);
        sb.Append("</x:Pane>" + Environment.NewLine);
        sb.Append("</x:Pane>" + Environment.NewLine);
        sb.Append("<x:Number>2</x:Number>" + Environment.NewLine);
        sb.Append("</x:Pane>" + Environment.NewLine);

        sb.Append("<x:ProtectContents>False</x:ProtectContents>" + Environment.NewLine);
        sb.Append("<x:ProtectObjects>False</x:ProtectObjects>" + Environment.NewLine);

        sb.Append("<x:ProtectScenarios>False</x:ProtectScenarios>" + Environment.NewLine);
        sb.Append("</x:WorksheetOptions>" + Environment.NewLine);

        sb.Append("</x:ExcelWorksheet>" + Environment.NewLine);
        sb.Append("</x:ExcelWorksheets>" + Environment.NewLine);

        sb.Append("<x:WindowHeight>12780</x:WindowHeight>" + Environment.NewLine);
        sb.Append("<x:WindowWidth>19035</x:WindowWidth>" + Environment.NewLine);

        sb.Append("<x:WindowTopX>0</x:WindowTopX>" + Environment.NewLine);
        sb.Append("<x:WindowTopY>15</x:WindowTopY>" + Environment.NewLine);

        sb.Append("<x:ProtectStructure>False</x:ProtectStructure>" + Environment.NewLine);
        sb.Append("<x:ProtectWindows>False</x:ProtectWindows>" + Environment.NewLine);

        sb.Append("</x:ExcelWorkbook>" + Environment.NewLine);
        sb.Append("</xml><![endif]-->" + Environment.NewLine);

        sb.Append("</head>" + Environment.NewLine);
        sb.Append("<body>" + Environment.NewLine);

        return sb.ToString();

    }

    /// <summary>
    /// Export excel with HTML format
    /// </summary>
    /// <param name="response">Current page response</param>
    /// <param name="fileName">export file name</param>
    /// <param name="tb">web html table</param>
    public static void ExportExcel(HttpResponse response, string fileName, Table tb)
    {
        try
        {
            response.Clear();
            response.ClearContent();
            response.ClearHeaders();
            response.Buffer = true;
            response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

            response.AppendHeader("Content-Disposition", string.Format("attachment; filename={0}", fileName));

            response.Charset = "utf-8";
            response.ContentEncoding = System.Text.Encoding.UTF8;
            response.BinaryWrite(System.Text.Encoding.UTF8.GetPreamble());

            System.IO.StringWriter oStringWriter = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter oHtmlTextWriter = new System.Web.UI.HtmlTextWriter(oStringWriter);
            tb.RenderControl(oHtmlTextWriter);
            response.Write(@"<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">");
            response.Write(AddExcelStyling());
            string style = @"<style> .text { mso-number-format:\@; } </style>";
            response.Write(style);
            response.Write(oStringWriter.ToString());

            response.End();
        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error occured at " + typeof(ImportExportUltility).Name + " ExportExcel().:", ex);
            response.End();
        }
    }

    /// <summary>
    /// Export excel with binary format using ClosedXml library 
    /// </summary>
    /// <param name="response">Current page response</param>
    /// <param name="dt">DataTabe</param>
    /// <param name="columnWidths">double array to define the with of column</param>
    public static void ExportExcel(HttpResponse response, string fileName, DataTable dt, double[] columnWidths)
    {
        try
        {
            int numColumn = columnWidths.Length;
            using (XLWorkbook wb = new XLWorkbook())
            {
                var ws = wb.Worksheets.Add(dt);

                using (MemoryStream MyMemoryStream = new MemoryStream())
                {
                    ws.Tables.First().ShowAutoFilter = false;
                    ws.Tables.First().ShowRowStripes = false;
                    ws.Tables.First().Theme = XLTableTheme.None;

                    ws.SheetView.FreezeRows(1);

                    ws.Row(1).Style.Font.FontColor = XLColor.Black;
                    ws.Row(1).Style.Font.Bold = true;
                    ws.Row(1).Style.Alignment.Indent = 1;
                    ws.Range(1, 1, 1, numColumn).Style.Fill.BackgroundColor = XLColor.LightGreen;

                    ws.Column(1).Width = columnWidths[0];
                    if (columnWidths.Length == 18)
                    {
                        ws.Column(1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                    }
                    ws.Column(1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Top;

                    for (int i = 1; i < numColumn; i++)
                    {
                        ws.Column(i + 1).Width = columnWidths[i];
                        ws.Column(i + 1).Style.Alignment.WrapText = true;
                        ws.Column(i + 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Top;
                    }

                    ws.RangeUsed().Style.Border.InsideBorderColor = XLColor.Black;
                    ws.RangeUsed().Style.Border.OutsideBorderColor = XLColor.Black;
                    ws.RangeUsed().Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                    ws.RangeUsed().Style.Border.OutsideBorder = XLBorderStyleValues.Thin;

                    wb.SaveAs(MyMemoryStream);

                    response.Clear();
                    response.Buffer = true;
                    response.Charset = "";
                    response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    response.AppendHeader("Content-Disposition", string.Format("attachment; filename={0}", fileName));
                    MyMemoryStream.WriteTo(response.OutputStream);
                    response.Flush();
                    response.End();
                }
            }
        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error occured at " + typeof(ImportExportUltility).Name + " ExportExcel().:", ex);
            response.End();
        }
    }

    private static DataTable ToDataTable(List<ImportExportFields> listData, string fileName, string[] columnNames, bool showExistedDataDescription = false)
    {
        string wsName = fileName.Substring(0, fileName.Length - 5);
        if (wsName.Length > 31)
        {
            wsName = wsName.Split(new string[] { "_" }, StringSplitOptions.None)[0];
            if (string.IsNullOrEmpty(wsName))
                wsName = "Sheet1";
        }

        DataTable dt = new DataTable(wsName);
        int numColumn = columnNames.Length;
        for (int i = 0; i < numColumn; i++)
        {
            dt.Columns.Add(columnNames[i], typeof(string));
        }

        DataRow dataRow;

        int rowscount = listData.Count();
        string geolocation = string.Empty;
        if (!showExistedDataDescription)
        {
            for (int i = 0; i < rowscount; i++)
            {
                //write in new row
                dataRow = dt.Rows.Add();
                var rowData = listData[i];
                dataRow[0] = rowData.UserId.ToString();
                dataRow[1] = rowData.FirstName;
                dataRow[2] = rowData.LastName;
                dataRow[3] = rowData.OrganizationName;
                dataRow[4] = rowData.Website;
                dataRow[5] = rowData.PhoneNumber;
                dataRow[6] = rowData.Email;
                dataRow[7] = rowData.PollinatorTypeName;
                dataRow[8] = rowData.OrganizationDescription;
                dataRow[9] = rowData.PollinatorSizeName;
                dataRow[10] = rowData.LandscapeStreet;
                dataRow[11] = rowData.LandscapeCity;
                dataRow[12] = rowData.LandscapeState;
                dataRow[13] = rowData.LandscapeZipcode;
                dataRow[14] = rowData.LandscapeCountryName;

                geolocation = string.Empty;
                if (rowData.Latitude.HasValue && rowData.Longitude.HasValue)
                {
                    geolocation = rowData.Latitude.ToString() + ";   " + rowData.Longitude.ToString();
                }
                dataRow[15] = geolocation;
            }
        }
        else
        {
            for (int i = 0; i < rowscount; i++)
            {
                //write in new row
                dataRow = dt.Rows.Add();
                var rowData = listData[i];
                dataRow[0] = rowData.LineNumber;
                dataRow[1] = rowData.ExistedDataDescription.Replace("<br>","\r\n");
                dataRow[2] = rowData.UserId.ToString();
                dataRow[3] = rowData.FirstName;
                dataRow[4] = rowData.LastName;
                dataRow[5] = rowData.OrganizationName;
                dataRow[6] = rowData.Website;
                dataRow[7] = rowData.PhoneNumber;
                dataRow[8] = rowData.Email;
                dataRow[9] = rowData.PollinatorTypeName;
                dataRow[10] = rowData.OrganizationDescription;
                dataRow[11] = rowData.PollinatorSizeName;
                dataRow[12] = rowData.LandscapeStreet;
                dataRow[13] = rowData.LandscapeCity;
                dataRow[14] = rowData.LandscapeState;
                dataRow[15] = rowData.LandscapeZipcode;
                dataRow[16] = rowData.LandscapeCountryName;

                geolocation = string.Empty;
                if (rowData.Latitude.HasValue && rowData.Longitude.HasValue)
                {
                    geolocation = rowData.Latitude.ToString() + "; " + rowData.Longitude.ToString();
                }
                dataRow[17] = geolocation;
            }
        }
        return dt;
    }

    /// <summary>
    /// Export data to excel and response directly
    /// </summary>
    /// <param name="response">Current page response</param>
    /// <param name="fileName">export file name</param>
    /// <param name="listData">list data to export</param>
    public static void ExportExcel(HttpResponse response, string fileName, List<ImportExportFields> listData)
    {
        string strColumnNames = "ID #\tFirst Name\tLast Name\tOrganization Name\tWebsite\tPhone Number\tEmail Address\tType of Pollinator\tOrganization Description\tSize of Pollinator Location\tAddress\tCity\tState\tZip\tCountry\tGeolocation";
        var columnNames = strColumnNames.Split(new string[] { "\t" }, StringSplitOptions.RemoveEmptyEntries);
        double[] columnWidths = new double[] { 15, 25, 20, 30, 20, 20, 28, 25, 30, 20, 20, 20, 20, 20, 20, 19.3 };

        DataTable dt = ImportExportUltility.ToDataTable(listData, fileName, columnNames);

        ImportExportUltility.ExportExcel(response, fileName, dt, columnWidths);
    }


    public static void ExportExistedDataExcel(HttpResponse response, string fileName, List<ImportExportFields> listData)
    {
        string strColumnNames = "Line\tError Description\tID #\tFirst Name\tLast Name\tOrganization Name\tWebsite\tPhone Number\tEmail Address\tType of Pollinator\tOrganization Description\tSize of Pollinator Location\tAddress\tCity\tState\tZip\tCountry\tGeolocation";
        var columnNames = strColumnNames.Split(new string[] { "\t" }, StringSplitOptions.RemoveEmptyEntries);
        double[] columnWidths = new double[] { 15, 35, 15, 25, 20, 30, 20, 20, 28, 25, 30, 20, 20, 20, 20, 20, 20, 19.3 };

        DataTable dt = ImportExportUltility.ToDataTable(listData, fileName, columnNames, true);
        ImportExportUltility.ExportExcel(response, fileName, dt, columnWidths);
    }


    public static void ExportFailedDataExcel(HttpResponse response, string fileName, List<OrginalDataField> listData)
    {
        string strColumnNames = "Line\tError Description\tID #\tFirst Name\tLast Name\tOrganization Name\tWebsite\tPhone Number\tEmail Address\tType of Pollinator\tOrganization Description\tSize of Pollinator Location\tAddress\tCity\tState\tZip\tCountry\tGeolocation";
        var columnNames = strColumnNames.Split(new string[] { "\t" }, StringSplitOptions.RemoveEmptyEntries);
        double[] columnWidths = new double[] { 15, 35, 15, 25, 20, 30, 20, 20, 28, 25, 30, 20, 20, 20, 20, 20, 20, 19.3 };

        DataTable dt = ImportExportUltility.ToDataTable(listData, fileName, columnNames);

        ImportExportUltility.ExportExcel(response, fileName, dt, columnWidths);
    }

    private static DataTable ToDataTable(List<OrginalDataField> listData, string fileName, string[] columnNames)
    {
        string wsName = fileName.Substring(0, fileName.Length - 5);
        if (wsName.Length > 31)
        {
            wsName = wsName.Split(new string[] { "_" }, StringSplitOptions.None)[0];
            if (string.IsNullOrEmpty(wsName))
                wsName = "Sheet1";
        }

        DataTable dt = new DataTable(wsName);

        int numColumn = columnNames.Length;
        for (int i = 0; i < numColumn; i++)
        {
            dt.Columns.Add(columnNames[i], typeof(string));
        }

        DataRow dataRow;

        int rowscount = listData.Count();
        string geolocation = string.Empty;

        for (int i = 0; i < rowscount; i++)
        {
            //write in new row
            dataRow = dt.Rows.Add();
            var rowData = listData[i];
            dataRow[0] = rowData.LineNumber;
            dataRow[1] = rowData.ErrorDescription.Replace("<br>","\r\n");
            dataRow[2] = rowData.ID.ToString();
            dataRow[3] = rowData.FirstName;
            dataRow[4] = rowData.LastName;
            dataRow[5] = rowData.OrganizationName;
            dataRow[6] = rowData.Website;
            dataRow[7] = rowData.PhoneNumber;
            dataRow[8] = rowData.Email;
            dataRow[9] = rowData.PollinatorType;
            dataRow[10] = rowData.OrganizationDescription;
            dataRow[11] = rowData.PollinatorSize;
            dataRow[12] = rowData.Address;
            dataRow[13] = rowData.City;
            dataRow[14] = rowData.State;
            dataRow[15] = rowData.ZIP;
            dataRow[16] = rowData.Country;
            dataRow[17] = rowData.Geolocation;
        }

        return dt;
    }

    /// <summary>
    /// Write log file to server by content and return download url
    /// </summary>
    /// <param name="request">Current page resquest</param>
    /// <param name="fileName">name of file</param>
    /// <param name="content">string content need write to file</param>
    /// <returns>link to download file</returns>
    public static string WriteFile(HttpRequest request, string fileName, string content)
    {
        string uploadFolder = System.Configuration.ConfigurationManager.AppSettings["FolderPath"];
        string sDirPath = request.PhysicalApplicationPath + uploadFolder + @"Admin\";
        if (!Directory.Exists(sDirPath))
        {
            Directory.CreateDirectory(sDirPath);
        }

        string filePath = sDirPath + @"\" + fileName;
        File.WriteAllText(filePath, content.ToString());

        string downloadUrl = request.ApplicationPath + @"/Handlers/DownloadFile.ashx?filename=" + uploadFolder.Replace(@"\", "/") + fileName;
        return downloadUrl;
    }

    /// <summary>
    /// Export data to csv file and return download url
    /// </summary>
    /// <param name="response">Current page response</param>
    /// <param name="fileName">export file name</param>
    /// <param name="listData">list data to export</param>
    public static string WriteCsvFile(HttpRequest request, string fileName, List<ImportExportFields> listData)
    {
        return WriteFile(request, fileName, DataToCsvString(listData));
    }

    /// <summary>
    /// Export data to csv and response directly
    /// </summary>
    /// <param name="response">Current page response</param>
    /// <param name="fileName">export file name</param>
    /// <param name="listData">list data to export</param>
    public static void ExportCSV(HttpResponse response, string fileName, List<ImportExportFields> listData)
    {
        //prepare the output stream
        response.Clear();
        response.Buffer = true;
        // response.ContentType = "text/csv";
        response.ContentType = "application/octet-stream";//application/vnd.ms-excel";
        response.AppendHeader("Content-Disposition", string.Format("attachment; filename={0}", fileName));
        //response.ContentEncoding = Encoding.Unicode;   
        response.ContentEncoding = System.Text.Encoding.UTF8;
        response.BinaryWrite(System.Text.Encoding.UTF8.GetPreamble());

        response.Write(DataToCsvString(listData));

        response.Flush();
        response.End();
    }

    private static string DataToCsvString(List<ImportExportFields> listData)
    {
        StringBuilder builder = new StringBuilder();
        string strColumnNames = "ID #,First Name,Last Name,Organization Name,Website,Phone Number,Email Address,Type of Pollinator,Organization Description,Size of Pollinator Location,Address,City,State,Zip,Country,Geolocation";

        //write header
        builder.Append(strColumnNames);
        builder.Append(Environment.NewLine);

        int numRecord = listData.Count;

        string geolocation;

        //write the data
        for (int i = 0; i < numRecord; i++)
        {
            var rowData = listData[i];

            ImportExportUltility.WriteCSVData(builder, rowData.UserId.ToString());
            ImportExportUltility.WriteCSVData(builder, rowData.FirstName);
            ImportExportUltility.WriteCSVData(builder, rowData.LastName);
            ImportExportUltility.WriteCSVData(builder, rowData.OrganizationName);
            ImportExportUltility.WriteCSVData(builder, rowData.Website);
            ImportExportUltility.WriteCSVData(builder, rowData.PhoneNumber);
            ImportExportUltility.WriteCSVData(builder, rowData.Email);
            ImportExportUltility.WriteCSVData(builder, rowData.PollinatorTypeName);
            ImportExportUltility.WriteCSVData(builder, rowData.OrganizationDescription);
            ImportExportUltility.WriteCSVData(builder, rowData.PollinatorSizeName);
            ImportExportUltility.WriteCSVData(builder, rowData.LandscapeStreet);
            ImportExportUltility.WriteCSVData(builder, rowData.LandscapeCity);
            ImportExportUltility.WriteCSVData(builder, rowData.LandscapeState);
            ImportExportUltility.WriteCSVData(builder, rowData.LandscapeZipcode);
            ImportExportUltility.WriteCSVData(builder, rowData.LandscapeCountryName);

            geolocation = string.Empty;
            if (rowData.Latitude.HasValue && rowData.Longitude.HasValue)
            {
                geolocation = rowData.Latitude.ToString() + "; " + rowData.Longitude.ToString();
            }
            ImportExportUltility.WriteCSVData(builder, geolocation, true);
        }
        return builder.ToString();
    }

    public static string WriteCSVData(StringBuilder builder, string value, bool lastColumn = false, string delimiter = ",")
    {

        if (string.IsNullOrEmpty(value))
        {
            builder.Append(string.Empty);
        }
        else
        {
            value = value.Replace(System.Environment.NewLine, "");
            // Implement special handling for values that contain comma or quote
            // Enclose in quotes and double up any double quotes
            if (value.IndexOfAny(new char[] { '"', ',', '\t' }) != -1)
                builder.AppendFormat("\"{0}\"", value.Replace("\"", "\"\""));
            else
            {
                builder.AppendFormat("{0}", value);

            }
        }
        builder.Append(lastColumn ? Environment.NewLine : delimiter);
        return value;
    }

    public static string[] GetCsvRecord(string line)
    {
        // extract the fields
        Regex CSVParser = new Regex("[\t,](?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))");
        string[] Fields = CSVParser.Split(line);

        // clean up the fields (remove " and leading spaces)
        for (int i = 0; i < Fields.Length; i++)
        {
            Fields[i] = Fields[i].TrimStart(' ', '"');
            Fields[i] = Fields[i].TrimEnd('"');
        }
        return Fields;
    }

    public static List<OrginalDataField> ReadCsv(string filePath, out int numFieldOfCurrentFile)
    {
        numFieldOfCurrentFile = 0;
        string content = File.ReadAllText(filePath);// Convert content to list string              
        Regex csvSplitLine = new Regex("\r\n(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))");
        string[] lines = csvSplitLine.Split(content);

        List<OrginalDataField> listData = new List<OrginalDataField>();

        //store data to list
        OrginalDataField orginalDataField;
        int rowNo = 0;
        foreach (var line in lines)
        {
            //not get line 1(header line)
            if (rowNo == 0)
            {
                numFieldOfCurrentFile = ImportExportUltility.GetCsvRecord(line).Length;//get num of column
                if (numFieldOfCurrentFile != numFieldOfImportFile)
                    break;

                rowNo++;
                continue;
            }

            //not add line is empty
            if (string.IsNullOrEmpty(line))
            {
                rowNo++;
                continue;
            }

            //add data records
            orginalDataField = new OrginalDataField();
            orginalDataField.LineNumber = rowNo + 1;

            string[] valueOfFields = ImportExportUltility.GetCsvRecord(line.ToString());

            //not add line is empty
            if (string.IsNullOrEmpty(valueOfFields[0]) && string.IsNullOrEmpty(valueOfFields[1]) && string.IsNullOrEmpty(valueOfFields[2])
                && string.IsNullOrEmpty(valueOfFields[3]) && string.IsNullOrEmpty(valueOfFields[4]) && string.IsNullOrEmpty(valueOfFields[5])
                && string.IsNullOrEmpty(valueOfFields[6]) && string.IsNullOrEmpty(valueOfFields[7]) && string.IsNullOrEmpty(valueOfFields[8])
                && string.IsNullOrEmpty(valueOfFields[9]) && string.IsNullOrEmpty(valueOfFields[10]) && string.IsNullOrEmpty(valueOfFields[11])
                && string.IsNullOrEmpty(valueOfFields[12]) && string.IsNullOrEmpty(valueOfFields[13]) && string.IsNullOrEmpty(valueOfFields[14])
                && string.IsNullOrEmpty(valueOfFields[15]))                
            {
                rowNo++;
                continue;
            }

            orginalDataField.ID = valueOfFields[0].ToString().Trim();
            orginalDataField.FirstName = valueOfFields[1].ToString().Trim();
            orginalDataField.LastName = valueOfFields[2].ToString().Trim();
            orginalDataField.OrganizationName = valueOfFields[3].ToString().Trim();
            orginalDataField.Website = valueOfFields[4].ToString().Trim();
            orginalDataField.PhoneNumber = valueOfFields[5].ToString().Trim();
            orginalDataField.Email = valueOfFields[6].ToString().Trim();
            orginalDataField.PollinatorType = valueOfFields[7].ToString().Trim();
            orginalDataField.OrganizationDescription = valueOfFields[8].ToString().Trim();
            orginalDataField.PollinatorSize = valueOfFields[9].ToString().Trim();
            orginalDataField.Address = valueOfFields[10].ToString().Trim();
            orginalDataField.City = valueOfFields[11].ToString().Trim();
            orginalDataField.State = valueOfFields[12].ToString().Trim();
            orginalDataField.ZIP = valueOfFields[13].ToString().Trim();
            orginalDataField.Country = valueOfFields[14].ToString().Trim();
            orginalDataField.Geolocation = valueOfFields[15].ToString().Trim();
            //add to list
            listData.Add(orginalDataField);

            //asc 1 unit
            rowNo++;
        }
        return listData;
    }

    public static List<OrginalDataField> ReadExcel(string filePath, FileInfo file, out int numColumn)
    {
        var listData = ReadDataFromExcelUsingClosedXML(filePath, out numColumn); //ReadBinaryExcel(filePath, file, out numColumn);
        if (listData == null && numColumn == 0)
        {
            listData = ReadHtmlExcel(filePath, out numColumn);
        }

        return listData;
    }

    private static List<OrginalDataField> ReadDataFromExcelUsingClosedXML(string filePath, out int numColumn)
    {

        var objWorkbook = new XLWorkbook(filePath);
        var objWorksheet = objWorkbook.Worksheets.First();

        var objFullRange = objWorksheet.RangeUsed();
        var objUsedRange = objWorksheet.Range(2, 1, objFullRange.RangeAddress.LastAddress.RowNumber,
                                                objFullRange.RangeAddress.LastAddress.ColumnNumber);

        numColumn = objUsedRange.ColumnCount();

        List<OrginalDataField> listData = new List<OrginalDataField>();
        if (numColumn != numFieldOfImportFile)
        {
            return listData;
        }

        int lineNumber = 1;
        foreach (var objRow in objUsedRange.RowsUsed())
        {
            OrginalDataField rowData = new OrginalDataField();
            lineNumber++;
            rowData.LineNumber = lineNumber;
            rowData.ID = GetString(objRow.Cell(1).Value);
            rowData.FirstName = GetString(objRow.Cell(2).Value);
            rowData.LastName = GetString(objRow.Cell(3).Value);
            rowData.OrganizationName = GetString(objRow.Cell(4).Value);
            rowData.Website = GetString(objRow.Cell(5).Value);
            rowData.PhoneNumber = GetString(objRow.Cell(6).Value);
            rowData.Email = GetString(objRow.Cell(7).Value);
            rowData.PollinatorType = GetString(objRow.Cell(8).Value);
            rowData.OrganizationDescription = GetString(objRow.Cell(9).Value);
            rowData.PollinatorSize = GetString(objRow.Cell(10).Value);
            rowData.Address = GetString(objRow.Cell(11).Value);
            rowData.City = GetString(objRow.Cell(12).Value);
            rowData.State = GetString(objRow.Cell(13).Value);
            rowData.ZIP = GetString(objRow.Cell(14).Value);
            rowData.Country = GetString(objRow.Cell(15).Value);
            rowData.Geolocation = GetString(objRow.Cell(16).Value);

            listData.Add(rowData);
        }

        return listData;

    }

    private static List<OrginalDataField> ReadHtmlExcel(string filePath, out int numColumn)
    {
        numColumn = 0;

        string content = File.ReadAllText(filePath);
        int firstIndex = content.IndexOf("<tr>");
        int lastIndex = content.LastIndexOf("</tr>");
        if (firstIndex == -1 || lastIndex == -1)
        {
            return null;
        }
        string tableContent = content.Substring(firstIndex, lastIndex - firstIndex + 5);

        string[] lines = tableContent.Split(new string[] { "<tr>" }, StringSplitOptions.RemoveEmptyEntries);
        List<OrginalDataField> listData = new List<OrginalDataField>();
        for (int i = 1; i < lines.Length; i++)
        {
            string line = lines[i];
            firstIndex = line.IndexOf("<td");
            lastIndex = line.LastIndexOf("</td>");
            string lineContent = line.Substring(firstIndex, lastIndex - firstIndex + 5);
            string[] cols = lineContent.Split(new string[] { "</td><td " }, StringSplitOptions.None);
            numColumn = cols.Length;
            if (numColumn >= numFieldOfImportFile)
            {
                for (int j = 0; j < cols.Length; j++)
                {
                    string value = cols[j];
                    firstIndex = value.LastIndexOf("\">") + 2;
                    value = value.Substring(firstIndex);
                    cols[j] = value;
                }
                OrginalDataField rowData = new OrginalDataField();
                rowData.LineNumber = i + 1;

                rowData.ID = cols[0];
                rowData.FirstName = cols[1];
                rowData.LastName = cols[2];
                rowData.OrganizationName = cols[3];
                rowData.Website = cols[4];
                rowData.PhoneNumber = cols[5];
                rowData.Email = cols[6];
                rowData.PollinatorType = cols[7];
                rowData.OrganizationDescription = cols[8];
                rowData.PollinatorSize = cols[9];
                rowData.Address = cols[10];
                rowData.City = cols[11];
                rowData.State = cols[12];
                rowData.ZIP = cols[13];
                rowData.Country = cols[14];
                rowData.Geolocation = cols[15].Replace("</td>", "");
                listData.Add(rowData);
            }
        }
        return listData;
    }
  

    private static List<OrginalDataField> ReadBinaryExcel(string filePath, FileInfo file, out int numColumn)
    {
        OleDbConnection oledbConn;
        if (file.Extension == ".xls")
        {
            oledbConn = new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"");
        }
        else //if (file.Extension == ".xlsx")
        {
            oledbConn = new OleDbConnection(@"Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties='Excel 12.0;HDR=YES;IMEX=1;';");
        }

        try
        {
            oledbConn.Open();
        }
        catch (Exception ex)
        {
            numColumn = 0;
            Pollinator.Common.Logger.Error("Error occured at " + typeof(ImportExportUltility).Name + " ReadBinaryExcel().:", ex);
            return null;
        }

        DataTable dt = oledbConn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);

        string firstSheetName = "";
        if (dt != null && dt.Rows.Count > 0)
        {
            firstSheetName = dt.Rows[0]["TABLE_NAME"].ToString();
        }

        OleDbCommand cmd = new OleDbCommand();
        OleDbDataAdapter oleda = new OleDbDataAdapter();
        dt = new DataTable();
        cmd.Connection = oledbConn;
        cmd.CommandType = CommandType.Text;
        cmd.CommandText = "SELECT * FROM [" + firstSheetName + "]";
        oleda = new OleDbDataAdapter(cmd);
        oleda.Fill(dt);
        oledbConn.Close();

        numColumn = dt.Columns.Count;

        List<OrginalDataField> listData = new List<OrginalDataField>();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            OrginalDataField rowData = new OrginalDataField();
            rowData.LineNumber = i + 2;
            rowData.ID = GetString(dt.Rows[i][0]);
            rowData.FirstName = GetString(dt.Rows[i][1]);
            rowData.LastName = GetString(dt.Rows[i][2]);
            rowData.OrganizationName = GetString(dt.Rows[i][3]);
            rowData.Website = GetString(dt.Rows[i][4]);
            rowData.PhoneNumber = GetString(dt.Rows[i][5]);
            rowData.Email = GetString(dt.Rows[i][6]);
            rowData.PollinatorType = GetString(dt.Rows[i][7]);
            rowData.OrganizationDescription = GetString(dt.Rows[i][8]);
            rowData.PollinatorSize = GetString(dt.Rows[i][9]);
            rowData.Address = GetString(dt.Rows[i][10]);
            rowData.City = GetString(dt.Rows[i][11]);
            rowData.State = GetString(dt.Rows[i][12]);
            rowData.ZIP = GetString(dt.Rows[i][13]);
            rowData.Country = GetString(dt.Rows[i][14]);
            rowData.Geolocation = GetString(dt.Rows[i][15]);

            listData.Add(rowData);
        }

        return listData;
    }

    private static string GetString(object o)
    {
        if (o == null || o is System.DBNull)
            return string.Empty;

        return o.ToString().Trim();
    }
}
