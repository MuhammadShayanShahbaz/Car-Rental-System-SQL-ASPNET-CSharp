<%@ Page Title="Report Damage" Language="C#" MasterPageFile="~/car.Master" AutoEventWireup="true" CodeBehind="DamageReport.aspx.cs" Inherits="nnnnnnn.DamageReport"  MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .report-container {
            max-width: 600px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 1px solid #ddd;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box; /* Ensures padding doesn't affect width */
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background-color: #dc3545;
            color: white;
            border: none;
            font-weight: bold;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .btn-submit:hover {
            background-color: #c82333;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            text-decoration: none;
            color: #555;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
    <div class="report-container">
        <h2 style="text-align:center; color:#dc3545;">Report an Incident</h2>
        <p style="text-align:center; color:#666;">Please provide details about the damage or incident.</p>
        <hr />

        <asp:Label ID="lblRentalInfo" runat="server" Font-Bold="true" ForeColor="#333"></asp:Label>
        <br /><br />

        <div class="form-group">
            <label>Incident Type:</label>
            <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control">
                <asp:ListItem Value="Accident">Accident / Collision</asp:ListItem>
                <asp:ListItem Value="Scratch">Scratch / Dent</asp:ListItem>
                <asp:ListItem Value="Mechanical">Mechanical Failure</asp:ListItem>
                <asp:ListItem Value="Theft">Theft</asp:ListItem>
                <asp:ListItem Value="Other">Other</asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <label>Description of Incident:</label>
            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" placeholder="Please describe what happened..."></asp:TextBox>
        </div>

        <asp:Button ID="btnSubmit" runat="server" Text="Submit Report" OnClick="btnSubmit_Click" CssClass="btn-submit" />
        
        <a href="CustomerDashboard.aspx" class="back-link">Back to Dashboard</a>
    </div>

</asp:Content>