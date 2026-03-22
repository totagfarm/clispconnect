-- CLISPConnect Seed Data for Liberia
-- Run after schema.sql

-- Insert District #10 Communities (Pilot - 75 Communities)
INSERT INTO communities (clan_id, name, code, community_type, latitude, longitude, population, households, status) VALUES
-- Sample of 10 communities (expand to 75 for full pilot)
('22222222-2222-2222-2222-222222222201', 'Bensonville', 'LR-MO-10-001', 'town', 6.3667, -10.7333, 5000, 1000, 'active'),
('22222222-2222-2222-2222-222222222201', 'Tubmanburg', 'LR-MO-10-002', 'town', 6.4833, -10.8167, 3500, 700, 'active'),
('22222222-2222-2222-2222-222222222201', 'Kakata', 'LR-MO-10-003', 'town', 6.5333, -10.3500, 4200, 840, 'active'),
('22222222-2222-2222-2222-222222222201', 'Paynesville', 'LR-MO-10-004', 'town', 6.3000, -10.7500, 6000, 1200, 'active'),
('22222222-2222-2222-2222-222222222201', 'Careysburg', 'LR-MO-10-005', 'town', 6.4167, -10.6833, 2800, 560, 'active'),
('22222222-2222-2222-2222-222222222201', 'Arthington', 'LR-MO-10-006', 'village', 6.4500, -10.7000, 1500, 300, 'active'),
('22222222-2222-2222-2222-222222222201', 'New Georgia', 'LR-MO-10-007', 'village', 6.3833, -10.7167, 1200, 240, 'active'),
('22222222-2222-2222-2222-222222222201', 'Barnesville', 'LR-MO-10-008', 'village', 6.4000, -10.7333, 1800, 360, 'active'),
('22222222-2222-2222-2222-222222222201', 'Tombo', 'LR-MO-10-009', 'village', 6.2833, -10.8000, 900, 180, 'active'),
('22222222-2222-2222-2222-222222222201', 'Kendeja', 'LR-MO-10-010', 'village', 6.4333, -10.7500, 1100, 220, 'active');

-- Insert Sample Leaders
INSERT INTO leader_profiles (first_name, last_name, gender, phone, education_level, occupation, is_verified) VALUES
('John', 'Doe', 'male', '+231770000001', 'High School', 'Community Chief', true),
('Mary', 'Johnson', 'female', '+231770000002', 'College', 'Women Leader', true),
('James', 'Williams', 'male', '+231770000003', 'High School', 'Youth Leader', true),
('Sarah', 'Brown', 'female', '+231770000004', 'University', 'Community Secretary', true),
('David', 'Smith', 'male', '+231770000005', 'High School', 'Elder', true);

-- Insert Leadership Assignments
INSERT INTO leadership_assignments (community_id, position_id, leader_id, start_date, is_current, appointment_type) VALUES
('33333333-3333-3333-3333-333333333301', '44444444-4444-4444-4444-444444444402', '55555555-5555-5555-5555-555555555501', '2026-01-01', true, 'elected'),
('33333333-3333-3333-3333-333333333301', '44444444-4444-4444-4444-444444444405', '55555555-5555-5555-5555-555555555502', '2026-01-01', true, 'elected'),
('33333333-3333-3333-3333-333333333301', '44444444-4444-4444-4444-444444444406', '55555555-5555-5555-5555-555555555503', '2026-01-01', true, 'elected');

-- Insert Sample Weekly Reports
INSERT INTO weekly_reports (community_id, reporter_id, report_week, local_projects, security_incidents, infrastructure_needs, status, priority_score) VALUES
('33333333-3333-3333-3333-333333333301', '55555555-5555-5555-5555-555555555501', '2026-03-17', 'Road construction ongoing', 'None', 'Need water well', 'submitted', 3),
('33333333-3333-3333-3333-333333333302', '55555555-5555-5555-5555-555555555502', '2026-03-17', 'School renovation complete', 'Minor theft reported', 'Need electricity', 'submitted', 5),
('33333333-3333-3333-3333-333333333303', '55555555-5555-5555-5555-555555555503', '2026-03-17', 'Market expansion', 'None', 'Need clinic', 'submitted', 7);

-- Insert Training Programs
INSERT INTO training_programs (name, description, category, duration_days, is_certified) VALUES
('Community Leadership Basics', 'Introduction to community leadership and governance', 'leadership', 5, true),
('Conflict Resolution', 'Mediation and peacebuilding skills', 'governance', 3, true),
('Financial Management', 'Basic accounting for community projects', 'governance', 2, true),
('Gender and Inclusion', 'Ensuring women and PwD participation', 'inclusion', 2, true),
('Digital Reporting', 'Using CLISPConnect mobile app', 'technology', 1, false);

-- Insert Training Sessions for Pilot
INSERT INTO training_sessions (program_id, name, start_date, end_date, location, district_id, status) VALUES
('66666666-6666-6666-6666-666666666601', 'District #10 Leadership Training - Batch 1', '2026-02-01', '2026-02-05', 'Bensonville Community Center', '11111111-1111-1111-1111-111111111111', 'completed'),
('66666666-6666-6666-6666-666666666602', 'District #10 Leadership Training - Batch 2', '2026-03-01', '2026-03-05', 'Tubmanburg Town Hall', '11111111-1111-1111-1111-111111111111', 'ongoing'),
('66666666-6666-6666-6666-666666666603', 'District #10 Conflict Resolution', '2026-04-01', '2026-04-03', 'Kakata Community Hall', '11111111-1111-1111-1111-111111111111', 'scheduled');

-- Insert Training Enrollments
INSERT INTO training_enrollments (session_id, leader_id, status, attendance_score, assessment_score, certificate_issued) VALUES
('77777777-7777-7777-7777-777777777701', '55555555-5555-5555-5555-555555555501', 'completed', 95.00, 88.00, true),
('77777777-7777-7777-7777-777777777701', '55555555-5555-5555-5555-555555555502', 'completed', 90.00, 85.00, true),
('77777777-7777-7777-7777-777777777701', '55555555-5555-5555-5555-555555555503', 'completed', 88.00, 82.00, true),
('77777777-7777-7777-7777-777777777702', '55555555-5555-5555-5555-555555555504', 'enrolled', NULL, NULL, false),
('77777777-7777-7777-7777-777777777702', '55555555-5555-5555-5555-555555555505', 'enrolled', NULL, NULL, false);