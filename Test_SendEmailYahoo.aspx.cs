using System;
using System.Net.Mail;

public partial class Test_SendEmailYahoo : System.Web.UI.Page
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
        objEmail.From = new MailAddress("sharepollinator@yahoo.com", "Sender");

        objEmail.Subject = "Test send email on GoDaddy account";
        objEmail.IsBodyHtml = true;

        var smtp = new SmtpClient();
        smtp.Host = "smtp.mail.yahoo.com";
        smtp.Port = 587;;
        smtp.EnableSsl = true;
   smtp.DnsServers.Autodetect(); 
smtp.DirectSendDefaults.SmtpOptions = ExtendedSmtpOptions.NoChunking | ExtendedSmtpOptions.No8bitAndBinary;; 

        smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
        smtp.UseDefaultCredentials = false;
        smtp.Credentials = new System.Net.NetworkCredential("sharepollinator@yahoo.com", "poli123456");

        objEmail.To.Add("hoaiphuong.nguyen@evizi.com");
        objEmail.Body = content;

        smtp.Send(objEmail);
    }
}