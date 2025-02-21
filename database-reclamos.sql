
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SISTEMA_RECLAMOS')
BEGIN
    CREATE DATABASE SISTEMA_RECLAMOS;
END;
GO

USE SISTEMA_RECLAMOS;
GO

-- Tabla de Usuarios (Clientes y Empleados)
CREATE TABLE Usuarios (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    DNI VARCHAR(20) UNIQUE NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono VARCHAR(20) NULL,
    TipoUsuario VARCHAR(20) NOT NULL,  
    FechaRegistro DATETIME DEFAULT GETDATE()
);
ALTER TABLE Usuarios
ADD CONSTRAINT chk_TipoUsuario CHECK (TipoUsuario IN ('Cliente', 'Empleado'));

-- Tabla Tipos  de Reclamo
CREATE TABLE TiposReclamo (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT NULL
);

-- Tabla Estados de Reclamo
CREATE TABLE EstadosReclamo (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Estado VARCHAR(50) UNIQUE NOT NULL
);
INSERT INTO EstadosReclamo (Estado) VALUES ('Pendiente'), ('En proceso'), ('Resuelto');


-- Tabla Reclamos
CREATE TABLE Reclamos (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT NOT NULL,  
    TipoReclamoID INT NOT NULL,
    EstadoID INT NOT NULL DEFAULT 1,
    Descripcion TEXT NOT NULL,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(ID),
    FOREIGN KEY (TipoReclamoID) REFERENCES TiposReclamo(ID),
    FOREIGN KEY (EstadoID) REFERENCES EstadosReclamo(ID)
);

--Tabla  Historial de Reclamos

CREATE TABLE HistorialReclamos (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ReclamoID INT NOT NULL,
    EstadoAnteriorID INT NOT NULL,
    EstadoNuevoID INT NOT NULL,
    FechaCambio DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ReclamoID) REFERENCES Reclamos(ID),
    FOREIGN KEY (EstadoAnteriorID) REFERENCES EstadosReclamo(ID),
    FOREIGN KEY (EstadoNuevoID) REFERENCES EstadosReclamo(ID)
);


IF OBJECT_ID('Clientes', 'U') IS NOT NULL
    DROP TABLE Clientes;
GO
CREATE TABLE Notificaciones (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ReclamoID INT NOT NULL,
    UsuarioID INT NOT NULL,
    Mensaje TEXT NOT NULL,
    FechaEnvio DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ReclamoID) REFERENCES Reclamos(ID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(ID)
);