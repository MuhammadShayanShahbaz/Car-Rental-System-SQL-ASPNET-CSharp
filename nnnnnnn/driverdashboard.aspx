<%@ Page Title="" Language="C#" MasterPageFile="~/car.Master" AutoEventWireup="true" CodeBehind="driverdashboard.aspx.cs" Inherits="nnnnnnn.driverdashboard"  MaintainScrollPositionOnPostback="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
    /* --- Container --- */
    .driver-container {
        padding: 30px;
        max-width: 1200px;
        margin: 0 auto;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    /* --- Welcome Alert --- */
    .driver-welcome {
        background-color: #d1ecf1;
        border: 1px solid #bee5eb;
        padding: 20px 25px;
        border-radius: 8px;
        margin-bottom: 30px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .driver-welcome:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 12px rgba(0,0,0,0.1);
    }

    .alert-heading {
        font-size: 1.6rem;
        margin-bottom: 10px;
        color: #004085;
        font-weight: 600;
    }

    .driver-welcome p {
        margin: 0;
        color: #0c5460;
        font-size: 1rem;
    }

    /* --- Section Title --- */
    h3 {
        margin-top: 30px;
        margin-bottom: 15px;
        color: #343a40;
        font-size: 1.3rem;
        font-weight: 600;
        border-bottom: 2px solid #007bff;
        display: inline-block;
        padding-bottom: 5px;
    }

    /* --- Grid Table --- */
    .table-driver {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        background-color: #ffffff;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        font-size: 0.95rem;
    }

    .table-driver th, .table-driver td {
        padding: 12px 10px;
        text-align: left;
        border-bottom: 1px solid #dee2e6;
    }

    .table-driver th {
        background-color: #007bff;
        color: white;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.9rem;
    }

    .table-driver tbody tr:nth-child(even) {
        background-color: #f8f9fa;
    }

    .table-driver tbody tr:hover {
        background-color: #e9f5ff;
    }

    /* --- Action Buttons --- */
    .btn-action {
        padding: 6px 14px;
        font-size: 0.85rem;
        border-radius: 6px;
        border: none;
        cursor: pointer;
        font-weight: 600;
        transition: background 0.3s, transform 0.2s;
    }

    .btn-action:hover {
        background-color: #e0a800;
        transform: translateY(-2px);
    }

    /* --- Responsive Table --- */
    @media (max-width: 768px) {
        .driver-container {
            padding: 20px;
        }

        h3 {
            font-size: 1.1rem;
        }

        .table-driver th, .table-driver td {
            padding: 10px 8px;
            font-size: 0.85rem;
        }

        .btn-action {
            padding: 5px 10px;
            font-size: 0.8rem;
        }
    }

    @media (max-width: 480px) {
        .table-driver {
            font-size: 0.8rem;
        }

        .table-driver th, .table-driver td {
            padding: 8px 6px;
        }
    }
</style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
    

    
    <div class="driver-container">
        <div style="background-color: #d1ecf1; border: 1px solid #bee5eb; padding: 20px; border-radius: 5px;">
            <div class="alert-heading">Welcome, Driver!</div>
            <p>Your currently assigned rental tasks are listed below.</p>
        </div>

        <h3 style="margin-top: 30px;">Assigned Rentals (Active)</h3>

        <asp:GridView ID="gvAssignedRentals" runat="server"
            AutoGenerateColumns="False"
            DataKeyNames="RentalID"
            CssClass="table table-driver table-bordered table-striped"
            EmptyDataText="You currently have no active assigned rentals.">
            
            <Columns>
                <asp:BoundField DataField="RentalID" HeaderText="Task ID" ReadOnly="True" />
                <asp:BoundField DataField="CustomerName" HeaderText="Customer" ReadOnly="True" />
                <asp:BoundField DataField="CarDetails" HeaderText="Assigned Vehicle" ReadOnly="True" />
                <asp:BoundField DataField="PlateNumber" HeaderText="Plate No" ReadOnly="True" />
                <asp:BoundField DataField="ActualStart" HeaderText="Start Time" DataFormatString="{0:g}" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
                
                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:Button ID="btnConfirm" runat="server" Text="Confirm Pickup" CssClass="btn-action" BackColor="#ffc107" ForeColor="#343a40" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

</asp:Content>
