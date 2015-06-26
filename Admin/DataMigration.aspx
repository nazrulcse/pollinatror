<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DataMigration.aspx.cs" Inherits="Admin_DataMigration" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
    <script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>

  
    <asp:PlaceHolder ID="PlaceHolder3" runat="server">

     
        <%=Scripts.Render("~/Scripts/AjaxFileupload.js") %>   
    </asp:PlaceHolder>



    <link href='<%=ResolveUrl("~/Content/SiteUpload.css")%>' rel="stylesheet" type="text/css" />

         
     <div class="admincontainer">
          <div style="padding-left: 3px;padding-right: 3px;" >
            <h2>Import Data</h2>
         
           
               <div style="width:100%">
                <asp:Panel runat="server" ID="panelSuccessMessage" Visible="False">
                    <div class="alert alert-info">
                        <a href="#" class="close" style="display: block; visibility: visible" data-dismiss="alert">&times;</a>
                        <%--<asp:Label ID="StatusMessage" runat="server" Text="<strong>Update successful!</strong>"></asp:Label>--%>
                        <strong style="color: #555">Import successful</strong>
                    </div>
                </asp:Panel>

                <asp:Panel runat="server" ID="panelErrorMessage" Visible="False">
                    <div class="alert alert-danger">
                        <a href="#" class="close" style="display: block; visibility: visible" data-dismiss="alert">&times;</a>
                        <strong style="color: red">There was an error in import data!</strong>
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

                     <fieldset style="border: 1px #ccc solid; padding-left:30px;padding-right:20px;padding-bottom:20px">
                            <legend>Import data from old system </legend>
                            
                            <div class="row half">
                                 <div class="6u">
                                       <strong>  Choose .csv file that data get from old Fusion Table (has location data)</strong>                                                                       
                                </div>
                                <div class="6u">
                                  
                                   <asp:FileUpload ID="FileUpload1" runat="server" ClientIDMode="Static"  Width="100%" />
                                  
                                </div>
                                 <div class="6u" style="margin-top:20px">
                                       <strong>  Choose .csv file that data get from old database (has Organization Name )</strong>                                                                       
                                </div>
                                <div class="6u">
                                  
                                    <asp:FileUpload ID="FileUpload2" runat="server" ClientIDMode="Static"  Width="100%" />
                                </div>
                            </div>

                           <div class="6u" style="margin-top:20px">
                           
                              

                            <button type="button" id="Button1" causesvalidation="false"  class="btn btn-success" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                                runat="server" onserverclick="btnImportOld_Click">
                                <i class="glyphicon glyphicon-edit"></i>
                                <span>Import</span>
                            </button>                                                    

                        </div>
                                    
                           

                        </fieldset>
                </div>


                  <div>

                       <fieldset style="border: 1px #ccc solid; padding-left:30px;padding-right:20px;padding-bottom:20px">
                            <legend>Import data for demo </legend>
                            
                            <div class="row half">
                                <div class="6u">
                                  <strong> Choose .csv file to import</strong>
 
                                </div>

                                  <div class="6u">
                                 <asp:FileUpload ID="fileDemo" runat="server" ClientIDMode="Static"  Width="100%" />
                                  
                                </div>
                               
                            </div>

                           <div class="6u" style="margin-top:20px">
                              <button type="button" id="Button3" causesvalidation="false"  class="btn btn-success" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                                runat="server" onserverclick="btnParseDemoData_Click">
                                <i class="glyphicon glyphicon-edit"></i>
                                <span>Parse data and save to file</span>
                            </button>     
                              
                            <button type="button" id="Button2" causesvalidation="false"  class="btn btn-success" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                                runat="server" onserverclick="btnImportDemo_Click">
                                <i class="glyphicon glyphicon-edit"></i>
                                <span>Import</span>
                            </button>                                                    

                        </div>
                                    
                           

                        </fieldset>
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
            font-size:18px;
            width:auto;
            border-bottom:0px;
        }
        fieldset
        {
            margin-left:0px;
            padding-left:2px;
        }
    
     </style>
    <script type="text/javascript">
       
       
    </script>
   
</asp:Content>

