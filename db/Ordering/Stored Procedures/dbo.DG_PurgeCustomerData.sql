SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Paul Young
-- Create date: 16/3/2016
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[DG_PurgeCustomerData] 
	@DeliveryId int
AS
BEGIN
	SET NOCOUNT ON;

	update oc
	set Title = null, Forename = null, Surname = null, MobilePhone = null, EveningPhone = null, DaytimePhone = null,
	EmailAddress = null, AlteredDate = getdate(), AlteredBy = 'sys'
	FROM dbo.Ordering_Delivery od
	join dbo.Ordering_Customer oc on od.CustomerId = oc.Id
	where od.DeliveryID = @DeliveryId

	update dbo.Ordering_Address
	set Address1 = null, Address2 = null, Town = null, County = null, Postcode = null, ContactTel = null,
	AlteredDate = getdate(), AlteredBy = 'sys'
	where DeliveryId = @DeliveryId

END
GO
