-- CLISPConnect Database Schema
-- PostgreSQL 15+ with PostGIS 3.0+
-- For Liberia Community Leadership Platform

-- Enable PostGIS extension
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- CORE TABLES
-- =====================================================

-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role_id UUID REFERENCES roles(id),
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);

-- Roles Table
CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    permissions JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Counties Table (15 Counties of Liberia)
CREATE TABLE counties (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) UNIQUE,
    capital VARCHAR(100),
    population INTEGER,
    area_sq_km DECIMAL(10,2),
    geometry GEOMETRY(MULTIPOLYGON, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Districts Table
CREATE TABLE districts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    county_id UUID REFERENCES counties(id),
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) UNIQUE,
    geometry GEOMETRY(MULTIPOLYGON, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Clans Table
CREATE TABLE clans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    district_id UUID REFERENCES districts(id),
    name VARCHAR(100) NOT NULL,
    geometry GEOMETRY(MULTIPOLYGON, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Communities Table
CREATE TABLE communities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clan_id UUID REFERENCES clans(id),
    name VARCHAR(200) NOT NULL,
    code VARCHAR(20) UNIQUE,
    community_type VARCHAR(50), -- town, village, settlement
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    geometry GEOMETRY(POINT, 4326),
    population INTEGER,
    households INTEGER,
    status VARCHAR(20) DEFAULT 'pending', -- pending, verified, active, inactive
    registration_date DATE,
    verification_date DATE,
    verified_by UUID REFERENCES users(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);

-- Leadership Positions Table (Configurable per community)
CREATE TABLE leadership_positions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL, -- Chief, Elder, Women Leader, Youth Leader, etc.
    description TEXT,
    level VARCHAR(50), -- community, clan, district, county
    is_elected BOOLEAN DEFAULT false,
    term_months INTEGER DEFAULT 12,
    gender_requirement VARCHAR(20), -- male, female, any
    min_age INTEGER,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Leader Profiles Table
CREATE TABLE leader_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(20), -- male, female, other
    phone VARCHAR(20),
    email VARCHAR(255),
    education_level VARCHAR(100),
    occupation VARCHAR(200),
    languages_spoken TEXT[],
    photo_url VARCHAR(500),
    id_document_url VARCHAR(500),
    is_verified BOOLEAN DEFAULT false,
    verified_by UUID REFERENCES users(id),
    verified_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Leadership Assignments Table
CREATE TABLE leadership_assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    community_id UUID REFERENCES communities(id),
    position_id UUID REFERENCES leadership_positions(id),
    leader_id UUID REFERENCES leader_profiles(id),
    start_date DATE NOT NULL,
    end_date DATE,
    is_current BOOLEAN DEFAULT true,
    appointment_type VARCHAR(50), -- elected, appointed, traditional
    appointment_date DATE,
    sworn_in_date DATE,
    certificate_url VARCHAR(500),
    status VARCHAR(20) DEFAULT 'active', -- active, inactive, suspended, terminated
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id)
);

-- Verification Requests Table
CREATE TABLE verification_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    community_id UUID REFERENCES communities(id),
    request_type VARCHAR(50), -- community_registration, leadership_structure, leader_profile
    submitted_by UUID REFERENCES users(id),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending', -- pending, under_review, approved, rejected
    reviewer_id UUID REFERENCES users(id),
    reviewed_at TIMESTAMP,
    review_notes TEXT,
    approval_document_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Training Programs Table
CREATE TABLE training_programs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    category VARCHAR(100), -- governance, leadership, conflict_resolution, etc.
    duration_days INTEGER,
    is_certified BOOLEAN DEFAULT false,
    certification_body VARCHAR(200),
    curriculum JSONB,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Training Sessions Table
