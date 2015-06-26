using System;
using System.Collections.Generic;
using System.Net.Mail;
using System.Net.Mime;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Pollinator.Common;

public partial class AsyncSendEmail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //IMPORTANT: Keep in mind that this async Web Request ALWAYS keeps running after you close the Webpage.
        var req = new AsyncWebRequest();
        req.ExecuteRequest();
    }
}

public class AsyncWebRequest
{
    private Page _currentPage = new Page();
    private List<ConfirmationEmailTemplate> _emailsInfo = new List<ConfirmationEmailTemplate>();
    delegate void MethodInvoker();

    public void ExecuteRequest()
    {
        if (HttpContext.Current.Handler == null) return;

        _currentPage = (Page)HttpContext.Current.Handler;

        if (_currentPage != null)
        {
            var taskDelegate = new MethodInvoker(this.RunTask);
            taskDelegate.BeginInvoke(CallBack, null);
        }
    }

    private void CallBack(IAsyncResult ar)
    {
        try
        {
            //In the end, remove cache after pushing out all data
            _currentPage.Session.Remove("Emails");
        }
        catch (Exception)
        {
            //Exception occurrs because enableSessionState is not set to true in configuration file or in the Page directive
        }
    }

    private void RunTask()
    {
        try
        {
            _emailsInfo = (List<ConfirmationEmailTemplate>)_currentPage.Session["Emails"];
        }
        catch (Exception)
        {
            //Exception occurrs because enableSessionState is not set to true in configuration file or in the Page directive
        }

        if (_emailsInfo == null || _emailsInfo.Count == 0) return;

        foreach (ConfirmationEmailTemplate email in _emailsInfo)
        {
            SendEmail(email);
        }
    }

    public bool SendEmail(ConfirmationEmailTemplate email)
    {
        var smtp = new SmtpClient();
        smtp.Host = Utility.EmailConfiguration.SmtpServer;// Example: "smtp.gmail.com";

        smtp.Port = 587;
        smtp.EnableSsl = true;
        smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
        //smtp.UseDefaultCredentials = true;
        smtp.Credentials = new System.Net.NetworkCredential(Utility.EmailConfiguration.UserName, Utility.EmailConfiguration.Password);

        var mail = new MailMessage();
        string emailFrom = email.EmailFrom;

        string bodyContent = email.EmailBodyTemplate;

        mail.From = new MailAddress(emailFrom, "Pollinator - Share Map");
        mail.ReplyToList.Add(new MailAddress(emailFrom, "Pollinator - Share Map"));
        mail.Priority = MailPriority.High;


        string[] emailAddresses = email.EmailTo.Split(new char[]{',',';'});
        foreach(string address in emailAddresses)
        {
            mail.To.Add(address);
        }

        mail.Subject = email.Subject;
        mail.Body = bodyContent;
        mail.IsBodyHtml = true;

        //mail.AlternateViews.Add(AlternateView.CreateAlternateViewFromString(bodyContent, null, MediaTypeNames.Text.Html));

        try
        {
            smtp.Send(mail);
        }
        catch (Exception ex)
        {
            Logger.Error(typeof(AsyncWebRequest).Name + ".SendEmail()", ex);
            return false;
        }

        return true;
    }
}
