<%@ Page Title="Management Dashboard" Language="C#" MasterPageFile="~/car.master" AutoEventWireup="true" CodeBehind="ManagementDashboard.aspx.cs" Inherits="nnnnnnn.ManagementDashboard" MaintainScrollPositionOnPostback="true"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
/* ===== General Dashboard Styling ===== */
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    font-size: 11px;
    background-color: #f9f9f9;
    color: #333;
}

.dashboard-container {
    padding: 15px;
    max-width: 1400px;
    margin: 0 auto;
}

.section-title {
    margin-top: 15px;
    margin-bottom: 8px;
    padding-bottom: 3px;
    border-bottom: 2px solid #007bff;
    font-size: 1rem;
    font-weight: 600;
    color: #007bff;
}

h2, h3, h4 {
    color: #343a40;
}

/* ===== Buttons ===== */
.btn-action {
    padding: 2px 6px;
    font-size: 0.65rem;
    font-weight: 600;
    border-radius: 4px;
    border: none;
    cursor: pointer;
    margin-bottom: 3px;
    transition: transform 0.15s, box-shadow 0.15s;
}

.btn-action:hover {
    transform: translateY(-1px);
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.btn-sm {
    padding: 1px 5px;
    font-size: 0.6rem;
}

/* ===== Panels ===== */
asp\:Panel, .dashboard-container div[style*="overflow-x:auto"] {
    margin-bottom: 15px;
}

asp\:Panel {
    border-radius: 6px;
    box-shadow: 0 1px 4px rgba(0,0,0,0.05);
    padding: 10px;
}

/* ===== Form Controls ===== */
.form-control {
    padding: 2px 4px;
    margin-right: 3px;
    margin-bottom: 3px;
    border-radius: 4px;
    border: 1px solid #ced4da;
    font-size: 0.65rem;
    height: 24px;
}

.form-control:focus {
    border-color: #007bff;
    box-shadow: 0 0 3px rgba(0,123,255,0.2);
    outline: none;
}

/* ===== Tables ===== */
.table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.65rem;
    background-color: #fff;
    border-radius: 4px;
    overflow: hidden;
    box-shadow: 0 1px 4px rgba(0,0,0,0.05);
}

.table th, .table td {
    padding: 2px 4px;
    text-align: left;
    border-bottom: 1px solid #dee2e6;
}

.table th {
    background-color: #007bff;
    color: #fff;
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.65rem;
}

.table tbody tr:nth-child(even) {
    background-color: #f8f9fa;
}

.table tbody tr:hover {
    background-color: #e9f5ff;
}

/* Smaller inputs inside GridViews */
.table td input.form-control,
.table td select.form-control {
    font-size: 0.6rem;
    padding: 1px 3px;
    height: 22px;
}

/* ===== Grid Container for Horizontal Scroll ===== */
.grid-container {
    overflow-x: auto;
}

/* ===== Incident Panel ===== */
.incident-alert {
    background-color: #fff3f3;
    border-radius: 4px;
    padding: 8px;
    box-shadow: 0 1px 4px rgba(0,0,0,0.05);
}

.incident-alert h4 {
    color: #dc3545;
    margin-bottom: 5px;
    font-size: 0.85rem;
}

/* ===== Status Labels ===== */
.status-label {
    padding: 2px 5px;
    border-radius: 3px;
    font-size: 0.6rem;
    font-weight: 600;
    display: inline-block;
}

