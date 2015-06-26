<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ImportData.aspx.cs" Inherits="Admin_ImportData" %>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">
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

    <script src="../Scripts/common.js" type="text/javascript"></script>
     <noscript>
       <link rel="stylesheet" href="<%=ResolveUrl("~/css/skel-noscript.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/Content/Site.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/css/style-wide.css")%>" />
        <link rel="stylesheet" href="<%=ResolveUrl("~/Content/css3-breadcrumb-navigation.css")%>" />
    </noscript>
    <asp:PlaceHolder ID="PlaceHolder1" runat="server">
        <%=Scripts.Render("~/js/skel.min.js")%>
    </asp:PlaceHolder>

    <!-- Prefixfree -->
    <link rel="stylesheet" href="<%=ResolveUrl("~/Content/css3-breadcrumb-navigation.css")%>" />
    <script src="../Scripts/prefixfree-1.0.7-breadcrumb-navigation.js" type="text/javascript" type="text/javascript"></script>
    <style type="text/css">
        div.fileinputs {
            position: relative;
        }

        div.fakefile {
            position: absolute;
            top: 0px;
            left: 0px;
            z-index: 1;
        }

        input.file {
            position: relative;
            text-align: right;
            -moz-opacity: 0;
            filter: alpha(opacity: 0);
            opacity: 0;
            z-index: 2;
        }

        div.scrollDiv {
            width: 100%;
            max-height:1000px;
            overflow: auto;
            border: 1px solid #ccc;
        }
        div.SectionStep {
            width: 100%; 
            border-top: 1px solid;
            margin-top:10px;
            padding-top:8px;
            
        }

        .inline-rb input[type="radio"] {
            width: auto;
        }

        .inline-rb label {
            display: inline;
            margin-right: 40px;
            margin-left: 3px;
        }

        

        .titleSection {
            font-weight:800;
            text-decoration:underline;
        }
        .gridview {
            width: 150%;
            text-wrap:none;
            grid-cell:initial;
            grid-flow:rows;
        }

        table.gridview th, td{
                border: 1px solid white;
                padding: 5px;
            }

        .gridviewHeader {
            padding:5px;
        }

        .gridview tr:hover {
            background-color: #fcf68f;
        }

        .normalRow {
            color:#333333;
            background-color:#F7F6F3;
        }

        .alternateRow {
            color:#284775;
            background-color:White;
        }

        .SelectedRowStyle
        {
            background-color: #fcf68f;
            color: blue;
        }

        button.button {
            padding: 12px 27px;
        }

        span.step {
            background: #cccccc;
            border-radius: 0.8em;
            -moz-border-radius: 0.8em;
            -webkit-border-radius: 0.8em;
            color: #ffffff;
            display: inline-block;
            font-weight: bold;
            line-height: 1.6em;
            margin-right: 5px;
            text-align: center;
            width: 1.6em;
        }
        span.stepSub {
            border-radius: 0.8em;
            -moz-border-radius: 0.8em;
            -webkit-border-radius: 0.8em;
            display: inline-block;
            font-weight: bold;
            line-height: 1.6em;
            margin-right: 5px;
            text-align: center;
            width: 1.6em;
        }
        table#MainContent_rblActionForExistedData td{
                border: none;
            }
        form select
        {    
            -webkit-appearance: none;            
        }
    </style>
     <script type="text/javascript" language="javascript">
         $(document).ready(function () {
             var Chrome = false;
             if (navigator.userAgent.toLowerCase().indexOf('chrome') > -1) {
                 Chrome = true;
                 $('.registerSelect').addClass('dropdownlist');
             }
             else if (navigator.userAgent.toLowerCase().indexOf('mozilla') > -1) {
                 $('.registerSelect').addClass('dropdownlistFirefox');
             }

             

             //onchange dropdown && mess == 'There is no valid data to continue importing.'
             $('#<%=ddlImportedUserType.ClientID %>').change(function () {
                 if (this.value == "premium") {
                     $('#divPremium').show();
                 }
                 else $('#divPremium').hide();
             });

             //highlight selected row grid
             $('.gridview tr').click(function () {
                 $('.gridview tr').removeClass('SelectedRowStyle');
                 $(this).addClass('SelectedRowStyle');
             });

             //show/hide button Continue
             $('#<%=rblActionForExistedData.ClientID%>').change(function () {
                 $('#<%= btnDCorrectionContinue.ClientID%>').removeAttr("disabled");
                 $('#<%= btnDCorrectionContinue.ClientID%>').attr('title', 'Continue import progress');

                 var rbvalue = $("input[name='<%=rblActionForExistedData.UniqueID%>']:radio:checked").val();
                 var mess = $('#<%= lblErrorMess.ClientID%>').text();
                 if (mess) {
                     if (rbvalue == 'Skip') {
                         $('#<%= btnDCorrectionContinue.ClientID%>').attr("disabled", "disabled");
                         $('#<%= btnDCorrectionContinue.ClientID%>').attr('title', 'There is no valid data to continue import process');
                     }
                 }
             });
        });
    </script>

        <div class="admincontainer">
        <div style="padding-left: 3px;padding-right: 3px;" >
            <%--<h2 style="margin-left: -8px">Import Data</h2>--%>
            <div class="breadcrumb flat" style="margin-bottom: 15px; margin-top: 30px">
	            <a href="#" id="astep1" runat="server" class="active" style="cursor:context-menu" title="Select a .CSV file">Browse File</a>
	            <a href="#" id="astep2" runat="server" style="cursor:context-menu" title="Examine data records, detect difference and suggest action before importing">Data Verification</a>
	            <a href="#" id="astep3" runat="server" style="cursor:context-menu" title="Import valid data records onto system">Import</a>
	            <a href="#" id="astep4" runat="server" style="cursor:context-menu" title="Import data is complete and all the information is writen to log">Finish</a>
            </div>
            <fieldset style="border: 1px #ccc solid; padding-bottom: 10px; width: 100%; padding-top: 2px;">
                <legend style="font-size: 20px;width:auto">Import Data</legend>
                <div runat="server" id="divStep0">
                <div style="float: right; text-align:right;">
                            <a  ID="LinkButton1" href="AdminFiles/ImportUsers-Template.csv" Style="color: blue" title="Click here to download a template file">Import Format - Download</a>
                 </div>
                <div class="row half">
                    <div class="6u" style="width: 14%; padding-top: 46px;">
                        <asp:Label ID="lblUserType" runat="server">Data source:</asp:Label>
                    </div>
                    <div class="6u" style="width: 80%" >
                        <asp:DropDownList ID="ddlImportedUserType" Width="60%" runat="server" CssClass="registerSelect" placeholder="Please select one">
                            <asp:ListItem Value="NONE">Please select</asp:ListItem>
                            <asp:ListItem Value="normal">SHARE Users</asp:ListItem>
                            <asp:ListItem Value="premium">BFF Farmer Users</asp:ListItem>
                        </asp:DropDownList>
                        <div style="display:none" id="divPremium">All BFF users imported should have already paid annual membership fee.</div>
                        <asp:RequiredFieldValidator InitialValue="NONE" Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="rfvNor5" runat="server" ControlToValidate="ddlImportedUserType" ErrorMessage="Data source is required" ToolTip="Data source is required" ValidationGroup="group1">Data source is required</asp:RequiredFieldValidator>
                    </div>
                     
                </div>
                <div class="row half">
                    <div class="6u" style="width: 14%; padding-top: 40px;">
                        <asp:Label ID="Label1" runat="server">Browse a file:</asp:Label>
                    </div>
                    <div class="6u" style="width: 85%;">
                        <asp:FileUpload ID="importFile" runat="server" CssClass="text" Enabled="true" ClientIDMode="Static" placeholder="Browse a CSV file" Style="width: 100%;" />
                        <asp:RequiredFieldValidator Display="Dynamic" CssClass="message-error" SetFocusOnError="true" ID="RequiredFieldValidator1"
                             runat="server" ControlToValidate="importFile" ErrorMessage="Browse a CSV file" ToolTip="Browse a CSV file" ValidationGroup="group1">Browse a CSV file</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="regexValidator" runat="server" Display="Dynamic" CssClass="message-error"
                            ControlToValidate="importFile"
                            ErrorMessage="Only CSV files are allowed"
                            ValidationExpression="(.*\.([cC][sS][vV])$)" ValidationGroup="group1"> 
                        </asp:RegularExpressionValidator>
                    </div>
                </div>
                </div>
                <div class="row half">
                    <%--<div class="6u" style="width: 20%; padding-top: 35px;"></div>--%>
                    <div class="6u" style="width: 100%;padding-top:10px;">
                      <div style="float: left;">
                          <asp:Label ID="lblMess" runat="server"></asp:Label>
                      </div>
                        <div style="float: right;">
                            <button id="btnImport" type="button" causesvalidation="True" validationgroup="group1"
                                class="submit button btn12" runat="server" onserverclick="btnImport_Click">
                                Next Step</button>
                        </div>
                    </div>
                </div>
                <%--<asp:GridView ID="grvData" runat="server" AutoGenerateColumns="true"></asp:GridView>--%>
                <div>
                        <asp:Label ID="lblErrorMess" CssClass="message-error" runat="server"></asp:Label>
                </div>

                <div id="divFailedData" runat="server" class="SectionStep">
                    <div style="width: 100%">
                        <%--<div style="width: 40%; float: left; text-align: left">
                            <asp:Label runat="server" ID="lbl1" CssClass="titleSection">The following data is not valid:</asp:Label>
                            <asp:Label runat="server" ID="lblNumRowFailed">10 rows</asp:Label>
                        </div>--%>
                        <div style="float: right; text-align: right; color: darkgreen; padding-right: 10px;">
                            <asp:LinkButton style="color: blue" runat="server" ID="lnkExportFailedData" OnClick="lnkExportFailedData_Click">Download log file</asp:LinkButton>
                        </div>
                    </div>
                    <div class="scrollDiv" >
                        <asp:GridView ID="gvFailedData" CssClass="gridview"  runat="server" CellPadding="4" ForeColor="#333333" 
                            AutoGenerateColumns="False" HeaderStyle-Wrap="false" HeaderStyle-CssClass="gridviewHeader" >
                            <AlternatingRowStyle CssClass="alternateRow" />
                            <RowStyle CssClass="normalRow"/>
                            <Columns>
                                <asp:BoundField DataField="LineNumber" HeaderText="#Line" HeaderStyle-HorizontalAlign="Center"  ItemStyle-HorizontalAlign="Center">
