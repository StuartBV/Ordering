SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[AppleOrderDataAccess]
@QueueId int
as

select
        'D' + convert( varchar(11), oa.DeliveryId) as PONumber,
        --coalesce(ou.GroupEmail, sso.[Email], '') as CompanyEmail,
        '' AS CompanyEmail,
        '' as CompanyPhoneNumber,
        oc.Title + ' ' + oc.Forename + ' ' + oc.Surname as CustomerName ,     
        oa.[Address1] as CustomerAddressLine2, 
        oa.[Address2] as CustomerAddressLine3,  
        '' as CustomerAddressLine4,
        oa.[Town] as CustomerCity , 
        oa.Country as CustomerCountry,
        oa.[Postcode] as CustomerPostcode ,   
        oc.[EmailAddress] as CustomerEmail,    
        coalesce(oc.[MobilePhone], oc.[DaytimePhone] , '') as CustomerPhone, 
        '' as ShippingPartner,
        '' as ShippingMethod,
        '' as SEANumber,
        '' as SalesEmail,
        '' as SalesRepId,
        '' as InternalUse,
        od.[Reference] as HeaderNote1,
        odi.ProductCode as AppleStockFileRef,
        1 as Quantity,
        '' as Discount,
        '' as PriceOverrideCode,
        '' as EtchingCode,
        '' as EngravingCode,
        '' as Line1ofText,
        '' as Line2ofText,
        '' as GiftCode,
        '' as GiftVariables1,
        '' as GiftVariables2,
        '' as Giftpackagepartnumber,
        '' as Giftpackagedetails,
        '' as Giftmessaging1,
        '' as Giftmessaging2,
        '' as Giftmessaging3,
        '' as Giftmessaging4,
        '' as Giftmessaging5,
        '' as SO#,
        '' as Dollaramt,
        '' as TimeBooked,
        '' AS DeliveryDate
        --od.DeliveryDate as DeliveryDate
from    [dbo].[Queue_Queue] q
        join [dbo].[Ordering_Delivery] od on od.[DeliveryID] = q.[DeliveryId] 
        join dbo.Ordering_DeliveryItems odi on od.DeliveryID = odi.DeliveryId
        join [dbo].[Ordering_Customer] oc on  oc.[Id] = od.[CustomerId] 
        join [dbo].[Ordering_Address] oa on oa.[DeliveryId] = q.[DeliveryId] 
        join [PPD3].[dbo].[SSO_User] sso on sso.[Username] =od.CreatedBy
        join [PPD3].[dbo].[SSO_OrganisationalUnit] ou on ou.[Id] = sso.[OrganisationalUnitId]
where   q.[Id] = @QueueId 
GO
