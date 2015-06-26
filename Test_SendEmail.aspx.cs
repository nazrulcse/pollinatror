using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Test_SendEmail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //Pollinator.Common.Logger.Error("TEST EMAIL");
        SendEmail();
    }

    private void SendEmail()
    {
        String content = string.Empty;

        var objEmail = new MailMessage();
        objEmail.From = new MailAddress("test@gmail.com", "Sender");

        objEmail.Subject = "Test send email on GoDaddy account";
        objEmail.IsBodyHtml = true;

        var smtp = new SmtpClient();
        smtp.Host = "smtpout.secureserver.net";
        smtp.Port = 80;
        smtp.EnableSsl = false;
        // and then send the mail
//        ServicePointManager.ServerCertificateValidationCallback =
//delegate(object s, X509Certificate certificate,
//X509Chain chain, SslPolicyErrors sslPolicyErrors)
//{ return true; };

        smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
        //smtp.UseDefaultCredentials = false;
        smtp.Credentials = new System.Net.NetworkCredential("admin@beefriendlyfarmer.org", "#passw0rd#");

        objEmail.To.Add("henry.pham@evizi.com");
 objEmail.To.Add("hoaiphuong.nguyen@evizi.com");
        objEmail.Body = content;

        smtp.Send(objEmail);
    }
}