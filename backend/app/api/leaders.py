"""
Leaders API Routes
"""

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from uuid import UUID

from app.database import get_db
from app.models.leader import LeaderProfile, LeadershipAssignment
from app.schemas.leader import LeaderProfileCreate, LeaderProfileResponse
from app.api.auth import get_current_user

router = APIRouter()

@router.get("/", response_model=list[LeaderProfileResponse])
async def list_leaders(
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """List all leaders"""
    leaders = db.query(LeaderProfile).all()
    return [LeaderProfileResponse.from_orm(l) for l in leaders]

@router.get("/{leader_id}", response_model=LeaderProfileResponse)
async def get_leader(
    leader_id: UUID,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """Get a specific leader by ID"""
    
    leader = db.query(LeaderProfile).filter(LeaderProfile.id == leader_id).first()
    
    if not leader:
        raise HTTPException(status_code=404, detail="Leader not found")
    
    return LeaderProfileResponse.from_orm(leader)