CREATE TABLE training_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    program_id UUID REFERENCES training_programs(id),
    name VARCHAR(200) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    location VARCHAR(200),
    county_id UUID REFERENCES counties(id),
    district_id UUID REFERENCES districts(id),
    trainer_id UUID REFERENCES users(id),
    max_participants INTEGER,
    status VARCHAR(20) DEFAULT 'scheduled', -- scheduled, ongoing, completed, cancelled
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Training Enrollments Table
CREATE TABLE training_enrollments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID REFERENCES training_sessions(id),
    leader_id UUID REFERENCES leader_profiles(id),
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'enrolled', -- enrolled, attended, completed, dropped_out
    attendance_score DECIMAL(5,2),
    assessment_score DECIMAL(5,2),
    certificate_issued BOOLEAN DEFAULT false,
    certificate_url VARCHAR(500),
    certificate_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Weekly Reports Table
CREATE TABLE weekly_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    community_id UUID REFERENCES communities(id),
    reporter_id UUID REFERENCES leader_profiles(id),
    report_week DATE NOT NULL, -- Monday of the report week
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'draft', -- draft, submitted, reviewed, approved
    is_synced BOOLEAN DEFAULT false,
    sync_timestamp TIMESTAMP,
    
    -- Report Categories
    local_projects TEXT,
    security_incidents TEXT,
    disaster_incidents TEXT,
    public_health_trends TEXT,
    infrastructure_needs TEXT,
    
    -- Attachments
    photos JSONB DEFAULT '[]',
    audio_recordings JSONB DEFAULT '[]',
    documents JSONB DEFAULT '[]',
    gps_points JSONB DEFAULT '[]',
    
    -- Review
    reviewed_by UUID REFERENCES users(id),
    reviewed_at TIMESTAMP,
    review_notes TEXT,
    priority_score INTEGER DEFAULT 0, -- 0-10
    escalation_required BOOLEAN DEFAULT false,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Report Categories Table (For Classification)
CREATE TABLE report_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    severity_level VARCHAR(20), -- low, medium, high, critical
    color_code VARCHAR(7), -- hex color for dashboard
    display_order INTEGER,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Helpdesk Tickets Table
CREATE TABLE helpdesk_tickets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ticket_number VARCHAR(20) UNIQUE,
    submitted_by UUID REFERENCES users(id),
    category VARCHAR(100), -- technical, verification, training, general
    subject VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'medium', -- low, medium, high, urgent
    status VARCHAR(20) DEFAULT 'open', -- open, in_progress, resolved, closed
    assigned_to UUID REFERENCES users(id),
    resolved_by UUID REFERENCES users(id),
    resolved_at TIMESTAMP,
    resolution_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit Logs Table
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notifications Table
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    type VARCHAR(50), -- email, sms, in_app
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    action_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- System Settings Table
CREATE TABLE system_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    key VARCHAR(100) UNIQUE NOT NULL,
    value JSONB NOT NULL,
    description TEXT,
    updated_by UUID REFERENCES users(id),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role_id);
CREATE INDEX idx_communities_county ON communities(clan_id);
CREATE INDEX idx_communities_status ON communities(status);
CREATE INDEX idx_communities_geometry ON communities USING GIST(geometry);
CREATE INDEX idx_counties_geometry ON counties USING GIST(geometry);
CREATE INDEX idx_districts_geometry ON districts USING GIST(geometry);
CREATE INDEX idx_leaderships_community ON leadership_assignments(community_id);
CREATE INDEX idx_leaderships_leader ON leadership_assignments(leader_id);
CREATE INDEX idx_leaderships_current ON leadership_assignments(is_current);
CREATE INDEX idx_reports_community ON weekly_reports(community_id);
CREATE INDEX idx_reports_week ON weekly_reports(report_week);
CREATE INDEX idx_reports_status ON weekly_reports(status);
CREATE INDEX idx_training_sessions_date ON training_sessions(start_date);
CREATE INDEX idx_enrollments_leader ON training_enrollments(leader_id);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_created ON audit_logs(created_at);

