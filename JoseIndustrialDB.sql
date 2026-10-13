IF DB_ID(N'JoseIndustrialDB') IS NULL
BEGIN
    CREATE DATABASE JoseIndustrialDB;
END;
GO

USE JoseIndustrialDB;
GO

IF OBJECT_ID(N'dbo.Categorias', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Categorias
    (
        CategoriaId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Categorias PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL,
        Descripcion NVARCHAR(500) NULL,
        Activa BIT NOT NULL
            CONSTRAINT DF_Categorias_Activa DEFAULT (1),
        FechaCreacion DATETIME2(0) NOT NULL
            CONSTRAINT DF_Categorias_FechaCreacion DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT UQ_Categorias_Nombre UNIQUE (Nombre)
    );
END;
GO

IF OBJECT_ID(N'dbo.Productos', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Productos
    (
        ProductoId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Productos PRIMARY KEY,
        CategoriaId INT NULL,
        Codigo NVARCHAR(50) NULL,
        Nombre NVARCHAR(150) NOT NULL,
        Descripcion NVARCHAR(1000) NULL,
        Precio DECIMAL(12,2) NOT NULL
            CONSTRAINT DF_Productos_Precio DEFAULT (0),
        Existencias INT NOT NULL
            CONSTRAINT DF_Productos_Existencias DEFAULT (0),
        Activo BIT NOT NULL
            CONSTRAINT DF_Productos_Activo DEFAULT (1),
        FechaCreacion DATETIME2(0) NOT NULL
            CONSTRAINT DF_Productos_FechaCreacion DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT FK_Productos_Categorias
            FOREIGN KEY (CategoriaId) REFERENCES dbo.Categorias (CategoriaId),
        CONSTRAINT CK_Productos_Precio_NoNegativo CHECK (Precio >= 0),
        CONSTRAINT CK_Productos_Existencias_NoNegativas CHECK (Existencias >= 0)
    );

    CREATE UNIQUE INDEX UX_Productos_Codigo
        ON dbo.Productos (Codigo)
        WHERE Codigo IS NOT NULL;
    CREATE INDEX IX_Productos_CategoriaId
        ON dbo.Productos (CategoriaId);
END;
GO

IF OBJECT_ID(N'dbo.Servicios', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Servicios
    (
        ServicioId INT IDENTITY(1,1) NOT NULL
            CONSTRAINT PK_Servicios PRIMARY KEY,
        CategoriaId INT NULL,
        Nombre NVARCHAR(150) NOT NULL,
        Descripcion NVARCHAR(1000) NULL,
        Precio DECIMAL(12,2) NOT NULL
            CONSTRAINT DF_Servicios_Precio DEFAULT (0),
        DuracionMinutos INT NULL,
        Activo BIT NOT NULL
            CONSTRAINT DF_Servicios_Activo DEFAULT (1),
        FechaCreacion DATETIME2(0) NOT NULL
            CONSTRAINT DF_Servicios_FechaCreacion DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT FK_Servicios_Categorias
            FOREIGN KEY (CategoriaId) REFERENCES dbo.Categorias (CategoriaId),
        CONSTRAINT CK_Servicios_Precio_NoNegativo CHECK (Precio >= 0),
        CONSTRAINT CK_Servicios_Duracion_Positiva
            CHECK (DuracionMinutos IS NULL OR DuracionMinutos > 0)
    );

    CREATE INDEX IX_Servicios_CategoriaId
        ON dbo.Servicios (CategoriaId);
END;
GO
