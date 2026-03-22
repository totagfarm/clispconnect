"""
Communities API Routes
"""

from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import Optional
from uuid import UUID

from app.database import get_db
from app.models.community import Community, County, District, Clan
from app.schemas.community import CommunityCreate, CommunityUpdate, CommunityResponse, CommunityListResponse
from app.api.auth import get_current_user

router = APIRouter()

@router.get("/", response_model=CommunityListResponse)
async def list_communities(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    county_id: Optional[UUID] = None,
    district_id: Optional[UUID] = None,
    status: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """List all communities with pagination and filters"""
    
    query = db.query(Community)
    
    if county_id:
        query = query.join(Clan).join(District).filter(District.county_id == county_id)
    
    if district_id:
        query = query.join(Clan).filter(Clan.district_id == district_id)
    
    if status:
        query = query.filter(Community.status == status)
    
    total = query.count()
    communities = query.offset((page - 1) * page_size).limit(page_size).all()
    
    return CommunityListResponse(
        total=total,
        page=page,
        page_size=page_size,
        communities=[CommunityResponse.from_orm(c) for c in communities]
    )

@router.get("/{community_id}", response_model=CommunityResponse)
async def get_community(
    community_id: UUID,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """Get a specific community by ID"""
    
    community = db.query(Community).filter(Community.id == community_id).first()
    
    if not community:
        raise HTTPException(status_code=404, detail="Community not found")
    
    return CommunityResponse.from_orm(community)

@router.post("/", response_model=CommunityResponse, status_code=status.HTTP_201_CREATED)
async def create_community(
    community: CommunityCreate,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """Create a new community"""
    
    clan = db.query(Clan).filter(Clan.id == community.clan_id).first()
    if not clan:
        raise HTTPException(status_code=404, detail="Clan not found")
    
    db_community = Community(
        **community.dict(),
        status="pending",
        created_by=current_user.id
    )
    
    db.add(db_community)
    db.commit()
    db.refresh(db_community)
    
    return CommunityResponse.from_orm(db_community)

@router.get("/counties/list")
async def list_counties(db: Session = Depends(get_db)):
    """List all counties in Liberia"""
    
    counties = db.query(County).all()
    
    return {
        "total": len(counties),
        "counties": [
            {
                "id": str(c.id),
                "name": c.name,
                "code": c.code,
                "capital": c.capital,
                "population": c.population
            }
            for c in counties
        ]
    }

@router.get("/districts/{county_id}")
async def list_districts(county_id: UUID, db: Session = Depends(get_db)):
    """List all districts in a county"""
    
    districts = db.query(District).filter(District.county_id == county_id).all()
    
    return {
        "county_id": str(county_id),
        "total": len(districts),
        "districts": [
            {"id": str(d.id), "name": d.name, "code": d.code}
            for d in districts
        ]
    }