<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);
require_once('../../../connection.php');
session_start();

if (!isset($_SESSION['user_id'])) {
    die(json_encode(['success' => false, 'message' => 'Not authenticated']));
}

try {
    $mysqli->begin_transaction();

    // Check if user has enough connects
    $user_id = $_SESSION['user_id'];
    $project_id = $_POST['project_id'];
    
    // Get project connect cost
    $cost_query = "SELECT project_connect_cost FROM client_projects WHERE id = ?";
    $stmt = $mysqli->prepare($cost_query);
    $stmt->bind_param("i", $project_id);
    $stmt->execute();
    $project = $stmt->get_result()->fetch_assoc();
    
    // Check connects balance
    $connects_query = "SELECT connects FROM freelancer_connects WHERE user_id = ?";
    $stmt = $mysqli->prepare($connects_query);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $connects = $stmt->get_result()->fetch_assoc();

    if ($connects['connects'] < $project['project_connect_cost']) {
        throw new Exception('Insufficient connects');
    }

    // Insert application
    $insert_query = "INSERT INTO freelancer_applications (project_id, user_id, application_details, portfolio_url, application_status_id) VALUES (?, ?, ?, ?, '1')";
    $stmt = $mysqli->prepare($insert_query);
    $stmt->bind_param("iiss", $project_id, $user_id, $_POST['application_details'], $_POST['portfolio_url']);
    $stmt->execute();

    // Deduct connects
    $update_query = "UPDATE freelancer_connects SET connects = connects - ? WHERE user_id = ?";
    $stmt = $mysqli->prepare($update_query);
    $stmt->bind_param("ii", $project['project_connect_cost'], $user_id);
    $stmt->execute();

    $mysqli->commit();
    echo json_encode(['success' => true]);

} catch (Exception $e) {
    $mysqli->rollback();
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}