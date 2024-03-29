USE [C126_ezelcuevas_gmail]
GO
/****** Object:  StoredProcedure [dbo].[TechCompanies_Update]    Script Date: 5/6/2023 8:04:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROC [dbo].[TechCompanies_Update]
			@Name nvarchar(120),
			@Profile nvarchar(max),
			@Summary nvarchar(255),
			@Headline nvarchar(120),
			@ContactInformation nvarchar(255),
			@Slug nvarchar(100),
			@StatusId int,
			@BatchImages BatchImages READONLY,
			@BatchUrls BatchUrls READONLY,
			@BatchTags BatchTags READONLY,
			@BatchFriendIds BatchFriendIds READONLY,

			@Id int OUTPUT

AS 

BEGIN 


declare @ImageId int


--update TechCompanies
UPDATE [dbo].[TechCompanies]
   SET [Name] = @Name
      ,[Profile] = @Profile
      ,[Summary] = @Summary
      ,[Headline] = @Headline
      ,[Slug] = @Slug
      ,[StatusId] = @StatusId
      ,[DateModified] = GETUTCDATE()
 WHERE dbo.TechCompanies.Id = @Id



UPDATE [dbo].[TechCompanyContactInformation]
   SET [Data] = @ContactInformation
      ,[DateModified] = GETUTCDATE()
 WHERE dbo.TechCompanyContactInformation.EntityId = @Id



 -- update images

DELETE FROM [dbo].[TechCompanyImages]
      WHERE TechCompanyId = @Id


INSERT INTO [dbo].[Images]
           ([TypeId]
           ,[Url])
    select [ImageTypeId], [ImageUrl]
	from @BatchImages as bi
	WHERE NOT EXISTS (	SELECT 1
						FROM dbo.Images as i
						WHERE i.[Url] = bi.[ImageUrl])

	SET @ImageId = SCOPE_IDENTITY() 



INSERT INTO [dbo].[TechCompanyImages]
           ([TechCompanyId]
           ,[ImageId])
    select @Id, i.Id
	from @BatchImages as bi
	Inner Join dbo.Images as i
	ON bi.ImageUrl = i.Url


--- update urls

/*

DELETE FROM [dbo].[Urls]
      WHERE Id = ( 
		select UrlId
		from dbo.TechCompanyUrls as tu
		where tu.TechCompanyId = @id
	  )

*/

DELETE FROM [dbo].[TechCompanyUrls]
      WHERE TechCompanyId = @Id

INSERT INTO dbo.Urls
			([Url])
	SELECT bu.[Url]
	FROM @BatchUrls as bu
	WHERE NOT EXISTS (	SELECT 1
						FROM dbo.Urls as u
						WHERE u.[Url] = bu.[Url])

INSERT INTO [dbo].[TechCompanyUrls]
           ([TechCompanyId] ,[UrlId])
    SELECT @id , u.Id
	FROM @BatchUrls as bu
	INNER JOIN dbo.Urls as u
	ON bu.[Url] = u.[Url]


	
--- update tags
--DELETE FROM [dbo].[Tags]
--      WHERE Id = ( 
--		select TagId
--		from dbo.TechCompanyTags as tt
--		where tt.TechCompanyId = @id
--					)

DELETE FROM [dbo].[TechCompanyTags]
      WHERE TechCompanyId = @Id

INSERT INTO dbo.Tags
			([TagName])
	SELECT bt.[TagName]
	FROM @BatchTags as bt
	WHERE NOT EXISTS (	SELECT 1
						FROM dbo.Tags as t
						WHERE t.[TagName] = bt.[TagName])

INSERT INTO [dbo].[TechCompanyTags]
           ([TechCompanyId] ,[TagId])
    SELECT @id , u.Id
	FROM @BatchTags as bu
	INNER JOIN dbo.Tags as u
	ON bu.[TagName] = u.[TagName]


---update friendIds

DELETE FROM [dbo].[TechCompanyFriends]
      WHERE TechCompanyId = @Id

INSERT INTO [dbo].[TechCompanyFriends]
           ([TechCompanyId] ,[FriendId])
    SELECT @id , f2.Id
	FROM @BatchFriendIds as bf
	INNER JOIN dbo.FriendsV2 as f2
	ON bf.[FriendId] = f2.[Id]


END
GO
