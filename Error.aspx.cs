using System;

namespace SmartWeb.UI
{
   public partial class Error : BasePage
   {
      protected void Page_Load(object sender, EventArgs e)
      {
         var exceptionMessage = this.Request.QueryString["exception"];

         // Determine where error was handled.
         string errorHandler = Request.QueryString["handler"];
         if (errorHandler == null)
         {
             errorHandler = "Error Page";
         }

         // Get the last error from the server.
         Exception ex = Server.GetLastError();

         string unhandledErrorMsg = "The error was unhandled by application code.";

         // If the exception no longer exists, create a generic exception.
         if (ex == null)
         {
             if (exceptionMessage != null)
                 ex = new Exception(exceptionMessage);
             else
                ex = new Exception(unhandledErrorMsg);
         }

         // Show error details to only you (developer). LOCAL ACCESS ONLY.
         if (Request.IsLocal && this.Request.QueryString["code"] == null)
         {
             // Detailed Error Message.
             ErrorDetailedMsg.Text = ex.Message;

             // Show where the error was handled.
             ErrorHandler.Text = errorHandler;

             // Show local access details.
             DetailedErrorPanel.Visible = true;

             if (ex.InnerException != null)
             {
                 InnerMessage.Text = ex.GetType().ToString() + "<br/>" +
                     ex.InnerException.Message;
                 InnerTrace.Text = ex.InnerException.StackTrace;
             }
             else
             {
                 InnerMessage.Text = ex.GetType().ToString();
                 if (ex.StackTrace != null)
                 {
                     InnerTrace.Text = ex.StackTrace.ToString().TrimStart();
                 }
             }
         }

         Pollinator.Common.Logger.Error("Error occurs at page: " + errorHandler, ex);

         // Clear the error from the server.
         Server.ClearError();
      }
   }
}
