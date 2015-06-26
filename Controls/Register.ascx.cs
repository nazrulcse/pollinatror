using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Microsoft.AspNet.Membership.OpenAuth;
using Pollinator.Common;
using Pollinator.DataAccess;

public partial class Account_Register : System.Web.UI.UserControl
{
    //role name
    PollinatorEntities mydb = new PollinatorEntities();
    string roleMembersName = Utility.RoleName.Members.ToString();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                //login after paypal return 
                if (!Context.User.Identity.IsAuthenticated)
                {
                    if (Request.Params["payer"] != null)
                    {
                        Guid payUserID = new Guid(Request.Params["payer"].ToString());
                        if (Request.Cookies[payUserID.ToString()] != null)
                        {
                            string pwd = string.Empty;
                            string cookieSubName = HttpUtility.HtmlEncode(payUserID.ToString() + "pw");
                            if (Request.Cookies[payUserID.ToString()][cookieSubName] != null)
                            {
                                pwd = HttpUtility.HtmlDecode(Request.Cookies[payUserID.ToString()][cookieSubName]);
                                var userCurrent = System.Web.Security.Membership.GetUser(payUserID);
                                if (userCurrent != null)
                                {
                                    string uid = userCurrent.UserName;
                                    bool checkValidateUser = System.Web.Security.Membership.ValidateUser(uid, pwd);
                                    if (checkValidateUser)
                                    {
                                        FormsAuthentication.SetAuthCookie(uid, createPersistentCookie: true);//Auto sign in

                                        if (Request.Params["backUrl"] != null && !string.IsNullOrEmpty(Request.Params["backUrl"].ToString()))
                                            ScriptManager.RegisterStartupScript(this, this.GetType(), "popupOK", "document.getElementById('MainContent_Register1_linkReturnToMap').setAttribute('href', \"" + Request.Params["backUrl"].ToString() + "\"); document.getElementById('confirm_pop').click();", true);
                                        else
                                            ScriptManager.RegisterStartupScript(this, this.GetType(), "popupOK", "document.getElementById('confirm_pop').click();", true);

                                        //Pollinator.Common.Logger.Information("Payment payer 1 at register: FormsAuthentication.SetAuthCookie: userName=" + uid + ", password=" + pwd + "; check1 ValidateUser=" + checkValidateUser);
                                    }

                                    //clear
                                    Response.Cookies[payUserID.ToString()].Expires = DateTime.Now.AddDays(-1); 
                                }
                            }
                        }
                    }
                    else if (Request.Params["payc"] != null)
                    {
                        //load info user typed on form
                        Guid payUserID = new Guid(Request.Params["payc"].ToString());

                        //1. Delete user if created(auto because use winzard control)
                        var userRM = System.Web.Security.Membership.GetUser(payUserID);
                        var userDetailRemoved = (from ud in mydb.UserDetails
                                                 where ud.UserId == payUserID
                                                 select ud).FirstOrDefault();
                        if (userDetailRemoved == null && userRM != null)//void case user paste url into address bar of browser
                            System.Web.Security.Membership.DeleteUser(userRM.UserName, true);

                        //2. log out new user if loged
                        FormsAuthentication.SignOut();

                        //3. load info user typed on form(thinking needed ??)

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "popupCancel", "alert('Payment is cancel, please view message and retry!');", true);
                    }
                }

                //Go Premium button
                if (Context.User.Identity.IsAuthenticated && Roles.IsUserInRole(roleMembersName))
                {
                    //paypal completed
                    //if (Request.Params["payer"] != null)
                    //{
                        //get UserID to delete TempUserPayment table
                        //Guid payUserID = new Guid(Request.Params["payer"].ToString());

                        //case have return url to client's test domain
                        //if (Request.Params["backUrl"] != null && !string.IsNullOrEmpty(Request.Params["backUrl"].ToString()))
                        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "popupOK", "document.getElementById('MainContent_Register1_linkReturnToMap').setAttribute('href', \"" + Request.Params["backUrl"].ToString() + "\"); document.getElementById('confirm_pop').click();", true);
                        //else
                        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "popupOK", "document.getElementById('confirm_pop').click();", true);
                    //}
                    
                    //show Premium button
                    Guid userID = (Guid)System.Web.Security.Membership.GetUser(Context.User.Identity.Name).ProviderUserKey;
                    var selectedUserDetail = (from user in mydb.UserDetails
                                              where user.UserId == userID
                                              select user).FirstOrDefault();
                    if (selectedUserDetail != null)
                    {
                        if (selectedUserDetail.MembershipLevel == 0)//only show btn for Normal User
                        {
                            HtmlAnchor btnGoPremium = (HtmlAnchor)LoginView1.FindControl("btnGoPremium");
                            btnGoPremium.Visible = true;
                            //btnGoPremium.InnerText = "Upgrade Bee Friendly Farmers";
                        }
                    }
                    //end Premium button
                }

                //bind data to dropdownlist
                BindDataDropdownlist();
            }
            catch (Exception ex)
            {
                //write log
                Pollinator.Common.Logger.Error("Occured in function: " + typeof(Account_Register).Name + ".Page_Load()", ex);
            }
            //end Go Premium button
        }
    }

    private void BindDataDropdownlist()
    {
        var countryList = (from ct in mydb.Countries
                           select new { ct.ID, ct.Name, ct.SortOder }).OrderBy(o => o.SortOder).ToList();

        var pollinatorSizeList = (from ps in mydb.PollinatorSizes
                                  select new { ps.ID, ps.Name }).OrderBy(o => o.ID).ToList();

        var pollinatorTypeList = (from pt in mydb.PollinatorTypes
                                  select new { pt.ID, pt.Name }).OrderBy(o => o.Name).ToList();


        DropDownList ddlPollinatorSize = ((DropDownList)LoginView1.FindControl("ddlPollinatorSize"));
        if (ddlPollinatorSize != null)
        {
            ddlPollinatorSize.DataSource = pollinatorSizeList;
            ddlPollinatorSize.DataValueField = "ID";
            ddlPollinatorSize.DataTextField = "Name";
            ddlPollinatorSize.DataBind();
        }
        DropDownList ddlPollinatorType = ((DropDownList)LoginView1.FindControl("ddlPollinatorType"));
        if (ddlPollinatorType != null)
        {
            ddlPollinatorType.DataSource = pollinatorTypeList;
            ddlPollinatorType.DataValueField = "ID";
            ddlPollinatorType.DataTextField = "Name";
            ddlPollinatorType.DataBind();
        }
        DropDownList ddlCountry = ((DropDownList)LoginView1.FindControl("ddlCountry"));
        if (ddlCountry != null)
        {
            ddlCountry.DataSource = countryList;
            ddlCountry.DataValueField = "ID";
            ddlCountry.DataTextField = "Name";
            ddlCountry.DataBind();
        }

        //Premium form
        DropDownList ddlPrePollinatorSize = ((DropDownList)LoginView1.FindControl("ddlPrePollinatorSize"));
        if (ddlPrePollinatorSize != null)
        {
            ddlPrePollinatorSize.DataSource = pollinatorSizeList;
            ddlPrePollinatorSize.DataValueField = "ID";
            ddlPrePollinatorSize.DataTextField = "Name";
            ddlPrePollinatorSize.DataBind();
        }
        DropDownList ddlPrePollinatorType = ((DropDownList)LoginView1.FindControl("ddlPrePollinatorType"));
        if (ddlPrePollinatorType != null)
        {
            ddlPrePollinatorType.DataSource = pollinatorTypeList;
            ddlPrePollinatorType.DataValueField = "ID";
            ddlPrePollinatorType.DataTextField = "Name";
            ddlPrePollinatorType.DataBind();
        }
        DropDownList ddlPreCountry = ((DropDownList)LoginView1.FindControl("ddlPreCountry"));
        if (ddlPreCountry != null)
        {
            ddlPreCountry.DataSource = countryList;
            ddlPreCountry.DataValueField = "ID";
            ddlPreCountry.DataTextField = "Name";
            ddlPreCountry.DataBind();
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        int progress = 0;
        string userName = string.Empty;
        UserDetail userDetail = new UserDetail();
        PolinatorInformation polinatorInformation = new PolinatorInformation();
        Label lblErrorMessage = ((Label)LoginView1.FindControl("lblErrorMessage"));
        lblErrorMessage.Text = "";

        try
        {
            //Create new User
            //userName = ((TextBox)LoginView1.FindControl("txtUserName")).Text;
            //string password = ((TextBox)LoginView1.FindControl("txtPassword")).Text;

            string password = string.Empty;
            string email = ((TextBox)LoginView1.FindControl("txtEmail")).Text;
            string passwordQuestion = "Q?";
            string passwordAnswer = "A";
            bool isApproved = true;
            MembershipCreateStatus status;
            string messError = string.Empty;

            //auto gen UserName, Password
            if (string.IsNullOrEmpty(userName))
                userName = Utility.CreateRandomUserName(0);
            if (string.IsNullOrEmpty(password))
                password = Utility.CreateRandomPassword(10);

            //Exec create
            System.Web.Security.Membership.CreateUser(userName, password, email, passwordQuestion, passwordAnswer, isApproved, out status);

            //status
            if (status == MembershipCreateStatus.Success)
                progress = 1;
            else
            {
                lblErrorMessage.Text = GetErrorMessage(status);
                return;
            }

            // Get the UserId of the just-added user
            MembershipUser newUser = System.Web.Security.Membership.GetUser(userName);
            Guid newUserId = (Guid)newUser.ProviderUserKey;

            //add usser to Members role
            if (!Roles.RoleExists(roleMembersName))
                Roles.CreateRole(roleMembersName);
            Roles.AddUserToRole(userName, roleMembersName);

            //Get Profile Data Entered by user in CUW control
            //table1: UserDetail 
            userDetail.UserId = newUserId;
            userDetail.MembershipLevel = 0;//Normal
            userDetail.FirstName = ((TextBox)LoginView1.FindControl("txtFirstName")).Text;
            userDetail.LastName = ((TextBox)LoginView1.FindControl("txtLastName")).Text;
            userDetail.PhoneNumber = ((TextBox)LoginView1.FindControl("txtPhoneNumber")).Text;


            //table2: PolinatorInformation 
            polinatorInformation.UserId = newUserId;
            polinatorInformation.ExpireDate = DateTime.Now.AddDays(30);//expire after 30 days

            //Pollinator Information
            polinatorInformation.OrganizationName = ((TextBox)LoginView1.FindControl("txtOrganizationName")).Text;
            polinatorInformation.LandscapeStreet = ((TextBox)LoginView1.FindControl("txtLandscapeStreet")).Text;
            polinatorInformation.LandscapeCity = ((TextBox)LoginView1.FindControl("txtLandscapeCity")).Text;
            polinatorInformation.LandscapeState = ((TextBox)LoginView1.FindControl("txtLandscapeState")).Text;
            polinatorInformation.LandscapeZipcode = ((TextBox)LoginView1.FindControl("txtLandscapeZipcode")).Text;
            //country
            polinatorInformation.LandscapeCountry = ((DropDownList)LoginView1.FindControl("ddlCountry")).SelectedValue;

            //size, type
            polinatorInformation.PollinatorSize = Int32.Parse(((DropDownList)LoginView1.FindControl("ddlPollinatorSize")).SelectedValue);
            polinatorInformation.PollinatorType = Int32.Parse(((DropDownList)LoginView1.FindControl("ddlPollinatorType")).SelectedValue);


            polinatorInformation.PhotoUrl = ((TextBox)LoginView1.FindControl("txtPhotoUrl")).Text;
            polinatorInformation.YoutubeUrl = ((TextBox)LoginView1.FindControl("txtYoutubeUrl")).Text;

            //save lat, long
            polinatorInformation.Latitude = decimal.Parse(hdnLat.Value);
            polinatorInformation.Longitude = decimal.Parse(hdnLng.Value);

            //update more 2 field, support PollinatorInfomation
            polinatorInformation.IsNew = true;
            polinatorInformation.LastUpdated = DateTime.Now;

            //save to 2 tables
            mydb.UserDetails.Add(userDetail);
            mydb.PolinatorInformations.Add(polinatorInformation);
            mydb.SaveChanges();
            progress = 2;//set progress to step 2(added 2 tables)

            //set isApproved in Membership
            //newUser.IsApproved = true;
            //Membership.UpdateUser(newUser);

            //send mail default of aspnet
            SendRegisterEmailDefaultAspNet(newUser, userDetail, polinatorInformation, password);

            //Send emails asynchronously in background
            //SendRegisterEmail(userDetail, polinatorInformation);

            //Auto Approved
            AutoApproveSubmission(newUser, userDetail, polinatorInformation);
            progress = 3;//set progress to step 3(Approved)

            //Fixed bug: Auto sign in
            //if (System.Web.Security.Membership.ValidateUser(userName, password))
            //    FormsAuthentication.SetAuthCookie(userName, createPersistentCookie: false);

            //show popup
            string continueUrl = "~/Default";
            if (!OpenAuth.IsLocalUrl(continueUrl))
                continueUrl = "~/";

            linkReturnToMap.NavigateUrl = continueUrl;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "document.getElementById('confirm_pop').click();", true);
        }
        catch (Exception ex)
        {
            //rollback
            if (progress == 1)//have just created User
                System.Web.Security.Membership.DeleteUser(userName, true);
            else if (progress == 2)//have created User, UserDetail, PollinatorInformation
            {
                System.Web.Security.Membership.DeleteUser(userName, true);
                if (userDetail.UserId != null)
                {
                    mydb.UserDetails.Remove(userDetail);
                    mydb.SaveChanges();
                }
                if (polinatorInformation.UserId != null)
                {
                    mydb.PolinatorInformations.Remove(polinatorInformation);
                    mydb.SaveChanges();
                }
            }

            //show error mess
            lblErrorMessage.Text = ex.Message;

            //write log
            Pollinator.Common.Logger.Error("Occured in function: " + typeof(Account_Register).Name + ".CreateUserWizard1_CreatedUser()", ex);
            //Response.Redirect("~/Default");
        }
    }

    protected void btnPreUpdate_Click(object sender, EventArgs e)
    {
        int progress = 0;
        string userName = string.Empty;
        UserDetail userDetail = new UserDetail();
        PolinatorInformation polinatorInformation = new PolinatorInformation();
        Label lblPreErrorMessage = ((Label)LoginView1.FindControl("lblPreErrorMessage"));
        lblPreErrorMessage.Text = "";
        try
        {
            //Create new User
            userName = ((TextBox)LoginView1.FindControl("txtPreUserName")).Text;
            string password = ((TextBox)LoginView1.FindControl("txtPrePassword")).Text;
            string email = ((TextBox)LoginView1.FindControl("txtPreEmail")).Text;
            string passwordQuestion = "Q?";
            string passwordAnswer = "A";
            bool isApproved = true;
            MembershipCreateStatus status;

            //auto gen UserName, Password if client not input UserName,Password
            if (string.IsNullOrEmpty(userName))
                userName = Utility.CreateRandomUserName(0);
            if (string.IsNullOrEmpty(password))
                password = Utility.CreateRandomPassword(10);

            //Exec create
            System.Web.Security.Membership.CreateUser(userName, password, email, passwordQuestion, passwordAnswer, isApproved, out status);

            //status
            if (status == MembershipCreateStatus.Success)
                progress = 1;
            else
            {
                lblPreErrorMessage.Text = GetErrorMessage(status);
                return;
            }

            // Get the UserId of the just-added user
            MembershipUser newUser = System.Web.Security.Membership.GetUser(userName);
            Guid newUserId = (Guid)newUser.ProviderUserKey;

            //add new Usser to Members role
            if (!Roles.RoleExists(roleMembersName))
                Roles.CreateRole(roleMembersName);
            Roles.AddUserToRole(userName, roleMembersName);

            //add info into UserDetail table
            var tempUserPaymentOld = (from tempUP in mydb.TempUserPayments
                                      where tempUP.UserId == newUserId
                                      select tempUP).FirstOrDefault();
            if (tempUserPaymentOld != null)
                mydb.TempUserPayments.Remove(tempUserPaymentOld);

            TempUserPayment tempUserPayment = new TempUserPayment();
            tempUserPayment.UserId = newUserId;
            tempUserPayment.Email = newUser.Email;

            //userDetail.MembershipLevel(have 2 levels): 0 is free; 1 is premium 
            tempUserPayment.MembershipLevel = 1;//Premium
            tempUserPayment.FirstName = ((TextBox)LoginView1.FindControl("txtPreFirstName")).Text;
            tempUserPayment.LastName = ((TextBox)LoginView1.FindControl("txtPreLastName")).Text;
            tempUserPayment.PhoneNumber = ((TextBox)LoginView1.FindControl("txtPrePhoneNumber")).Text;

            //table2: UserDetail 
            //PolinatorInformation polinatorInformation = new PolinatorInformation();
            //polinatorInformation.UserId = newUserId;


            tempUserPayment.OrganizationName = ((TextBox)LoginView1.FindControl("txtPreOrganizationName")).Text;
            tempUserPayment.LandscapeStreet = ((TextBox)LoginView1.FindControl("txtPreLandscapeStreet")).Text;
            tempUserPayment.LandscapeCity = ((TextBox)LoginView1.FindControl("txtPreLandscapeCity")).Text;
            tempUserPayment.LandscapeState = ((TextBox)LoginView1.FindControl("txtPreLandscapeState")).Text;
            tempUserPayment.LandscapeZipcode = ((TextBox)LoginView1.FindControl("txtPreLandscapeZipcode")).Text;
            //country
            tempUserPayment.LandscapeCountry = ((DropDownList)LoginView1.FindControl("ddlPreCountry")).SelectedValue;

            //size, type
            tempUserPayment.PollinatorSize = Int32.Parse(((DropDownList)LoginView1.FindControl("ddlPrePollinatorSize")).SelectedValue);
            tempUserPayment.PollinatorType = Int32.Parse(((DropDownList)LoginView1.FindControl("ddlPrePollinatorType")).SelectedValue);

            tempUserPayment.PhotoUrl = ((TextBox)LoginView1.FindControl("txtPrePhotoUrl")).Text;
            tempUserPayment.YoutubeUrl = ((TextBox)LoginView1.FindControl("txtPreYoutubeUrl")).Text;

            tempUserPayment.Website = ((TextBox)LoginView1.FindControl("txtPreWebsite")).Text;
            tempUserPayment.Description = ((TextBox)LoginView1.FindControl("txtPreDescription")).Text;
            tempUserPayment.BillingAddress = ((TextBox)LoginView1.FindControl("txtPreBillingAddress")).Text;
            tempUserPayment.BillingCity = ((TextBox)LoginView1.FindControl("txtPreBillingCity")).Text;
            tempUserPayment.BillingState = ((TextBox)LoginView1.FindControl("txtPreBillingState")).Text;
            tempUserPayment.BillingZipcode = ((TextBox)LoginView1.FindControl("txtPreBillingZipcode")).Text;

            //save lat, long
            tempUserPayment.Latitude = decimal.Parse(hdnLat.Value);
            tempUserPayment.Longitude = decimal.Parse(hdnLng.Value);

            //save to TempUserPayments table
            mydb.TempUserPayments.Add(tempUserPayment);
            mydb.SaveChanges();
            progress = 2;//set progress to step 2

            //Payment: send request to Paypal
            //CreateUserWizard2.Visible = false;
            if (tempUserPayment != null)
            {
                //create cookie password
                string cookieSubName = HttpUtility.HtmlEncode(newUserId.ToString()+"pw");
                string cookieSubValue = HttpUtility.HtmlEncode(password);
                Response.Cookies[newUserId.ToString()][cookieSubName] = cookieSubValue;
                Response.Cookies[newUserId.ToString()].Expires = DateTime.Now.AddHours(1);

                // get business account email from config
                string PaypalEmail = ConfigurationManager.AppSettings["PaypalSeller"];
                //get payer email that user's email
                string PayerEmail = tempUserPayment.Email;
                // get variable environment from config
                bool SandboxEnvi = bool.Parse(ConfigurationManager.AppSettings["SandboxEnvironment"]);
                // get price from config
                string PaypalPrice = ConfigurationManager.AppSettings["PaypalPrice"];
                // Callback url to handle process when payement is successful
                string ReturnUrl = "http://" + HttpContext.Current.Request["HTTP_HOST"] + "/ShareMap?payer=" + newUserId;
                // Callback url to handle process when IPN Paypal service notify 
                string NotifyUrl = "http://" + HttpContext.Current.Request["HTTP_HOST"] + "/HandlerIPN.ashx";
                // Callback url to handle process when payment is cancel  
                string CancelUrl = "http://" + HttpContext.Current.Request["HTTP_HOST"] + "/ShareMap?payc=" + newUserId;
                //name of product
                string PaypalItemName = ConfigurationManager.AppSettings["PaypalItemName"];
                //custom parram contain temp information of New User
                string custom = newUserId + ";" + password + ";add";//CreateUserWizard2.ContinueDestinationPageUrl;

                //for case test demo link included in a frame of client's domain
                string backUrl = ConfigurationManager.AppSettings["BackUrl"]+"?Step=12";
                if (!String.IsNullOrEmpty(backUrl))
                    ReturnUrl += "&backUrl=" + backUrl;

                // generate a html form paypal IPN string
                string PaypalFormHtmlStr = "<form target='_parent' name='_xclick' action='" + ((SandboxEnvi) ? "https://www.sandbox.paypal.com/cgi-bin/webscr" : "https://www.paypal.com/cgi-bin/webscr") + "' method='post'>" +
                                                "<input type='hidden' name='cmd' value='_xclick'>" +
                                                "<input type='hidden' name='business' value='" + PaypalEmail + "'>" +
                                                "<input type='hidden' name='payer_email' value='" + PayerEmail + "'>" +
                                                "<input type='hidden' name='currency_code' value='USD'>" +
                                                "<input type='hidden' name='item_name' value='" + PaypalItemName + "'>" +
                                                "<input type='hidden' name='amount' value='" + PaypalPrice + "'>" +
                                                "<input type='hidden' name='custom' value='" + custom + "' />" +
                                                "<input type='hidden' name='return' value='" + ReturnUrl + "'>" +
                                                "<input type='hidden' name='notify_url' value='" + NotifyUrl + "'>" +
                                                "<input type='hidden' name='cancel_url' value='" + CancelUrl + "'>" +
                                                "<input type='image' id='paypal_btn' src='' border='0' name='submit' alt=''> </form>";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "paypal", "document.getElementById('paypal_container').innerHTML = \"" + PaypalFormHtmlStr + "\"  ; document.getElementById('paypal_btn').click() ;", true);

                
            }
            //show process bar
            ScriptManager.RegisterStartupScript(this, this.GetType(), "popupWait", "document.getElementById('showProcessbar').click();", true);
        }
        catch (Exception ex)
        {
            //rollback
            if (progress == 1)//have just created User
                System.Web.Security.Membership.DeleteUser(userName, true);

            //show error message
            lblPreErrorMessage.Text = ex.Message;

            //write log
            Pollinator.Common.Logger.Error("Occured in function: " + typeof(Account_Register).Name + ".CreateUserWizard2_CreatedUser()", ex);
            //Response.Redirect("~/Default");
        }
    }

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
            //polinatorInformation.IsNew = false;
            polinatorInformation.LastUpdated = DateTime.Now;

            //submit change
            mydb.SaveChanges();
        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error occured at " + typeof(Account_Register).Name + ".AutoApproveSubmission(...). ", ex);
        }
    }

    /// <summary>
    /// send email using default of aspnet
    /// </summary>
    /// <param name="usr"></param>
    /// <param name="userInfo"></param>
    /// <param name="pollinator"></param>
    private void SendRegisterEmailDefaultAspNet(MembershipUser usr, UserDetail userInfo, PolinatorInformation pollinator, string password)
    {
        if (usr == null)
            return;

        //get template
        String content = string.Empty;
        Uri uri = HttpContext.Current.Request.Url;

        string webAppUrl = uri.GetLeftPart(UriPartial.Authority); //Return both host and port
        String path = Request.PhysicalApplicationPath + "\\EmailTemplates\\RegisterEmail.html";
        using (StreamReader reader = File.OpenText(path))
        {
            content = reader.ReadToEnd();  // Load the content from your file...   
            if (userInfo.MembershipLevel == 0)
            {
                content = content.Replace("<tr><td>User name:</td><td>{UserName}</td></tr>","");
                content = content.Replace("<tr><td>Password:</td><td>{Password}</td></tr>","");
                content = content.Replace(@"<a href=""{LogonLink}""><strong>Click Here to Log On</strong></a><br /><br />","");
                
            }

            content = content.Replace("{RegisterName}", userInfo.FirstName);
            content = content.Replace("{UserName}", usr.UserName);
            content = content.Replace("{Password}", password);
            content = content.Replace("{UserType}", userInfo.MembershipLevel == 0 ? "NORMAL" : "PREMIUM");
            content = content.Replace("{ShareMapUrl}", webAppUrl + "/ShareMap");
            content = content.Replace("{OrganizationName}", pollinator.OrganizationName);
            content = content.Replace("{PhoneNumber}", userInfo.PhoneNumber);
            content = content.Replace("{LandscapeStreet}", pollinator.LandscapeStreet);
            content = content.Replace("{LandscapeCity}", pollinator.LandscapeCity);
            content = content.Replace("{LandscapeState}", pollinator.LandscapeState);
            content = content.Replace("{LandscapeZipcode}", pollinator.LandscapeZipcode);
            content = content.Replace("{PollinatorSize}", pollinator.PollinatorSize.ToString());
            content = content.Replace("{PollinatorType}", pollinator.PollinatorType.ToString());
            content = content.Replace("{LogonLink}", webAppUrl + "/ShareMap#login_form");

            var webAppPath = WebHelper.FullyQualifiedApplicationPath;
            content = content.Replace("{SiteLogo}", webAppPath + WebHelper.SiteLogo);
        }
        //send for New User
        MailMessage myMail = new MailMessage();
        myMail.From = new MailAddress(Utility.EmailConfiguration.WebMasterEmail, "Pollinator - Share Map");
        myMail.To.Add(usr.Email);
        myMail.Subject = "Thank you for registering with S.H.A.R.E!";
        myMail.IsBodyHtml = true;
        myMail.Body = content;
        SmtpClient smtp = new SmtpClient();
        smtp.Send(myMail);

        //send reminder for Admin
        path = Request.PhysicalApplicationPath + "\\EmailTemplates\\RegisterEmailAdmin.html";
        using (StreamReader reader = File.OpenText(path))
        {
            content = reader.ReadToEnd();  // Load the content from your file...   
        }

        foreach (var adminEmail in GetListAdmin())
        {
            var adminName = adminEmail.Substring(0, adminEmail.IndexOf("@"));
            content = content.Replace("{AdminName}", adminName);
            content = content.Replace("{RegisterName}", userInfo.FirstName);
            content = content.Replace("{UserName}", usr.UserName);
            content = content.Replace("{UserType}", userInfo.MembershipLevel == 0 ? "NORMAL" : "PREMIUM");
            content = content.Replace("{ShareMapUrl}", webAppUrl + "/ShareMap");
            content = content.Replace("{OrganizationName}", pollinator.OrganizationName);
            content = content.Replace("{PhoneNumber}", userInfo.PhoneNumber);
            content = content.Replace("{LandscapeStreet}", pollinator.LandscapeStreet);
            content = content.Replace("{LandscapeCity}", pollinator.LandscapeCity);
            content = content.Replace("{LandscapeState}", pollinator.LandscapeState);
            content = content.Replace("{LandscapeZipcode}", pollinator.LandscapeZipcode);
            content = content.Replace("{PollinatorSize}", pollinator.PollinatorSize.ToString());
            content = content.Replace("{PollinatorType}", pollinator.PollinatorType.ToString());
            content = content.Replace("{LogonLink}", webAppUrl + "/ShareMap#login_form");
            content = content.Replace("{PollinatorLink}", webAppUrl + "/Admin/PollinatorInformation?user=" + userInfo.UserId);
            content = content.Replace("{UserListLink}", webAppUrl + "/Admin/Users");

            var webAppPath = WebHelper.FullyQualifiedApplicationPath;
            content = content.Replace("{SiteLogo}", webAppPath + WebHelper.SiteLogo);

            //send for admin
            MailMessage myAdminMail = new MailMessage();
            myAdminMail.From = new MailAddress(Utility.EmailConfiguration.WebMasterEmail, "Pollinator - Share Map");
            myAdminMail.To.Add(adminEmail);
            myAdminMail.Subject = "New register on S.H.A.R.E!";
            myAdminMail.IsBodyHtml = true;
            myAdminMail.Body = content;
            SmtpClient smtpAdmin = new SmtpClient();
            smtpAdmin.Send(myAdminMail);
        }
    }

    #region Async Send Email
    /// <summary>
    /// get list addmin
    /// </summary>
    /// <returns></returns>
    public static List<string> GetListAdmin()
    {
        var emails = new List<string>();
        var listAdmin = Roles.GetUsersInRole(Utility.RoleName.Administrator.ToString());
        foreach (var user in listAdmin)
        {
            var membershipUser = System.Web.Security.Membership.GetUser(user);
            if (membershipUser != null) emails.Add(membershipUser.Email);
        }

        return emails;
    }

    //This function will send emails in background...
    public void SendRegisterEmail(UserDetail userInfo, Pollinator.DataAccess.PolinatorInformation pollinator)
    {
        phEmailTasks.Controls.Add(new LiteralControl("<iframe src='" + ResolveUrl("../AsyncSendEmail") + "' id='AsyncSendEmails' scrolling='no'></iframe>"));

        var emails = new List<ConfirmationEmailTemplate>();

        var userEmailTemplate = GetUserEmailTemplate(userInfo, pollinator);
        emails.Add(userEmailTemplate); //Add emailing for new user

        //var Administrators = new List<string>();
        //Administrators.Add("Truong"); //Dummy data, must be replaced with real Admin name

        foreach (var adminEmail in GetListAdmin())
        {
            var adminName = adminEmail.Substring(0, adminEmail.IndexOf("@"));
            var adminEmailTemplate = GetAdminEmailTemplate(adminName, adminEmail, userInfo, pollinator);
            emails.Add(adminEmailTemplate); //Add emailing for Administrators
        }

        //Put them all in session object which will be retrieved in Async process running in background
        Session["Emails"] = emails;
    }

    private ConfirmationEmailTemplate GetUserEmailTemplate(UserDetail userInfo, Pollinator.DataAccess.PolinatorInformation pollinator)
    {
        String path = Request.PhysicalApplicationPath + "\\EmailTemplates\\RegisterEmail.html";
        Uri uri = HttpContext.Current.Request.Url;
        string webAppUrl = uri.GetLeftPart(UriPartial.Authority); //Return both host and port
        string userType = userInfo.MembershipLevel == 0 ? "NORMAL" : "PREMIUM";
        using (StreamReader reader = File.OpenText(path))
        {
            String content = reader.ReadToEnd();  // Load the content from your file...   
            content = content.Replace("{RegisterName}", userInfo.FirstName);
            content = content.Replace("{UserName}", System.Web.Security.Membership.GetUser(userInfo.UserId).UserName);
            content = content.Replace("{UserType}", userType);
            content = content.Replace("{ShareMapUrl}", webAppUrl + "/ShareMap");
            content = content.Replace("{OrganizationName}", pollinator.OrganizationName);
            content = content.Replace("{PhoneNumber}", userInfo.PhoneNumber);
            content = content.Replace("{LandscapeStreet}", pollinator.LandscapeStreet);
            content = content.Replace("{LandscapeCity}", pollinator.LandscapeCity);
            content = content.Replace("{LandscapeState}", pollinator.LandscapeState);
            content = content.Replace("{LandscapeZipcode}", pollinator.LandscapeZipcode);
            content = content.Replace("{PollinatorSize}", pollinator.PollinatorSize.ToString());
            content = content.Replace("{PollinatorType}", pollinator.PollinatorType.ToString());
            content = content.Replace("{LogonLink}", webAppUrl + "/ShareMap#login_form");

            var webAppPath = WebHelper.FullyQualifiedApplicationPath;
            content = content.Replace("{SiteLogo}", webAppPath + WebHelper.SiteLogo);

            var membership = System.Web.Security.Membership.GetUser(userInfo.UserId);

            var emailTemplate = new ConfirmationEmailTemplate();
            emailTemplate.EmailTo = membership.Email;// "phamdinhtruong@gmail.com;henry.pham@evizi.com"; //DUMMY data, must replaced with real data of register user
            emailTemplate.EmailFrom = Utility.EmailConfiguration.WebMasterEmail;
            emailTemplate.Subject = "Thank you for registering with S.H.A.R.E!";
            emailTemplate.EmailBodyTemplate = content;

            return emailTemplate;
        }
    }

    private ConfirmationEmailTemplate GetAdminEmailTemplate(string adminName, string adminEmail, UserDetail userInfo, Pollinator.DataAccess.PolinatorInformation pollinator)
    {
        String path = Request.PhysicalApplicationPath + "\\EmailTemplates\\RegisterEmailAdmin.html";
        Uri uri = HttpContext.Current.Request.Url;
        string webAppUrl = uri.GetLeftPart(UriPartial.Authority); //Return both host and port
        string userType = userInfo.MembershipLevel == 0 ? "NORMAL" : "PREMIUM";
        using (StreamReader reader = File.OpenText(path))
        {
            String content = reader.ReadToEnd();  // Load the content from your file...   
            content = content.Replace("{AdminName}", adminName);
            content = content.Replace("{RegisterName}", userInfo.FirstName);
            content = content.Replace("{UserType}", userType);
            content = content.Replace("{ShareMapUrl}", webAppUrl + "/ShareMap");
            content = content.Replace("{OrganizationName}", pollinator.OrganizationName);
            content = content.Replace("{PhoneNumber}", userInfo.PhoneNumber);
            content = content.Replace("{LandscapeStreet}", pollinator.LandscapeStreet);
            content = content.Replace("{LandscapeCity}", pollinator.LandscapeCity);
            content = content.Replace("{LandscapeState}", pollinator.LandscapeState);
            content = content.Replace("{LandscapeZipcode}", pollinator.LandscapeZipcode);
            content = content.Replace("{PollinatorSize}", pollinator.PollinatorSize.ToString());
            content = content.Replace("{PollinatorType}", pollinator.PollinatorType.ToString());
            content = content.Replace("{LogonLink}", webAppUrl + "/ShareMap#login_form");
            content = content.Replace("{PollinatorLink}", webAppUrl + "/Admin/PollinatorInformation?user=" + userInfo.UserId);
            content = content.Replace("{UserListLink}", webAppUrl + "/Admin/Users");

            var webAppPath = WebHelper.FullyQualifiedApplicationPath;
            content = content.Replace("{SiteLogo}", webAppPath + WebHelper.SiteLogo);

            var membership = System.Web.Security.Membership.GetUser(userInfo.UserId);

            var emailTemplate = new ConfirmationEmailTemplate();
            emailTemplate.EmailTo = adminEmail;
            emailTemplate.EmailFrom = Utility.EmailConfiguration.WebMasterEmail;
            emailTemplate.Subject = "Thank you for registering with S.H.A.R.E!";
            emailTemplate.EmailBodyTemplate = content;

            return emailTemplate;
        }
    }
    #endregion

    /// <summary>
    /// After passing error message, it returns user friendly message to the user to resolve the issue.
    /// </summary>
    /// <param name="status"></param>
    /// <returns></returns>
    private string GetErrorMessage(MembershipCreateStatus status)
    {
        switch (status)
        {
            case MembershipCreateStatus.DuplicateUserName:
                return "Username already exists. Please enter a different user name.";

            case MembershipCreateStatus.DuplicateEmail:
                return "A username for that e-mail address already exists. Please enter a different e-mail address.";

            case MembershipCreateStatus.InvalidPassword:
                return "The password provided is invalid. Please enter a valid password value.";

            case MembershipCreateStatus.InvalidEmail:
                return "The e-mail address provided is invalid. Please check the value and try again.";

            case MembershipCreateStatus.InvalidAnswer:
                return "The password retrieval answer provided is invalid. Please check the value and try again.";

            case MembershipCreateStatus.InvalidQuestion:
                return "The password retrieval question provided is invalid. Please check the value and try again.";

            case MembershipCreateStatus.InvalidUserName:
                return "The user name provided is invalid. Please check the value and try again.";

            case MembershipCreateStatus.ProviderError:
                return "The authentication provider returned an error. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

            case MembershipCreateStatus.UserRejected:
                return "The user creation request has been canceled. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

            default:
                return "An unknown error occurred. Please verify your entry and try again. If the problem persists, please contact your system administrator.";
        }
    }
}