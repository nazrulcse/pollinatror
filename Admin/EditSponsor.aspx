<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="EditSponsor.aspx.cs" Inherits="Admin_EditSponsor" %>

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
        $(document).ready(function () {            
            if ( (navigator.userAgent.toLowerCase().indexOf('chrome') > -1) || (navigator.userAgent.toLowerCase().indexOf('firefox') > -1)) {
                $('#lblIsActive').css('padding-top', '5px');
             }
        });

    </script>
    <asp:PlaceHolder ID="PlaceHolder3" runat="server">

        <%=Scripts.Render("~/js/skel.min.js") %>
        <%=Scripts.Render("~/Scripts/AjaxFileupload.js") %>   
    </asp:PlaceHolder>


    <noscript>
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/skel-noscript.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style-wide.css")%>" />

    </noscript>

    <link href='<%=ResolveUrl("~/Content/SiteUpload.css")%>' rel="stylesheet" type="text/css" />

     <div class="admincontainer">
           <div style="padding-left: 3px;padding-right: 3px;" >

            <h2 >Sponsor Information</h2>
            <p  >
                <!--Bootstrap button style-->
                <button class="btn" onclick="window.location.href = '<%= ResolveUrl("~/Admin/SponsorList") %>'; return false;">
                    <i class="glyphicon glyphicon-backward"></i>
                    Back to List
                </button>
            </p>
           
            <div style="width: 100%">
                <asp:Panel runat="server" ID="panelSuccessMessage" Visible="False">
                    <div class="alert alert-info">
                        <a href="#" class="close" style="display: block; visibility: visible" data-dismiss="alert">&times;</a>          
                        <strong style="color: #555"><%if (SponsorID > 0)
                                                      { %>Update <%}
                                                      else
                                                      {%> Add <%}%>successful</strong>
                    </div>
                </asp:Panel>

                <asp:Panel runat="server" ID="panelErrorMessage" Visible="False">
                    <div class="alert alert-danger">
                        <a href="#" class="close" style="display: block; visibility: visible" data-dismiss="alert">&times;</a>
                        <strong style="color: red">There was an error in saving data!</strong>
                    </div>
                </asp:Panel>
               
            </div>

            <div style="width: 100%; background-color: #f5f5f5; border-color: #ccc; border-width: 1px; border-style: Solid; font-family: Verdana; font-size: 0.8em; border-collapse: collapse;">             
                <div class="row" style="margin-top: 20px; margin-bottom: 20px; margin-right: 20px;" runat="server">
                    <div class="12u">

                        <div style="width:50%; float:left" >
                            <div  class="6u" style="width:100%;margin-top: 5px;" >
                                Name<asp:TextBox MaxLength="60" class="text" placeholder="Name" ID="txtName" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="validatorName" runat="server" ControlToValidate="txtName" ErrorMessage="Name is required." ToolTip="Name is required." ValidationGroup="Update">Name is required.</asp:RequiredFieldValidator>
                            </div>
                            <div  class="6u" style="width:100%; margin-top:10px; "> Website<asp:TextBox MaxLength="60" class="text" placeholder="Website" ID="txtWebsite" runat="server"></asp:TextBox>
                                 <asp:RegularExpressionValidator   CssClass="message-error" SetFocusOnError="true" ID="validatorWebsite"  ControlToValidate="txtWebsite"  runat="server" ValidationExpression="(http(s)?://)?([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?" ErrorMessage="Invalid URL" ValidationGroup="Update"></asp:RegularExpressionValidator>

                            </div>
                                                 
                             <div  class="6u" style="width:100%; margin-top: 10px;">
                                <label class="file-upload">
                                    <a class="button btn36" runat="server" id="linAddPhoto" style="width: 152px; font-size: 12px;">Add photo</a>
                                    <img id="loadingNormal" src="../images/loading.gif" style="display: none;">
                                                                                             
                                    <asp:FileUpload style="height: 0px;width: 0px;" ID="fileToUpload" runat="server" ClientIDMode="Static" onchange="javascript:return fileUpload('MainContent_txtPhotoUrl', 'MainContent_imgPhoto','loadingNormal', 'fileToUpload');" />
                                    
                                </label>
                                    <asp:TextBox MaxLength="255" Width="0" ID="txtPhotoUrl" runat="server" style="display:none" ></asp:TextBox>  
                                  <asp:RequiredFieldValidator SetFocusOnError="true" CssClass="message-error" ID="validatorPhotoUrl" runat="server" ControlToValidate="txtPhotoUrl" ErrorMessage="Please add sponsor image." ToolTip="Please add sponsor image." ValidationGroup="Update">Please add sponsor image.</asp:RequiredFieldValidator>
                            </div>
                            <div  class="6u" style="width:100%; margin-top: 10px;">
                                <asp:CheckBox ID="chkIsActive" runat="server" CssClass="flat-checkbox" style="float: left" /><label  id="lblIsActive" style="float: left;font-size:13px" for="<%= chkIsActive.ClientID %>"><strong style="color:rgb(36,137,197)">Make sponsor default</strong></label>
                            </div>
                        </div>

                    
                        <div style="width: 50%; float:right">

                            <div class="6u" style="width:100%;margin-left:20px;margin-top:30px;height:202px;" >
                                <asp:Image ID="imgPhoto" ImageUrl="" runat="server" style ="max-height:100%;max-width:100%;display:none" />
                            </div>

                        </div>

                        </div>

                    </div>
            
             </div>

            <div class="row" style="margin-top: 20px;font-family: Verdana; font-size: 0.9em;" >
                    
                <div class="12u" style="margin-left: -26px">
                        <div class="6u">
                            <%if (SponsorID > 0)
                              { 
                            %>
                            <button type="button" id="btnUpdate" causesvalidation="True" validationgroup="Update" class="btn btn-success" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                                runat="server" onclick="doSave();" onserverclick="btnUpdate_Click">
                                <i class="glyphicon glyphicon-edit"></i>
                                <span>Update</span>
                            </button>
                            <%}
                              else
                              {                              
                            %>

                            <button type="button" id="btnAdd" causesvalidation="True" validationgroup="Update" class="btn btn-success" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                                runat="server"  onclick="doSave();" onserverclick="btnUpdate_Click">
                                <i class="glyphicon glyphicon-plus"></i>
                                <span>Save</span>
                            </button>
                            <%
                              }
                              
                              if (SponsorID > 0)
                              {
                            %>
                            
                            <button type="button" id="btnDelete" onclick="javascript:$('#divConfirmDelete').modal('show');" class="btn btn-danger delete" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                              runat="server">
                                <i class="glyphicon glyphicon-trash"></i>
                                <span>Delete</span>
                            </button>

                            <%}
                              else
                              {                              
                            %>

                            <button type="button" id="btnReset" onclick="clearForm()" causesvalidation="false" class="btn btn-danger delete" style="height: 40px; font-family: Segoe UI; font-size: 1.2em; font-weight: 600"
                                runat="server" >
                                <i class="glyphicon glyphicon-remove"></i>
                                <span>Reset</span>
                            </button>
                            <%
                               }
                            %>

                        </div>
                    </div>

             </div>

        </div>
    </div>
    
    <div id="divConfirmDelete" class="modal fade">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" 
                  aria-hidden="true">×</button>
            <h3 id="myModalLabel">Delete Confirmation</h3>
       </div>
       <div class="modal-body">
           Are you sure you want to delete?
            <div class="modal-footer">
                <button id="Button1" class="btn btn-danger" runat="server" aria-hidden="true" type="button" onclick="$('#divConfirmDelete').modal('hide');" onserverclick="btnDelete_Click">Yes</button>                
                <button class="btn btn-info" data-dismiss="modal" aria-hidden="true">No</button>
            </div>
         </div>
    </div>

    <input id="dontDeletePreImage" value="1" type="hidden" runat="server" />
    <script type="text/javascript">

        $(document).ready(function () {
            var txtPhotoUrl = '#<%=txtPhotoUrl.ClientID %>';
            if ($(txtPhotoUrl).val() != "") {
                var imgPhoto = '<%=imgPhoto.ClientID %>';
                $('#' + imgPhoto).css('display', 'inline');
            }

            $(".close").click(function () {
                $(".alert").alert();
            });

        });

        function fileUpload(txtphotoUrlID, imgPhoto, imgLoading, fileToUploadID) {             
            var validatorPhotoUrl = '#<%=validatorPhotoUrl.ClientID %>';
            $(validatorPhotoUrl).css("visibility", "hidden");

            var rootServerPath = '<%=ResolveUrl("~")%>';
            ajaxFileUpload(rootServerPath, txtphotoUrlID, imgLoading, fileToUploadID, validatorPhotoUrl, imgPhoto, '<%=linAddPhoto.ClientID %>', '<%=dontDeletePreImage.ClientID %>');
        }

        function doSave() {
            var validatorPhotoUrl = '#<%=validatorPhotoUrl.ClientID %>';
            $(validatorPhotoUrl).text('Please add sponsor image.');
            $(validatorPhotoUrl).attr('title', 'Please add sponsor image.');
            if (Page_ClientValidate("Update")) {
                var btnAdd = '#<%=btnAdd.ClientID %>';
                if (btnAdd)
                    $(btnAdd).attr("disabled", "disabled");

                var btnUpdate = '#<%=btnUpdate.ClientID %>';
                if (btnUpdate)
                    $(btnUpdate).attr("disabled", "disabled");
            }
        }

        function clearForm() {
            var txtName = '#<%=txtName.ClientID %>';
            $(txtName).val("");
            var validatorName = '#<%=validatorName.ClientID %>';
            $(validatorName).css("visibility", "hidden");

            var txtWebsite = '#<%=txtWebsite.ClientID %>';
            $(txtWebsite).val("");
            var validatorWebsite = '#<%=validatorWebsite.ClientID %>';
            $(validatorWebsite).css("visibility", "hidden");

            var txtPhotoUrl = '#<%=txtPhotoUrl.ClientID %>';
            $(txtPhotoUrl).val("");

            var imgPhoto = '<%=imgPhoto.ClientID %>';
            $('#' + imgPhoto).css('display', 'none');
            var validatorPhotoUrl = '#<%=validatorPhotoUrl.ClientID %>';
            $(validatorPhotoUrl).css("visibility", "hidden");

        }
    </script>

    <style type="text/css" ">
         .row
         {
             margin-right: 25px;
             margin-left: -25px;
         }

         form input.text, form select, form textarea
         {
             margin-top: 10px;
             margin-bottom: 10px;
         }

         .message-error
         {
             font-size: 1em;
         }
     </style>
</asp:Content>