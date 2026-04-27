<%@ Page Title="" Language="C#" MasterPageFile="~/car.Master" AutoEventWireup="true" CodeBehind="CustomerDashboard.aspx.cs" Inherits="nnnnnnn.CustomerDashboard"  MaintainScrollPositionOnPostback="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
       <style>
        /* --- Status Badges --- */
        .status-badge {
            color: white;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            display: inline-block;
            font-weight: 600;
            text-transform: uppercase;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .status-green   { background-color: #28a745; }
        .status-red     { background-color: #dc3545; }
        .status-orange  { background-color: #fd7e14; }
        .status-blue    { background-color: #007bff; }
        .status-grey    { background-color: #6c757d; }

        /* --- Profile Card --- */
        .profile-card {
            background: #ffffff;
            padding: 25px 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            max-width: 500px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .profile-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .profile-card h4 {
            margin-bottom: 15px;
            font-size: 1.3rem;
            color: #333;
        }

        .profile-card p {
            margin: 6px 0;
            font-size: 0.95rem;
            color: #555;
        }

        /* --- Edit Button --- */
        .btn-edit-profile {
            margin-top: 15px;
            padding: 6px 18px;
            font-size: 0.9rem;
            border-radius: 6px;
            transition: background 0.3s, transform 0.2s;
        }

        .btn-edit-profile:hover {
            transform: translateY(-2px);
        }

        /* --- GridView Table --- */
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .table th, .table td {
            padding: 12px 10px;
            text-align: left;
            font-size: 0.95rem;
        }

        .table th {
            background-color: #333;
            color: #fff;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
        }

        .table tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .table tbody tr:hover {
            background-color: #e9f5ff;
        }

        /* --- Responsive table scroll --- */
        .table-container {
            overflow-x: auto;
        }

        /* --- Images in table --- */
        .table img {
            vertical-align: middle;
            margin-right: 10px;
            border-radius: 6px;
        }

        /* --- Action buttons in table --- */
        .action-btn {
            padding: 4px 12px;
            font-size: 0.85rem;
            border-radius: 6px;
            margin-right: 4px;
            border: none;
            cursor: pointer;
            transition: background 0.3s, transform 0.2s;
        }

        .action-btn:hover {
            transform: translateY(-2px);
        }

        .btn-view {
            background-color: #007bff;
            color: white;
        }

        .btn-cancel {
            background-color: #dc3545;
            color: white;
        }

        .btn-complete {
            background-color: #28a745;
            color: white;
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="padding: 20px;">
        <h2>My Dashboard</h2>
        <hr />

        <!-- Profile Card -->
        <div class="profile-card">
            <h4>My Profile</h4>
            <p><strong>Name:</strong> <asp:Label ID="lblName" runat="server"></asp:Label></p>
            <p><strong>Email:</strong> <asp:Label ID="lblEmail" runat="server"></asp:Label></p>
            <asp:Button ID="btnEditProfile" runat="server" Text="Edit Profile" 
                CssClass="btn btn-primary btn-sm btn-edit-profile" 
                OnClick="btnEditProfile_Click" />
        </div>

        <!-- Reservations & Rentals Grid -->
        <h3>My Reservations & Rentals</h3>
        
        <div style="overflow-x:auto;">
            <asp:GridView ID="gvMyReservations" runat="server" 
                AutoGenerateColumns="False" 
                DataKeyNames="ReservationID" 
                CssClass="table table-striped table-bordered"
                Width="100%"
                OnRowCommand="gvMyReservations_RowCommand"
                EmptyDataText="No booking history found.">
                
                <HeaderStyle BackColor="#333" ForeColor="White" Font-Bold="true" />

                <Columns>
                    <asp:BoundField DataField="ReservationID" HeaderText="Ref #" ReadOnly="True" />
                    
                    <asp:TemplateField HeaderText="Car">
                        <ItemTemplate>
                            <img src='<%# Eval("CarImage") %>' width="50" height="30" 
                                 style="vertical-align:middle; margin-right:10px; border-radius:4px;" 
                                 alt="Car Image" />
                            <%# Eval("CarName") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="RequestedStart" HeaderText="From" DataFormatString="{0:dd-MMM-yyyy}" />
                    <asp:BoundField DataField="RequestedEnd" HeaderText="To" DataFormatString="{0:dd-MMM-yyyy}" />
                    
                    <asp:TemplateField HeaderText="Cost">
                        <ItemTemplate>
                            <strong>PKR <%# Eval("EstimatedCost", "{0:N0}") %></strong>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Penalty">
                        <ItemTemplate>
                            <%# IsPenaltyActive(Eval("PenaltyAmount")) ? 
                                "<span style='color:red; font-weight:bold;'>PKR " + 
                                Convert.ToDecimal(Eval("PenaltyAmount")).ToString("N0") + "</span>" : 
                                "<span style='color:green;'>-</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# GetStatusClass(Eval("ReservationStatus")) %>'>
                                <%# Eval("ReservationStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
    <ItemTemplate>
        
        <asp:Panel ID="pnlActiveActions" runat="server" 
            Visible='<%# Eval("RentalID") != DBNull.Value && Eval("ActualEnd") == DBNull.Value %>'>
            
            <asp:Button ID="btnReturn" runat="server" Text="Return" 
                CommandName="ReturnCar" 
                CommandArgument='<%# Eval("RentalID") %>' 
                CssClass="action-btn btn-complete"
                CausesValidation="false" 
                OnClientClick="return confirm('Are you sure you want to return this car?');" />

            <asp:Button ID="btnIncident" runat="server" Text="Report" 
                CommandName="RedirectToReport" 
                CommandArgument='<%# Eval("RentalID") %>' 
                CssClass="action-btn btn-cancel"
                CausesValidation="false" />
        </asp:Panel>

        <asp:Label ID="lblReturned" runat="server" Text="Completed" ForeColor="Green" Font-Bold="true"
            Visible='<%# Eval("ActualEnd") != DBNull.Value %>' />

        <asp:Label ID="lblPending" runat="server" Text="Wait for Approval" ForeColor="Orange"
            Visible='<%# Eval("ReservationStatus").ToString() == "Pending" %>' />

    </ItemTemplate>
</asp:TemplateField>

                </Columns>

            </asp:GridView>
        </div>
    </div>
</asp:Content>