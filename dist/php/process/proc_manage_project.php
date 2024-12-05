<?php
session_start();
$mysqli = require '../../../connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $response = array();

    // Handle the different actions (update, delete)
    switch ($_POST['action']) {
        case 'update':
            // Check if all the required fields are provided for update
            if (isset(
                $_POST['project_title'], 
                $_POST['project_category'], 
                $_POST['project_description'], 
                $_POST['status'], 
                $_POST['connect_cost'], 
                $_POST['merit_worth'], 
                $_POST['project_id'])) {
                
                $query = "CALL sp_update_client_projects(?, ?, ?, ?, ?, ?, ?, ?)";

                $stmt = $mysqli->prepare($query);
                if ($stmt === false) {
                    $response['success'] = false;
                    $response['message'] = 'Failed to prepare statement: ' . $mysqli->error;
                    echo json_encode($response);
                    exit;
                }

                $stmt->bind_param("ssssiiii",
                    $_POST['project_title'], 
                    $_POST['project_category'],  
                    $_POST['project_description'], 
                    $_POST['status'],
                    $_POST['project_id'],
                    $_SESSION['user_id'],
                    $_POST['connect_cost'],
                    $_POST['merit_worth']
                );

                // Execute the statement and check for success
                if ($stmt->execute()) {
                    $response['success'] = true;
                    $response['message'] = 'Project updated successfully';
                } else {
                    $response['success'] = false;
                    $response['message'] = 'Failed to update project: ' . $stmt->error;
                }
            } else {
                $response['success'] = false;
                $response['message'] = 'Missing required parameters for update.';
            }
            break;

        case 'delete':
            // Ensure the required parameters are present for deletion
            if (isset($_POST['project_id'])) {
                $query = "CALL sp_delete_client_projects(?, ?)";

                $stmt = $mysqli->prepare($query);
                if ($stmt === false) {
                    $response['success'] = false;
                    $response['message'] = 'Failed to prepare statement: ' . $mysqli->error;
                    echo json_encode($response);
                    exit;
                }

                $stmt->bind_param("ii", $_POST['project_id'], $_SESSION['user_id']);

                // Execute the delete query and check for success
                if ($stmt->execute()) {
                    $response['success'] = true;
                    $response['message'] = 'Project deleted successfully';
                } else {
                    $response['success'] = false;
                    $response['message'] = 'Failed to delete project: ' . $stmt->error;
                }
            } else {
                $response['success'] = false;
                $response['message'] = 'Missing project ID for deletion.';
            }
            break;

        default:
            $response['success'] = false;
            $response['message'] = 'Invalid action specified.';
            break;
    }

    // Return the response as JSON
    echo json_encode($response);
}
