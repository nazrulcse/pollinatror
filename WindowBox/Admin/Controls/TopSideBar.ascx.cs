﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class WindowBox_Admin_Controls_TopSideBar : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public string Name
    {
        get
        {          
            return (string)ViewState["MenuName"];

        }
        set
        {
            ViewState["MenuName"] = value;
        }
    }
}