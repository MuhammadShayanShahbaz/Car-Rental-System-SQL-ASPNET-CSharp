using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace nnnnnnn
{
    public partial class RentaCar : System.Web.UI.Page
    {
        DAL myDal = new DAL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initial Load (Default values)
                LoadFilteredCars();
            }
        }

        // Triggered when Search Button is clicked
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadFilteredCars();
        }

        private void LoadFilteredCars()
        {
            // 1. Get values from UI
            string search = txtSearch.Text.Trim();
            string category = ddlCategory.SelectedValue;
            string sort = ddlSort.SelectedValue;

            // 2. Call DAL with parameters
            DataTable dt = myDal.FilterCars(search, category, sort);

            // 3. Bind to Repeater
            if (dt.Rows.Count > 0)
            {
                rptCars.DataSource = dt;
                rptCars.DataBind();
                lblNoResults.Visible = false;
            }
            else
            {
                rptCars.DataSource = null;
                rptCars.DataBind();
                lblNoResults.Visible = true; // Show "No cars found"
            }
        }
    }
}