using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace nnnnnnn
{
    public partial class car : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["UserRole"] != null)
                {
                    string role = Session["UserRole"].ToString();

                    // Hide Login, Show Logout
                    hlLogin.Visible = false;
                    lbLogout.Visible = true;

                    // Toggle Menu Items based on Role
                    if (role == "Admin")
                    {
                        hlAdminDashboard.Visible = true;
                    }
                    else if (role == "Staff")
                    {
                        hlStaffDashboard.Visible = true;
                    }
                    else if (role == "Customer")
                    {
                        hlCustDashboard.Visible = true;
                    }
                }
                else
                {
                    // Not Logged In
                    hlLogin.Visible = true;
                    lbLogout.Visible = false;

                    // Hide all dashboards
                    hlAdminDashboard.Visible = false;
                    hlStaffDashboard.Visible = false;
                    hlCustDashboard.Visible = false;
                }
            }
        }

        protected void lbLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}