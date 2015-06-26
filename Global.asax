<%@ Application Language="C#" %>
<%@ Import Namespace="Pollinator" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="System.Web.Routing" %>
<%@ Import Namespace="Pollinator.Common" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup
        BundleConfig.RegisterBundles(BundleTable.Bundles);
        AuthConfig.RegisterOpenAuth();
        RouteConfig.RegisterRoutes(RouteTable.Routes);
     /*   System.Web.Security.Membership.CreateUser("pollinator", "Butterfly415$$", "admin@beefriendlyfarmer.org");
        Roles.AddUserToRole("pollinator", "Administrator");
        System.Web.Security.Membership.CreateUser("admin", "123456", "henry.pham@evizi.com");
        Roles.AddUserToRole("admin", "Administrator");
        System.Web.Security.Membership.CreateUser("Administrator", "1qasw23ed", "hoaiphuong.nguyen@evizi.com");
       Roles.AddUserToRole("Administrator", "Administrator");*/
        
    }

    void Application_BeginRequest(object sender, EventArgs e)
    {
        string fullOrigionalpath = Request.Url.ToString().ToLower();
        //if (fullOrigionalpath.Contains("/sharemap/") || fullOrigionalpath.Contains("/sharemap/"))
        //{
        //    string newUrl = fullOrigionalpath.Replace("/ShareMap/", "/ShareMap?").Replace("/ShareMap/", "/ShareMap?");
        //    //Context.RewritePath("~/ShareMap");
        //    Response.Redirect(newUrl);
        //}
    } 
    
    public static void RegisterRoutes(RouteCollection routeCollection)
    {
        //routeCollection.MapPageRoute("RouteForMapWidget", "MapWidget", "~/MapWidget");
        //routeCollection.MapPageRoute("RouteForShareMap", "ShareMap", "~/ShareMap");
        //routeCollection.MapPageRoute("RouteForShareMap1", "ShareMap/", "~/ShareMap");
    }
    
    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    //Catch exception at application level    
    //Note: An error handler that is defined in the Global.asax file will only catch errors that occur during processing of requests by 
    //the ASP.NET runtime. For example, it will catch the error if a user requests an  file that does not occur in your 
    //application. However, it does not catch the error if a user requests a nonexistent .htm file. For non-ASP.NET errors, you can 
    //create a custom handler in Internet Information Services (IIS). The custom handler will also not be called for server-level errors.
    void Application_Error(Object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs.

        //Note: Never set customErrors to Off in your Web.config file if you do not have an Application_Error handler in your 
        //Global.asax file. Potentially compromising information about your Web site can be exposed to anyone who can cause an error 
        //to occur on your site.

        // Get last error from the server
        Exception exc = Server.GetLastError();

        string errorHandler = Request.CurrentExecutionFilePath.ToLower();

        bool error_transferred = false;

        //// Handle HTTP errors
        if (exc.GetType() == typeof(HttpException))
        {
            // The Complete Error Handling Example generates
            // some errors using URLs with "NoCatch" in them;
            // ignore these here to simulate what would happen
            // if a global.asax handler were not implemented.
            var extension = Request.CurrentExecutionFilePathExtension.ToLower();
            if (exc.Message.Contains("NoCatch") || exc.Message.Contains("maxUrlLength")
            || (exc.Message.Contains("File does not exist.") &&
                (extension == ".jpg" || extension == ".png" || extension == ".gif" || extension == ".jpeg")))
                return;


            //Redirect HTTP errors to HttpError page
            Server.Transfer("~/HttpError"); //Note: You cannot directly output error information for requests from the 
            //Global.asax file; you must transfer control to another page, typically a 
            //Web Forms page. When transferring control to another page, use Transfer method. 
            //This preserves the current context so that you can get error information from the GetLastError method.
        }

        if (exc is HttpUnhandledException)
        {
            if (exc.InnerException != null)
            {
                error_transferred = true;

                Page page = HttpContext.Current.Handler as Page;

                exc = new Exception(exc.InnerException.Message);
                Server.Transfer(page.ResolveUrl("~/Error?handler=" + errorHandler + "&exception=" + exc.Message), false);
            }
        }

        if (error_transferred == false)
        {
            //Or else, log errors silently (Add onto log storage, send email to Admin)
            Logger.Error("Error occurs at page: " + errorHandler, exc);

            // Clear the error from the server.
            Server.ClearError();
        }
    }


</script>
