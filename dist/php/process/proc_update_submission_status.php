<?php
session_start();
require_once '../../../connection.php';

$data = json_decode(file_get_contents('php://input'), true);
$response = ['success' => false];

if (isset($data['submission_id'], $data['status'])) {
    $mysqli->begin_transaction();
    
    try {
        
        $query = "CALL sp_update_freelancer_project_submissions(?, ?)";
        $stmt = $mysqli->prepare($query);
        $stmt->bind_param("ii", $data['status'], $data['submission_id']);
        $stmt->execute();

        if (!empty($data['comment'])) {
            $comment_query = "CALL sp_insert_project_comments(?, ?, ?)";
            $stmt = $mysqli->prepare($comment_query);
            $stmt->bind_param("iis", $data['project_id'], $_SESSION['user_id'], $data['comment']);
            $stmt->execute();
        }

        $mysqli->commit();
        $response['success'] = true;
    } catch (Exception $e) {
        $mysqli->rollback();
        $response['error'] = $e->getMessage();
    }
}

echo json_encode($response);
