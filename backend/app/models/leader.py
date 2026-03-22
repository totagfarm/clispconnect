"""
Leader Profile and Leadership Assignment Models
"""

from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey, Date, Enum
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import uuid
from app.database import Base
import enum

class Gender(enum.Enum):
    MALE = "male"
    FEMALE = "female"
    OTHER = "other"

class LeadershipPosition(Base):
    """Configurable leadership positions"""
    __tablename__ = "leadership_positions"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(100), nullable=False)  # Chief, Elder, Women Leader, etc.
    description = Column(String)
    level = Column(String(50))  # community, clan, district, county
    is_elected = Column(Boolean, default=False)
    term_months = Column(Integer, default=12)
    gender_requirement = Column(String(20))  # male, female, any
    min_age = Column(Integer)
    display_order = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

class LeaderProfile(Base):
    """Individual leader profiles"""
    __tablename__ = "leader_profiles"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    date_of_birth = Column(Date)
    gender = Column(Enum(Gender))
    phone = Column(String(20))
    email = Column(String(255))
    education_level = Column(String(100))
    occupation = Column(String(200))
    languages_spoken = Column(String)  # JSON array
    photo_url = Column(String(500))
    id_document_url = Column(String(500))
    is_verified = Column(Boolean, default=False)
    verified_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    verified_at = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    user = relationship("User", back_populates="leader_profile")
    leadership_assignments = relationship("LeadershipAssignment", back_populates="leader")
    training_enrollments = relationship("TrainingEnrollment", back_populates="leader")
    weekly_reports = relationship("WeeklyReport", back_populates="reporter")

class LeadershipAssignment(Base):
    """Leadership positions assigned to leaders in communities"""
    __tablename__ = "leadership_assignments"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    community_id = Column(UUID(as_uuid=True), ForeignKey("communities.id"))
    position_id = Column(UUID(as_uuid=True), ForeignKey("leadership_positions.id"))
    leader_id = Column(UUID(as_uuid=True), ForeignKey("leader_profiles.id"))
    start_date = Column(Date, nullable=False)
    end_date = Column(Date)
    is_current = Column(Boolean, default=True)
    appointment_type = Column(String(50))  # elected, appointed, traditional
    appointment_date = Column(Date)
    sworn_in_date = Column(Date)
    certificate_url = Column(String(500))
    status = Column(String(20), default="active")  # active, inactive, suspended, terminated
    notes = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    created_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    updated_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    
    community = relationship("Community", back_populates="leadership_assignments")
    position = relationship("LeadershipPosition")
    leader = relationship("LeaderProfile", back_populates="leadership_assignments")