<?php
//checking if user is logged in
if (!isset($_SESSION['user_id'])) {
    header("Location: ../../dist/php/login.php");; //to be updated to landing page if done(index.php)
    exit;
}
//query for user data
$user_id = $_SESSION['user_id'];
$stmt = $mysqli->prepare("CALL get_user_by_id(?)");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

//user profiles
$profile_pic = $user['profile_picture_url'] ? "../../dist/php/uploads/profile_pictures/" . $user['profile_picture_url'] : "../../img/default-profile.png";
$full_name = $user['first_name'] . " " . $user['last_name'];
$job_title = $user['job_title'] ?? "No job title provided";
$gender = $user['gender'] ?? "No gender found"; 
$city = $user['city'] ?? "No city found"; 
$email = $user['email'] ?? "No email found";