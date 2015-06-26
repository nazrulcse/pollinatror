using System;
using System.Collections.Generic;
using System.Web;
using Pollinator.Common;

/// <summary>
/// Summary description for BasePage
/// </summary>
public class BasePage : System.Web.UI.Page
{
	public BasePage()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    protected override void OnPreInit(EventArgs e)
    {
        Utility.EmailConfiguration = new EmailConfiguration("smtp.gmail.com", "sharepollinator@gmail.com", "matkhauquangan", "SHARE@polinator.com");

        base.OnPreInit(e);
        this.Unload += new EventHandler(BasePage_Unload);
    }

    void BasePage_Unload(object sender, EventArgs e)
    {
        if (!IsPostBack) //Modified by Henry 2012/04/03
            LogVisitor();
    }

    private void LogVisitor()
    {
        //string page = this.Page.ToString().Replace("ASP.", "");

        //int i = page.LastIndexOf("_");
        //string s = page.Substring(0, i);

        //int j = s.LastIndexOf("_");
        //string pageFileName = s.Substring(j + 1, s.Length - j - 1) + ".aspx";

        //VisitorLogController controller = new VisitorLogController();
        //VisitorLog log = new VisitorLog();

        //log.PageName = pageFileName;
        //log.PageURL = _pageUrl;
        //log.VisitorName = _logonUserName;
        //log.VisitedTime = DateTime.Now;

        //log.Save();
    }

}