-- =====================================================
-- VIEWS FOR DASHBOARDS
-- =====================================================

-- Community Summary View
CREATE VIEW v_community_summary AS
SELECT 
    c.id,
    c.name,
    c.status,
    c.population,
    c.households,
    cl.name as clan_name,
    d.name as district_name,
    co.name as county_name,
    COUNT(la.id) as leader_count,
    COUNT(CASE WHEN la.is_current = true THEN 1 END) as current_leader_count,
    c.created_at as registration_date,
    c.verification_date
FROM communities c
LEFT JOIN clans cl ON c.clan_id = cl.id
LEFT JOIN districts d ON cl.district_id = d.id
LEFT JOIN counties co ON d.county_id = co.id
LEFT JOIN leadership_assignments la ON c.id = la.community_id
GROUP BY c.id, cl.name, d.name, co.name;

-- Leadership Diversity View
CREATE VIEW v_leadership_diversity AS
SELECT 
    c.id as community_id,
    c.name as community_name,
    COUNT(la.id) as total_leaders,
    COUNT(CASE WHEN lp.gender_requirement = 'female' THEN 1 END) as women_leaders,
    COUNT(CASE WHEN lp.gender_requirement = 'female' THEN 1 END)::float / 
        NULLIF(COUNT(la.id), 0) * 100 as women_percentage,
    COUNT(CASE WHEN lp.name LIKE '%Youth%' THEN 1 END) as youth_leaders,
    COUNT(CASE WHEN lp.name LIKE '%Disability%' THEN 1 END) as pwd_leaders
FROM communities c
LEFT JOIN leadership_assignments la ON c.id = la.community_id AND la.is_current = true
LEFT JOIN leadership_positions lp ON la.position_id = lp.id
WHERE c.status = 'active'
GROUP BY c.id, c.name;

-- Weekly Reporting Summary View
CREATE VIEW v_weekly_reporting_summary AS
SELECT 
    DATE_TRUNC('week', wr.report_week) as week_start,
    COUNT(wr.id) as total_reports,
    COUNT(CASE WHEN wr.status = 'submitted' THEN 1 END) as submitted_reports,
    COUNT(CASE WHEN wr.status = 'approved' THEN 1 END) as approved_reports,
    COUNT(CASE WHEN wr.escalation_required = true THEN 1 END) as escalated_reports,
    COUNT(DISTINCT wr.community_id) as reporting_communities,
    AVG(wr.priority_score) as avg_priority_score
FROM weekly_reports wr
GROUP BY DATE_TRUNC('week', wr.report_week)
ORDER BY week_start DESC;

-- Training Completion View
CREATE VIEW v_training_completion AS
SELECT 
    tp.id as program_id,
    tp.name as program_name,
    COUNT(DISTINCT te.leader_id) as total_participants,
    COUNT(CASE WHEN te.status = 'completed' THEN 1 END) as completed,
    COUNT(CASE WHEN te.certificate_issued = true THEN 1 END) as certified,
    AVG(te.assessment_score) as avg_score,
    ts.start_date,
    ts.end_date
FROM training_programs tp
LEFT JOIN training_sessions ts ON tp.id = ts.program_id
LEFT JOIN training_enrollments te ON ts.id = te.session_id
GROUP BY tp.id, tp.name, ts.start_date, ts.end_date;

-- =====================================================
-- INITIAL DATA SEEDS
-- =====================================================

