<?php 

require ('../../connection.php');
if (!isset($_SESSION['user_id'])) {
    header("Location: ../../dist/php/login.php");; //to be updated to landing page if done(index.php)
    exit;
}
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

$freelancer_id = $_GET['id'];

// Query for freelancer details
$details_query = "SELECT * FROM v_user_profile 
                 JOIN v_freelancer_connects_and_merits ON v_user_profile.id = v_freelancer_connects_and_merits.id
                 WHERE v_user_profile.id = ?";
$stmt = $mysqli->prepare($details_query);
$stmt->bind_param("i", $freelancer_id);
$stmt->execute();
$freelancer = $stmt->get_result()->fetch_assoc();

// Query for job experience
$experience_query = "SELECT * FROM freelancer_experiences 
                    WHERE user_id = ? 
                    ORDER BY duration DESC";
$stmt = $mysqli->prepare($experience_query);
$stmt->bind_param("i", $freelancer_id);
$stmt->execute();
$experiences = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Query for project history
$projects_query = "SELECT * FROM v_applications
                  JOIN v_applications_ids ON v_applications.id = v_applications_ids.id
                  JOIN v_project_details ON v_applications_ids.project_id = v_project_details.id
                  JOIN v_user_profile ON v_project_details.project_owner = v_user_profile.id
                  WHERE v_applications_ids.user_id = ? 
                  ORDER BY v_applications.created_at DESC";
$stmt = $mysqli->prepare($projects_query);
$stmt->bind_param("i", $freelancer_id);
$stmt->execute();
$projects = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | View Freelancer</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

    <!-- view_application.js -->
    <script src="../../dist/js/view_application.js"></script>
