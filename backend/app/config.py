"""
Application Configuration
"""

from pydantic_settings import BaseSettings
from functools import lru_cache
from typing import List

class Settings(BaseSettings):
    # App Settings
    APP_NAME: str = "CLISPConnect API"
    APP_VERSION: str = "1.0.0"
    APP_DESCRIPTION: str = "Community Leadership Identification and Structuring Program - Liberia"
    DEBUG: bool = False
    
    # Database
    DATABASE_URL: str = "postgresql://clispuser:password@localhost:5432/clispconnect"
    DATABASE_POOL_SIZE: int = 10
    DATABASE_MAX_OVERFLOW: int = 20
    
    # Security
    SECRET_KEY: str = "your-secret-key-change-in-production-min-32-chars"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7
    
    # CORS
    CORS_ORIGINS: List[str] = [
        "https://www.clispconnect.com",
        "https://api.clispconnect.com",
        "https://clispconnect.com",
        "http://localhost:3000",
        "http://localhost:8000"
    ]
    
    # File Storage
    STORAGE_BUCKET: str = "clispconnect-storage"
    MAX_UPLOAD_SIZE: int = 10 * 1024 * 1024  # 10MB
    
    # Email (Optional)
    SMTP_HOST: str = ""
    SMTP_PORT: int = 587
    SMTP_USER: str = ""
    SMTP_PASSWORD: str = ""
    EMAIL_FROM: str = "noreply@clispconnect.com"
    
    # Pilot Configuration
    PILOT_DISTRICT_ID: str = "11111111-1111-1111-1111-111111111111"
    PILOT_START_DATE: str = "2026-01-01"
    PILOT_END_DATE: str = "2026-06-30"
    
    class Config:
        env_file = ".env"

@lru_cache()
def get_settings() -> Settings:
    return Settings()

settings = get_settings()