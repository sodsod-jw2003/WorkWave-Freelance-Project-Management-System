<?php
session_start();
$mysqli = require '../../../connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = $_SESSION['user_id'];
    $user_experience_id = $_POST['user_experience_id'];
    $job_title = $_POST['job_title'];
    $company_name = $_POST['company_name'];
    $duration = $_POST['duration'];

    $query = "CALL sp_update_user_experience(?, ?, ?, ?, ?)";
              
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("sssii", $job_title, $company_name, $duration, $user_experience_id, $user_id);
    
    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false]);
    }
}
