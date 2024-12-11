<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);
require_once('../../../connection.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    $application_id = $_POST['application_id'];
    $status = $_POST['status']; // Get status from POST data

    $updateQuery = "CALL sp_update_application_status(?, ?)";
    
    $stmt = $mysqli->prepare($updateQuery);
    $stmt->bind_param("ii", $status, $application_id);

    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => $stmt->error // Add this to see the error
        ]);
    }    
    $stmt->close();
}
