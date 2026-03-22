"""
CLISPConnect API - Main Application Entry Point
Community Leadership Identification and Structuring Program - Liberia
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from datetime import datetime

from app.config import settings
from app.database import Base, engine
from app.api import auth, communities, leaders, training, reports, dashboard

# Create database tables
Base.metadata.create_all(bind=engine)

# Initialize FastAPI app
app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    description=settings.APP_DESCRIPTION,
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json"
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API routers
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(communities.router, prefix="/api/communities", tags=["Communities"])
app.include_router(leaders.router, prefix="/api/leaders", tags=["Leaders"])
app.include_router(training.router, prefix="/api/training", tags=["Training"])
app.include_router(reports.router, prefix="/api/reports", tags=["Reports"])
app.include_router(dashboard.router, prefix="/api/dashboard", tags=["Dashboard"])

@app.get("/")
async def root():
    """Root endpoint - API information"""
    return {
        "service": "CLISPConnect API",
        "version": settings.APP_VERSION,
        "status": "running",
        "program": "Community Leadership Identification and Structuring Program",
        "organization": "Community Leadership Empowerment Forum (CLEF)",
        "partner": "Ministry of Internal Affairs (MIA), Liberia",
        "pilot": "District #10, Montserrado County",
        "documentation": "/docs",
        "health": "/health"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
        "version": settings.APP_VERSION
    }

@app.get("/api/info")
async def api_info():
    """API information endpoint"""
    return {
        "name": settings.APP_NAME,
        "version": settings.APP_VERSION,
        "description": settings.APP_DESCRIPTION,
        "endpoints": {
            "authentication": "/api/auth",
            "communities": "/api/communities",
            "leaders": "/api/leaders",
            "training": "/api/training",
            "reports": "/api/reports",
            "dashboard": "/api/dashboard",
            "documentation": "/docs",
            "health": "/health"
        },
        "pilot_info": {
            "district": "District #10",
            "county": "Montserrado County",
            "start_date": settings.PILOT_START_DATE,
            "end_date": settings.PILOT_END_DATE,
            "target_communities": 75,
            "target_leaders": 75
        }
    }

@app.exception_handler(Exception)
async def global_exception_handler(request, exc):
    """Global exception handler"""
    return JSONResponse(
        status_code=500,
        content={
            "error": "Internal server error",
            "detail": str(exc) if settings.DEBUG else "An unexpected error occurred"
        }
    )

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)