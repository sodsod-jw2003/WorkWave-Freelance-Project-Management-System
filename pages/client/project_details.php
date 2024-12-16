<?php 
session_start();
$mysqli = require ('../../connection.php');
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

$project_id = $_GET['id'] ?? null;

// Fetch project details
$project_query = "SELECT * FROM v_project_details WHERE id = ?";
$stmt = $mysqli->prepare($project_query);
$stmt->bind_param("i", $project_id);
$stmt->execute();
$project_result = $stmt->get_result();
$project = $project_result->fetch_assoc();

$submission_query = "SELECT fs.*, u.first_name, u.last_name 
                     FROM v_freelancer_submissions fs
                     JOIN v_user_profile u ON fs.user_id = u.id 
                     WHERE fs.project_id = ?";
$stmt = $mysqli->prepare($submission_query);
$stmt->bind_param("i", $project_id);
$stmt->execute();
$submissions = $stmt->get_result();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Project Details</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- SWAL -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <!-- freelancer_profile.js -->
    <script src="../../dist/js/client_project_details.js" defer></script>
    <script src="https://cdn.botpress.cloud/webchat/v2.2/inject.js"></script>
    <script src="https://files.bpcontent.cloud/2024/12/12/18/20241212181227-C50YEH0A.js"></script>

</head>
<body>
    <section class="container-fluid poppins">
        <div class="container">
            <!-- profile header -->
            <div class="row mt-4 align-items-center">
                <!-- project title -->
                <div class="col-12 col-md-6">
                    <h2 class="text-start fw-semibold"><?php echo htmlspecialchars($project['project_title']); ?></h2>
                </div>
                <!-- /end project title -->

                <!-- breadcrumb navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="dashboard.php"><?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="projects.php">Projects</a></li>
                            <li class="breadcrumb-item active" aria-current="page"><?php echo htmlspecialchars($project['project_title']); ?></li>
                        </ol>
                    </nav>
                </div>
                <!-- /breadcrumb navigation -->
            </div>
            <!-- /profile header -->

            <!-- objective content -->
            <div class="row">
                <!-- sidebar objective card -->
                <div class="col-12 col-md-4 col-lg-3 p-3">
                    <div class="card card-primary card-outline shadow border-0 mb-4">
                        <!-- objective header -->
                        <div class="card-header bg-green-30 p-3">
                            <div class="d-flex align-items-center text-white">
                                <i class="fa-solid fa-list-check text-white mx-1"></i>
                                <div class="text-white p-1 d-inline">Completion History</div>
                            </div>
                        </div>
                        <!-- /objective header -->
                        <div class="card-body">
                            <div class="timeline">
                                <?php
                                $history_query = "SELECT * FROM v_project_completion_history WHERE project_id = ? ORDER BY action_timestamp ASC";
                                $stmt = $mysqli->prepare($history_query);
                                $stmt->bind_param("i", $project_id);
                                $stmt->execute();
                                $history_result = $stmt->get_result();

                                while ($history = $history_result->fetch_assoc()):
                                ?>
                                    <div class="timeline-item">
                                        <div class="timeline-dot"></div>
                                        <div class="card shadow-sm">
                                            <div class="card-body p-3">
                                                <h6 class="mb-1 text-green-50"><?php echo htmlspecialchars($history['status']); ?></h6>
                                                <div class="text-muted small">
                                                    <?php echo date('F d, Y g:i A', strtotime($history['action_timestamp'])); ?>
                                                </div>
                                                <?php if ($history['new_submission_url'] && $history['status'] != 'pending'): ?>
                                                    <a href="<?php echo htmlspecialchars($history['new_submission_url']); ?>" 
                                                    download 
                                                    class="btn btn-sm btn-secondary">
                                                        <i class="fas fa-download me-2"></i>Download
                                                    </a>
                                                <?php endif; ?>
                                            </div>
                                        </div>
                                    </div>
                                <?php endwhile; ?>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /sidebar objective card -->

                <!-- main objective card -->
                <div class="col-12 col-md-8 col-lg-9 p-3">
                    <div class="card shadow border-0">
                        <div class="card-body">
                            <!-- project title & status -->
                            <div class="container d-flex justify-content-between align-items-center px-4 pt-4 pb-0 mb-0 me-2">
                                <h4 class="text-green-50 fw-semibold"><?php echo htmlspecialchars($project['project_title']); ?></h4>
                                <span class="badge bg-success mb-2"><?php echo htmlspecialchars($project['project_status']); ?></span>
                            </div>
                            <!-- /project title & status -->

                            <!-- project category & description -->
                            <div class="container px-4 pt-2 pb-3">
                                <h5><?php echo htmlspecialchars($project['project_category']); ?></h5>
                                <h6 class="text-muted mt-3 text-justify"><?php echo htmlspecialchars($project['project_description']); ?></h6>
                                <h6 class="text-muted small mt-3 text-justify"><?php echo htmlspecialchars($project['project_objective']); ?></h6>
                            </div>
                            <!-- /project category & description -->
                        </div>
                    </div> 

                    <!-- submissions section -->
                    <div class="card shadow border-0 mt-3">
                        <div class="card-body">
                            <div class="container d-flex justify-content-between align-items-center px-4 pt-4 pb-0 mb-0 me-2">
                                <h5 class="card-title text-green-50 fw-semibold">Submissions</h5>

                                <?php 
                                // Check if there are any submissions and get the status of the first submission
                                $submission_status = 'No submissions'; // Default if no submissions
                                if ($submissions->num_rows > 0) {
                                    // Get the status of the first submission
                                    $first_submission = $submissions->fetch_assoc();
                                    $submission_status = htmlspecialchars($first_submission['status']);
                                    // Reset the pointer back to the start for the while loop
                                    $submissions->data_seek(0);
                                }
                                ?>

                                <!-- Initial status badge, which will be updated dynamically -->
                                <span class="badge bg-success mb-2 extra-class"><?php echo $submission_status; ?></span>
                            </div>

                            <div class="container px-4 pt-2 pb-3">
                                <?php if ($submissions->num_rows > 0): ?>
                                    <?php while ($submission = $submissions->fetch_assoc()): ?>
                                        <div class="submission-card mb-3 p-3 border rounded">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6><?php echo htmlspecialchars($submission['first_name'] . ' ' . $submission['last_name']); ?></h6>
                                                    <a href="<?php echo htmlspecialchars($submission['submission_url']); ?>" download class="btn btn-sm btn-secondary">
                                                        <i class="fas fa-download me-2"></i>Download Submission
                                                    </a>
                                                </div>
                                                <?php if ($submission['status'] == 'for review'): ?>
                                                    <div>
                                                        <button class="btn btn-success accept-submission" data-submission-id="<?php echo $submission['id']; ?>">
                                                            <i class="fas fa-check me-2"></i>Accept
                                                        </button>
                                                        <button class="btn btn-danger reject-submission" data-submission-id="<?php echo $submission['id']; ?>">
                                                            <i class="fas fa-times me-2"></i>Reject
                                                        </button>
                                                    </div>
                                                <?php endif; ?>
                                            </div>
                                        </div>
                                    <?php endwhile; ?>
                                <?php else: ?>
                                    <div class="alert alert-warning" role="alert">
                                        No submissions found for this project.
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                    <!-- /submissions section -->
                </div>
                <!-- /main objective card -->
            </div>
            <!-- /objective content -->
        </div>
    </section>
</body>
</html>
