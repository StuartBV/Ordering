SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Sender_Email_Tokens_Get]
@queueId int
as
set nocount on
set transaction isolation level read uncommitted

declare @now datetime=convert(char(10),getdate(),103)+' '+convert(char(5),getdate(),14),
	@cr char(1)=char(10),@employeename varchar(100),@customername varchar(100),@customeraddress varchar(500),@customerphone varchar(20),	
	@customerwphone varchar(20),@customermphone varchar(20),@customerhphone varchar(20),@customeremail varchar(200),@supplieraddress varchar(500),
	@suppliername varchar(100),@employeeemail varchar(200),@poref varchar(40),@ourref varchar(30),@accountno varchar(50),
	@productfulfilmenttype varchar(500), @deliveryId int
	
select @deliveryId=q.DeliveryId
from QUEUE_Queue q
where q.Id=@queueid

select @customername=isnull(cu.[Title]+' ','')+isnull(cu.[Forename]+' ','')+isnull(cu.[Surname],''),
	@customeraddress=
		isnull(nullif(a.Address1+@cr,''),'')
		+isnull(nullif(a.address2+@cr,''),'')
		+isnull(nullif(a.town+@cr,''),'')
		+isnull(nullif(a.county+@cr,''),'')
		+isnull(nullif(a.postcode+@cr,''),'')
		+isnull(nullif(a.country+@cr,''),''),
	@customeremail=cu.[EmailAddress],
	@customerphone=isnull(a.ContactTel,''),
	@customermphone=isnull(cu.MobilePhone,''),
	@customerhphone=isnull(cu.EveningPhone,''),
	@customerwphone=isnull(cu.DaytimePhone,''),
	@suppliername =isnull(d.[name],''),
	@supplieraddress=
		isnull(nullif(d.add1+@cr,''),'')
		+isnull(nullif(d.add2+@cr,''),'')
		+isnull(nullif(d.add3+@cr,''),'')
		+isnull(nullif(d.town+@cr,''),'')
		+isnull(nullif(d.coun+@cr,''),'')
		+isnull(nullif(d.post+@cr,''),'')
		+@cr
		+isnull(nullif('TEL: '+d.tel+@cr,''),'')
		+isnull(nullif('FAX: '+d.fax+@cr,''),''),
	@employeename=isnull(e.FName+' '+e.sname,od.CreatedBy), 
	@employeeemail=coalesce(e.WEmail,e.FName+'.'+e.sname+'@BeValued.co.uk' ,'noreply@bevalued.co.uk'), 
	@poref=od.orderref,
	@accountno=isnull('Account No: '+isnull(od.AccountNo,d.accountno),''),
	@productfulfilmenttype=isnull(sl.description,'Unknown Type')
from ORDERING_Delivery od join ORDERING_Customer cu on cu.id=od.CustomerId
join ORDERING_Address a on a.DeliveryId=od.id
join ppd3.dbo.Distributor d on d.id=od.SupplierId
left join ppd3.dbo.Logon l on l.UserID=od.CreatedBy
left join ppd3.dbo.employees e on e.id=l.UserFK
left join syslookup sl on sl.code = od.productfulfilmenttype and sl.tablename='ProductFulfilmentTypes'
where od.id=@deliveryId

--Start of Tokens DataSets (Body)

select isnull(convert(char(10),d.DeliveryDate,103),'TBA') deliverydate, d.deliverynotes, @employeename RaisedBy, @now [now], @productfulfilmenttype productfulfilmenttype
from ORDERING_Delivery d
where d.id=@deliveryId

select @suppliername [suppliername], @supplieraddress [supplieraddress]

select
	isnull(cu.[Title]+' ','')
	+isnull(cu.[Forename]+' ','')
	+isnull(cu.[Surname],'') customername,
	@customerAddress CustomerAddress,
	@customeremail EmailAddress,
	@customerphone customerphone,
	@customermphone customermphone,
	@customerhphone customerhphone,
	@customerwphone customerwphone
from ORDERING_Delivery d join ORDERING_Customer cu on cu.id=d.CustomerId
where d.id=@deliveryId

select 
	isnull(nullif(ic.[BusinessName]+@cr,''),'')
	+isnull(nullif(ic.AddressLine1+@cr,''),'')
	+isnull(nullif(ic.AddressLine2+@cr,''),'')
	+isnull(nullif(ic.AddressLine3+@cr,''),'')
	+isnull(nullif(ic.Town+@cr,''),'')
	+isnull(nullif(ic.Postcode+@cr,''),'')
	+isnull(nullif('TEL: '+ic.Telephone+@cr,''),'')
	+isnull(nullif('FAX: '+ic.Fax+@cr,''),'')
	+isnull(nullif(ic.Email+@cr,''),'')
	+@cr [InvoiceAddress],
	cd.CurrencySymbol [CurrencySymbol]
from ORDERING_Delivery d join CLIENT_BusinessAddress ic on ic.Channel=d.channel
join ppd3.dbo.CurrencyData cd on cd.countryid=d.CountryId
where d.id=@deliveryId

select 
	isnull(nullif(nullif(od.reference,'0'),''),'N/A') InsuranceClaimRef,
	'N/A' IncidentDate, -- This is not used, but was put in for legacy purposes to allow SP to roll out to LIVE
	isnull(convert(char(10),oc.IncidentDate,103),'') as ClaimIncidentDate,
	isnull(oc.InsurancePolicyNo,'N/A') CustomerPolicyRef,
	@poref PoRef, @poref OurRef,
	'OS' + cast(od.Id as varchar(20)) + '/' + cast(od.SupplierId as varchar(20)) as cplestimateid
from ORDERING_Delivery od
left join dbo.Ordering_Claims oc on oc.DeliveryId=od.id
where od.id=@deliveryid

select 
	sum(di.ProductPrice-(di.ProductDeliveryprice+di.ProductInstallprice+di.productdisposalprice) ) totalnetprice,
	cast(sum(di.ProductPrice * di.VATRate) as decimal(8,2)) totalpriceincvat,
	cast(sum(di.ProductPrice * di.VATRate - di.productprice) as decimal(8,2)) totalvatprice,
	cast(sum(di.ProductDeliveryprice) as varchar) totaldeliveryprice,
	cast(sum(di.ProductInstallprice) as varchar) totalinstallprice,
	cast(sum(di.productdisposalprice) as varchar) totaldisposalprice
from ORDERING_ProductList_View di
where di.DeliveryId=@deliveryId

GO
