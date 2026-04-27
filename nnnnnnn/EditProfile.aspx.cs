using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace nnnnnnn
{
    public partial class EditProfile : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["CarRentalDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadCurrentProfile();
            }
        }

        private void LoadCurrentProfile()
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
                                txtFirstName.Text = rdr["FirstName"].ToString();
                                txtLastName.Text = rdr["LastName"].ToString();
                                txtEmail.Text = rdr["Email"].ToString();
                                txtPhone.Text = rdr["PhoneNo"].ToString();
                                txtAddress.Text = rdr["Address"].ToString();
                                txtCNIC.Text = rdr["CNIC"].ToString();
                                txtLicense.Text = rdr["LicenseNo"].ToString();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading profile: " + ex.Message;
                lblMessage.CssClass = "text-danger";
            }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_UpdateProfile", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@PersonID", userId);
                        cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                        cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@PhoneNo", txtPhone.Text.Trim());
                        cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                        cmd.Parameters.AddWithValue("@CNIC", txtCNIC.Text.Trim());
                        cmd.Parameters.AddWithValue("@LicenseNo", txtLicense.Text.Trim());

                        conn.Open();
                        cmd.ExecuteNonQuery();

                        lblMessage.Text = "Profile updated successfully!";
                        lblMessage.CssClass = "text-success";

                        // Update session if name changed
                        Session["UserName"] = txtFirstName.Text + " " + txtLastName.Text;

                        // Hide Save/Cancel
                        btnSave.Visible = false;
                        btnCancel.Visible = false;

                        // Show the new buttons
                        btnReturn.CssClass = btnReturn.CssClass.Replace("d-none", "");
                        btnEditAgain.CssClass = btnEditAgain.CssClass.Replace("d-none", "");
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error updating profile: " + ex.Message;
                lblMessage.CssClass = "text-danger";
            }
        }
        protected void btnReturn_Click(object sender, EventArgs e)
        {
            Response.Redirect("CustomerDashboard.aspx");
        }

        protected void btnEditAgain_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditProfile.aspx");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("CustomerDashboard.aspx");
        }
    }
}