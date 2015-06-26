using System;

public partial class Test_Logger : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            int i = 0;
            int j = 1/i;
            //string s = Pollinator.Common.DataHelper.Encode("abc@123456");
        }
        catch (Exception ex)
        {
            Pollinator.Common.Logger.Error("Occured in function: " + typeof(Test_Logger).Name + ".Page_Load()", ex);
        }
    }
}