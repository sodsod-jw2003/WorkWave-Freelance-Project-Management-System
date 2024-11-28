<?php
session_start();
$mysqli = require '../../../connection.php';

// pagawaan ng view tapos ilagay sa stored procedure yung select
$query = "
    SELECT 
        fa.user_id, 
        u.first_name, 
        u.last_name, 
        fa.project_id, 
        p.project_name, 
        fa.application_date, 
        fa.status 
    FROM 
        freelancer_applications fa
    INNER JOIN 
        users u ON fa.user_id = u.id
    INNER JOIN 
        projects p ON fa.project_id = p.id
    WHERE 
        u.role = 'freelancer'
        AND fa.status = 'Accepted';";

$result = $mysqli->query($query);

// Fetch all accepted applications and prepare an array
$applications = [];
while ($row = $result->fetch_assoc()) {
    $applications[] = $row;
}

header('Content-Type: application/json');
echo json_encode($applications);
exit;
