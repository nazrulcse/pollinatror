using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class WindowBox_WindowBoxDisplay : System.Web.UI.Page
{
    protected string PageURL
    {
        get { return HttpContext.Current.Request.Url.AbsoluteUri; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }
}