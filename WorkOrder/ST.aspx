﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ST.aspx.cs" Inherits="WorkOrder_ST" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1,user-scalable=no">
    <title>送汤</title>
    <script src="/Scripts/jquery-1.10.2.min.js"></script> 
    <script src="/Content/layer/layer.js"></script>

    <link href="../css/weui.css" rel="stylesheet" />
    <link href="../css/weuix.css" rel="stylesheet" />
    <script src="../js/zepto.min.js"></script>
    <script src="../js/zepto.weui.js"></script>
    <style>
        .weui-mark-lt {
            color: #fff;
            display: block;
            font-size: 0.775em !important;
            left: -0.5em;
            height: 1em;
            line-height: 1em !important;
            position: relative;
            text-align: center;
            top: 0.55em;
            transform: rotate(-45deg);
            width: 3.375em;
            padding: 0.125em;
        }
    </style>
    <style>
        .weui-cell{
            padding:4px 15px;
        }
        .weui-btn + .weui-btn{
            margin-top:0px;
        }
    </style>

     <script>
         $(document).ready(function () {
         });

         $(function () {
             sm_yzj();

             $("#yzj").keyup(function (e) {
                 if (($("#yzj").val()).length >= 3) {
                     yzj_change();
                 }
            });

            $("#btn_sl2").click(function () {
                $("#btn_sl2").attr("disabled", "disabled");
                $("#btn_sl2").removeClass('weui-btn_primary').addClass('weui_btn_disabled weui_btn_default');

                $("#btn_cancel2").attr("disabled", "disabled");
                $("#btn_cancel2").removeClass('weui-btn_primary').addClass('weui_btn_disabled weui_btn_default');

                if (!valid_sl()) {
                    $("#btn_sl2").removeAttr("disabled");
                    $("#btn_sl2").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');

                    $("#btn_cancel2").removeAttr("disabled");
                    $("#btn_cancel2").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');
                    return;
                }

                $.confirm('确认【送汤】吗？', function () {
                    $.ajax({
                        type: "post",
                        url: "ST.aspx/sl2",
                        data: "{'_emp_code_name':'" + $('#emp_code_name').val() 
                            + "','need_t_no':'" + "<%= _need_t_no %>" + "','zyb':'" + $("#zyb").val() + "','lotno':'" + $("#lot_no").val()
                            + "','act_qty':'" + $('#act_qty').val()+ "','comment':'" + $('#comment').val()+ "','sku_area':'" + $("#sku_area").val()
                            + "','yzj_no':'" + $('#yzj').val() + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,//默认是true，异步；false为同步，此方法执行完在执行下面代码
                        success: function (data) {
                            var obj = eval(data.d);
                                
                                if (obj[0].flag == "Y") {
                                layer.alert(obj[0].msg);
                                $("#btn_sl2").removeAttr("disabled");
                                $("#btn_sl2").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');

                                $("#btn_cancel2").removeAttr("disabled");
                                $("#btn_cancel2").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');
                                return;
                            }
                            window.location.href = "/workorder/YT_list.aspx?workshop=<%=_workshop %>";
                        }
                    });                   
                }, function () {
                    //点击取消后的回调函数
                    $("#btn_sl2").removeAttr("disabled");
                    $("#btn_sl2").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');

                    $("#btn_cancel2").removeAttr("disabled");
                    $("#btn_cancel2").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');
                });
                
             });

            $("#btn_cancel2").click(function () {
                $("#btn_sl2").attr("disabled", "disabled");
                $("#btn_sl2").removeClass('weui-btn_primary').addClass('weui_btn_disabled weui_btn_default');

                $("#btn_cancel2").attr("disabled", "disabled");
                $("#btn_cancel2").removeClass('weui-btn_primary').addClass('weui_btn_disabled weui_btn_default');

                $.confirm('确认【取消送汤】吗？', function () {
                    $.ajax({
                        type: "post",
                        url: "ST.aspx/cancel2",
                        data: "{'_emp_code_name':'" + $('#emp_code_name').val() + "','need_t_no':'" + "<%= _need_t_no %>" + "'}",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        async: false,//默认是true，异步；false为同步，此方法执行完在执行下面代码
                        success: function (data) {
                            var obj = eval(data.d);
                            if (obj[0].flag == "Y") {
                                layer.alert(obj[0].msg);
                                $("#btn_sl2").removeAttr("disabled");
                                $("#btn_sl2").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');

                                $("#btn_cancel2").removeAttr("disabled");
                                $("#btn_cancel2").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');
                                return;
                            }
                            window.location.href = "/workorder/YT_list.aspx?workshop=<%=_workshop %>";

                        }

                    });
                }, function () {
                    //点击取消后的回调函数
                    $("#btn_sl2").removeAttr("disabled");
                    $("#btn_sl2").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');

                    $("#btn_cancel2").removeAttr("disabled");
                    $("#btn_cancel2").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');
                });
            });

        });

         function sm_yzj() {
             $('#img_sm_yzj').click(function () {
                 wx.ready(function () {
                     wx.scanQRCode({
                         needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
                         scanType: ["qrCode", "barCode"], // 可以指定扫二维码还是一维码，默认二者都有
                         success: function (res) {
                             var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
                             // code 在这里面写上扫描二维码之后需要做的内容  
                             $('#yzj').val(result);//result="1-1";
                             yzj_change();
                         }
                     });
                 });
             });
         }

         function yzj_change() {
             if ($('#yzj').val() != $('#yzj_no').val()) {
                 $.toptip($('#yzj').val() + '与要汤的压铸机'+ $('#yzj_no').val() +'不一致', 'error');
             }
         }

         function zyb_change() {
             $.ajax({
                 type: "post",
                 url: "ST.aspx/zyb_change",
                 data: "{'zyb':'" + $("#zyb").val() + "'}",
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 async: false,//默认是true，异步；false为同步，此方法执行完在执行下面代码
                 success: function (data) {
                     var obj = eval(data.d);

                     var json_lotno = obj[0].json_lotno;
                     $("#lot_no").select("update", { items: json_lotno });
                     $('#lot_no').val('');
                 }

             });
         }
         

        function lotno_change() {
            $.ajax({
                type: "post",
                url: "ST.aspx/lotno_change",
                data: "{'zyb':'" + $("#zyb").val() + "','lotno':'" + $("#lot_no").val() + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,//默认是true，异步；false为同步，此方法执行完在执行下面代码
                success: function (data) {
                    var obj = eval(data.d);
                    var flag = obj[0].flag;
                    if (flag == "Y") {
                        layer.alert(obj[0].msg);
                        $('#lot_no').val("");
                        $('#act_qty').val("");
                        $('#txt_sy_qty').val($('#cur_sy_qty').val());
                    } else {
                        $('#act_qty').val(obj[0].qty);
                        $('#txt_sy_qty').val(parseFloat($('#cur_sy_qty').val() == "" ? "0" : $('#cur_sy_qty').val()) - parseFloat(obj[0].qty == "" ? "0" : obj[0].qty));
                    }
                    return;
                }

            });
        }

        function act_qty_change() {
            $('#txt_sy_qty').val(parseFloat($('#cur_sy_qty').val() == "" ? "0" : $('#cur_sy_qty').val()) - parseFloat($('#act_qty').val() == "" ? "0" : $('#act_qty').val()));
        }

        function valid_sl() {
            if ($('#yzj').val() != $('#yzj_no').val()) {
                layer.alert($('#yzj').val() + "与要汤的压铸机" + $('#yzj_no').val() + "不一致.");
                return false;
            }
            if ($("#zyb").val() == "") {
                layer.alert("请输入【转运包】.");
                return false;
            }
            if ($("#lot_no").val() == "") {
                layer.alert("请输入【Lot No】.");
                return false;
            }
            if ($.trim($("#act_qty").val()) == "") {
                layer.alert("请输入【送汤量】.");
                return false;
            }
            else if (parseInt($("#act_qty").val()) <= 0) {
                layer.alert("【送汤量】必须大于0.");
                return false;
            }
            //else if (parseInt($("#act_qty").val()) > parseInt($("#sy_qty").val())) {
            //    layer.alert("【送汤量】不可大于【剩余量】.");
            //    return false;
            //}
            return true;
         }

    </script>

