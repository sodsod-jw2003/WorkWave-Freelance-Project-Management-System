<?php 

require ('../../connection.php');
$mysqli = require ('../../connection.php');
if (!isset($_SESSION['user_id'])) {
    header("Location: ../../dist/php/login.php");; //to be updated to landing page if done(index.php)
    exit;
}
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

$user_id = $_SESSION['user_id'];

// Query to get connects and merits
$query = "SELECT connects, merits FROM v_freelancer_connects_and_merits WHERE id = ?";
$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();
$stats = $result->fetch_assoc();

// Default values if no results found
$connects = $stats['connects'] ?? 0;
$merits = $stats['merits'] ?? 0;

// Count projects
$projects_query = "SELECT COUNT(DISTINCT v_applications_ids.project_id) AS project_count
                   FROM v_applications
                   JOIN v_applications_ids ON v_applications.id = v_applications_ids.id
                   WHERE v_applications_ids.user_id = ? AND status = 'accepted'";

$stmt = $mysqli->prepare($projects_query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$project_count = $stmt->get_result()->fetch_assoc()['project_count'];

// Count objectives
$objectives_query = "SELECT COUNT(DISTINCT id) AS objective_count
                     FROM v_freelancer_submissions
                     WHERE user_id = ? AND (status = 'pending' OR status = 'rejected')";
$stmt = $mysqli->prepare($objectives_query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$objective_count = $stmt->get_result()->fetch_assoc()['objective_count'];

// Count clients
$clients_query = "SELECT COUNT(DISTINCT v_project_details.project_owner) AS client_query
                   FROM v_applications
                   JOIN v_applications_ids ON v_applications.id = v_applications_ids.id
                   JOIN v_project_details ON v_project_details.id = v_applications_ids.project_id
                   WHERE v_applications_ids.user_id = ? AND v_applications.status = 'accepted'";
$stmt = $mysqli->prepare($clients_query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$client_count = $stmt->get_result()->fetch_assoc()['client_query'];


// Project
$project_query = "SELECT v_project_details.*, 
                          CONCAT(v_user_profile.first_name, ' ', v_user_profile.last_name) AS client_name 
                   FROM v_project_details
                   JOIN v_user_profile ON v_project_details.project_owner = v_user_profile.id
                   WHERE project_status = 'hiring'
                   ORDER BY created_at DESC";
$result = $mysqli->query($project_query);
$projects = $result->fetch_all(MYSQLI_ASSOC);

//skills query
$skills_query = "SELECT * FROM v_skills_with_category ORDER BY category, skill";
$skills_result = mysqli_query($mysqli, $skills_query);

$skills_by_category = [];
while ($row = mysqli_fetch_assoc($skills_result)) {
    $skills_by_category[$row['category']][] = $row;
}

$category_icons = [
    'Writing' => 'fa-solid fa-pen-nib',
    'Translation' => 'fa-solid fa-language',
    'Graphic Design' => 'fa-solid fa-user-pen',
    'Video and Animation' => 'fa-solid fa-video',
    'UI/UX Design' => 'fa-brands fa-figma',
    'Web Development' => 'fa-solid fa-globe',
    'Mobile Development' => 'fa-solid fa-mobile',
    'Software Development' => 'fa-solid fa-file-code',
    'Digital Marketing' => 'fa-solid fa-store',
    'Sales Support' => 'fa-solid fa-phone',
    'Advertising' => 'fa-solid fa-phone',
    'Virtual Assistance' => 'fa-solid fa-headset',
    'Data Entry' => 'fa-solid fa-database',
    'Customer Support' => 'fa-solid fa-phone',
    'Financial Skills' => 'fa-solid fa-coins',
    'Business Consulting' => 'fa-solid fa-briefcase',
    'Human Resources' => 'fa-solid fa-users',
    'IT Support' => 'fa-solid fa-screwdriver-wrench',
    'Networking' => 'fa-solid fa-network-wired',
    'DevOps' => 'fa-solid fa-gears',
    'Engineering' => 'fa-solid fa-helmet-safety',
    'Architecture' => 'fa-brands fa-unity',
    'Manufacturing' => 'fa-solid fa-industry',
    'Coaching & Development' => 'fa-solid fa-notes-medical',
    'Health & Wellness' => 'fa-solid fa-shield-heart',
    'Contract & Documentation' => 'fa-solid fa-file-contract',
    'Compliance & Research' => 'fa-solid fa-book',
    'Data Processing' => 'fa-solid fa-chart-simple',
    'Advanced Analytics' => 'fa-solid fa-chart-line',
    'Game Development Support' => 'fa-solid fa-gamepad',
    'Monetization & Coaching' => 'fa-solid fa-chalkboard-user',
];
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Freelancer Dashboard</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

    <!-- freelancer_dashboard.js -->
    <script src="../../dist/js/freelancer_dashboard.js" defer></script>
    <script src="https://cdn.botpress.cloud/webchat/v2.2/inject.js"></script>
    <script src="https://files.bpcontent.cloud/2024/12/12/18/20241212181227-C50YEH0A.js"></script>
</head>
<body>
<section class="container-fluid poppins">
    <div class="row d-flex justify-content-center">

        <!-- filter jobs -->
        <!-- <div class="col-md-2 col-12 bg-light min0vh-100">
        .
        </div> -->
        <!-- /filter jobs -->

        <!-- feed -->
        <div class="col-md-10 col-12">
            <!-- creds and cons -->
            <div class="row mx-0 my-3">
                <div class="col-10 col-lg-6 d-flex align-items-center mb-3 mb-lg-0">
                    <h2 class="m-0">Freelancer Dashboard</h2>
                </div>
                <div class="col-12 col-lg-6 pe-lg-3">
                    <div class="row d-flex justify-content-lg-end g-2">
                        <!-- creds -->
                        <div class="col-6 col-md-4 d-flex bg-green-30 text-white rounded shadow-sm border me-2">
                            <div class="col-5 d-flex justify-content-center align-items-center">
                                <i class="fas fa-star fa-2x p-3"></i>
                            </div>
                            <div class="col-7 d-flex justify-content-start align-items-center">
                                <div>
                                    <div class="text-start text-green-10 small">Merits</div>
                                    <div class="text-start fw-semibold" id="merits-count"><?php echo htmlspecialchars($merits); ?></div>
                                </div>
                            </div>
                        </div>
                        <!-- /creds -->
                        <!-- cons -->
                        <div class="col-6 col-md-4 d-flex bg-green-30 text-white rounded shadow-sm border">
                            <div class="col-5 d-flex justify-content-center align-items-center">
                                <i class="fas fa-handshake fa-2x p-3"></i>
                            </div>
                            <div class="col-7 d-flex justify-content-start align-items-center">
                                <div>
                                    <div class="text-start text-green-10 small">Connects</div>
                                    <div class="text-start fw-semibold" id="connects-count"><?php echo htmlspecialchars($connects); ?></div>
                                </div>
                            </div>
                        </div>
                        <!-- /cons -->
                    </div>
                </div>
            </div>
            <!-- /creds and cons -->
            <!-- projects, tasks, and clients -->
            <div class="row mx-0 my-3 g-4">
                <div class="col-12 col-md-4 p-2">
                    <a href="projects.php" class="px-3 pb-3 pt-2 rounded-2 bg-light shadow d-flex align-items-center text-decoration-none">
                        <div class="col-7 d-flex flex-column align-items-start mt-1">
                            <div class="fw-bold fs-2 ps-2 text-dark"><?php echo htmlspecialchars($project_count); ?></div>
                            <div class="fs-6 ps-2 text-green-50 fw-semibold">Your Projects</div>
                        </div>
                        <div class="col-5 d-flex justify-content-center align-items-center mt-2">
                            <i class="fas fa-diagram-project fa-4x text-green-50"></i>
                        </div>
                    </a>
                </div>
                <div class="col-12 col-md-4 p-2">
                    <a href="projects_objectives.php" class="px-3 pb-3 pt-2 rounded-2 bg-light shadow d-flex align-items-center text-decoration-none">
                        <div class="col-7 d-flex flex-column align-items-start mt-1">
                            <div class="fw-bold fs-2 ps-2 text-dark"><?php echo htmlspecialchars($objective_count); ?></div>
                            <div class="fs-6 ps-2 text-green-50 fw-semibold">Project Objectives</div>
                        </div>
                        <div class="col-5 d-flex justify-content-center align-items-center mt-2">
                            <i class="fas fa-list-check fa-4x text-green-50"></i>
                        </div>
                    </a>
                </div>
                <div class="col-12 col-md-4 p-2">
                    <a href="clients.php" class="px-3 pb-3 pt-2 rounded-2 bg-light shadow d-flex align-items-center text-decoration-none">
                        <div class="col-7 d-flex flex-column align-items-start mt-1">
                            <div class="fw-bold fs-2 ps-2 text-dark"><?php echo htmlspecialchars($client_count); ?></div>
                            <div class="fs-6 ps-2 text-green-50 fw-semibold">Clients</div>
                        </div>
                        <div class="col-5 d-flex justify-content-center align-items-center mt-2">
                            <i class="fas fa-user-tie fa-4x text-green-50"></i>
                        </div>
                    </a>
                </div>
            </div>
            <!-- /projects, tasks, and clients -->
            <!-- filter and sort -->
            <div class="row px-2 mb-4">
                <div class=" border-0 rounded-3">
                    <div class="d-flex align-items-center justify-content-between">
                        <!-- filter and sort -->
                        <div class="col-lg-6 col-md-12 mb-3 mb-lg-0 d-flex justify-content-between">
                            <div class="row w-100 align-items-center">
                                <!-- filter -->
                                <div class="col-md-4 p-2 ms-1">
                                    <select id="filterProjects" class="form-select no-outline-green-focus bg-light" >
                                        <option value="" selected disabled>Select Category</option>
                                        <?php
                                            foreach ($skills_by_category as $category => $skills) {
                                                // Add data attribute for debugging
                                                echo "<option value=\"" . htmlspecialchars($category) . "\">" . htmlspecialchars($category) . "</option>";
                                            }
                                        ?>
                                    </select>
                                </div>
                                <!-- /filter -->
                                <!-- sort -->
                                <div class="col-md-5 d-flex align-items-center bg- p-2">
                                <select class="form-select no-outline-green-focus me-2 bg-light" id="sortSelect" aria-label="Sort Projects">
                                    <option selected disabled>Sort Projects:</option>
                                    <option value="title">Project Title</option>
                                    <option value="date">Time Posted</option>
                                </select>
                                <button class="btn btn-light border me-1" id="sortAsc">
                                    <i class="fas fa-arrow-up text-secondary"></i>
                                </button>
                                <button class="btn btn-light border me-1" id="sortDesc">
                                    <i class="fas fa-arrow-down text-secondary"></i>
                                </button>
                                </div>
                                <!-- /sort -->
                            </div>
                        </div>
                        <!-- /filter and sort -->
                        <!-- search -->
                        <div class="col-lg-3 col-12">
                            <div class="input-group">
                                <!-- Search input -->
                                <input type="text" id="searchProjects" name="search" class="form-control no-outline-green-focus border-end-0" placeholder="Search">
                                <span class="input-group-text bg-transparent border-start-0">
                                    <i class="fas fa-search"></i>
                                </span>
                            </div>
                        </div>
                        <!-- /search -->
                    </div>
                </div>
            </div>
            <!-- /filter and sort -->
             
            <!-- project feed -->
            <div class="row px-1">
                <div class="container px-3">
                    <?php foreach($projects as $project): ?>
                        <!-- project card -->
                        <div class="card mb-4 shadow-sm bg-light border rounded-3">
                            <div class="card-body">
                                <!-- title and cons -->
                                <div class="col-12 col d-flex justify-content-between mb-2">
                                    <div class="col-md-6 pt-2 d-flex bg- align-items-center">
                                        <a href="project_application.php?id=<?php echo htmlspecialchars($project['id']); ?>" 
                                        class="text-green-40 fw-semibold ps-2 fs-3">
                                            <?php echo htmlspecialchars($project['project_title']); ?>
                                        </a>
                                    </div>
                                    <div class="col-md-3 bg- d-flex align-items-center justify-content-end pe-2">
                                        <span class="me-3">
                                            <span class="text-muted">Cost:</span>
                                            <span class="fw-semibold text-green-40"><?php echo htmlspecialchars($project['project_connect_cost']); ?></span>
                                            <span class="fw-semibold text-green-40">Connects</span>
                                        </span>
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
                                        <?php 
                                            $category = htmlspecialchars($project['project_category']);
                                            $icon = $category_icons[$category] ?? 'fa-solid fa-folder';
                                        ?>
                                        <i class="<?php echo $icon; ?> fs-5"></i>
                                        <span class="px-2 fs-5 fw-semibold"><?php echo $category; ?></span>
                                    </span>
                                    <!-- buttons -->
                                    <span class="d-flex align-items-center">
                                        <span class="d-flex align-items-center p-2 rounded-3">
                                            <div class="d-flex align-items-center">
                                                <a href="project_application.php?id=<?php echo htmlspecialchars($project['id']); ?>" class="btn p-0" id="apply-btn">
                                                    <i class="fas fa-hand fs-4 text-green-40"></i>
                                                </a>
                                            </div>
                                        </span>
                                        <span class="d-flex align-items-center p-2 me-2 rounded-3">
                                            <div class="d-flex align-items-center">
                                            <button class="btn p-0 heart-btn" data-project-id="<?php echo htmlspecialchars($project['id']); ?>">
                                                <i class="far fa-heart fs-4 text-danger heart-icon"></i>
                                            </button>
                                            </div>
                                        </span>
                                    </span>
                                </div>
                                <!-- project description -->
                                <div class="col-12 col d-flex align-items-center mt-2">
                                    <div class="px-2 text-muted small text-justify">
                                        <?php echo htmlspecialchars($project['project_description']); ?>
                                    </div>
                                </div>
                                <hr class="divider mx-2 mt-3">
                                <!-- client name and posted time -->
                                <div class="col-12 col d-flex align-items-center px-2 pt-0 mt-0">
                                    <div class="col-md-6 d-flex bg- align-items-center">
                                        <span>
                                            <span class="text-muted me-1">Posted by:</span>
                                            <span class="fw-semibold text-green-40"><?php echo htmlspecialchars($project['client_name']); ?></span>
                                        </span>
                                    </div>
                                    <div class="col-md-6 d-flex bg- align-items-center justify-content-end">
                                        <span class="text-muted small"><?php echo date('M j, Y', strtotime($project['created_at'])); ?></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>
            </div>
            <!-- /project feed -->

        <!-- /feed -->


        <!-- sidebar right -->
        <!-- <div class="col-md-2 col-12 bg-light ">
            .
        </div> -->
        <!-- /sidebar right -->
    </div>
</section>


</body>
</html>