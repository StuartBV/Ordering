SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Paul Young
-- Create date: 26/11/2014
-- Description:	
-- =============================================
CREATE proc [dbo].[XXXApi_GetKeyInfo] 
	@KeyId varchar(20)
AS
begin
	set transaction isolation level read uncommitted
	SET NOCOUNT ON;

    select  
		KeyId ,
        ApiKey ,
        CreateDate ,
        RequestLimit ,
        RequestPeriod ,
        Disabled ,
        Description,
        CountryRestriction,
        Channel,
        Client
    from ApiKeys ak
    where ak.KeyId = @KeyId
END
GO
