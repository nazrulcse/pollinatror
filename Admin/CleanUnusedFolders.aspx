<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="CleanUnusedFolders.aspx.cs" Inherits="Admin_CleanUnusedFolders" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
    <script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>

 

    <link href='<%=ResolveUrl("~/Content/SiteUpload.css")%>' rel="stylesheet" type="text/css" />

     <div class="admincontainer">
          <div style="padding-left: 3px;padding-right: 3px;" >

               <div style="width: 100%">
                <asp:Panel runat="server" ID="panelSuccessMessage" Visible="False">
                    <div class="alert alert-info">
                        <a href="#" class="close" style="display: block; visibility: visible" data-dismiss="alert">&times;</a>           
                        <strong style="color: #555">Delete successful</strong>
                    </div>
                </asp:Panel>

                <asp:Panel runat="server" ID="panelErrorMessage" Visible="False">
                    <div class="alert alert-danger">
                        <a href="#" class="close" style="display: block; visibility: visible" data-dismiss="alert">&times;</a>
                        <strong style="color: red">There was an error in delete folder!</strong>
                    </div>
                </asp:Panel>

                <script type="text/javascript">
                    $(document).ready(function () {
                        $(".close").click(function () {
                            $(".alert").alert();
                        });
                    });
                </script>

           
                <div>

                     <div class="6u" style="margin-top:-15px">
                    
                        <asp:Label runat="server" ForeColor="#e80c4d" Text="Be careful with deleting folders. Before proceeding, please backup the uploads folders." >

                        </asp:Label>                                           

                    </div>
                    <div class="6u" style="margin-top:15px">
                    
                          <button type="button" id="btnDelete" onserverclick="btnDeleteJunkyUploadFolder_Click" class="btn btn-danger delete" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                            runat="server">
                            <i class="glyphicon glyphicon-trash"></i>
                           <span>Clean unused uploads folders</span>
                        </button>                                                  

                    </div>
                                                
        </div>

   </div>
</div>

</div>
  
     <style type="text/css" ">
         form input.text, form select, form textarea
         {
             margin-top: 10px;
             margin-bottom: 10px;
         }


         legend
         {
             font-size: 18px;
             width: auto;
             border-bottom: 0px;
         }

         fieldset
         {
             margin-left: -8px;
             padding-left: 2px;
         }
     </style>

</asp:Content>