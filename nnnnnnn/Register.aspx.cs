using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace nnnnnnn
{
    public partial class Register : System.Web.UI.Page
    {
        // Instance of your Data Access Layer
        DAL myDal = new DAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserRole"] != null)
            {
                Response.Redirect("Home.aspx");
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // 1. Validation
            if (string.IsNullOrWhiteSpace(txtFirst.Text) || string.IsNullOrWhiteSpace(txtLast.Text) ||
                string.IsNullOrWhiteSpace(txtUser.Text) || string.IsNullOrWhiteSpace(txtPass.Text) ||
                string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                lblMsg.Text = "Please fill in all fields.";
                return;
            }

            DateTime dob;
            if (!DateTime.TryParse(txtDOB.Text, out dob))
            {
                lblMsg.Text = "Please enter a valid Date of Birth.";
                return;
            }

            // 2. Call DAL to save to Database
            // This calls the 'sp_RegisterCustomer' procedure we created
            bool isSuccess = myDal.RegisterCustomer(
                txtFirst.Text.Trim(),
                txtLast.Text.Trim(),
                txtUser.Text.Trim(),
                txtPass.Text.Trim(),
                txtEmail.Text.Trim(),
                txtPhone.Text.Trim(),
                ddlGender.SelectedValue,
                dob
            );

            // 3. Handle Success/Failure
            if (isSuccess)
            {
                // Send them back to Login with a success message
                Response.Write("<script>alert('Account created successfully! Please Login.'); window.location='Login.aspx';</script>");
            }
            else
            {
                lblMsg.Text = "Registration failed. Username or Email may already exist.";
            }
        }
    }
}