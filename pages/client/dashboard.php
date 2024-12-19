<?php
$mysqli = require ('../../connection.php');

require ('../../connection.php');
if (!isset($_SESSION['user_id'])) {
    header("Location: /WorkWave/index.php");
    exit;
}
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

// Get all projects
$projects_list_query = "SELECT * FROM v_project_details 
                       WHERE project_owner = ? 
                       ORDER BY created_at DESC";
$stmt = $mysqli->prepare($projects_list_query);
$stmt->bind_param("i", $_SESSION['user_id']); 
$stmt->execute();
$projects = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Count projects
$projects_query = "SELECT COUNT(*) as project_count 
                  FROM v_project_details
                  WHERE project_owner = ?";
$stmt = $mysqli->prepare($projects_query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$project_count = $stmt->get_result()->fetch_assoc()['project_count'];

// Count hired freelancers
$freelancers_query = "SELECT COUNT(DISTINCT v_applications_ids.user_id) as freelancer_count 
                      FROM v_applications
                      JOIN v_applications_ids ON v_applications.id = v_applications_ids.id
                      JOIN v_project_details ON v_project_details.id = v_applications_ids.project_id
                      WHERE v_project_details.project_owner = ? AND v_applications.status = 'accepted'";
$stmt = $mysqli->prepare($freelancers_query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$freelancer_count = $stmt->get_result()->fetch_assoc()['freelancer_count'];

// Count total applications
$applications_query = "SELECT COUNT(*) as application_count 
                      FROM v_applications
                      JOIN v_applications_ids ON v_applications.id = v_applications_ids.id
                      JOIN v_project_details ON v_project_details.id = v_applications_ids.project_id
                      WHERE v_project_details.project_owner = ? AND v_applications.status = 'pending'";
$stmt = $mysqli->prepare($applications_query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$application_count = $stmt->get_result()->fetch_assoc()['application_count'];

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
    <title>WorkWave | Client Dashboard</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

    <!-- dashboard JS -->
    <script src="../../dist/js/client_dashboard.js" defer></script>

    <script src="https://cdn.botpress.cloud/webchat/v2.2/inject.js"></script>
    <script src="https://files.bpcontent.cloud/2024/12/12/18/20241212181227-C50YEH0A.js"></script>

</head>
<body>
    <section class="container-fluid poppins">
        <div class="container">
            <!-- Profile Header -->
            <div class="row mt-4 align-items-center">
                <!-- Profile Title -->
                <div class="col-12 col-md-6">
                    <h2 class="text-start">Client Dashboard</h2>
                </div>
                <!-- Breadcrumb Navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item active" aria-current="page"><?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard</li>
                        </ol>
                    </nav>
                </div>
            </div>
            <!-- contracts, projects, freelancers, and applications -->
            <div class="row">
                <!-- projects, tasks, and clients -->
                <div class="row mx-0 my-3 g-4">
                    <div class="col-12 col-md-4 p-2">
                        <a href="projects.php" class="px-3 pb-3 pt-2 rounded-2 bg-light shadow d-flex align-items-center no-deco">
                            <div class="col-7 d-flex flex-column align-items-start mt-1">
                                <div class="fw-bold fs-2 ps-2 text-dark"><?php echo htmlspecialchars($project_count ?? 0); ?></div>
                                <div class="fs-6 ps-2 text-green-50 fw-semibold">Projects</div>
                            </div>
                            <div class="col-5 d-flex justify-content-center align-items-center mt-2">
                                <i class="fas fa-diagram-project fa-4x text-green-50"></i>
                            </div>
                        </a>
                    </div>
                    <div class="col-12 col-md-4 p-2">
                        <a href="freelancers.php" class="px-3 pb-3 pt-2 rounded-2 bg-light shadow d-flex align-items-center no-deco">
                            <div class="col-7 d-flex flex-column align-items-start mt-1">
                                <div class="fw-bold fs-2 ps-2 text-dark"><?php echo htmlspecialchars($freelancer_count ?? 0); ?></div>
                                <div class="fs-6 ps-2 text-green-50 fw-semibold">Freelancers</div>
                            </div>
                            <div class="col-5 d-flex justify-content-center align-items-center mt-2">
                                <i class="fas fa-briefcase fa-4x text-green-50"></i>
                            </div>
                        </a>
                    </div>
                    <div class="col-12 col-md-4 p-2">
                        <a href="applications.php" class="px-3 pb-3 pt-2 rounded-2 bg-light shadow d-flex align-items-center no-deco">
                            <div class="col-7 d-flex flex-column align-items-start mt-1">
                                <div class="fw-bold fs-2 ps-2 text-dark"><?php echo htmlspecialchars($application_count ?? 0); ?></div>
                                <div class="fs-6 ps-2 text-green-50 fw-semibold">Applications</div>
                            </div>
                            <div class="col-5 d-flex justify-content-center align-items-center mt-2">
                                <i class="fas fa-hand fa-4x text-green-50"></i>
                            </div>
                        </a>
                    </div>
                </div>
                <!-- /projects, tasks, and clients -->
            </div>
            <!-- /contracts, projects, freelancers, and applications -->
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
                                                echo "<option value=\"$category\">$category</option>";
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
            <!-- projects -->
            <div class="row px-1">
                <div class="container px-3">
                    <div class="card mb-4 shadow border-0 rounded-3">
                        <div class="card-body">
                            <h4 class="m-2">Your Projects</h4>
                            <div class="row px-4 py-2">
                                <?php if ($projects): ?>
                                    <?php foreach($projects as $project): ?>
                                        <div class="col-12 d-flex justify-content-center align-items-center p-4 rounded shadow-sm border mb-3 bg-light">
                                            <div class="col-12">
                                                <!-- Project Title and Status -->
                                                <div class="row align-items-center px-3 py-2 rounded-top">
                                                    <div class="col-md-6 d-flex align-items-center ps-0">
                                                        <h5 class="mb-0">
                                                            <a href="project_details.php?id=<?php echo htmlspecialchars($project['id']); ?>" class="text-green-50 fs-4 text-decoration-none fw-semibold">
                                                                <?php echo htmlspecialchars($project['project_title']); ?>
                                                            </a>
                                                            <span class="badge text-white bg-secondary ms-2">
                                                                Posted <?php echo date('M j, Y', strtotime($project['created_at'])); ?>
                                                            </span>
                                                        </h5>
                                                    </div>
                                                    <div class="col-md-6 d-flex justify-content-end pe-0">
                                                        <span class="badge bg-success">
                                                            <?php echo htmlspecialchars($project['project_status']); ?>
                                                        </span>
                                                    </div>
                                                </div>
                                                <!-- Project Category -->
                                                <div class="row align-items-center px-3 py-2 rounded-bottom">
                                                    <div class="col-md-6 d-flex align-items-center ms-0 ps-0">
                                                        <i class="<?php echo $category_icons[$project['project_category']] ?? 'fas fa-folder'; ?> me-3 text-green-50 fa-2x"></i>
                                                        <span class="fs-5">
                                                            <?php echo htmlspecialchars($project['project_category']); ?>
                                                        </span>
                                                    </div>
                                                    <div class="col-md-6 d-flex justify-content-end pe-0">
                                                        <a href="project_details.php?id=<?php echo htmlspecialchars($project['id']); ?>" 
                                                        class="btn btn-outline-secondary me-0">
                                                            View Project
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    <?php endforeach; ?>
                                <?php else: ?>
                                    <div class="col-12 text-center py-4">
                                        <p>No projects found.</p>
                                    </div>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /projects -->
        </div>
    </section>
</body>
</html>