using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace nnnnnnn
{
    public partial class driverdashboard : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["CarRentalDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // CRITICAL: Ensure only Drivers can access this page
            if (Session["UserRole"] == null || Session["StaffRole"] == null || Session["StaffRole"].ToString() != "Driver")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindAssignedRentals();
            }
        }

        private void BindAssignedRentals()
        {
            // We assume UserID holds the EmployeeID/DriverID from login
            if (Session["UserID"] == null) return;
            int driverId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetAssignedDriverRentals", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@DriverID", driverId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvAssignedRentals.DataSource = dt;
                    gvAssignedRentals.DataBind();
                }
            }
        }

        // Add other event handlers here later (e.g., btnConfirm_Click)
    }
}