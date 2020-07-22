﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="YZ_HSolve.aspx.cs" Inherits="WorkOrder_YZ_HSolve" %>

<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1,user-scalable=no">
    <title>后处理完成</title>
    <script src="/Scripts/jquery-1.10.2.min.js"></script> 
  <%--  <script src="../Content/layer/layer.js"></script>--%>
     <link rel="stylesheet" href="../css/weui.css" />
    <link rel="stylesheet" href="../css/weuix.css" />
    <script src="../js/zepto.min.js"></script>
    <script src="../js/zepto.weui.js"></script>
   

     <style>
        .rowbr{
            margin-bottom:5px;
        }
        .textwidth1{
            padding-right:25px;
        }        
        .textwidth2{
            padding-right:40px;
        }
         .weui-btn + .weui-btn{
            margin-top:0px;
        }
       divtable .weui-table td, .weui-table th, table td, table th
       {
           border:none;
       }
       .collapse li.js-show .weui-flex{
           opacity:1;
       }
      
        
    </style>


    
    <script>

 

        function valid() {

            if ($("#txt_xmh").val() == "")
            {
                alert("请选择物料号.");
                return false;
            }
            if ($("#txt_dh").val() == "") {
                alert("请输入后处理单号.");
                return false;
            }

            if ($("#source_dh").val() == "") {
                alert("请输入来源单号.");
                return false;
            }

        

            return true;
        }
    </script>
