<%@ Page Title="More Pollinator Photos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="PollinatorInfo.aspx.cs" Inherits="PollinatorInfo" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <hgroup class="title">
    <script src="/js/jquery.bxslider.min.js"></script>
    <!-- bxSlider CSS file -->
    <link href="/css/jquery.bxslider.css" rel="stylesheet" />
    <script language="javascript">
        $(document).ready(function () {
            $('.bxslider').bxSlider({
                slideWidth: 720,
                adaptiveHeight: true,
                auto: true,
                pause: 5000,
                slideMargin: 10
            });
        });
        window._skel_config = {
            prefix: '<%= ResolveUrl("~/css/style")%>',
            preloadStyleSheets: true,
            resetCSS: true,
            boxModel: 'border',
            grid: { gutters: 30 },
            breakpoints: {
                wide: { range: '1200-', containers: 1140, grid: { gutters: 50 } },
                narrow: { range: '481-1199', containers: 960 },
                mobile: { range: '-480', containers: 960 }
            }
        };
    </script>      
        <script src="js/skel.min.js"></script>
    </hgroup>
   
    <div id="main-wrapper" style="padding: 0">
        <div>
            <h2><asp:Label ID="Organization" runat="server" Text="Organization"></asp:Label></h2>
            <p style="color: #3764a0;font-family: Tahoma,Verdana,Arial;font-size: 15px; font-weight: bold;line-height: 100%; padding: 10px 0; margin: 0;"><asp:Label ID="LandspaceAddress" runat="server" Text="Addr"></asp:Label></p>
            <p><asp:Label ID="Description" runat="server" Text="Desc"></asp:Label></p>
            </div>
    <%
        String[] Images; 
    if (Photos.IndexOf(';') != -1)
    {
        Images = Photos.Split(';');
    }
    else
    {
        if (String.IsNullOrEmpty(Photos) == false)
        { 
        Images = new string[3] { Photos, Photos, Photos };
        }
        else
        {
            Images = new string [0];
        }
    }
    %>
    <% if (Images.Length > 0) { %>

      <div class="bxslider">
        <% foreach (string photo in Images) {
               String img = photo.Trim();
               %>
          <li><a href="<%=img%>" target="_blank"><img class="carousel-image" alt="<%=PollinatorName%>" onerror="this.src='/Images/no_image.jpg'" src="<%=img%>"></a></li>
        <% } %>
      </div>

    <% } %>
    </div>
     
</asp:Content>
