<?php
session_start();
$mysqli = require '../../../connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = $_SESSION['user_id'];
    $project_title = $_POST['project_title'];
    $project_category = $_POST['project_category'];
    $project_description = $_POST['project_description']; 
    $project_status = $_POST['status'];

    $query = "INSERT INTO projects (user_id, project_title, project_category, project_description, project_status, created_at) 
              VALUES (?, ?, ?, ?, ?, NOW())";
              
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("issss", $user_id, $project_title, $project_category, $project_description, $project_status);
    
    $response = array();
    if ($stmt->execute()) {
        $response['success'] = true;
        $response['message'] = 'Project added successfully';
        $response['project_id'] = $mysqli->insert_id;
    } else {
        $response['success'] = false;
        $response['message'] = 'Failed to add project';
    }
    
    echo json_encode($response);
}
