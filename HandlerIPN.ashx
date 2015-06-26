<%@ WebHandler Language="C#" Class="HandlerIPN" %>

using System;
using System.Web;
using System.Net;
using System.IO;
using System.Collections.Specialized;
using Pollinator.DataAccess;
using Pollinator.Common;
using System.Collections.Generic;
using System.Linq;
using System.Web.Security;
using System.Net.Mail;
using System.Configuration;
using Microsoft.AspNet.Membership.OpenAuth;
using System.Collections;

public class HandlerIPN : IHttpHandler {
    
    PollinatorEntities mydb = new PollinatorEntities();
    public void ProcessRequest (HttpContext context) {
        int createProcess = 1;//set status of processing
        try
        {
            //Post back to either sandbox or live
            string strSandbox = "https://www.sandbox.paypal.com/cgi-bin/webscr";
            string strLive = "https://www.paypal.com/cgi-bin/webscr";
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create((bool.Parse(System.Configuration.ConfigurationManager.AppSettings["SandboxEnvironment"])) ? strSandbox : strLive);

            //Set values for the request back
            req.Method = "POST";
            req.ContentType = "application/x-www-form-urlencoded";
            byte[] param = HttpContext.Current.Request.BinaryRead(HttpContext.Current.Request.ContentLength);
            string strRequest = System.Text.Encoding.ASCII.GetString(param);
            string strResponse_copy = strRequest;  //Save a copy of the initial info sent by PayPal
            strRequest += "&cmd=_notify-validate";
            req.ContentLength = strRequest.Length;

            //Send the request to PayPal and get the response
            StreamWriter streamOut = new StreamWriter(req.GetRequestStream(), System.Text.Encoding.ASCII);

            streamOut.Write(strRequest);
            streamOut.Close();
            StreamReader streamIn = new StreamReader(req.GetResponse().GetResponseStream());
            string strResponse = streamIn.ReadToEnd();
            streamIn.Close();

            // pull the values passed on the initial message from PayPal
            NameValueCollection these_argies = HttpUtility.ParseQueryString(strResponse_copy);
            string strpayment_date = HttpUtility.UrlDecode(these_argies["payment_date"]);
            
            //get userID, password, continueDestinationPageUrl
            string custom = HttpUtility.UrlDecode(these_argies["custom"]);
            string[] customArray = custom.Split(';');
            Guid userID = new Guid(customArray[0]);
            string password = customArray[1];
            string actionType = customArray[2];
            
            if (strResponse == "VERIFIED")
            {
                //check the payment_status is Completed
                //check that txn_id has not been previously processed
                //check that receiver_email is your Primary PayPal email
                //check that payment_amount/payment_currency are correct
                //process payment
                
                string user_email = HttpUtility.UrlDecode(these_argies["payer_email"]);
                string pay_stat = HttpUtility.UrlDecode(these_argies["payment_status"]);
                string txn_id = HttpUtility.UrlDecode(these_argies["txn_id"]);
                
                //DateTime payment_date = HttpUtility.UrlDecode(strpayment_date)== null ? DateTime.Now : DateTime.Parse(strpayment_date);

                //log these_argies
                if (pay_stat.Equals("Completed"))
                {
                    var transactionPaypal = (from paymentInfor in mydb.PaymentInformations
                                             where paymentInfor.txn_id == txn_id
                                             select paymentInfor).FirstOrDefault();
                    if (transactionPaypal != null)
                        return;
                        
                    
                    //save payment information into PaymentInformation table
                    PaymentInformation payInfo = new PaymentInformation();
                    payInfo.InitialInfoSentByPayPal = strResponse_copy;
                    payInfo.StrResponse = strResponse;
                    payInfo.user_email = user_email;
                    payInfo.pay_stat = pay_stat;
                    payInfo.txn_id = txn_id;
                    payInfo.UserId = userID;
                    payInfo.custom = custom;
                    payInfo.CreateDate = DateTime.Now;
                    mydb.PaymentInformations.Add(payInfo);//add to DB
                    mydb.SaveChanges();
                    
                    
                    //load info from temp table to re-insert main tables(UserDetail, PollinatorInformation
                    var tempUserPayment = (from tempUP in mydb.TempUserPayments
                                            where tempUP.UserId == userID
                                            select tempUP).FirstOrDefault();
                    if (tempUserPayment == null)
                        return;

                    if (actionType == "add")
                    {
                        //insert to UserDetail, PollinatorInformation
                        UserDetail userDetail = new UserDetail();
                        userDetail.UserId = tempUserPayment.UserId;

                        userDetail.MembershipLevel = tempUserPayment.MembershipLevel;//Premium
                        userDetail.FirstName = tempUserPayment.FirstName;
                        userDetail.LastName = tempUserPayment.LastName;
                        userDetail.PhoneNumber = tempUserPayment.PhoneNumber;

                        //table2: PolinatorInformation 
                        PolinatorInformation polinatorInformation = new PolinatorInformation();
                        polinatorInformation.UserId = tempUserPayment.UserId;

                        polinatorInformation.OrganizationName = tempUserPayment.OrganizationName;
                        polinatorInformation.PollinatorSize = tempUserPayment.PollinatorSize;
                        polinatorInformation.LandscapeStreet = tempUserPayment.LandscapeStreet;
                        polinatorInformation.LandscapeCity = tempUserPayment.LandscapeCity;
                        polinatorInformation.LandscapeState = tempUserPayment.LandscapeState;
                        polinatorInformation.LandscapeZipcode = tempUserPayment.LandscapeZipcode;
                        polinatorInformation.LandscapeCountry = tempUserPayment.LandscapeCountry;
                        
                        polinatorInformation.PhotoUrl = tempUserPayment.PhotoUrl;
                        polinatorInformation.YoutubeUrl = tempUserPayment.YoutubeUrl;

                        polinatorInformation.Website = tempUserPayment.Website;
                        polinatorInformation.PollinatorType = tempUserPayment.PollinatorType;
                        polinatorInformation.Description = tempUserPayment.Description;
                        polinatorInformation.BillingAddress = tempUserPayment.BillingAddress;
                        polinatorInformation.BillingCity = tempUserPayment.BillingCity;
                        polinatorInformation.BillingState = tempUserPayment.BillingState;
                        polinatorInformation.BillingZipcode = tempUserPayment.BillingZipcode;

                        polinatorInformation.PaymentFullName = tempUserPayment.PaymentFullName;
                        polinatorInformation.PaymentAddress = tempUserPayment.PaymentAddress;
                        polinatorInformation.PaymentState = tempUserPayment.PaymentState;
                        polinatorInformation.PaymentCardNumber = tempUserPayment.PaymentCardNumber;
                        //save lat, long
                        polinatorInformation.Latitude = tempUserPayment.Latitude;
                        polinatorInformation.Longitude = tempUserPayment.Longitude;
                        //folder upload
                        polinatorInformation.UserFolder = tempUserPayment.UserFolder;

                        //update more 2 field, support PollinatorInfomation
                        polinatorInformation.IsNew = true;
                        polinatorInformation.LastUpdated = DateTime.Now;

                        //paidDate
                        polinatorInformation.PaidDate = DateTime.Now;

                        //submit to SQL DB
                        mydb.UserDetails.Add(userDetail);
                        mydb.PolinatorInformations.Add(polinatorInformation);
                        mydb.SaveChanges();

                        //set isApproved for Membership table(isApproved= false is default --> cannot login)
                        MembershipUser newUser = System.Web.Security.Membership.GetUser(userID);
                        newUser.IsApproved = true;
                        System.Web.Security.Membership.UpdateUser(newUser);

                        //send mail default of aspnet
                        SendRegisterEmailDefaultAspNet(newUser, userDetail, polinatorInformation, password);

                        //Auto Approved
                        AutoApproveSubmission(newUser, userDetail, polinatorInformation);

                        //passed step 2
                        tempUserPayment.CreateProcess = 2;//after insert into UserDetail, PollinatorInformation

                        //final section
                        //bool check1 = System.Web.Security.Membership.ValidateUser(newUser.UserName, password);
                        //if (System.Web.Security.Membership.ValidateUser(newUser.UserName, password))
                        //{
                        //    FormsAuthentication.SetAuthCookie(newUser.UserName, createPersistentCookie: true);//Auto sign in
                        //    Pollinator.Common.Logger.Information("Payment 2.1 Vinh test: FormsAuthentication.SetAuthCookie: userName=" + newUser.UserName + ", password=" + password + "; check1 ValidateUser=" + check1);
                            
                        //}

                        //if (System.Web.Security.Membership.ValidateUser(newUser.UserName, password))
                        //{
                        //    FormsAuthentication.SetAuthCookie(newUser.UserName, true);
                        //}
                    }//end case add new
                    else//case: change, upgrade
                    {
                        //insert to UserDetail, PollinatorInformation
                        var userDetail = (from ud in mydb.UserDetails
                                          where ud.UserId == tempUserPayment.UserId
                                          select ud).FirstOrDefault();
                        
                        userDetail.UserId = tempUserPayment.UserId;//no need
                        userDetail.MembershipLevel = tempUserPayment.MembershipLevel;//Premium
                        userDetail.FirstName = tempUserPayment.FirstName;
                        userDetail.LastName = tempUserPayment.LastName;
                        userDetail.PhoneNumber = tempUserPayment.PhoneNumber;

                        //table2: PolinatorInformation 
                        var polinatorInformation = (from pi in mydb.PolinatorInformations
                                                    where pi.UserId == tempUserPayment.UserId
                                                    select pi).FirstOrDefault();
                        
                        polinatorInformation.UserId = tempUserPayment.UserId;//no need

                        polinatorInformation.OrganizationName = tempUserPayment.OrganizationName;
                        polinatorInformation.PollinatorSize = tempUserPayment.PollinatorSize;
                        polinatorInformation.LandscapeStreet = tempUserPayment.LandscapeStreet;
                        polinatorInformation.LandscapeCity = tempUserPayment.LandscapeCity;
                        polinatorInformation.LandscapeState = tempUserPayment.LandscapeState;
                        polinatorInformation.LandscapeZipcode = tempUserPayment.LandscapeZipcode;
                        polinatorInformation.LandscapeCountry = tempUserPayment.LandscapeCountry;
                        
                        polinatorInformation.PhotoUrl = tempUserPayment.PhotoUrl;
                        polinatorInformation.YoutubeUrl = tempUserPayment.YoutubeUrl;

                        polinatorInformation.Website = tempUserPayment.Website;
                        polinatorInformation.PollinatorType = tempUserPayment.PollinatorType;
                        polinatorInformation.Description = tempUserPayment.Description;
                        polinatorInformation.BillingAddress = tempUserPayment.BillingAddress;
                        polinatorInformation.BillingCity = tempUserPayment.BillingCity;
                        polinatorInformation.BillingState = tempUserPayment.BillingState;
                        polinatorInformation.BillingZipcode = tempUserPayment.BillingZipcode;

                        polinatorInformation.PaymentFullName = tempUserPayment.PaymentFullName;
                        polinatorInformation.PaymentAddress = tempUserPayment.PaymentAddress;
                        polinatorInformation.PaymentState = tempUserPayment.PaymentState;
                        polinatorInformation.PaymentCardNumber = tempUserPayment.PaymentCardNumber;
                        //save lat, long
                        polinatorInformation.Latitude = tempUserPayment.Latitude;
                        polinatorInformation.Longitude = tempUserPayment.Longitude;
                        //folder upload
                        polinatorInformation.UserFolder = tempUserPayment.UserFolder;

                        //update more 2 field, support PollinatorInfomation
                        polinatorInformation.IsNew = true; //reset to new
                        polinatorInformation.LastUpdated = DateTime.Now;

                        //paidDate, this value shound get from response of Paypal
                        polinatorInformation.PaidDate = DateTime.Now;

                        //submit changed thing to SQL DB
                        mydb.SaveChanges();

                        //set isApproved for Membership table(isApproved= false is default --> cannot login)
                        MembershipUser usr = System.Web.Security.Membership.GetUser(userID);
                        usr.IsApproved = true;
                        usr.Email = tempUserPayment.Email;
                        System.Web.Security.Membership.UpdateUser(usr);//submit changed usr

                        //Auto Approved
                        AutoApproveSubmission(usr, userDetail, polinatorInformation);
                    }

                    //Delete temp table after insert/update OK
                    if (tempUserPayment != null)
                        mydb.TempUserPayments.Remove(tempUserPayment);
                }
                // more checks needed here specially your account number and related stuff
            }
            else if (strResponse == "INVALID")
            {
                //log for manual investigation
                Pollinator.Common.Logger.Information("Payment 4. => INVALID:" + typeof(HandlerIPN).Name + ".ProcessRequest(), strResponse=" + strResponse);
                
                //rollback data new user at here
                if (actionType == "add")
                {
                    //1. remove current User if have
                    var userRM = System.Web.Security.Membership.GetUser(userID);
                    if (userRM != null)
                        System.Web.Security.Membership.DeleteUser(userRM.UserName, true);

                    //2. log out new user if loged
                    FormsAuthentication.SignOut();
                }
            }
            else
            {
                //log response/ipn data for manual investigation
                Pollinator.Common.Logger.Information("Payment 5. => Else case:" + typeof(HandlerIPN).Name + ".ProcessRequest(), strResponse=" + strResponse);

                //rollback data new user at here
                if (actionType == "add")
                {
                    //1. remove current User if have
                    var userRM = System.Web.Security.Membership.GetUser(userID);
                    if (userRM != null)
                        System.Web.Security.Membership.DeleteUser(userRM.UserName, true);

                    //2. log out new user if loged
                    FormsAuthentication.SignOut();
                }
            }
        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Payment catch=> ex:" + typeof(HandlerIPN).Name + ".ProcessRequest()", ex);

            //rollback data new user at here
        }
        //context.Response.Write(msg);
    }
 
    public bool IsReusable {
        get {
            return false;
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
        String path = HttpContext.Current.Request.PhysicalApplicationPath + "\\EmailTemplates\\RegisterEmail.html";
        using (StreamReader reader = File.OpenText(path))
        {
            content = reader.ReadToEnd();  // Load the content from your file...   
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
        path = HttpContext.Current.Request.PhysicalApplicationPath + "\\EmailTemplates\\RegisterEmailAdmin.html";
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
            
            //submit changed to DB SQL
            mydb.SaveChanges();
        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Error occured at " + typeof(HandlerIPN).Name + ".AutoApproveSubmission(...). ", ex);
        }
    }

    

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
    
    void Send_download_link(string from, string to, string subject, string body)
    {
        try
        {  // Construct a new e-mail message 
            System.Net.Mail.SmtpClient client = new System.Net.Mail.SmtpClient();
            client.Send(from, to, subject, body);
        }
        catch (System.Net.Mail.SmtpException ex)
        {
            throw ex;// "Send_download_link: " + ex.Message;

        }
    } // --- end of Send_download_link --

}