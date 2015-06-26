<%@ WebHandler Language="C#" Class="RegisterUser" %>

using System;
using System.IO;
using System.Web;
using System.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Linq;
using System.Collections.Generic;
using System.Net.Mail;
using Pollinator.Common;
using Pollinator.DataAccess;


public class RegisterUser : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    //role name
    PollinatorEntities mydb = new PollinatorEntities();
    string roleMembersName = Utility.RoleName.Members.ToString();

    public void ProcessRequest(HttpContext context)
    {
        if (context.Request.QueryString["UserName"] != null)
        {
            ValidateUserName(context);
            return;
        }

        string step = context.Request.Form["step"];
        if (step == "2" || step == "1")
        {
            SaveAccountInformation(context);
        }
        else if (step == "4")
        {
           SaveDataStep4(context);
            try
            {
                Guid newUserId = new Guid(context.Session["userId"].ToString());

                // get business account email from config
                string PaypalEmail = ConfigurationManager.AppSettings["PaypalSeller"];
                
                //get payer email that user's email
                string PayerEmail = context.Session["email"].ToString();
                // get variable environment from config
                bool SandboxEnvi = bool.Parse(ConfigurationManager.AppSettings["SandboxEnvironment"]);
                // get price from config
                string PaypalPrice = ConfigurationManager.AppSettings["PaypalPrice"];
                // Callback url to handle process when payement is successful
                string ReturnUrl = "http://"+context.Request.Url.Authority + context.Request.ApplicationPath + "/ShareMap?step=final&payer=" + newUserId;
                // Callback url to handle process when IPN Paypal service notify 
                string NotifyUrl = "http://" + context.Request.Url.Authority + context.Request.ApplicationPath + "/HandlerIPN.ashx";
                // Callback url to handle process when payment is cancel  
                string CancelUrl = "http://" + context.Request.Url.Authority + context.Request.ApplicationPath + "/ShareMap?payc=" + newUserId;
                //name of product
                string PaypalItemName = ConfigurationManager.AppSettings["PaypalItemName"];

                //custom parram contain temp information of New User
                //  string custom = newUserId + /*";" + password + */";add";//CreateUserWizard2.ContinueDestinationPageUrl;

                //for case test demo link included in a frame of client's domain
                /*  string backUrl = ConfigurationManager.AppSettings["BackUrl"];
                  if (!String.IsNullOrEmpty(backUrl))
                      ReturnUrl += "&backUrl=" + backUrl;*/

                // generate a html form paypal IPN string
                string PaypalFormHtmlStr = "<form target='_parent' name='_xclick' action='" + ((SandboxEnvi) ? "https://www.sandbox.paypal.com/cgi-bin/webscr" : "https://www.paypal.com/cgi-bin/webscr") + "' method='post'>" +
                                                "<input type='hidden' name='cmd' value='_xclick'>" +
                                                "<input type='hidden' name='business' value='" + PaypalEmail + "'>" +
                                                "<input type='hidden' name='payer_email' value='" + PayerEmail + "'>" +
                                                "<input type='hidden' name='currency_code' value='USD'>" +
                                                "<input type='hidden' name='item_name' value='" + PaypalItemName + "'>" +
                                                "<input type='hidden' name='amount' value='" + PaypalPrice + "'>" +
                                                //  "<input type='hidden' name='custom' value='" + custom + "' />" +
                                                "<input type='hidden' name='return' value='" + ReturnUrl + "'>" +
                                                "<input type='hidden' name='notify_url' value='" + NotifyUrl + "'>" +
                                                "<input type='hidden' name='cancel_url' value='" + CancelUrl + "'>" +
                                                "<input type='image' id='paypal_btn' src='' border='0' name='submit' alt=''> </form>";

                context.Response.Write(PaypalFormHtmlStr);
            }
            catch (Exception ex)
            {
                context.Response.Write(ex.ToString());
            }

        }
        else if (step == "final")
        {
            SendConfirmEmail(context, context.Request.Form["type"]);
        }
    }

    private static void ValidateUserName(HttpContext context)
    {
        var userName = context.Request.QueryString["UserName"].ToString();
        if (System.Web.Security.Membership.GetUser(userName) != null)
        {
            context.Response.Write("true");
        }
        else
        {
            context.Response.Write("false");
        }
    }

    private void SaveAccountInformation(HttpContext context)
    {
        string fullName = context.Request.Form["fullName"].Trim();
        string email = context.Request.Form["email"].Trim();
        string phoneNumber = context.Request.Form["phoneNumber"].Trim();

        string userName = context.Request.Form["userName"].Trim();
        string password = context.Request.Form["password"].Trim();
        string notCreateAccount = context.Request.Form["notCreateAccount"];

        if (notCreateAccount == "false" && String.IsNullOrEmpty(userName))
        {
            userName = Utility.CreateRandomUserName(0);
            password = Utility.CreateRandomPassword(10);
        }

        //Exec create
        System.Web.Security.MembershipUser newUser = System.Web.Security.Membership.CreateUser(userName, password, email);
        Guid newUserId = (Guid)newUser.ProviderUserKey;

        context.Session["userId"] = newUserId.ToString();      
        context.Session["email"] = email;     
        context.Session[newUserId.ToString() + "password"] = HttpUtility.HtmlEncode(password);     

        //add usser to Members role
        if (!System.Web.Security.Roles.RoleExists(roleMembersName))
            System.Web.Security.Roles.CreateRole(roleMembersName);
        System.Web.Security.Roles.AddUserToRole(userName, roleMembersName);

        //table1: UserDetail 
        UserDetail userDetail = new UserDetail();

        userDetail.UserId = newUserId;
        userDetail.MembershipLevel = 0;
        userDetail.FirstName = fullName;
        //  userDetail.LastName = ((TextBox)LoginView1.FindControl("txtLastName")).Text;
        userDetail.PhoneNumber = phoneNumber;
        mydb.UserDetails.Add(userDetail);

        //table2: PolinatorInformation 
        SavePolinatorInformation(context, newUserId);
        try
        {
            mydb.SaveChanges();
        }
        catch (System.Data.Entity.Validation.DbEntityValidationException e)
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

    private void SavePolinatorInformation(HttpContext context, Guid UserID)
    {
        string autoApproveSubmission = "0";
        var autoApproveSubmission1 = ConfigurationManager.AppSettings["AutoApproveSubmission"];
        var state = context.Request.Form["landscapeCity"].Trim();
        var zip = context.Request.Form["landscapeZipcode"].Trim();
        if (autoApproveSubmission1 != null && !string.IsNullOrEmpty(autoApproveSubmission1))
            autoApproveSubmission = autoApproveSubmission1;

        PolinatorInformation polinatorInformation = new PolinatorInformation();
        polinatorInformation.UserId = UserID;
        polinatorInformation.LandscapeCountry = context.Request.Form["country"];
        polinatorInformation.LandscapeStreet = string.Empty;
        polinatorInformation.LandscapeState = context.Request.Form["landscapeState"].Trim();
        polinatorInformation.LandscapeCity = String.IsNullOrEmpty(state) ? string.Empty : state;
        polinatorInformation.LandscapeZipcode = String.IsNullOrEmpty(zip) ? string.Empty : zip;
        if (context.Request.Form["lat"] != "" && context.Request.Form["lng"] != "")
        {
            polinatorInformation.Latitude = Decimal.Parse(context.Request.Form["lat"]);
            polinatorInformation.Longitude = Decimal.Parse(context.Request.Form["lng"]);
        }

        polinatorInformation.OrganizationName = context.Request.Form["organizationName"];
        polinatorInformation.Description = context.Request.Form["organizationDescription"];
        polinatorInformation.PollinatorSize = Int32.Parse(context.Request.Form["pollinatorSize"]);
        polinatorInformation.PollinatorType = Int32.Parse(context.Request.Form["pollinatorType"]);
        if (context.Request.Form["findOut"] == "NONE")
            polinatorInformation.OrganizationFindOut = 22;//Other
        else
            polinatorInformation.OrganizationFindOut = Int32.Parse(context.Request.Form["findOut"]);

        polinatorInformation.PhotoUrl = context.Request.Form["photoUrl"];
        polinatorInformation.YoutubeUrl = context.Request.Form["youtubeUrl"];

        if (autoApproveSubmission.ToLower().Trim() == "1")
        {
            polinatorInformation.IsApproved = true;
            polinatorInformation.IsNew = false;
        }
        else
        {
            polinatorInformation.IsApproved = false;
            polinatorInformation.IsNew = true;
        }

        polinatorInformation.ExpireDate = DateTime.Now.AddDays(30);//expire after 30 days   
        polinatorInformation.CreatedDate = DateTime.Now;
        polinatorInformation.LastUpdated = DateTime.Now;
        
        mydb.PolinatorInformations.Add(polinatorInformation);

        //mydb.SaveChanges();
    }

    private void SaveDataStep4(HttpContext context)
    {
        Guid UserID = new Guid(context.Session["userId"].ToString());
    
        var polinatorInformation = (from pi in mydb.PolinatorInformations
                                    where pi.UserId == UserID
                                    select pi).FirstOrDefault();
        if (polinatorInformation != null)
        {
            polinatorInformation.Website = context.Request.Form["orgWebsite"].Trim();
            polinatorInformation.LastUpdated = DateTime.Now;  
            mydb.SaveChanges();
        }

    }

    private void SendConfirmEmail(HttpContext context, string type)
    {
        
        Guid UserID = new Guid(context.Session["userId"].ToString());
        var userAccount = System.Web.Security.Membership.GetUser(UserID);

        var userInfo = (from ud in mydb.UserDetails
                        where ud.UserId == UserID
                        select ud).FirstOrDefault();

        if (type == "BFF" && userInfo!=null)
        {
            userInfo.MembershipLevel = 1;
            mydb.SaveChanges();
        }

        var pollinator = (from pi in mydb.PolinatorInformations
                          where pi.UserId == UserID
                          select pi).FirstOrDefault();


        //get template
        String content = string.Empty;

        string webAppUrl = context.Request.Url.Authority;
        if (context.Request.ApplicationPath != @"/")
            webAppUrl = webAppUrl + context.Request.ApplicationPath;
        
        String path = context.Request.PhysicalApplicationPath + "\\EmailTemplates\\RegisterEmail.html";
        using (StreamReader reader = File.OpenText(path))
        {
            content = reader.ReadToEnd();  // Load the content from your file...   
            if (userInfo.MembershipLevel == 0)
            {
                content = content.Replace("<tr><td>User name:</td><td>{UserName}</td></tr>", "");
                content = content.Replace("<tr><td>Password:</td><td>{Password}</td></tr>", "");
                content = content.Replace(@"<a href=""{LogonLink}""><strong>Click Here to Log On</strong></a><br /><br />", "");

            }

            content = content.Replace("{RegisterName}", userInfo.FirstName);
            content = content.Replace("{UserName}", userAccount.UserName);
            string pwd = HttpUtility.HtmlDecode(context.Session[UserID.ToString() + "password"].ToString());

            content = content.Replace("{Password}", pwd);
            content = content.Replace("{UserType}", userInfo.MembershipLevel == 0 ? "SHARE" : "BFF");
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
        if (!String.IsNullOrEmpty(userAccount.Email))
        {
            //send for New User
            MailMessage myMail = new MailMessage();
            myMail.From = new MailAddress(Utility.EmailConfiguration.WebMasterEmail, "Pollinator - Share Map");
            myMail.To.Add(userAccount.Email);
            myMail.Subject = "Thank you for registering with S.H.A.R.E!";
            myMail.IsBodyHtml = true;
            myMail.Body = content;
            SmtpClient smtp = new SmtpClient();
            smtp.Send(myMail);
        }

        //send reminder for Admin
        path = context.Request.PhysicalApplicationPath + "\\EmailTemplates\\RegisterEmailAdmin.html";
        using (StreamReader reader = File.OpenText(path))
        {
            content = reader.ReadToEnd();  // Load the content from your file...   
        }

        foreach (var adminEmail in GetListAdmin())
        {
            var adminName = adminEmail.Substring(0, adminEmail.IndexOf("@"));
            content = content.Replace("{AdminName}", adminName);
            content = content.Replace("{RegisterName}", userInfo.FirstName);
            content = content.Replace("{UserName}", userAccount.UserName);
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

    /// <summary>
    /// get list addmin
    /// </summary>
    /// <returns></returns>
    public static List<string> GetListAdmin()
    {
        var emails = new List<string>();
        var listAdmin = System.Web.Security.Roles.GetUsersInRole(Utility.RoleName.Administrator.ToString());
        foreach (var user in listAdmin)
        {
            var membershipUser = System.Web.Security.Membership.GetUser(user);
            if (membershipUser != null) emails.Add(membershipUser.Email);
        }

        return emails;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}