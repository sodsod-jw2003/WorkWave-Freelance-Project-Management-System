-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 24, 2024 at 11:06 AM
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `activate_account` (IN `p_activation_token_hash` VARCHAR(255))   BEGIN
	SELECT * FROM
	users 
	WHERE
	activation_token_hash = p_activation_token_hash;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_by_email` (IN `p_email` VARCHAR(255))   BEGIN
	SELECT * FROM users
    WHERE users.email = p_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_by_id` (IN `p_user_id` INT(11))   BEGIN
	SELECT * FROM
	user_profile
	WHERE
	user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_by_reset_token_hash` (IN `p_reset_token_hash` VARCHAR(255))   BEGIN
	IF p_reset_token_hash = ''
	THEN
		SELECT 'please fillup all fields' as error_message;
	ELSE
		SELECT * FROM users
		WHERE reset_token_hash = p_reset_token_hash;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `signup_users` (IN `p_first_name` VARCHAR(50), IN `p_last_name` VARCHAR(50), IN `p_birthdate` DATE, IN `p_gender` VARCHAR(21), IN `p_city` VARCHAR(255), IN `p_email` VARCHAR(255), IN `p_password_hash` VARCHAR(255), IN `p_activation_token_hash` VARCHAR(255), IN `p_role` VARCHAR(255))   BEGIN
	IF p_first_name = '' OR p_last_name = '' OR p_birthdate = '' OR p_gender = '' OR p_city = '' OR p_email = '' OR p_password_hash = ''
    THEN
    SELECT 'please fillup all fields' as error_message;
	ELSE
	INSERT INTO users(users.first_name, users.last_name, users.birthdate, users.gender, users.city, users.email, users.password_hash, users.activation_token_hash, users.role)
	VALUES (p_first_name, p_last_name, p_birthdate, p_gender, p_city, p_email, p_password_hash, p_activation_token_hash, p_role);
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_activation_token` (IN `p_user_id` INT(11))   BEGIN
	UPDATE users
	SET
	activation_token_hash = NULL
	WHERE
	user_id = p_user_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_reset_token` (IN `p_reset_token_hash` VARCHAR(255), IN `p_email` VARCHAR(255))   BEGIN
	UPDATE users 
    SET reset_token_hash = p_reset_token_hash,
		reset_token_expiry = DATE_ADD(NOW(), INTERVAL 30 MINUTE)
    WHERE email = p_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user_profile_picture` (IN `p_profile_picture_url` VARCHAR(255), IN `p_user_id` INT(11))   BEGIN
	UPDATE users 
	SET
		users.profile_picture_url = p_profile_picture_url
	WHERE
		users.user_id = p_user_id;
END$$

DELIMITER ;

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
  `role` varchar(255) NOT NULL,
  `profile_picture_url` varchar(255) NOT NULL,
  `job_title_id` int(10) DEFAULT NULL,
  `bio` varchar(500) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `reset_token_hash` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  `activation_token_hash` varchar(255) DEFAULT NULL,
  `last_login_date` datetime DEFAULT NULL,
  `attempts` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `birthdate`, `gender`, `city`, `email`, `role`, `profile_picture_url`, `job_title_id`, `bio`, `password_hash`, `reset_token_hash`, `reset_token_expiry`, `activation_token_hash`, `last_login_date`, `attempts`) VALUES
(19, 'Kate', 'Jensen', '2003-09-13', 'Female', 'Caloocan, Metro Manila, Philippines', 'ronaldsullano666@gmail.com', 'Freelancer', '../../dist/php/uploads/profile_pictures/6741c9f93aa18_wallpaperflare.com_wallpaper.jpg', 3, '', '$2y$10$VzA1NGX.l9gXOijcrrVqC.9zEdJLQa3Fkz0.tzaQWaJaa1kAMdupK', NULL, NULL, NULL, NULL, NULL),
(22, 'Ronald', 'Sullano', '2003-07-13', 'Male', 'Caloocan, Metro Manila, Philippines', 'ronaldsullano1234@gmail.com', 'Freelancer', '../../dist/php/uploads/profile_pictures/6741e2df82542_images.jpg', NULL, '', '$2y$10$6de7uj7dIUKeq2NjkH2VL.QIDOaIDeXjbQdEh3ohlg.b/ZdT1W4He', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users_experiences`
--

CREATE TABLE `users_experiences` (
  `user_experience_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `job_title` varchar(255) NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `duration` varchar(9) NOT NULL,
  `description` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users_skills`
--

CREATE TABLE `users_skills` (
  `user_skills_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `skill_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `user_profile`
-- (See below for the actual view)
--
CREATE TABLE `user_profile` (
`user_id` int(11)
,`first_name` varchar(50)
,`last_name` varchar(50)
,`birthdate` date
,`gender` varchar(21)
,`city` varchar(255)
,`email` varchar(255)
,`role` varchar(255)
,`profile_picture_url` varchar(255)
,`job_title` varchar(255)
,`bio` varchar(500)
);

-- --------------------------------------------------------

--
-- Structure for view `user_profile`
--
DROP TABLE IF EXISTS `user_profile`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `user_profile`  AS SELECT `users`.`user_id` AS `user_id`, `users`.`first_name` AS `first_name`, `users`.`last_name` AS `last_name`, `users`.`birthdate` AS `birthdate`, `users`.`gender` AS `gender`, `users`.`city` AS `city`, `users`.`email` AS `email`, `users`.`role` AS `role`, `users`.`profile_picture_url` AS `profile_picture_url`, `job_titles`.`job_title` AS `job_title`, `users`.`bio` AS `bio` FROM (`users` left join `job_titles` on(`users`.`job_title_id` = `job_titles`.`job_title_id`)) ;

--
-- Indexes for dumped tables
--

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
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `ResetToken` (`reset_token_hash`),
  ADD UNIQUE KEY `activation_token_hash` (`activation_token_hash`),
  ADD KEY `job_title_id` (`job_title_id`);

--
-- Indexes for table `users_experiences`
--
ALTER TABLE `users_experiences`
  ADD PRIMARY KEY (`user_experience_id`),
  ADD KEY `user` (`user_id`);

--
-- Indexes for table `users_skills`
--
ALTER TABLE `users_skills`
  ADD PRIMARY KEY (`user_skills_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `skill_id` (`skill_id`);

--
-- AUTO_INCREMENT for dumped tables
--

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
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `users_experiences`
--
ALTER TABLE `users_experiences`
  MODIFY `user_experience_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users_skills`
--
ALTER TABLE `users_skills`
  MODIFY `user_skills_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `job_title_id` FOREIGN KEY (`job_title_id`) REFERENCES `job_titles` (`job_title_id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `users_experiences`
--
ALTER TABLE `users_experiences`
  ADD CONSTRAINT `user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `users_skills`
--
ALTER TABLE `users_skills`
  ADD CONSTRAINT `skill_id` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`skill_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
