-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 06, 2024 at 02:25 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `workwave_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_activate_account` (IN `p_activation_token_hash` VARCHAR(255))   BEGIN
	SELECT * FROM
	users 
	WHERE
	activation_token_hash = p_activation_token_hash;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_projects` (IN `p_user_id` INT(11), IN `p_project_title` VARCHAR(255), IN `p_project_category` VARCHAR(255), IN `p_project_description` TEXT, IN `p_project_status` VARCHAR(50), IN `p_connect_cost` INT(11), IN `p_merit_worth` INT(11))   BEGIN
    INSERT INTO client_projects (
        user_id,
        project_title,
        project_category,
        project_description,
        project_status,
        project_connect_cost,
        project_merit_worth,
        created_at
    )
    VALUES (
        p_user_id,
        p_project_title,
        p_project_category,
        p_project_description,
        p_project_status,
        p_connect_cost,
        p_merit_worth,
        NOW()
    );
     SELECT LAST_INSERT_ID() AS project_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_user_experience` (IN `p_user_id` INT(11), IN `p_job_title` VARCHAR(255), IN `p_company_name` VARCHAR(255), IN `p_duration` VARCHAR(255))   BEGIN
	INSERT INTO freelancer_experiences (user_id, job_title, company_name, duration) VALUES (p_user_id, p_job_title, p_company_name, p_duration);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_client_projects` (IN `p_project_id` INT(11), IN `p_user_id` INT(11))   BEGIN
    DELETE FROM client_projects
    WHERE 
        project_id = p_project_id
        AND user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_users_skills` (IN `p_user_id` INT(11))   BEGIN
DELETE FROM freelancer_skills WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_user_experience` (IN `p_user_experience_id` INT(11), IN `p_user_id` INT(11))   BEGIN
	DELETE FROM freelancer_experiences WHERE user_experience_id = p_user_experience_id AND user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_user_info` (IN `p_user_id` INT(11))   BEGIN
	SELECT * FROM
	users
	WHERE
	user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_distint_user_skills` (IN `p_user_id` INT(11))   BEGIN
SELECT DISTINCT s.skill_category, s.skill_name 
          FROM freelancer_skills us 
          JOIN skills s ON us.skill_id = s.skill_id 
          WHERE us.user_id = p_user_id 
          ORDER BY s.skill_category;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_freelancers_from_v_freelancers` ()   BEGIN
    SELECT * FROM v_freelancers;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_job` ()   BEGIN
SELECT job_title_id, job_title FROM job_titles;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_projects` (IN `p_user_id` INT(11))   BEGIN
    SELECT * 
    FROM client_projects
    WHERE user_id = p_user_id
    ORDER BY created_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_project_details` (IN `p_project_id` INT(11), IN `p_user_id` INT(11))   BEGIN
    SELECT * 
    FROM client_projects
    WHERE project_id = p_project_id
      AND user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_sidebar_projects` (IN `p_user_id` INT(11))   BEGIN
    SELECT 
        project_title, 
        project_category, 
        project_status
    FROM client_projects
    WHERE user_id = p_user_id
    ORDER BY created_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_skills` ()   BEGIN
SELECT 
s.skill_id, 
s.skill_name,
s.skill_category 
FROM skills s 
ORDER BY s.skill_category, s.skill_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_skills_category` ()   BEGIN
    SELECT DISTINCT skill_category
    FROM skills
    ORDER BY skill_category;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_tasks_from_v_tasks` (IN `p_project_id` INT)   BEGIN
    SELECT * 
    FROM v_tasks 
    WHERE project_id = p_project_id
    ORDER BY created_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_user_by_email` (IN `p_email` VARCHAR(255))   BEGIN
	SELECT * FROM users
    WHERE users.email = p_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_user_by_id` (IN `p_user_id` INT(11))   BEGIN
	SELECT * FROM
	v_user_profile
	WHERE
	user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_user_by_reset_token_hash` (IN `p_reset_token_hash` VARCHAR(255))   BEGIN
	IF p_reset_token_hash = ''
	THEN
		SELECT 'please fillup all fields' as error_message;
	ELSE
		SELECT * FROM users
		WHERE reset_token_hash = p_reset_token_hash;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_user_experience_order_by_duration` (IN `p_user_id` INT(11))   BEGIN
	SELECT * FROM freelancer_experiences WHERE user_id = p_user_id ORDER BY duration DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_user_from_v_user_profile` (IN `p_user_id` INT(11))   BEGIN

