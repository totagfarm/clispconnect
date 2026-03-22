"""
Training Program and Enrollment Models
"""

from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey, Date, Integer, Float
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import uuid
from app.database import Base

class TrainingProgram(Base):
    """Training programs/curriculum"""
    __tablename__ = "training_programs"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(200), nullable=False)
    description = Column(String)
    category = Column(String(100))  # governance, leadership, conflict_resolution, etc.
    duration_days = Column(Integer)
    is_certified = Column(Boolean, default=False)
    certification_body = Column(String(200))
    curriculum = Column(JSONB)  # Course modules
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

class TrainingSession(Base):
    """Specific training session instances"""
    __tablename__ = "training_sessions"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    program_id = Column(UUID(as_uuid=True), ForeignKey("training_programs.id"))
    name = Column(String(200), nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    location = Column(String(200))
    county_id = Column(UUID(as_uuid=True), ForeignKey("counties.id"))
    district_id = Column(UUID(as_uuid=True), ForeignKey("districts.id"))
    trainer_id = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    max_participants = Column(Integer)
    status = Column(String(20), default="scheduled")  # scheduled, ongoing, completed, cancelled
    notes = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    program = relationship("TrainingProgram")
    enrollments = relationship("TrainingEnrollment", back_populates="session")

class TrainingEnrollment(Base):
    """Leader enrollment in training sessions"""
    __tablename__ = "training_enrollments"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    session_id = Column(UUID(as_uuid=True), ForeignKey("training_sessions.id"))
    leader_id = Column(UUID(as_uuid=True), ForeignKey("leader_profiles.id"))
    enrollment_date = Column(DateTime(timezone=True), server_default=func.now())
    status = Column(String(20), default="enrolled")  # enrolled, attended, completed, dropped_out
    attendance_score = Column(Float)
    assessment_score = Column(Float)
    certificate_issued = Column(Boolean, default=False)
    certificate_url = Column(String(500))
    certificate_date = Column(Date)
    notes = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    session = relationship("TrainingSession", back_populates="enrollments")
    leader = relationship("LeaderProfile", back_populates="training_enrollments")