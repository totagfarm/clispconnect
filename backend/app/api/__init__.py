"""
API Routers
"""

from .auth import router as auth_router
from .communities import router as communities_router
from .leaders import router as leaders_router
from .training import router as training_router
from .reports import router as reports_router
from .dashboard import router as dashboard_router

__all__ = [
    "auth_router",
    "communities_router",
    "leaders_router",
    "training_router",
    "reports_router",
    "dashboard_router"
]