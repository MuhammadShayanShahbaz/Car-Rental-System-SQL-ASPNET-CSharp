using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing; // Required for Color.Green/Red

namespace nnnnnnn
{
    public partial class ManagementDashboard : System.Web.UI.Page 

    {

        // 1. Connection String
        string connStr = ConfigurationManager.ConnectionStrings["CarRentalDB"].ConnectionString;

        // --- INSIDE ManagementDashboard.aspx.cs ---

        // Replace the existing Page_Load method with this one:
        protected void Page_Load(object sender, EventArgs e)
        { 
            if (Session["UserRole"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                // Bind User/Car grids first
                BindUserGrid();
                BindCarGrid(); BindInsuranceGrid(); BindReservationGrid();// Bind the NEW grids:
                BindRentalGrid();
                BindMaintenanceGrid(); BindIncidentGrid();

                string role = Session["UserRole"].ToString();

                // 1. UI Permissions & Dropdown Loading
                pnlAdminInsert.Visible = (role == "Admin");
                pnlAddCar.Visible = (role == "Admin");
                pnlAddInsurance.Visible = (role == "Admin");

                if (role == "Staff" && Session["StaffRole"] != null && Session["StaffRole"].ToString() == "Driver")
                {
                    Response.Redirect("DriverDashboard.aspx");
                    return; // Stop execution of the current page
                }
                if (role == "Admin")
                {
                    LoadCarIDs(); // <--- Load Dropdown FIRST if Admin
                                  // Now bind the Insurance Grid which relies on the dropdown existing
                    BindInsuranceGrid(); 
                }
                else // Staff logic
                {
                    BindInsuranceGrid(); // Load grid even if Staff (it will be empty/read-only)
                    if (gvUsers.Columns.Count > 15) gvUsers.Columns[15].Visible = false;
                    if (gvCars.Columns.Count > 13) gvCars.Columns[13].Visible = false;
                    if (gvInsurance.Columns.Count > 10) gvInsurance.Columns[10].Visible = false;
                }
            }
        }
        // =========================================================
        // 4. INSURANCE GRID LOGIC (gvInsurance)
        // =========================================================
        private void BindInsuranceGrid()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetInsurancePolicies", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    try
                    {
                        da.Fill(dt);
                        gvInsurance.DataSource = dt;
                        gvInsurance.DataBind();
                    }
                    catch (Exception ex)
                    {
                        // Optionally handle specific errors, otherwise the grid will be empty
                        Response.Write($"<script>console.log('Error Binding Insurance: {ex.Message}');</script>");
                    }
                }
            }
        }
        protected void TogglePanel_Click(object sender, EventArgs e)
        {
            // Security check
            if (Session["UserRole"].ToString() != "Admin") return;

            // Reset visibility of all panels first
            pnlAdminInsert.Visible = false;
            pnlAddCar.Visible = false;

            // Get the argument passed by the button
            Button btn = (Button)sender;
            string command = btn.CommandArgument;

            if (command == "User")
            {
                pnlAdminInsert.Visible = true;
            }
            else if (command == "Car")
            {
                pnlAddCar.Visible = true;
            }
            // If CommandArgument is "View" or anything else, both panels stay hidden, showing the grids.
        }
        // =========================================================
        // 1. SMART ADD USER
        // =========================================================
        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            if (Session["UserRole"].ToString() != "Admin") return;

            // --- 1. Validation Check ---
            if (string.IsNullOrWhiteSpace(txtNewFirst.Text) ||
                string.IsNullOrWhiteSpace(txtNewUser.Text) ||
                string.IsNullOrWhiteSpace(txtNewEmail.Text))
            {
                Response.Write("<script>alert('Error: First Name, Username, and Email are mandatory fields.');</script>");
                return;
            }

            // --- 2. Data Preparation ---
            string dob = string.IsNullOrEmpty(txtNewDOB.Text) ? "2000-01-01" : txtNewDOB.Text;
            string mainRole = ddlJobTitle.SelectedValue;
            // Set a safe fallback for the specific StaffRole if "None" is selected
            if (mainRole == "None") mainRole = "Customer";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_AddUserSmart", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Parameter Passing (Matches sp_AddUserSmart signature)
                    cmd.Parameters.AddWithValue("@F", txtNewFirst.Text.Trim());
                    cmd.Parameters.AddWithValue("@L", txtNewLast.Text.Trim());
                    cmd.Parameters.AddWithValue("@U", txtNewUser.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtNewEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Phone", txtNewPhone.Text.Trim());

                    cmd.Parameters.AddWithValue("@gender", ddlNewGender.SelectedValue);
                    cmd.Parameters.AddWithValue("@Dob", dob);
                    cmd.Parameters.AddWithValue("@Accst", ddlNewStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@Role", ddlNewRole.SelectedValue); // High-level role
                    cmd.Parameters.AddWithValue("@main", mainRole); // Specific StaffRole/Job Title

                    // --- 3. Execution ---
                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                    catch (SqlException ex) when (ex.Number == 2627)
                    {
                        Response.Write("<script>alert('Error: Username or Email must be unique.');</script>");
                        return;
                    }
                    catch (Exception ex)
                    {
                        Response.Write($"<script>alert('Database Error during User Insert: {ex.Message}');</script>");
                        return;
                    }
                }
            }

            // Clear inputs and Refresh Grid
            txtNewFirst.Text = ""; txtNewLast.Text = ""; txtNewUser.Text = "";
            txtNewEmail.Text = ""; txtNewPhone.Text = ""; txtNewDOB.Text = "";
            BindUserGrid();
        }

        

        // =========================================================
        // 2. USER GRID LOGIC
        // =========================================================
        private void BindUserGrid()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetDashboardUsers", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RequestorRole", Session["UserRole"].ToString());
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvUsers.DataSource = dt;
                    gvUsers.DataBind();
                }
            }
        }

        protected void gvUsers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            if (Session["UserRole"].ToString() != "Admin") return;
            int id = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                new SqlCommand("DELETE FROM Person WHERE PersonID=" + id, conn).ExecuteNonQuery();
            }
            BindUserGrid();
        }

        protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // 1. Delete Button Visibility (Security)
                Button btnDel = (Button)e.Row.FindControl("btnDelete");
                if (btnDel != null)
                {
                    btnDel.Visible = (Session["UserRole"] != null && Session["UserRole"].ToString() == "Admin");
                }

                // 2. Edit Mode Initialization
                if ((e.Row.RowState & DataControlRowState.Edit) > 0)
                {
                    // Find the Staff Role dropdown (CRITICAL: MUST USE FINDCONTROL)
                    DropDownList ddlStaffRole = (DropDownList)e.Row.FindControl("ddlEditStaffRole");

                    if (ddlStaffRole != null)
                    {
                        object staffRoleObj = DataBinder.Eval(e.Row.DataItem, "StaffRole");
                        string currentRole = (staffRoleObj == DBNull.Value || staffRoleObj == null)
                                              ? string.Empty
                                              : staffRoleObj.ToString();

                        // If the value is NULL/Empty OR the value from the database 
                        // doesn't match an item in the list, set a safe default.
                        if (string.IsNullOrEmpty(currentRole) || ddlStaffRole.Items.FindByValue(currentRole) == null)
                        {
                            ddlStaffRole.SelectedValue = "Maintenance Crew";
                        }
                        else
                        {
                            // Value is valid and exists in the list
                            ddlStaffRole.SelectedValue = currentRole;
                        }
                    }
                }
            }
        }

        // --- MISSING EDIT METHODS (ADDED HERE) ---
        protected void gvUsers_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvUsers.EditIndex = e.NewEditIndex;
            BindUserGrid();
        }

        protected void gvUsers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvUsers.EditIndex = -1;
            BindUserGrid();
        }

        protected void gvUsers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // 1. Get the ID
            int id = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);

            // 2. Find Controls
            GridViewRow row = gvUsers.Rows[e.RowIndex];
            TextBox txtcnic = (TextBox)row.FindControl("txtCNIC");
            TextBox txtlice = (TextBox)row.FindControl("txtlicen");
            DropDownList ddlStatus = (DropDownList)row.FindControl("ddlAccountStatus");
            DropDownList ddlRole = (DropDownList)row.FindControl("txtrole"); // Main Role (Customer/Staff/Admin)
            DropDownList ddlStaffRole = (DropDownList)row.FindControl("ddlEditStaffRole"); // Job Title

            // --- 3. Smart Data Preparation ---
            string newRole = ddlRole.SelectedValue;
            string newStaffRole = "Customer"; // Default

            // Logic: Retrieve the Job Title selected by the admin
            if (ddlStaffRole != null)
            {
                newStaffRole = ddlStaffRole.SelectedValue;
            }

            // --- AUTO-CORRECTION FIX ---
            // If Admin selects 'Driver' or 'Maintenance Crew' but forgets to change Role to 'Staff', we fix it here.
            if (newStaffRole == "Driver" || newStaffRole == "Maintenance Crew")
            {
                // If the main role is currently 'Customer', force it to 'Staff'
                if (newRole == "Customer")
                {
                    newRole = "Staff";
                }
            }
            // If Admin selects 'Manager', ensure Role is 'Admin' or 'Staff'
            if (newStaffRole == "Manager" && newRole == "Customer")
            {
                newRole = "Admin";
            }
            // ---------------------------

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateUserSmart", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@ID", id);
                    cmd.Parameters.AddWithValue("@CNIC", txtcnic.Text.Trim());
                    cmd.Parameters.AddWithValue("@License", txtlice.Text.Trim());
                    cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@NewRole", newRole); // Passes the auto-corrected role
                    cmd.Parameters.AddWithValue("@NewStaffRole", newStaffRole);

                    conn.Open();
                    try
                    {
                        cmd.ExecuteNonQuery();

                        // Success
                        gvUsers.EditIndex = -1;
                        BindUserGrid();

                        // Optional: Show success alert
                        // Response.Write($"<script>alert('User updated to {newRole} - {newStaffRole}');</script>");
                    }
                    catch (SqlException ex)
                    {
                        if (ex.Number == 547)
                            Response.Write($"<script>alert('Error: Cannot change role. This user has active records in other tables (Rentals/Maintenance). Delete those first.');</script>");
                        else
                            Response.Write($"<script>alert('SQL Error: {ex.Message}');</script>");
                    }
                }
            }
        }
        // =========================================================
        // 3. CAR GRID LOGIC
        // =========================================================
        private void BindCarGrid()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_ManageCars_Get", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    try
                    {
                        da.Fill(dt);
                        gvCars.DataSource = dt;
                        gvCars.DataBind();
                    }
                    catch { /* Handle empty */ }
                }
            }
        }

        protected void gvCars_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            if (Session["UserRole"].ToString() != "Admin") return;
            int carId = Convert.ToInt32(gvCars.DataKeys[e.RowIndex].Value);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                new SqlCommand("DELETE FROM Car WHERE CarID=" + carId, conn).ExecuteNonQuery();
            }
            BindCarGrid();
        }

        protected void gvCars_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Button btnDel = (Button)e.Row.FindControl("btnDeleteCar");
                if (btnDel != null) btnDel.Visible = (Session["UserRole"].ToString() == "Admin");

                Label lbl = (Label)e.Row.FindControl("lblStatus");
                if (lbl != null)
                {
                    lbl.ForeColor = (lbl.Text == "Available") ? Color.Green : Color.Red;
                    lbl.Font.Bold = true;
                }

                if ((e.Row.RowState & DataControlRowState.Edit) > 0)
                {
                    DropDownList ddl = (DropDownList)e.Row.FindControl("ddlStatus");
                    string current = DataBinder.Eval(e.Row.DataItem, "Status").ToString();
                    if (ddl != null) ddl.SelectedValue = current;
                }
                if ((e.Row.RowState & DataControlRowState.Edit) > 0)
                {
                    DropDownList ddlStatus = (DropDownList)e.Row.FindControl("ddlStatus");
                    if (ddlStatus != null) ddlStatus.SelectedValue = DataBinder.Eval(e.Row.DataItem, "Status").ToString();

                    // Find the new IsInsured Dropdown
                    DropDownList ddlInsured = (DropDownList)e.Row.FindControl("ddlIsInsured");
                    if (ddlInsured != null)
                    {
                        // Get the current IsInsured BIT value (True or False)
                        bool isInsuredValue = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "IsInsured"));

                        // Select the matching option ("True" or "False")
                        ddlInsured.SelectedValue = isInsuredValue.ToString();
                    }
                }
            }
        }
        protected void gvCars_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // 1. Find Data & Controls
            int carId = Convert.ToInt32(gvCars.DataKeys[e.RowIndex].Value);

            // Find the dropdown controls
            DropDownList ddlStatus = (DropDownList)gvCars.Rows[e.RowIndex].FindControl("ddlStatus");
            DropDownList ddlFuelT = (DropDownList)gvCars.Rows[e.RowIndex].FindControl("ddlFuelType");
            DropDownList ddlInsured = (DropDownList)gvCars.Rows[e.RowIndex].FindControl("ddlIsInsured"); // <-- NEW CONTROL

            // Find textboxes
            TextBox txtRate = (TextBox)gvCars.Rows[e.RowIndex].FindControl("txtRate");
            TextBox txtplate = (TextBox)gvCars.Rows[e.RowIndex].FindControl("txtPlateNumber");
            TextBox txtmod = (TextBox)gvCars.Rows[e.RowIndex].FindControl("txtModel");
            TextBox txtbr = (TextBox)gvCars.Rows[e.RowIndex].FindControl("txtBrand");
            TextBox txtTran = (TextBox)gvCars.Rows[e.RowIndex].FindControl("txtTransmission");
            TextBox txtSeat = (TextBox)gvCars.Rows[e.RowIndex].FindControl("txtSeatingCapacity");
            TextBox txtYearw = (TextBox)gvCars.Rows[e.RowIndex].FindControl("txtYear");
            TextBox txtCar = (TextBox)gvCars.Rows[e.RowIndex].FindControl("txtCarImage");

            // 2. Data Conversion (Safer conversion for numeric and boolean types)
            if (!decimal.TryParse(txtRate.Text, out decimal dailyRate)) return;
            if (!int.TryParse(txtSeat.Text, out int seats)) seats = 0;
            if (!int.TryParse(txtYearw.Text, out int year)) year = 0;

            // Convert dropdown string ("True" or "False") to boolean (BIT)
            bool isInsured = Convert.ToBoolean(ddlInsured.SelectedValue); // <-- NEW CONVERSION

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_ManageCars_Update", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CarID", carId);

                    // Pass converted values and dropdown selections
                    cmd.Parameters.AddWithValue("@ft", ddlFuelT.SelectedValue);
                    cmd.Parameters.AddWithValue("@pl", txtplate.Text.Trim());
                    cmd.Parameters.AddWithValue("@mod", txtmod.Text.Trim());
                    cmd.Parameters.AddWithValue("@br", txtbr.Text.Trim());
                    cmd.Parameters.AddWithValue("@tr", txtTran.Text.Trim());
                    cmd.Parameters.AddWithValue("@sc", seats); // Pass int
                    cmd.Parameters.AddWithValue("@yy", year); // Pass int
                    cmd.Parameters.AddWithValue("@cari", txtCar.Text.Trim());
                    cmd.Parameters.AddWithValue("@DailyRate", dailyRate); // Pass decimal
                    cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@ins", isInsured); // <-- PASS BOOLEAN

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            gvCars.EditIndex = -1;
            BindCarGrid();       // Refresh Car Grid to show new IsInsured status
            BindInsuranceGrid();
        }
        protected void btnAddCarSubmit_Click(object sender, EventArgs e)
        {
            // 1. Security Check
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
            {
                return;
            }

            // 2. Input Validation
            if (string.IsNullOrWhiteSpace(txtAddPlate.Text) || string.IsNullOrWhiteSpace(txtAddBrand.Text) ||
                string.IsNullOrWhiteSpace(txtAddRate.Text) || string.IsNullOrWhiteSpace(txtAddYear.Text) ||
                ddlAddFuel.SelectedValue == "")
            {
                Response.Write("<script>alert('Error: Please fill in all required fields (Plate, Brand, Rate, Year, Fuel).');</script>");
                return;
            }

            // 3. Safe Data Conversion
            if (!decimal.TryParse(txtAddRate.Text, out decimal dailyRate))
            {
                Response.Write("<script>alert('Error: Daily Rate must be a valid number.');</script>"); return;
            }
            if (!int.TryParse(txtAddYear.Text, out int year))
            {
                Response.Write("<script>alert('Error: Year must be a valid integer.');</script>"); return;
            }

            int seats = 0;
            if (!string.IsNullOrWhiteSpace(txtAddSeats.Text))
            {
                int.TryParse(txtAddSeats.Text, out seats);
            }

            // ---------------------------------------------------------
            // 4. IMAGE UPLOAD LOGIC (Folder: Carimages)
            // ---------------------------------------------------------
            string imagePath = "~/Carimages/default_car.jpg"; // Default fallback if no file selected

            if (fuAddImage.HasFile)
            {
                try
                {
                    // A. Generate a unique filename to prevent overwriting existing images
                    // Example: "a1b2c3d4_bmw.jpg"
                    string fileName = Guid.NewGuid().ToString() + "_" + fuAddImage.FileName;

                    // B. Get the physical path to your "Carimages" folder
                    string folderPath = Server.MapPath("~/Carimages/");

                    // C. Save the file
                    fuAddImage.SaveAs(folderPath + fileName);

                    // D. Set the path variable to save in the Database
                    imagePath = "~/Carimages/" + fileName;
                }
                catch (Exception ex)
                {
                    Response.Write($"<script>alert('Image Upload Error: {ex.Message}');</script>");
                    return;
                }
            }

            // 5. Database Insertion
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_AddCar", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Pass parameters to SQL
                    cmd.Parameters.AddWithValue("@PlateNumber", txtAddPlate.Text.Trim());
                    cmd.Parameters.AddWithValue("@Brand", txtAddBrand.Text.Trim());
                    cmd.Parameters.AddWithValue("@Model", txtAddModel.Text.Trim());
                    cmd.Parameters.AddWithValue("@Year", year);
                    cmd.Parameters.AddWithValue("@FuelType", ddlAddFuel.SelectedValue);
                    cmd.Parameters.AddWithValue("@Transmission", txtAddTrans.Text.Trim());
                    cmd.Parameters.AddWithValue("@SeatingCapacity", seats);
                    cmd.Parameters.AddWithValue("@DailyRate", dailyRate);
                    cmd.Parameters.AddWithValue("@IsInsured", chkAddInsured.Checked);

                    // Use the uploaded image path here
                    cmd.Parameters.AddWithValue("@CarImage", imagePath);
                    cmd.Parameters.AddWithValue("@Status", "Available");

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();

                        // 6. Success: Clear inputs and Refresh Grid
                        txtAddPlate.Text = "";
                        txtAddBrand.Text = "";
                        txtAddModel.Text = "";
                        txtAddYear.Text = "";
                        txtAddRate.Text = "";
                        txtAddTrans.Text = "";
                        txtAddSeats.Text = "";
                        chkAddInsured.Checked = false;

                        BindCarGrid();
                        BindInsuranceGrid(); // Because adding a car might auto-add insurance

                        Response.Write("<script>alert('Car added successfully!');</script>");
                    }
                    catch (SqlException ex)
                    {
                        if (ex.Number == 2627)
                        {
                            Response.Write("<script>alert('Error: A car with this Plate Number already exists.');</script>");
                        }
                        else
                        {
                            Response.Write($"<script>alert('Database Error: {ex.Message}');</script>");
                        }
                    }
                }
            }
        }
        protected void gvCars_RowEditing(object sender, GridViewEditEventArgs e) { gvCars.EditIndex = e.NewEditIndex; BindCarGrid(); }
        protected void gvCars_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e) { gvCars.EditIndex = -1; BindCarGrid(); }
        // =========================================================
        // 4. INSURANCE GRID LOGIC (gvInsurance)
        // =========================================================
        protected void btnAddInsuranceSubmit_Click(object sender, EventArgs e)
        {
            if (Session["UserRole"].ToString() != "Admin") return;

            // --- Validation and Safe Parsing (omitted for brevity, assume valid inputs) ---
            if (ddlInsCarID.SelectedValue == "0" || string.IsNullOrWhiteSpace(txtInsPolicy.Text) ||
                !int.TryParse(ddlInsCarID.SelectedValue, out int carId) ||
                !decimal.TryParse(txtInsAmount.Text, out decimal amount) ||
                !DateTime.TryParse(txtInsStart.Text, out DateTime startDate) ||
                !DateTime.TryParse(txtInsEnd.Text, out DateTime endDate))
            {
                Response.Write("<script>alert('Error: Check required fields and format.');</script>");
                return;
            }

            // Check if dates are logical (startDate < endDate)
            if (startDate >= endDate)
            {
                Response.Write("<script>alert('Error: Policy Start Date must be before End Date.');</script>");
                return;
            }
            // End Validation

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_InsertInsurancePolicy", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@CarID", carId);
                    cmd.Parameters.AddWithValue("@Provider", txtInsProvider.Text.Trim());
                    cmd.Parameters.AddWithValue("@PolicyNumber", txtInsPolicy.Text.Trim());
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);
                    cmd.Parameters.AddWithValue("@CoverageAmount", amount);

                    conn.Open();
                    try
                    {
                        cmd.ExecuteNonQuery();
                    }
                    catch (SqlException ex)
                    {
                        if (ex.Number == 547)
                        {
                            Response.Write("<script>alert('SQL Error: The specified Car ID does not exist.');</script>");
                        }
                        else if (ex.Number == 2627)
                        {
                            Response.Write("<script>alert('SQL Error: Policy Number must be unique.');</script>");
                        }
                        else
                        {
                            Response.Write($"<script>alert('DB Error: {ex.Message}');</script>");
                        }
                        return;
                    }
                }
            }

            // Clear fields and Refresh Grids
            ddlInsCarID.SelectedIndex = 0;
            txtInsProvider.Text = ""; txtInsPolicy.Text = "";
            txtInsAmount.Text = ""; txtInsStart.Text = ""; txtInsEnd.Text = "";

            BindCarGrid();       // <-- NOW REFRESHES CARS TO SHOW IsInsured = 1
            BindInsuranceGrid(); // Refresh Insurance list
        }
        protected void gvInsurance_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            if (Session["UserRole"].ToString() != "Admin") return; // Admin only

            // --- FIX: Get the specific GridViewRow object using the index ---
            GridViewRow row = gvInsurance.Rows[e.RowIndex];

            int policyId = Convert.ToInt32(gvInsurance.DataKeys[e.RowIndex].Value);

            // Find Controls within the identified row
            TextBox txtProvider = (TextBox)row.FindControl("txtProvider");
            TextBox txtPolicy = (TextBox)row.FindControl("txtPolicyNumber");
            TextBox txtAmount = (TextBox)row.FindControl("txtEditAmount");
            CheckBox chkActive = (CheckBox)row.FindControl("chkEditActive");

            // --- Dates from BoundFields need to be retrieved from the values collected by ASP.NET ---
            // The UpdateEventArgs (e) automatically collects values from BoundFields and puts them in e.NewValues
            // However, since dates are often edited in TemplateFields, we must rely on the row index method:

            // 1. Get the current data item for date extraction (using DataKeys index)
            // You need to ensure the BoundFields for StartDate and EndDate are marked ReadOnly="false" in the HTML 
            // OR we can retrieve the values directly from e.NewValues collection if we relied on BoundFields. 

            // **SAFER APPROACH: Since dates were not set up as TemplateFields for editing, 
            // we must rely on e.NewValues (if BoundField editing is enabled) or the original data.**

            // Since BoundFields for dates often cause issues when editing, let's assume they were not edited 
            // and rely on the value being updated from the GridView control state itself.

            // Let's rely on the original structure and focus on the data you meant to update:

            decimal amount;

            if (!decimal.TryParse(txtAmount.Text, out amount))
            {
                // Cancel the edit if conversion fails
                gvInsurance.EditIndex = -1;
                BindInsuranceGrid();
                Response.Write("<script>alert('Error: Coverage Amount must be a valid number.');</script>");
                return;
            }

            // --- IMPORTANT: Retrieving BoundField Date Values ---
            // Because BoundFields were used for dates, the simplest way is to retrieve the 
            // original non-edited value from the row's data item or rely on the e.NewValues dictionary.

            // For simplicity, let's extract the date from the non-editable cells as a fallback 
            // if you didn't mark them as ReadOnly=false. (Index 7 and 8)
            string startDateStr = row.Cells[7].Text;
            string endDateStr = row.Cells[8].Text;

            if (!DateTime.TryParse(startDateStr, out DateTime startDate) ||
                !DateTime.TryParse(endDateStr, out DateTime endDate))
            {
                // Fallback or error handling if date parsing fails
                // This is necessary because BoundFields can be complex
                startDate = DateTime.Now;
                endDate = DateTime.Now.AddYears(1);
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateInsurancePolicy", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@InsuranceID", policyId);
                    cmd.Parameters.AddWithValue("@Provider", txtProvider.Text);
                    cmd.Parameters.AddWithValue("@PolicyNumber", txtPolicy.Text);
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);
                    cmd.Parameters.AddWithValue("@CoverageAmount", amount);
                    cmd.Parameters.AddWithValue("@IsActive", chkActive.Checked);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            gvInsurance.EditIndex = -1;
            BindInsuranceGrid();
        }// --- ADDED: START EDIT MODE ---
        protected void gvInsurance_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvInsurance.EditIndex = e.NewEditIndex;
            BindInsuranceGrid();
        }

        // --- ADDED: CANCEL EDIT MODE ---
        protected void gvInsurance_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvInsurance.EditIndex = -1;
            BindInsuranceGrid();
        } // --- ADDED: INSURANCE ROW DATA BOUND METHOD ---
        protected void gvInsurance_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // This is where you would put logic to change colors, 
            // format data, or show/hide controls in the Insurance Grid.

            // For now, we'll keep it empty to fix the compile error.
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Example: Check if the policy is active and color the row background
                // Note: You may need to update your HTML to allow editing dates if required.
                // bool isActive = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "IsActive"));
                // if (!isActive)
                // {
                //     e.Row.BackColor = System.Drawing.Color.LightPink;
                // }
            }
        }// This method ensures the ddlInsCarID dropdown is populated
        private void LoadCarIDs()
        {
            // You should use the same connStr variable declared globally
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Selects CarID and a combined string for the display text
                string sql = "SELECT CarID, Brand + ' ' + Model + ' (' + PlateNumber + ')' AS CarInfo FROM Car ORDER BY Brand";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();

                    // Use SqlDataReader to populate the list
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            ddlInsCarID.DataSource = reader;
                            ddlInsCarID.DataTextField = "CarInfo";
                            ddlInsCarID.DataValueField = "CarID";
                            ddlInsCarID.DataBind();
                        }
                    }
                }
            }
            // Always add a default prompt item
            ddlInsCarID.Items.Insert(0, new ListItem("-- Select Car --", "0"));
        }
        protected void gvInsurance_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            if (Session["UserRole"].ToString() != "Admin") return; // Admin only

            int policyId = Convert.ToInt32(gvInsurance.DataKeys[e.RowIndex].Value);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_DeleteInsurancePolicy", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@InsuranceID", policyId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            BindCarGrid();       // Refresh car grid to update IsInsured status
            BindInsuranceGrid(); // Refresh policy list
        }


        // 1. Add BindReservations() to Page_Load (for Admin and Staff)

        // 2. Bind Method// =========================================================
        // 5. RESERVATION LOGIC
        // =========================================================

        private void BindReservationGrid()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetAllReservations", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    try
                    {
                        da.Fill(dt);
                        gvReservations.DataSource = dt;
                        gvReservations.DataBind();
                    }
                    catch { /* Handle empty */ }
                }
            }
        }

        protected void gvReservations_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string status = "";

            if (e.CommandName == "ApproveRes")
            {
                status = "Approved";
            }
            else if (e.CommandName == "RejectRes")
            {
                status = "Rejected";
            }
            else
            {
                return; // Not our command
            }

            int resId = Convert.ToInt32(e.CommandArgument);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateReservationStatus", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ReservationID", resId);
                    cmd.Parameters.AddWithValue("@Status", status);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            BindReservationGrid(); // Refresh to see new status
            BindCarGrid();
        }

        protected void gvReservations_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // 1. Color Code the Status
                Label lblStatus = (Label)e.Row.FindControl("lblResStatus");
                if (lblStatus != null)
                {
                    string status = lblStatus.Text;
                    if (status == "Pending") lblStatus.ForeColor = System.Drawing.Color.Orange;
                    else if (status == "Approved") lblStatus.ForeColor = System.Drawing.Color.Green;
                    else if (status == "Rejected") lblStatus.ForeColor = System.Drawing.Color.Red;
                }

                // 2. Hide Buttons if NOT Pending
                // (Once approved/rejected, you shouldn't change it again easily)
                if (lblStatus != null && lblStatus.Text != "Pending")
                {
                    Button btnApp = (Button)e.Row.FindControl("btnApprove");
                    Button btnRej = (Button)e.Row.FindControl("btnReject");
                    if (btnApp != null) btnApp.Visible = false;
                    if (btnRej != null) btnRej.Visible = false;
                }
                BindRentalGrid();

            }
        }
        private void BindRentalGrid()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetAllRentals", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvRentals.DataSource = dt;
                    gvRentals.DataBind();
                }
            }
        }

        private void BindMaintenanceGrid()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetMaintenanceHistory", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvMaintenance.DataSource = dt;
                    gvMaintenance.DataBind();
                }
            }
        }
        protected void gvRentals_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int rentalId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ReportIncident")
            {
                // Store ID for the popup panel
                hfIncidentRentalID.Value = rentalId.ToString();
                pnlIncident.Visible = true;
                txtIncTitle.Focus();
            }
            else if (e.CommandName == "ReturnCar")
            {
                // 1. Calls SP to close rental and sets Car Status = 'Maintenance'
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_ProcessReturn", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@RentalID", rentalId);
                        conn.Open(); cmd.ExecuteNonQuery();
                    }
                }
                lblMsg.Text = $"Rental {rentalId} returned and moved to Maintenance.";
                BindRentalGrid();
                BindMaintenanceGrid();
                BindCarGrid();
            }
        }

        // 2. INCIDENT SUBMISSION
        protected void btnSaveIncident_Click(object sender, EventArgs e)
        {
            int rentalId = Convert.ToInt32(hfIncidentRentalID.Value);
            decimal.TryParse(txtIncCost.Text, out decimal cost);

            // 1. Call SP to log the incident
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_ReportIncident", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RentalID", rentalId);
                    cmd.Parameters.AddWithValue("@Title", txtIncTitle.Text);
                    cmd.Parameters.AddWithValue("@Description", txtIncDesc.Text);
                    cmd.Parameters.AddWithValue("@DamageLevel", ddlIncLevel.SelectedValue);
                    cmd.Parameters.AddWithValue("@EstCost", cost);
                    conn.Open(); cmd.ExecuteNonQuery();
                }
            }

            // 2. FORCE CAR INTO MAINTENANCE STATUS
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Query to find the CarID from the RentalID and update its status
                string sql = "UPDATE Car SET Status = 'Maintenance' WHERE CarID = (SELECT CarID FROM Rental WHERE RentalID = @RentalID)";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@RentalID", rentalId);
                    conn.Open(); cmd.ExecuteNonQuery();
                }
            }

            pnlIncident.Visible = false;
            lblMsg.Text = "Incident Reported and Car placed in Maintenance.";
            BindUserGrid();
            BindCarGrid(); BindInsuranceGrid(); BindReservationGrid();// Bind the NEW grids:
            BindRentalGrid();
            BindMaintenanceGrid(); BindIncidentGrid();
        }
        protected void btnCancelIncident_Click(object sender, EventArgs e)
        {
            pnlIncident.Visible = false;
        }

        // 3. MAINTENANCE GRID UPDATE (REINLIST)
        protected void gvMaintenance_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int maintId = Convert.ToInt32(gvMaintenance.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvMaintenance.Rows[e.RowIndex];

            // Retrieve values from Edit Templates
            string type = ((DropDownList)row.FindControl("ddlMaintType")).SelectedValue;
            string desc = ((TextBox)row.FindControl("txtMaintDesc")).Text;
            decimal.TryParse(((TextBox)row.FindControl("txtMaintCost")).Text, out decimal cost);

            // Call SP to close maintenance and set car status to 'Available'
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_CompleteMaintenanceAndReinlist", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@MaintenanceID", maintId);
                    cmd.Parameters.AddWithValue("@MaintenanceType", type);
                    cmd.Parameters.AddWithValue("@Description", desc);
                    cmd.Parameters.AddWithValue("@Cost", cost);
                    conn.Open(); cmd.ExecuteNonQuery();
                }
            }

            gvMaintenance.EditIndex = -1;
            lblMsg.Text = $"Maintenance {maintId} finished. Car is now available.";
            BindMaintenanceGrid();
            BindCarGrid();
        }

        // Standard Edit/Cancel Handlers
        protected void gvMaintenance_RowEditing(object sender, GridViewEditEventArgs e) { gvMaintenance.EditIndex = e.NewEditIndex; BindMaintenanceGrid(); }
        protected void gvMaintenance_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e) { gvMaintenance.EditIndex = -1; BindMaintenanceGrid(); }
        // --- INCIDENT GRID UPDATE LOGIC ---

        protected void gvIncidentReports_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvIncidentReports.EditIndex = e.NewEditIndex;
            BindIncidentGrid();
        }

        protected void gvIncidentReports_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvIncidentReports.EditIndex = -1;
            BindIncidentGrid();
        }

        protected void gvIncidentReports_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // 1. Get ID and Controls
            int incidentId = Convert.ToInt32(gvIncidentReports.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvIncidentReports.Rows[e.RowIndex];

            DropDownList ddlStatus = (DropDownList)row.FindControl("ddlEditStatus");
            TextBox txtCost = (TextBox)row.FindControl("txtEditCost");

            decimal newCost = 0;
            decimal.TryParse(txtCost.Text, out newCost);

            // 2. Call Update Procedure
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_UpdateIncidentReport", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IncidentID", incidentId);
                    cmd.Parameters.AddWithValue("@NewStatus", ddlStatus.SelectedValue);
                    cmd.Parameters.AddWithValue("@NewCost", newCost);

                    conn.Open();
                    try
                    {
                        cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        lblMsg.Text = "Error updating incident: " + ex.Message;
                        return;
                    }
                }
            }

            // 3. Exit Edit Mode and Refresh
            gvIncidentReports.EditIndex = -1;
            BindIncidentGrid();
            lblMsg.Text = $"Incident {incidentId} updated successfully.";
        }
        private void BindIncidentGrid()
        {
            // Reuses your generic BindGrid helper if you have one, or use the full implementation below:
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetIncidentReports", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    try { da.Fill(dt); gvIncidentReports.DataSource = dt; gvIncidentReports.DataBind(); } catch { }
                }
            }
        }

    }   
}