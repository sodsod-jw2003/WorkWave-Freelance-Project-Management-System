<?php
session_start();
$mysqli = require '../../../connection.php';

$user_id = $_SESSION['user_id'];

$query = "SELECT * FROM v_freelancer_experiences WHERE user_id = ? ORDER BY duration DESC;";
$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

while($job = $result->fetch_assoc()) {
    $years = explode('-', $job['duration']);
    echo '<div class="card mb-3 job-card bg-light border-start-accent card-outline" data-job-id="' . $job['id'] . '">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h5 class="card-title mb-1">' . htmlspecialchars($job['job_title']) . '</h5>
                        <h6 class="card-subtitle mb-2 text-muted">' . htmlspecialchars($job['company_name']) . '</h6>
                        <p class="card-text small text-muted mb-2">' . $job['duration'] . '</p>
                    </div>
                    <div class="btn-group">
                        <button class="btn btn-sm btn-outline-primary edit-job me-2" data-id="' . $job['id'] . '">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-danger delete-job" data-id="' . $job['id'] . '">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            </div>
          </div>';
}
