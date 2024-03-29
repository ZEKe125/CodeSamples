USE [C126_ezelcuevas_gmail]
GO
/****** Object:  Table [dbo].[TechCompanies]    Script Date: 5/6/2023 8:04:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TechCompanies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](120) NOT NULL,
	[Profile] [nvarchar](max) NOT NULL,
	[Summary] [nvarchar](255) NOT NULL,
	[Headline] [nvarchar](120) NOT NULL,
	[Slug] [nvarchar](100) NOT NULL,
	[StatusId] [int] NOT NULL,
	[DateCreated] [datetime2](7) NOT NULL,
	[DateModified] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_TechCompanies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TechCompanies] ADD  CONSTRAINT [DF_TechCompanies_DateCreated]  DEFAULT (getutcdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[TechCompanies] ADD  CONSTRAINT [DF_TechCompanies_DateModified]  DEFAULT (getutcdate()) FOR [DateModified]
GO
