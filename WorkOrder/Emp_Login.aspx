﻿<%@ Page Language="C#" Title="" AutoEventWireup="true" CodeFile="Emp_Login.aspx.cs" Inherits="Emp_Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>员工上下岗操作</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1,user-scalable=no"/>

    <script src="/Scripts/jquery-1.10.2.min.js"></script> 
    <script src="/Content/layer/layer.js"></script>

    <link href="../css/weui.css" rel="stylesheet" />
    <link href="../css/weuix.css" rel="stylesheet" />
    <script src="../js/zepto.min.js"></script>
    <script src="../js/zepto.weui.js"></script>
</head>
<body>

    <script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <%--步骤二：通过config接口注入权限验证配置--%>
    <script>  
        $(document).ready(function () {
            //$("#btn_bind_data").css("display", "none");

            if ($("#btn_sure").val() == "离岗确认") {
                $("#div_emp").hide(); $("#div_code").hide(); $("#div_login_on").show();
            } else {
                $("#div_login_on").hide();
            }
        });

        function e_code_change() {
            if ($("#e_code").val() == "") {
                layer.alert('【设备】不可为空');
                return;
            }
            $("#<%=btn_bind_data.ClientID%>").click();
        }

        $(function(){
            $("#e_code").keyup(function (e) {
                if ("<%=_workshop %>"=="三车间") {
                    if (($("#e_code").val()).length >= 3) {
                        e_code_change();
                    }
                } else {
                    if (($("#e_code").val()).length >= 5) {
                        e_code_change();
                    }
                }
               
            });
        });

    </script>
    <script>
        $.ajax({
            url: "/getwxconfig.aspx/GetScanQRCode",
            type: "Post",
            data: "{ 'url': '" + location.href + "' }",
            async: false,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                var datad = JSON.parse(data.d); //转为Json字符串
                wx.config({
                    debug: false, // 开启调试模式
                    appId: datad.appid, // 必填，公众号的唯一标识
                    timestamp: datad.timestamp, // 必填，生成签名的时间戳
                    nonceStr: datad.noncestr, // 必填，生成签名的随机串
                    signature: datad.signature,// 必填，签名，见附录1
                    jsApiList: ["scanQRCode"] // 必填，需要使用的JS接口列表
                });
                //wx.error(function (res) {
                //    alert(res);
                //});
                wx.ready(function () {
                    //扫描二维码
                    document.querySelector('img[id*=img_sm]').onclick = function () {
                        wx.scanQRCode({
                            needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
                            scanType: ["qrCode", "barCode"], // 可以指定扫二维码还是一维码，默认二者都有
                            success: function (res) {
                                var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
                                // code 在这里面写上扫描二维码之后需要做的内容                       
                                $('#e_code').val(result);
                                //$('#e_code').change();
                                e_code_change();

                            }
                        });
                    };//end_document_scanQRCode
                });
            },
            error: function (error) {
                alert(error)
            }
        });
    </script>
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server">
    </asp:ScriptManager>
    
        
        <div class="weui-cells weui-cells_form">    

            <div class="weui-form-preview" id="div_login_on">
                <div class="weui-form-preview__bd">
                    <asp:Repeater runat="server" ID="listBxInfor">
                        <ItemTemplate>
                            <div class="weui-form-preview__item"> 
                                <label class="weui-form-preview__label">上岗人</label>
                                <span class="weui-form-preview__value"><%# Eval("emp_code")+""+Eval("emp_name") %></span>
                            </div>
                            <div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">上岗时间</label>
                                <span class="weui-form-preview__value"><%# Eval("on_date","{0:yyyy-MM-dd HH:mm}") %></span>
                            </div>
                            <div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">时长</label>
                                <span class="weui-form-preview__value"><%# Eval("times") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            
            <asp:TextBox ID="domain" class="form-control" ReadOnly="true" placeholder="" Style="max-width: 100%" runat="server" Visible="false"></asp:TextBox>

            <div id="div_emp" class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">登入人</label></div>
                <asp:TextBox ID="txt_emp" class="weui-input" ReadOnly="true" placeholder="" runat="server" style="color:gray"></asp:TextBox>
            </div>

            <div id="div_code" class="weui-cell">
                <div class="weui-cell__hd f-red"><label class="weui-label">当前岗位</label></div>
                <div class="weui-cell__bd">
                    <span style="float:left; width:90%">
                        <asp:TextBox ID="e_code" class="weui-input" runat="server" placeholder="请输入当前设备" onkeyup="this.value=this.value.toUpperCase()" ></asp:TextBox> <%--onchange="e_code_change()"--%>
                    </span>
                    <span style="float:left; width:10%">
                        <img id="img_sm" src="../img/fdj2.png" style="padding-top:10px;" />
                    </span>
                </div>
            </div>

            <br />

            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:GridView ID="GridView1" 
                        AllowMultiColumnSorting="True" AllowPaging="True"
                        AllowSorting="True" AutoGenerateColumns="False"
                        OnPageIndexChanging="GridView1_PageIndexChanging" OnRowDeleting="GridView1_RowDeleting" DataKeyNames="id"
                        runat="server" Font-Size="Small" Width="96%" style="margin-left:2%; margin-right:2%;" PageSize="5" BackColor="White" BorderColor="#e5e5e5" BorderStyle="solid" BorderWidth="1px" CellPadding="4" ForeColor="#999999" GridLines="Horizontal">
                    <FooterStyle BackColor="#CCCC99" ForeColor="#999999" />
                    <PagerSettings FirstPageText="首页" LastPageText="尾页" NextPageText="下页" PreviousPageText="上页" />
                    <PagerStyle ForeColor="Black" BackColor="White" HorizontalAlign="Right" />
                    <SelectedRowStyle BackColor="#CC3333" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#ffffff" Font-Bold="True" ForeColor="#999999" HorizontalAlign="Center" />

                    <Columns>  
                        <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" />
                        <asp:BoundField DataField="location" HeaderText="location" ReadOnly="True" />
                        <asp:BoundField DataField="e_code" HeaderText="设备号" ReadOnly="True" ItemStyle-Width="20%">
                            <HeaderStyle Wrap="True" />
                        <ItemStyle Width="20%" />
                        </asp:BoundField> 
                        <asp:BoundField DataField="location_desc" HeaderText="车间/生产线/岗位" ReadOnly="True" ItemStyle-Width="65%">
                            <HeaderStyle Wrap="True" />
                        <ItemStyle Width="65%" />
                        </asp:BoundField> 
                        <asp:CommandField HeaderText="" ShowDeleteButton="True" ItemStyle-Width="15%" >
                        <ItemStyle Width="15%" />
                        </asp:CommandField>
                    </Columns>
                    <SortedAscendingCellStyle BackColor="#F7F7F7" />
                    <SortedAscendingHeaderStyle BackColor="#4B4B4B" />
                    <SortedDescendingCellStyle BackColor="#E5E5E5" />
                    <SortedDescendingHeaderStyle BackColor="#242121" />
                </asp:GridView>

                <asp:Button ID="btn_bind_data" runat="server" Text="绑定grid数据" style="display:none;" OnClick="btn_bind_data_Click"/>
            </ContentTemplate>
            </asp:UpdatePanel>

            <div class="weui-cell">
                <asp:Button ID="btn_sure" class="weui-btn weui-btn_primary" runat="server" Text="上岗确认" OnClick="btn_sure_Click"/>
            </div>
            
        </div>   
            
    </form>
</body>
</html>