</head>
<body>
    <script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
    <%--步骤二：通过config接口注入权限验证配置--%>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server">
        </asp:ScriptManager>
   

        <div class="weui-cells weui-cells_form">

            <div class="weui-form-preview">
                <asp:TextBox ID="emp_code_name" class="form-control" ReadOnly="true" placeholder="" style="color:gray;display:none;" runat="server"></asp:TextBox>
                <asp:TextBox ID="need_t_no" class="weui-input" ReadOnly="true" placeholder="" style="color:gray;display:none;" runat="server"></asp:TextBox>
                <asp:TextBox ID="domain" class="weui-input" ReadOnly="true" placeholder="" style="color:gray;display:none;" runat="server"></asp:TextBox>
                <asp:TextBox ID="sku_area" class="weui-input" ReadOnly="true" placeholder="" style="color:gray;display:none;" runat="server"></asp:TextBox>
                <asp:TextBox ID="yzj_no" class="weui-input" ReadOnly="true" placeholder="" style="color:gray;display:none;" runat="server"></asp:TextBox>
                <asp:TextBox ID="cur_sy_qty" class="weui-input" ReadOnly="true" placeholder="" style="color:gray;display:none;" runat="server"></asp:TextBox>

                <div class="weui-form-preview__hd">
                    <div class="weui-form-preview__item">
                        <label class="weui-form-preview__label">要汤单号</label>
                        <label class="weui-form-preview__"><%= _need_t_no %></label>
                    </div>
                </div>
                <div class="weui-form-preview__bd">
                    <asp:Repeater runat="server" ID="listBxInfo">
                        <ItemTemplate>
                             <div class="weui-mark-vip"><span class="weui-mark-lt <%# Eval("type").ToString()=="部分"?"bg-red":""%>"><%#Eval("type") %></span></div>

                            <div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">压铸机</label>
                                <span class="weui-form-preview__value"><%# Eval("yzj_no_desc") %></span>
                            </div>
                            <div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">材料</label>
                                <span class="weui-form-preview__value"><%# Eval("cl") %></span>
                            </div>
                            <div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">要汤量</label>
                                <span class="weui-form-preview__value"><%# Eval("sy_qty") %> KG </span>
                            </div>
                            <div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">要求送到时间</label>
                                <span class="weui-form-preview__value">
                                    <%# Eval("need_date_dl")%>
                                    <%# Eval("need_date","{0:yyyy-MM-dd HH:mm}")%>
                                </span>
                            </div>  
                            <div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">要汤人</label>
                                <span class="weui-form-preview__value">
                                    <%# Eval("cellphone")+""+ Eval("emp_name") %>
                                    <span style="color:<%# Eval("times_type").ToString()=="还差"?"#10AEFF":(Eval("times_type").ToString()=="超时"?"red":"#999999") %>;">
                                    <%# Eval("times_type") %><%# Eval("times") %>
                                </span>
                                </span>
                                
                            </div>                            
                            <%--<div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">岗位</label>
                                <span class="weui-form-preview__value"><%# Eval("location_desc") %>
                                   <span style="font-weight:800"><%# "["+ Eval("sku_area")+"]" %></span>
                                </span>
                            </div>--%>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="weui-form-preview__bd">
                    <asp:Repeater runat="server" ID="listBx_lotno">
                        <ItemTemplate>
                            <div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">转运包</label>
                                <span class="weui-form-preview__value"><%# Eval("zyb") %></span>
                            </div>
                            <div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">Lot No</label>
                                <span class="weui-form-preview__value"><%# Eval("lot_no") %></span>
                            </div>
                            <div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">送料数量</label>
                                <span class="weui-form-preview__value"><%# Eval("act_qty") %> KG </span>
                            </div>
                            <div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">还差数量</label>
                                <span class="weui-form-preview__value"><%# Eval("sy_qty") %> KG </span>
                            </div>
                            <div class="weui-form-preview__item">
                                <label class="weui-form-preview__label">送料时间</label>
                                <span class="weui-form-preview__value"><%# Eval("act_date","{0:yyyy-MM-dd HH:mm}") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

            </div>
            
            <div class="weui-cell">
                <div class="weui-cell__hd f-red"><label class="weui-label">压铸机</label></div>
                <div class="weui-cell__bd">
                    <span style="float:left; width:90%">
                        <asp:TextBox ID="yzj" class="weui-input"  placeholder="请输入压铸机号" runat="server"></asp:TextBox>
                    </span>
                    <span style="float:left; width:10%">
                        <img id="img_sm_yzj" src="../img/fdj2.png" style="padding-top:2px; "  />
                    </span>
                </div>
            </div>
            <div class="weui-cell">
                <div class="weui-cell__hd f-red"><label class="weui-label">转运包</label></div>
                <div class="weui-cell__hd">
                    <asp:TextBox ID="zyb" class="weui-input" placeholder="请输入转运包" style="color:gray" runat="server"></asp:TextBox>
                </div>
            </div>
            <div class="weui-cell">
                <div class="weui-cell__hd f-red"><label class="weui-label">Lot No</label></div>
                <div class="weui-cell__hd">
                    <asp:TextBox ID="lot_no" class="weui-input" placeholder="请输入Lot No" style="color:gray" runat="server"></asp:TextBox>
                </div>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd f-red"><label class="weui-label">送汤量</label></div>
                <asp:TextBox ID="act_qty" class="weui-input" placeholder="" runat="server" type="number" onchange="act_qty_change()"></asp:TextBox>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">还差量</label></div>
                <asp:TextBox ID="txt_sy_qty" class="weui-input" ReadOnly="true" placeholder="" style="color:gray" runat="server"></asp:TextBox>
            </div>

            <div class="weui-cell">
                <div class="weui-cell__hd"><label class="weui-label">送汤说明</label></div>
                <textarea id="comment" class="weui-textarea"  placeholder="请输入说明" rows="3"  runat="server"></textarea>
            </div>

            <div class="weui-cell">
                <input id="btn_sl2" type="button" value="送汤" class="weui-btn weui-btn_primary" />
                <input id="btn_cancel2" type="button" value="取消要汤" class="weui-btn weui-btn_primary" style="margin-left:10px;" />
            </div>

        </div>

    
    </form>
    <script>
        var datalist_zyb;
        $.ajax({
            type: "post",
            url: "ST.aspx/init_zyb",
            data: "{'workshop':'" + "<%= _workshop %>" + "','emp': '" + $("#emp_code_name").val() + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            async: false,//默认是true，异步；false为同步，此方法执行完在执行下面代码
            success: function (data) {
                var obj = eval(data.d);
                datalist_zyb = obj[0].json_zyb;
            }
        });

        $("#zyb").select({
            title: "转运包",
            items: datalist_zyb,
            onChange: function (d) {
                zyb_change();
            },
            onClose: function (d) {
                var obj = eval(d.data);
                //alert(obj.values);
            },
            onOpen: function () {
                //  console.log("open");
            }

        });
        $("#lot_no").select({
            title: "转运包序列号",
            items: [{title:'' ,value:''}],
            onChange: function (d) {
                lotno_change();
            },
            onClose: function (d) {
                //var obj = eval(d.data);
                //alert(obj.values);

            },
            onOpen: function () {
                //  console.log("open");
            },

        }); 
    </script>
</body>
    <script>
        var datad = [];
        $.ajax({
            url: "/getwxconfig.aspx/GetScanQRCode",
            type: "Post",
            data: "{ 'url': '" + location.href + "' }",
            async: false,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                datad = JSON.parse(data.d); //转为Json字符串
            },
            error: function (error) {
                alert(error)
            }
        });
        wx.config({
            debug: false, // 开启调试模式
            appId: datad.appid, // 必填，公众号的唯一标识
            timestamp: datad.timestamp, // 必填，生成签名的时间戳
            nonceStr: datad.noncestr, // 必填，生成签名的随机串
            signature: datad.signature,// 必填，签名，见附录1
            jsApiList: ["scanQRCode"] // 必填，需要使用的JS接口列表
        });
    </script>
</html>
