SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[OrderSender_GetOrderDetails]
@DeliveryId int
as
set nocount on
declare @cr char(1)=Char(10)

select od.Id, CustomerId, SourceKey, SourceType, SupplierId, Reference, 
	[Status], od.CountryId, DeliveryDate, OrderRef, IsNull(od.AccountNo,d.AccountNo) AccountNo, DeliveryNotes,
	DeliveryService, CourierCode, CourierRef, CourierServiceCode,
	SupplierRef, CourierID, ProductFulfilmentType, Category, SupplierName,
	MarkedForInvoiceDate, Channel, od.InscoId, SendEmail, SendSms, DeliveryID,
	Seq, [Guid],
	IsNull(i.[Name],'unknown') InsurerName,
	IsNull(sso.FirstName + ' ' + sso.LastName, od.CreatedBy) + ' <' + Coalesce(ou.GroupEmail, sso.Email, '') + '>' AgentName,
	Coalesce(ou.GroupEmail, sso.Email, 'no-reply@bevalued.co.uk') AgentEmail,
	case
	when i.ID=2402 then 'DAG'
	when od.SupplierId=6658 then 'Aviva'
	else 'Be Valued' 
	end ClientName,
	IsNull(sl.[Description],'Unknown Type') ProductFulfilmentTypeDesc,
	IsNull(NullIf(d.Add1+@cr,''),'')
	+IsNull(NullIf(d.Add2+@cr,''),'')
	+IsNull(NullIf(d.Add3+@cr,''),'')
	+IsNull(NullIf(d.Town+@cr,''),'')
	+IsNull(NullIf(d.Coun+@cr,''),'')
	+IsNull(NullIf(d.Post+@cr,''),'')
	+@cr
	+IsNull(NullIf('TEL: '+d.Tel+@cr,''),'')
	+IsNull(NullIf('FAX: '+d.Fax+@cr,''),'') SupplierAddress,
d.DFEmail SupplierEmail
from Ordering_Delivery od
	join PPD3.dbo.Distributor d on d.ID=od.SupplierId
	left join PPD3.dbo.InsuranceCos i on i.ID=od.InscoId
	left join PPD3.dbo.SSO_User sso on sso.Username=od.CreatedBy
	left join PPD3.dbo.SSO_OrganisationalUnit ou on ou.Id=sso.OrganisationalUnitId
	left join sysLookup sl on sl.Code=od.ProductFulfilmentType and sl.TableName='ProductFulfilmentTypes'
where od.Id=@DeliveryId

select Address1, Address2, Town, County, Country, Postcode, ContactTel, CompanyName
from Ordering_Address
where DeliveryId=@DeliveryId

select DeliveryId, InsurancePolicyNo, InsuranceClaimNo, Excess, IncidentDate
from Ordering_Claims
where DeliveryId=@DeliveryId

select Deliveryid, BankId, Amount, PayeeName, BankSortCode, BankAccountNo
from Ordering_CashSettlements
where Deliveryid=@DeliveryId

select c.Id, c.Title, c.Forename, c.Surname, c.EmailAddress, c.MobilePhone,
 c.DaytimePhone, c.EveningPhone, c.[Name]
from Ordering_Delivery d
join Ordering_Customer c on d.CustomerId=c.Id
where d.DeliveryID=@DeliveryId

select DeliveryId, FulfilmentType, ServiceCode, PriceNet, VatRate, DeliveryCode, PriceGross
from Ordering_Delivery_Orders
where DeliveryId=@DeliveryId

select 
	IsNull(NullIf(ic.[BusinessName]+@cr,''),'')
	+IsNull(NullIf(ic.AddressLine1+@cr,''),'')
	+IsNull(NullIf(ic.AddressLine2+@cr,''),'')
	+IsNull(NullIf(ic.AddressLine3+@cr,''),'')
	+IsNull(NullIf(ic.Town+@cr,''),'')
	+IsNull(NullIf(ic.Postcode+@cr,''),'')
	+IsNull(NullIf(ic.Telephone+@cr,''),'')
	+IsNull(NullIf(ic.Email+@cr,''),'')
	+@cr [InvoiceAddress]
from Ordering_Delivery d 
	join Client_BusinessAddress ic on ic.Channel=d.Channel
	join PPD3.dbo.CurrencyData cd on cd.countryID=d.CountryId
where d.Id=@DeliveryId

select DeliveryId, ItemId, SourceKey, SourceType, ProductCode, Make, Model,
	PriceNet, RRP, [Status], VATRate, PriceGross, ExcessDeducted,
	Installation, Category, ItemReference, SupplierCostPrice,
	SupplierGrossPrice, [Guid]
from Ordering_DeliveryItems
where DeliveryId=@DeliveryId

select ic.Id, ic.DeliveryItemId, ic.[Type], ic.SupplierChargeId, ic.Catnum,
	ic.[Description], ic.PriceNet, ic.RRP, ic.VatRate, ic.PriceGross,
	IsNull(sl.[Description],'ERROR!!!') as TypeDesc
from Ordering_DeliveryItems i
	join Ordering_DeliveryItemCharges ic on i.ItemId=ic.DeliveryItemId
	left join sysLookup sl on sl.TableName='DeliveryItemChargeType' and sl.Code=ic.[Type]
where i.DeliveryId=@DeliveryId
GO
