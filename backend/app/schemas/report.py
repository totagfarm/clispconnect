"""
Report Schemas (Pydantic)
"""

from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import date, datetime
from uuid import UUID

class WeeklyReportBase(BaseModel):
    local_projects: Optional[str] = None
    security_incidents: Optional[str] = None
    disaster_incidents: Optional[str] = None
    public_health_trends: Optional[str] = None
    infrastructure_needs: Optional[str] = None

class WeeklyReportCreate(WeeklyReportBase):
    community_id: UUID
    report_week: date

class WeeklyReportUpdate(BaseModel):
    local_projects: Optional[str] = None
    security_incidents: Optional[str] = None
    disaster_incidents: Optional[str] = None
    public_health_trends: Optional[str] = None
    infrastructure_needs: Optional[str] = None
    status: Optional[str] = None
    priority_score: Optional[int] = None
    review_notes: Optional[str] = None

class WeeklyReportResponse(WeeklyReportBase):
    id: UUID
    community_id: UUID
    reporter_id: Optional[UUID] = None
    report_week: date
    submitted_at: datetime
    status: str
    priority_score: int = 0
    escalation_required: bool = False
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True