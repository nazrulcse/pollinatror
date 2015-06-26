<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ExportData.aspx.cs" Inherits="Admin_ExportData" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap-theme.min.css">
    <script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>

  <link href="../css/bootstrap-modal.css" rel="stylesheet" />
   
     <script type="text/javascript">
         window._skel_config = {
             prefix: '../css/style',
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


      <div class="admincontainer">
        <div >

            <h2 style="margin-left:2px">Export Data</h2>
         
           
               <div style="width: 1048px; height: 514px;">
                <asp:Panel runat="server" ID="panelSuccessMessage" Visible="False">
                    <div class="alert alert-info">
                        <a href="#" class="close" style="display: block; visibility: visible" data-dismiss="alert">&times;</a>
                        <%--<asp:Label ID="StatusMessage" runat="server" Text="<strong>Update successful!</strong>"></asp:Label>--%>
                        <strong style="color: #555">Export successful</strong>
                    </div>
                </asp:Panel>

                <asp:Panel runat="server" ID="panelErrorMessage" Visible="False">
                    <div class="alert alert-danger">
                        <a href="#" class="close" style="display: block; visibility: visible" data-dismiss="alert">&times;</a>
                        <strong style="color: red">There was an error in export data!</strong>
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

                     <fieldset style="border: 1px #ccc solid; margin-left:4px; padding-left:10px;padding-bottom:20px">
                            <legend>Export</legend>
                            
                            <div class="row half" style="margin-top:10px">
                                 <div class="6u"> 
                                       <strong>  Choose data source</strong></div>
                             
                            </div>

                          <div class="row half">
                                 <div class="6u"> 
                                     <asp:DropDownList  ID="drMemberShip" Width="50%" runat="server" placeholder="Choose data source">
                                         <asp:ListItem Value="0">SHARE users</asp:ListItem>
                                         <asp:ListItem Value="1">BFF Farmer users</asp:ListItem>
                                         <asp:ListItem Value="2">All users</asp:ListItem>
                                        </asp:DropDownList>
                             
                            </div>
                        
                          </div >
                              <div class="row half" style="margin-top:10px;display:none">
                                 <div class="6u"> 
                                       <strong>  Export as </strong>
                                 </div>                             
                          </div>
                          <div class="row half" style="display:none">
                                 <div class="6u"> 
                                     <asp:DropDownList  ID="drExportFormat" Width="50%" runat="server" placeholder="Choose format">
                                            <asp:ListItem Value="Csv">Csv</asp:ListItem>        
                                         <asp:ListItem Value="Excel">Excel</asp:ListItem>                                                                     
                                        </asp:DropDownList>
                                  </div>                             
                            </div>


                           <div class="6u" style="margin-top:20px">                                                     
                            <button type="button" id="Button1" causesvalidation="false"  class="btn btn-success" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                                runat="server" onserverclick="btnExport_Click">
                                <i class="glyphicon glyphicon-edit"></i>
                                <span>Export</span>
                            </button>                                                    

                        </div>
                                    
                           

                        </fieldset>
                </div>



    </div>
   </div>

    </div>
   <script type="text/javascript">
       $(document).ready(function () {
           $(".close").click(function () {
               $(".alert").alert();
           });
       });
       </script>
     <style type="text/css" ">
          form input.text, form select, form textarea
        {
            margin-top: 5px;
            margin-bottom: 5px;
            -webkit-appearance: scrollbarbutton-down;
        }
          .row.half
            {
                padding-left: 15px;
            }


        legend
        {
            font-size: 18px;
            width: auto;
            border-bottom: 0px;
            margin-bottom: 0px;
        }

        fieldset
        {
            margin-left: -8px;
            padding-left: 12px;
        }
    
     </style>
  
   
</asp:Content>