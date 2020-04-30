﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class prod_wip_detail : System.Web.UI.Page
{
    public string _workshop = "";
    public string _emp = "";//当前登入

    protected void Page_Load(object sender, EventArgs e)
    {
        _workshop = Request.QueryString["workshop"].ToString();

        if (WeiXin.GetCookie("workcode") == null)
        {
            Response.Write("<script>alert('登入信息过期，请退出程序重新进入。');window.history.back();location.reload();</script>");
            return;
        }

        LoginUser lu = (LoginUser)WeiXin.GetJsonCookie();
        _emp = lu.WorkCode + lu.UserName;
        //_emp = "02432何桂勤";

        GetData();
       
    }

    private void GetData()
    {
         
        string type = Request["type"].ToString();
        string dh = Request["dh"].ToString();
        string need_no= Request["need_no"].ToString();
        string sql = string.Format(@"select * from Mes_App_WorkOrder_Wip where lot_no= '{0}' and need_no='{1}' ",dh,need_no);
        DataTable dt  = SQLHelper.Query(sql).Tables[0];     
         
       // DataView dataView = dt_hist.DefaultView;
       // DataTable dtMainDistinct = dataView.ToTable(true, "pgino", "pn", "workorder","workorder_part","par_qty");//的第一个参数为是否DISTINCT
       
        dtMain.DataSource = dt ;
        dtMain.DataBind();
        //NG Detail
        //sql = string.Format(@"select a.*,hr.cellphone from Mes_App_WorkOrder_Ng_Detail a join [172.16.5.6].[eHR_DB].[dbo].[View_HR_Emp] hr  on  a.emp_code=hr.employeeid  where lot_no= '{0}' ", dh);
        sql = string.Format(@"select t.* ,hr.cellphone from
                            (select   isnull(workorder,workorder_part)workorder, emp_code , emp_name,pgino,pn, sku,sku_Descr,off_qty as qty,off_date,par_qty,'下料' as opdesc  
                            from Mes_App_WorkOrder_History  where lot_no='{0}' and need_no='{1}'
                            union all
                            select workorder, emp_code , emp_name,pgino,pn, sku,sku_Descr,qty,on_date,qty as par_qty,'不合格品' from Mes_App_WorkOrder_Ng_Detail a 
                            where lot_no= '{0}' and need_no='{1}')t
                            join [172.16.5.6].[eHR_DB].[dbo].[View_HR_Emp] hr  on  t.emp_code=hr.employeeid", dh,need_no);
        dt = SQLHelper.Query(sql).Tables[0];

        DataList1.DataSource = dt ;
        DataList1.DataBind();
        //Label1.Text =""+ dh+" " + dt_hist.Rows[0]["pgino"].ToString()+ "  "  + dt_hist.Rows[0]["pn"].ToString() + "  数量:"+dt_hist.Rows[0]["par_qty"].ToString();




    }

    [WebMethod]
    public static string Reject_Sku(string emp, string needno, string lotno, string reject_qty, string source, string reject_where)
    {
        string result = "";

        string re_sql = @"exec [usp_app_Reject] '{0}','{1}','{2}',{3},'{4}','{5}'";
        re_sql = string.Format(re_sql, emp, needno, lotno, Convert.ToSingle(reject_qty == "" ? "0" : reject_qty), source, reject_where);
        DataTable re_dt = SQLHelper.Query(re_sql).Tables[0];
        string flag = re_dt.Rows[0][0].ToString();
        string msg = re_dt.Rows[0][1].ToString();

        result = "[{\"flag\":\"" + flag + "\",\"msg\":\"" + msg + "\"}]";
        return result;

    }
}