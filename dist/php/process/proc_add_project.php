<?php
session_start();
$mysqli = require '../../../connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = $_SESSION['user_id'];
    $project_title = $_POST['project_title'];
    $project_category = $_POST['project_category'];
    $project_description = $_POST['project_description']; 
    $project_status = $_POST['status'];

    $query = "CALL sp_add_projects(?,?,?,?,?)";
    $stmt = $mysqli->prepare($query);

    if (!$stmt) {
        echo json_encode([
            'success' => false,
            'message' => 'Failed to prepare statement: ' . $mysqli->error
        ]);
        exit;
    }

    $stmt->bind_param("issss", $user_id, $project_title, $project_category, $project_description, $project_status);
    
    $response = array();
    if ($stmt->execute()) {
        $result = $stmt->get_result();
        if ($result && $row = $result->fetch_assoc()) {
            $response['success'] = true;
            $response['message'] = 'Project added successfully';
            $response['project_id'] = $row['project_id'];
        } else {
            $response['success'] = false;
            $response['message'] = 'Failed to retrieve project ID';
        }
    } else {
        $response['success'] = false;
        $response['message'] = 'Failed to execute statement: ' . $stmt->error;
    }

    echo json_encode($response);
}