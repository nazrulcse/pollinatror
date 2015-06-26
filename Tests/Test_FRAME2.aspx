<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test_FRAME2.aspx.cs" Inherits="Tests_Test_FRAME2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
</head>
<body>
    <form id="form1" runat="server">
        <script type="text/javascript">
            window.onload = function () {
                var port = '<%= Request.Url.Port == 80? string.Empty: ":" + Request.Url.Port%>';
                
                window.location.href = 'http://<%=Request.Url.Host%>' + port + "/ShareMap.aspx";
            }

        </script>

        <asp:Label runat="server" id="lblDebug"></asp:Label>
    </form>
</body>
</html>
