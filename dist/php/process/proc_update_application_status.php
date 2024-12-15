<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 1);
require_once('../../../connection.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $application_id = $_POST['application_id'];
    $status = $_POST['status'];

    // Get project_id for this application
    $projectQuery = "SELECT project_id FROM v_applications 
                    JOIN v_applications_ids ON v_applications.id = v_applications_ids.id 
                    WHERE v_applications.id = ?";
    $stmt = $mysqli->prepare($projectQuery);
    $stmt->bind_param("i", $application_id);
    $stmt->execute();
    $stmt->bind_result($project_id);
    $stmt->fetch();
    $stmt->close();

    // Check for existing accepted applications if trying to accept
    if ($status === '2') {
        $checkQuery = "SELECT COUNT(*) FROM v_applications 
                      JOIN v_applications_ids ON v_applications.id = v_applications_ids.id 
                      WHERE project_id = ? AND status = 'accepted'";
        $stmt = $mysqli->prepare($checkQuery);
        $stmt->bind_param("i", $project_id);
        $stmt->execute();
        $stmt->bind_result($count);
        $stmt->fetch();
        $stmt->close();

        if ($count > 0) {
            echo json_encode([
                'success' => false,
                'message' => 'An application is already accepted for this project'
            ]);
            exit;
        }
    }

    // If no existing accepted application, proceed with update
    $updateQuery = "CALL sp_update_application_status(?, ?)";
    $stmt = $mysqli->prepare($updateQuery);
    $stmt->bind_param("ii", $status, $application_id);

    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => $stmt->error
        ]);
    }    
    $stmt->close();
}
