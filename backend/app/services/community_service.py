"""
Community Service Layer
"""

from sqlalchemy.orm import Session
from typing import List, Optional
from uuid import UUID
from app.models.community import Community, County, District, Clan

class CommunityService:
    def __init__(self, db: Session):
        self.db = db
    
    def get_all(self, skip: int = 0, limit: int = 100) -> List[Community]:
        return self.db.query(Community).offset(skip).limit(limit).all()
    
    def get_by_id(self, community_id: UUID) -> Optional[Community]:
        return self.db.query(Community).filter(Community.id == community_id).first()
    
    def get_by_county(self, county_id: UUID) -> List[Community]:
        return self.db.query(Community).join(Clan).join(District).filter(
            District.county_id == county_id
        ).all()
    
    def get_by_status(self, status: str) -> List[Community]:
        return self.db.query(Community).filter(Community.status == status).all()