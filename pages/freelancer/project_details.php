<?php 
session_start();
$mysqli = require ('../../connection.php');
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

$project_id = $_GET['id'] ?? null;

// Fetch project details
$project_query = "Select * from v_project_details WHERE id = ?";
$stmt = $mysqli->prepare($project_query);
$stmt->bind_param("i", $project_id);
$stmt->execute();
$project_result = $stmt->get_result();
$project = $project_result->fetch_assoc();


$submission_query = "SELECT submission_url, status
                    FROM v_freelancer_submissions
                    WHERE project_id = ? AND user_id = ?";
$stmt = $mysqli->prepare($submission_query);
$stmt->bind_param("ii", $project_id, $_SESSION['user_id']);
$stmt->execute();
$submission_result = $stmt->get_result();
// $submission = $submission_result->fetch_assoc() ?: ['submission_url' => null, 'status' => null];

// Check if status is not pending
$isDisabled = isset($submission['submission_url']) && $submission['status'] != "pending" && $submission['status'] != "rejected";

$comment_query = "SELECT comment, created_at 
FROM v_project_comments 
WHERE project_id = ? 
ORDER BY created_at DESC LIMIT 1";
$stmt = $mysqli->prepare($comment_query);
$stmt->bind_param("i", $project_id);
$stmt->execute();
$comment = $stmt->get_result()->fetch_assoc();

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

    <!-- SweetAlert2 CDN -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <!-- freelancer_profile.js -->
    <script src="../../dist/js/freelancer_project_details.js" defer></script>
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
                            <li class="breadcrumb-item"><a href="projects.php" >Projects</a></li>
                            <li class="breadcrumb-item active" aria-current="page"><?php echo htmlspecialchars($project['project_title']); ?></li>
                        </ol>
                    </nav>
                </div>
                <!-- /breadcrumb naviagtion -->
            </div>
            <!-- /profile header -->

            <!-- objective content -->
            <div class="row">
                <!-- sidebar objective card and freelancer card -->
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
                        <!-- objective sidebar content -->
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
                                        <div class="">
                                            <div class="card-body p-3">
                                                <h6 class="mb-1 text-green-50"><?php echo htmlspecialchars($history['status']); ?></h6>
                                                <div class="text-muted small">
                                                    <?php echo date('F d, Y g:i A', strtotime($history['action_timestamp'])); ?>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <?php endwhile; ?>
                            </div>
                        </div>
                        <!-- /objective sidebar content -->
                    </div>
                </div>
                <!-- /sidebar objective card and freelancer card -->

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
                            <div class="container px-4 pt-2 pb-3 ">
                                <h5 class=""><?php echo htmlspecialchars($project['project_category']); ?></h5>
                                <h6 class="text-muted mt-3 text-justify"><?php echo htmlspecialchars($project['project_description']); ?></h6>
                                <h6 class="text-muted small mt-3 text-justify"><?php echo htmlspecialchars($project['project_objective']); ?></h6>
                            </div>
                            <!-- /project category & description -->
                        </div>
                    </div> 
                    <!-- file input (client's view of the submission will reflect here) -->
                    <div class="card shadow border-0 mt-3">
                        <div class="card-body">
                            <div class="container d-flex justify-content-between align-items-center px-4 pt-4 pb-0 mb-0 me-2">
                                <h5 class="card-title text-green-50 fw-semibold">Work Submission</h5>
                                <span class="badge bg-success mb-2 extra-class"><?php echo htmlspecialchars($submission['status']); ?></span>
                            </div>
                            <div class="container px-4 pt-2 pb-3">
                                <form id="submitForm">
                                    <div class="mb-3">

                                        <?php if($isDisabled): ?>
                                            <div class="alert alert-info">
                                                Submitted file: <?php echo basename($submission['submission_url']); ?>
                                            </div>
                                        <?php endif; ?>
                                        <?php if($submission['status'] === 'rejected'): ?>
                                            <div class="alert alert-danger">
                                                <strong>Rejection Reason:</strong> 
                                                <p class="mb-0"><?php echo htmlspecialchars($comment['comment']); ?></p>
                                                <small class="text-muted">
                                                    <?php echo date('M d, Y h:i A', strtotime($comment['created_at'])); ?>
                                                </small>
                                            </div>
                                        <?php endif; ?>
                                        <label for="fileInput" class="form-label">Upload your files</label>
                                        <input class="form-control" type="file" id="fileInput" name="fileInput[]" multiple <?php echo $isDisabled ? 'disabled' : ''; ?>>
                                    </div>
                                    <div class="text-end">
                                        <button type="submit" class="btn btn-dark-green" <?php echo $isDisabled ? 'disabled' : ''; ?>>Submit</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /main objective card -->
            </div>
            <!-- /objective content -->
        </div>
    </section>
</body>
</html>