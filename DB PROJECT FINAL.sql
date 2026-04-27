-- ========================================================
-- 1. DATABASE CREATION
-- ========================================================

CREATE DATABASE dbnb;
GO

USE dbnb;
GO

-- ========================================================
-- 2. TABLE CREATION (SCHEMA)
-- ========================================================

-- A. Core Person Table
CREATE TABLE Person (
    PersonID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Gender NVARCHAR(10) CHECK (Gender IN ('Male','Female','Other')),
    DateOfBirth DATE NOT NULL,
    CNIC VARCHAR(50) NOT NULL DEFAULT 'Add now',
    LicenseNo VARCHAR(50) NOT NULL DEFAULT 'Add now',
    Email NVARCHAR(200) NOT NULL UNIQUE,
    PhoneNo NVARCHAR(30) NULL,
    Address NVARCHAR(500) NULL,
    Username NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(256) NOT NULL, 
    AccountStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending', 
    DateCreated DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- B. Roles: Customer
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY, 
    FOREIGN KEY (CustomerID) REFERENCES Person(PersonID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- C. Roles: Employee
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    StaffRole NVARCHAR(50) NOT NULL CHECK (StaffRole IN ('Maintenance Crew','Driver','Manager')),
    Salary DECIMAL(18,2) NULL,
    HireDate DATE NULL,
    Branch NVARCHAR(200) NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Person(PersonID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- D. Roles: Admin Override
CREATE TABLE AdminOverride (
    AdminID INT PRIMARY KEY,
    AdminLevel NVARCHAR(50) NOT NULL,
    Permissions NVARCHAR(500) NULL,
    FOREIGN KEY (AdminID) REFERENCES Employee(EmployeeID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- E. Car Types & Cars
CREATE TABLE CarType (
    CarTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) -- e.g., Sedan, SUV, Luxury
);
GO

CREATE TABLE Car (
    CarID INT IDENTITY(1,1) PRIMARY KEY,
    PlateNumber NVARCHAR(50) UNIQUE,
    Brand NVARCHAR(100),
    Model NVARCHAR(100),
    Year INT,
    FuelType NVARCHAR(50),
    Transmission NVARCHAR(50),
    SeatingCapacity INT,
    DailyRate DECIMAL(18,2),
    Status NVARCHAR(50) DEFAULT 'Available', -- Available, Rented, Maintenance
    CarTypeID INT NULL,
    IsInsured BIT DEFAULT 0,
    CarImage NVARCHAR(500) DEFAULT 'default_car.jpg',
    FOREIGN KEY (CarTypeID) REFERENCES CarType(CarTypeID)
);
GO

-- F. Insurance
CREATE TABLE Insurance (
    InsuranceID INT IDENTITY(1,1) PRIMARY KEY,
    CarID INT,
    Provider NVARCHAR(200),
    PolicyNumber NVARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    CoverageType NVARCHAR(100),
    CoverageAmount DECIMAL(18,2),
    IsActive BIT,
    FOREIGN KEY (CarID) REFERENCES Car(CarID) ON DELETE CASCADE
);
GO

-- G. Reservation
CREATE TABLE Reservation (
    ReservationID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    CarID INT,
    DriverID INT NULL, -- Assigned Driver
    RequestedStart DATETIME,
    RequestedEnd DATETIME,
    PickupMethod NVARCHAR(50),
    DriverRequired BIT DEFAULT 0,
    Accessories NVARCHAR(1000) NULL,
    CouponCode NVARCHAR(100) NULL,
    Status NVARCHAR(50) DEFAULT 'Pending',
    
    -- Payment info for Reservation
    PaymentMethod NVARCHAR(50) NULL,
    PaymentStatus NVARCHAR(50) NULL,
    TransactionRef NVARCHAR(100) NULL,
    
    DateCreated DATETIME DEFAULT GETDATE(),
    
    FOREIGN KEY (CustomerID) REFERENCES Person(PersonID),
    FOREIGN KEY (CarID) REFERENCES Car(CarID),
    FOREIGN KEY (DriverID) REFERENCES Employee(EmployeeID)
);
GO

-- H. Rental (Active Contracts)
CREATE TABLE Rental (
    RentalID INT IDENTITY(1,1) PRIMARY KEY,
    ReservationID INT NULL,
    CustomerID INT,
    CarID INT,
    DriverID INT NULL,
    
    ActualStart DATETIME NULL,
    ActualEnd DATETIME NULL,
    TotalAmount DECIMAL(18,2) NULL,
    Status NVARCHAR(50) DEFAULT 'Active',
    
    DamageReport NVARCHAR(500) NULL,
    PenaltyAmount DECIMAL(18,2) NULL,

    FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID),
    FOREIGN KEY (CustomerID) REFERENCES Person(PersonID),
    FOREIGN KEY (CarID) REFERENCES Car(CarID),
    FOREIGN KEY (DriverID) REFERENCES Employee(EmployeeID)
);
GO

-- I. Payments
CREATE TABLE Payment (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    RentalID INT NOT NULL, -- Links to ReservationID initially, logical link to Rental
    Amount DECIMAL(18, 2),
    PaymentMethod NVARCHAR(50),
    TransactionDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) DEFAULT 'Paid',
    TransactionRef NVARCHAR(200) NULL,
    FOREIGN KEY (RentalID) REFERENCES Reservation(ReservationID)
);
GO

-- J. Maintenance & Incidents
CREATE TABLE Maintenance (
    MaintenanceID INT IDENTITY(1,1) PRIMARY KEY,
    CarID INT NOT NULL,
    EmployeeID INT NULL,
    MaintenanceDate DATETIME DEFAULT GETDATE(),
    MaintenanceType NVARCHAR(200),
    Cost DECIMAL(18,2) DEFAULT 0,
    Description NVARCHAR(MAX),
    Status NVARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (CarID) REFERENCES Car(CarID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE SET NULL
);
GO

CREATE TABLE IncidentReport (
    IncidentID INT IDENTITY(1,1) PRIMARY KEY,
    RentalID INT NOT NULL,
    Title NVARCHAR(100),
    Description NVARCHAR(MAX),
    DamageLevel NVARCHAR(50),
    EstimatedCost DECIMAL(18, 2),
    ReportDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) DEFAULT 'Under Review',
    FOREIGN KEY (RentalID) REFERENCES Rental(RentalID)
);
GO

-- K. Coupons
CREATE TABLE OFFER_DETAILS (
    Promo_Code VARCHAR(15) PRIMARY KEY,
    Description VARCHAR(50),
    Promo_Type VARCHAR(20) NOT NULL, -- 'Percentage' or 'Fixed'
    Is_One_Time CHAR(1) NOT NULL,    -- 'Y' or 'N'
    Percentage DECIMAL(5,2) NULL,
    Discounted_Amount DECIMAL(8,2) NULL,
    Status VARCHAR(10) NOT NULL      -- 'Active', 'Used'
);
GO

-- L. Tracking Device
CREATE TABLE TrackingDevice (
    TrackerID INT IDENTITY(1,1) PRIMARY KEY,
    CarID INT,
    IMEINumber NVARCHAR(100),
    Provider NVARCHAR(200),
    InstalledDate DATETIME,
    ActiveStatus NVARCHAR(50),
    FOREIGN KEY (CarID) REFERENCES Car(CarID)
);
GO

-- ========================================================
-- 3. FUNCTIONS
-- ========================================================

-- Change the hard path to a relative web path
UPDATE Car 
SET CarImage = '~/Carimages/download.jpeg' 
WHERE CarImage LIKE 'C:%';


-- Penalty Calculator
CREATE FUNCTION fn_CalculatePenalty (@RentalID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @PenaltyRate DECIMAL(18,2) = 1000.00;
    DECLARE @DaysOverdue INT = 0;
    
    SELECT @DaysOverdue = DATEDIFF(day, r.RequestedEnd, GETDATE())
    FROM Rental rent 
    JOIN Reservation r ON rent.ReservationID = r.ReservationID
    WHERE rent.RentalID = @RentalID
      AND rent.ActualEnd IS NULL 
      AND r.RequestedEnd < GETDATE(); 

    IF @DaysOverdue < 0 SET @DaysOverdue = 0;
    
    RETURN @DaysOverdue * @PenaltyRate;
END
GO

-- ========================================================
-- 4. STORED PROCEDURES
-- ========================================================

-- SP: Login Logic
CREATE PROCEDURE sp_UserLogin
    @Username NVARCHAR(100),
    @Password NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PersonID INT;
    DECLARE @Role NVARCHAR(20);
    DECLARE @StaffRole NVARCHAR(50) = NULL;
    DECLARE @FullName NVARCHAR(200);

    SELECT @PersonID = p.PersonID, 
           @FullName = p.FirstName + ' ' + p.LastName,
           @StaffRole = e.StaffRole
    FROM Person p
    LEFT JOIN Employee e ON p.PersonID = e.EmployeeID 
    WHERE p.Username = @Username AND p.Password = @Password; 

    IF @PersonID IS NOT NULL
    BEGIN
        IF EXISTS (SELECT 1 FROM AdminOverride WHERE AdminID = @PersonID)
            SET @Role = 'Admin';
        ELSE IF EXISTS (SELECT 1 FROM Employee WHERE EmployeeID = @PersonID)
            SET @Role = 'Staff';
        ELSE IF EXISTS (SELECT 1 FROM Customer WHERE CustomerID = @PersonID)
            SET @Role = 'Customer';
        ELSE
            SET @Role = 'None'; 

        SELECT @PersonID AS ID, @Role AS UserRole, @StaffRole AS StaffRole, @FullName AS Name; 
    END
    ELSE
    BEGIN
        SELECT -1 AS ID, 'Invalid' AS UserRole, NULL AS StaffRole, NULL AS Name;
    END
END
GO

-- SP: Register Customer (Public)
CREATE PROCEDURE sp_RegisterCustomer
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Username NVARCHAR(100),
    @Password NVARCHAR(256),
    @Email NVARCHAR(200),
    @PhoneNo NVARCHAR(30),
    @Gender NVARCHAR(10),
    @DateOfBirth DATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NewID INT;

    INSERT INTO Person (FirstName, LastName, Username, Password, Email, PhoneNo, Gender, DateOfBirth, AccountStatus)
    VALUES (@FirstName, @LastName, @Username, @Password, @Email, @PhoneNo, @Gender, @DateOfBirth, 'Verified');

    SET @NewID = SCOPE_IDENTITY();
    INSERT INTO Customer (CustomerID) VALUES (@NewID);
END
GO

-- SP: Add User Smart (Admin)
CREATE PROCEDURE sp_AddUserSmart
    @F NVARCHAR(100), @L NVARCHAR(100), @U NVARCHAR(100),
    @Password NVARCHAR(256), -- Added Parameter
    @Email NVARCHAR(200), @Phone NVARCHAR(30), 
    @Role NVARCHAR(20), @gender NVARCHAR(10),
    @Dob DATE, @Accst NVARCHAR(50), 
    @main nvarchar(30)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NewID INT;

    INSERT INTO Person (FirstName, LastName, Username, Password, Email, PhoneNo, Gender, DateOfBirth, AccountStatus)
    VALUES (@F, @L, @U, @Password, @Email, @Phone, @gender, @Dob, @Accst);

    SET @NewID = SCOPE_IDENTITY();

    IF @Role = 'Customer'
    BEGIN
        INSERT INTO Customer (CustomerID) VALUES (@NewID);
    END
    ELSE IF @Role = 'Staff'
    BEGIN
        INSERT INTO Employee (EmployeeID, StaffRole, Salary, HireDate, Branch)
        VALUES (@NewID, @main, 30000, GETDATE(), 'Head Office');
    END
    ELSE IF @Role = 'Admin'
    BEGIN
        INSERT INTO Employee (EmployeeID, StaffRole, Salary, HireDate, Branch)
        VALUES (@NewID, @main, 50000, GETDATE(), 'Head Office');
        
        INSERT INTO AdminOverride (AdminID, AdminLevel, Permissions)
        VALUES (@NewID, 'SuperAdmin', 'All');
    END
END
GO

-- SP: Get Profile
CREATE PROCEDURE sp_GetProfile
    @PersonID INT
AS
BEGIN
    SELECT FirstName, LastName, Username, Email, 
           PhoneNo, Address, CNIC, LicenseNo
    FROM Person
    WHERE PersonID = @PersonID;
END
GO

-- SP: Update Person Profile (Customer Self-Edit)
CREATE PROCEDURE sp_UpdatePersonProfile
    @PersonID INT,
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Email NVARCHAR(200),
    @PhoneNo NVARCHAR(30),
    @Address NVARCHAR(500),
    @Gender NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Person
    SET FirstName = @FirstName,
        LastName = @LastName,
        Email = @Email,
        PhoneNo = @PhoneNo,
        Address = @Address,
        Gender = @Gender
    WHERE PersonID = @PersonID;
END
GO

-- SP: Update User Smart (Admin Edit)
CREATE PROCEDURE sp_UpdateUserSmart
    @ID INT,
    @CNIC VARCHAR(50),
    @License VARCHAR(50),
    @Status NVARCHAR(50),
    @NewRole NVARCHAR(50),
    @NewStaffRole NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Person SET CNIC = @CNIC, LicenseNo = @License, AccountStatus = @Status 
    WHERE PersonID = @ID;

    -- Detach dependencies before deletion
    UPDATE Maintenance SET EmployeeID = NULL WHERE EmployeeID = @ID;
    UPDATE Rental SET DriverID = NULL WHERE DriverID = @ID;
    UPDATE Reservation SET DriverID = NULL WHERE DriverID = @ID;

    DELETE FROM Customer WHERE CustomerID = @ID;
    DELETE FROM AdminOverride WHERE AdminID = @ID;
    DELETE FROM Employee WHERE EmployeeID = @ID; 

    IF @NewRole = 'Customer'
    BEGIN
        INSERT INTO Customer (CustomerID) VALUES (@ID);
    END
    ELSE IF @NewRole = 'Staff'
    BEGIN
        INSERT INTO Employee (EmployeeID, StaffRole, Salary, HireDate, Branch)
        VALUES (@ID, ISNULL(@NewStaffRole, 'Maintenance Crew'), 30000, GETDATE(), 'Head Office');
    END
    ELSE IF @NewRole = 'Admin'
    BEGIN
        INSERT INTO Employee (EmployeeID, StaffRole, Salary, HireDate, Branch)
        VALUES (@ID, ISNULL(@NewStaffRole, 'Maintenance Crew'), 50000, GETDATE(), 'Head Office');
        
        INSERT INTO AdminOverride (AdminID, AdminLevel, Permissions)
        VALUES (@ID, 'SuperAdmin', 'All');
    END
END
GO

-- SP: Get Dashboard Users
CREATE PROCEDURE sp_GetDashboardUsers
    @RequestorRole NVARCHAR(50)
AS
BEGIN
    SELECT 
        p.PersonID, p.FirstName, p.LastName, p.DateOfBirth, 
        p.Username, p.Email, p.Gender, p.PhoneNo, p.CNIC, 
        p.LicenseNo, p.AccountStatus, p.DateCreated, 
        e.StaffRole, 
        CASE 
            WHEN a.AdminID IS NOT NULL THEN 'Admin'
            WHEN e.EmployeeID IS NOT NULL THEN 'Staff'
            ELSE 'Customer' 
        END AS UserType
    FROM Person p
    LEFT JOIN Employee e ON p.PersonID = e.EmployeeID
    LEFT JOIN AdminOverride a ON p.PersonID = a.AdminID
    WHERE 
        (@RequestorRole = 'Admin') 
        OR 
        (@RequestorRole = 'Staff' AND a.AdminID IS NULL) 
END
GO

-- SP: Get Available Cars
CREATE PROCEDURE sp_GetAvailableCars
AS
BEGIN
    SELECT CarID, Brand, Model, Year, DailyRate, Transmission, CarImage 
    FROM Car 
    WHERE Status = 'Available'
END
GO

-- SP: Get Car Daily Rate
CREATE PROCEDURE sp_GetCarDailyRate
    @CarID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT DailyRate FROM Car WHERE CarID = @CarID;
END
GO

-- SP: Get Car By ID
CREATE PROCEDURE sp_GetCarByID
    @CarID INT
AS
BEGIN
    SELECT * FROM Car WHERE CarID = @CarID
END
GO

-- SP: Manage Cars (Get)
CREATE PROCEDURE sp_ManageCars_Get
AS
BEGIN
    SELECT * FROM Car
END
GO

-- SP: Add Car
CREATE PROCEDURE sp_AddCar
    @PlateNumber NVARCHAR(50),
    @Brand NVARCHAR(100),
    @Model NVARCHAR(100),
    @Year INT,
    @FuelType NVARCHAR(50),
    @Transmission NVARCHAR(50),
    @SeatingCapacity INT,
    @DailyRate DECIMAL(18,2),
    @IsInsured BIT,
    @CarImage NVARCHAR(500),
    @Status NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NewCarID INT;

    INSERT INTO Car (PlateNumber, Brand, Model, Year, FuelType, Transmission, SeatingCapacity, DailyRate, Status, CarTypeID, IsInsured, CarImage)
    VALUES (@PlateNumber, @Brand, @Model, @Year, @FuelType, @Transmission, @SeatingCapacity, @DailyRate, @Status, 1, @IsInsured, @CarImage);

    SET @NewCarID = SCOPE_IDENTITY();

    IF @IsInsured = 1
    BEGIN
        INSERT INTO Insurance (CarID, Provider, PolicyNumber, StartDate, EndDate, CoverageAmount, CoverageType, IsActive)
        VALUES (@NewCarID, 'Default Rental Co.', @PlateNumber + '-POL', GETDATE(), DATEADD(year, 1, GETDATE()), @DailyRate * 365, 'Comprehensive', 1);
    END
END
GO

-- SP: Update Car
CREATE PROCEDURE sp_ManageCars_Update
    @CarID INT,
    @DailyRate DECIMAL(18,2),
    @Status NVARCHAR(50),
    @ft NVARCHAR(50), @pl NVARCHAR(50), @mod NVARCHAR(100), 
    @br NVARCHAR(100), @tr NVARCHAR(50), @sc INT, 
    @yy INT, @ins BIT, @cari NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Car 
    SET DailyRate = @DailyRate, Status = @Status, FuelType = @ft,
        PlateNumber = @pl, Model = @mod, Brand = @br,
        Transmission = @tr, SeatingCapacity = @sc, Year = @yy,
        IsInsured = @ins, CarImage = @cari
    WHERE CarID = @CarID;

    -- Auto-insert insurance if missing and flag is set
    IF @ins = 1 AND NOT EXISTS (SELECT 1 FROM Insurance WHERE CarID = @CarID)
    BEGIN
        DECLARE @CarPlate NVARCHAR(50);
        SELECT @CarPlate = PlateNumber FROM Car WHERE CarID = @CarID;
        INSERT INTO Insurance (CarID, Provider, PolicyNumber, StartDate, EndDate, CoverageAmount, CoverageType, IsActive)
        VALUES (@CarID, 'Auto-Generated Policy', @CarPlate + '-POLICY', GETDATE(), DATEADD(year, 1, GETDATE()), @DailyRate * 365, 'Comprehensive', 1);
    END
END
GO

-- SP: Find Available Driver
CREATE PROCEDURE sp_FindAvailableDriver
AS
BEGIN
    SELECT TOP 1 e.EmployeeID
    FROM Employee e
    WHERE e.StaffRole = 'Driver'
    AND e.EmployeeID NOT IN (
        SELECT r.DriverID FROM Rental r WHERE r.Status = 'Active' AND r.DriverID IS NOT NULL
        UNION 
        SELECT res.DriverID FROM Reservation res WHERE res.Status = 'Approved' AND res.DriverID IS NOT NULL
    );
END
GO

-- SP: Book Reservation
CREATE PROCEDURE sp_BookReservation
    @CustomerID INT,
    @CarID INT,
    @Start DATETIME,
    @End DATETIME,
    @Pickup NVARCHAR(100),
    @Driver BIT,
    @CNIC NVARCHAR(50),
    @License NVARCHAR(50),
    @Address NVARCHAR(500),
    @PayMethod NVARCHAR(50),
    @PayStatus NVARCHAR(50),
    @TransRef NVARCHAR(100),
    @Accessories NVARCHAR(1000) = NULL,
    @CouponCode NVARCHAR(100) = NULL,
    @DriverID INT = NULL,
    @Amount DECIMAL(18,2),
    @ReservationID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Person 
    SET CNIC = @CNIC, LicenseNo = @License, Address = @Address
    WHERE PersonID = @CustomerID;

    INSERT INTO Reservation (
        CustomerID, CarID, RequestedStart, RequestedEnd, PickupMethod, 
        DriverRequired, Accessories, CouponCode, Status, 
        PaymentMethod, PaymentStatus, TransactionRef, DriverID
    )
    VALUES (
        @CustomerID, @CarID, @Start, @End, @Pickup, 
        @Driver, @Accessories, @CouponCode, 'Pending', 
        @PayMethod, @PayStatus, @TransRef, @DriverID
    );

    SET @ReservationID = SCOPE_IDENTITY();

    -- Create Payment Record (50% Deposit)
    INSERT INTO Payment (RentalID, Amount, PaymentMethod, TransactionDate, Status)
    VALUES (@ReservationID, @Amount, @PayMethod, GETDATE(), @PayStatus); 
END
GO

-- SP: Get My Reservations
CREATE PROCEDURE sp_GetMyReservations
    @CustomerID INT
AS
BEGIN
    SELECT 
        r.ReservationID, r.RequestedStart, r.RequestedEnd,
        r.Status AS ReservationStatus, r.PaymentMethod, r.PaymentStatus,
        r.PickupMethod, r.DriverRequired,
        c.Brand + ' ' + c.Model AS CarName, c.CarImage, c.DailyRate,
        rent.RentalID, rent.ActualStart, rent.ActualEnd, rent.DamageReport,
        p_driver.FirstName + ' ' + p_driver.LastName AS AssignedDriverName,
        ISNULL(dbo.fn_CalculatePenalty(rent.RentalID), 0.00) AS PenaltyAmount,
        DATEDIFF(day, r.RequestedStart, r.RequestedEnd) * c.DailyRate AS EstimatedCost
    FROM Reservation r
    JOIN Car c ON r.CarID = c.CarID
    LEFT JOIN Rental rent ON r.ReservationID = rent.ReservationID
    LEFT JOIN Employee e_driver ON r.DriverID = e_driver.EmployeeID
    LEFT JOIN Person p_driver ON e_driver.EmployeeID = p_driver.PersonID
    WHERE r.CustomerID = @CustomerID
    ORDER BY r.DateCreated DESC;
END
GO

-- SP: Get All Reservations (Admin)
CREATE PROCEDURE sp_GetAllReservations
AS
BEGIN
    SELECT 
        r.ReservationID,
        p.FirstName + ' ' + p.LastName AS CustomerName,
        c.Brand + ' ' + c.Model + ' (' + c.PlateNumber + ')' AS CarInfo,
        r.RequestedStart, r.RequestedEnd, r.PickupMethod, r.Status, r.DateCreated
    FROM Reservation r
    JOIN Person p ON r.CustomerID = p.PersonID
    JOIN Car c ON r.CarID = c.CarID
    ORDER BY r.DateCreated DESC;
END
GO

-- SP: Update Reservation Status
CREATE PROCEDURE sp_UpdateReservationStatus
    @ReservationID INT,
    @Status NVARCHAR(50) 
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CarID INT, @CustomerID INT, @ActualStart DATETIME = GETDATE();

    SELECT @CarID = CarID, @CustomerID = CustomerID 
    FROM Reservation WHERE ReservationID = @ReservationID;

    UPDATE Reservation SET Status = @Status WHERE ReservationID = @ReservationID;

    IF @Status = 'Approved'
    BEGIN
        UPDATE Car SET Status = 'Rented' WHERE CarID = @CarID;
        
        INSERT INTO Rental (ReservationID, CustomerID, CarID, ActualStart, Status, DamageReport, PenaltyAmount, DriverID)
        VALUES (@ReservationID, @CustomerID, @CarID, @ActualStart, 'Active', NULL, 0, 
            (SELECT DriverID FROM Reservation WHERE ReservationID = @ReservationID));
            
        UPDATE OFFER_DETAILS SET Status = 'Used'
        WHERE Promo_Code = (SELECT CouponCode FROM Reservation WHERE ReservationID = @ReservationID)
          AND Is_One_Time = 'Y' AND Status = 'Active';
    END
    
    IF @Status = 'Rejected' OR @Status = 'Completed'
    BEGIN
        UPDATE Car SET Status = 'Available' WHERE CarID = @CarID;
    END
END
GO

-- SP: Get All Rentals
CREATE PROCEDURE sp_GetAllRentals
AS
BEGIN
    SELECT 
        r.RentalID, 
        p.FirstName + ' ' + p.LastName AS CustomerName,
        c.PlateNumber, r.ActualStart, r.ActualEnd, r.Status, r.TotalAmount,
        c.Brand, c.Model, p.PersonID
    FROM Rental r
    JOIN Person p ON r.CustomerID = p.PersonID
    JOIN Car c ON r.CarID = c.CarID
    ORDER BY r.ActualStart DESC;
END
GO

-- SP: Process Return
CREATE PROCEDURE sp_ProcessReturn
    @RentalID INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CarID INT;
    SELECT @CarID = CarID FROM Rental WHERE RentalID = @RentalID;

    UPDATE Rental SET ActualEnd = GETDATE(), Status = 'Completed' WHERE RentalID = @RentalID;
    UPDATE Car SET Status = 'Available' WHERE CarID = @CarID;
    
    -- Auto-Generate Post-Rental Maintenance Check
    INSERT INTO Maintenance (CarID, MaintenanceType, Description, Status, MaintenanceDate)
    VALUES (@CarID, 'Post-Rental Check', 'Standard inspection after rental return.', 'Pending', GETDATE());
END
GO

-- SP: Maintenance History
CREATE PROCEDURE sp_GetMaintenanceHistory
AS
BEGIN
    SELECT 
        m.MaintenanceID, 
        c.Brand + ' ' + c.Model + ' (' + c.PlateNumber + ')' AS CarInfo,
        ISNULL(p.FirstName + ' ' + p.LastName, 'Unassigned') AS MechanicName,
        m.MaintenanceType, m.Cost, m.Description, m.Status, m.MaintenanceDate
    FROM Maintenance m
    JOIN Car c ON m.CarID = c.CarID
    LEFT JOIN Person p ON m.EmployeeID = p.PersonID
    ORDER BY m.MaintenanceDate DESC;
END
GO

-- SP: Complete Maintenance
CREATE PROCEDURE sp_CompleteMaintenanceAndReinlist
    @MaintenanceID INT,
    @MaintenanceType NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @Cost DECIMAL(18,2)
AS
BEGIN
    DECLARE @CarID INT;
    SELECT @CarID = CarID FROM Maintenance WHERE MaintenanceID = @MaintenanceID;

    UPDATE Maintenance
    SET MaintenanceType = @MaintenanceType, Description = @Description, Cost = @Cost, Status = 'Completed'
    WHERE MaintenanceID = @MaintenanceID;

    UPDATE Car SET Status = 'Available' WHERE CarID = @CarID;
END
GO

-- SP: Incident Reporting
CREATE PROCEDURE sp_ReportIncident
    @RentalID INT,
    @Title NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @DamageLevel NVARCHAR(50),
    @EstCost DECIMAL(18,2)
AS
BEGIN
    INSERT INTO IncidentReport (RentalID, Title, Description, DamageLevel, EstimatedCost, Status)
    VALUES (@RentalID, @Title, @Description, @DamageLevel, @EstCost, 'Under Review');

    UPDATE Rental SET DamageReport = @Title + ' (' + @DamageLevel + ')', PenaltyAmount = @EstCost
    WHERE RentalID = @RentalID;
END
GO

CREATE PROCEDURE sp_GetIncidentReports
AS
BEGIN
    SELECT i.IncidentID, i.RentalID, i.Title, i.DamageLevel, i.EstimatedCost, 
           i.ReportDate, i.Status, p.FirstName + ' ' + p.LastName AS CustomerName, c.PlateNumber
    FROM IncidentReport i
    JOIN Rental r ON i.RentalID = r.RentalID
    JOIN Person p ON r.CustomerID = p.PersonID
    JOIN Car c ON r.CarID = c.CarID
    ORDER BY i.ReportDate DESC;
END
GO

CREATE PROCEDURE sp_UpdateIncidentReport
    @IncidentID INT,
    @NewStatus NVARCHAR(50),
    @NewCost DECIMAL(18, 2)
AS
BEGIN
    DECLARE @CarID INT;
    DECLARE @IsInsured BIT;
    DECLARE @PolicyCoverage DECIMAL(18, 2);
    DECLARE @FinalCost DECIMAL(18, 2);
    
    SELECT @CarID = r.CarID FROM IncidentReport i JOIN Rental r ON i.RentalID = r.RentalID WHERE i.IncidentID = @IncidentID;

    SELECT TOP 1 @IsInsured = c.IsInsured, @PolicyCoverage = i.CoverageAmount 
    FROM Car c LEFT JOIN Insurance i ON c.CarID = i.CarID AND i.IsActive = 1 AND i.EndDate >= GETDATE()
    WHERE c.CarID = @CarID;
    
    SET @IsInsured = ISNULL(@IsInsured, 0);
    SET @PolicyCoverage = ISNULL(@PolicyCoverage, 0); 

    IF @IsInsured = 1
        SET @FinalCost = CASE WHEN @NewCost > @PolicyCoverage THEN @NewCost - @PolicyCoverage ELSE 0.00 END;
    ELSE
        SET @FinalCost = @NewCost; 

    UPDATE IncidentReport SET Status = @NewStatus, EstimatedCost = @FinalCost WHERE IncidentID = @IncidentID;

    IF @NewStatus = 'Resolved' UPDATE Car SET Status = 'Available' WHERE CarID = @CarID;
    ELSE IF @NewStatus = 'Under Review' UPDATE Car SET Status = 'Maintenance' WHERE CarID = @CarID;
END
GO

-- SP: Insurance
CREATE PROCEDURE sp_GetInsurancePolicies
AS
BEGIN
    SELECT i.InsuranceID, i.PolicyNumber, i.Provider, i.StartDate, i.EndDate, 
           i.CoverageAmount, i.IsActive, c.CarID, c.PlateNumber, c.Brand, c.Model
    FROM Insurance i JOIN Car c ON i.CarID = c.CarID ORDER BY i.EndDate DESC;
END
GO

CREATE PROCEDURE sp_InsertInsurancePolicy
    @CarID INT,
    @Provider NVARCHAR(200),
    @PolicyNumber NVARCHAR(100),
    @StartDate DATE,
    @EndDate DATE,
    @CoverageAmount DECIMAL(18,2)
AS
BEGIN
    INSERT INTO Insurance (CarID, Provider, PolicyNumber, StartDate, EndDate, CoverageAmount, CoverageType, IsActive)
    VALUES (@CarID, @Provider, @PolicyNumber, @StartDate, @EndDate, @CoverageAmount, 'Comprehensive', 1); 
    UPDATE Car SET IsInsured = 1 WHERE CarID = @CarID;
END
GO

CREATE PROCEDURE sp_UpdateInsurancePolicy
    @InsuranceID INT,
    @Provider NVARCHAR(200),
    @PolicyNumber NVARCHAR(100),
    @StartDate DATE,
    @EndDate DATE,
    @CoverageAmount DECIMAL(18,2),
    @IsActive BIT
AS
BEGIN
    UPDATE Insurance
    SET Provider = @Provider, PolicyNumber = @PolicyNumber, StartDate = @StartDate,
        EndDate = @EndDate, CoverageAmount = @CoverageAmount, IsActive = @IsActive
    WHERE InsuranceID = @InsuranceID;
END
GO

CREATE PROCEDURE sp_DeleteInsurancePolicy
    @InsuranceID INT
AS
BEGIN
    DECLARE @CarID INT;
    SELECT @CarID = CarID FROM Insurance WHERE InsuranceID = @InsuranceID;
    DELETE FROM Insurance WHERE InsuranceID = @InsuranceID;
    IF NOT EXISTS (SELECT 1 FROM Insurance WHERE CarID = @CarID AND EndDate >= GETDATE() AND IsActive = 1)
        UPDATE Car SET IsInsured = 0 WHERE CarID = @CarID;
END
GO
USE dbnb;
GO
USE dbnb;
GO

CREATE OR ALTER PROCEDURE sp_FilterAvailableCars
    @SearchTerm NVARCHAR(100) = NULL,
    @Category NVARCHAR(50) = 'All',
    @SortBy NVARCHAR(20) = 'Default'
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.CarID,
        c.Brand,
        c.Model,
        c.Year,
        c.DailyRate,
        c.Transmission,
        c.FuelType,  -- <--- ADDED THIS COLUMN
        c.CarImage,
        t.TypeName
    FROM Car c
    LEFT JOIN CarType t ON c.CarTypeID = t.CarTypeID
    WHERE c.Status = 'Available'
    -- 1. Search Logic
    AND (
        @SearchTerm IS NULL 
        OR c.Brand LIKE '%' + @SearchTerm + '%' 
        OR c.Model LIKE '%' + @SearchTerm + '%'
    )
    -- 2. Category Logic
    AND (
        @Category = 'All' 
        OR t.TypeName = @Category
    )
    -- 3. Sorting Logic
    ORDER BY 
        CASE WHEN @SortBy = 'PriceLow' THEN c.DailyRate END ASC,
        CASE WHEN @SortBy = 'PriceHigh' THEN c.DailyRate END DESC,
        c.CarID DESC;
END
GO
-- ========================================================
-- 5. DUMMY DATA INSERTION
-- ========================================================

-- Car Types
INSERT INTO CarType (TypeName) VALUES ('Luxury'), ('Sedan'), ('SUV');

-- Cars
INSERT INTO Car (PlateNumber, Brand, Model, Year, FuelType, Transmission, SeatingCapacity, DailyRate, Status, CarTypeID, IsInsured, CarImage)
VALUES 
('BMW-M5-001', 'BMW', 'M5 Competition', 2024, 'Petrol', 'Automatic', 5, 50000, 'Available', 1, 1, 'https://placehold.co/600x400?text=BMW+M5'),
('TOY-COR-002', 'Toyota', 'Corolla', 2023, 'Petrol', 'Automatic', 5, 8000, 'Available', 2, 0, 'https://placehold.co/600x400?text=Toyota+Corolla');

-- Coupons
INSERT INTO OFFER_DETAILS (Promo_Code, Description, Promo_Type, Is_One_Time, Percentage, Status)
VALUES ('SUMMER10', '10% Off', 'Percentage', 'Y', 10.00, 'Active');

-- Users: Admin
INSERT INTO Person (FirstName, LastName, Gender, DateOfBirth, CNIC, Email, Username, Password, AccountStatus)
VALUES ('Boss', 'Admin', 'Male', '1980-01-01', '35202-ADMIN', 'admin@rent.com', 'admin', '12345', 'Verified');
INSERT INTO Employee (EmployeeID, StaffRole, Salary, HireDate, Branch) VALUES (SCOPE_IDENTITY(), 'Manager', 100000, GETDATE(), 'HQ');
INSERT INTO AdminOverride (AdminID, AdminLevel, Permissions) VALUES (SCOPE_IDENTITY(), 'SuperAdmin', 'All');

-- Users: Customer
INSERT INTO Person (FirstName, LastName, Gender, DateOfBirth, CNIC, Email, Username, Password, AccountStatus)
VALUES ('John', 'Customer', 'Male', '1995-05-05', '35202-CUST', 'cust@rent.com', 'customer', '12345', 'Verified');
INSERT INTO Customer (CustomerID) VALUES (SCOPE_IDENTITY());

-- Users: Driver
INSERT INTO Person (FirstName, LastName, Gender, DateOfBirth, CNIC, Email, Username, Password, AccountStatus)
VALUES ('Baby', 'Driver', 'Male', '1990-01-01', '35202-DRIVE', 'driver@rent.com', 'driver', '12345', 'Verified');
INSERT INTO Employee (EmployeeID, StaffRole, Salary, HireDate, Branch) VALUES (SCOPE_IDENTITY(), 'Driver', 30000, GETDATE(), 'HQ');

GO