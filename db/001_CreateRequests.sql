CREATE TABLE Requests 
(
    RequestId UNIQUEIDENTIFIER NOT NULL
        DEFAULT NEWID(),

    RequestNumber BIGINT IDENTITY(1,1) NOT NULL,

    RequestType NVARCHAR(50) NOT NULL,

    ResourceType NVARCHAR(50) NOT NULL,

    DisplayName NVARCHAR(255) NOT NULL,

    RequestedBy NVARCHAR(255) NOT NULL,

    RequestedOn DATETIME2 NOT NULL
        DEFAULT SYSUTCDATETIME(),
    
    Status  NVARCHAR(50) NOT NULL
        DEFAULT 'Pending',

    ResourceId NVARCHAR(255) NULL,

    CompletedOn DATETIME2 NULL,

    Payload NVARCHAR(MAX) NOT NULL,

    CONSTRAINT PK_Requests
        PRIMARY_KEY (ResourceId)
);