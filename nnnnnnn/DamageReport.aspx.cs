using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace nnnnnnn
{
    public partial class DamageReport : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["CarRentalDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["RentalID"] != null)
                {
                    string rentalId = Request.QueryString["RentalID"];
                    lblRentalInfo.Text = "Reporting for Rental Reference #" + rentalId;
                }
                else
                {
                    // If accessed without an ID, go back
                    Response.Redirect("CustomerDashboard.aspx");
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtDescription.Text))
            {
                Response.Write("<script>alert('Please enter a description.');</script>");
                return;
            }

            int rentalId = Convert.ToInt32(Request.QueryString["RentalID"]);
            string type = ddlType.SelectedValue;
            string desc = txtDescription.Text;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_ReportIncident", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RentalID", rentalId);
                    cmd.Parameters.AddWithValue("@Title", type);
                    cmd.Parameters.AddWithValue("@Description", desc);

                    // Defaults for a customer report
                    cmd.Parameters.AddWithValue("@DamageLevel", "Customer Reported");
                    cmd.Parameters.AddWithValue("@EstCost", 0);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Success & Redirect back
            Response.Write("<script>alert('Incident reported successfully.'); window.location='CustomerDashboard.aspx';</script>");
        }
    }
}