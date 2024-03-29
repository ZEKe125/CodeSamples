USE [C126_ezelcuevas_gmail]
GO
/****** Object:  StoredProcedure [dbo].[TechCompanies_Search_Pagination]    Script Date: 5/6/2023 8:04:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[TechCompanies_Search_Pagination]
					@PageIndex int 
                   ,@PageSize int
				   ,@Query nvarchar(100)

AS

BEGIN



Declare @offset int = @PageIndex * @PageSize

SELECT t.[Id]
      ,[Name]
      ,[Profile]
      ,[Summary]
      ,[Headline]
      ,[Slug]
      ,[StatusId]
	  ,[ContactInformation] = (
					SELECT [Id]
							,[EntityId]
							,[Data]
							,[DateCreated]
							,[DateModified]
						FROM [dbo].[TechCompanyContactInformation] as c
						Where c.EntityId = t.Id
						FOR JSON AUTO
	  )
	  ,[Images] = (
					SELECT i.[Id]
						  ,i.[TypeId]
						  ,i.[Url]
					  FROM [dbo].[Images] as i
					  inner Join dbo.TechCompanyImages as ti
					  ON i.Id = ti.ImageId 
					  Where ti.TechCompanyId = t.Id
					  FOR JSON AUTO
 )
		,[Urls] = ( 

					SELECT [Id]
						  ,[EntityId]
						  ,[Url]
					  FROM [dbo].[Urls] as u
					  inner Join dbo.TechCompanyUrls as tu
					  ON u.Id = tu.UrlId
					  Where tu.TechCompanyId = t.Id
					  FOR JSON AUTO
)
		,[Friends] = (	
							SELECT f2.[Id]
								  ,[Title]
								  ,[Bio]
								  ,[Summary]
								  ,[Headline]
								  ,[Slug]
								  ,[StatusId]
								  ,[image].[Id] as ImageId
								  ,[image].[TypeId] as ImageTypeId
								  ,[image].[Url] as ImageUrl
								  ,Skills = (
											SELECT s.Id as id, 
											s.[Name] as [name]
					  
											FROM dbo.FriendsV2 as f
											INNER JOIN dbo.FriendSkills as fs
											ON f.Id = fs.FriendId
											INNER JOIN dbo.Skills as s
											ON s.Id = fs.SkillId
											WHERE f.Id = f2.Id
											FOR JSON AUTO
								  )
								  ,[UserId]
								  ,[DateCreated]
								  ,[DateModified]

							  FROM [dbo].[FriendsV2] as f2
							  inner join dbo.TechCompanyFriends as tf
							  on f2.Id = tf.FriendId
							  INNER JOIN dbo.Images as [image]
							  ON f2.PrimaryImageId = [image].Id
							  where tf.TechCompanyId = t.Id
							  for json auto
		)
		,[Tags] = (   

				SELECT [Id]
					  ,[TagName]
				  FROM [dbo].[Tags] as tg
				  inner join dbo.TechCompanyTags as tt
				  on tg.Id = tt.TagId
				  where tt.TechCompanyId = t.Id
				  for json auto

		) 
      ,[DateCreated]
      ,[DateModified]
	  ,TotalCount = COUNT(1) OVER()
  FROM [dbo].[TechCompanies] as t
  WHERE (t.[Name] LIKE '%' + @Query + '%')
ORDER BY Id

OFFSET @offSet Rows
Fetch Next @PageSize Rows ONLY


END
GO
