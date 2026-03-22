"""
Training API Routes
"""

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from uuid import UUID

from app.database import get_db
from app.models.training import TrainingProgram, TrainingSession
from app.api.auth import get_current_user

router = APIRouter()

@router.get("/programs")
async def list_training_programs(db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    """List all training programs"""
    programs = db.query(TrainingProgram).filter(TrainingProgram.is_active == True).all()
    return {"total": len(programs), "programs": programs}

@router.get("/sessions")
async def list_training_sessions(db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    """List all training sessions"""
    sessions = db.query(TrainingSession).all()
    return {"total": len(sessions), "sessions": sessions}