-- Insert Roles
INSERT INTO roles (id, name, description, permissions) VALUES
('00000000-0000-0000-0000-000000000001', 'super_admin', 'Full system access', '{"all": true}'),
('00000000-0000-0000-0000-000000000002', 'mia_admin', 'Ministry of Internal Affairs admin', '{"communities": ["read", "write", "verify"], "leaders": ["read", "write"], "reports": ["read", "write"], "training": ["read"], "dashboard": ["read"]}'),
('00000000-0000-0000-0000-000000000003', 'clef_admin', 'CLEF national admin', '{"communities": ["read", "write", "verify"], "leaders": ["read", "write"], "reports": ["read", "write"], "training": ["read", "write"], "dashboard": ["read"]}'),
('00000000-0000-0000-0000-000000000004', 'county_coordinator', 'County-level coordinator', '{"communities": ["read", "write"], "leaders": ["read"], "reports": ["read", "write"], "training": ["read"], "dashboard": ["read"]}'),
('00000000-0000-0000-0000-000000000005', 'district_coordinator', 'District-level coordinator', '{"communities": ["read", "write"], "leaders": ["read"], "reports": ["read", "write"], "training": ["read"], "dashboard": ["read"]}'),
('00000000-0000-0000-0000-000000000006', 'registry_officer', 'Registry data entry officer', '{"communities": ["read", "write"], "leaders": ["read", "write"], "reports": ["read"], "training": ["read"], "dashboard": ["read"]}'),
('00000000-0000-0000-0000-000000000007', 'community_desk', 'Helpdesk officer', '{"communities": ["read"], "leaders": ["read"], "reports": ["read"], "training": ["read"], "helpdesk": ["read", "write"], "dashboard": ["read"]}'),
('00000000-0000-0000-0000-000000000008', 'trainer', 'Training facilitator', '{"communities": ["read"], "leaders": ["read"], "reports": ["read"], "training": ["read", "write"], "dashboard": ["read"]}'),
('00000000-0000-0000-0000-000000000009', 'community_leader', 'Registered community leader', '{"communities": ["read"], "leaders": ["read"], "reports": ["read", "write"], "training": ["read"], "dashboard": ["read"]}'),
('00000000-0000-0000-0000-000000000010', 'public_visitor', 'Public portal user', '{"communities": ["read"], "leaders": ["read"], "reports": [], "training": [], "dashboard": []}');

-- Insert Leadership Positions (Standard Model)
INSERT INTO leadership_positions (name, description, level, is_elected, term_months, gender_requirement, min_age, display_order) VALUES
('Paramount Chief', 'Traditional head of chiefdom', 'chiefdom', true, 120, 'any', 30, 1),
('Town Chief', 'Traditional head of town/community', 'community', true, 60, 'any', 25, 2),
('Elder', 'Community elder council member', 'community', true, 60, 'any', 40, 3),
('Women Leader', 'Women''s representative', 'community', true, 36, 'female', 21, 4),
('Youth Leader', 'Youth representative', 'community', true, 24, 'any', 18, 5),
('Person with Disability Representative', 'PWD representative', 'community', true, 36, 'any', 18, 6),
('Community Secretary', 'Record keeper and communicator', 'community', false, 36, 'any', 21, 7),
('Peace Advisor', 'Conflict resolution advisor', 'community', false, 36, 'any', 30, 8),
('Development Coordinator', 'Community development projects', 'community', false, 36, 'any', 25, 9),
('Health Liaison', 'Public health communication', 'community', false, 36, 'any', 21, 10);

-- Insert Report Categories
INSERT INTO report_categories (name, description, severity_level, color_code, display_order) VALUES
('Community Project Update', 'Updates on local development projects', 'low', '#28a745', 1),
('Security Incident', 'Crime, conflict, or security concerns', 'high', '#dc3545', 2),
('Disaster Incident', 'Fire, flood, storm, or other disasters', 'critical', '#dc3545', 3),
('Public Health Trend', 'Disease outbreaks, health concerns', 'medium', '#ffc107', 4),
('Infrastructure Need', 'Roads, water, electricity needs', 'medium', '#17a2b8', 5),
('Education Issue', 'School-related concerns', 'low', '#6f42c1', 6),
('Economic Activity', 'Market, trade, livelihood updates', 'low', '#20c997', 7),
('Environmental Concern', 'Deforestation, pollution, etc.', 'medium', '#28a745', 8);

