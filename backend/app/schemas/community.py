"""
Community Schemas (Pydantic)
"""

from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import date, datetime
from uuid import UUID

class CommunityBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=200)
    community_type: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    population: Optional[int] = None
    households: Optional[int] = None
    notes: Optional[str] = None

class CommunityCreate(CommunityBase):
    clan_id: UUID

class CommunityUpdate(BaseModel):
    name: Optional[str] = None
    community_type: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    population: Optional[int] = None
    households: Optional[int] = None
    status: Optional[str] = None
    notes: Optional[str] = None

class CommunityResponse(CommunityBase):
    id: UUID
    code: Optional[str] = None
    status: str
    registration_date: Optional[date] = None
    verification_date: Optional[date] = None
    created_at: datetime
    updated_at: datetime
    
    class Config:
        from_attributes = True

class CommunityListResponse(BaseModel):
    total: int
    page: int
    page_size: int
    communities: List[CommunityResponse]