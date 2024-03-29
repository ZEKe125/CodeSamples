USE [C126_ezelcuevas_gmail]
GO
/****** Object:  StoredProcedure [dbo].[TechCompanies_Delete]    Script Date: 5/6/2023 8:04:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROC [dbo].[TechCompanies_Delete]
			@Id int 

AS 

BEGIN 


--- delete contactInfo
DELETE FROM [dbo].[TechCompanyContactInformation]
      WHERE EntityId = @Id


 -- delete images
DELETE FROM [dbo].[TechCompanyImages]
      WHERE TechCompanyId = @Id


--- delete urls
DELETE FROM [dbo].[Urls]
      WHERE Id = ( 
		select UrlId
		from dbo.TechCompanyUrls as tu
		where tu.TechCompanyId = @id
					)

DELETE FROM [dbo].[TechCompanyUrls]
      WHERE TechCompanyId = @Id


	
--- delete tags
DELETE FROM [dbo].[Tags]
      WHERE Id = ( 
		select TagId
		from dbo.TechCompanyTags as tt
		where tt.TechCompanyId = @id
					)

DELETE FROM [dbo].[TechCompanyTags]
      WHERE TechCompanyId = @Id


---delete friendIds
DELETE FROM [dbo].[TechCompanyFriends]
      WHERE TechCompanyId = @Id

--delete TechCompanies
DELETE FROM [dbo].[TechCompanies]
      WHERE Id = @Id

END
GO
