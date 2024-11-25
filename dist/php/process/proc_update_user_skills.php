<?php
session_start();
$mysqli = require '../../../connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = $_SESSION['user_id'];
    
    $mysqli->begin_transaction();

    try {
        //delete existing skills
        $delete_query = "CALL sp_delete_users_skills(?)";
        $stmt = $mysqli->prepare($delete_query);
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $stmt->close();

        while ($mysqli->more_results() && $mysqli->next_result()) {
            if ($extraResult = $mysqli->store_result()) {
                $extraResult->free();
            }
        }

        //onsert new skills
        if (isset($_POST['skills']) && is_array($_POST['skills'])) {
            $insert_query = "CALL sp_insert_user_skills(?, ?)";
            $stmt = $mysqli->prepare($insert_query);

            foreach ($_POST['skills'] as $skill_id) {
                $stmt->bind_param("ii", $user_id, $skill_id);
                $stmt->execute();
            }
            $stmt->close();
        }

        $mysqli->commit();
        echo json_encode(['success' => true]);

    } catch (Exception $e) {
        if ($mysqli->errno) {
            $mysqli->rollback();
        }
        echo json_encode(['success' => false, 'message' => $e->getMessage()]);
    }
}
