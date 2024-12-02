<?php
session_start();
$mysqli = require '../../../connection.php';

if (isset($_GET['project_id'])) {
    $project_id = $mysqli->real_escape_string($_GET['project_id']);
    
    $query = "CALL sp_get_tasks_from_v_tasks(?)";
              
    $result = $mysqli->query($query);
    
    $tasks = [];
    while ($row = $result->fetch_assoc()) {
        $tasks[] = [
            'task_id' => $row['task_id'],
            'task_title' => $row['task_title'],
            'task_description' => $row['task_description'],
            'status' => $row['status'],
            'freelancer_name' => $row['freelancer_name'],
            'created_at' => $row['created_at'],
            'updated_at' => $row['updated_at']
        ];
    }
    
    echo json_encode($tasks);
} else {
    echo json_encode(['error' => 'No project ID provided']);
}
