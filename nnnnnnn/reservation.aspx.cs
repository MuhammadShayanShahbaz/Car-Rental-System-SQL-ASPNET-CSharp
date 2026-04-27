using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using WebGrease.Activities;

namespace nnnnnnn
{
    public partial class reservation : System.Web.UI.Page
    {
        // Using the assumed connection string name based on previous context
        string connStr = ConfigurationManager.ConnectionStrings["CarRentalDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                if (Request.QueryString["CarID"] == null) Response.Redirect("RentACar.aspx");

                // AUTO-FILL LOGIC: Fetch existing profile data (CNIC, Address, etc.)
                LoadUserProfile();

                // INITIAL CALCULATION: Display the cost estimate when the page loads
                CalculateAndDisplayCost();
            }
        }

        // ==============================================================================
        // HELPER METHOD 1: Fetch Profile Data
        // ==============================================================================
        private void LoadUserProfile()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Using the updated sp_GetProfile from previous context to fetch all necessary fields
                using (SqlCommand cmd = new SqlCommand("sp_GetProfile", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@PersonID", userId);
                    conn.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            string cnic = rdr["CNIC"].ToString();
                            string lic = rdr["LicenseNo"].ToString();

                            // Only auto-fill if data is not the default 'Add now'
                            if (cnic != "Add now") txtCNIC.Text = cnic;
                            if (lic != "Add now") txtLicense.Text = lic;

                            txtAddress.Text = rdr["Address"].ToString();
                        }
                    }
                }
            }
        }

        // ==============================================================================
        // HELPER METHOD 2: Calculate and Display Cost (for initial view)
        // ==============================================================================
        // This method should be attached to relevant OnTextChanged/AutoPostBack events 
        // for real-time updates if possible, but is required for Page_Load.
        private void CalculateAndDisplayCost()
        {
            if (Request.QueryString["CarID"] == null || !int.TryParse(Request.QueryString["CarID"], out int carId))
            {
                lblTotalAmount.Text = "PKR 0.00";
                return;
            }

            
            // Ensure this logic is exactly like this:
            if (!DateTime.TryParse(txtStart.Text, out DateTime start) ||
                !DateTime.TryParse(txtEnd.Text, out DateTime end))
            {
                lblTotalAmount.Text = "PKR 0.00"; // It sets 0 if dates are empty/invalid
                return;
            }

            // Logic continues...

            int totalDays = (end - start).Days;

            // 1. Get Daily Rate
            decimal dailyRate = GetCarDailyRate(carId);

            if (dailyRate <= 0.00m)
            {
                lblTotalAmount.Text = "PKR 0.00";
                return;
            }

            // 2. Calculate Costs
            decimal baseCost = dailyRate * totalDays;
            decimal totalEstimatedCost = baseCost;

            // 3. Apply 10% Driver Surcharge
            if (chkDriver.Checked)
            {
                totalEstimatedCost += baseCost * 0.10m;
            }

            // Display Total Cost (This is the full estimated cost, not the 50% deposit)
            lblTotalAmount.Text = $"PKR {totalEstimatedCost:N2} (50% Deposit: PKR {totalEstimatedCost * 0.50m:N2})";
        }

        // ==============================================================================
        // HELPER METHOD 3: Fetch Daily Rate from DB (Calls sp_GetCarDailyRate)
        // ==============================================================================
        private decimal GetCarDailyRate(int carId)
        {
            decimal dailyRate = 0.00m;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetCarDailyRate", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CarID", carId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        dailyRate = Convert.ToDecimal(result);
                    }
                }
            }
            return dailyRate;
        }

        // ==============================================================================
        // EVENT HANDLER: Confirm Reservation
        // ==============================================================================
        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            lblError.Text = ""; // Clear previous errors

            // 1. INPUT VALIDATION & INITIALIZATION
            if (string.IsNullOrWhiteSpace(txtCNIC.Text) || string.IsNullOrWhiteSpace(txtLicense.Text) ||
                string.IsNullOrWhiteSpace(txtAddress.Text) || string.IsNullOrWhiteSpace(txtStart.Text) ||
                string.IsNullOrWhiteSpace(txtEnd.Text))
            {
                lblError.Text = "Please fill in all mandatory details (CNIC, License, Address, and Dates).";
                return;
            }

            // 2. DATE PARSING & VALIDITY CHECK
            DateTime start, end;
            if (!DateTime.TryParse(txtStart.Text, out start) || !DateTime.TryParse(txtEnd.Text, out end))
            {
                lblError.Text = "Invalid Date Format.";
                return;
            }

            TimeSpan duration = end - start;
            int totalDays = duration.Days;

            if (totalDays <= 0)
            {
                lblError.Text = "Rental period must be at least 24 hours.";
                return;
            }
            if (start < DateTime.Now.Date)
            {
                lblError.Text = "Start date cannot be in the past.";
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);
            int carId = Convert.ToInt32(Request.QueryString["CarID"]);

            // ---------------- START: FINANCIAL CALCULATION LOGIC ----------------

            decimal dailyRate = GetCarDailyRate(carId);

            if (dailyRate <= 0.00m)
            {
                lblError.Text = "Error: Car rate not found or car is currently unavailable for booking.";
                return;
            }

            decimal baseCost = dailyRate * totalDays;
            decimal totalEstimatedCost = baseCost;

            // Apply 10% Driver Surcharge
            if (chkDriver.Checked)
            {
                totalEstimatedCost += baseCost * 0.10m;
            }

            // The amount paid NOW is the 50% Deposit
            decimal depositAmount = totalEstimatedCost * 0.50m;

            // ---------------- END: FINANCIAL CALCULATION LOGIC ----------------


            // ---------------- DRIVER ASSIGNMENT CHECK ----------------
            int? driverId = null;
            if (chkDriver.Checked)
            {
                // Call the stored procedure to find an available driver
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_FindAvailableDriver", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                            driverId = Convert.ToInt32(result);
                        else
                        {
                            lblError.Text = "Error: Driver requested but none are currently available. Please uncheck the driver option.";
                            return;
                        }
                    }
                }
            }

            // ---------------- PAYMENT & TRANSACTION PREP ----------------
            string couponCode = txtCouponCode.Text.Trim();
            string payMethod;
            string payStatus;
            string transRef = "N/A";

            if (rbOnline.Checked)
            {
                // Basic check for card data (assuming a real API handles the full transaction)
                if (string.IsNullOrWhiteSpace(txtCardNo.Text) || string.IsNullOrWhiteSpace(txtExpiry.Text))
                {
                    lblError.Text = "Please enter complete card details for online payment.";
                    return;
                }

                payMethod = "Online";
                payStatus = "Paid";
                transRef = "TXN-" + Guid.NewGuid().ToString().Substring(0, 8).ToUpper();
            }
            else // Cash on Delivery (rbCOD.Checked)
            {
                payMethod = "COD";
                payStatus = "Pending Payment";
            }

            // ---------------- SAVE RESERVATION AND PAYMENT ----------------
            int reservationId = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_BookReservation", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // CORE RESERVATION DETAILS
                    cmd.Parameters.AddWithValue("@CustomerID", userId);
                    cmd.Parameters.AddWithValue("@CarID", carId);

                    // Explicit SQL Types for Dates (CRITICAL FIX)
                    cmd.Parameters.Add("@Start", SqlDbType.DateTime).Value = start;
                    cmd.Parameters.Add("@End", SqlDbType.DateTime).Value = end;

                    cmd.Parameters.AddWithValue("@Pickup", txtPickup.Text);
                    cmd.Parameters.AddWithValue("@Driver", chkDriver.Checked);
                    cmd.Parameters.AddWithValue("@Accessories", txtAccessories.Text.Trim());
                    cmd.Parameters.AddWithValue("@CouponCode", couponCode);
                    cmd.Parameters.AddWithValue("@DriverID", (object)driverId ?? DBNull.Value);

                    // USER PROFILE DETAILS (Updates Person table)
                    cmd.Parameters.AddWithValue("@CNIC", txtCNIC.Text);
                    cmd.Parameters.AddWithValue("@License", txtLicense.Text);
                    cmd.Parameters.AddWithValue("@Address", txtAddress.Text);

                    // PAYMENT DETAILS
                    cmd.Parameters.AddWithValue("@PayMethod", payMethod);
                    cmd.Parameters.AddWithValue("@PayStatus", payStatus);
                    cmd.Parameters.AddWithValue("@TransRef", transRef);

                    // AMOUNT: The 50% DEPOSIT
                    cmd.Parameters.AddWithValue("@Amount", depositAmount);

                    // Output Parameter for the new Reservation ID
                    SqlParameter outId = new SqlParameter("@ReservationID", SqlDbType.Int)
                    {
                        Direction = ParameterDirection.Output
                    };
                    cmd.Parameters.Add(outId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    reservationId = Convert.ToInt32(outId.Value);
                }
            }

            // ---------------- REDIRECT TO CONFIRMATION ----------------
            Response.Redirect($"fillcard.aspx?ReservationID={reservationId}&TotalCost={totalEstimatedCost:N2}&Deposit={depositAmount:N2}");
        }
        public string GetStatusClass(object statusObj)
        {
            // Ensure the helper can handle potential nulls from the DB
            if (statusObj == null || statusObj == DBNull.Value) return "status-orange";

            // The object statusObj now holds the value from the 'ReservationStatus' column
            string status = statusObj.ToString();

            if (status == "Approved") return "status-green";
            if (status == "Rejected") return "status-red";
            return "status-orange"; // Pending
        }
        // This method runs automatically when Date or Checkbox changes
        protected void CalculateCost_Change(object sender, EventArgs e)
        {
            // Re-run the calculation logic you already wrote
            CalculateAndDisplayCost();
        }
    }
}