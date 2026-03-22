"""
Leader Schemas (Pydantic)
"""

from pydantic import BaseModel, Field, EmailStr
from typing import Optional, List
from datetime import date, datetime
from uuid import UUID

class LeaderProfileBase(BaseModel):
    first_name: str = Field(..., min_length=1, max_length=100)
    last_name: str = Field(..., min_length=1, max_length=100)
    phone: Optional[str] = None
    email: Optional[EmailStr] = None
    education_level: Optional[str] = None
    occupation: Optional[str] = None

class LeaderProfileCreate(LeaderProfileBase):
    user_id: Optional[UUID] = None

class LeaderProfileResponse(LeaderProfileBase):
    id: UUID
    gender: Optional[str] = None
    is_verified: bool = False
    created_at: datetime
    
    class Config:
        from_attributes = True

class LeadershipAssignmentBase(BaseModel):
    position_id: UUID
    start_date: date
    appointment_type: Optional[str] = None

class LeadershipAssignmentCreate(LeadershipAssignmentBase):
    community_id: UUID
    leader_id: UUID

class LeadershipAssignmentResponse(LeadershipAssignmentBase):
    id: UUID
    community_id: UUID
    leader_id: UUID
    is_current: bool = True
    status: str = "active"
    created_at: datetime
    
    class Config:
        from_attributes = True