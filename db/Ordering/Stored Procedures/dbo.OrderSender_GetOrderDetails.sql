SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[OrderSender_GetOrderDetails]
@DeliveryId int
as
set nocount on
declare @cr char(1)=char(10)

select od.Id, CustomerId, SourceKey, SourceType, SupplierId, Reference, 
	   Status, od.CountryId, DeliveryDate, OrderRef, isnull(od.AccountNo,d.accountno) as AccountNo, DeliveryNotes,
       DeliveryService, CourierCode, CourierRef, CourierServiceCode,
       SupplierRef, CourierID, ProductFulfilmentType, Category, SupplierName,
       MarkedForInvoiceDate, Channel, od.InscoId, SendEmail, SendSms, DeliveryID,
       Seq, Guid,
		isnull(i.Name,'unknown') as InsurerName,
		isnull(sso.FirstName + ' ' + sso.LastName, od.CreatedBy) + ' <' + coalesce(ou.GroupEmail, sso.Email, '') + '>' as AgentName,
		coalesce(ou.GroupEmail, sso.Email, 'no-reply@bevalued.co.uk') as AgentEmail,
		case
			when i.ID=2402 then 'DAG'
			when od.SupplierId=6658 then 'Aviva'
			else 'Be Valued' 
		end ClientName,
		isnull(sl.description,'Unknown Type') as ProductFulfilmentTypeDesc,
		isnull(nullif(d.add1+@cr,''),'')
		+isnull(nullif(d.add2+@cr,''),'')
		+isnull(nullif(d.add3+@cr,''),'')
		+isnull(nullif(d.town+@cr,''),'')
		+isnull(nullif(d.coun+@cr,''),'')
		+isnull(nullif(d.post+@cr,''),'')
		+@cr
		+isnull(nullif('TEL: '+d.tel+@cr,''),'')
		+isnull(nullif('FAX: '+d.fax+@cr,''),'') as SupplierAddress,
		d.DFEmail as SupplierEmail
from Ordering_Delivery od
join ppd3.dbo.Distributor d on d.ID=od.SupplierId
left join PPD3.dbo.InsuranceCos i on i.ID=od.InscoId
left join PPD3.dbo.SSO_User sso on sso.Username=od.CreatedBy
left join PPD3.dbo.SSO_OrganisationalUnit ou on ou.Id=sso.OrganisationalUnitId
left join syslookup sl on sl.code = od.productfulfilmenttype and sl.tablename='ProductFulfilmentTypes'
where od.Id=@DeliveryId

select  Address1, Address2, Town, County, Country, Postcode, ContactTel, CompanyName
from Ordering_Address
where DeliveryId=@DeliveryId

select DeliveryId, InsurancePolicyNo, InsuranceClaimNo, Excess, IncidentDate
from Ordering_Claims
where DeliveryId=@DeliveryId

select Deliveryid, BankId, Amount, PayeeName, BankSortCode, BankAccountNo
from Ordering_CashSettlements
where Deliveryid=@DeliveryId

select c.Id, c.Title, c.Forename, c.Surname, c.EmailAddress, c.MobilePhone,
       c.DaytimePhone, c.EveningPhone, c.Name
from Ordering_Delivery d
join Ordering_Customer c on d.CustomerId=c.Id
where d.DeliveryID=@DeliveryId

select DeliveryId, FulfilmentType, ServiceCode, PriceNet, VatRate, DeliveryCode, PriceGross
from Ordering_Delivery_Orders
where DeliveryId=@DeliveryId

select 
	isnull(nullif(ic.[BusinessName]+@cr,''),'')
	+isnull(nullif(ic.AddressLine1+@cr,''),'')
	+isnull(nullif(ic.AddressLine2+@cr,''),'')
	+isnull(nullif(ic.AddressLine3+@cr,''),'')
	+isnull(nullif(ic.Town+@cr,''),'')
	+isnull(nullif(ic.Postcode+@cr,''),'')
	+isnull(nullif(ic.Telephone+@cr,''),'')
	+isnull(nullif(ic.Email+@cr,''),'')
	+@cr [InvoiceAddress]
from ORDERING_Delivery d 
join CLIENT_BusinessAddress ic on ic.Channel=d.channel
join ppd3.dbo.CurrencyData cd on cd.countryid=d.CountryId
where d.id=@deliveryId

select DeliveryId, ItemId, SourceKey, SourceType, ProductCode, Make, Model,
       PriceNet, RRP, Status, VATRate, PriceGross, ExcessDeducted,
       Installation, Category, ItemReference, SupplierCostPrice,
       SupplierGrossPrice, Guid
from Ordering_DeliveryItems
where DeliveryId=@DeliveryId

select ic.Id, ic.DeliveryItemId, ic.Type, ic.SupplierChargeId, ic.Catnum,
       ic.Description, ic.PriceNet, ic.RRP, ic.VatRate, ic.PriceGross,
	   isnull(sl.Description,'ERROR!!!') as TypeDesc
from Ordering_DeliveryItems i
join Ordering_DeliveryItemCharges ic on i.ItemId=ic.DeliveryItemId
left join syslookup sl on sl.tablename='DeliveryItemChargeType' and sl.code=ic.[Type]
where i.DeliveryId=@DeliveryId
GO
