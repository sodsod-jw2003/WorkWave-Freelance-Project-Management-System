<?php 

require ('../../connection.php');
if (!isset($_SESSION['user_id'])) {
    header("Location: ../../dist/php/login.php");; //to be updated to landing page if done(index.php)
    exit;
}
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

$query = "SELECT fa.*, u.first_name, u.last_name, u.profile_picture_url, cp.project_title 
          FROM freelancer_applications fa
          LEFT JOIN users u ON fa.user_id = u.user_id
          LEFT JOIN client_projects cp ON fa.project_id = cp.project_id
          WHERE cp.user_id = ? AND fa.application_status = 'pending'
          ORDER BY fa.application_date DESC";

$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$applications = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | All Projects</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

    <script src="../../dist/js/client_projects.js" defer></script>

</head>
<body>
    <section class="container-fluid poppins">
        <div class="container">
            <!-- Profile Header -->
            <div class="row mt-4 align-items-center">
                <!-- Profile Title -->
                <div class="col-12 col-md-6">
                    <h2 class="text-start">Projects</h2>
                </div>
                <!-- Breadcrumb Navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="dashboard.php"><?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">All Projects</li>
                        </ol>
                    </nav>
                </div>
            </div>
            <!-- projects -->
            <div class="row mt-4">
                <div class="container px-3">
                    <div class="card mb-4 shadow border-0 rounded-3">
                        <div class="card-body">
                            <div class="row my-3 mx-1 border-0">
                                <h3>Your Projects</h3>
                            </div>
                            <div class="row px-4">
                                <?php if ($applications): ?>
                                    <?php foreach($applications as $application): ?>
                                        <div class="col-12 d-flex justify-content-center align-items-center p-4 rounded shadow-sm border mb-3 bg-light">
                                            <div class="col-12">
                                                <!-- Project Title and Status -->
                                                <div class="row align-items-center px-3 py-2 rounded-top">
                                                    <!-- Project Title -->
                                                    <div class="col-md-6 d-flex align-items-center ps-0">
                                                        <h5 class="mb-0">
                                                            <a href="#" class="text-muted text-decoration-none">Project Title</a>
                                                        </h5>
                                                    </div>
                                                    <!-- Project Status -->
                                                    <div class="col-md-6 d-flex justify-content-end pe-0">
                                                        <span class="badge bg-success">Project Status</span>
                                                    </div>
                                                </div>
                                                <!-- Freelancer Info -->
                                                <div class="row align-items-center px-3 py-2 rounded-bottom">
                                                    <!-- Freelancer -->
                                                    <div class="col-md-6 d-flex align-items-center ms-0 ps-0">
                                                        <img src="<?php echo htmlspecialchars($application['profile_picture_url']); ?>" 
                                                        alt="" 
                                                        class="rounded-circle" 
                                                        style="width: 30px; height: 30px;">
                                                        <span class="fs-5 ms-3 fw-semibold">
                                                            Freelancer Name
                                                        </span>
                                                    </div>
                                                    <div class="col-md-6 d-flex justify-content-end pe-0">
                                                        <a href="view_application.php?id=<?php echo htmlspecialchars($application['application_id']); ?>" 
                                                        class="btn btn-outline-secondary me-0">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    <?php endforeach; ?>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
            </div>
            <!-- /projects -->
        </div>
    </section>
</body>
</html>