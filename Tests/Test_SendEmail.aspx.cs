using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Pollinator.Common;
using Pollinator.DataAccess;

public partial class Test_SendEmail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        GetListAdmin();
        btnRegister.Click += btnRegister_Click;
    }

    public static List<string> GetListAdmin()
    {
        List<string> emails = new List<string>();
        var listAdmin = Roles.GetUsersInRole(Utility.RoleName.Administrator.ToString());
        foreach (var user in listAdmin)
            emails.Add(System.Web.Security.Membership.GetUser(user).Email);
        return emails;
    }

    void btnRegister_Click(object sender, EventArgs e)
    {
        lblThankYouMessage.Text = "Thank you for registering pollinator information with Pollinator Partnership. An email has been sent to contact emails associated with your account. Please be patient; the delivery of email may be delayed. Remember to confirm that the email above is correct and to check your junk or spam folder or filter if you do not receive this email.";

        UserDetail userInfo = new UserDetail();
        var pollinator = new Pollinator.DataAccess.PolinatorInformation();

        //----------------NOTE: You have to supply the real data to replace this dummy data------------------
        userInfo.UserId = new Guid();
        userInfo.FirstName = "Truong";
        userInfo.PhoneNumber = "0904949821";

        pollinator.OrganizationName = "Natural Resources Conservation Service";
        pollinator.LandscapeStreet = "Duy Tan";
        pollinator.LandscapeCity = "Hanoi";
        pollinator.LandscapeState = "CA";
        pollinator.LandscapeZipcode = "01";
        pollinator.PollinatorSize = 1;
        pollinator.PollinatorType = 1;

        SendRegisterEmail(userInfo, pollinator);
    }

    public void SendRegisterEmail(UserDetail userInfo, Pollinator.DataAccess.PolinatorInformation pollinator)
    {
        var emails = new List<ConfirmationEmailTemplate>();

        var userEmailTemplate = GetUserEmailTemplate(userInfo, pollinator);
        emails.Add(userEmailTemplate);

        var Administrators = new List<string>();
        Administrators.Add("Truong"); //Dummy data, must be replaced with real Admin name

        foreach(var admin in Administrators)
        {
            string adminEmail = "phamdinhtruong@gmail.com";//DUMMY data, must replaced with real data of Admin user

            var adminEmailTemplate = GetAdminEmailTemplate(admin, adminEmail, userInfo, pollinator);
            emails.Add(adminEmailTemplate);
        }

        Session["Emails"] = emails;
    }

    private ConfirmationEmailTemplate GetUserEmailTemplate(UserDetail userInfo, Pollinator.DataAccess.PolinatorInformation pollinator)
    {
        String path = Request.PhysicalApplicationPath + "\\EmailTemplates\\RegisterEmail.html";
        Uri uri = HttpContext.Current.Request.Url;
        string webAppUrl = uri.GetLeftPart(UriPartial.Authority); //Return both host and port

        using (StreamReader reader = File.OpenText(path))
        {
            String content = reader.ReadToEnd();  // Load the content from your file...   
            content = content.Replace("{RegisterName}", userInfo.FirstName);
            content = content.Replace("{UserType}", "PREMIUM");
            content = content.Replace("{ShareMapUrl}", webAppUrl + "/Pollinator/ShareMap.aspx");
            content = content.Replace("{OrganizationName}", pollinator.OrganizationName);
            content = content.Replace("{PhoneNumber}", userInfo.PhoneNumber);
            content = content.Replace("{LandscapeStreet}", pollinator.LandscapeStreet);
            content = content.Replace("{LandscapeCity}", pollinator.LandscapeCity);
            content = content.Replace("{LandscapeState}", pollinator.LandscapeState);
            content = content.Replace("{LandscapeZipcode}", pollinator.LandscapeZipcode);
            content = content.Replace("{PollinatorSize}", pollinator.PollinatorSize.ToString());
            content = content.Replace("{PollinatorType}", pollinator.PollinatorType.ToString());
            content = content.Replace("{LogonLink}", webAppUrl + "/Pollinator/Account/Login");

            var membership = System.Web.Security.Membership.GetUser(userInfo.UserId);

            var emailTemplate = new ConfirmationEmailTemplate();
            emailTemplate.EmailTo = "phamdinhtruong@gmail.com"; //DUMMY data, must replaced with real data of register user
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

        using (StreamReader reader = File.OpenText(path))
        {
            String content = reader.ReadToEnd();  // Load the content from your file...   
            content = content.Replace("{AdminName}", adminName);
            content = content.Replace("{RegisterName}", userInfo.FirstName);
            content = content.Replace("{UserType}", "PREMIUM");
            content = content.Replace("{ShareMapUrl}", webAppUrl + "/Pollinator/ShareMap.aspx");
            content = content.Replace("{OrganizationName}", pollinator.OrganizationName);
            content = content.Replace("{PhoneNumber}", userInfo.PhoneNumber);
            content = content.Replace("{LandscapeStreet}", pollinator.LandscapeStreet);
            content = content.Replace("{LandscapeCity}", pollinator.LandscapeCity);
            content = content.Replace("{LandscapeState}", pollinator.LandscapeState);
            content = content.Replace("{LandscapeZipcode}", pollinator.LandscapeZipcode);
            content = content.Replace("{PollinatorSize}", pollinator.PollinatorSize.ToString());
            content = content.Replace("{PollinatorType}", pollinator.PollinatorType.ToString());
            content = content.Replace("{LogonLink}", webAppUrl + "/Pollinator/Account/Login");

            var membership = System.Web.Security.Membership.GetUser(userInfo.UserId);

            var emailTemplate = new ConfirmationEmailTemplate();
            emailTemplate.EmailTo = adminEmail;
            emailTemplate.EmailFrom = Utility.EmailConfiguration.WebMasterEmail;
            emailTemplate.Subject = "Thank you for registering with S.H.A.R.E!";
            emailTemplate.EmailBodyTemplate = content;

            return emailTemplate;
        }
    }
}