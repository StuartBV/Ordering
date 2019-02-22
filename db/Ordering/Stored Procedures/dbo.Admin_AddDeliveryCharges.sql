SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Admin_AddDeliveryCharges]
@DeliveryId int,
@DeliveryItemId int, 
@Type int,
@SupplierChargeId int,                                          
@Catnum varchar(500),
@Description varchar(500),
@PriceNet smallmoney,
@RRP smallmoney,
@VatRate decimal(5,3),
@CreatedBy UserID
as
set xact_abort,nocount on
declare @deliveryItemChargeId int

begin tran
	insert into ordering_DeliveryItemCharges (DeliveryItemId, [Type], SupplierChargeId, Catnum, [Description], PriceNet, RRP, VatRate, CreatedBy)
	select @DeliveryItemId, @Type, @SupplierChargeId, @Catnum,@Description, @PriceNet, @RRP, @VatRate, @CreatedBy

	select @deliveryItemChargeId=scope_identity()

	insert into Invoicing.dbo.Invoicing_ItemCharges ( ItemId, [Type], SupplierChargeId, Catnum,[Description], PriceNet, VatRate, CreatedBy, DeliveryId, DeliveryItemId)   
	select @deliveryItemChargeId, @Type, @SupplierChargeId, @Catnum, @Description, @PriceNet, @VatRate, @CreatedBy, @DeliveryId, @DeliveryItemId
	--where  exists (select * from Invoicing.dbo.INVOICING_Orders where DeliveryId=@DeliveryId )
	from  Invoicing.dbo.Invoicing_Orders where DeliveryId=@DeliveryId
commit

-- Does this really need to be '*'??
select * from Invoicing.dbo.Invoicing_Orders 
where DeliveryId=@DeliveryId
GO