<HeaderStyle HorizontalAlign="Center"></HeaderStyle>

<ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Error Description">
                                    <EditItemTemplate>
                                        <asp:Literal ID="TextBox1" runat="server" Text='<%# Bind("ErrorDescription") %>'></asp:Literal>
                                    </EditItemTemplate>
                                    <HeaderTemplate>
                                        <img style="margin-bottom: -6px;" alt="" src="../Images/taken.png" />
                                        Error Description
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("ErrorDescription").ToString() %>'></asp:Label>
                                    </ItemTemplate>
                                    <%--<ItemStyle Width="500px" />--%>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="First Name">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("FirstName") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# ShowText( Eval("FirstName").ToString()) %>' ToolTip='<%# Bind("FirstName") %>' ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Last Name">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox3" runat="server" Text='<%# ShowText( Eval("LastName").ToString()) %>' ToolTip='<%# Bind("LastName") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label3" runat="server" Text='<%# ShowText( Eval("LastName").ToString()) %>' ToolTip='<%# Bind("LastName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Organization Name">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("OrganizationName") %>' ></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label4" runat="server" Text='<%# ShowText( Eval("OrganizationName").ToString()) %>' ToolTip='<%# Bind("OrganizationName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Address">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("Address") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label5" runat="server" Text='<%# ShowText( Eval("Address").ToString()) %>' ToolTip='<%# Bind("Address") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="City">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox6" runat="server" Text='<%# Bind("City") %>' ></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label6" runat="server" Text='<%# ShowText( Eval("City").ToString()) %>' ToolTip='<%# Bind("City") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="State" HeaderText="State" />
                                <asp:BoundField DataField="ZIP" HeaderText="ZIP" />
                                <asp:TemplateField HeaderText="Country">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox7" runat="server" Text='<%# Bind("Country") %>' ></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label7" runat="server" Text='<%# ShowText( Eval("Country").ToString()) %>' ToolTip='<%# Bind("Country") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EditRowStyle CssClass="SelectedRowStyle" />
                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" Wrap="False" />
                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                            <SortedAscendingCellStyle BackColor="#E9E7E2" />
                            <SortedAscendingHeaderStyle BackColor="#506C8C" />
                            <SortedDescendingCellStyle BackColor="#FFFDF8" />
                            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                        </asp:GridView>
                    </div>
                    <div class="row half" style="margin-top: 20px;">
                        <div style="float: right;">
                                <button id="btnDCheckingBack" type="button" class="submit button btn36" runat="server"  title="back" onclick="window.history.back(); return true;" >Back</button>
                                <button id="btnDCheckingSkipContinue" type="button" class="submit button btn12" runat="server" onserverclick="btnDCheckingSkipContinue_ServerClick" title="Continue import progress and skip invalid data">Skip & Continue</button>

                                <button id="btnDCheckingCancel" type="button" class="submit button btn36" style="min-width: 150px;"
                                    runat="server" onserverclick="btnDCheckingCancel_ServerClick" title="Click here to stop import">
                                    <span>Cancel Import</span>
                                </button>
                            </div>
                    </div>
                </div>

                 <div id="divExistedData" runat="server" class="SectionStep">
                    <div style="width: 100%">
                       <%-- <div style="width: 40%; float: left; text-align: left">
                            <asp:Label runat="server" ID="Label2" CssClass="titleSection">The following data was existed in database:</asp:Label>
                            <asp:Label runat="server" ID="lblNumRowExisted">10 rows</asp:Label>
                        </div>--%>
                        <div style="float: right; text-align: right; color: darkgreen; padding-right: 10px;">
                            <asp:LinkButton style="color: blue" runat="server" ID="lnkExportExistedData" OnClick="lnkExportExistedData_Click">Download log file</asp:LinkButton>
                        </div>
                    </div>
                    <div class="scrollDiv">
                        
                        <asp:GridView ID="gvExistedData" runat="server" CssClass="gridview" CellPadding="4" AutoGenerateColumns="False" ForeColor="#333333" GridLines="None">
                            <AlternatingRowStyle CssClass="alternateRow" />
                            <RowStyle CssClass="normalRow"/>
                            <Columns>
                                <asp:BoundField DataField="LineNumber" HeaderText="#Line" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Confirmation Before Import">
                                    <EditItemTemplate>
                                        <asp:Literal ID="TextBox1" runat="server" Text='<%# Bind("ExistedDataDescription") %>'></asp:Literal>
                                    </EditItemTemplate>
                                    <HeaderTemplate>
                                        <img style="margin-bottom: -3px;" alt="" src="../Images/icon/alarmYellow24_24.png" />
                                        Confirmation Before Import
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("ExistedDataDescription").ToString() %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle Width="550px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="First Name">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("FirstName") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# ShowText( Eval("FirstName").ToString()) %>' ToolTip='<%# Bind("FirstName") %>' ></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Last Name">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox3" runat="server" Text='<%# ShowText( Eval("LastName").ToString()) %>' ToolTip='<%# Bind("LastName") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label3" runat="server" Text='<%# ShowText( Eval("LastName").ToString()) %>' ToolTip='<%# Bind("LastName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Organization Name">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("OrganizationName") %>' ></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label4" runat="server" Text='<%# ShowText( Eval("OrganizationName").ToString()) %>' ToolTip='<%# Bind("OrganizationName") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Address">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("LandscapeStreet") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label5" runat="server" Text='<%# ShowText( Eval("LandscapeStreet").ToString()) %>' ToolTip='<%# Bind("LandscapeStreet") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="City">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox6" runat="server" Text='<%# Bind("LandscapeCity") %>' ></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label6" runat="server" Text='<%# ShowText( Eval("LandscapeCity").ToString()) %>' ToolTip='<%# Bind("LandscapeCity") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="State">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox8" runat="server" Text='<%# Bind("LandscapeState")%>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label8" runat="server" Text='<%# Bind("LandscapeState")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="ZIP">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox9" runat="server" Text='<%# Bind("LandscapeZipcode")%>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label9" runat="server" Text='<%# Bind("LandscapeZipcode")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Country">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="TextBox7" runat="server" Text='<%# Bind("LandscapeCountryName")%>' ></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("LandscapeCountryName")%>' ToolTip='<%# Bind("LandscapeCountryName")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EditRowStyle BackColor="#999999" />
                            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
                            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
                            <SortedAscendingCellStyle BackColor="#E9E7E2" />
                            <SortedAscendingHeaderStyle BackColor="#506C8C" />
                            <SortedDescendingCellStyle BackColor="#FFFDF8" />
                            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
                        </asp:GridView>
                    </div>
                     <fieldset style="border: 1px #ccc solid; height: 90px;">
                        <legend style="font-size: 16px;font-weight: 100;"><asp:Label runat="server" ID="Label4">Choose an action</asp:Label></legend>
                         <div style="text-align:center; width: 100%;margin-top: -10px;">
                             <asp:RadioButtonList runat="server" ID="rblActionForExistedData" RepeatDirection="Horizontal"
                                 TextAlign="Right" CssClass="inline-rb">
                                 <asp:ListItem Value="Skip" Text="Skip" Selected="True"></asp:ListItem>
                                 <asp:ListItem Value="New" Text="New"></asp:ListItem>
                                 <asp:ListItem Value="Overwrite" Text="Overwrite"></asp:ListItem>
                             </asp:RadioButtonList>
                         </div>
                     </fieldset>
                    <div class="row half" style="margin-top: -20px;">
                            <%--<div><label><span style="font-weight:bold;">*Note: </span>Please horizontal scroll to end of line to view details description.</label></div>--%>
                            <div style="float: right;">
                                <button id="Button1" type="button" class="submit button btn36" runat="server"  title="back" onclick="window.history.back(); return true;" >Back</button>
                                <button id="btnDCorrectionContinue" type="button" class="submit button btn12" runat="server" onserverclick="btnDCorrectionContinue_ServerClick" title="Continue import progress">Continue</button>
                                <button id="btnDCorrectionCancel" type="button" class="submit button btn36" style="min-width: 150px;"
                                    runat="server" onserverclick="btnDCorrectionCancel_ServerClick" title="Click here to stop import">
                                    <span>Cancel Import</span>
                                </button>
                            </div>
                    </div>
                </div>


                 <div id="divImportSuccessful" runat="server" class="SectionStep" style="border:none">
                      <div class="row half" >
                        
                            <asp:Label runat="server" ID="Label6"  Font-Size="14" Font-Bold="true" ForeColor="Blue">Import Finished</asp:Label>
                          
                    </div>
     

                     <div style="padding-left:10px">
                            <div >
                                <asp:Label runat="server" ID="lblTotalDataRecord1" CssClass="lblLeft"><span class='step'>1</span>Total data records:</asp:Label>
                                  <asp:Label runat="server" ID="lblTotalDataRecord">10 rows</asp:Label>
                            </div>
                      
                        </div>
                      <div style="padding-left:10px">
                            <div >
                                <asp:Label runat="server" ID="Label5" CssClass="lblLeft"><span class='step'>2</span>Records imported:</asp:Label>
                                  <asp:Label runat="server" ID="lblNumImported">10 rows</asp:Label>
                            </div>
                      
                        </div>

                      <div style="padding-left:10px">
                        <div >
                            <asp:Label runat="server" ID="Label7" CssClass="lblLeft"><span class='step'>3</span>Records ignored:</asp:Label>
                              <asp:Label runat="server" ID="lblNumNotImported">10 rows</asp:Label>
                        </div>
                        
                    </div>

                      <div style="padding-left:25px">
                        <div>
                            <asp:Label runat="server" ID="Label10" CssClass="lblLeft"><img src="../Images/icon/fast-forward.png" /> Invalid records:</asp:Label>
                            <asp:Label runat="server" ID="lblNumInvalid">10 rows</asp:Label>
                            <asp:LinkButton style="color: blue;" runat="server" ToolTip="Click here to get log file" ID="lnkFinishInvalidLog" OnClick="lnkExportFailedData_Click">(View Log File)</asp:LinkButton>
                        </div>
                    </div>

                      <div  style="padding-left:25px">
                        <div >
                            <asp:Label runat="server" ID="Label11" CssClass="lblLeft"><img src="../Images/icon/fast-forward.png" /> Manually skipped:</asp:Label>
                            <asp:Label runat="server" ID="lblNumSkipExist">10 rows</asp:Label>
                            <asp:LinkButton style="color: blue;" runat="server" ID="lnkFinishSkipLog" ToolTip="Click here to get log file" OnClick="lnkExportExistedData_Click">(View Log File)</asp:LinkButton>
                        </div>
                       
                    </div>
                  
                     <div class="row half" style="margin-top: 30px;">
                            <div style="float: right;">
                                <button id="btnSuccessfullFinish" style="width:144px" type="button" class="submit button btn12" runat="server" onserverclick="btnSuccessfullFinish_ServerClick">Finish</button>
                               
                            </div>
                    </div>
                </div>

                <div id="divImportFail" runat="server" class="SectionStep">
                      <div class="row half" >
                        
                            <asp:Label runat="server" ID="Label8"  Font-Size="14" Font-Bold="true" ForeColor="Red">Import Failed</asp:Label>
                          
                    </div>

                     <div class="row half" >
                        
                            <asp:Label runat="server" ID="Label9"  Font-Size="12" ForeColor="Red">Error: Data cannot be imported……</asp:Label>
                         <asp:HyperLink runat="server" ID="linErrorLog"  Font-Size="12"  ForeColor="Blue">Click here to view log file for details</asp:HyperLink>
                          
                    </div>

                      
                     <div class="row half" style="margin-top: 30px;">
                            <div style="float: right;">
                                <button id="btnFailFReTry" type="button" class="submit button btn12" runat="server" onserverclick="btnFailFReTry_ServerClick">Re-try Import</button>
                                <button id="btnFailFinish" type="button" class="submit button btn12" runat="server" onserverclick="btnFailFinish_ServerClick">Finish</button>
                               
                            </div>
                    </div>
                </div>

            </fieldset>
        </div>
    </div>

    <%--Show process bar such as while redirect to paypal page--%>
        <a class="submit button btn12" href="#Processbar_form" id="showProcessbar" style="display: none">Please wait...</a>
        <a href="#x" class="overlay" id="Processbar_form"></a>
        <div class="popup" style="height:auto;  background:none; border:none">
          <div style="width:auto; text-align:center">
            <p style="color: white; margin-bottom: 0px;z-index: 10;">You are being redirected to the PayPal Payment Form...</p>
            <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/process/loadingprogressbar_animated.gif" AlternateText="please wait.." />
          </div>
        </div>

    <script type="text/javascript">
        //Disable auto close popup when clickshowProcessbar
        $('#Processbar_form').on('click', function (e) {
            e.preventDefault();
        });
    </script>
</asp:Content>
