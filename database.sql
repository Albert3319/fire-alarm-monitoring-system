-- KỊCH BẢN KHỞI TẠO CƠ SỞ DỮ LIỆU HỆ THỐNG GIÁM SÁT PCCC
-- Môn: Kỹ thuật phần mềm ứng dụng - ĐHBK Hà Nội

CREATE DATABASE HeThongGiamSatPCCC;
GO
USE [HeThongGiamSatPCCC]
GO

-- 1. Bảng Tòa nhà (Building)
CREATE TABLE [dbo].[Building](
	[BuildingId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[BuildingName] [nvarchar](100) NULL
);
GO

-- 2. Bảng Tầng (Floor)
CREATE TABLE [dbo].[Floor](
	[FloorId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[BuildingId] [int] NOT NULL,
	[FloorName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](255) NULL,
	CONSTRAINT [FK_Floor_Building] FOREIGN KEY([BuildingId]) REFERENCES [dbo].[Building] ([BuildingId])
);
GO

-- 3. Bảng Khu vực (Area)
CREATE TABLE [dbo].[Area](
	[AreaId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[AreaName] [nvarchar](100) NULL,
	[BuildingId] [int] NULL,
	[Description] [nvarchar](200) NULL,
	[FloorId] [int] NULL,
	CONSTRAINT [FK_Area_Building] FOREIGN KEY([BuildingId]) REFERENCES [dbo].[Building] ([BuildingId]),
	CONSTRAINT [FK_Area_Floor] FOREIGN KEY([FloorId]) REFERENCES [dbo].[Floor] ([FloorId])
);
GO

-- 4. Bảng Cảm biến PCCC (Sensor)
CREATE TABLE [dbo].[Sensor](
	[SensorId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[SensorName] [nvarchar](100) NULL,
	[SensorType] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[AreaId] [int] NULL,
	[Temperature] [float] NULL,
	[Smoke] [float] NULL,
	[FireLevel] [nvarchar](20) NULL,
	[Location] [nvarchar](100) NULL,
	CONSTRAINT [FK_Sensor_Area] FOREIGN KEY([AreaId]) REFERENCES [dbo].[Area] ([AreaId])
);
GO

-- 5. Bảng Thiết bị PCCC ngoại vi (Device)
CREATE TABLE [dbo].[Device](
	[DeviceId] [int] NOT NULL PRIMARY KEY,
	[Name] [nvarchar](100) NULL,
	[Type] [nvarchar](50) NULL,
	[Status] [nvarchar](20) NULL,
	[FloorId] [int] NULL,
	[DeviceCode] [nvarchar](20) NULL,
	[Manufacturer] [nvarchar](100) NULL,
	[Model] [nvarchar](100) NULL,
	[InstallDate] [datetime] NULL,
	[SensorId] [int] NULL,
	CONSTRAINT [FK_Device_Floor] FOREIGN KEY([FloorId]) REFERENCES [dbo].[Floor] ([FloorId]),
	CONSTRAINT [FK_Device_Sensor] FOREIGN KEY([SensorId]) REFERENCES [dbo].[Sensor] ([SensorId])
);
GO

-- 6. Bảng Sự cố Cảnh báo (Alarm)
CREATE TABLE [dbo].[Alarm](
	[AlarmId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[SensorId] [int] NULL,
	[AlarmTime] [datetime] NULL DEFAULT (getdate()),
	[Level] [nvarchar](50) NULL,
	[IsResolved] [bit] NULL DEFAULT ((0)),
	CONSTRAINT [FK_Alarm_Sensor] FOREIGN KEY([SensorId]) REFERENCES [dbo].[Sensor] ([SensorId])
);
GO

-- 7. Bảng Vai trò (Role)
CREATE TABLE [dbo].[Role](
	[RoleId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[RoleName] [nvarchar](50) NOT NULL,
	[RoleCode] [nvarchar](30) NULL,
	[Description] [nvarchar](200) NULL,
	[Priority] [int] NOT NULL DEFAULT ((0)),
	[IsActive] [bit] NOT NULL DEFAULT ((1)),
	[CreatedAt] [datetime] NOT NULL DEFAULT (getdate())
);
GO

-- 8. Bảng Quyền hạn (Permission)
CREATE TABLE [dbo].[Permission](
	[PermissionId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[PermissionCode] [nvarchar](50) NOT NULL UNIQUE,
	[PermissionName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[CreatedAt] [datetime] NOT NULL DEFAULT (getdate()),
	[IsActive] [bit] NOT NULL DEFAULT ((1))
);
GO

-- 9. Bảng Phân quyền Vai trò (RolePermission)
CREATE TABLE [dbo].[RolePermission](
	[RoleId] [int] NOT NULL,
	[PermissionId] [int] NOT NULL,
	[GrantedAt] [datetime] NOT NULL DEFAULT (getdate()),
	PRIMARY KEY ([RoleId], [PermissionId]),
	CONSTRAINT [FK_RolePermission_Role] FOREIGN KEY([RoleId]) REFERENCES [dbo].[Role] ([RoleId]),
	CONSTRAINT [FK_RolePermission_Permission] FOREIGN KEY([PermissionId]) REFERENCES [dbo].[Permission] ([PermissionId])
);
GO

-- 10. Bảng Người dùng (User)
CREATE TABLE [dbo].[User](
	[UserId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Username] [nvarchar](50) NOT NULL UNIQUE,
	[Password] [nvarchar](255) NOT NULL,
	[RoleId] [int] NULL,
	[FullName] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[Phone] [nvarchar](20) NULL,
	[BuildingId] [int] NULL,
	[Status] [nvarchar](20) NOT NULL DEFAULT ('Active'),
	[LastLogin] [datetime] NULL,
	[CreatedAt] [datetime] NOT NULL DEFAULT (getdate()),
	[UpdatedAt] [datetime] NOT NULL DEFAULT (getdate()),
	CONSTRAINT [FK_User_Role] FOREIGN KEY([RoleId]) REFERENCES [dbo].[Role] ([RoleId])
);
GO

-- 11. Bảng Nhật ký xử lý cảnh báo (AlarmLog)
CREATE TABLE [dbo].[AlarmLog](
	[LogId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[AlarmId] [int] NULL,
	[UserId] [int] NULL,
	[Action] [nvarchar](255) NULL,
	[LogTime] [datetime] NULL DEFAULT (getdate()),
	CONSTRAINT [FK_AlarmLog_Alarm] FOREIGN KEY([AlarmId]) REFERENCES [dbo].[Alarm] ([AlarmId]),
	CONSTRAINT [FK_AlarmLog_User] FOREIGN KEY([UserId]) REFERENCES [dbo].[User] ([UserId])
);
GO

-- 12. Bảng Nhật ký thao tác hệ thống (SystemLog)
CREATE TABLE [dbo].[SystemLog](
	[LogId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[UserId] [int] NULL,
	[Action] [nvarchar](255) NULL,
	[LogTime] [datetime] NULL DEFAULT (getdate()),
	CONSTRAINT [FK_SystemLog_User] FOREIGN KEY([UserId]) REFERENCES [dbo].[User] ([UserId])
);
GO
