Use SPAIDW2A0104

Create table Customer (
 CustomerSK int identity not null primary key,
 CustomerID varchar(10) not null,
 FirstName varchar(20) not null,
 LastName varchar(20) not null,
 CompanyName varchar(50) not null,
 Contact varchar(10)
 );

Create table Employee (
 EmployeeSK int identity not null primary key,
 EmployeeID varchar(10) not null,
 FirstName varchar(20) not null,
 LastName varchar(20) not null,
 Contact varchar(10),
 Gender char(1) not null
 );

Create table [Order] (
 OrderSK int identity not null primary key,
 OrderID varchar(10) not null,
 RequiredAcc decimal(6,2) not null,
 OrderDate date not null
 );

Create table Dataset (
 DatasetSK int identity not null primary key,
 DatasetID varchar(10) not null,
 DatasetName varchar(50) not null
 );

Create table ModelType (
 ModelCode varchar(10) primary key,
 ModelType varchar(50) not null
 );

Create table Model (
 ModelSK int identity not null primary key,
 ModelID varchar(10) not null,
 ModelCode varchar(10) not null,
 TrainingDate date not null,
 Accuracy decimal(6,2) not null,

 foreign key(ModelCode) references ModelType(ModelCode)
 );

Create table Time (
 TimeSK int identity not null primary key,
 Date date not null,
 Day int not null,
 Month int not null,
 Quarter int not null,
 Year int not null,
 DayOfWeek char(3) not null
 );

Create table OrderFacts (
 OrderFactsSK int identity not null primary key,
 OrderSK int not null,
 TimeSK int not null,
 CustomerSK int not null,
 EmployeeSK int not null,
 ModelSK int not null,
 DatasetSK int not null,
 Price int not null,
 foreign key (OrderSK) references [Order](OrderSK),
 foreign key (TimeSK) references Time(TimeSK),
 foreign key (CustomerSK) references Customer(CustomerSK),
 foreign key (EmployeeSK) references Employee(EmployeeSK),
 foreign key (ModelSK) references Model(ModelSK),
 foreign key (DatasetSK) references Dataset(DatasetSK)
 );