.status-Available { background-color: #28a745; }
.status-Rented { background-color: #ffc107; color: #343a40; }
.status-Maintenance { background-color: #17a2b8; }

/* ===== Responsive Adjustments ===== */
@media (max-width: 1200px) {
    .dashboard-container { padding: 10px; }
    .table, .table th, .table td { font-size: 0.6rem; padding: 1px 3px; }
    .btn-action { font-size: 0.6rem; padding: 1px 4px; }
    .form-control { font-size: 0.6rem; height: 22px; padding: 1px 3px; }
}

@media (max-width: 768px) {
    .form-control, .btn-action {
        width: 100% !important;
        margin-bottom: 3px;
    }
    
    h2, h3, h4 {
        font-size: 0.9rem;
    }
}
</style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:Label ID="lblError" runat="server" ForeColor="Red" Font-Bold="true" EnableViewState="false"></asp:Label>
        <br /><br />
    <div class="dashboard-container">
        <div style="margin-bottom: 20px;">
    <asp:Button ID="btnToggleUserPanel" runat="server" Text="Add New User" OnClick="TogglePanel_Click" CommandArgument="User" CssClass="btn-action" BackColor="#333" ForeColor="White" />
    <asp:Button ID="btnToggleCarPanel" runat="server" Text="Add New Car" OnClick="TogglePanel_Click" CommandArgument="Car" CssClass="btn-action" BackColor="#333" ForeColor="White" />
    <asp:Button ID="btnToggleView" runat="server" Text="View Grids" OnClick="TogglePanel_Click" CommandArgument="View" CssClass="btn-action" BackColor="#6c757d" ForeColor="White" />
</div>
        <h2>Management Dashboard</h2>
        
        <asp:Panel ID="pnlAdminInsert" runat="server" BorderStyle="Solid" BorderWidth="1px" Padding="20px" BackColor="#f0f8ff" Visible="false">
            <h4>+ Add New User</h4>
            
            <div class="form-inline">
                <div style="margin-bottom:10px;">
                    <asp:TextBox ID="txtNewFirst" runat="server" Placeholder="First Name" CssClass="form-control" Width="120"></asp:TextBox>
                    <asp:TextBox ID="txtNewLast" runat="server" Placeholder="Last Name" CssClass="form-control" Width="120"></asp:TextBox>
                    <asp:TextBox ID="txtNewUser" runat="server" Placeholder="Username" CssClass="form-control" Width="120"></asp:TextBox>
                    <asp:TextBox ID="txtNewEmail" runat="server" Placeholder="Email" CssClass="form-control" Width="150"></asp:TextBox>
                    <asp:TextBox ID="txtNewPhone" runat="server" Placeholder="Phone" CssClass="form-control" Width="120"></asp:TextBox>
                </div>

                <div>
                    <label>Gender:</label>
                    <asp:DropDownList ID="ddlNewGender" runat="server" CssClass="form-control" Width="100">
                        <asp:ListItem>Male</asp:ListItem>
                        <asp:ListItem>Female</asp:ListItem>
                        <asp:ListItem>Other</asp:ListItem>
                    </asp:DropDownList>

                    <label>DOB:</label>
                    <asp:TextBox ID="txtNewDOB" runat="server" TextMode="Date" CssClass="form-control" Width="130"></asp:TextBox>

                    <label>Status:</label>
                    <asp:DropDownList ID="ddlNewStatus" runat="server" CssClass="form-control" Width="100">
                        <asp:ListItem>Verified</asp:ListItem>
                        <asp:ListItem>Pending</asp:ListItem>
                        <asp:ListItem>Suspended</asp:ListItem>
                    </asp:DropDownList>

                    <label>Role:</label>
                    <asp:DropDownList ID="ddlNewRole" runat="server" CssClass="form-control" Width="100">
                        <asp:ListItem Value="Customer">Customer</asp:ListItem>
                        <asp:ListItem Value="Staff">Staff</asp:ListItem>
                        <asp:ListItem Value="Admin">Admin</asp:ListItem>
                    </asp:DropDownList>

                    <label>Job:</label>
                    <asp:DropDownList ID="ddlJobTitle" runat="server" CssClass="form-control" Width="130">
                        <asp:ListItem Value="None">-- N/A --</asp:ListItem>
                        <asp:ListItem Value="Maintenance Crew">Maintenance Crew</asp:ListItem>
                        <asp:ListItem Value="Driver">Driver</asp:ListItem>
                        <asp:ListItem Value="Manager">Manager</asp:ListItem>
                    </asp:DropDownList>


                    <asp:Button ID="btnAddUser" runat="server" Text="Create" OnClick="btnAddUser_Click" CssClass="btn-action" BackColor="#28a745" ForeColor="White" Height="30" />
                </div>
            </div>
        </asp:Panel>
        
    <h3 class="section-title">All Users</h3>
<div style="overflow-x:auto;">
    <asp:GridView ID="gvUsers" runat="server" 
        AutoGenerateColumns="False" 
        DataKeyNames="PersonID" 
        CssClass="table table-striped"
        Width="100%"
        OnRowEditing="gvUsers_RowEditing"
        OnRowUpdating="gvUsers_RowUpdating"
        OnRowCancelingEdit="gvUsers_RowCancelingEdit"
        OnRowDeleting="gvUsers_RowDeleting" 
        OnRowDataBound="gvUsers_RowDataBound">
        
        <Columns>
            <asp:BoundField DataField="PersonID" HeaderText="ID" ReadOnly="True" ItemStyle-Width="40px" />
            <asp:BoundField DataField="Username" HeaderText="Username" ReadOnly="True" />
            <asp:BoundField DataField="FirstName" HeaderText="Fname" ReadOnly="True" />
            <asp:BoundField DataField="LastName" HeaderText="Lname" ReadOnly="True" />
            <asp:BoundField DataField="Email" HeaderText="Email" ReadOnly="True" />
            <asp:BoundField DataField="PhoneNo" HeaderText="Phone" ReadOnly="True" />
            <asp:BoundField DataField="Gender" HeaderText="Gender" ReadOnly="True" />
            <asp:BoundField DataField="DateOfBirth" HeaderText="DOB" ReadOnly="True" DataFormatString="{0:d}" />

            <asp:TemplateField HeaderText="Licence">
                <ItemTemplate><%# Eval("LicenseNo") %></ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtlicen" runat="server" Text='<%# Bind("LicenseNo") %>' CssClass="form-control" Width="100"></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="CNIC">
                <ItemTemplate><%# Eval("CNIC") %></ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtCNIC" runat="server" Text='<%# Bind("CNIC") %>' CssClass="form-control" Width="100"></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Account Status">
                <ItemTemplate>
                    <asp:Label ID="lblAccStatus" runat="server" Text='<%# Eval("AccountStatus") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="ddlAccountStatus" runat="server" CssClass="form-control" Width="120"
                        SelectedValue='<%# Bind("AccountStatus") %>'>
                        <asp:ListItem>Verified</asp:ListItem>
                        <asp:ListItem>Pending</asp:ListItem>
                        <asp:ListItem>Suspended</asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="User Role">
                <ItemTemplate>
                    <asp:Label ID="drorole" runat="server" Text='<%# Eval("UserType") %>'></asp:Label>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:DropDownList ID="txtrole" runat="server" CssClass="form-control" Width="120"
                        SelectedValue='<%# Bind("UserType") %>'>
                        <asp:ListItem>Customer</asp:ListItem>
                        <asp:ListItem>Staff</asp:ListItem>
                        <asp:ListItem>Admin</asp:ListItem>
                    </asp:DropDownList>
                </EditItemTemplate>
            </asp:TemplateField>


<asp:TemplateField HeaderText="Job Title">
    <ItemTemplate>
        <%# Eval("StaffRole") == DBNull.Value ? "-" : Eval("StaffRole") %>
    </ItemTemplate>
    <EditItemTemplate>
        <asp:DropDownList ID="ddlJobTitle" runat="server" CssClass="form-control" Width="130">
    <asp:ListItem Value="None">-- N/A --</asp:ListItem>
    <asp:ListItem Value="Maintenance Crew">Maintenance Crew</asp:ListItem>
    <asp:ListItem Value="Driver">Driver</asp:ListItem>
    </asp:DropDownList>
    </EditItemTemplate>
</asp:TemplateField>
            <asp:BoundField DataField="DateCreated" HeaderText="DC" ReadOnly="True" />
            
            <asp:CommandField ShowEditButton="True" ButtonType="Button" ControlStyle-CssClass="btn-action" HeaderText="EDIT" />
            
            <asp:TemplateField HeaderText="Delete">
                <ItemTemplate>
                    <asp:Button ID="btnDelete" runat="server" CommandName="Delete" Text="Delete" 
                        OnClientClick="return confirm('Permanently delete this user?');" 
                        BackColor="#dc3545" ForeColor="White" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</div>
        <h3 class="section-title">Car Fleet Management</h3>
        <asp:Panel ID="pnlAddCar" runat="server" BorderStyle="Solid" BorderWidth="1px" Padding="20px" BackColor="#f8f8f8" Visible="false" style="margin-top:20px;">
    <h4>+ Add New Car to Fleet</h4>
    
    <div class="form-inline">
        <asp:TextBox ID="txtAddBrand" runat="server" Placeholder="Brand" CssClass="form-control" Width="100"></asp:TextBox>
        <asp:TextBox ID="txtAddModel" runat="server" Placeholder="Model" CssClass="form-control" Width="100"></asp:TextBox>
        <asp:TextBox ID="txtAddPlate" runat="server" Placeholder="Plate No" CssClass="form-control" Width="100"></asp:TextBox>
        <asp:TextBox ID="txtAddYear" runat="server" Placeholder="Year" TextMode="Number" CssClass="form-control" Width="70"></asp:TextBox>
        
        
        <asp:DropDownList ID="ddlAddFuel" runat="server" CssClass="form-control" Width="100">
            <asp:ListItem Value="">-- Fuel --</asp:ListItem>
            <asp:ListItem>Petrol</asp:ListItem>
            <asp:ListItem>Diesel</asp:ListItem>
            <asp:ListItem>Electric</asp:ListItem>
        </asp:DropDownList>
        
        <asp:TextBox ID="txtAddTrans" runat="server" Placeholder="Transmission" CssClass="form-control" Width="110"></asp:TextBox>
        <asp:TextBox ID="txtAddSeats" runat="server" Placeholder="Seats" TextMode="Number" CssClass="form-control" Width="70"></asp:TextBox>
        
        <asp:FileUpload ID="fuAddImage" runat="server" CssClass="form-control" />
        <asp:TextBox ID="txtAddRate" runat="server" Placeholder="Daily Rate" CssClass="form-control" Width="80"></asp:TextBox>
        <label>Insured:</label>
        <asp:CheckBox ID="chkAddInsured" runat="server" />
        <asp:DropDownList ID="ddlsltatus" runat="server" CssClass="form-control" Width="100">
    <asp:ListItem Value="">-- status --</asp:ListItem>
    <asp:ListItem>Available</asp:ListItem>
    <asp:ListItem>Rented</asp:ListItem>
    <asp:ListItem>Maintenance</asp:ListItem>
</asp:DropDownList>
        <asp:Button ID="btnAddCarSubmit" runat="server" Text="Save Car" OnClick="btnAddCarSubmit_Click" CssClass="btn-action" BackColor="#17a2b8" ForeColor="White" Height="30" />
    </div>
</asp:Panel>
        <div style="overflow-x:auto;">
            <asp:GridView ID="gvCars" runat="server" 
                AutoGenerateColumns="False" 
                DataKeyNames="CarID"
                Width="100%"
                CssClass="table table-bordered"
                OnRowEditing="gvCars_RowEditing" 
                OnRowUpdating="gvCars_RowUpdating" 
                OnRowCancelingEdit="gvCars_RowCancelingEdit" 
                OnRowDeleting="gvCars_RowDeleting" 
                OnRowDataBound="gvCars_RowDataBound">
                
                <Columns>
                    <asp:BoundField DataField="CarID" HeaderText="ID" ReadOnly="True" />
                                                               <asp:TemplateField HeaderText="Brand">
    <ItemTemplate><%# Eval("Brand") %></ItemTemplate>
    <EditItemTemplate>
        <asp:TextBox ID="txtBrand" runat="server" Text='<%# Bind("Brand") %>' CssClass="form-control" Width="100"></asp:TextBox>
    </EditItemTemplate>
</asp:TemplateField>

                                            <asp:TemplateField HeaderText="Model">
    <ItemTemplate><%# Eval("Model") %></ItemTemplate>
    <EditItemTemplate>
        <asp:TextBox ID="txtModel" runat="server" Text='<%# Bind("Model") %>' CssClass="form-control" Width="100"></asp:TextBox>
    </EditItemTemplate>
</asp:TemplateField>
                    
                        <asp:TemplateField HeaderText="Plate">
    <ItemTemplate><%# Eval("PlateNumber") %></ItemTemplate>
    <EditItemTemplate>
        <asp:TextBox ID="txtPlateNumber" runat="server" Text='<%# Bind("PlateNumber") %>' CssClass="form-control" Width="100"></asp:TextBox>
    </EditItemTemplate>
</asp:TemplateField>
                    
                                                                                   <asp:TemplateField HeaderText="Year">
    <ItemTemplate><%# Eval("Year") %></ItemTemplate>
    <EditItemTemplate>
        <asp:TextBox ID="txtYear" runat="server" Text='<%# Bind("Year") %>' CssClass="form-control" Width="100"></asp:TextBox>
    </EditItemTemplate>
</asp:TemplateField>
           <asp:TemplateField HeaderText="FuelType">                     
                        <ItemTemplate>
        <asp:Label ID="lblFuelType" runat="server" Text='<%# Eval("FuelType") %>'></asp:Label>
    </ItemTemplate>
    <EditItemTemplate>
        <asp:DropDownList ID="ddlFuelType" runat="server">
            <asp:ListItem>Petrol</asp:ListItem>
            <asp:ListItem>Diesel</asp:ListItem>
            <asp:ListItem>Electric</asp:ListItem>
        </asp:DropDownList>
    </EditItemTemplate>
</asp:TemplateField>
                                                               <asp:TemplateField HeaderText="Transmission">
    <ItemTemplate><%# Eval("Transmission") %></ItemTemplate>
    <EditItemTemplate>
        <asp:TextBox ID="txtTransmission" runat="server" Text='<%# Bind("Transmission") %>' CssClass="form-control" Width="100"></asp:TextBox>
    </EditItemTemplate>
</asp:TemplateField>
                                                                                   <asp:TemplateField HeaderText="SeatingCapacity">
    <ItemTemplate><%# Eval("SeatingCapacity") %></ItemTemplate>
    <EditItemTemplate>
        <asp:TextBox ID="txtSeatingCapacity" runat="server" Text='<%# Bind("SeatingCapacity") %>' CssClass="form-control" Width="100"></asp:TextBox>
    </EditItemTemplate>
</asp:TemplateField>
                    
                                                                                  
                    
                    
                                                                             

                    
                                                                                   <asp:TemplateField HeaderText="CarImage">
    <ItemTemplate><%# Eval("CarImage") %></ItemTemplate>
    <EditItemTemplate>
        <asp:TextBox ID="txtCarImage" runat="server" Text='<%# Bind("CarImage") %>' CssClass="form-control" Width="100"></asp:TextBox>
    </EditItemTemplate>
</asp:TemplateField>
                    
                    <asp:TemplateField HeaderText="Insured">
    <ItemTemplate>
        <%# Convert.ToBoolean(Eval("IsInsured")) ? "Yes" : "No" %>
    </ItemTemplate>
    <EditItemTemplate>
        <asp:DropDownList ID="ddlIsInsured" runat="server" CssClass="form-control" Width="70">
            <asp:ListItem Value="True">Yes</asp:ListItem>
            <asp:ListItem Value="False">No</asp:ListItem>
        </asp:DropDownList>
    </EditItemTemplate>
</asp:TemplateField>
                    <asp:TemplateField HeaderText="Rate">
                        <ItemTemplate><%# Eval("DailyRate", "{0:N0}") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtRate" runat="server" Text='<%# Bind("DailyRate") %>' Width="70"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:DropDownList ID="ddlStatus" runat="server">
                                <asp:ListItem>Available</asp:ListItem>
                                <asp:ListItem>Rented</asp:ListItem>
                                <asp:ListItem>Maintenance</asp:ListItem>
                            </asp:DropDownList>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:CommandField ShowEditButton="True" ButtonType="Button" headertext="EDIT"/>
                    
                    <asp:TemplateField headertext="Delete">
                        <ItemTemplate>
                            <asp:Button ID="btnDeleteCar" runat="server" CommandName="Delete" Text="Delete" 
                                OnClientClick="return confirm('Delete Car?');" 
                                BackColor="#dc3545" ForeColor="White" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>


        </div>
        <br /><hr /><br />

<h3 class="section-title">Insurance Policy Management (Admin Only)</h3>

<asp:Panel ID="pnlAddInsurance" runat="server" BorderStyle="Solid" BorderWidth="1px" Padding="20px" BackColor="#e6f0ff" Visible="false" style="margin-bottom:20px;">
    <h4>+ Add New Policy</h4>
    <div class="form-inline">
        <label>Car ID:</label>
       <label>Car ID:</label>
<asp:DropDownList ID="ddlInsCarID" runat="server" CssClass="form-control" Width="120"></asp:DropDownList> <asp:TextBox ID="txtInsProvider" runat="server" CssClass="form-control" Width="120" placeholder="Provider"></asp:TextBox>
        <asp:TextBox ID="txtInsPolicy" runat="server" CssClass="form-control" Width="100" placeholder="Policy No"></asp:TextBox>
        
        <label>Start:</label>
        <asp:TextBox ID="txtInsStart" runat="server" TextMode="Date" CssClass="form-control" Width="120"></asp:TextBox>
        <label>End:</label>
        <asp:TextBox ID="txtInsEnd" runat="server" TextMode="Date" CssClass="form-control" Width="120"></asp:TextBox>
        
        <asp:TextBox ID="txtInsAmount" runat="server" CssClass="form-control" Width="100" placeholder="Amount"></asp:TextBox>
        
        <asp:Button ID="btnAddInsuranceSubmit" runat="server" Text="Save Policy" OnClick="btnAddInsuranceSubmit_Click" BackColor="#007bff" ForeColor="White" CssClass="btn-action" Height="30" />
    </div>
</asp:Panel>


<div style="overflow-x:auto; width:100%;">
    <asp:GridView ID="gvInsurance" runat="server" 
        AutoGenerateColumns="False" 
        DataKeyNames="InsuranceID"
        CssClass="table table-bordered table-sm"
        OnRowEditing="gvInsurance_RowEditing"
        OnRowUpdating="gvInsurance_RowUpdating"
        OnRowCancelingEdit="gvInsurance_RowCancelingEdit"
        OnRowDataBound="gvInsurance_RowDataBound" OnRowDeleting="gvInsurance_RowDeleting">
        <EmptyDataTemplate>
        <p style="text-align: center; color: #6c757d; padding: 15px; border: 1px dashed #ccc;">
            No insurance policies found. Please use the "Add New Policy" panel above.
        </p>
    </EmptyDataTemplate>
        <Columns >
            <asp:BoundField DataField="InsuranceID" HeaderText="Policy ID" ReadOnly="True"  />
            <asp:BoundField DataField="PlateNumber" HeaderText="Plate" ReadOnly="True" />
            <asp:BoundField DataField="Brand" HeaderText="Car" ReadOnly="True" />
            <asp:BoundField DataField="Provider" HeaderText="Provider" />
            <asp:BoundField DataField="PolicyNumber" HeaderText="Policy No" />
            
            <asp:TemplateField HeaderText="Coverage">
                <ItemTemplate><%# Eval("CoverageAmount", "{0:N0}") %></ItemTemplate>
                <EditItemTemplate>
                    <asp:TextBox ID="txtEditAmount" runat="server" Text='<%# Bind("CoverageAmount") %>' Width="80px"></asp:TextBox>
                </EditItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Active">
                <ItemTemplate><%# Convert.ToBoolean(Eval("IsActive")) ? "Yes" : "No" %></ItemTemplate>
                <EditItemTemplate>
                    <asp:CheckBox ID="chkEditActive" runat="server" Checked='<%# Bind("IsActive") %>' />
                </EditItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="StartDate" HeaderText="Start Date" DataFormatString="{0:d}" />
            <asp:BoundField DataField="EndDate" HeaderText="End Date" DataFormatString="{0:d}" />
            
            <asp:CommandField ShowEditButton="True" ButtonType="Button" HeaderText="Edit" ControlStyle-CssClass="btn-action" />
            <asp:TemplateField HeaderText="Delete">
    <ItemTemplate>
        <asp:Button ID="btnDeletePolicy" runat="server" CommandName="Delete" Text="Delete" 
            OnClientClick="return confirm('Permanently delete this policy?');" 
            BackColor="#dc3545" ForeColor="White" />
    </ItemTemplate>
</asp:TemplateField>
        </Columns>
    </asp:GridView>
</div>

    </div>



  <br /><hr /><br />

<h3 class="section-title">Reservation Requests & History</h3>

<div style="overflow-x:auto;">
    <asp:GridView ID="gvReservations" runat="server" 
        AutoGenerateColumns="False" 
        DataKeyNames="ReservationID"
        CssClass="table table-bordered table-hover"
        OnRowCommand="gvReservations_RowCommand"
        OnRowDataBound="gvReservations_RowDataBound"
        Width="100%">
        
        <Columns>
            <asp:BoundField DataField="ReservationID" HeaderText="ID" ReadOnly="True" />
            <asp:BoundField DataField="CustomerName" HeaderText="Customer" ReadOnly="True" />
            <asp:BoundField DataField="CarInfo" HeaderText="Car Details" ReadOnly="True" />
            
            <asp:BoundField DataField="RequestedStart" HeaderText="Pickup" DataFormatString="{0:d}" />
            <asp:BoundField DataField="RequestedEnd" HeaderText="Return" DataFormatString="{0:d}" />
            <asp:BoundField DataField="PickupMethod" HeaderText="Method" />

            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <asp:Label ID="lblResStatus" runat="server" Text='<%# Eval("Status") %>' Font-Bold="true"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:Button ID="btnApprove" runat="server" CommandName="ApproveRes" CommandArgument='<%# Eval("ReservationID") %>' 
                        Text="Approve" CssClass="btn-action" BackColor="#28a745" ForeColor="White" />
                    
                    <asp:Button ID="btnReject" runat="server" CommandName="RejectRes" CommandArgument='<%# Eval("ReservationID") %>' 
                        Text="Reject" CssClass="btn-action" BackColor="#dc3545" ForeColor="White" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:Panel ID="pnlIncident" runat="server" Visible="false" CssClass="incident-alert" BorderColor="Red" BorderStyle="Solid" BorderWidth="1px" style="margin-bottom:20px;">
    <h4 style="color:red;">⚠ Report Incident</h4>
    <asp:HiddenField ID="hfIncidentRentalID" runat="server" />
    <div style="display:flex; gap:10px; flex-wrap:wrap;">
        <asp:TextBox ID="txtIncTitle" runat="server" Placeholder="Issue Title (e.g. Dent)" CssClass="form-control" Width="200"></asp:TextBox>
        <asp:DropDownList ID="ddlIncLevel" runat="server" CssClass="form-control">
            <asp:ListItem>Low</asp:ListItem><asp:ListItem>Moderate</asp:ListItem><asp:ListItem>Severe</asp:ListItem><asp:ListItem>Total Loss</asp:ListItem>
        </asp:DropDownList>
        <asp:TextBox ID="txtIncCost" runat="server" Placeholder="Est. Cost" CssClass="form-control" Width="100"></asp:TextBox>
    </div>
    <br />
    <asp:TextBox ID="txtIncDesc" runat="server" TextMode="MultiLine" Placeholder="Description details..." CssClass="form-control" Width="100%" Rows="2"></asp:TextBox>
    <br /><br />
    <asp:Button ID="btnSaveIncident" runat="server" Text="Submit Report" OnClick="btnSaveIncident_Click" CssClass="btn btn-danger" />
    <asp:Button ID="btnCancelIncident" runat="server" Text="Cancel" OnClick="btnCancelIncident_Click" CssClass="btn btn-secondary" />
</asp:Panel>
    <asp:Label ID="lblMsg" runat="server" EnableViewState="false" Font-Bold="true" ForeColor="Green"></asp:Label>

<div class="dash-section">
    <h3>Active Rentals</h3>
    <div class="grid-container">
        <asp:GridView ID="gvRentals" runat="server" AutoGenerateColumns="False" DataKeyNames="RentalID" CssClass="table table-striped" OnRowCommand="gvRentals_RowCommand">
            <Columns>
                <asp:BoundField DataField="RentalID" HeaderText="ID" />
                <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                <asp:BoundField DataField="PlateNumber" HeaderText="Car" />
                <asp:BoundField DataField="ActualStart" HeaderText="Start Time" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:Button ID="btnIncident" runat="server" CommandName="ReportIncident" CommandArgument='<%# Eval("RentalID") %>' Text="⚠ Incident" CssClass="btn btn-warning btn-sm" />
                        <asp:Button ID="btnReturn" runat="server" CommandName="ReturnCar" CommandArgument='<%# Eval("RentalID") %>' Text="Return Car" CssClass="btn btn-primary btn-sm" OnClientClick="return confirm('Process Return? Car will move to Maintenance.');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>No active rentals found.</EmptyDataTemplate>
        </asp:GridView>
    </div>
</div>

<div class="dash-section">
    <h3>Maintenance Queue</h3>
    <div class="grid-container">
        <asp:GridView ID="gvMaintenance" runat="server" AutoGenerateColumns="False" DataKeyNames="MaintenanceID" CssClass="table table-bordered"
            OnRowEditing="gvMaintenance_RowEditing" OnRowUpdating="gvMaintenance_RowUpdating" OnRowCancelingEdit="gvMaintenance_RowCancelingEdit">
            <Columns>
                <asp:BoundField DataField="MaintenanceID" HeaderText="ID" ReadOnly="true" />
                <asp:BoundField DataField="CarInfo" HeaderText="Car" ReadOnly="true" />
                <asp:TemplateField HeaderText="Type">
                    <ItemTemplate><%# Eval("MaintenanceType") %></ItemTemplate>
                    <EditItemTemplate>
                        <asp:DropDownList ID="ddlMaintType" runat="server"><asp:ListItem>Post-Rental Check</asp:ListItem><asp:ListItem>Repair</asp:ListItem><asp:ListItem>Cleaning</asp:ListItem></asp:DropDownList>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Description">
                    <ItemTemplate><%# Eval("Description") %></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtMaintDesc" runat="server" Text='<%# Bind("Description") %>'></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Cost">
                    <ItemTemplate><%# Eval("Cost", "{0:C}") %></ItemTemplate>
                    <EditItemTemplate><asp:TextBox ID="txtMaintCost" runat="server" Text='<%# Bind("Cost") %>' Width="80"></asp:TextBox></EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate><asp:Button ID="btnEdit" runat="server" CommandName="Edit" Text="Process" CssClass="btn btn-info btn-sm" /></ItemTemplate>
                    <EditItemTemplate>
                        <asp:Button ID="btnUpd" runat="server" CommandName="Update" Text="✅ Reinlist" CssClass="btn btn-success btn-sm" />
                        <asp:Button ID="btnCan" runat="server" CommandName="Cancel" Text="Cancel" CssClass="btn btn-secondary btn-sm" />
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>No cars currently in maintenance.</EmptyDataTemplate>
        </asp:GridView>
    </div>
</div>
    <div class="dash-section">
    <h3>Incident Reports</h3>
    <div class="grid-container">
       <asp:GridView ID="gvIncidentReports" runat="server" 
    AutoGenerateColumns="False" 
    DataKeyNames="IncidentID" 
    CssClass="table table-bordered"
    OnRowEditing="gvIncidentReports_RowEditing"
    OnRowUpdating="gvIncidentReports_RowUpdating"
    OnRowCancelingEdit="gvIncidentReports_RowCancelingEdit">
    
    <Columns>
        <asp:BoundField DataField="IncidentID" HeaderText="ID" ReadOnly="true" />
        <asp:BoundField DataField="RentalID" HeaderText="Rental" ReadOnly="true" />
        <asp:BoundField DataField="CustomerName" HeaderText="Customer" ReadOnly="true" />
        <asp:BoundField DataField="PlateNumber" HeaderText="Car" ReadOnly="true" />
        <asp:BoundField DataField="Title" HeaderText="Issue" ReadOnly="true" />
        <asp:BoundField DataField="DamageLevel" HeaderText="Level" ReadOnly="true" />

        <asp:TemplateField HeaderText="Est. Cost">
            <ItemTemplate><%# Eval("EstimatedCost", "{0:C}") %></ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="txtEditCost" runat="server" Text='<%# Bind("EstimatedCost") %>' Width="100px"></asp:TextBox>
            </EditItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Status">
            <ItemTemplate><%# Eval("Status") %></ItemTemplate>
            <EditItemTemplate>
                <asp:DropDownList ID="ddlEditStatus" runat="server" SelectedValue='<%# Bind("Status") %>'>
                    <asp:ListItem>Under Review</asp:ListItem>
                    <asp:ListItem>Resolved</asp:ListItem>
                </asp:DropDownList>
            </EditItemTemplate>
        </asp:TemplateField>
        
        <asp:BoundField DataField="ReportDate" HeaderText="Date" DataFormatString="{0:d}" ReadOnly="true" />
        
        <asp:CommandField ShowEditButton="True" ButtonType="Button" />
        
    </Columns>
    <EmptyDataTemplate>No incident reports found.</EmptyDataTemplate>
</asp:GridView>
    </div>
</div>
</div>

</asp:Content>