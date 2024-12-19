<?php
session_start();
$mysqli = require '../../../connection.php';

error_log("Received POST data: " . print_r($_POST, true));

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = $_SESSION['user_id'];
    $project_title = $_POST['project_title'];
    $project_category = $_POST['project_category'];
    $project_description = $_POST['project_description']; 
    $project_objective = $_POST['project_objective'];

    $query = "CALL sp_add_projects(?,?,?,?,?)";
    $stmt = $mysqli->prepare($query);

    if (!$stmt) {
        echo json_encode([
            'success' => false,
            'message' => 'Failed to prepare statement: ' . $mysqli->error
        ]);
        exit;
    }

    $stmt->bind_param("issss", $user_id, $project_title, $project_category, $project_description, $project_objective);
    
    $response = array();
    if ($stmt->execute()) {
        $result = $stmt->get_result();
        if ($result && $row = $result->fetch_assoc()) {
            $response['success'] = true;
            $response['message'] = 'Project added successfully';
            $response['project_id'] = $row['id'];
            $response['project_status'] = $row['project_status'];
            $response['project_category'] = $row['project_category'];
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