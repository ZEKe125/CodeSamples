USE [C126_ezelcuevas_gmail]
GO
/****** Object:  Table [dbo].[Urls]    Script Date: 5/6/2023 8:04:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Urls](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NULL,
	[Url] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_Urls] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Urls]  WITH CHECK ADD  CONSTRAINT [FK_Urls_TechCompanies] FOREIGN KEY([EntityId])
REFERENCES [dbo].[TechCompanies] ([Id])
GO
ALTER TABLE [dbo].[Urls] CHECK CONSTRAINT [FK_Urls_TechCompanies]
GO
