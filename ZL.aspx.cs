﻿using LitJson;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ZL : System.Web.UI.Page
{
    public string _workshop = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        //_workshop = Request.QueryString["workshop"].ToString();

        //if (_workshop == "二车间" || _workshop == "四车间")
        //{
        //    bind_data();
        //}
        //else if (_workshop == "三车间")
        //{
        //    bind_data_three();
        //}

        if (!IsPostBack)
        {
            LoginUser lu = (LoginUser)WeiXin.GetJsonCookie();
            emp_code_name.Text = lu.WorkCode + lu.UserName;
        }
    }

    public void bind_data()
    {
        //上岗监视
        string sql = @"select count(1) app_emp from [Mes_App_EmployeeLogin] 
            where off_date is null and on_date is not null and emp_code not in(select EMPLOYEEID from [172.16.5.26].[Production].[dbo].[Hrm_Emp] where dept_name='IT部' )
                and id in (select distinct login_id from Mes_App_EmployeeLogin_Location 
                            where workshop='" + _workshop + "' and (e_code not like 'J%' and e_code not like 'Q%'))";
        DataTable re_dt = SQLHelper.Query(sql).Tables[0];

        Label1.Text = re_dt.Rows[0][0].ToString();

        sql = @"select count(1) app_emp from [Mes_App_EmployeeLogin] 
            where off_date is null and on_date is not null and emp_code not in(select EMPLOYEEID from [172.16.5.26].[Production].[dbo].[Hrm_Emp] where dept_name='IT部' )
                and id in (select distinct login_id from Mes_App_EmployeeLogin_Location 
                        where workshop='" + _workshop + "'  and (e_code like 'J%' or e_code like 'Q%'))";
        DataTable re_dt_j = SQLHelper.Query(sql).Tables[0];

        Label1_j.Text = re_dt_j.Rows[0][0].ToString();

        //要料监视
        DataTable dt_go = new DataTable();
        DataTable dt_wc = new DataTable();
        DataTable dt_rj = new DataTable();
        DataTable dt_end = new DataTable();

        sql = @"exec [usp_app_YL_list_new] '"+ _workshop + "',''";
        dt_go = SQLHelper.Query(sql).Tables[0];
        dt_wc = SQLHelper.Query(sql).Tables[1];
        dt_rj = SQLHelper.Query(sql).Tables[2];
        dt_end = SQLHelper.Query(sql).Tables[3];

        int count_yl = dt_go.Rows.Count + dt_wc.Rows.Count + dt_rj.Rows.Count;
        Label2.Text = count_yl.ToString();
        Label2_end.Text = dt_end.Rows.Count.ToString();

        //不合格监视
        //sql = @"exec [usp_app_bhgp_Apply_list_dv] '"+ _workshop + "','','0001',''";
        //DataTable dt_01 = SQLHelper.Query(sql).Tables[0];
        //sql = @"exec [usp_app_bhgp_Apply_list_dv] '" + _workshop + "','','0002',''";
        //DataTable dt_02 = SQLHelper.Query(sql).Tables[0];
        //sql = @"exec [usp_app_bhgp_Apply_list_dv] '" + _workshop + "','','0003',''";
        //DataTable dt_03 = SQLHelper.Query(sql).Tables[0];
        //sql = @"exec [usp_app_bhgp_Apply_list_dv] '" + _workshop + "','','0004',''";
        //DataTable dt_04 = SQLHelper.Query(sql).Tables[0];
        //sql = @"exec [usp_app_bhgp_Apply_list_dv] '" + _workshop + "','','0005',''";
        //DataTable dt_05 = SQLHelper.Query(sql).Tables[0];
        //sql = @"exec [usp_app_bhgp_Apply_list_dv] '" + _workshop + "','','9998',''";
        //DataTable dt_06 = SQLHelper.Query(sql).Tables[0];
        //int count_bhg = dt_01.Rows.Count + dt_02.Rows.Count + dt_03.Rows.Count + dt_04.Rows.Count + dt_05.Rows.Count + dt_06.Rows.Count;

        sql = @"exec [usp_app_bhgp_Apply_list_dv_V1_New] '{0}','{1}'";
        sql = string.Format(sql, _workshop, "");
        DataSet ds = SQLHelper.Query(sql);
        DataTable dt_01 = ds.Tables[0]; DataTable dt_02 = ds.Tables[1]; DataTable dt_03 = ds.Tables[2];
        DataTable dt_04 = ds.Tables[3]; DataTable dt_05 = ds.Tables[4]; DataTable dt_98 = ds.Tables[5];
        DataTable dt_99 = ds.Tables[6];
        int count_bhg = dt_02.Rows.Count + dt_03.Rows.Count + dt_04.Rows.Count + dt_05.Rows.Count + dt_98.Rows.Count;

        //Label3.Text = count_bhg.ToString();
        Label3_V1.Text = count_bhg.ToString();
        Label3_V1_f.Text = dt_01.Rows.Count.ToString();
        Label3_V1_e.Text = dt_99.Rows.Count.ToString();

        //以下marked by fish 20.7.14
        #region marked by fish 20.7.14
        ////生产监视
        //int iPart = 0, iWip = 0, iNg=0; //iPart部分，iWip在制数，iNg不合格返线数
        ////生产中
        //sql = string.Format(@"exec [usp_app_wip_list_prod] '{0}','{1}'", _workshop, "");
        //DataTable dt_data_go = SQLHelper.Query(sql).Tables[1];
        //iPart = iPart + dt_data_go.Select("ispartof='部分' and line<>'组装件'").Count(); //配件（组装件）不计数
        //iWip  = iWip + dt_data_go.Select("ispartof<>'部分' and line<>'组装件' and  isnull(workorder_wip,'') not like 'R%'").Count();
        //iNg = iNg + dt_data_go.Select(" workorder_wip like 'R%'").Count();
        ////待终检
        //sql = string.Format(@"exec [usp_app_wip_list_Qcc] '{0}','{1}',{2}", _workshop, "", 2);
        //DataTable dt_data_qc = SQLHelper.Query(sql).Tables[0];
        //iPart = iPart + dt_data_qc.Select("ispartof='部分'").Count();
        //iWip = iWip + dt_data_qc.Select("ispartof<>'部分'  and  isnull(workorder_wip,'') not like 'R%'").Count();
        //iNg = iNg + dt_data_qc.Select(" workorder_wip like 'R%'").Count();
        ////待GP12
        //sql = string.Format(@"exec [usp_app_wip_list_Qcc] '{0}','{1}',{2}", _workshop, "", 3);
        //DataTable dt_data_GP = SQLHelper.Query(sql).Tables[0];
        //iPart = iPart + dt_data_GP.Select("ispartof='部分'").Count();
        //iWip = iWip + dt_data_GP.Select("ispartof<>'部分'").Count();
        ////待入库
        //sql = string.Format(@"exec [usp_app_wip_list_Qcc] '{0}','{1}',{2}", _workshop, "", 4);
        //DataTable dt_data_ruku_go = SQLHelper.Query(sql).Tables[0];         
        //iWip = iWip + dt_data_ruku_go.Rows.Count;

        //int count_scjs = dt_data_go.Rows.Count + dt_data_qc.Rows.Count + dt_data_GP.Rows.Count + dt_data_ruku_go.Rows.Count;
        //lblWip.Text = iWip.ToString();
        //lblPart.Text = iPart.ToString();
        //lblNg.Text = iNg.ToString();
        #endregion
    }

    public void bind_data_three()
    {
        //上岗监视
        string sql = @"select count(1) app_emp from [Mes_App_EmployeeLogin] 
            where off_date is null and on_date is not null and emp_code not in(select EMPLOYEEID from [172.16.5.26].[Production].[dbo].[Hrm_Emp] where dept_name='IT部' )
                and id in (select distinct login_id from Mes_App_EmployeeLogin_Location
                            where workshop='" + _workshop + "' and (e_code not like 'J%' and e_code not like 'Q%'))";
        DataTable re_dt = SQLHelper.Query(sql).Tables[0];

        Label1_three.Text = re_dt.Rows[0][0].ToString();

        sql = @"select count(1) app_emp from [Mes_App_EmployeeLogin] 
            where off_date is null and on_date is not null and emp_code not in(select EMPLOYEEID from [172.16.5.26].[Production].[dbo].[Hrm_Emp] where dept_name='IT部' )
                and id in (select distinct login_id from Mes_App_EmployeeLogin_Location 
                        where workshop='" + _workshop + "' and (e_code like 'J%' or e_code like 'Q%'))";
        DataTable re_dt_j = SQLHelper.Query(sql).Tables[0];

        Label1_three_j.Text = re_dt_j.Rows[0][0].ToString();

        //要料监视
        DataTable dt_go = new DataTable();
        DataTable dt_wc = new DataTable();
        DataTable dt_rj = new DataTable();
        DataTable dt_end = new DataTable();

        sql = @"exec [usp_app_YL_list_new] '" + _workshop + "',''";
        dt_go = SQLHelper.Query(sql).Tables[0];
        dt_wc = SQLHelper.Query(sql).Tables[1];
        dt_rj = SQLHelper.Query(sql).Tables[2];
        dt_end = SQLHelper.Query(sql).Tables[3];

        int count_yl = dt_go.Rows.Count + dt_wc.Rows.Count + dt_rj.Rows.Count;
        Label2_three.Text = count_yl.ToString();
        Label2_three_end.Text = dt_end.Rows.Count.ToString();

        //要汤监视
        sql = @"exec [usp_app_YT_list] '{0}','{1}'";
        sql = string.Format(sql, _workshop, "");
        DataTable dt_YT_go = SQLHelper.Query(sql).Tables[0];
        Label_YT.Text = dt_YT_go.Rows.Count.ToString();


        //不合格监视
        sql = @"exec [usp_app_bhgp_Apply_list_dv_V1_New] '{0}','{1}'";
        sql = string.Format(sql, _workshop, "");
        DataSet ds = SQLHelper.Query(sql);
        DataTable dt_01 = ds.Tables[0]; DataTable dt_02 = ds.Tables[1]; DataTable dt_03 = ds.Tables[2];
        DataTable dt_04 = ds.Tables[3]; DataTable dt_05 = ds.Tables[4]; DataTable dt_98 = ds.Tables[5];
        DataTable dt_99 = ds.Tables[6];
        int count_bhg = dt_02.Rows.Count + dt_03.Rows.Count + dt_04.Rows.Count + dt_05.Rows.Count + dt_98.Rows.Count;

        Label_bhg_thr.Text = count_bhg.ToString();
        Label_bhg_thr_f.Text = dt_01.Rows.Count.ToString();
        Label_bhg_thr_e.Text = dt_99.Rows.Count.ToString();
    }


    //检验监视
    [WebMethod]
    public static string ProdList_Data()
    {        
        int iPart = 0, iWip = 0, iNg = 0,iSh=0; //iPart部分，iWip在制数，iNg不合格返线数   iSh  待入库数
        //待终检
        string sql = string.Format(@"exec [usp_app_wip_list_Qcc] '{0}','{1}',{2}", "二车间", WeiXin.GetCookie("workcode"), 2);
        DataSet ds = SQLHelper.Query(sql);
        DataTable dt_data_qc = ds.Tables[0];
        iPart = iPart + dt_data_qc.Select("ispartof='部分'").Count();
        iWip = iWip + dt_data_qc.Select("ispartof<>'部分'  and  isnull(workorder_wip,'') =''").Count();
        iNg = iNg + dt_data_qc.Select(" isnull(workorder_wip,'') <>''").Count();

        sql = string.Format(@"exec [usp_app_wip_list_Qcc] '{0}','{1}',{2}", "三车间", WeiXin.GetCookie("workcode"), 2);
        ds = SQLHelper.Query(sql);
        dt_data_qc = ds.Tables[0];
        iPart = iPart + dt_data_qc.Select("ispartof='部分'").Count();
        iWip = iWip + dt_data_qc.Select("ispartof<>'部分'  and  isnull(workorder_wip,'') =''").Count();
        iNg = iNg + dt_data_qc.Select(" isnull(workorder_wip,'') <>''").Count();

        sql = string.Format(@"exec [usp_app_wip_list_Qcc] '{0}','{1}',{2}", "四车间", WeiXin.GetCookie("workcode"), 2);
        ds = SQLHelper.Query(sql);
        dt_data_qc = ds.Tables[0];
        iPart = iPart + dt_data_qc.Select("ispartof='部分'").Count();
        iWip = iWip + dt_data_qc.Select("ispartof<>'部分'  and  isnull(workorder_wip,'')  =''").Count();
        iNg = iNg + dt_data_qc.Select(" isnull(workorder_wip,'') <>''").Count();


        //待GP12
        sql = string.Format(@"exec [usp_app_wip_list_Qcc] '{0}','{1}',{2}", "二车间", WeiXin.GetCookie("workcode"), 3);
        ds = SQLHelper.Query(sql);
        DataTable dt_data_GP = ds.Tables[0];
        iPart = iPart + dt_data_GP.Select("ispartof='部分'").Count();
        iWip = iWip + dt_data_GP.Select("ispartof<>'部分'  and  isnull(workorder_wip,'') =''").Count();
        iNg = iNg + dt_data_GP.Select(" isnull(workorder_wip,'') <>''").Count();

        sql = string.Format(@"exec [usp_app_wip_list_Qcc] '{0}','{1}',{2}", "三车间", WeiXin.GetCookie("workcode"), 3);
        ds = SQLHelper.Query(sql);
        dt_data_GP = ds.Tables[0];
        iPart = iPart + dt_data_GP.Select("ispartof='部分'").Count();
        iWip = iWip + dt_data_GP.Select("ispartof<>'部分'  and  isnull(workorder_wip,'')  =''").Count();
        iNg = iNg + dt_data_GP.Select(" isnull(workorder_wip,'') <>''").Count();

        sql = string.Format(@"exec [usp_app_wip_list_Qcc] '{0}','{1}',{2}", "四车间", WeiXin.GetCookie("workcode"), 3);
        ds = SQLHelper.Query(sql);
        dt_data_GP = ds.Tables[0];
        iPart = iPart + dt_data_GP.Select("ispartof='部分'").Count();
        iWip = iWip + dt_data_GP.Select("ispartof<>'部分'  and  isnull(workorder_wip,'')  =''").Count();
        iNg = iNg + dt_data_GP.Select(" isnull(workorder_wip,'') <>''").Count();

        //end qc,gp12
        sql = string.Format(@"usp_app_monitor_zl");
        DataSet ds_ = SQLHelper.Query(sql);
        iSh =  ds_.Tables[0].Rows.Count+ ds_.Tables[1].Rows.Count+ds_.Tables[2].Rows.Count;       
         

        string res = "[{\"wip\":\"" + iWip.ToString() + "\",\"part\":\"" + iPart.ToString() + "\",\"ng\":\"" + iNg.ToString() + "\",\"sh\":\"" + iSh.ToString() + "\",\"msg\":\"ok\"}]";
        return res;

    }
  

    [WebMethod]
    public static string lotno_change(string result)
    {
        string res = "";
        // res = "[{\"flag\":\"" + flag + "\",\"msg\":\"" + msg + "\",\"need_no\":\"" + need_no + "\",\"para\":\"" + para + "\"}]";
        return res;

    }


   



}