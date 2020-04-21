﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class WorkOrder_SL : System.Web.UI.Page
{
    public string _workshop = "";
    public string _need_no = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        _workshop = Request.QueryString["workshop"].ToString();

        if (WeiXin.GetCookie("workcode") == null)
        {
            Response.Write("<script>layer.alert('登入信息过期，请退出程序重新进入。');window.history.back();location.reload();</script>");
            return;
        }

        _need_no = Request.QueryString["need_no"].ToString();

        if (!IsPostBack)
        {
            LoginUser lu = (LoginUser)WeiXin.GetJsonCookie();
            emp_code_name.Text = lu.WorkCode + lu.UserName;
            //emp_code_name.Text = "02432何桂勤";

            need_no.Text = _need_no;
            init_data(_need_no);
        }
    }

    void init_data(string need_no)
    {
        string sql = @"exec [usp_app_SL_init] '{0}'";
        sql = string.Format(sql, need_no);
        DataSet ds = SQLHelper.Query(sql);

        DataTable dt = ds.Tables[0];
        listBxInfo.DataSource = dt;
        listBxInfo.DataBind();

        pgino.Text = dt.Rows[0]["pgino"].ToString();
        pn.Text = dt.Rows[0]["pn"].ToString();

        txt_sy_qty.Text= dt.Rows[0]["sy_qty"].ToString();
        txt_act_date.Text = DateTime.Now.ToString("yyyy-MM-dd HH:mm");

        listBx_lotno.DataSource = ds.Tables[1];
        listBx_lotno.DataBind();
    }

    //[WebMethod]
    //public static string lotno_change(string pgino, string lotno)
    //{
    //    string re_sql = @"exec [usp_app_SL_lot_change] '{0}', '{1}'";
    //    re_sql = string.Format(re_sql, pgino, lotno);
    //    DataSet ds = SQLHelper.Query(re_sql);

    //    DataTable re_dt = ds.Tables[0];
    //    string flag = re_dt.Rows[0][0].ToString();
    //    string msg = re_dt.Rows[0][1].ToString();

    //    string qty = "";
    //    if (flag == "N")
    //    {
    //        DataTable dt = ds.Tables[1];
    //        qty = dt.Rows[0]["tr_qty_chg"].ToString();
    //    }

    //    string result = "[{\"flag\":\"" + flag + "\",\"msg\":\"" + msg + "\",\"qty\":\"" + qty + "\"}]";
    //    return result;

    //}

    [WebMethod]
    public static string lotno_change(string pgino, string lotno)
    {
        string re_sql = @"exec [usp_app_SL_lot_change_qad] '{0}', '{1}'";
        re_sql = string.Format(re_sql, pgino, lotno);
        DataSet ds = SQLHelper.Query(re_sql);

        DataTable re_dt = ds.Tables[0];
        string flag = re_dt.Rows[0][0].ToString();
        string msg = re_dt.Rows[0][1].ToString();

        string qty = "";
        if (flag == "N")
        {
            DataTable dt = ds.Tables[1];
            string sqlStr = @"select ld_qty_oh from pub.ld_det where ld_status='WIP' and ld_part='" + pgino + "' and ld_ref='" + lotno + "' and ld_loc='" + dt.Rows[0][0].ToString() + "' with (nolock)";
            DataTable ldt = QadOdbcHelper.GetODBCRows(sqlStr);

            if (ldt == null)
            {
                flag = "Y"; msg = "Lot No不正确";
            }
            else if (ldt.Rows.Count <= 0)
            {
                flag = "Y"; msg = "Lot No不正确";
            }
            else
            {
                flag = "N"; msg = "";
                //qty = ldt.Rows[0][0].ToString();
                //qty = Convert.ToSingle(ldt.Rows[0][0].ToString()).ToString();
                float qty_c = Convert.ToSingle(ldt.Rows[0][0].ToString());

                string sql_q = @"exec [usp_app_SL_lot_change_qad_qty] '{0}', '{1}', {2}";
                sql_q = string.Format(sql_q, pgino, lotno, qty_c);
                DataTable re_dt_q = SQLHelper.Query(sql_q).Tables[0];

                flag = re_dt_q.Rows[0][0].ToString();
                msg = re_dt_q.Rows[0][1].ToString();

                if (flag == "N")
                {
                    qty = qty_c.ToString();
                }
            }
        }

        string result = "[{\"flag\":\"" + flag + "\",\"msg\":\"" + msg + "\",\"qty\":\"" + qty + "\"}]";
        return result;

    }


    protected void btn_sl_Click(object sender, EventArgs e)
    {
        btn_sl.Text = "送料中。。。。"; btn_sl.Enabled = false;

        string re_sql = @"exec [usp_app_SL] '{0}', '{1}','{2}','{3}','{4}','{5}'";
        re_sql = string.Format(re_sql, emp_code_name.Text, need_no.Text,lot_no.Text,act_qty.Text, pgino.Text, pn.Text);
        DataTable re_dt = SQLHelper.Query(re_sql).Tables[0];
        string flag = re_dt.Rows[0][0].ToString();
        string msg = re_dt.Rows[0][1].ToString();

        if (flag == "N")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "showsuccess", "layer.alert('" + msg + "');", true);
            Response.Redirect("/workorder/YL_list_new.aspx?workshop=" + _workshop);
        }
        else
        {
            btn_sl.Text = "送料"; btn_sl.Enabled = true;
            ClientScript.RegisterStartupScript(this.GetType(), "showsuccess", "layer.alert('失败：" + msg + "')", true);
        }

    }

    protected void btn_cancel_Click(object sender, EventArgs e)
    {
        btn_cancel.Text = "取消送料中。。。。"; btn_cancel.Enabled = false;

        string re_sql = @"exec [usp_app_SL_cancel] '{0}', '{1}'";
        re_sql = string.Format(re_sql, emp_code_name.Text, need_no.Text);
        DataTable re_dt = SQLHelper.Query(re_sql).Tables[0];
        string flag = re_dt.Rows[0][0].ToString();
        string msg = re_dt.Rows[0][1].ToString();

        if (flag == "N")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "showsuccess", "layer.alert('" + msg + "');", true);
            Response.Redirect("/workorder/YL_list_new.aspx?workshop="+_workshop);
        }
        else
        {
            btn_cancel.Text = "取消送料"; btn_cancel.Enabled = true;
            ClientScript.RegisterStartupScript(this.GetType(), "showsuccess", "layer.alert('失败：" + msg + "')", true);
        }
    }

}