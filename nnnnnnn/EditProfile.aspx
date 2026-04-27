<%@ Page Title="" Language="C#" MasterPageFile="~/car.Master" AutoEventWireup="true" CodeBehind="EditProfile.aspx.cs" Inherits="nnnnnnn.EditProfile"  MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .profile-card {
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0px 4px 18px rgba(0,0,0,0.12);
            transition: 0.3s ease;
            background: #fff;
            padding: 30px;
        }

        .profile-card:hover {
            box-shadow: 0px 6px 25px rgba(0,0,0,0.18);
        }

        .profile-header {
            background: linear-gradient(135deg, #0052cc, #007bff);
            padding: 20px;
            border-radius: 18px 18px 0 0;
            color: #fff;
            text-align: center;
        }

        .profile-header h3 {
            margin: 0;
            font-weight: 600;
            letter-spacing: 1px;
        }

        .profile-form .row {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .profile-form label {
            font-weight: 600;
            flex: 1;
            margin-bottom: 0;
        }

        .profile-form .form-control {
            flex: 2;
            border-radius: 10px;
            padding: 10px 12px;
            border: 1px solid #cfd8e3;
            transition: 0.3s;
        }

        .profile-form .form-control:focus {
            border-color: #0066ff;
            box-shadow: 0 0 5px rgba(0,102,255,0.3);
        }

        .profile-form .mb-3 {
            margin-bottom: 15px;
        }

        .profile-buttons {
            text-align: center;
            margin-top: 30px;
        }

        .btn-lg {
            padding: 10px 32px;
            border-radius: 10px;
            font-weight: 600;
            margin: 5px;
        }

        .btn-success:hover {
            background-color: #1e9e4a !important;
        }

        .btn-secondary:hover {
            background-color: #4a4f57 !important;
        }

        .btn-warning:hover {
            background-color: #ffb74d !important;
        }

        .btn-primary:hover {
            background-color: #004080 !important;
        }

        @media (max-width: 767px) {
            .profile-form .row {
                flex-direction: column;
            }

            .profile-form label, .profile-form .form-control {
                flex: 1 1 100%;
            }

            .profile-form label {
                margin-bottom: 5px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-5">
        <div class="profile-card">
            <div class="profile-header">
                <h3>Edit Profile</h3>
            </div>
            <div class="profile-form mt-4">
                
                <div class="row">
                    <label for="txtFirstName">First Name</label>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" 
                        ControlToValidate="txtFirstName" ErrorMessage="Required" 
                        CssClass="text-danger" Display="Dynamic" />
                </div>

                <div class="row">
                    <label for="txtLastName">Last Name</label>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvLastName" runat="server" 
                        ControlToValidate="txtLastName" ErrorMessage="Required" 
                        CssClass="text-danger" Display="Dynamic" />
                </div>

                <div class="row">
                    <label for="txtEmail">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                        ControlToValidate="txtEmail" ErrorMessage="Required" 
                        CssClass="text-danger" Display="Dynamic" />
                </div>

                <div class="row">
                    <label for="txtPhone">Phone Number</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
                </div>

                <div class="row">
                    <label for="txtAddress">Address</label>
                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                </div>

                <div class="row">
                    <label for="txtCNIC">CNIC</label>
                    <asp:TextBox ID="txtCNIC" runat="server" CssClass="form-control" placeholder="35202-1234567-1" />
                </div>

                <div class="row">
                    <label for="txtLicense">License Number</label>
                    <asp:TextBox ID="txtLicense" runat="server" CssClass="form-control" />
                </div>

                <div class="profile-buttons">
                    <asp:Button ID="btnSave" runat="server" Text="Save Changes" 
                        CssClass="btn btn-success btn-lg me-2" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                        CssClass="btn btn-secondary btn-lg" OnClick="btnCancel_Click" CausesValidation="false" />
                    <asp:Button ID="btnReturn" runat="server" Text="Return to Dashboard"
                        CssClass="btn btn-primary btn-lg me-2 d-none" OnClick="btnReturn_Click" />
                    <asp:Button ID="btnEditAgain" runat="server" Text="Edit Again"
                        CssClass="btn btn-warning btn-lg d-none" OnClick="btnEditAgain_Click" />
                </div>

                <asp:Label ID="lblMessage" runat="server" CssClass="text-success d-block mt-3 text-center" />

            </div>
        </div>
    </div>
</asp:Content>
