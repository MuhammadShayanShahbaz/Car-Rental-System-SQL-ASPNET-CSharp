using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace nnnnnnn
{
    public partial class cardetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string carId = Request.QueryString["CarID"];
                if (carId != null) LoadCarDetails(Convert.ToInt32(carId));
            }
        }

        private void LoadCarDetails(int id)
        {
            DAL dal = new DAL();
            DataRow row = dal.GetCarByID(id);

            if (row != null)
            {
                imgCar.ImageUrl = row["CarImage"].ToString();
                hBrandModel.InnerText = row["Brand"] + " " + row["Model"];
                hYear.InnerText = row["Year"].ToString();
                hPrice.InnerText = "PKR " + Convert.ToDecimal(row["DailyRate"]).ToString("N0") + " / Day";
                lblTrans.Text = row["Transmission"].ToString();
                lblFuel.Text = row["FuelType"].ToString();
                lblSeats.Text = row["SeatingCapacity"].ToString();
                lblDescBrand.Text = row["Brand"].ToString();
            }
        }

        protected void btnRent_Click(object sender, EventArgs e)
        {
            // Go to Reservation Page with the CarID
            string carId = Request.QueryString["CarID"];
            Response.Redirect("Reservation.aspx?CarID=" + carId);
        }
    }
}