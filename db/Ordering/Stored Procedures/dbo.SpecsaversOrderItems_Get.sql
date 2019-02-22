SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpecsaversOrderItems_Get] @DeliveryId int
as
    begin
        set nocount on;
        select  RRP
        from    dbo.Ordering_DeliveryItems
        where   DeliveryId = @DeliveryId
    end
GO
