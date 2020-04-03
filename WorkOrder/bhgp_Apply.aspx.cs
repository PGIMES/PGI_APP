﻿using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class bhgp_Apply : System.Web.UI.Page
{
    public string _workshop = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        _workshop = Request.QueryString["workshop"].ToString();

        if (WeiXin.GetCookie("workcode") == null)
        {
            Response.Write("<script>layer.alert('登入信息过期，请退出程序重新进入。');window.history.back();location.reload();</script>");
            return;
        }

        if (!IsPostBack)
        {
            LoginUser lu = (LoginUser)WeiXin.GetJsonCookie();
            emp_code_name.Text = lu.WorkCode + lu.UserName;
            domain.Text = lu.Domain;

            //emp_code_name.Text = "02432何桂勤";
            //domain.Text = "200";
        }
        
    }

    [WebMethod]
    public static string init_pgino(string domain)
    {
        string result = "";
        string sql = @" exec [usp_app_bhgp_Apply_pgino] '" + domain + "'";
        DataSet ds = SQLHelper.Query(sql);

        DataTable dt = ds.Tables[0];
        string json = JsonConvert.SerializeObject(dt);

        DataTable dt_reason = ds.Tables[1];
        string json_reason = JsonConvert.SerializeObject(dt_reason);

        result = "[{\"json\":" + json + ",\"json_reason\":" + json_reason + "}]";
        return result;

    }

    [WebMethod]
    public static string pgino_change(string pgino)
    {

        string re_sql = @"exec [usp_app_bhgp_Apply_pgino_change] '{0}'";
        re_sql = string.Format(re_sql, pgino);
        DataSet ds = SQLHelper.Query(re_sql);

        string pn = "", descr = "";
        DataTable re_dt = ds.Tables[0];
        pn = re_dt.Rows[0][0].ToString();
        descr = re_dt.Rows[0][1].ToString();

        DataTable dt_op = ds.Tables[1];
        string json_op = JsonConvert.SerializeObject(dt_op);

        string result = "[{\"pn\":\"" + pn + "\",\"descr\":\"" + descr + "\",\"json_op\":" + json_op + "}]";
        return result;

    }


    protected void btnsave_Click(object sender, EventArgs e)
    {

        string re_sql = @"exec usp_app_bhgp_Apply '{0}', '{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}'";
        re_sql = string.Format(re_sql, emp_code_name.Text, workorder.Text, pgino.Text, pn.Text, descr.Text, op.Text, qty.Text, reason.Text, comment.Value);
        DataTable re_dt = SQLHelper.Query(re_sql).Tables[0];
        string flag = re_dt.Rows[0][0].ToString();
        string msg = re_dt.Rows[0][1].ToString();

        if (flag == "N")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "showsuccess", "layer.alert('" + msg + "')", true);
            Response.Redirect("/workorder/bhgp_deal_list_new.aspx?workshop=" + _workshop);
        }
        else
        {
            ClientScript.RegisterStartupScript(this.GetType(), "showsuccess", "layer.alert('失败：" + msg + "')", true);
        }

    }

}