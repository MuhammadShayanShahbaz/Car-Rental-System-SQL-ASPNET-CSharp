<%@ Page Title="" Language="C#" MasterPageFile="~/car.Master" AutoEventWireup="true" CodeBehind="cardetails.aspx.cs" Inherits="nnnnnnn.cardetails"  MaintainScrollPositionOnPostback="true" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* CSS Reset for consistency */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #333;
        }
        
        /* Main container with card-like design */
        .car-details-container {
            
            background: white;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            padding: 30px;
        }
        
        /* Image section */
        .car-image {
            flex: 1;
            min-width: 300px;
        }
        .car-image img {
            width: 100%;
            height: auto;
            border-radius: 10px;
            transition: transform 0.3s ease;
        }
        .car-image img:hover {
            transform: scale(1.05);
        }
        
        /* Details section */
        .car-info {
            flex: 1;
            min-width: 300px;
        }
        .car-info h2 {
            font-size: 2.5em;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .car-info h4 {
            color: #7f8c8d;
            font-weight: normal;
            margin-bottom: 15px;
        }
        .car-info h3 {
            color: #27ae60;
            font-size: 2em;
            margin-bottom: 20px;
        }
        .car-info hr {
            border: none;
            height: 2px;
            background: linear-gradient(to right, #3498db, #2980b9);
            margin: 20px 0;
        }
        .car-info p {
            font-size: 1.1em;
            line-height: 1.6;
            margin-bottom: 15px;
        }
        .car-info strong {
            color: #34495e;
        }
        .car-info .description {
            background: #ecf0f1;
            padding: 15px;
            border-radius: 8px;
            border-left: 5px solid #3498db;
        }
        
        /* Button styling */
        .rent-button {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            padding: 15px 30px;
            font-size: 1.2em;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }
        .rent-button:hover {
            background: linear-gradient(135deg, #2980b9, #21618c);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(52, 152, 219, 0.4);
        }
        
        /* Responsive design */
        @media (max-width: 768px) {
            .car-details-container {
                flex-direction: column;
                padding: 20px;
            }
            .car-info h2 {
                font-size: 2em;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="car-details-container">
        <div class="car-image">
            <asp:Image ID="imgCar" runat="server" Width="100%" />
        </div>

        <div class="car-info">
            <h2 id="hBrandModel" runat="server"></h2>
            <h4 id="hYear" runat="server"></h4>
            <h3 id="hPrice" runat="server"></h3>
            
            <hr />
            <p><strong>Transmission:</strong> <asp:Label ID="lblTrans" runat="server"></asp:Label></p>
            <p><strong>Fuel Type:</strong> <asp:Label ID="lblFuel" runat="server"></asp:Label></p>
            <p><strong>Seating:</strong> <asp:Label ID="lblSeats" runat="server"></asp:Label></p>
            <p class="description"><strong>Description:</strong> <br />
               This <asp:Label ID="lblDescBrand" runat="server"></asp:Label> offers a premium driving experience 
               with top-tier maintenance and full insurance coverage.
            </p>

            <asp:Button ID="btnRent" runat="server" Text="Rent This Car" 
                OnClick="btnRent_Click" CssClass="rent-button" />
        </div>
    </div>
</asp:Content>