<?php
//checking if user is logged in
if (!isset($_SESSION['user_id'])) {
    header("Location: ../../dist/php/login.php");; //to be updated to landing page if done(index.php)
    exit;
}
//query for user data
$user_id = $_SESSION['user_id'];
$stmt = $mysqli->prepare("SELECT * FROM v_user_profile WHERE id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();


$stmt = $mysqli->prepare("SELECT id FROM v_available_job_titles WHERE job_title = ?");
$stmt->bind_param("s", $user['job_title']);
$stmt->execute();
$result = $stmt->get_result();

// Fetch the job_title_id
$job_title_id = null;
if ($jobtitle = $result->fetch_assoc()) {
    $job_title_id = $jobtitle['id'];
}

//user profiles
$profile_pic = $user['profile_picture_url'] ? "../../dist/php/uploads/profile_pictures/" . $user['profile_picture_url'] : "../../img/default-profile.png";
$full_name = $user['first_name'] . " " . $user['last_name'];
$job_title = $user['job_title'] ?? "No job title provided";
$gender = $user['gender'] ?? "No gender found"; 
$city = $user['city'] ?? "No city found"; 
$email = $user['email'] ?? "No email found";