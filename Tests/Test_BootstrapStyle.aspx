<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test_BootstrapStyle.aspx.cs" Inherits="Test_BootstrapStyle" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        
<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
<script type="text/javascript" src="http://code.jquery.com/jquery.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/js/bootstrap.min.js"></script>
<style type="text/css">
	.bs-example{
		margin: 20px;
	}
</style>

    <div class="bs-example">
    <div class="alert alert-info">
        <a href="#" class="close" data-dismiss="alert">&times;</a>
        <strong>Note!</strong> Please read the comments carefully.
    </div>
</div>


    <div class="alert alert-success">
        <a href="#" class="close" data-dismiss="alert">&times;</a> 
        <asp:Label ID="StatusMessage" runat="server" Text="Updated successfully"></asp:Label>
    </div>
        
    <div class="alert alert-failure">
        <a href="#" class="close" data-dismiss="alert">&times;</a> 
        <asp:Label ID="Label1" runat="server" Text="There is an error in updating database."></asp:Label>
    </div>
        
         <!-- HTML to write -->
<a href="#" data-toggle="tooltip" title="Some tooltip text!" id="linkTooltip">Hover over me</a>

<!-- Generated markup by the plugin -->
 <div class="tooltip top">
   <div class="tooltip-inner">
      Some tooltip text!
    </div>
    <div class="tooltip-arrow"></div>
 </div>
<script type="text/javascript">
$(document).ready(function () {

    $('#linkTooltip').tooltip('toggle');
});
</script>

<br/> <br/>
<input type="text" id="btnPopover" class="btn btn-default" data-container="body" data-toggle="popover" data-content="Vivamus sagittis lacus vel augue laoreet rutrum faucibus.">
Popover on left
</input>
<script type="text/javascript">
    $(document).ready(function () {

        $('#btnPopover').popover('show');
        $('#btnPopover').popover('hide');
    });
</script>
<br/><br/>
    
<%--    <asp:LinkButton ID="btnUpdate" runat="server" class="btn btn-success fileinput-button" Text="<i class='glyphicon glyphicon-edit'></i> <span>Update</span>" />

    <asp:LinkButton ID="btnDelete" runat="server" Text="<i class='glyphicon glyphicon-trash'></i> <span>Edit</span>" OnClientClick="return confirm('Are you sure you want delete?');" CssClass="btn btn-danger delete" ></asp:LinkButton>
    
    --%>
        
        &nbsp;
    <button type="button" class="btn btn-success" style="height: 40px;font-family: Segoe UI;font-size: 1.2em;font-weight: 600" >
        <i class="glyphicon glyphicon-edit"></i>
        <span>Update</span>
    </button>
        
    <button type="button" class="btn btn-danger delete " style="height: 40px;font-family: Segoe UI;font-size: 1.2em;font-weight: 600" onclick="return confirm('Are you sure you want delete?');" >
        <i class="glyphicon glyphicon-trash"></i>
        <span>Delete</span>
    </button>

    <script type="text/javascript">
        $(document).ready(function () {
            $(".close").click(function () {
                $(".alert").alert();
            });
        });
</script>
    
    <!-- Button trigger modal -->
<button class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">
  Launch demo modal
</button>

<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
      </div>
      <div class="modal-body">
        ...
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div>
    </form>
</body>
</html>
