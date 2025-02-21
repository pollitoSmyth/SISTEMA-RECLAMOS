
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SISTEMA_RECLAMOS')
BEGIN
    CREATE DATABASE SISTEMA_RECLAMOS;
END;
GO

USE SISTEMA_RECLAMOS;
GO

-- Tabla de Clientes
CREATE TABLE Clientes (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    DNI VARCHAR(20) UNIQUE NOT NULL,  -- DNI agregado
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono VARCHAR(20),
    FechaRegistro DATETIME DEFAULT GETDATE()
);

-- Tabla de Empleados
CREATE TABLE Empleados (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    DNI VARCHAR(20) UNIQUE NOT NULL,  -- DNI agregado
    Nombre VARCHAR(100) NOT NULL,
    Cargo VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla de Reclamos
CREATE TABLE Reclamos (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT,
    EmpleadoID INT,
    Descripcion TEXT NOT NULL,
    Estado VARCHAR(50) DEFAULT 'Pendiente',
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ID),
    FOREIGN KEY (EmpleadoID) REFERENCES Empleados(ID)
);

-- Tabla de Notificaciones
CREATE TABLE Notificaciones (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ReclamoID INT,
    Mensaje TEXT NOT NULL,
    FechaEnvio DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ReclamoID) REFERENCES Reclamos(ID)
);