</head>
<body>
    <section class="container-fluid poppins">
        <div class="container">
            <!-- profile header -->
            <div class="row mt-4 d-flex align-items-center">
                <!-- profile title -->
                <div class="col-12 col-md-6">
                    <h2 class="text-start">Dynamic Client Name</h2>
                </div>
                <!-- breadcrumb navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="dashboard.php">'s Dashboard</a></li>
                            <li class="breadcrumb-item"><a href="clients.php">All Clients</a></li>
                            <li class="breadcrumb-item active" aria-current="page">dynamic client name</li>
                        </ol>
                    </nav>
                </div>
            </div>
            <!-- /profile header -->
            
            <div class="row">
                <!-- sidebar profile card -->
                <div class="col-12 col-md-4 col-lg-3 p-3">
                    <div class="card card-primary card-outline border-top-accent shadow border-0 mb-4 position-relative">
                        <div class="container d-flex justify-content-center mt-5 position-relative">
                            <div class="profile-pic-wrapper">
                                <!-- client pfp -->
                                <img src="" class="profile-pic rounded-circle" style="width: 100px; height: 100px; object-fit: cover;" onerror="this.onerror=null; this.src='../../img/default-profile.png';">
                            </div>
                        </div>
                        <div class="container fs-5 text-center mt-3">client name</div>
                        <div class="container fs-6 text-center text-muted mb-5">job title</div>
                    </div>
                    <!-- sidebar: personal information -->
                    <div class="card card-primary card-outline shadow border-0 mb-4">
                        <!-- personal info: static header -->
                        <div class="card-header bg-green-30 p-3">
                            <div class="d-flex align-items-center text-decoration-none">
                                <i class="fa-solid fa-user text-white mx-1"></i>
                                <div class="text-white p-1 d-inline">Personal Information</div>
                            </div>
                        </div>
                        <!-- personal info: content -->
                        <div class="card-body">
                            <div class="mb-3">
                                <span class="fas fa-envelope me-1 text-green-60"></span>
                                <span class="text-muted fw-semibold text-green-60">Email</span>
                                <div class="text-muted small"><?php echo $freelancer['email'] ?></div>
                            </div>
                            <hr class="divider">
                            <div class="mb-3">
                                <span class="fas fa-phone me-1 text-green-60"></span>
                                <span class="text-muted fw-semibold text-green-60">Mobile Number</span>
                                <div class="text-muted small"><?php echo $freelancer['mobile_number'] ?></div>
                            </div>
                            <hr class="divider">
                            <div class="mb-3">
                                <span class="fas fa-mars-and-venus me-1 text-green-60"></span>
                                <span class="text-muted fw-semibold text-green-60">Gender</span>
                                <div class="text-muted small"><?php echo $freelancer['gender'] ?></div>
                            </div>
                            <hr class="divider">
                            <div class="mb-3">
                                <span class="fas fa-location-dot me-1 text-green-60"></span>
                                <span class="text-muted fw-semibold text-green-60">Location</span>
                                <div class="text-muted small"><?php echo $freelancer['city'] ?></div>
                            </div>
                            <hr class="divider">
                            <div class="mb-3">
                                <span class="fas fa-flag me-1 text-green-60"></span>
                                <span class="text-muted fw-semibold text-green-60">Nationality</span>
                                <div class="text-muted small"><?php echo $freelancer['nationality'] ?></div>
                            </div>
                            <hr class="divider">
                            <div class="">
                                <span class="fas fa-language me-1 text-green-60"></span>
                                <span class="text-muted fw-semibold text-green-60">Language</span>
                                <div class="text-muted small"><?php echo $freelancer['language'] ?></div>
                            </div>
                        </div>
                    </div>                        
                </div>
                <!-- /sidebar profile card -->
                <!-- main content -->
                <div class="col-12 col-md-8 col-lg-9 p-3">
                    <div class="card shadow border-0">
                        <div class="card-body">
                            <!-- nav pills -->
                            <ul class="nav nav-pills mb-3 m-2" id="pills-tab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="pills-project-tab" data-bs-toggle="pill" data-bs-target="#pills-project" type="button" role="tab" aria-controls="pills-project" aria-selected="true">
                                        Project History
                                    </button>
                                </li>
                            </ul>
                            <!-- /nav pills -->
                            <!-- tab content -->
                            <div class="tab-content m-2" id="pills-tabContent">
                                <!-- project history: tab pane -->
                            <!-- project history: tab pane -->
                                <div class="tab-pane slide show active" id="pills-project" role="tabpanel" aria-labelledby="pills-project-tab">
                                    <?php foreach ($projects as $project): ?>
                                        <!-- dynamic project card -->
                                        <div class="card my-4 shadow-sm bg-light border rounded-3">
                                            <div class="card-body">
                                                <!-- title and cons -->
                                                <div class="col-12 col d-flex justify-content-between mb-2">
                                                    <div class="col-md-6 pt-2 d-flex bg- align-items-center">
                                                        <div
                                                        class="text-green-40 fw-semibold ps-2 fs-3">
                                                            <?php echo htmlspecialchars($project['project_title']); ?>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6 d-flex align-items-center justify-content-end pe-2">
                                                        <span class="">
                                                            <span class="text-muted">Worth:</span>
                                                            <span class="fw-semibold text-green-40"><?php echo htmlspecialchars($project['project_merit_worth']); ?></span>
                                                            <span class="fw-semibold text-green-40">Merits</span>
                                                        </span>
                                                    </div>
                                                </div>
                                                <hr class="divider mx-2">
                                                <!-- project category -->
                                                <div class="col-12 col d-flex align-items-center justify-content-between mb-2">
                                                    <span class="d-flex align-items-center p-2 rounded-3 text-green-40">
                                                        <span class="fas fa-diagram-project fs-5"></span>
                                                        <span class="px-2 fs-5 fw-semibold"><?php echo htmlspecialchars($project['project_category']); ?></span>
                                                    </span>
                                                </div>
                                                <!-- project description -->
                                                <div class="col-12 col d-flex align-items-center mt-2">
                                                    <div class="px-2 text-muted small text-justify">
                                                        <?php 
                                                        $description = htmlspecialchars($project['project_description']);
                                                        echo strlen($description) > 20 ? substr($description, 0, 20) . '...' : $description;
                                                        ?>
                                                    </div>
                                                </div>
                                                <hr class="divider mx-2 mt-3">
                                                <!-- client name and posted time -->
                                                <div class="col-12 col d-flex align-items-center px-2 pt-0 mt-0">
                                                    <div class="col-md-6 d-flex bg- align-items-center">
                                                        <span>
                                                            <span class="text-muted me-1">Posted by:</span>
                                                            <span class="fw-semibold text-green-40">
                                                                <?php 
                                                                    echo htmlspecialchars($project['first_name'] . ' ' . $project['last_name']); 
                                                                ?>
                                                            </span>
                                                        </span>
                                                    </div>
                                                    <div class="col-md-6 d-flex align-items-center justify-content-end">
                                                        <span class="text-muted small">
                                                            <?php 
                                                                echo htmlspecialchars(date('M j, Y', strtotime($project['created_at'])));
                                                            ?>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    <?php endforeach; ?>
                                </div>
                                <!-- /project history: tab pane -->
                            </div>
                            <!-- /tab content -->
                        </div>
                    </div>
                </div>    
                <!-- /main content -->
            </div>

        </div>
    </section>
</body>
</html>