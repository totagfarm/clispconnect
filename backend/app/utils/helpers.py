"""
Helper Functions
"""

from datetime import datetime, date, timedelta
from typing import Optional

def get_week_start(d: date) -> date:
    """Get Monday of the week for a given date"""
    return d - timedelta(days=d.weekday())

def format_phone_number(phone: str) -> Optional[str]:
    """Format Liberian phone number"""
    if not phone:
        return None
    # Remove all non-digits
    digits = ''.join(filter(str.isdigit, phone))
    # Add Liberia country code if missing
    if digits.startswith('0'):
        digits = '231' + digits[1:]
    elif not digits.startswith('231'):
        digits = '231' + digits
    return '+' + digits if len(digits) >= 10 else None