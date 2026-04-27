<%@ Page Title="" Language="C#" MasterPageFile="~/car.Master" AutoEventWireup="true" CodeBehind="reservation.aspx.cs" Inherits="nnnnnnn.reservation"  MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Container for reservation form */
        .reservation-container {
            max-width: 650px;
            margin: 20px auto;
            padding: 30px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background: #fff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            font-family: Arial, sans-serif;
        }

        .reservation-container h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #003366;
        }

        .reservation-container h4 {
            margin-top: 25px;
            color: #003366;
            border-bottom: 1px solid #eee;
            padding-bottom: 5px;
        }

        .reservation-container label {
            font-weight: bold;
            margin-top: 10px;
            display: block;
        }

        .reservation-container .form-control {
            width: 100%;
            padding: 10px 12px;
            margin-top: 5px;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }

        .reservation-container .row {
            display: flex;
            gap: 10px;
        }

        .reservation-container .col-6 {
            flex: 1;
        }

        .reservation-container .form-group {
            margin-bottom: 15px;
        }

        .reservation-container .btn {
            padding: 12px 0;
            border-radius: 6px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.2s ease-in-out;
        }

        .reservation-container .btn-success {
            background-color: #003366;
            color: #fff;
            width: 100%;
        }

        .reservation-container .btn-success:hover {
            background-color: #002244;
        }

        .reservation-container .btn-apply {
            background-color: #007bff;
            color: #fff;
            margin-left: 10px;
            padding: 8px 16px;
        }

        .reservation-container .btn-apply:hover {
            background-color: #0056b3;
        }

        .reservation-container hr {
            margin: 15px 0;
            border-color: #eee;
        }

        .reservation-container .payment-panel {
            padding: 15px;
            background-color: #f9f9f9;
            border: 1px solid #eee;
            border-radius: 5px;
            margin-top: 10px;
        }

        .reservation-container .back-link a {
            text-decoration: none;
            color: #333;
        }

        .reservation-container .spacer {
            margin-top: 15px;
        }

        /* Responsive */
        @media (max-width: 600px) {
            .reservation-container .row {
                flex-direction: column;
            }
        }
    </style>

    <script type="text/javascript">
        function togglePayment() {
            const cardPanel = document.getElementById('<%= pnlCardDetails.ClientID %>');
            const rbOnline = document.getElementById('<%= rbOnline.ClientID %>');
            cardPanel.style.display = rbOnline.checked ? 'block' : 'none';
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="reservation-container">
        <h2>Finalize Reservation</h2>

        <h4>Your Details</h4>
        <div class="form-group">
            <label>CNIC:</label>
            <asp:TextBox ID="txtCNIC" runat="server" CssClass="form-control" placeholder="35202-xxxxxxx-x"></asp:TextBox>
        </div>
        <div class="form-group">
            <label>License No:</label>
            <asp:TextBox ID="txtLicense" runat="server" CssClass="form-control" placeholder="Driving License"></asp:TextBox>
        </div>
        <div class="form-group">
            <label>Address:</label>
            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
        </div>

        <h4>Rental Details</h4>
        <div class="form-group">
            <label>Pickup Location:</label>
            <asp:TextBox ID="txtPickup" runat="server" CssClass="form-control" placeholder="Enter Address or Branch"></asp:TextBox>
        </div>
        <div class="row">
            <div class="col-6">
                <label>From:</label>
                <asp:TextBox ID="txtStart" runat="server" TextMode="Date" CssClass="form-control" 
                    AutoPostBack="true" OnTextChanged="CalculateCost_Change"></asp:TextBox>
            </div>
            <div class="col-6">
                <label>To:</label>
                <asp:TextBox ID="txtEnd" runat="server" TextMode="Date" CssClass="form-control" 
                    AutoPostBack="true" OnTextChanged="CalculateCost_Change"></asp:TextBox>
            </div>
        </div>

        <asp:CheckBox ID="chkDriver" runat="server" Text=" Request a Driver" CssClass="spacer" 
            AutoPostBack="true" OnCheckedChanged="CalculateCost_Change" />

        <h4>Payment Method</h4>
        <div class="payment-panel">
            <asp:RadioButton ID="rbCOD" runat="server" GroupName="Payment" Text="Cash on Delivery" Checked="true" onclick="togglePayment()" />
            <br />
            <asp:RadioButton ID="rbOnline" runat="server" GroupName="Payment" Text="Online Payment (Card)" onclick="togglePayment()" />
        </div>

        <h4>Options & Coupon</h4>
        <div class="form-group">
            <label>Accessories (Optional):</label>
            <asp:TextBox ID="txtAccessories" runat="server" CssClass="form-control" placeholder="e.g., GPS, Baby Seat, Carrier (Separate by comma)"></asp:TextBox>
        </div>
        <div class="form-group">
            <label>Coupon Code:</label>
            <asp:TextBox ID="txtCouponCode" runat="server" CssClass="form-control" Width="200px"></asp:TextBox>
            <asp:Button ID="btnApplyCoupon" runat="server" Text="Apply" CssClass="btn-apply" />
        </div>

        <h4 class="spacer">Total Amount: <asp:Label ID="lblTotalAmount" runat="server" Text="PKR X,XXX.00" Font-Bold="true"></asp:Label></h4>

        <asp:Panel ID="pnlCardDetails" runat="server" class="payment-panel" style="display:none;">
            <label>Card Number:</label>
            <asp:TextBox ID="txtCardNo" runat="server" CssClass="form-control" placeholder="0000 0000 0000 0000"></asp:TextBox>

            <div class="row spacer">
                <div class="col-6">
                    <asp:TextBox ID="txtExpiry" runat="server" CssClass="form-control" placeholder="MM/YY"></asp:TextBox>
                </div>
                <div class="col-6">
                    <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" placeholder="CVV"></asp:TextBox>
                </div>
            </div>
        </asp:Panel>

        <asp:Label ID="lblError" runat="server" ForeColor="Red" class="spacer"></asp:Label>

        <asp:Button ID="btnConfirmReservation" runat="server" Text="Confirm Reservation"
            CssClass="btn btn-success spacer" OnClick="btnConfirm_Click" />
    </div>
</asp:Content>
