SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ordering_InsertOrder]
@SourceKey int,
@SourceType int,  -- 3 = Claim Companion
@SupplierId int,
@Reference varchar(30),
@DeliveryDate datetime =null,
@DeliveryNotes varchar(1000)=null,
@ProductFulfilmentType tinyint,
@Category varchar(200), -- ?
@channel varchar(50),
@insCoId int,
@Guid varchar(50),
@userid UserID,
@InsurancePolicyNo varchar(50)='',
@InsuranceClaimNo varchar(50),
@Excess smallmoney,
@IncidentDate datetime=null,
@Address1 varchar(100)=null,
@Address2 varchar(100)=null,
@Town varchar(100)=null,
@County varchar(100)=null,
@Postcode varchar(8)=null,
@Country varchar(100)=null,
@ContactTel varchar(20)=null,
@Title varchar(20),
@Forename varchar(100),
@Surname varchar(100),
@EmailAddress varchar(200),
@MobilePhone varchar(20)=null,
@DaytimePhone varchar(20)=null,
@EveningPhone varchar(20)=null,
@OrderTotal smallmoney=null,
@BankSortCode varchar(20)=null,
@BankAccountNo varchar(20)=null,
@PayeeName varchar(50)=null,
@BankId int=null,
@SendEmail tinyint=0,
@ServiceCode varchar(10)='0',
@ServiceCharge smallmoney=0
AS
set xact_abort on

declare @customerId int, @DeliveryId int

if exists (select * from Ordering_Delivery where Guid=@Guid)
	raiserror('Duplicate order exists SP_Ordering_InsertOrder',18,1)

begin TRAN

	SET @DeliveryDate = (SELECT CASE WHEN @SupplierId = 6683 AND @DeliveryDate IS NULL THEN DATEADD(dd, DATEDIFF(dd, 0, getdate()), 0) ELSE @DeliveryDate END) 

	insert into Ordering_Delivery (SourceKey, SourceType, SupplierId, Reference, CountryId, DeliveryDate,
		DeliveryNotes, ProductFulfilmentType, Category, SupplierName, Channel, InscoId, Guid, CreatedBy, SendEmail)
	select @SourceKey, @SourceType, @SupplierId, @Reference, 0, @DeliveryDate,
		@DeliveryNotes, @ProductFulfilmentType, @Category, d.Name, @Channel, @insCoid, @Guid, @userid,@SendEmail
	from SN_Distributor d
	where Id=@SupplierId

	set @DeliveryId = scope_identity()

	insert into Ordering_Claims (DeliveryId, InsurancePolicyNo, InsuranceClaimNo, Excess, IncidentDate, CreatedBy)
	values  (@DeliveryId, @InsurancePolicyNo, @InsuranceClaimNo, @Excess, @IncidentDate, @UserId)

	insert into Ordering_Address (DeliveryId, Address1, Address2, Town, County, Country, Postcode, ContactTel, CreatedBy)
	values  (@DeliveryId, @Address1, @Address2, @Town, @County, @Country, @PostCode, @ContactTel, @userid)

	insert into Ordering_Customer (Title, Forename, Surname, EmailAddress, MobilePhone, DaytimePhone, EveningPhone,CreatedBy)
	values  (@Title, @Forename, @Surname, @EmailAddress, @MobilePhone, @DaytimePhone, @EveningPhone, @userId)
	
	set @customerId = scope_identity()

	update Ordering_Delivery set CustomerId=@customerId where Id = @DeliveryId

	insert into Ordering_Delivery_Orders (DeliveryId, FulfilmentType, ServiceCode, PriceNet, VatRate, DeliveryCode, CreatedBy)
	values  (@DeliveryId, case @ProductFulfilmentType 
		when 7 then 3
		else @ProductFulfilmentType
	end, @ServiceCode, @ServiceCharge, 1.2, '', @userId)

	if @ProductFulfilmentType=7 -- Our Cash
	begin
		insert into Ordering_CashSettlements (Deliveryid, BankId, Amount, PayeeName, BankSortCode, BankAccountNo, CreatedBy)
		select @DeliveryId, @BankId, @OrderTotal, @PayeeName, @BankSortCode, @BankAccountNo, @userid
	end

	select @DeliveryId as DeliveryId

commit



GO
