"""
Reports API Routes
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import Optional
from datetime import date
from uuid import UUID

from app.database import get_db
from app.models.report import WeeklyReport, ReportCategory
from app.models.community import Community
from app.schemas.report import WeeklyReportCreate, WeeklyReportUpdate, WeeklyReportResponse
from app.api.auth import get_current_user

router = APIRouter()

@router.get("/", response_model=list[WeeklyReportResponse])
async def list_reports(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    community_id: Optional[UUID] = None,
    status: Optional[str] = None,
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """List weekly reports with filters"""
    
    query = db.query(WeeklyReport)
    
    if community_id:
        query = query.filter(WeeklyReport.community_id == community_id)
    
    if status:
        query = query.filter(WeeklyReport.status == status)
    
    if start_date:
        query = query.filter(WeeklyReport.report_week >= start_date)
    
    if end_date:
        query = query.filter(WeeklyReport.report_week <= end_date)
    
    reports = query.order_by(WeeklyReport.report_week.desc()).offset((page - 1) * page_size).limit(page_size).all()
    
    return [WeeklyReportResponse.from_orm(r) for r in reports]

@router.post("/", response_model=WeeklyReportResponse, status_code=201)
async def create_report(
    report: WeeklyReportCreate,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """Submit a new weekly report"""
    
    community = db.query(Community).filter(Community.id == report.community_id).first()
    if not community:
        raise HTTPException(status_code=404, detail="Community not found")
    
    db_report = WeeklyReport(
        community_id=report.community_id,
        report_week=report.report_week,
        local_projects=report.local_projects,
        security_incidents=report.security_incidents,
        disaster_incidents=report.disaster_incidents,
        public_health_trends=report.public_health_trends,
        infrastructure_needs=report.infrastructure_needs,
        status="submitted",
        is_synced=True
    )
    
    db.add(db_report)
    db.commit()
    db.refresh(db_report)
    
    return WeeklyReportResponse.from_orm(db_report)

@router.get("/categories")
async def get_report_categories(db: Session = Depends(get_db)):
    """Get all report categories"""
    
    categories = db.query(ReportCategory).filter(ReportCategory.is_active == True).all()
    
    return {
        "total": len(categories),
        "categories": [
            {
                "id": str(c.id),
                "name": c.name,
                "description": c.description,
                "severity_level": c.severity_level,
                "color_code": c.color_code
            }
            for c in categories
        ]
    }