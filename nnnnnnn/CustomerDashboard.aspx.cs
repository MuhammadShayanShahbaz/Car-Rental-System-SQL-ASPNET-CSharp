using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace nnnnnnn
{
    public partial class CustomerDashboard : System.Web.UI.Page
    {
        // Connection String
        string connStr = ConfigurationManager.ConnectionStrings["CarRentalDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Security Check
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                // 2. Load Data on first visit
                LoadProfile();
                LoadReservations();
            }
        }

        // =================================================================
        // DATA LOADING METHODS
        // =================================================================
        private void LoadProfile()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetProfile", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@PersonID", userId);
                        conn.Open();
                        using (SqlDataReader rdr = cmd.ExecuteReader())
                        {
                            if (rdr.Read())
                            {
                                lblName.Text = rdr["FirstName"].ToString() + " " + rdr["LastName"].ToString();
                                lblEmail.Text = rdr["Email"].ToString();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Profile Load Error: " + ex.Message);
            }
        }

        private void LoadReservations()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_GetMyReservations", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@CustomerID", userId);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        gvMyReservations.DataSource = dt;
                        gvMyReservations.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Reservations Load Error: " + ex.Message);
            }
        }

        // =================================================================
        // BUTTON ACTIONS (ROW COMMAND)
        // =================================================================
        protected void gvMyReservations_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                // 1. Get the Rental ID from the button's CommandArgument
                int rentalId = Convert.ToInt32(e.CommandArgument);

                // 2. Handle "ReturnCar" Logic
                if (e.CommandName == "ReturnCar")
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        using (SqlCommand cmd = new SqlCommand("sp_ProcessReturn", conn))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("@RentalID", rentalId);
                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }
                    // Show success and refresh to update status to "Returned"
                    Response.Write("<script>alert('Car returned successfully!');</script>");
                    LoadReservations();
                }
                // 3. Handle "RedirectToReport" Logic (The Incident Button)
                else if (e.CommandName == "RedirectToReport")
                {
                    // Redirect to the DamageReport page, passing the RentalID
                    Response.Redirect("DamageReport.aspx?RentalID=" + rentalId);
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }

        // =================================================================
        // HELPER METHODS (For Styling & Logic)
        // =================================================================
        protected void btnEditProfile_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditProfile.aspx");
        }

        // Sets the color of the status badge
        protected string GetStatusClass(object statusObj)
        {
            if (statusObj == null) return "status-badge status-grey";

            string status = statusObj.ToString().ToLower();

            if (status == "active" || status == "approved") return "status-badge status-green";
            if (status == "pending") return "status-badge status-orange";
            if (status == "completed") return "status-badge status-blue";
            if (status == "cancelled" || status == "rejected") return "status-badge status-red";

            return "status-badge status-grey";
        }

        // Checks if there is a penalty to color the text Red/Green
        protected bool IsPenaltyActive(object penaltyObj)
        {
            if (penaltyObj == null || penaltyObj == DBNull.Value) return false;

            decimal penalty;
            if (decimal.TryParse(penaltyObj.ToString(), out penalty))
            {
                return penalty > 0;
            }
            return false;
        }
    }
}