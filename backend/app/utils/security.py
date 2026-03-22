"""
Security Utilities
"""

import secrets
import hashlib
from datetime import datetime, timedelta

def generate_verification_token() -> str:
    """Generate a secure verification token"""
    return secrets.token_urlsafe(32)

def hash_file(file_content: bytes) -> str:
    """Generate SHA256 hash of file content"""
    return hashlib.sha256(file_content).hexdigest()

def sanitize_input(text: str) -> str:
    """Sanitize user input"""
    if not text:
        return ""
    return text.strip()[:1000]