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
using System.Net.Mail;

public partial class Test_SendEmail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        btnRegister.Click += btnRegister_Click;
    }

    void btnRegister_Click(object sender, EventArgs e)
    {
        try
        {
            //get template
            String content = string.Empty;
            String path = Request.PhysicalApplicationPath + "\\EmailTemplates\\RegisterEmail.html";
            using (StreamReader reader = File.OpenText(path))
            {
                content = reader.ReadToEnd();  // Load the content from your file...   
            }
            //send for New User
            MailMessage myMail = new MailMessage();
            myMail.From = new MailAddress(Utility.EmailConfiguration.WebMasterEmail, "Pollinator - Share Map");
            myMail.To.Add("vinh.ngo@evizi.com");
            myMail.To.Add("henry.pham@evizi.com");
            myMail.Subject = "Vinh Test send email(registering with S.H.A.R.E!)";
            myMail.IsBodyHtml = true;
            myMail.Body = content;
            SmtpClient smtp = new SmtpClient();
            smtp.Send(myMail);

            lblThankYouMessage.Text = "Đã send email from ("+Utility.EmailConfiguration.WebMasterEmail+"; to (henry.pham@evizi.com)";
        }
        catch (Exception ex)
        {
            lblThankYouMessage.Text = ex.ToString();
        }
    }
}