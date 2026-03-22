"""
Community, County, District, and Clan Models
"""

from sqlalchemy import Column, String, Integer, Decimal, Date, DateTime, ForeignKey, Enum
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from geoalchemy2 import Geometry
import uuid
from app.database import Base
import enum

class CommunityStatus(enum.Enum):
    PENDING = "pending"
    VERIFIED = "verified"
    ACTIVE = "active"
    INACTIVE = "inactive"

class County(Base):
    """Liberia counties (15 total)"""
    __tablename__ = "counties"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(100), nullable=False)
    code = Column(String(10), unique=True)
    capital = Column(String(100))
    population = Column(Integer)
    area_sq_km = Column(Decimal(10, 2))
    geometry = Column(Geometry("MULTIPOLYGON", srid=4326))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    districts = relationship("District", back_populates="county")

class District(Base):
    """Districts within counties"""
    __tablename__ = "districts"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    county_id = Column(UUID(as_uuid=True), ForeignKey("counties.id"))
    name = Column(String(100), nullable=False)
    code = Column(String(10), unique=True)
    geometry = Column(Geometry("MULTIPOLYGON", srid=4326))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    county = relationship("County", back_populates="districts")
    clans = relationship("Clan", back_populates="district")

class Clan(Base):
    """Clans within districts"""
    __tablename__ = "clans"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    district_id = Column(UUID(as_uuid=True), ForeignKey("districts.id"))
    name = Column(String(100), nullable=False)
    geometry = Column(Geometry("MULTIPOLYGON", srid=4326))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    district = relationship("District", back_populates="clans")
    communities = relationship("Community", back_populates="clan")

class Community(Base):
    """Registered communities"""
    __tablename__ = "communities"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    clan_id = Column(UUID(as_uuid=True), ForeignKey("clans.id"))
    name = Column(String(200), nullable=False)
    code = Column(String(20), unique=True)
    community_type = Column(String(50))  # town, village, settlement
    latitude = Column(Decimal(10, 8))
    longitude = Column(Decimal(11, 8))
    geometry = Column(Geometry("POINT", srid=4326))
    population = Column(Integer)
    households = Column(Integer)
    status = Column(Enum(CommunityStatus), default=CommunityStatus.PENDING)
    registration_date = Column(Date)
    verification_date = Column(Date)
    verified_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    notes = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    created_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    updated_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    
    clan = relationship("Clan", back_populates="communities")
    leadership_assignments = relationship("LeadershipAssignment", back_populates="community")
    weekly_reports = relationship("WeeklyReport", back_populates="community")