SELECT * FROM v_user_profile WHERE user_id = p_user_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_user_skills` (IN `p_user_id` INT(11))   BEGIN
	SELECT skill_id FROM freelancer_skills WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insert_user_skills` (IN `p_user_id` INT(11), IN `P_skill_id` INT(11))   BEGIN
	INSERT INTO freelancer_skills (user_id, skill_id) VALUES (p_user_id, P_skill_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_project_details` (IN `p_project_id` INT)   BEGIN
    SELECT * 
    FROM client_projects
    WHERE project_id = p_project_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_signup_users` (IN `p_first_name` VARCHAR(50), IN `p_last_name` VARCHAR(50), IN `p_birthdate` DATE, IN `p_gender` VARCHAR(21), IN `p_city` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_password_hash` VARCHAR(255), IN `p_activation_token_hash` VARCHAR(255), IN `p_role` VARCHAR(255))   BEGIN
	IF p_first_name = '' OR p_last_name = '' OR p_birthdate = '' OR p_gender = '' OR p_city = '' OR p_email = '' OR p_password_hash = ''
    THEN
    SELECT 'please fillup all fields' as error_message;
	ELSE
	INSERT INTO users(users.first_name, users.last_name, users.birthdate, users.gender, users.city, users.email, users.password_hash, users.activation_token_hash, users.role)
	VALUES (p_first_name, p_last_name, p_birthdate, p_gender, p_city, p_email, p_password_hash, p_activation_token_hash, p_role);
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_activation_token` (IN `p_user_id` INT(11))   BEGIN
	UPDATE users
	SET
	activation_token_hash = NULL
	WHERE
	user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_client_projects` (IN `p_project_title` VARCHAR(255), IN `p_project_category` VARCHAR(255), IN `p_project_description` TEXT, IN `p_project_status` VARCHAR(50), IN `p_project_id` INT(11), IN `p_user_id` INT(11), IN `p_connect_cost` INT(11), IN `p_merit_worth` INT(11))   BEGIN
    UPDATE client_projects
    SET 
        project_title = p_project_title,
        project_category = p_project_category,
        project_description = p_project_description,
        project_status = p_project_status,
        project_connect_cost = p_connect_cost,
        project_merit_worth = p_merit_worth
    WHERE 
        project_id = p_project_id
        AND user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_deactivation` (IN `p_deactivation_duration` VARCHAR(255), IN `p_user_id` INT(11))   BEGIN
	UPDATE users SET
	deactivation_duration = p_deactivation_duration,
	status = "inactive"
	WHERE 
	user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_reset_token` (IN `p_reset_token_hash` VARCHAR(255), IN `p_email` VARCHAR(255))   BEGIN
	UPDATE users 
    SET reset_token_hash = p_reset_token_hash,
		reset_token_expiry = DATE_ADD(NOW(), INTERVAL 30 MINUTE)
    WHERE email = p_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_user_experience` (IN `p_job_title` VARCHAR(255), IN `p_company_name` VARCHAR(255), IN `p_duration` VARCHAR(255), IN `p_user_experience_id` INT(11), IN `p_user_id` INT(11))   BEGIN
	UPDATE freelancer_experiences 
              SET job_title = p_job_title, company_name = p_company_name, duration = p_duration 
              WHERE user_experience_id = p_user_experience_id AND user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_user_password` (IN `p_password_hash` VARCHAR(255), IN `p_user_id` INT(11))   BEGIN
UPDATE users 
SET password_hash = p_password_hash, 
reset_token_hash = NULL 
WHERE user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_user_profile` (IN `p_user_id` INT(11), IN `p_first_name` VARCHAR(255), IN `p_last_name` VARCHAR(255), IN `p_job_title_id` INT(11), IN `p_gender` VARCHAR(255), IN `p_mobile_number` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_city` VARCHAR(255), IN `p_nationality` VARCHAR(255), IN `p_language` VARCHAR(255))   BEGIN
    UPDATE users
    SET 
        first_name = p_first_name,
        last_name = p_last_name,
        job_title_id = p_job_title_id,
        gender = p_gender,
        mobile_number = p_mobile_number,
        email = p_email,
        city = p_city,
        nationality = p_nationality,
        language = p_language
    WHERE 
        user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_user_profile_picture` (IN `p_profile_picture_url` VARCHAR(255), IN `p_user_id` INT(11))   BEGIN
	UPDATE users 
	SET
		users.profile_picture_url = p_profile_picture_url
	WHERE
		users.user_id = p_user_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `client_projects`
--

CREATE TABLE `client_projects` (
  `project_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `project_title` varchar(255) NOT NULL,
  `project_category` varchar(255) NOT NULL,
  `project_description` text DEFAULT NULL,
  `project_status` enum('In Progress','Completed','Hiring') NOT NULL DEFAULT 'Hiring',
  `project_connect_cost` int(11) DEFAULT NULL,
  `project_merit_worth` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client_projects`
--

INSERT INTO `client_projects` (`project_id`, `user_id`, `project_title`, `project_category`, `project_description`, `project_status`, `project_connect_cost`, `project_merit_worth`, `created_at`, `updated_at`) VALUES
(25, 31, 'Dev Ops', 'DevOps', 'Create something', 'In Progress', 10, 25, '2024-12-06 01:25:14', '2024-12-06 12:29:35'),
(26, 31, 'Game Development', 'Graphic Design', 'DSA\nDA\nSD\nAS\nDAS\nDAS\nD\nsad\nasd', 'In Progress', 5, 10, '2024-12-06 01:41:09', '2024-12-06 12:47:44'),
(27, 32, 'Jensen Project', 'Financial Skills', 'Testing \n', 'Hiring', 10, 10, '2024-12-06 10:59:05', '2024-12-06 12:00:17'),
(28, 31, 'Banana Game', 'Game Development Support', 'Saging to the max', 'In Progress', 5, 10, '2024-12-06 11:40:08', '2024-12-06 12:06:30');

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_applications`
--

CREATE TABLE `freelancer_applications` (
  `application_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `application_details` text NOT NULL,
  `portfolio_url` varchar(255) DEFAULT NULL,
  `application_status` enum('pending','accepted','rejected') NOT NULL DEFAULT 'pending',
  `application_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_applications`
--

INSERT INTO `freelancer_applications` (`application_id`, `project_id`, `user_id`, `application_details`, `portfolio_url`, `application_status`, `application_date`) VALUES
(14, 26, 30, 'sadasdasd\r\nASDAS\r\nDASD', 'https://chatgpt.com/c/6752cf26-842c-800d-b682-1fff3c29335c', 'pending', '2024-12-06 18:18:32'),
(15, 25, 30, 'adas\r\nAD\r\nAS\r\nDA\r\n    aaaaaaa', 'https://chatgpt.com/c/6752cf26-842c-800d-b682-1fff3c29335c', 'accepted', '2024-12-06 18:57:35'),
(16, 25, 35, 'asdas', 'https://github.com/', 'pending', '2024-12-06 19:31:45'),
(18, 28, 35, 'fd', '', 'accepted', '2024-12-06 19:41:32');

--
-- Triggers `freelancer_applications`
--
DELIMITER $$
CREATE TRIGGER `tr_after_application_status_update` AFTER UPDATE ON `freelancer_applications` FOR EACH ROW IF NEW.application_status = 'accepted' THEN
        UPDATE client_projects
        SET project_status = 'in progress'
        WHERE project_id = NEW.project_id;
    END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_connects`
--

CREATE TABLE `freelancer_connects` (
  `freelancer_connects_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `connects` int(11) DEFAULT 100
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_connects`
--

INSERT INTO `freelancer_connects` (`freelancer_connects_id`, `user_id`, `connects`) VALUES
(1, 30, 20),
(4, 35, 85);

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_experiences`
--

CREATE TABLE `freelancer_experiences` (
  `user_experience_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `job_title` varchar(255) NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `duration` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_experiences`
--

INSERT INTO `freelancer_experiences` (`user_experience_id`, `user_id`, `job_title`, `company_name`, `duration`) VALUES
(16, 19, 'Bamama', 'ASDaaa', '2003-2321'),
(17, 19, 'asadasdaa', 'asd', '2003-1212'),
(25, 19, 'sad', 'asd', '2003-1212'),
(26, 22, 'Software Developer', 'Internet Org', '2021-2024'),
(33, 22, 'Taga hugas ng pinggan sa bahay', 'ICOR Inc.', '2012-2024'),
(35, 22, 'Software Engineer', 'ICOR Inc.aa', '2001-2002'),
(47, 23, 'Software Engineer', 'ICOR Inc.', '2005-2012'),
(53, 28, 'test', 'aaa', '2023-2024'),
(55, 30, 'Software Developer', 'Google', '2020-Present'),
(56, 33, 'Software Engineer', 'Yahoo', '2020-Present'),
(57, 35, 'Software Developer', 'Yahoo', '2020-Present');

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_merits`
--

CREATE TABLE `freelancer_merits` (
  `freelancer_credits_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `merits` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_merits`
--

INSERT INTO `freelancer_merits` (`freelancer_credits_id`, `user_id`, `merits`) VALUES
(1, 30, 0),
(2, 35, 0);

-- --------------------------------------------------------

--
-- Table structure for table `freelancer_skills`
--

CREATE TABLE `freelancer_skills` (
  `user_skills_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `skill_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `freelancer_skills`
--

INSERT INTO `freelancer_skills` (`user_skills_id`, `user_id`, `skill_id`) VALUES
(188, 29, 127),
(189, 30, 132),
(190, 30, 130),
(193, 35, 57),
(194, 35, 56);

-- --------------------------------------------------------

--
-- Table structure for table `job_titles`
--

CREATE TABLE `job_titles` (
  `job_title_id` int(11) NOT NULL,
  `job_title` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `job_titles`
--

INSERT INTO `job_titles` (`job_title_id`, `job_title`) VALUES
(1, 'Software Developer'),
(2, '3D Artist'),
(3, 'Database Administrator');

-- --------------------------------------------------------

--
-- Table structure for table `skills`
--

CREATE TABLE `skills` (
  `skill_id` int(11) NOT NULL,
  `skill_name` varchar(255) NOT NULL,
  `skill_category` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `skills`
--

INSERT INTO `skills` (`skill_id`, `skill_name`, `skill_category`) VALUES
(1, 'Content Writing', 'Writing'),
(2, 'Copywriting', 'Writing'),
(3, 'Technical Writing', 'Writing'),
(4, 'Blog Writing', 'Writing'),
(5, 'Creative', 'Writing'),
(6, 'Multilingual Translation', 'Translation'),
(7, 'Subtitling', 'Translation'),
(8, 'Transcription', 'Translation'),
(9, 'Proofreading', 'Translation'),
(10, 'Editing', 'Translation'),
(11, 'Logo Design', 'Graphic Design'),
(12, 'Branding Design', 'Graphic Design'),
(13, 'Infographic Design', 'Graphic Design'),
(14, 'Social Media Graphics', 'Graphic Design'),
(15, 'Print Design', 'Graphic Design'),
(16, 'Video Editing', 'Video and Animation'),
(17, 'Motion Graphics', 'Video and Animation'),
(18, '2D Animation', 'Video and Animation'),
(19, '3D Animation', 'Video and Animation'),
(20, 'Explainer Videos', 'Video and Animation'),
(21, 'Wireframing', 'UI/UX Design'),
(22, 'Prototyping', 'UI/UX Design'),
(23, 'Mobile App Design', 'UI/UX Design'),
(24, 'Website Design', 'UI/UX Design'),
(25, 'User Testing', 'UI/UX Design'),
(26, 'Front-End Development', 'Web Development'),
(27, 'Back-End Development', 'Web Development'),
(28, 'Full-Stack Development', 'Web Development'),
(29, 'CMS Development (WordPress, Joomla)', 'Web Development'),
(30, 'E-Commerce Development', 'Web Development'),
(31, 'iOS Development', 'Mobile Development'),
(32, 'Android Development', 'Mobile Development'),
(33, 'Flutter Development', 'Mobile Development'),
(34, 'React Native Development', 'Mobile Development'),
(35, 'Game App Development', 'Mobile Development'),
(36, 'Python Development', 'Software Development'),
(37, 'Java Development', 'Software Development'),
(38, '.NET Development', 'Software Development'),
(39, 'C++ Development', 'Software Development'),
(40, 'API Development', 'Software Development'),
(41, 'Social Media Marketing', 'Digital Marketing'),
(42, 'SEO (Search Engine Optimization)', 'Digital Marketing'),
(43, 'Content Marketing', 'Digital Marketing'),
(44, 'Email Marketing', 'Digital Marketing'),
(45, 'Affiliate Marketing', 'Digital Marketing'),
(46, 'Lead Generation', 'Sales Support'),
(47, 'CRM Management', 'Sales Support'),
(48, 'Cold Calling', 'Sales Support'),
(49, 'Sales Funnel Design', 'Sales Support'),
(50, 'Prospect Research', 'Sales Support'),
(51, 'PPC Campaigns', 'Advertising'),
(52, 'Google Ads', 'Advertising'),
(53, 'Facebook Ads', 'Advertising'),
(54, 'LinkedIn Ads', 'Advertising'),
(55, 'Display Advertising', 'Advertising'),
(56, 'Email Management', 'Virtual Assistance'),
(57, 'Calendar Management', 'Virtual Assistance'),
(58, 'Travel Booking', 'Virtual Assistance'),
(59, 'Social Media Assistance', 'Virtual Assistance'),
(60, 'File Organization', 'Virtual Assistance'),
(61, 'Typing', 'Data Entry'),
(62, 'Data Cleaning', 'Data Entry'),
(63, 'Online Research', 'Data Entry'),
(64, 'Spreadsheet Management', 'Data Entry'),
(65, 'CRM Data Input', 'Data Entry'),
(66, 'Chat Support', 'Customer Support'),
(67, 'Phone Support', 'Customer Support'),
(68, 'Ticket Management', 'Customer Support'),
(69, 'Complaint Resolution', 'Customer Support'),
(70, 'Technical Support', 'Customer Support'),
(71, 'Bookkeeping', 'Financial Skills'),
(72, 'Payroll Management', 'Financial Skills'),
(73, 'Financial Analysis', 'Financial Skills'),
(74, 'Tax Preparation', 'Financial Skills'),
(75, 'Budget Planning', 'Financial Skills'),
(76, 'Business Strategy', 'Business Consulting'),
(77, 'Market Research', 'Business Consulting'),
(78, 'SWOT Analysis', 'Business Consulting'),
(79, 'Operations Management', 'Business Consulting'),
(80, 'Process Improvement', 'Business Consulting'),
(81, 'Recruitment', 'Human Resources'),
(82, 'Onboarding', 'Human Resources'),
(83, 'Employee Training', 'Human Resources'),
(84, 'Performance Reviews', 'Human Resources'),
(85, 'HR Policies', 'Human Resources'),
(86, 'Hardware Troubleshooting', 'IT Support'),
(87, 'Software Installation', 'IT Support'),
(88, 'IT Helpdesk Support', 'IT Support'),
(89, 'Network Setup', 'IT Support'),
(90, 'Remote Assistance', 'IT Support'),
(91, 'System Administration', 'Networking'),
(92, 'Cloud Computing', 'Networking'),
(93, 'VPN Setup', 'Networking'),
(94, 'Server Maintenance', 'Networking'),
(95, 'Cybersecurity', 'Networking'),
(96, 'CI/CD Pipelines', 'DevOps'),
(97, 'Docker', 'DevOps'),
(98, 'Kubernetes', 'DevOps'),
(99, 'Automation Scripting', 'DevOps'),
(100, 'Infrastructure as Code', 'DevOps'),
(101, 'Civil Engineering', 'Engineering'),
(102, 'Mechanical Engineering', 'Engineering'),
(103, 'Electrical Engineering', 'Engineering'),
(104, 'Structural Analysis', 'Engineering'),
(105, 'Robotics Design', 'Engineering'),
(106, 'Building Design', 'Architecture'),
(107, 'CAD Drafting', 'Architecture'),
(108, '3D Modeling', 'Architecture'),
(109, 'Interior Design', 'Architecture'),
(110, 'Landscape Architecture', 'Architecture'),
(111, 'Product Design', 'Manufacturing'),
(112, 'CNC Programming', 'Manufacturing'),
(113, '3D Printing', 'Manufacturing'),
(114, 'Materials Engineering', 'Manufacturing'),
(115, 'Prototyping', 'Manufacturing'),
(116, 'Life Coaching', 'Coaching & Development'),
(117, 'Career Counseling', 'Coaching & Development'),
(118, 'Parenting Advice', 'Coaching & Development'),
(119, 'Fitness Planning', 'Health & Wellness'),
(120, 'Nutrition Consulting', 'Health & Wellness'),
(121, 'Meditation Training', 'Health & Wellness'),
(122, 'Contract Drafting', 'Contract & Documentation'),
(123, 'Intellectual Property Consulting', 'Contract & Documentation'),
(124, 'Immigration Support', 'Contract & Documentation'),
(125, 'Business Compliance Assistance', 'Compliance & Research'),
(126, 'Legal Research', 'Compliance & Research'),
(127, 'Data Cleaning', 'Data Processing'),
(128, 'Data Wrangling', 'Data Processing'),
(129, 'Big Data Analytics', 'Data Processing'),
(130, 'Predictive Analytics', 'Advanced Analytics'),
(131, 'Machine Learning Model Development', 'Advanced Analytics'),
(132, 'Data Visualization', 'Advanced Analytics'),
(133, 'Game Testing', 'Game Development Support'),
(134, 'Level Design', 'Game Development Support'),
(135, 'Narrative Writing', 'Game Development Support'),
(136, 'Game Monetization Strategy', 'Monetization & Coaching'),
(137, 'Esports Coaching', 'Monetization & Coaching');

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
  `task_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `task_title` varchar(255) NOT NULL,
  `task_description` text DEFAULT NULL,
  `status` enum('pending','in progress','completed','approved') NOT NULL,
  `assigned_to` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `birthdate` date NOT NULL,
  `gender` varchar(21) NOT NULL,
  `city` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `mobile_number` varchar(13) NOT NULL,
  `nationality` varchar(255) NOT NULL,
  `language` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL,
  `profile_picture_url` varchar(255) NOT NULL,
  `job_title_id` int(10) DEFAULT NULL,
  `bio` varchar(500) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `reset_token_hash` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  `activation_token_hash` varchar(255) DEFAULT NULL,
  `last_login_date` datetime DEFAULT NULL,
  `attempts` int(1) DEFAULT NULL,
  `deactivation_duration` datetime DEFAULT NULL,
  `status` varchar(255) DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `birthdate`, `gender`, `city`, `email`, `mobile_number`, `nationality`, `language`, `role`, `profile_picture_url`, `job_title_id`, `bio`, `password_hash`, `reset_token_hash`, `reset_token_expiry`, `activation_token_hash`, `last_login_date`, `attempts`, `deactivation_duration`, `status`) VALUES
(29, 'kate', 'jensen', '2003-09-08', 'Female', 'Angeles, Pampanga, Philippines', 'jensenkajie@gmail.com', '', '', '', 'Freelancer', '', NULL, '', '$2y$10$fGb.gQEZo5SaDwxix5vXeu4Mmx5Q5h3O84R1QQ2WwL0SBeV037bhy', NULL, NULL, NULL, NULL, NULL, NULL, 'active'),
(30, 'Freelance Ronald', 'Sullano', '2003-07-14', 'Male', 'Caloocan, Metro Manila, Philippines', 'ronaldsullano1234@gmail.com', '9515910708', 'Filipino', 'Tagalog', 'Freelancer', '../../dist/php/uploads/profile_pictures/675246781cbb9_IMG_20230104_162006.png', 2, '', '$2y$10$nWpuLhxM5qvEWpsWwpwGKu4aUDewI1ZAbp39VawrkWfv0wjHVQgWu', NULL, NULL, NULL, NULL, NULL, NULL, 'active'),
(31, 'Client Ronald', 'Sullano', '2003-07-14', 'Male', 'Caloocan, Metro Manila, Philippines', 'ronaldsullano666@gmail.com', '9515910708', 'Filipino', 'Filipino', 'Client', '../../dist/php/uploads/profile_pictures/675247abedcbb_674e15dedd858_gary-chapman.jpg', 3, '', '$2y$10$6vohCxMgIJUVnrzFXXQYmuMGDQStAO5nqnZJD.46lXru1Y73w5dse', NULL, NULL, NULL, NULL, NULL, NULL, 'active'),
(32, 'Kate', 'Jensen', '2003-07-10', 'Female', 'Antipolo, Rizal, Philippines', 'ronaldsullano12345@gmail.com', '9515910702', 'Thai', 'Guarani', 'Client', '../../dist/php/uploads/profile_pictures/6752d8cfd48d2_received_364139713153077.jpeg', 3, '', '$2y$10$sTftvqLPrrJnugSToi/2Ee7qHUqAU26S6RWhgIg5Rvari9KdxdAGa', NULL, NULL, NULL, NULL, NULL, NULL, 'active'),
(35, 'Freelance Kate', 'Jensen', '2003-07-03', 'Female', 'Angeles, Pampanga, Philippines', 'ronaldsullano6666@gmail.com', '9515120708', 'Filipino', 'Tagalog', 'Freelancer', '../../dist/php/uploads/profile_pictures/6752e0aaed0bc_received_364139713153077.jpeg', 1, '', '$2y$10$I3mN3hppEF20cswF8ty1L.euzn1caw0ZyBSahmbfINVIRaCAChHbe', NULL, NULL, NULL, NULL, NULL, NULL, 'active');

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `tr_freelancer_signup_merit_connects` AFTER INSERT ON `users` FOR EACH ROW IF NEW.role = 'freelancer' THEN
        INSERT INTO freelancer_connects (user_id, connects)
        VALUES (NEW.user_id, 100);
		INSERT INTO freelancer_merits (user_id, merits)
        VALUES (NEW.user_id, 0);
    END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_freelancers`
-- (See below for the actual view)
--
CREATE TABLE `v_freelancers` (
`user_id` int(11)
,`first_name` varchar(50)
,`last_name` varchar(50)
,`project_id` int(11)
,`project_title` varchar(255)
,`application_date` datetime
,`application_status` enum('pending','accepted','rejected')
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_freelancer_connects_merits`
-- (See below for the actual view)
--
CREATE TABLE `v_freelancer_connects_merits` (
`user_id` int(11)
,`connects` int(11)
,`merits` int(10)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_tasks`
-- (See below for the actual view)
--
CREATE TABLE `v_tasks` (
`task_id` int(11)
,`project_id` int(11)
,`task_title` varchar(255)
,`task_description` text
,`status` enum('pending','in progress','completed','approved')
,`assigned_to` int(11)
,`created_at` timestamp
,`updated_at` timestamp
,`freelancer_name` varchar(101)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_user_profile`
-- (See below for the actual view)
--
CREATE TABLE `v_user_profile` (
`user_id` int(11)
,`first_name` varchar(50)
,`last_name` varchar(50)
,`birthdate` date
,`gender` varchar(21)
,`city` varchar(255)
,`email` varchar(255)
,`mobile_number` varchar(13)
,`nationality` varchar(255)
,`language` varchar(255)
,`role` varchar(255)
,`profile_picture_url` varchar(255)
,`job_title_id` int(10)
,`job_title` varchar(255)
,`status` varchar(255)
);

-- --------------------------------------------------------

--
-- Structure for view `v_freelancers`
--
DROP TABLE IF EXISTS `v_freelancers`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_freelancers`  AS SELECT `fa`.`user_id` AS `user_id`, `u`.`first_name` AS `first_name`, `u`.`last_name` AS `last_name`, `fa`.`project_id` AS `project_id`, `p`.`project_title` AS `project_title`, `fa`.`application_date` AS `application_date`, `fa`.`application_status` AS `application_status` FROM ((`freelancer_applications` `fa` join `users` `u` on(`fa`.`user_id` = `u`.`user_id`)) join `client_projects` `p` on(`fa`.`project_id` = `p`.`project_id`)) WHERE `u`.`role` = 'freelancer' AND `fa`.`application_status` = 'accepted' ;

-- --------------------------------------------------------

--
-- Structure for view `v_freelancer_connects_merits`
--
DROP TABLE IF EXISTS `v_freelancer_connects_merits`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_freelancer_connects_merits`  AS SELECT `users`.`user_id` AS `user_id`, `freelancer_connects`.`connects` AS `connects`, `freelancer_merits`.`merits` AS `merits` FROM ((`users` left join `freelancer_connects` on(`freelancer_connects`.`user_id` = `users`.`user_id`)) left join `freelancer_merits` on(`freelancer_merits`.`user_id` = `users`.`user_id`)) WHERE `users`.`role` = 'Freelancer' ;

-- --------------------------------------------------------

--
-- Structure for view `v_tasks`
--
DROP TABLE IF EXISTS `v_tasks`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_tasks`  AS SELECT `t`.`task_id` AS `task_id`, `t`.`project_id` AS `project_id`, `t`.`task_title` AS `task_title`, `t`.`task_description` AS `task_description`, `t`.`status` AS `status`, `t`.`assigned_to` AS `assigned_to`, `t`.`created_at` AS `created_at`, `t`.`updated_at` AS `updated_at`, concat(`u`.`first_name`,' ',`u`.`last_name`) AS `freelancer_name` FROM (`tasks` `t` left join `users` `u` on(`t`.`assigned_to` = `u`.`user_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_user_profile`
--
DROP TABLE IF EXISTS `v_user_profile`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_user_profile`  AS SELECT `users`.`user_id` AS `user_id`, `users`.`first_name` AS `first_name`, `users`.`last_name` AS `last_name`, `users`.`birthdate` AS `birthdate`, `users`.`gender` AS `gender`, `users`.`city` AS `city`, `users`.`email` AS `email`, `users`.`mobile_number` AS `mobile_number`, `users`.`nationality` AS `nationality`, `users`.`language` AS `language`, `users`.`role` AS `role`, `users`.`profile_picture_url` AS `profile_picture_url`, `users`.`job_title_id` AS `job_title_id`, `job_titles`.`job_title` AS `job_title`, `users`.`status` AS `status` FROM (`users` left join `job_titles` on(`users`.`job_title_id` = `job_titles`.`job_title_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `client_projects`
--
ALTER TABLE `client_projects`
  ADD PRIMARY KEY (`project_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `freelancer_applications`
--
ALTER TABLE `freelancer_applications`
  ADD PRIMARY KEY (`application_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `freelancer_connects`
--
ALTER TABLE `freelancer_connects`
  ADD PRIMARY KEY (`freelancer_connects_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `freelancer_experiences`
--
ALTER TABLE `freelancer_experiences`
  ADD PRIMARY KEY (`user_experience_id`),
  ADD KEY `user` (`user_id`);

--
-- Indexes for table `freelancer_merits`
--
ALTER TABLE `freelancer_merits`
  ADD PRIMARY KEY (`freelancer_credits_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `freelancer_skills`
--
ALTER TABLE `freelancer_skills`
  ADD PRIMARY KEY (`user_skills_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `skill_id` (`skill_id`);

--
-- Indexes for table `job_titles`
--
ALTER TABLE `job_titles`
  ADD PRIMARY KEY (`job_title_id`);

--
-- Indexes for table `skills`
--
ALTER TABLE `skills`
  ADD PRIMARY KEY (`skill_id`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`task_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `tasks_ibfk_2` (`assigned_to`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `ResetToken` (`reset_token_hash`),
  ADD UNIQUE KEY `activation_token_hash` (`activation_token_hash`),
  ADD KEY `job_title_id` (`job_title_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `client_projects`
--
ALTER TABLE `client_projects`
  MODIFY `project_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `freelancer_applications`
--
ALTER TABLE `freelancer_applications`
  MODIFY `application_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `freelancer_connects`
--
ALTER TABLE `freelancer_connects`
  MODIFY `freelancer_connects_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `freelancer_experiences`
--
ALTER TABLE `freelancer_experiences`
  MODIFY `user_experience_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `freelancer_merits`
--
ALTER TABLE `freelancer_merits`
  MODIFY `freelancer_credits_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `freelancer_skills`
--
ALTER TABLE `freelancer_skills`
  MODIFY `user_skills_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=195;

--
-- AUTO_INCREMENT for table `job_titles`
--
ALTER TABLE `job_titles`
  MODIFY `job_title_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `skills`
--
ALTER TABLE `skills`
  MODIFY `skill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=138;

--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `task_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `client_projects`
--
ALTER TABLE `client_projects`
  ADD CONSTRAINT `client_projects_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `freelancer_applications`
--
ALTER TABLE `freelancer_applications`
  ADD CONSTRAINT `freelancer_applications_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `client_projects` (`project_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `freelancer_applications_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `freelancer_connects`
--
ALTER TABLE `freelancer_connects`
  ADD CONSTRAINT `freelancer_connects_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `freelancer_merits`
--
ALTER TABLE `freelancer_merits`
  ADD CONSTRAINT `freelancer_merits_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `freelancer_skills`
--
ALTER TABLE `freelancer_skills`
  ADD CONSTRAINT `skill_id` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`skill_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Constraints for table `tasks`
--
ALTER TABLE `tasks`
  ADD CONSTRAINT `tasks_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `client_projects` (`project_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tasks_ibfk_2` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `job_title_id` FOREIGN KEY (`job_title_id`) REFERENCES `job_titles` (`job_title_id`) ON DELETE CASCADE ON UPDATE SET NULL;

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `e_update_status` ON SCHEDULE EVERY 1 DAY STARTS '2024-10-24 14:14:08' ENDS '2025-11-11 14:14:08' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE users
SET deactivation_duration = NULL,
    status = 'active'
WHERE deactivation_duration IS NOT NULL
  AND deactivation_duration <= NOW()$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