-- Insert 15 Counties of Liberia
INSERT INTO counties (id, name, code, capital, population, area_sq_km) VALUES
('11111111-1111-1111-1111-111111111101', 'Bomi', 'LR-BM', 'Tubmanburg', 84119, 1942),
('11111111-1111-1111-1111-111111111102', 'Bong', 'LR-BG', 'Gbarnga', 333481, 8772),
('11111111-1111-1111-1111-111111111103', 'Gbarpolu', 'LR-GP', 'Bopolu', 83388, 9689),
('11111111-1111-1111-1111-111111111104', 'Grand Bassa', 'LR-GB', 'Buchanan', 221693, 7936),
('11111111-1111-1111-1111-111111111105', 'Grand Cape Mount', 'LR-CM', 'Robertsport', 127076, 5162),
('11111111-1111-1111-1111-111111111106', 'Grand Gedeh', 'LR-GG', 'Zwedru', 125258, 10484),
('11111111-1111-1111-1111-111111111107', 'Grand Kru', 'LR-GK', 'Barclayville', 57913, 3895),
('11111111-1111-1111-1111-111111111108', 'Lofa', 'LR-LO', 'Voinjama', 276863, 9982),
('11111111-1111-1111-1111-111111111109', 'Margibi', 'LR-MG', 'Kakata', 209923, 2616),
('11111111-1111-1111-1111-111111111110', 'Maryland', 'LR-MY', 'Harper', 135938, 2297),
('11111111-1111-1111-1111-111111111111', 'Montserrado', 'LR-MO', 'Bensonville', 1118241, 1909),
('11111111-1111-1111-1111-111111111112', 'Nimba', 'LR-NI', 'Sanniquellie', 462026, 11551),
('11111111-1111-1111-1111-111111111113', 'River Cess', 'LR-RC', 'Cestos City', 71509, 5594),
('11111111-1111-1111-1111-111111111114', 'River Gee', 'LR-RG', 'Fish Town', 66789, 5113),
('11111111-1111-1111-1111-111111111115', 'Sinoe', 'LR-SI', 'Greenville', 102391, 10137);

-- Insert District #10, Montserrado County (Pilot District)
INSERT INTO districts (county_id, name, code) VALUES
('11111111-1111-1111-1111-111111111111', 'District #10', 'LR-MO-10');

-- Insert System Settings
INSERT INTO system_settings (key, value, description) VALUES
('pilot_district_id', '"11111111-1111-1111-1111-111111111111"', 'District #10, Montserrado County (Pilot)'),
('pilot_start_date', '"2026-01-01"', 'Pilot program start date'),
('pilot_end_date', '"2026-06-30"', 'Pilot program end date'),
('pilot_target_communities', '75', 'Target communities for pilot'),
('pilot_target_leaders', '75', 'Target leaders for pilot'),
('reporting_deadline_day', '7', 'Day of week for report submission (0=Sunday)'),
('enable_public_registry', 'true', 'Enable public registry portal'),
('require_leader_verification', 'true', 'Require MIA verification for leaders'),
('enable_offline_reporting', 'true', 'Enable offline mobile reporting');

-- =====================================================
-- TRIGGERS FOR AUDIT TRAILS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply to all tables with updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_communities_updated_at BEFORE UPDATE ON communities FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_leadership_assignments_updated_at BEFORE UPDATE ON leadership_assignments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_weekly_reports_updated_at BEFORE UPDATE ON weekly_reports FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- COMMENTS FOR DOCUMENTATION
-- =====================================================

COMMENT ON TABLE communities IS 'All registered communities in Liberia with GIS data';
COMMENT ON TABLE leadership_assignments IS 'Current and historical leadership positions in communities';
COMMENT ON TABLE weekly_reports IS 'Weekly digital reports from community leaders';
COMMENT ON TABLE training_enrollments IS 'Training participation and completion records';
COMMENT ON TABLE verification_requests IS 'Verification workflow for communities and leaders';
