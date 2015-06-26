using System;
using System.Web.UI.HtmlControls;
using Pollinator.Common;

namespace SmartWeb.UI
{
    public partial class HttpError : BasePage
   {
      protected void Page_Load(object sender, EventArgs e)
      {
          var errorCode = Request.QueryString["code"];
         lbl404.Visible = (errorCode != null && errorCode == "404");
         lbl408.Visible = (errorCode != null && errorCode == "408");
         lbl505.Visible = (errorCode != null && errorCode == "505");
         lblError.Visible = (!string.IsNullOrEmpty(errorCode));
      }
   }
}
