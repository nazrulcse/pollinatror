<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="About.aspx.cs" Inherits="About" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <script type="text/javascript">
        $(document).ready(function () {
            $('#UploadPhoto_form').on('click', function (e) {
                e.preventDefault();
            });
        });
    </script>
    <hgroup class="title">
        <h1><%: Title %>.</h1>
        <h2>Your app description page.</h2>
    </hgroup>

    <article>
        <p>        
            Use this area to provide additional information.
        </p>

        <p>        
            Use this area to provide additional information.
        </p>

        <p>        
            Use this area to provide additional information.
        </p>
    </article>

    <aside>
        <h3>Aside Title</h3>
        <p>        
            Use this area to provide additional information.
        </p>
        <ul>
            <li><a runat="server" href="~/">Home</a></li>
            <li><a runat="server" href="~/About">About</a></li>
            <li><a id="A1" runat="server" href="~/Contact">Contact</a></li>
            <li><a runat="server" href="javascript:PopupWindowiOffice('Modules/Upload/index.html',400,700);">Upload Image</a></li>
            <a href="#UploadPhoto_form" id="showUploadPhoto_form" class="button btn36">Add Photo</a>
        </ul>
    </aside>

    
<!--Vinh-->
<a href="#x" class="overlay" id="UploadPhoto_form"></a>
<div class="popup" style="width:60%; height:80%">
 <%-- <div class="row">
  </div>--%>
  <%--<div class="row" style="width: 100%; height:auto">--%>
  <iframe src="Modules/Upload/index.html" id="uploadform" style="width:100%; height:auto; border: 1px solid red" ></iframe>
 <%-- </div>--%>
  <div >
   <%-- <div style="text-align:center; clear:both; margin-bottom: 0%">class="submit button btn12"--%>
       <a id="btnOK" href="#close"  style="font-family: Verdana; color: white; font-size: 14px" >Save changed</a>
            <a id="btnNotOK" href="#close"  style="font-family: Verdana; color: white; font-size: 14px;margin: 28px;">Cancel</a>
   <%--</div>--%>
  </div>
  <a class="popup-close" href="#close"></a> 
</div>
</asp:Content>

