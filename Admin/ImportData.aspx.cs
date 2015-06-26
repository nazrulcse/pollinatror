using System;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using GeoCoding;
using GeoCoding.Google;
using Pollinator.Common;
using Pollinator.DataAccess;
using System.Web.UI.WebControls;


public partial class Admin_ImportData : System.Web.UI.Page
{
    PollinatorEntities mydb = new PollinatorEntities();
    List<ImportExportFields> listRowOK = new List<ImportExportFields>();
    List<OrginalDataField> listRowFailed = new List<OrginalDataField>();
    byte memberLevel = 0;
    int numFieldOfImportFile = 16;//number column of import file
    string sourceData = "ManualImport";


    #region event click
    /// <summary>
    /// Page load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            btnImport.Attributes.Add("Title", "Click here to start import progress");

            divFailedData.Visible = false;
            divExistedData.Visible = false;
            divImportSuccessful.Visible = false;
            divImportFail.Visible = false;

            //set status navigator bar: current active step = 1(browse file)
            SetStatusNavigationBar(1);
        }
    }

    /// <summary>
    /// Import button clicked
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnImport_Click(object sender, EventArgs e)
    {
        try
        {

            //reset previous state
            lblMess.Text = lblErrorMess.Text = string.Empty;
            listRowOK = new List<ImportExportFields>();
            listRowFailed = new List<OrginalDataField>();
            //User Type
            if (ddlImportedUserType.SelectedValue == "premium")
                memberLevel = 1;

            MemberLevel = memberLevel;

            //Step 0: check import file and get content
            List<OrginalDataField> listOrginalDataField = new List<OrginalDataField>();
            if (!CheckImportFile(out listOrginalDataField))//not select file yet
                return;

            //set status navigator bar: current active step = 2
            SetStatusNavigationBar(2);

            //Step 1: Data Checking
            bool isHaveFailedData = DataChecking(listOrginalDataField);

            //disable button Import to void re-click
            if (listRowOK.Count > 0 || listRowFailed.Count > 0)
            {
                btnImport.Visible = false;
                divStep0.Visible = false;
                //btnImport.Disabled = true;
                //btnImport.Attributes.Add("Title", "Cannot import until there is data availability.");
                //btnImport.Style["cursor"] = "not-allowed";

                //browse file
                importFile.Enabled = false;
            }

            if (isHaveFailedData)
                return;

            //Step 2: Data Correction
            bool isHaveExistedData = DataCorrection();
            if (isHaveExistedData)
                return;
            btnDCorrectionContinue.Attributes["style"] = "";
        }
        catch (Exception ex)
        {
            lblErrorMess.Text = ex.ToString();
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_ImportData).Name + " btnImport_Click().:", ex);
        }
    }

    /// <summary>
    /// 'Skip & Continue' button of Data Checking step clicked
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDCheckingSkipContinue_ServerClick(object sender, EventArgs e)
    {
        //reset status
        lblErrorMess.Text = string.Empty;
        listRowOK = (List<ImportExportFields>)ViewState["listRowOK"];
        listRowFailed = (List<OrginalDataField>)ViewState["listRowFailed"];

        //Finish Step 1(Data Checking) and move to Step 2(Data Correction)
        if (listRowOK.Count == 0)
        {
            lblErrorMess.Text = "There is no valid data to continue import process.";
            //hide btnDCheckingSkipContinue
            btnDCheckingSkipContinue.Attributes["disabled"] = "disabled";
            btnDCheckingSkipContinue.Attributes["title"] = "There is no valid data to continue import process";
            btnDCheckingSkipContinue.Attributes["style"] = "cursor:not-allowed";
            return;
        }

        //lblMess
        ViewState["lblMess"] = string.Format("{0}<span style='color:#e80c4d'> (Skipped)</span>", ViewState["lblMess"].ToString());
        lblMess.Text = ViewState["lblMess"].ToString();

        //finish and cont
        divFailedData.Visible = false;

        btnDCorrectionContinue.Attributes["style"] = "";
        DataCorrection();
    }

    /// <summary>
    /// 'Cancel Import' button of Data Checking step clicked
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDCheckingCancel_ServerClick(object sender, EventArgs e)
    {
        ResetBeginStatus();
    }

    /// <summary>
    /// 'Continue' button of Data Correction step clicked
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDCorrectionContinue_ServerClick(object sender, EventArgs e)
    {
        //reset status
        lblErrorMess.Text = string.Empty;
        listRowOK = (List<ImportExportFields>)ViewState["listRowOK"];
        listRowFailed = (List<OrginalDataField>)ViewState["listRowFailed"];

        if (string.Compare(rblActionForExistedData.SelectedValue, "skip", true) == 0)
        {

            //import and skip existed rows
            var listImport = listRowOK.Where(item => item.IsExistedData == false);
            if (listImport.Count() == 0)
            {
                lblErrorMess.Text = "There is no valid data to continue import process.";
                //GUI of step 2 still show that User can change other action
                divExistedData.Visible = true;
                //hide btnDCorrectionContinue
                btnDCorrectionContinue.Attributes["disabled"] = "disabled";
                btnDCorrectionContinue.Attributes["title"] = "There is no valid data to continue import process";
                btnDCorrectionContinue.Attributes["style"] = "cursor:not-allowed";

            }
            else
            {
                lblMess.Text = string.Format("{0}<span style='color:#FFCC00'> (Skipped)</span>", ViewState["lblMess"].ToString());
                ImportDataIntoDatabase(listRowOK, "skip");
            }
        }
        else if (string.Compare(rblActionForExistedData.SelectedValue, "overwrite", true) == 0)
        {
            lblMess.Text = string.Format("{0}<span style='color:#FFCC00'> (Overwrited)</span>", ViewState["lblMess"].ToString());

            //import all and update value for existed rows
            ImportDataIntoDatabase(listRowOK, "overwrite");
        }
        else
        {
            lblMess.Text = string.Format("{0}<span style='color:#FFCC00'> (New)</span>", ViewState["lblMess"].ToString());
            //import all data as add new
            ImportDataIntoDatabase(listRowOK, "new");
        }
    }

    /// <summary>
    /// 'Cancel Import' button of Data Correction step clicked
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDCorrectionCancel_ServerClick(object sender, EventArgs e)
    {
        ResetBeginStatus();
    }

    /// <summary>
    /// Click here for details(file.csv)
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void lnkExportFailedData_Click(object sender, EventArgs e)
    {
        string fileName = "ImportLog_InvalidData" + System.DateTime.Now.ToString("_MMddyyyy") + ".xlsx";
        listRowFailed = (List<OrginalDataField>)ViewState["listRowFailed"];
        ImportExportUltility.ExportFailedDataExcel(HttpContext.Current.Response, fileName, listRowFailed);
    }

    protected void lnkExportExistedData_Click(object sender, EventArgs e)
    {
        string fileName = "ImportLog_ExistedData" + System.DateTime.Now.ToString("_MMddyyyy") + ".xlsx";
        listRowOK = (List<ImportExportFields>)ViewState["listRowOK"];
        List<ImportExportFields> listExistedData = listRowOK.Where(item => item.IsExistedData == true).ToList();
        ImportExportUltility.ExportExistedDataExcel(HttpContext.Current.Response, fileName, listExistedData);
    }

    /// <summary>
    /// Finish import when successful
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnSuccessfullFinish_ServerClick(object sender, EventArgs e)
    {
        Response.Redirect("~/ShareMap");
    }

    /// <summary>
    /// Finish import when fail
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnFailFinish_ServerClick(object sender, EventArgs e)
    {
        ResetBeginStatus();
    }

    /// <summary>
    /// Retry import when fail
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnFailFReTry_ServerClick(object sender, EventArgs e)
    {
        this.divImportFail.Visible = false;
        listRowOK = (List<ImportExportFields>)ViewState["listRowOK"];
        if (string.Compare(rblActionForExistedData.SelectedValue, "skip", true) == 0)
        {
            ImportDataIntoDatabase(listRowOK, "skip");
        }
        else if (string.Compare(rblActionForExistedData.SelectedValue, "overwrite", true) == 0)
        {
            //import all and update value for existed rows
            ImportDataIntoDatabase(listRowOK, "overwrite");
        }
        else
        {
            //import all data as add new
            ImportDataIntoDatabase(listRowOK, "new");
        }
    }

    #endregion


    private bool CheckImportFile(out List<OrginalDataField> listOrginalDataField)
    {
        listOrginalDataField = new List<OrginalDataField>();
        //check: has file
        if (importFile.HasFile)
        {
            //check: file not allow empty, num of collumn(>1)
            try
            {
                string uploadFolder = System.Configuration.ConfigurationManager.AppSettings["FolderPath"];
                string sDirPath = Request.PhysicalApplicationPath + uploadFolder;
                string uploadPath = sDirPath + "\\" + importFile.FileName;
                importFile.SaveAs(uploadPath);//store to server

                int numFieldOfCurrentFile = 0;//number fields of file

                System.IO.FileInfo file = new System.IO.FileInfo(uploadPath);
                string typeFile = file.Extension;//type of file
                if (string.Compare(typeFile, ".csv", true) == 0)//read data csv
                {
                    listOrginalDataField = ImportExportUltility.ReadCsv(uploadPath, out numFieldOfCurrentFile);
                }
                else//read data excel
                {
                    numFieldOfCurrentFile = 0;
                    listOrginalDataField = ImportExportUltility.ReadExcel(uploadPath, file, out numFieldOfCurrentFile);
                }

                //Remove uploaded file
                File.Delete(uploadPath);

                //check
                int numDataRecord = 0;
                if (listOrginalDataField != null)
                {
                    numDataRecord = listOrginalDataField.Count;
                    if (numFieldOfCurrentFile > numFieldOfImportFile)
                    {
                        lblErrorMess.Text = "There are too many columns in the your import file. Please recheck.";
                        return false;
                    }
                    else if (numFieldOfCurrentFile < numFieldOfImportFile)
                    {
                        lblErrorMess.Text = "There are too few columns in the your import file. Please recheck.";
                        return false;
                    }
                    else if (numDataRecord == 0)
                    {
                        lblErrorMess.Text = "There is no data for import. Please recheck.";
                        return false;
                    }
                }
                else
                {
                    lblErrorMess.Text = "There is no data for import. Please recheck.";
                    return false;
                }

                //lblMess
                if (ViewState["lblMess"] != null)
                {
                    string lblMessText = string.Format("File: {0} ({1} Kb)"
                        , importFile.PostedFile.FileName, importFile.PostedFile.ContentLength);
                    ViewState["lblMess"] = lblMessText;
                }
                else
                {
                    string lblMessText = string.Format("File name: {0} ({1} Kb)"
                        , importFile.PostedFile.FileName, importFile.PostedFile.ContentLength);

                    ViewState.Add("lblMess", lblMessText);
                }

                lblMess.Text = ViewState["lblMess"].ToString();

                return true;
            }
            catch (Exception ex)
            {
                lblErrorMess.Text = "ERROR: " + ex.Message.ToString();
                Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_ImportData).Name + " CheckImportFile(). ", ex);
                return false;
            }
        }
        else
        {
            lblMess.Text = "You have not specified a file.";
            return false;
        }
    }



    /// <summary>
    /// Data Checking
    /// </summary>
    /// <param name="lines"></param>
    /// <returns></returns>
    private bool DataChecking(List<OrginalDataField> listOrginalDataField)
    {
        //GUI show/hide
        bool isHaveFailedData = false;

        //get Type
        var listPTypeTemp = mydb.PollinatorTypes.ToList();
        List<DataItem> listPType = new List<DataItem>();
        foreach (var item in listPTypeTemp)
            listPType.Add(new DataItem { ID = item.ID.ToString(), Name = item.Name });
        //get size
        var listPSizeTemp = mydb.PollinatorSizes.ToList();
        List<DataItem> listPSize = new List<DataItem>();
        foreach (var item in listPSizeTemp)
            listPSize.Add(new DataItem { ID = item.ID.ToString(), Name = item.Name });
        //get country
        var listCountry = (from ps in mydb.Countries
                           select new DataItem { ID = ps.ID, Name = ps.Name }).ToList();

        //check
        int totalNumberRecord = listOrginalDataField.Count;
        foreach (var item in listOrginalDataField)
            GetDataFromLineString(item, listPType, listPSize, listCountry);

        //set viewstate
        if (ViewState["listRowOK"] != null)
            ViewState["listRowOK"] = listRowOK;
        else
            ViewState.Add("listRowOK", listRowOK);
        //listRowFailed
        if (ViewState["listRowFailed"] != null)
            ViewState["listRowFailed"] = listRowFailed;
        else
            ViewState.Add("listRowFailed", listRowFailed);

        //lblMess
        ViewState["lblMess"] = string.Format("{0}<br><span class='step'>1</span> Total data records: {1}<br><span style='color:#e80c4d'><span class='step'>2</span> Invalid records: {2}</span>", ViewState["lblMess"].ToString()
            , totalNumberRecord, listRowFailed.Count);
        lblMess.Text = ViewState["lblMess"].ToString();

        //show result
        TotalInvalidRecord = listRowFailed.Count;
        TotalRecord = totalNumberRecord;
        if (listRowFailed.Count > 0)
        {
            isHaveFailedData = true;//result status

            divFailedData.Visible = true;
            //lblNumRowFailed.Text = listRowFailed.Count.ToString() + " rows";

            //bind
            gvFailedData.DataSource = listRowFailed;
            gvFailedData.DataBind();
        }

        return isHaveFailedData;
    }

    /// <summary>
    /// Data Correction
    /// </summary>
    /// <returns></returns>
    private bool DataCorrection()
    {
        bool isHaveExistedData = false;
        foreach (var item in listRowOK)
        {

            if (item.UserId != Guid.Empty)//Check UserID
            {
                if (mydb.PolinatorInformations.Any(o => o.UserId == item.UserId)) //check existed
                {
                    isHaveExistedData = true;
                    //set status
                    item.IsExistedData = true;
                    item.ExistedUserId = item.UserId;
                    item.ExistedDataDescription = "Pollinator with same ID already exists in system.";
                }
                else
                {
                    //First Name, Organization Name, Address
                    var userPollinator = (from ud in mydb.UserDetails
                                          join pi in mydb.PolinatorInformations on ud.UserId equals pi.UserId
                                          where string.Compare(ud.FirstName, item.FirstName, true) == 0
                                          && string.Compare(pi.OrganizationName, item.OrganizationName, true) == 0
                                          && (string.Compare(pi.LandscapeStreet, item.LandscapeStreet, true) == 0 && string.Compare(pi.LandscapeCity, item.LandscapeCity, true) == 0 && string.Compare(pi.LandscapeState, item.LandscapeState, true) == 0)
                                          select new { UserId = ud.UserId });
                    if (userPollinator != null && userPollinator.Count() > 0)
                    {
                        isHaveExistedData = true;
                        //set current GuiID
                        item.IsExistedData = true;
                        item.ExistedUserId = userPollinator.First().UserId;
                        item.ExistedDataDescription = "Pollinator with same First Name, Organization Name and Address already exists in system.";
                    }
                }//end check case 2
            }//end check case 1
            else
            {
                //First Name, Organization Name, Address
                var userPollinator = (from ud in mydb.UserDetails
                                      join pi in mydb.PolinatorInformations on ud.UserId equals pi.UserId
                                      where string.Compare(ud.FirstName, item.FirstName, true) == 0
                                      && string.Compare(pi.OrganizationName, item.OrganizationName, true) == 0
                                      && (string.Compare(pi.LandscapeStreet, item.LandscapeStreet, true) == 0 && string.Compare(pi.LandscapeCity, item.LandscapeCity, true) == 0 && string.Compare(pi.LandscapeState, item.LandscapeState, true) == 0)
                                      select new { UserId = ud.UserId });
                if (userPollinator != null && userPollinator.Count() > 0)
                {
                    isHaveExistedData = true;
                    //set current GuiID
                    item.IsExistedData = true;
                    item.ExistedUserId = userPollinator.First().UserId;
                    item.ExistedDataDescription = "Pollinator with same First Name, Organization Name and Address already exists in system.";
                }
            }//end check case 2
        }

        //set viewstate
        ViewState["listRowOK"] = listRowOK;



        //show result
        if (isHaveExistedData)//have existed data
        {
            divExistedData.Visible = true;

            //bind
            var listExistedData = listRowOK.Where(item => item.IsExistedData == true);
            //lblNumRowExisted.Text = listExistedData.Count().ToString() + " rows";
            //lblMess
            int rowOK = listRowOK.Count - listExistedData.Count();
            ViewState["lblMess"] = string.Format("{0} <br><span style='color:#FFCC00'><span class='step'>3</span> Records already exist: {1} (See confirm list below)</span>", ViewState["lblMess"].ToString(), listExistedData.Count());
            lblMess.Text = ViewState["lblMess"].ToString();

            gvExistedData.DataSource = listExistedData;
            gvExistedData.DataBind();
        }
        else
            ImportDataIntoDatabase(listRowOK, null);//there are no any have existed data -->move final step(perform import to sql)

        return isHaveExistedData;
    }

    /// <summary>
    /// Check csv input file
    /// </summary>
    /// <param name="filePath"></param>
    /// <returns></returns>


    /// <summary>
    /// Reset form as begin status
    /// </summary>
    private void ResetBeginStatus()
    {
        //set status navigator bar: current active step = 1(browse file)
        SetStatusNavigationBar(1);

        //step 0: show
        //btnImport button
        lblMess.Visible = true;
        lblMess.Text = "";
        btnImport.Visible = true;
        divStep0.Visible = true;
        //btnImport.Disabled = false;
        //btnImport.Attributes.Add("Title", "Click to start import progress");
        //btnImport.Style["cursor"] = "";

        //browse file
        ddlImportedUserType.SelectedIndex = 0;
        importFile.Enabled = true;
        lblMess.Text = lblErrorMess.Text = string.Empty;

        //step 1, 2, 3: hidden
        divFailedData.Visible = false;
        divExistedData.Visible = false;
        divImportSuccessful.Visible = false;
        divImportFail.Visible = false;

        //reset datasource
        listRowOK.Clear();
        listRowFailed.Clear();
        if (ViewState["listRowOK"] != null)
        {
            ViewState.Remove("listRowOK");
            ViewState.Remove("listRowFailed");
            ViewState.Remove("lblMess");
        }
    }

    /// <summary>
    /// Get Data From LineString
    /// </summary>
    /// <param name="lineContent"></param>
    /// <param name="lineNumber"></param>
    private void GetDataFromLineString(OrginalDataField orginalDataField, List<DataItem> listPType, List<DataItem> listPSize, List<DataItem> listCountry)
    {
        try
        {
            //parse line
            //string[] valueOffields = ImportExportUltility.GetCsvRecord(lineContent);//input line and return value of fields of that line

            //set value field
            string errorDescriptionRow = string.Empty;
            string errorDescriptionField = string.Empty;
            bool fieldOK = true;
            bool rowOK = true;
            string itemID = string.Empty;

            //create a new datarow
            ImportExportFields dataRow = new ImportExportFields();
            dataRow.LineNumber = orginalDataField.LineNumber;//0
            dataRow.Premium = memberLevel;
            dataRow.isApproved = 1;

            //ID
            if (!string.IsNullOrEmpty(orginalDataField.ID))
            {
                fieldOK = CheckValidateField(orginalDataField.ID, "ID", "Guid", false, 0, -1, null, null, out itemID, out errorDescriptionField);
                if (fieldOK)
                    dataRow.UserId = new Guid(orginalDataField.ID);//1
                else
                {
                    rowOK = false;
                    errorDescriptionRow += errorDescriptionField;
                }
            }

            //FirstName
            fieldOK = CheckValidateField(orginalDataField.FirstName, "First Name", null, true, 0, 100, @"[^{}]*", null, out itemID, out errorDescriptionField);
            if (fieldOK)
                dataRow.FirstName = orginalDataField.FirstName;//csv field 1
            else
            {
                rowOK = false;
                errorDescriptionRow += errorDescriptionField;
            }

            //LastName
            fieldOK = CheckValidateField(orginalDataField.LastName, "Last Name", null, false, 0, 60, null, null, out itemID, out errorDescriptionField);
            if (fieldOK)
                dataRow.LastName = orginalDataField.LastName;//csv field 2
            else
            {
                rowOK = false;
                errorDescriptionRow += errorDescriptionField;
            }

            //csv field OrganizationName
            fieldOK = CheckValidateField(orginalDataField.OrganizationName, "Organization Name", null, true, 0, 100, null, null, out itemID, out errorDescriptionField);
            if (fieldOK)
                dataRow.OrganizationName = orginalDataField.OrganizationName;//csv field 3
            else
            {
                rowOK = false;
                errorDescriptionRow += errorDescriptionField;
            }

            //Website
            fieldOK = CheckValidateField(orginalDataField.Website, "Website", null, false, 0, 255, @"(http(s)?://)?([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?", null, out itemID, out errorDescriptionField);
            if (fieldOK)
                dataRow.Website = orginalDataField.Website;//csv field 4
            else
            {
                rowOK = false;
                errorDescriptionRow += errorDescriptionField;
            }

            //PhoneNumber
            fieldOK = CheckValidateField(orginalDataField.PhoneNumber, "Phone Number", null, false, 0, 24, @"([()\d+-.\s])*", null, out itemID, out errorDescriptionField);
            if (fieldOK)
                dataRow.PhoneNumber = orginalDataField.PhoneNumber;//csv field 5
            else
            {
                rowOK = false;
                errorDescriptionRow += errorDescriptionField;
            }

            //Email
            fieldOK = CheckValidateField(orginalDataField.Email, "Email", null, false, 0, 256, @"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*", null, out itemID, out errorDescriptionField);
            if (fieldOK)
                dataRow.Email = orginalDataField.Email;//csv field 6
            else
            {
                rowOK = false;
                errorDescriptionRow += errorDescriptionField;
            }

            //PollinatorType
            fieldOK = CheckValidateField(orginalDataField.PollinatorType, "Type of Pollinator", null, false, 0, 30, null, listPType, out itemID, out errorDescriptionField);
            if (fieldOK)
            {
                dataRow.PollinatorTypeName = orginalDataField.PollinatorType;//csv field 7
                if (!string.IsNullOrEmpty(itemID))
                    dataRow.PollinatorType = Int32.Parse(itemID);
                else
                    dataRow.PollinatorType = 0;
            }
            else
            {
                rowOK = false;
                errorDescriptionRow += errorDescriptionField;
            }

            //OrganizationDescription
            fieldOK = CheckValidateField(orginalDataField.OrganizationDescription, "Organization Description", null, false, 0, -1, null, null, out itemID, out errorDescriptionField);
            if (fieldOK)
                dataRow.OrganizationDescription = orginalDataField.OrganizationDescription;//csv field 8
            else
            {
                rowOK = false;
                errorDescriptionRow += errorDescriptionField;
            }

            //PollinatorSize
            fieldOK = CheckValidateField(orginalDataField.PollinatorSize, "Size of Pollinator Location", null, false, 0, 60, null, listPSize, out itemID, out errorDescriptionField);
            if (fieldOK)
            {
                dataRow.PollinatorSizeName = orginalDataField.PollinatorSize;//csv field 9
                if (!string.IsNullOrEmpty(itemID))
                    dataRow.PollinatorSize = Int32.Parse(itemID);
                else
                    dataRow.PollinatorSize = 9;//Other               
            }
            else
            {
                rowOK = false;
                errorDescriptionRow += errorDescriptionField;
            }

            //check Address(Street, City, State)
            if (string.IsNullOrEmpty(orginalDataField.Address) && string.IsNullOrEmpty(orginalDataField.City) && string.IsNullOrEmpty(orginalDataField.State))
            {
                rowOK = false;
                errorDescriptionField += string.Format("<br> - {0}", "Address (or City/State) is required");
                errorDescriptionRow += errorDescriptionField;
            }
            else
            {
                //Address
                fieldOK = CheckValidateField(orginalDataField.Address, "Address", null, false, 0, 100, null, null, out itemID, out errorDescriptionField);
                if (fieldOK)
                    dataRow.LandscapeStreet = orginalDataField.Address;//csv field 10
                else
                {
                    rowOK = false;
                    errorDescriptionRow += errorDescriptionField;
                }

                //City
                fieldOK = CheckValidateField(orginalDataField.City, "City", null, false, 0, 50, null, null, out itemID, out errorDescriptionField);
                if (fieldOK)
                    dataRow.LandscapeCity = orginalDataField.City;//csv field 11
                else
                {
                    rowOK = false;
                    errorDescriptionRow += errorDescriptionField;
                }

                //State
                fieldOK = CheckValidateField(orginalDataField.State, "State", null, false, 0, 30, null, null, out itemID, out errorDescriptionField);
                if (fieldOK)
                    dataRow.LandscapeState = orginalDataField.State;//csv field 12
                else
                {
                    rowOK = false;
                    errorDescriptionRow += errorDescriptionField;
                }
            }

            
            //ZIP
            fieldOK = CheckValidateField(orginalDataField.ZIP, "ZIP", null, false, 0, 15, @"[A-Za-z0-9\s-]*", null, out itemID, out errorDescriptionField);
            if (fieldOK)
                dataRow.LandscapeZipcode = orginalDataField.ZIP;//csv field 13
            else
            {
                rowOK = false;
                errorDescriptionRow += errorDescriptionField;
            }

            //Country
            fieldOK = CheckValidateField(orginalDataField.Country, "Country", null, false, 0, 100, null, listCountry, out itemID, out errorDescriptionField);
            if (fieldOK)
            {
                dataRow.LandscapeCountryName = orginalDataField.Country;//csv field 14
                dataRow.LandscapeCountry = itemID;
            }
            else
            {
                rowOK = false;
                errorDescriptionRow += errorDescriptionField;
            }



            //Geolocation(lat;lng)
            if (!string.IsNullOrEmpty(orginalDataField.Geolocation) && orginalDataField.Geolocation.Contains(';'))
            {
                dataRow.Geolocation = orginalDataField.Geolocation;
                string[] geolocation = orginalDataField.Geolocation.Split(new string[] { ";" }, StringSplitOptions.None);
                if (geolocation.Length == 2)
                {
                    string latitude = geolocation[0].Trim();
                    string longitude = geolocation[1].Trim();

                    //latitude
                    fieldOK = CheckValidateField(latitude, "Latitude of Geolocation", "decimal", true, 0, 18, null, null, out itemID, out errorDescriptionField);
                    if (fieldOK)
                        dataRow.Latitude = decimal.Parse(latitude);
                    else
                    {
                        rowOK = false;
                        errorDescriptionRow += errorDescriptionField;
                    }

                    //Longitude
                    fieldOK = CheckValidateField(latitude, "Longitude of Geolocation", "decimal", true, 0, 18, null, null, out itemID, out errorDescriptionField);
                    if (fieldOK)
                        dataRow.Longitude = decimal.Parse(longitude);
                    else
                    {
                        rowOK = false;
                        errorDescriptionRow += errorDescriptionField;
                    }
                }
            }


            //row is OK-> add to list OK
            if (rowOK)
                listRowOK.Add(dataRow);//add to list row OK
            else//row is failed -> add to list
            {
                OrginalDataField dataRowFailed = new OrginalDataField();
                dataRowFailed.LineNumber = orginalDataField.LineNumber;//0
                dataRowFailed.ErrorDescription = errorDescriptionRow.Substring(4);//error

                dataRowFailed.ID = orginalDataField.ID;
                dataRowFailed.FirstName = orginalDataField.FirstName;
                dataRowFailed.LastName = orginalDataField.LastName;
                dataRowFailed.OrganizationName = orginalDataField.OrganizationName;
                dataRowFailed.Website = orginalDataField.Website;
                dataRowFailed.PhoneNumber = orginalDataField.PhoneNumber;
                dataRowFailed.Email = orginalDataField.Email;
                dataRowFailed.PollinatorType = orginalDataField.PollinatorType;
                dataRowFailed.OrganizationDescription = orginalDataField.OrganizationDescription;
                dataRowFailed.PollinatorSize = orginalDataField.PollinatorSize;
                dataRowFailed.Address = orginalDataField.Address;
                dataRowFailed.City = orginalDataField.City;
                dataRowFailed.State = orginalDataField.State;
                dataRowFailed.ZIP = orginalDataField.ZIP;
                dataRowFailed.Country = orginalDataField.Country;
                dataRowFailed.Geolocation = orginalDataField.Geolocation;

                //add to list failed rows
                listRowFailed.Add(dataRowFailed);
            }

        }
        catch (Exception ex)
        {
            lblErrorMess.Text = ex.Message;
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Admin_ImportData).Name + " GetDataFromLineString(). ", ex);
        }

    }

    /// <summary>
    /// Check Validate Field
    /// </summary>
    /// <param name="value"></param>
    /// <param name="fieldName"></param>
    /// <param name="dataType"></param>
    /// <param name="required"></param>
    /// <param name="minLength"></param>
    /// <param name="maxLength"></param>
    /// <param name="regularExpressions"></param>
    /// <param name="errorDescription"></param>
    /// <returns></returns>
    private bool CheckValidateField(string value, string fieldName, string dataType, bool required, int minLength, int maxLength, string regularExpPattern, List<DataItem> listDataItem, out string itemID, out string errorDescription)
    {
        bool result = true;
        errorDescription = string.Empty;
        itemID = string.Empty;

        //Case 1: required
        if (required && string.IsNullOrEmpty(value))
        {
            result = false;
            errorDescription += string.Format("<br> -'{0}': {1}", fieldName, "data column is empty");
        }
        else if (!string.IsNullOrEmpty(value))
        {//only validate if not empty
            //Case check input name match with a item from list data
            if (listDataItem != null) //check existed
            {
                var itemData = listDataItem.SingleOrDefault(o => string.Compare(o.Name, value, true) == 0);
                if (itemData != null)
                    itemID = itemData.ID;//out 
                else
                {
                    result = false;
                    errorDescription += string.Format("<br> -'{0}': {1}", fieldName, " not match any item in existing system.");
                }
            }

            //Case 2: Data type
            else if (!string.IsNullOrEmpty(dataType))//default data type is string
            {
                try
                {
                    object valueConvertedType;
                    if (dataType == "Guid")
                        valueConvertedType = new Guid(value);
                    else if (dataType == "Int32")
                        valueConvertedType = Int32.Parse(value);
                }
                catch (Exception ex)
                {
                    result = false;
                    errorDescription += string.Format("<br> - '{0}': {1}", fieldName, ex.Message);
                }
            }

            //Case 3: Data length(note: maxlength = -1 is nvarchar(max))
            else if ((value.Length < minLength || value.Length > maxLength) && maxLength != -1)
            {
                result = false;
                errorDescription += string.Format("<br> - '{0}': {1}", fieldName, "Maximum data length exceeded(Maximum length is " + maxLength + ")");
            }

            //Case 4: regularExpressions
            else if (!string.IsNullOrEmpty(regularExpPattern) && !string.IsNullOrEmpty(value))
            {
                Regex regex = new Regex(regularExpPattern);
                Match match = regex.Match(value);
                if (!match.Success || (match.Success && match.Value != value))
                {
                    result = false;
                    errorDescription += string.Format("<br> - '{0}': {1}", fieldName, "invalid data");
                }
            }
        }



        return result;
    }


    /// <summary>
    /// Get ID of Item by Name
    /// Use to get ID of PollinatorType, PollinatorSize, Country
    /// </summary>
    /// <param name="name"></param>
    /// <param name="listDataItem"></param>
    /// <returns></returns>
    private string GetItemIDByName(string name, List<DataItem> listDataItem)
    {
        if (!string.IsNullOrEmpty(name))
        {
            DataItem item = listDataItem.Single(o => string.Compare(o.Name, name, true) == 0);
            if (item == null)
                return null;
            return item.ID;
        }
        else
            return string.Empty;
    }

    /// <summary>
    /// Final step, Import Data Into Database
    /// </summary>
    /// <param name="listRowImport">list needed import</param>
    /// <param name="actionForExistedData">3 option: skip, new, overwrite. default is null(new)</param>
    /// Create by: Hoai Phuong
    private void ImportDataIntoDatabase(List<ImportExportFields> listRowImport, string actionForExistedData = null)
    {
        //set status navigator bar: current active step = 3(import)
        SetStatusNavigationBar(3);

        //show please wait... popup
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "popupWait", "document.getElementById('showProcessbar').click();", true);
        //lblErrorMess.Text = "Đang import vào sql db...";
        divExistedData.Visible = false;

        memberLevel = MemberLevel;

        DateTime createdDate = DateTime.Now;
        ImportExportFields writedata;
        Membership userDB;
        UserDetail userDetail;
        PolinatorInformation polinatorInformation;

        Guid userId;
        int numImport = 0;
        int numSkipExist = 0;

        List<string> listAddUserName = new List<string>();

        int numRecord = listRowImport.Count;
        for (int i = 0; i < numRecord; i++)
        {
            writedata = listRowImport.ElementAt(i);


            userDetail = new UserDetail();
            polinatorInformation = new PolinatorInformation();

            if (writedata.IsExistedData && actionForExistedData == "skip")
            {
                numSkipExist++;
                continue;
            }
            numImport++;
            if (!writedata.IsExistedData || actionForExistedData == "new")
            {
                if (!string.IsNullOrEmpty(writedata.Email))
                {
                    //generate new user
                    //auto gen UserName, Password

                    string userName = Utility.CreateRandomUserName(0);
                    string password = Utility.CreateRandomPassword(10);
                    listAddUserName.Add(userName);
                    //Exec create
                    userId = (Guid)System.Web.Security.Membership.CreateUser(userName, password, writedata.Email).ProviderUserKey;

                }
                else
                    userId = Guid.NewGuid();
            }
            else
            {
                //if (writedata.UserId != Guid.Empty)
                //    userId = writedata.UserId;
                //else

                userId = writedata.ExistedUserId;
                if (!string.IsNullOrEmpty(writedata.Email))
                {
                    userDB = (from us in mydb.Memberships
                              where us.UserId == userId
                              select us).FirstOrDefault();
                    userDB.Email = writedata.Email;
                }

                userDetail = (from ud in mydb.UserDetails
                              where ud.UserId == userId
                              select ud).FirstOrDefault();

                polinatorInformation = (from pi in mydb.PolinatorInformations
                                        where pi.UserId == userId
                                        select pi).FirstOrDefault();
            }

            userDetail.UserId = userId;
            userDetail.FirstName = writedata.FirstName;
            userDetail.LastName = writedata.LastName;
            userDetail.MembershipLevel = memberLevel;
            userDetail.PhoneNumber = writedata.PhoneNumber;

            //Table 2: polinatorInformation
            polinatorInformation.UserId = userId;

            polinatorInformation.OrganizationName = writedata.OrganizationName;
            polinatorInformation.Description = writedata.OrganizationDescription;
            polinatorInformation.PollinatorSize = writedata.PollinatorSize;
            polinatorInformation.PollinatorType = writedata.PollinatorType;
            polinatorInformation.LandscapeStreet = writedata.LandscapeStreet;
            polinatorInformation.LandscapeCity = writedata.LandscapeCity;
            polinatorInformation.LandscapeState = writedata.LandscapeState;
            polinatorInformation.LandscapeZipcode = writedata.LandscapeZipcode;
            polinatorInformation.LandscapeCountry = writedata.LandscapeCountry;
            polinatorInformation.Website = writedata.Website;

            polinatorInformation.IsApproved = true;
            polinatorInformation.IsNew = false;
            polinatorInformation.CreatedDate = createdDate;
            polinatorInformation.LastUpdated = createdDate;

            if (writedata.Latitude.HasValue && writedata.Longitude.HasValue)
            {
                polinatorInformation.Latitude = (decimal)writedata.Latitude;
                polinatorInformation.Longitude = (decimal)writedata.Longitude;
            }
            else
            {
                SetLalngByAddress(writedata, polinatorInformation);
            }

            polinatorInformation.SourceData = sourceData;

            if (!writedata.IsExistedData || actionForExistedData == "new")
            {
                mydb.UserDetails.Add(userDetail);
                mydb.PolinatorInformations.Add(polinatorInformation);
            }
        }

        try
        {
            mydb.SaveChanges();

            //show successfully panel
            lblMess.Visible = false;
            this.divImportSuccessful.Visible = true;
            this.lblTotalDataRecord.Text = TotalRecord.ToString();
            this.lblNumImported.Text = numImport.ToString();
            this.lblNumNotImported.Text = (TotalInvalidRecord + numSkipExist).ToString();
            this.lblNumInvalid.Text = TotalInvalidRecord.ToString();
            this.lblNumSkipExist.Text = numSkipExist.ToString();

            //show/hide link download log file
            if (TotalInvalidRecord == 0)
                lnkFinishInvalidLog.Visible = false;
            else lnkFinishInvalidLog.Visible = true;

            if (numSkipExist == 0)
                lnkFinishSkipLog.Visible = false;
            else lnkFinishSkipLog.Visible = true;

            //Write log
            var logContent = new StringBuilder();
            logContent.Append(string.Format("Total data records: {0}{1}", TotalRecord.ToString(), Environment.NewLine));
            logContent.Append(string.Format("Records imported: {0}{1}", numImport.ToString(), Environment.NewLine));
            logContent.Append(string.Format("Records ignored: {0}{1}", (TotalInvalidRecord + numSkipExist).ToString(), Environment.NewLine));
            logContent.Append(string.Format(" - Invalid records: {0}{1}", TotalInvalidRecord.ToString(), Environment.NewLine));
            logContent.Append(string.Format(" - Manually skipped: {0}{1}", numSkipExist.ToString(), Environment.NewLine));

            string fileName = "ImportSuccessful" + System.DateTime.Now.ToString("_yyMMdd_hhmm") + ".txt";
            ImportExportUltility.WriteFile(Request, fileName, logContent.ToString());

            //set status navigator bar: current active step = 3(Finish)
            SetStatusNavigationBar(4);
        }
        catch (Exception e)
        {
            //Delete added udername
            try
            {
                for (int i = 0; i < listAddUserName.Count; i++)
                {
                    System.Web.Security.Membership.DeleteUser(listAddUserName[i]);
                }
            }
            catch
            {
            }
            //Write log fie
            WriteImportFailLog(e);

            SetStatusNavigationBar(4);
            //show error panel
            this.divImportFail.Visible = true;
        }

    }

    private static void SetLalngByAddress(ImportExportFields writedata, PolinatorInformation polinatorInformation)
    {
        string physicalLocation;
        GoogleGeoCoder geoCoder = new GoogleGeoCoder();
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
            }

        }
        if (matchAddress != null && matchAddress.Length > 0)
        {
            polinatorInformation.Latitude = (decimal)matchAddress[0].Coordinates.Latitude;
            polinatorInformation.Longitude = (decimal)matchAddress[0].Coordinates.Longitude;
            if (matchAddress.Length > 1)
                polinatorInformation.FuzyLocation = true;

        }
    }

    private void WriteImportFailLog(Exception e)
    {
        var errorLog = new StringBuilder();
        string newLine;
        if (e is DbEntityValidationException)
        {
            foreach (var eve in ((DbEntityValidationException)e).EntityValidationErrors)
            {
                newLine = string.Format("Entity of type \"{0}\" in state \"{1}\" has the following validation errors:{2}",
                                                 eve.Entry.Entity.GetType().Name, eve.Entry.State, Environment.NewLine);
                errorLog.Append(newLine);
                foreach (var ve in eve.ValidationErrors)
                {
                    newLine = string.Format("- Property: \"{0}\", Error: \"{1}\" {2}",
                                                ve.PropertyName, ve.ErrorMessage, Environment.NewLine);
                    errorLog.Append(newLine);
                }
            }
        }
        else
        {
            errorLog.Append(e.ToString());
        }

        string fileName = "Importfail" + System.DateTime.Now.ToString("_yyMMdd_hhmm") + ".txt";
        string fileUrl = ImportExportUltility.WriteFile(Request, fileName, errorLog.ToString());
        this.linErrorLog.NavigateUrl = fileUrl;
    }

    public byte MemberLevel
    {
        get
        {
            if (ViewState["memberLevel"] != null)
                return (byte)ViewState["memberLevel"];
            else
                return 0;
        }
        set
        {
            ViewState["memberLevel"] = value;
        }
    }

    public int TotalRecord
    {
        get
        {
            if (ViewState["TotalRecord"] != null)
                return (int)ViewState["TotalRecord"];
            else
                return 0;
        }
        set
        {
            ViewState["TotalRecord"] = value;
        }
    }

    public int TotalInvalidRecord
    {
        get
        {
            if ((int)ViewState["TotalInvalidRecord"] != null)
                return (int)ViewState["TotalInvalidRecord"];
            else
                return 0;
        }
        set
        {
            ViewState["TotalInvalidRecord"] = value;
        }
    }



    /// <summary>
    /// show text of fields on gridview. Only show maximum 100 char and show full text when tootip
    /// </summary>
    /// <param name="orginalText"></param>
    /// <returns></returns>
    protected string ShowText(string orginalText)
    {
        string text = orginalText;
        if (!String.IsNullOrEmpty(orginalText) && orginalText.Length > 100)
            text = orginalText.Substring(0, 100) + "...";
        return Server.HtmlEncode(text);
    }

    /// <summary>
    /// Set Status of Navigation Bar
    /// </summary>
    /// <param name="currentActiveStep">have 4 step: 1(browse file), 2(data verification), 3(import), 4(finish)</param>
    private void SetStatusNavigationBar(int currentActiveStep)
    {
        switch (currentActiveStep)
        {
            case 2:
                astep1.Attributes["class"] = "";
                astep2.Attributes["class"] = "active";
                astep3.Attributes["class"] = "";
                astep4.Attributes["class"] = "";
                break;
            case 3:
                astep1.Attributes["class"] = "";
                astep2.Attributes["class"] = "";
                astep3.Attributes["class"] = "active";
                astep4.Attributes["class"] = "";
                break;
            case 4:
                astep1.Attributes["class"] = "";
                astep2.Attributes["class"] = "";
                astep3.Attributes["class"] = "";
                astep4.Attributes["class"] = "active";
                break;
            default:
                astep1.Attributes["class"] = "active";
                astep2.Attributes["class"] = "";
                astep3.Attributes["class"] = "";
                astep4.Attributes["class"] = "";
                break;
        }

    }
}