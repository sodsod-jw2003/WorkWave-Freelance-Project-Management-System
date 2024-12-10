<?php
header('Content-Type: application/json');
error_reporting(E_ALL);
ini_set('display_errors', 0);
require_once('../../../connection.php');
session_start();

try {
    $data = json_decode(file_get_contents('php://input'), true);
    $project_id = $data['project_id'];
    $user_id = $_SESSION['user_id'];

    $mysqli->begin_transaction();

    // Get connect cost to refund
    $cost_query = "SELECT project_connect_cost FROM client_projects WHERE id = ?";
    $stmt = $mysqli->prepare($cost_query);
    $stmt->bind_param("i", $project_id);
    $stmt->execute();
    $project = $stmt->get_result()->fetch_assoc();

    // Refund connects
    $refund_query = "UPDATE freelancer_connects 
                    SET connects = connects + ? 
                    WHERE user_id = ?";
    $stmt = $mysqli->prepare($refund_query);
    $stmt->bind_param("ii", $project['project_connect_cost'], $user_id);
    $stmt->execute();

    // Delete application
    $delete_query = "DELETE FROM freelancer_applications 
                    WHERE project_id = ? AND user_id = ?";
    $stmt = $mysqli->prepare($delete_query);
    $stmt->bind_param("ii", $project_id, $user_id);
    $stmt->execute();

    $mysqli->commit();
    echo json_encode(['success' => true]);

} catch (Exception $e) {
    $mysqli->rollback();
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
