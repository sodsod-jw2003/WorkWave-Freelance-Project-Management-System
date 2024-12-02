<?php
session_start();
$mysqli = require '../../../connection.php';

$query = "CALL sp_get_sidebar_projects(?)";
$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();

$result = $stmt->get_result();
$html = '';

while ($project = $result->fetch_assoc()) {
    $html .= '<div class="mb-3">';
    $html .= '<div class="text-muted fw-semibold text-green-60">' . htmlspecialchars($project['project_title']) . '</div>';
    $html .= '<div class="text-muted small">' . htmlspecialchars($project['project_category']) . '</div>';
    $html .= '<div class="text-muted small d-inline">' . htmlspecialchars($project['project_status']) . '</div>';
    $html .= '</div>';
    $html .= '<hr class="divider">';
}

echo $html;
