# CLISPConnect Backend API

FastAPI backend for CLISPConnect platform.

## Setup

```bash
# Create virtual environment
python -m venv venv

# Activate
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run development server
uvicorn app.main:app --reload

# Run production server
uvicorn app.main:app --host 0.0.0.0 --port 8080