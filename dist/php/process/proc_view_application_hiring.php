<?php
header('Content-Type: application/json');
require_once('../../../connection.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $application_id = $_POST['application_id'];

    // retrieve the project_id for the given application_id
    $projectQuery = "SELECT project_id FROM freelancer_applications WHERE application_id = ?";
    $stmt = $mysqli->prepare($projectQuery);
    $stmt->bind_param("i", $application_id);
    $stmt->execute();
    $stmt->bind_result($project_id);
    $stmt->fetch();
    $stmt->close();

    if (!$project_id) {
        echo json_encode(['success' => false, 'message' => 'Invalid application ID']);
        exit;
    }

    // Check if there is already an accepted application for this project
    $checkQuery = "SELECT COUNT(*) FROM freelancer_applications WHERE project_id = ? AND application_status = 'accepted'";
    $stmt = $mysqli->prepare($checkQuery);
    $stmt->bind_param("i", $project_id);
    $stmt->execute();
    $stmt->bind_result($count);
    $stmt->fetch();
    $stmt->close();

    if ($count > 0) {
        echo json_encode(['success' => false, 'message' => 'An application is already accepted for this project']);
        exit;
    }

    // Proceed with updating the application_status
    $updateQuery = "UPDATE freelancer_applications SET application_status = 'accepted' WHERE application_id = ?";
    $stmt = $mysqli->prepare($updateQuery);
    $stmt->bind_param("i", $application_id);

    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to update status']);
    }
    $stmt->close();
}
