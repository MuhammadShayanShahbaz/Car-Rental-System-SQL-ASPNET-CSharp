<%@ Page Title="About Us" Language="C#" MasterPageFile="~/car.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="nnnnnnn.About"  MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* About Us Page Styles */
        .about-hero {
            background: linear-gradient(rgba(0, 50, 100, 0.85), rgba(0, 30, 70, 0.9));
            color: white;
            padding: 100px 20px;
            text-align: center;
        }
        
        .about-hero h1 {
            font-size: 3.5rem;
            margin-bottom: 20px;
        }
        
        .about-hero p {
            font-size: 1.25rem;
            max-width: 800px;
            margin: 0 auto;
            line-height: 1.6;
        }
        
        .about-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 80px 20px;
        }
        
        .section-title {
            text-align: center;
            color: #002060;
            font-size: 2.5rem;
            margin-bottom: 50px;
        }
        
        /* Story Section */
        .story-section {
            display: flex;
            align-items: center;
            gap: 60px;
            margin-bottom: 80px;
        }
        
        .story-content {
            flex: 1;
        }
        
        .story-image {
            flex: 1;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .story-image img {
            width: 100%;
            height: auto;
            display: block;
            transition: transform 0.5s ease;
        }
        
        .story-image:hover img {
            transform: scale(1.05);
        }
        
        /* Mission & Vision */
        .mission-vision {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
            margin-bottom: 80px;
        }
        
        .mission-card, .vision-card {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            text-align: center;
            transition: transform 0.3s ease;
        }
        
        .mission-card:hover, .vision-card:hover {
            transform: translateY(-10px);
        }
        
        .mission-card h3, .vision-card h3 {
            color: #002060;
            font-size: 1.8rem;
            margin-bottom: 20px;
        }
        
        .mission-icon, .vision-icon {
            font-size: 3rem;
            margin-bottom: 20px;
            display: block;
        }
        
        /* Team Section */
        .team-section {
            text-align: center;
            margin-bottom: 80px;
        }
        
        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }
        
        .team-member {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: transform 0.3s ease;
        }
        
        .team-member:hover {
            transform: translateY(-5px);
        }
        
        .member-image {
            height: 250px;
            overflow: hidden;
        }
        
        .member-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .team-member:hover .member-image img {
            transform: scale(1.1);
        }
        
        .member-info {
            padding: 25px;
        }
        
        .member-info h4 {
            color: #002060;
            margin-bottom: 5px;
            font-size: 1.3rem;
        }
        
        .member-role {
            color: #FF6B35;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        /* Values Section */
        .values-section {
            background: #f8f9fa;
            padding: 80px 20px;
            margin-bottom: 80px;
        }
        
        .values-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .value-card {
            text-align: center;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .value-icon {
            font-size: 2.5rem;
            margin-bottom: 20px;
            display: block;
        }
        
        .value-card h4 {
            color: #002060;
            margin-bottom: 15px;
            font-size: 1.3rem;
        }
        
        /* Contact CTA */
        .contact-cta {
            text-align: center;
            padding: 60px 20px;
            background: linear-gradient(135deg, #002060, #0040a0);
            color: white;
            border-radius: 20px;
            margin-bottom: 60px;
        }
        
        .contact-cta h2 {
            font-size: 2.5rem;
            margin-bottom: 20px;
        }
        
        .contact-cta p {
            font-size: 1.2rem;
            max-width: 700px;
            margin: 0 auto 30px;
            line-height: 1.6;
        }
        
        .cta-button {
            display: inline-block;
            background: #FF6B35;
            color: white;
            padding: 15px 40px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            transition: background-color 0.3s ease;
        }
        
        .cta-button:hover {
            background: #E55A2B;
        }
        
        /* Responsive Styles */
        @media (max-width: 992px) {
            .story-section {
                flex-direction: column;
                gap: 40px;
            }
            
            .about-hero h1 {
                font-size: 2.8rem;
            }
        }
        
        @media (max-width: 768px) {
            .about-hero {
                padding: 80px 20px;
            }
            
            .about-hero h1 {
                font-size: 2.3rem;
            }
            
            .about-hero p {
                font-size: 1.1rem;
            }
            
            .section-title {
                font-size: 2rem;
            }
            
            .mission-card, .vision-card {
                padding: 30px 20px;
            }
        }
        
        @media (max-width: 480px) {
            .about-hero h1 {
                font-size: 2rem;
            }
            
            .team-grid {
                grid-template-columns: 1fr;
            }
            
            .values-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="about-hero">
        <div>
            <h1>About Rent A Car</h1>
            <p>Driving excellence in car rentals since 2005. We're committed to providing you with the best vehicles and service for every journey.</p>
        </div>
    </section>

    <!-- Main Content -->
    <div class="about-content">
        <!-- Our Story -->
        <section class="story-section">
            <div class="story-content">
                <h2 class="section-title">Our Story</h2>
                <p>Founded in 2025 with a car dream, EzRentals has grown to become one of the most trusted names in the car rental industry. What started as a small family business has evolved into a nationwide service provider with over 50 locations across the country.</p>
                <p>Our journey began when our founders, Huzaifa farooq and Muhammad Shayan, noticed a gap in the market for reliable, affordable car rentals with exceptional customer service. We believed that renting a car should be a seamless experience, not a stressful one. That vision continues to drive us forward today.</p>
                <p>Over the years, we've expanded our fleet to include everything from economy cars for budget-conscious travelers to luxury vehicles for special occasions. But one thing has never changed: our commitment to treating every customer like family.</p>
            </div>
            <div class="story-image">
                <img src="https://images.unsplash.com/photo-1580273916550-e323be2ae537?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80" alt="Our First Rental Location">
            </div>
        </section>

        <!-- Mission & Vision -->
        <h2 class="section-title">Our Mission & Vision</h2>
        <div class="mission-vision">
            <div class="mission-card">
                <span class="mission-icon">🎯</span>
                <h3>Our Mission</h3>
                <p>To provide reliable, affordable, and convenient car rental solutions that empower our customers to travel with confidence and peace of mind. We strive to exceed expectations through exceptional service, well-maintained vehicles, and transparent pricing.</p>
            </div>
            <div class="vision-card">
                <span class="vision-icon">👁️</span>
                <h3>Our Vision</h3>
                <p>To become the most trusted and preferred car rental service globally, recognized for innovation in mobility solutions and setting new standards in customer satisfaction and environmental responsibility in the transportation industry.</p>
            </div>
        </div>

    

        <!-- Fleet Image -->
        <div class="story-image" style="margin-bottom: 80px;">
            <img src="https://images.unsplash.com/photo-1503376780353-7e6692767b70?ixlib=rb-1.2.1&auto=format&fit=crop&w=1600&q=80" alt="Our Diverse Fleet">
        </div>

        <!-- Contact CTA -->
        <section class="contact-cta">
            <h2>Ready to Hit the Road?</h2>
            <p>Experience the EzRentals difference. Whether you need a car for a day, a week, or longer, we're here to make your journey comfortable and memorable.</p>
            <a href="RentACar.aspx" class="cta-button">Book Your Car Now</a>
        </section>
    </div>
</asp:Content>