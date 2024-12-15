<?php
require_once('../../../connection.php');

$data = json_decode(file_get_contents('php://input'), true);
$search = '%' . $data['search'] . '%';

// Search projects
$project_query = "SELECT id, project_title, project_category 
                    FROM v_project_details 
                    WHERE project_status = 'Hiring' 
                    AND project_title LIKE ? 
                    LIMIT 3;
                    ";
$stmt = $mysqli->prepare($project_query);
$stmt->bind_param("s", $search);
$stmt->execute();
$projects = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Search clients
$client_query = "SELECT id, first_name, last_name, job_title, profile_picture_url FROM v_clients 
                WHERE first_name LIKE ? 
                OR last_name LIKE ? 
                OR job_title LIKE ? 
                LIMIT 3";
$stmt = $mysqli->prepare($client_query);
$stmt->bind_param("sss", $search, $search, $search);
$stmt->execute();
$clients = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

$results = [
    'projects' => $projects,
    'clients' => $clients
];

header('Content-Type: application/json');
echo json_encode($results);
