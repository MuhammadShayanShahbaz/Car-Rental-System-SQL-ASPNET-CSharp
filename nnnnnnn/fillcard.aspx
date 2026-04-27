<%@ Page Title="" Language="C#" MasterPageFile="~/car.Master" AutoEventWireup="true" CodeBehind="fillcard.aspx.cs" Inherits="nnnnnnn.fillcard"  MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .confirmation-container {
            text-align: center;
            padding: 60px 20px;
            max-width: 600px;
            margin: 0 auto;
            font-family: Arial, sans-serif;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }

        .confirmation-container .icon {
            font-size: 60px;
            color: #28a745;
            margin-bottom: 20px;
        }

        .confirmation-container h1 {
            color: #333;
            margin-bottom: 15px;
        }

        .confirmation-container h3 {
            margin-bottom: 10px;
        }

        .confirmation-container p {
            font-size: 16px;
            line-height: 1.6;
            color: #555;
            margin-bottom: 20px;
        }

        .confirmation-container .online-status {
            color: #007bff;
        }

        .confirmation-container .cod-status {
            color: #28a745;
        }

        .confirmation-container hr {
            border-color: #eee;
            margin: 20px 0;
        }

        .confirmation-container .btn-dashboard {
            display: inline-block;
            background-color: #003366;
            color: #fff;
            padding: 15px 35px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            transition: background 0.2s ease-in-out;
        }

        .confirmation-container .btn-dashboard:hover {
            background-color: #002244;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="confirmation-container">
        <div class="icon">✓</div>
        <h1>Request Submitted</h1>
        <hr />

        <% 
           string type = Request.QueryString["Status"];
           if (type == "Online") { 
        %>
            <h3 class="online-status">Payment Voucher Generated</h3>
            <p>
                We have sent a <strong>payment voucher</strong> to your account/email. <br />
                Please pay it from there to finalize your booking.
            </p>

        <% } else { %>
            <h3 class="cod-status">Cash on Delivery Confirmed</h3>
            <p>
                Your request has been received. <br />
                Please pay the amount at the counter upon pickup.
            </p>
        <% } %>

        <br /><br />

        <a href="CustomerDashboard.aspx" class="btn-dashboard">Go to My Dashboard</a>
    </div>
</asp:Content>
