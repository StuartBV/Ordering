SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[SupplierEvents_InvoiceStandingData] as

select distinct d.[id],d.Channel,
	rtrim(ltrim(c.InsuranceClaimNo)) InsuranceClaimNo,
	rtrim(ltrim(c.InsurancePolicyNo)) InsurancePolicyNo,
	i.InvoiceNo as invoicenumber, i.InvoiceSent,
	c.IncidentDate,c.Excess,
	cu.Title,cu.Forename Fname, cu.Surname Lname,  isnull(a.Address1,cu.EmailAddress) Address1,
	isnull(ltrim(rtrim(a.Postcode)),'BN22 8LD') Postcode,
	isnull(i.Total,0) InvoiceTotal
from ORDERING_Delivery d
join ordering_claims c on d.Id=c.DeliveryId
join ordering_customer cu on cu.id=d.CustomerId
left join ORDERING_Address a on a.DeliveryId=d.Id
left join Invoicing.dbo.Invoicing_CPLInvoices i on i.deliveryID=d.Id
GO
