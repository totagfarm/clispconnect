"""
Weekly Report and Helpdesk Models
"""

from sqlalchemy import Column, String, Boolean, DateTime, ForeignKey, Date, Integer, Text
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import uuid
from app.database import Base

class WeeklyReport(Base):
    """Weekly reports from community leaders"""
    __tablename__ = "weekly_reports"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    community_id = Column(UUID(as_uuid=True), ForeignKey("communities.id"))
    reporter_id = Column(UUID(as_uuid=True), ForeignKey("leader_profiles.id"))
    report_week = Column(Date, nullable=False)  # Monday of the report week
    submitted_at = Column(DateTime(timezone=True), server_default=func.now())
    status = Column(String(20), default="draft")  # draft, submitted, reviewed, approved
    is_synced = Column(Boolean, default=False)
    sync_timestamp = Column(DateTime(timezone=True))
    
    # Report Categories
    local_projects = Column(Text)
    security_incidents = Column(Text)
    disaster_incidents = Column(Text)
    public_health_trends = Column(Text)
    infrastructure_needs = Column(Text)
    
    # Attachments (JSON arrays of URLs)
    photos = Column(JSONB, default=[])
    audio_recordings = Column(JSONB, default=[])
    documents = Column(JSONB, default=[])
    gps_points = Column(JSONB, default=[])
    
    # Review
    reviewed_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    reviewed_at = Column(DateTime(timezone=True))
    review_notes = Column(Text)
    priority_score = Column(Integer, default=0)  # 0-10
    escalation_required = Column(Boolean, default=False)
    
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
    
    community = relationship("Community", back_populates="weekly_reports")
    reporter = relationship("LeaderProfile", back_populates="weekly_reports")

class ReportCategory(Base):
    """Report classification categories"""
    __tablename__ = "report_categories"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(100), nullable=False)
    description = Column(String)
    severity_level = Column(String(20))  # low, medium, high, critical
    color_code = Column(String(7))  # hex color for dashboard
    display_order = Column(Integer)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class HelpdeskTicket(Base):
    """Support tickets"""
    __tablename__ = "helpdesk_tickets"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    ticket_number = Column(String(20), unique=True)
    submitted_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    category = Column(String(100))  # technical, verification, training, general
    subject = Column(String(200), nullable=False)
    description = Column(Text, nullable=False)
    priority = Column(String(20), default="medium")  # low, medium, high, urgent
    status = Column(String(20), default="open")  # open, in_progress, resolved, closed
    assigned_to = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    resolved_by = Column(UUID(as_uuid=True), ForeignKey("users.id"))
    resolved_at = Column(DateTime(timezone=True))
    resolution_notes = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())