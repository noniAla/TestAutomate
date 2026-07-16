CREATE INDEX IX_Requests_Status
    ON Requests(Status);
GO

CREATE INDEX IX_Requests_ResourceType
    ON Requests(ResourceType);
GO

CREATE INDEX IX_Requests_RequestedOn
    ON Requests(RequestedOn DESC);
GO

CREATE INDEX IX_AuditLog_RequestId
    ON AuditLog(RequestId);
GO

CREATE INDEX IX_AuditLog_EventTimestamp
    ON AuditLog(EventTimestamp DESC);
GO
