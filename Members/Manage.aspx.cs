using Pollinator.Common;
using Pollinator.DataAccess;
using System;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

public partial class Members_Manage : System.Web.UI.Page
{
    PollinatorEntities mydb = new PollinatorEntities();
    #region Events
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            //try
            //{
                if (!Context.User.Identity.IsAuthenticated || !Roles.IsUserInRole(Utility.RoleName.Members.ToString()))
                    Response.Redirect("~/ShareMap.aspx");

                //paypal completed
                if (Request.Params["payer"] != null)
                {
                    //get UserID to delete TempUserPayment table
                    Guid payUserID = new Guid(Request.Params["payer"].ToString());
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "document.getElementById('confirm_pop').click();", true);
                }

                //user
                MembershipUser usr = System.Web.Security.Membership.GetUser(UserID);

                //userdetail
                var userDetail = GetUserDetail();
                if (userDetail == null)
                    Response.Redirect("~/ShareMap.aspx");

                var polinatorInformation = GetPolinatorInformation();
                if (polinatorInformation == null)
                    Response.Redirect("~/ShareMap.aspx");

                string userFolder = String.Empty;

                //get userFolder
                //  string userFolder = Context.User.Identity.Name;
                //  if (polinatorInformation.PhotoUrl != null)
                 // {
                   //   int index = polinatorInformation.PhotoUrl.LastIndexOf("/");
                   //   if (index > -1)
                   //   {
                   //       string tempUrl = polinatorInformation.PhotoUrl.Substring(0, index);
                   //       index = tempUrl.LastIndexOf("/");
                   //       if (index > -1)
                   //          userFolder = tempUrl.Substring(index + 1);
                   //   }
                 // }
                  //this.mulUpload.UserFolder = userFolder;
                //this.mulUploadVideo.UserFolder = userFolder+"video";

                //this.mulUpload.UserID = polinatorInformation.UserId;
                //this.mulUploadVideo.UserID = polinatorInformation.UserId;

                if (polinatorInformation.PhotoUrl != null)
                {
                    userFolder = getUserFolder(polinatorInformation.PhotoUrl);
                }

                if (string.IsNullOrEmpty(userFolder))
                    userFolder = UserName;
                if (string.IsNullOrEmpty(userFolder))
                    userFolder = UserID.ToString();

                this.mulUploadImage.UserFolder = userFolder;
                this.mulUploadImage.PhotoUrl = polinatorInformation.PhotoUrl;
                this.mulUploadImage.UserID = polinatorInformation.UserId;

                this.mulUploadVideo.UserFolder = userFolder + "video";
                this.mulUploadVideo.YoutubeUrl = polinatorInformation.YoutubeUrl;
                this.mulUploadVideo.UserID = polinatorInformation.UserId;
         

                //set UserFolder for single upload
                HiddenUploadUserFolder_Photo.Value = userFolder;
                HiddenUploadUserFolder_Video.Value = userFolder + "video";

                //Go Premium
                if (Request.Params["goPre"] != null && Request.Params["goPre"].ToString() == "1")
                {
                    HiddenMemberLevel.Value = "1";
                    btnPreUpdate.InnerText = "Upgrade";
                }

                //fill data into form
                if (userDetail.MembershipLevel > 0 || HiddenMemberLevel.Value == "1")
                    LoadDataToFormPremium(usr, userDetail, polinatorInformation);
                else
                {
                    LoadDataToFormNormal(usr, userDetail, polinatorInformation);

                    //prepare for case swicth form premium
                    BindPollinatorSize(ddlPrePollinatorSize);
                    BindPollinatorType(ddlPrePollinatorType);
                    BindCountry(ddlPreCountry);
                }

            //}
            //catch (Exception ex)
            //{
              //  Pollinator.Common.Logger.Error("Error occured at " + typeof(Members_Manage).Name + ".Page_Load(). Exception:" + ex.Message);
            //}
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/ShareMap.aspx");
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {

            byte memberLevel = byte.Parse(HiddenMemberLevel.Value);
            if (memberLevel == 1)//upgrade from Normal to Premium
            {
                //premium
                ScriptManager.RegisterStartupScript(this, this.GetType(), "js", "document.getElementById('" + divRowRegNormal.ClientID + "').style.display='none';"
                    + "document.getElementById('" + divRowRegPremium.ClientID + "').style.display='inline';", true);
            }
            else { //normal
                ScriptManager.RegisterStartupScript(this, this.GetType(), "js", "document.getElementById('" + divRowRegNormal.ClientID + "').style.display='inline';"
                    + "document.getElementById('" + divRowRegPremium.ClientID + "').style.display='none';", true);
            }

            //user
            MembershipUser usr = System.Web.Security.Membership.GetUser(UserID);

            var userDetail = GetUserDetail();
            if (userDetail == null)
                userDetail = new UserDetail();

            var polinatorInformation = GetPolinatorInformation();
            if (polinatorInformation == null)
                polinatorInformation = new PolinatorInformation();

            //status
            polinatorInformation.IsApproved = false;//reset IsApproved = 0
            polinatorInformation.IsNew = false;
            polinatorInformation.LastUpdated = DateTime.Now;

            //get new values from form and set to object to update
            if (memberLevel == 1 && userDetail.MembershipLevel == 0)//upgrade from Normal to Premium
            {
                //add info into UserDetail table
                var tempUserPaymentOld = (from tempUP in mydb.TempUserPayments
                                       where tempUP.UserId == UserID
                                       select tempUP).FirstOrDefault();
                if (tempUserPaymentOld != null)
                    mydb.TempUserPayments.Remove(tempUserPaymentOld);

                TempUserPayment tempUserPayment = new TempUserPayment();
                tempUserPayment.UserId = UserID;

                //membership(user)
                tempUserPayment.Email = txtPreEmail.Text;

                //userDetail.MembershipLevel(have 2 levels): 0 is free; 1 is premium 
                tempUserPayment.MembershipLevel = 1;//Premium
                tempUserPayment.FirstName = txtPreFirstName.Text;
                tempUserPayment.LastName = txtPreLastName.Text;
                tempUserPayment.PhoneNumber = txtPrePhoneNumber.Text;
                //tempUserPayment.OrganizationName = txtPreOrganizationName.Text;

                //table2: UserDetail 
                tempUserPayment.OrganizationName = txtPreOrganizationName.Text;
                tempUserPayment.PollinatorSize = Int32.Parse(ddlPrePollinatorSize.SelectedValue);
                tempUserPayment.PollinatorType = Int32.Parse(ddlPrePollinatorType.SelectedValue);

                tempUserPayment.LandscapeStreet = txtPreLandscapeStreet.Text;
                tempUserPayment.LandscapeCity = txtPreLandscapeCity.Text;
                tempUserPayment.LandscapeState = txtPreLandscapeState.Text;
                tempUserPayment.LandscapeZipcode = txtPreLandscapeZipcode.Text;
                tempUserPayment.LandscapeCountry = ddlPreCountry.SelectedValue;

                tempUserPayment.PhotoUrl = txtPrePhotoUrl.Text;
                tempUserPayment.YoutubeUrl = txtPreYoutubeUrl.Text;

                tempUserPayment.Website = txtPreWebsite.Text;
                tempUserPayment.Description = txtPreDescription.Text;
                tempUserPayment.BillingAddress = txtPreBillingAddress.Text;
                tempUserPayment.BillingCity = txtPreBillingCity.Text;
                tempUserPayment.BillingState = txtPreBillingState.Text; ;
                tempUserPayment.BillingZipcode = txtPreBillingZipcode.Text;



                //save lat, long
                tempUserPayment.Latitude = decimal.Parse(hdnLat.Value);
                tempUserPayment.Longitude = decimal.Parse(hdnLng.Value);

                //save userfolder
                //if (!string.IsNullOrEmpty(tempUserPayment.PhotoUrl))
                //{
                //    string filePath = tempUserPayment.PhotoUrl.Split(';')[0];
                //    if (!string.IsNullOrEmpty(filePath))
                //    {
                //        int index1 = filePath.LastIndexOf('/');
                //        if (index1 > 0)
                //        {
                //            filePath = filePath.Substring(0, index1).Trim();
                //            index1 = filePath.LastIndexOf('/');
                //            if (index1 > 0)
                //                filePath = filePath.Substring(index1+1, filePath.Length-index1).Trim();
                            
                //            tempUserPayment.UserFolder = HttpUtility.HtmlDecode(filePath);
                //        }
                //    }
                //}
                //createProcess 
                //tempUserPayment.CreateProcess = 1;
                //tempUserPayment.CreateDate = DateTime.Now;

                //save to TempUserPayments table
                mydb.TempUserPayments.Add(tempUserPayment);
                mydb.SaveChanges();//submit temp table 

                //Payment: send request to Paypal
                if (tempUserPayment != null)
                {
                    // get business account email from config
                    string PaypalEmail = ConfigurationManager.AppSettings["PaypalSeller"];
                    // get variable environment from config
                    bool SandboxEnvi = bool.Parse(ConfigurationManager.AppSettings["SandboxEnvironment"]);
                    // get price from config
                    string PaypalPrice = ConfigurationManager.AppSettings["PaypalPrice"];
                    // Callback url to handle process when payement is successful
                    string ReturnUrl = "http://" + HttpContext.Current.Request["HTTP_HOST"] + "/Members/Manage.aspx?payer=" + UserID;
                    // Callback url to handle process when IPN Paypal service notify 
                    string NotifyUrl = "http://" + HttpContext.Current.Request["HTTP_HOST"] + "/HandlerIPN.ashx";
                    // Callback url to handle process when payment is cancel  
                    string CancelUrl = "http://" + HttpContext.Current.Request["HTTP_HOST"] + "/Members/Manage.aspx?payc=" + UserID;
                    //name of product
                    string PaypalItemName = ConfigurationManager.AppSettings["PaypalItemName"];

                    //custom parram contain temp information of New User
                    string custom = UserID + ";password;change";//CreateUserWizard2.ContinueDestinationPageUrl;
                    //end custom

                    //Pollinator.Common.Logger.Information("Paypal Manage 2 ReturnUrl= " + ReturnUrl);

                    // generate a html form paypal IPN string
                    string PaypalFormHtmlStr = "<form target='_parent' name='_xclick' action='" + ((SandboxEnvi) ? "https://www.sandbox.paypal.com/cgi-bin/webscr" : "https://www.paypal.com/cgi-bin/webscr") + "' method='post'>" +
                                                    "<input type='hidden' name='cmd' value='_xclick'>" +
                                                    "<input type='hidden' name='business' value='" + PaypalEmail + "'>" +
                                                    "<input type='hidden' name='payer_email' value='" + PaypalEmail + "'>" +
                                                    "<input type='hidden' name='currency_code' value='USD'>" +
                                                    "<input type='hidden' name='item_name' value='" + PaypalItemName + "'>" +
                                                    "<input type='hidden' name='amount' value='" + PaypalPrice + "'>" +
                                                    "<input type='hidden' name='custom' value='" + custom + "' />" +
                                                    "<input type='hidden' name='return' value='" + ReturnUrl + "'>" +
                                                    "<input type='hidden' name='notify_url' value='" + NotifyUrl + "'>" +
                                                    "<input type='hidden' name='cancel_url' value='" + CancelUrl + "'>" +
                                                    "<input type='image' id='paypal_btn' src='' border='0' name='submit' alt=''> </form>";

                    //Pollinator.Common.Logger.Information("Paypal Manage 3 PaypalFormHtmlStr= " + PaypalFormHtmlStr);
                    //payment
                    //string ExternalPaymemtlUrl = ConfigurationManager.AppSettings["ExternalPaymemtlUrl"];
                    //if (!String.IsNullOrEmpty(ExternalPaymemtlUrl))//external payment
                    //{
                    //    tempUserPayment.PaypalFormHtmlStr = PaypalFormHtmlStr;
                    //    mydb.SaveChanges();

                    //    //redirect to external paymemt page
                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "popupWaitxxxx", "document.getElementById('MainContent_HyperLink123').click();", true);

                    //    //string urlRedirect = string.Format("{0}?userID={1}", ExternalPaymemtlUrl, tempUserPayment.UserId);
                    //    //ScriptManager.RegisterStartupScript(this, this.GetType(), "redirect", " window.location.replace(\"" + urlRedirect + "\");", true);
                    //}
                    //else
                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "paypal", "document.getElementById('paypal_container').innerHTML = \"" + PaypalFormHtmlStr + "\"  ; document.getElementById('paypal_btn').click() ;", true);

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "paypal", "document.getElementById('paypal_container').innerHTML = \"" + PaypalFormHtmlStr + "\"  ; document.getElementById('paypal_btn').click() ;", true);
                }
                //show please wait... popup
                ScriptManager.RegisterStartupScript(this, this.GetType(), "popupWait", "document.getElementById('showProcessbar').click();", true);
            }
            else
            {
                if (memberLevel == 0)
                    GetInfoFromFormNormal(usr, userDetail, polinatorInformation);
                else
                    GetInfoFromFormPrenium(usr, userDetail, polinatorInformation);

                if (usr != null)
                    System.Web.Security.Membership.UpdateUser(usr);

                mydb.SaveChanges();//submit changed to DB

                //Auto Approved
                AutoApproveSubmission(usr, userDetail, polinatorInformation);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "document.getElementById('confirm_pop').click();", true);
            }

            //Response.Redirect("~/ShareMap.aspx");
        }
        catch (Exception ex)
        {
            byte memberLevel = byte.Parse(HiddenMemberLevel.Value);
            if (memberLevel == 1)//upgrade from Normal to Premium
            {
                //premium
                ScriptManager.RegisterStartupScript(this, this.GetType(), "js", "document.getElementById('" + divRowRegNormal.ClientID + "').style.display='none';"
                    + "document.getElementById('" + divRowRegPremium.ClientID + "').style.display='inline';", true);
            }
            else
            { //normal
                ScriptManager.RegisterStartupScript(this, this.GetType(), "js", "document.getElementById('" + divRowRegNormal.ClientID + "').style.display='inline';"
                    + "document.getElementById('" + divRowRegPremium.ClientID + "').style.display='none';", true);
            }

            //Response.Write(ex.ToString());
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Members_Manage).Name + ".btnUpdate_Click()", ex);
            GoToAlertMessage(panelErrorMessage);
        }

        
    }

    public string getUserFolder(String uploadUrl) 
    {
        string userFolder = String.Empty;   
        string filePath = uploadUrl.Split(';')[0];
        int index = filePath.LastIndexOf('\\');
        if (index > -1)
         {
             string tempUrl = filePath.Substring(0, index);
             index = tempUrl.LastIndexOf("\\");
             if (index > -1)
                userFolder = tempUrl.Substring(index + 1);
         }
        return userFolder;
    }
    #endregion

    #region Private methods
    /// <summary>
    /// SUBMISSIONS automatically approved
    /// </summary>
    /// <param name="userDetail"></param>
    /// <param name="polinatorInformation"></param>
    private void AutoApproveSubmission(MembershipUser usr, UserDetail userDetail, PolinatorInformation polinatorInformation)
    {
        try
        {
            string autoApproveSubmission = "0";
            var autoApproveSubmission1 = ConfigurationManager.AppSettings["AutoApproveSubmission"];
            if (autoApproveSubmission1 != null && !string.IsNullOrEmpty(autoApproveSubmission1))
                autoApproveSubmission = autoApproveSubmission1;

            if (autoApproveSubmission.ToLower().Trim() != "1")
                return;

            bool IsApprovedOrg = false;
            if (polinatorInformation.IsApproved.HasValue)
                IsApprovedOrg = polinatorInformation.IsApproved.Value;

            polinatorInformation.IsApproved = true;
            polinatorInformation.IsNew = false;
            polinatorInformation.LastUpdated = DateTime.Now;
         
            //submit change
            mydb.SaveChanges();
        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Members_Manage).Name + ".AutoApproveSubmission(...). ", ex);
        }
    }

    /// <summary>
    /// User Normal: load data from DB into controls on form
    /// </summary>
    /// <param name="usr"></param>
    /// <param name="userDetail"></param>
    /// <param name="polinatorInformation"></param>
    private void LoadDataToFormNormal(MembershipUser usr, UserDetail userDetail, PolinatorInformation polinatorInformation)
    {
        //divRowRegPremium.Visible = false;
        ScriptManager.RegisterStartupScript(this, this.GetType(), "js", "document.getElementById('" + divRowRegNormal.ClientID + "').style.display='inline';"
        + "document.getElementById('" + divRowRegPremium.ClientID + "').style.display='none'; SetVariablesOfUploadControl('0');", true);

        HiddenMemberLevel.Value = "0";

        txtNorUserName.Text = UserName;
        if (usr != null)
            txtNorEmail.Text = usr.Email;

        //Table 1 :user detail
        txtNorFirstName.Text = userDetail.FirstName;
        txtNorLastName.Text = userDetail.LastName;
        txtNorPhoneNumber.Text = userDetail.PhoneNumber;


        //Table 2: polinatorInformation
        // txtNorOrganizationName.Text = polinatorInformation.OrganizationName ;

        BindPollinatorSize(ddlNorPollinatorSize);
        ddlNorPollinatorSize.SelectedValue = polinatorInformation.PollinatorSize.ToString();

        BindPollinatorType(ddlNorPollinatorType);
        ddlNorPollinatorType.SelectedValue = polinatorInformation.PollinatorType.ToString();

        BindCountry(ddlNorCountry);
        ddlNorCountry.SelectedValue = polinatorInformation.LandscapeCountry.ToString();

        //Pollinator Information
        txtNorOrganizationName.Text = polinatorInformation.OrganizationName;
        txtNorLandscapeStreet.Text = polinatorInformation.LandscapeStreet;
        txtNorLandscapeCity.Text = polinatorInformation.LandscapeCity;
        txtNorLandscapeState.Text = polinatorInformation.LandscapeState;
        txtNorLandscapeZipcode.Text = polinatorInformation.LandscapeZipcode;
        txtNorPhotoUrl.Text = polinatorInformation.PhotoUrl.Trim();
        txtNorYoutubeUrl.Text = polinatorInformation.YoutubeUrl.Trim();
        txtOrganizationDescription.Text = polinatorInformation.Description;
        //thumbnail
        //string photoUrl = "";
        //try
        //{
         //   photoUrl = Utility.ValidateImage(polinatorInformation.PhotoUrl);
        //}
        //catch (Exception ex){}
        
        //if (!string.IsNullOrEmpty(photoUrl))
          //  imgPhoto.ImageUrl = photoUrl; 
        SetPhoto(polinatorInformation);
        SetVideo(polinatorInformation);
        

        //load lat, lng, txtPosition 
        hdnLat.Value = polinatorInformation.Latitude.ToString();
        hdnLng.Value = polinatorInformation.Longitude.ToString();
        txtPosition.Text = polinatorInformation.Latitude.ToString();

        ScriptManager.RegisterStartupScript(this, this.GetType(), "showvideo", "displayVideoWithOutValidate('#" + txtNorYoutubeUrl.ClientID + "');", true);
    }

    /// <summary>
    /// User Premium: load data from DB into controls on form
    /// </summary>
    /// <param name="usr"></param>
    /// <param name="userDetail"></param>
    /// <param name="polinatorInformation"></param>
    private void LoadDataToFormPremium(MembershipUser usr, UserDetail userDetail, PolinatorInformation polinatorInformation)
    {
        //divRowRegNormal.Visible = false;
        ScriptManager.RegisterStartupScript(this, this.GetType(), "js", "document.getElementById('" + divRowRegNormal.ClientID + "').style.display='none';"
            + "document.getElementById('" + divRowRegPremium.ClientID + "').style.display='inline'; SetVariablesOfUploadControl('1');", true);
        
        HiddenMemberLevel.Value = "1";

        if (usr != null)
        {
            txtPreUserName.Text = usr.UserName;
            txtPreEmail.Text = usr.Email;
        }

        //Table 1 :user detail
        txtPreFirstName.Text = userDetail.FirstName;
        txtPreLastName.Text = userDetail.LastName;
        txtPrePhoneNumber.Text = userDetail.PhoneNumber;
        //txtPreOrganizationName.Text = userDetail.OrganizationName;


        //Table 2: polinatorInformation
        txtPreOrganizationName.Text = polinatorInformation.OrganizationName;
        txtPreLandscapeStreet.Text = polinatorInformation.LandscapeStreet;
        txtPreLandscapeCity.Text = polinatorInformation.LandscapeCity;
        txtPreLandscapeState.Text = polinatorInformation.LandscapeState;
        txtPreLandscapeZipcode.Text = polinatorInformation.LandscapeZipcode;
        //txtPrePhotoUrl.Text = polinatorInformation.PhotoUrl;
        //txtPreYoutubeUrl.Text = polinatorInformation.YoutubeUrl;

        //premium info
        txtPreWebsite.Text = polinatorInformation.Website;

        BindPollinatorSize(ddlPrePollinatorSize);
        ddlPrePollinatorSize.SelectedValue = polinatorInformation.PollinatorSize.ToString();

        BindPollinatorType(ddlPrePollinatorType);
        ddlPrePollinatorType.SelectedValue = polinatorInformation.PollinatorType.ToString();

        BindCountry(ddlPreCountry);
        ddlPreCountry.SelectedValue = polinatorInformation.LandscapeCountry.ToString();

        txtPreDescription.Text = polinatorInformation.Description;
        txtPreBillingAddress.Text = polinatorInformation.BillingAddress;
        txtPreBillingCity.Text = polinatorInformation.BillingCity;
        txtPreBillingState.Text = polinatorInformation.BillingState;
        txtPreBillingZipcode.Text = polinatorInformation.BillingZipcode;
        SetPhoto(polinatorInformation);
        SetVideo(polinatorInformation);
        //load lat, lng, txtPosition 
        hdnLat.Value = polinatorInformation.Latitude.ToString();
        hdnLng.Value = polinatorInformation.Longitude.ToString();
        txtPrePosition.Text = polinatorInformation.Latitude.ToString();


        ScriptManager.RegisterStartupScript(this, this.GetType(), "showvideo", "displayVideoWithOutValidate('#" + txtPreYoutubeUrl.ClientID + "');", true);
    }

    /// <summary>
    /// User Normal: collect data from controls on form
    /// </summary>
    /// <param name="usr"></param>
    /// <param name="userDetail"></param>
    /// <param name="polinatorInformation"></param>
    private void GetInfoFromFormNormal(MembershipUser usr, UserDetail userDetail, PolinatorInformation polinatorInformation)
    {
        //  usr.UserName = txtUserNameP.Text;
        if (usr != null)
            usr.Email = txtNorEmail.Text;

        //Table 1 :user detail
        userDetail.MembershipLevel = 0;//Normal
        userDetail.FirstName = txtNorFirstName.Text.Trim();
        userDetail.LastName = txtNorLastName.Text.Trim();
        userDetail.PhoneNumber = txtNorPhoneNumber.Text.Trim();


        //Table 2: polinatorInformation
        polinatorInformation.OrganizationName = txtNorOrganizationName.Text.Trim();
        polinatorInformation.PollinatorType = Int32.Parse(ddlNorPollinatorType.SelectedValue);
        polinatorInformation.PollinatorSize = Int32.Parse(ddlNorPollinatorSize.SelectedValue);
        polinatorInformation.LandscapeStreet = txtNorLandscapeStreet.Text.Trim();
        polinatorInformation.LandscapeCity = txtNorLandscapeCity.Text.Trim();
        polinatorInformation.LandscapeState = txtNorLandscapeState.Text.Trim();
        polinatorInformation.LandscapeZipcode = txtNorLandscapeZipcode.Text.Trim();
        polinatorInformation.LandscapeCountry = ddlNorCountry.SelectedValue.Trim();

        polinatorInformation.PhotoUrl = txtNorPhotoUrl.Text.Trim();
        polinatorInformation.YoutubeUrl = txtNorYoutubeUrl.Text.Trim();
        

        //get lat, lng 
        polinatorInformation.Latitude = decimal.Parse(hdnLat.Value);
        polinatorInformation.Longitude = decimal.Parse(hdnLng.Value);

    }

    /// <summary>
    /// User Premium: collect data from controls on form
    /// </summary>
    /// <param name="usr"></param>
    /// <param name="userDetail"></param>
    /// <param name="polinatorInformation"></param>
    private void GetInfoFromFormPrenium(MembershipUser usr, UserDetail userDetail, PolinatorInformation polinatorInformation)
    {
        if (usr != null)
            usr.Email = txtPreEmail.Text;

        //Table 1 :user detail
        userDetail.MembershipLevel = 1;//premium
        userDetail.FirstName = txtPreFirstName.Text.Trim();
        userDetail.LastName = txtPreLastName.Text.Trim();
        userDetail.PhoneNumber = txtPrePhoneNumber.Text.Trim();
        //userDetail.OrganizationName = txtPreOrganizationName.Text.Trim();


        //Table 2: polinatorInformation
        polinatorInformation.OrganizationName = txtPreOrganizationName.Text.Trim();
        polinatorInformation.PollinatorSize = Int32.Parse(ddlPrePollinatorSize.SelectedValue);
        polinatorInformation.LandscapeStreet = txtPreLandscapeStreet.Text.Trim();
        polinatorInformation.LandscapeCity = txtPreLandscapeCity.Text.Trim();
        polinatorInformation.LandscapeState = txtPreLandscapeState.Text.Trim();
        polinatorInformation.LandscapeZipcode = txtPreLandscapeZipcode.Text.Trim();
        polinatorInformation.LandscapeCountry = ddlPreCountry.SelectedValue;
        polinatorInformation.PhotoUrl = txtPrePhotoUrl.Text.Trim();
        polinatorInformation.YoutubeUrl = txtPreYoutubeUrl.Text.Trim();


        //premium info
        polinatorInformation.Website = txtPreWebsite.Text.Trim();
        polinatorInformation.PollinatorType = Int32.Parse(ddlPrePollinatorType.SelectedValue);
        polinatorInformation.Description = txtPreDescription.Text.Trim();
        polinatorInformation.BillingAddress = txtPreBillingAddress.Text.Trim();
        polinatorInformation.BillingCity = txtPreBillingCity.Text.Trim();
        polinatorInformation.BillingState = txtPreBillingState.Text.Trim();
        polinatorInformation.BillingZipcode = txtPreBillingZipcode.Text.Trim();

        //get lat, lng 
        polinatorInformation.Latitude = decimal.Parse(hdnLat.Value);
        polinatorInformation.Longitude = decimal.Parse(hdnLng.Value);
    }

    private void SetVideo(PolinatorInformation polinatorInformation)
    {
        string youtubeUrls = string.Empty;
        if (polinatorInformation.YoutubeUrl != null)
            youtubeUrls = polinatorInformation.YoutubeUrl.Trim();

        txtPreYoutubeUrl.Text = youtubeUrls;
        txtNorYoutubeUrl.Text = youtubeUrls;
        if (!string.IsNullOrEmpty(youtubeUrls))
        {
            string[] arrVideo = youtubeUrls.Split(new string[] { ";" }, StringSplitOptions.RemoveEmptyEntries);
            numVideo.Text = String.Format("({0} {1})", arrVideo.Length.ToString(), arrVideo.Length > 1 ? "videos" : "video");
            numVideoN.Text = String.Format("({0} {1})", arrVideo.Length.ToString(), arrVideo.Length > 1 ? "videos" : "video");
        }
        else
        {
            numVideo.Style["display"] = "none";
            numVideoN.Style["display"] = "none";
        }
    }

    private void SetPhoto(PolinatorInformation polinatorInformation)
    {
        string photoUrls = string.Empty;
        if (polinatorInformation.PhotoUrl != null)
            photoUrls = polinatorInformation.PhotoUrl.Trim();
        txtNorPhotoUrl.Text = photoUrls;
        txtPrePhotoUrl.Text = photoUrls;
        if (!string.IsNullOrEmpty(photoUrls))
        {
            string[] arrPhoto = photoUrls.Split(new string[] { ";" }, StringSplitOptions.RemoveEmptyEntries);
            numPhoto.Text = String.Format("({0} {1})", arrPhoto.Length.ToString(), arrPhoto.Length > 1 ? "photos" : "photo");
            numPhotoN.Text = String.Format("({0} {1})", arrPhoto.Length.ToString(), arrPhoto.Length > 1 ? "photos" : "photo");

            var firstUrl = Utility.ValidateImage(arrPhoto[0].Trim());
            imgPhoto.ImageUrl = firstUrl;
            if (string.IsNullOrEmpty(firstUrl))
            {
                imgPhoto.Style["display"] = "none";
                imgPhotoP.Style["display"] = "none";
            }
        }
        else
        {
            numPhoto.Style["display"] = "none";
            numPhotoN.Style["display"] = "none";
            imgPhoto.Style["display"] = "none";
            imgPhotoP.Style["display"] = "none";
        }
    }

    private void BindPollinatorSize(DropDownList control)
    {
        var pollinatorSizes = (from ps in mydb.PollinatorSizes
                               select new { ps.ID, ps.Name }).ToList();
        control.DataValueField = "ID";
        control.DataTextField = "Name";
        control.DataSource = pollinatorSizes;
        control.DataBind();
    }

    private void BindPollinatorType(DropDownList control)
    {
        var pollinatorTypes = (from ps in mydb.PollinatorTypes
                               select new { ps.ID, ps.Name }).ToList();
        control.DataValueField = "ID";
        control.DataTextField = "Name";
        control.DataSource = pollinatorTypes;
        control.DataBind();
    }

    private void BindCountry(DropDownList control)
    {
        var countries = (from ps in mydb.Countries
                               select new { ps.ID, ps.Name, ps.SortOder }).OrderBy(o => o.SortOder).ToList();
        control.DataValueField = "ID";
        control.DataTextField = "Name";
        control.DataSource = countries;
        control.DataBind();
    }

    /// <summary>
    /// Get PolinatorInformation entity from DB
    /// </summary>
    /// <returns></returns>
    private PolinatorInformation GetPolinatorInformation()
    {
        var polinatorInformation = (from pi in mydb.PolinatorInformations
                                    where pi.UserId == UserID
                                    select pi).FirstOrDefault();
        return polinatorInformation;
    }

    /// <summary>
    /// Get UserDetail entity from DB
    /// </summary>
    /// <returns></returns>
    private UserDetail GetUserDetail()
    {
        var userDetail = (from ud in mydb.UserDetails
                          where ud.UserId == UserID
                          select ud).FirstOrDefault();

        return userDetail;
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
    #endregion

    #region Properties
    private string UserName
    {
        get
        {
            string text = Context.User.Identity.Name;
            if (text != null)
                return text;
            else
                return string.Empty;
        }
    }
    private Guid UserID
    {
        get
        {
            return (Guid)System.Web.Security.Membership.GetUser(Context.User.Identity.Name).ProviderUserKey;

        }
        set
        {
            ViewState["UserID"] = value;
        }
        
    }
    #endregion
}