</head>
<body>
      <script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
      <script>
          $(document).ready(function () {
              page_show();
              sm_source();
           
          

          });


          $(function () {
              $("#<%=btn_bind_xm.ClientID%>").click();  

              $("#btnsave2").click(function () { 
                  $(":button").attr("disabled", "disabled");
                  $(":button").removeClass('weui-btn_primary').addClass('weui_btn_disabled weui_btn_default');
                 
                  if (!valid()) {
                      $(":button").removeAttr("disabled");
                      $(":button").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');
                      return false;
                      //}
                  }

                  var qty = $("#txt_qty").val();
                  $.confirm('当前输入下料数量为 ' + qty + ' ，确认要暂存吗？', function () { btnclick(0); },
                          function () {
                              $(":button").removeAttr("disabled");
                              $(":button").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');
                          });

                    
                  


                     
              });

              $("#btnsave3").click(function () {
                  debugger
                  $(":button").attr("disabled","disabled");
                  $(":button").removeClass('weui-btn_primary').addClass('weui_btn_disabled weui_btn_default');

                  if (!valid()) {
                      $(":button").removeAttr("disabled");
                      $(":button").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');
                      return false;
                      //}
                  }
                 
                      if (parseFloat($("#txt_curr_qty").val()) + parseFloat($("#txt_off_qty").val()) < parseFloat($("#txt_ztsl").val())) {
                          $.confirm('零托,确认执行下一步吗？', function () { btnclick($("#btnsave3").val()); },
                              function () {
                                  $(":button").removeAttr("disabled");
                                  $(":button").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');
                              });
                      }
                      else {
                          btnclick(1);
                      }
                  

                  
              });

            });


          //function setvalue() {
          //    var totalRow = 0; var is_tr_row = false;

          //    $('#divtable table  tr').each(function (i) {
          //        if (i > 0) {
          //            is_tr_row = true;
          //            qty = $(this).children('td:eq(2)').text();
          //            totalRow +=parseFloat(qty);
          //        }

          //    });

          //    if (is_tr_row) {

          //        if (parseFloat(totalRow) + parseFloat($("#txt_off_qty").val()) <= parseFloat($("#txt_qty").val())) {

          //            $("#txt_qty").val(totalRow + parseFloat($("#txt_off_qty").val()));
          //            $("#txt_curr_qty").val(totalRow);

          //        }
          //        else {
          //            $("#txt_qty").val($("#txt_ztsl").val());
          //            $("#txt_curr_qty").val(parseFloat($("#txt_ztsl").val()) - parseFloat($("#txt_off_qty").val()));

          //        }
          //    }
          //}


          function source_dh_change() {

              $("#dh_record").val($("#dh_record").val() + "," + $("#source_dh").val());

              $("#<%=btn_bind_data.ClientID%>").click();
            <%--   $("#<%=btn_bind_xm.ClientID%>").click(); --%>

          }
          
          function btnclick(btnevent){
               $.ajax({
                      type: "post",
                      url: "YZ_HSolve.aspx/save2",
                      data: "{'_dh':'" + $('#txt_dh').val()
                          + "','_curr_qty':'" + $('#txt_curr_qty').val() + "','_emp':'" + $('#txt_emp').val() + "','_pgino':'" + $('#txt_xmh').val()
                          + "','_btnms':'" + btnevent + "','_dh_record':'" + $('#dh_record').val()
                          + "','_remark':'" + $('#txt_remark').val() + "','_stepvalue':'" + $("input[name='step']:checked").val() + "'}",
                      contentType: "application/json; charset=utf-8",
                      dataType: "json",
                      async: false,//默认是true，异步；false为同步，此方法执行完在执行下面代码
                      success: function (data) {
                          var obj = eval(data.d);
                          if (obj[0].flag == "Y") {
                              alert(obj[0].msg);
                              $(":button").removeAttr("disabled");
                              $(":button").removeClass('weui_btn_disabled weui_btn_default').addClass('weui-btn_primary');
                              return false;
                          }
                          var ms = "";
                          if (btnevent == 0) { ms = "暂存" } else { ms="下料"}
                          alert(ms + '完成');
                          window.location.href = "/Cjgl1.aspx?workshop=<%=_workshop %>";
                      }

                  });
          }

          function page_show() {
              $('.collapse .js-category').children('div').children('span').css("color", "#e0e0e0");

              $('.collapse .js-category').click(function () {
                  $parent = $(this).parent('li');
                  if ($parent.hasClass('js-show')) {
                      $parent.removeClass('js-show');
                      $(this).children('i').removeClass('icon-35').addClass('icon-74');

                      $(this).children('div').children('span').css("color", "#e0e0e0");//#e0e0e0
                  } else {
                      $parent.siblings().removeClass('js-show');
                      $parent.addClass('js-show');
                      $(this).children('i').removeClass('icon-74').addClass('icon-35');
                      $parent.siblings().find('i').removeClass('icon-35').addClass('icon-74');

                      $(this).children('div').children('span').css("color", "#428BCA");//
                  }
              });

          }

         

         
             
         

          function qty_change() {

              var key_value = $("#txt_qty").val();//完工数量
              var off_qty = $("#txt_off_qty").val(); //已下料数量
              var curr_qty = key_value - off_qty;
              $("#txt_curr_qty").val(curr_qty);
             
             
          }

           function xmh_change() {

               $("#<%=btn_bind_xm.ClientID%>").click();
          }

           function setvalue() {
               debugger
               alert($("#txt_step").val());
              
           }


          function sm_source() {
              $('img[id*=img_sm]').click(function () {
                  wx.ready(function () {
                      wx.scanQRCode({
                          needResult: 1, // 默认为0，扫描结果由微信处理，1则直接返回扫描结果，
                          scanType: ["qrCode", "barCode"], // 可以指定扫二维码还是一维码，默认二者都有
                          success: function (res) {
                              var result = res.resultStr; // 当needResult 为 1 时，扫码返回的结果
                               $('#source_dh').val(result);
                                $('#dh_record').val($('#dh_record').val()+","+result);
                              $("#<%=btn_bind_data.ClientID%>").click();
                          }
                      });
                  });
              });
          }
        
          function step_change()
          { }

    </script>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server">
        </asp:ScriptManager>
    <div class="resume-setting-page normal-page-wrap"> 
      
    
        
            <div class="weui-cells weui-cells_form">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
            <script type="text/javascript">
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                    $("#txt_dh").attr("readonly", "readonly");
                    $("#txt_curr_qty").attr("readonly", "readonly");
                    $("#txt_off_qty").attr("readonly", "readonly");
                    $("#txt_pn").attr("readonly", "readonly");
                    page_show();
                    sm_source();
                   
                });
            </script>
               <%-- <asp:TextBox ID="txt_step" class="weui-input" placeholder="" Style="max-width: 100%;" runat="server"></asp:TextBox>--%>
             <asp:TextBox ID="ps_part" class="weui-input" placeholder="" Style="max-width: 100%; display:none" runat="server" ></asp:TextBox>

                <div hidden="hidden">
                    <div class="weui-cell__hd">
                        <label class="weui-label">当前岗位</label>
                    </div>
                    <div class="weui-cell__bd">
                        <asp:TextBox ID="txt_location" class="weui-input" ReadOnly="true" placeholder="" Style="max-width: 100%" runat="server"></asp:TextBox>
                    </div>
                </div>
                         
                 <div hidden="hidden">
                    <div class="weui-cell__hd">
                        <label class="weui-label">登入人</label>
                    </div>
                    <div class="weui-cell__bd">
                       <asp:TextBox ID="txt_emp" class="weui-input" ReadOnly="true" placeholder="" Style="max-width: 100%" runat="server"></asp:TextBox>
                        <asp:TextBox ID="txt_ztsl" class="weui-input"  placeholder="" Style="max-width: 100%; "  runat="server" ></asp:TextBox>
                        <asp:TextBox ID="dh_record" class="weui-input"  placeholder="" Style="max-width: 100%; "  runat="server" ></asp:TextBox>
                        <asp:TextBox ID="txt_cz" class="weui-input" placeholder="" Style="max-width: 100%;" runat="server"></asp:TextBox>
                         <asp:TextBox ID="txt_desc2" class="weui-input" placeholder="" Style="max-width: 100%;" runat="server"></asp:TextBox>
                        <asp:TextBox ID="txt_lotno" class="weui-input" placeholder="" Style="max-width: 100%;" runat="server"></asp:TextBox>
                    </div>
                </div>






                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label f-red">后处理单号</label>
                    </div>
                    <div class="weui-cell__bd">
                        <asp:TextBox ID="txt_dh" class="weui-input" runat="server" Style="color: gray"></asp:TextBox>
                    </div>

                </div>


                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">来源单号</label>
                    </div>
                    <div class="weui-cell__bd">
                        <span style="float: left; width: 90%">
                            <asp:TextBox ID="source_dh" class="weui-input" Style="color: gray" placeholder="请输入来源单号" runat="server" onchange="source_dh_change()"></asp:TextBox>
                        </span>
                        <span style="float: left; width: 10%">
                            <img id="img_sm" src="../img/fdj2.png" style="padding-top: 10px;" />
                        </span>
                    </div>
                </div>


                <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label f-red">物料号</label>
                    </div>
                    <div class="weui-cell__bd">
                        <%--<asp:DropDownList ID="txt_xmh" class="weui-input" runat="server" onchange="xmh_change()" ></asp:DropDownList>--%>
                        <asp:TextBox ID="txt_xmh" class="weui-input" Style="max-width: 100%" runat="server"></asp:TextBox>
                    </div>
                </div>

                 <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label">零件号</label>
                    </div>
                    <div class="weui-cell__bd">
                        <asp:TextBox ID="txt_pn" class="weui-input" Style="max-width: 100%; color:gray" runat="server"></asp:TextBox>
                    </div>
                </div>

                  <div class="weui-cell">
                    <div class="weui-cell__hd">
                        <label class="weui-label f-red">下料数量</label>
                    </div>
                    <div class="weui-cell__bd">
                        <asp:TextBox ID="txt_qty" class="weui-input" Style="max-width: 100%"  onchange="qty_change()" runat="server" placeholder="请输入完工数量"  ></asp:TextBox>    
                    </div>
                </div>



                <div class="weui-cell" style="font-size: 12px; color: gray;">
                    <div class="weui-flex__item">
                        已下料
                               <asp:TextBox ID="txt_off_qty" class="weui-input" runat="server" Style="color: gray; width: 30%; border-bottom: 1px solid #e5e5e5; text-align: center;"></asp:TextBox>
                    </div>
                    <div class="weui-flex__item">
                        本次下料
                               <asp:TextBox ID="txt_curr_qty" class="weui-input" runat="server" Style="color: gray; width: 30%; border-bottom: 1px solid #e5e5e5; text-align: center;"></asp:TextBox>
                    </div>
                </div>

                <div class="weui-cell">
                    <div class="weui-cell__hd ">
                        <label class="weui-label">说明</label></div>
                    <div class="weui-cell__bd">
                        <textarea id="txt_remark" class="weui-textarea" placeholder="请输入说明" rows="2" runat="server"></textarea>
                    </div>
                </div>     

                 <div class="weui-form-preview">

                     <ul class="collapse">
                         <li>
                             <div class="weui-flex js-category">
                                 <div class="weui-flex__item"><span>下一步</span></div>
                                 <i class="icon icon-74"></i>
                             </div>
                             <div class="page-category js-categoryInner">

                                 <div class="weui-cells page-category-content">

                                    <div class="weui-cell__bd">
                                         <div class="weui-form-li">
                                             <input class="weui-form-checkbox" name="step"  id="g2" value="终检" type="radio"   runat="server" />   
                                             <label for="g2">
                                                 <i class="weui-icon-radio"></i>
                                                 <div class="weui-form-text">
                                                     <p>终检</p>
                                                 </div>
                                             </label>
                                         </div>
                                     </div>
                                     <div class="weui-cell__ft"></div>

                                     <div class="weui-cell__bd">
                                         <div class="weui-form-li">
                                             <input class="weui-form-checkbox" name="step"  id="g3" value="GP12" type="radio" runat="server" />  
                                             <label for="g3" class="middle">
                                                 <i class="weui-icon-radio"></i>
                                                 <div class="weui-form-text">
                                                     <p>GP12</p>
                                                 </div>
                                             </label>
                                         </div>
                                     </div>
                                     <div class="weui-cell__ft"></div>

                                     <div class="weui-cell__bd">
                                         <div class="weui-form-li">
                                             <input class="weui-form-checkbox" name="step"  id="g4" value="入库" type="radio" runat="server"  /> 
                                             <label for="g4" class="middle">
                                                 <i class="weui-icon-radio"></i>
                                                 <div class="weui-form-text">
                                                     <p>入库</p>
                                                 </div>
                                             </label>
                                         </div>
                                     </div>
                                     <div class="weui-cell__ft"></div>

                                 </div>
                             </div>
                         </li>

                     </ul>
                 </div>

                
                   <div class="weui-form-preview">

                     <ul class="collapse">
                         <li class="">
                             <div class="weui-flex js-category">
                                 <div class="weui-flex__item"><span>关联材料</span></div>
                                 <i class="icon icon-74"></i>
                             </div>
                             <div class="page-category js-categoryInner">

                                 <div class="weui-cells page-category-content">
                                      <div class="weui-form-preview__bd" id="divtable">
                                      <asp:Repeater runat="server" ID="Repeater_lotno">

                                              <HeaderTemplate>
                                                  <table border="0">
                                                      <tr>
                                                          <td>来源单号</td>
                                                          <td>物料号</td>
                                                          <td>数量 </td>
                                                    
                                                        
                                                      </tr>
                                              </HeaderTemplate>

                                               <ItemTemplate>
                                                   <tr>
                                                        <td><%# Eval("workorder")%></td>
                                                        <td><%# Eval("pgino") %></td>
                                                        <td><%# Eval("need_off_qty")%></td>
                                                       
                                                   </tr>
                                        </ItemTemplate>
                                           <FooterTemplate>
                                      </table>
                                        </FooterTemplate>
                                          </asp:Repeater>
                                       </div>
                                    

                                 </div>
                             </div>
                         </li>

                     </ul>
                 </div>

               

                <div class="weui-form-preview">
                    <ul class="collapse">

                        <li>
                            <div class="weui-flex js-category">
                                <div class="weui-flex__item"><span>完成记录</span></div>
                                <i class="icon icon-74"></i>
                            </div>
                            <div class="page-category js-categoryInner">

                                <div class="weui-cells page-category-content">
                                     <div class="weui-form-preview__bd"  >
                                    <asp:Repeater runat="server" ID="Repeater_record">

                                        <HeaderTemplate>
                                            <table>
                                                <tr>
                                                    <td>物料号</td>
                                                    <td>数量</td>
                                                    <td>下料人 </td>
                                                    <td>下料时间 </td>
                                                </tr>
                                        </HeaderTemplate>

                                        <ItemTemplate>
                                            <tr>
                                                <td><%# Eval("pgino") %></td>
                                                <td><%# Eval("off_qty")%></td>
                                                <td><%# Eval("emp_name")%></td>
                                                <td><%# Eval("create_date","{0:MM/dd HH:mm}")%></td>
                                            </tr>

                                        </ItemTemplate>
                                         <FooterTemplate>
                                      </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>


                
           
              

               <asp:Button ID="btn_bind_xm" runat="server" Text="项目号关联数据" style="display:none;" OnClick="btn_bind_xm_Click" />
              
              <asp:Button ID="btn_bind_data" runat="server" Text="绑定来源数据" style="display:none;" OnClick="btn_bind_data_Click" />
              
           

                   </ContentTemplate>
            </asp:UpdatePanel>
                </div>
              <div class="weui-cell">

                   <input id="btnsave2" type="button" value="暂存" class="weui-btn weui-btn_primary" />
                  <input id="btnsave3" type="button" value="下料" class="weui-btn weui-btn_primary" style="margin-left:10px;" />
              </div>
               
              
     
      
               
            
           
           
        
       
    </div>
    </form>
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
