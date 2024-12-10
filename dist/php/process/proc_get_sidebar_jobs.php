<?php
session_start();
$mysqli = require '../../../connection.php';

$user_id = $_SESSION['user_id'];

$query = "SELECT * FROM v_freelancer_experiences WHERE user_id = ? ORDER BY duration DESC";
$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

while($job = $result->fetch_assoc()) {
    echo '<div class="mb-3">
            <div class="text-muted fw-semibold text-green-60">' . htmlspecialchars($job['job_title']) . '</div>
            <div class="text-muted small">' . htmlspecialchars($job['company_name']) . '</div>
            <div class="text-muted small d-inline fst-italic">' . $job['duration'] . '</div>
          </div>';
    
    if($result->num_rows > 1) {
        echo '<hr class="divider">';
    }
}
