using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace nnnnnnn
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If already logged in, redirect to home
            if (Session["UserRole"] != null)
            {
                Response.Redirect("Home.aspx");
            }
        }
        // Add this method inside your existing login.aspx.cs class
        protected void btnGoToRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("Register.aspx");
        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // Ensure you have a DAL or direct SQL implementation here. 
            // Assuming you are using direct SQL connection for simplicity:

            string connStr = ConfigurationManager.ConnectionStrings["CarRentalDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UserLogin", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Username", txtUsername.Text);
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text);

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        string userRole = reader["UserRole"].ToString();
                        int userID = Convert.ToInt32(reader["ID"]);

                        if (userRole != "Invalid" && userID > 0)
                        {
                            // Basic session variables
                            Session["UserID"] = userID;
                            Session["UserRole"] = userRole;
                            Session["UserName"] = reader["Name"].ToString();

                            // CRITICAL: Save the specific Staff Role for Driver check
                            if (reader["StaffRole"] != DBNull.Value)
                            {
                                Session["StaffRole"] = reader["StaffRole"].ToString();
                            }
                            else
                            {
                                Session["StaffRole"] = null;
                            }

                            // Redirect based on the primary role
                            if (userRole == "Admin" || userRole == "Staff")
                            {
                                // ManagementDashboard will handle the specific 'Driver' redirect
                                Response.Redirect("ManagementDashboard.aspx");
                            }
                            else if (userRole == "Customer")
                            {
                                Response.Redirect("CustomerDashboard.aspx");
                            }
                        }
                        else
                        {
                            lblMessage.Text = "Invalid username or password.";
                        }
                    }
                }
            }
        }
    }
}