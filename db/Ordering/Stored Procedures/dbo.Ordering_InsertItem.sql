SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Ordering_InsertItem]
@Deliveryid int,
@SourceKey int, 
@SourceType tinyint, 
@ProductCode varchar(50), 
@Make varchar(100), 
@Model varchar(100), 
@PriceNet money, 
@RRP money, 
@Status tinyint=5, 
@VatRate money,
@ExcessDeducted money=null,
@Installation tinyint=0, 
@Category varchar(100), 
@ItemReference varchar(50)=null, 
@SupplierCostPrice money, 
@UserId userid,
@SupplierId int,
@ChargeCatnum varchar(100)=null,
@ChargeTypeId int=null,
@ChargePriceNet money=null,
@ChargeDescription varchar(200) = null,
@ChargeVatRate money = null,
@EstimatedRRP money = null,
@SupplierChargeId int = null

as

declare @DeliveryItemId int

insert into Ordering_DeliveryItems (DeliveryId, SourceKey, SourceType, ProductCode, Make, Model, PriceNet, RRP, Status, VATRate, ExcessDeducted,
	Installation, Category, ItemReference, SupplierCostPrice, CreatedBy)
values (@DeliveryId, @SourceKey, @SourceType, @ProductCode, @Make, @Model, @PriceNet, @RRP, @Status, @VatRate, @ExcessDeducted,
	@Installation, @Category, @ItemReference, 
	case when @ProductCode = 'AGCOD' then @PriceNet else
	@SupplierCostPrice end, @UserId)

set @DeliveryItemId=scope_identity()

if @ChargeCatnum is not null
begin
	insert into dbo.Ordering_DeliveryItemCharges( DeliveryItemId, Type, SupplierChargeId, Catnum, Description, PriceNet, RRP, VatRate, CreateDate, CreatedBy)
	values  (@DeliveryItemId, @ChargeTypeId, @SupplierChargeId, @ChargeCatnum, @ChargeDescription, @ChargePriceNet, @EstimatedRRP, @ChargeVatRate, getdate(), @UserId)
end



GO
