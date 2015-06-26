using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TestRegisterPremium : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        btnRegister.Click += BtnRegisterClick;

    }

    protected void BtnRegisterClick(object sender, EventArgs e)
    {

            HttpWebRequest req2 = WebRequest.Create("http://demo.evizi.com:8089/ShareMap.aspx?payer=e5f97fa0-a79a-45e4-824c-b4aa5aae8f9d") as HttpWebRequest;
            req2.Method = "GET";
            req2.KeepAlive = true;
            req2.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8";
            req2.UserAgent = "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36";
            req2.Referer = "http://test.pollinator.org/";
            req2.Host = "demo.evizi.com:8089";
            req2.Headers["Accept-Encoding"] = "gzip,deflate,sdch";
            req2.Headers["Accept-Language"] = "en-US,en;q=0.8,vi;q=0.6";

       
            //// get business account email from config
            //string PaypalEmail = ConfigurationManager.AppSettings["PaypalSeller"];
            //// get variable environment from config
            //bool SandboxEnvi = bool.Parse(ConfigurationManager.AppSettings["SandboxEnvironment"]);
            //// get price from config
            //string PaypalPrice = ConfigurationManager.AppSettings["PaypalPrice"];
            //// Callback url to handle process when payement is successful
            //string ReturnUrl = "http://" + HttpContext.Current.Request["HTTP_HOST"] + "/";
            //// Callback url to handle process when IPN Paypal service notify 
            //string NotifyUrl = "http://" + HttpContext.Current.Request["HTTP_HOST"] + "/HandlerIPN.ashx";
            //// Callback url to handle process when payment is cancel  
            //string CancelUrl = "http://" + HttpContext.Current.Request["HTTP_HOST"];

            //// generate a html form paypal IPN string
            //string PaypalFormHtmlStr = "<form name='_xclick' action='" + ((SandboxEnvi) ? "https://www.sandbox.paypal.com/cgi-bin/webscr" : "https://www.paypal.com/cgi-bin/webscr") + "' method='post'>" +
            //                                "<input type='hidden' name='cmd' value='_xclick'>" +
            //                                "<input type='hidden' name='business' value='" + PaypalEmail + "'>" +
            //                                "<input type='hidden' name='payer_email' value='" + PaypalEmail + "'>" +
            //                                "<input type='hidden' name='currency_code' value='USD'>" +
            //                                "<input type='hidden' name='item_name' value='Digital Download'>" +
            //                                "<input type='hidden' name='amount' value='" + PaypalPrice + "'>" +
            //                                "<input type='hidden' name='custom' value='VinhTestPayment' />" +
            //                                "<input type='hidden' name='return' value='" + ReturnUrl + "'>" +
            //                                "<input type='hidden' name='notify_url' value='" + NotifyUrl + "'>" +
            //                                "<input type='hidden' name='cancel_url' value='" + CancelUrl + "'>" +
            //                                "<input type='image' id='paypal_btn' src='' border='0' name='submit' alt=''> </form>";

            //string urlRedirect = string.Format("http://pollinator.massiveimpacttechnology.com/PayPal.aspx?newUserId={0}&password={1}", "111", "222");
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "redirect", " window.location.replace(\"" + urlRedirect + "\");", true);
            ////ScriptManager.RegisterStartupScript(this, this.GetType(), "redirect", "var urlRedirect = Request.Url.Host + '/Paypal.aspx?PaypalFormHtmlStr=xxx'; alert(urlRedirect); window.location.replace(urlRedirect);", true);
            ////ScriptManager.RegisterStartupScript(this, this.GetType(), "paypal", "document.getElementById('paypal_container').innerHTML = \"" + PaypalFormHtmlStr + "\"  ; document.getElementById('paypal_btn').click() ;", true);
            ////ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('---');", true); 
    }
}