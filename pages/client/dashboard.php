<?php
$mysqli1 = require ('../../connection.php');
$mysqli2 = require ('../../connection.php');
$mysqli3 = require ('../../connection.php');
$mysqli4 = require ('../../connection.php');

require ('../../connection.php');
if (!isset($_SESSION['user_id'])) {
    header("Location: ../../dist/php/login.php");; //to be updated to landing page if done(index.php)
    exit;
}
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

// Count projects
$projects_query = "SELECT COUNT(*) as project_count 
                  FROM client_projects 
                  WHERE user_id = ?";
$stmt = $mysqli1->prepare($projects_query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$project_count = $stmt->get_result()->fetch_assoc()['project_count'];

// Count hired freelancers
$freelancers_query = "SELECT COUNT(DISTINCT fa.user_id) as freelancer_count 
                      FROM freelancer_applications fa
                      JOIN client_projects cp ON fa.project_id = cp.project_id
                      WHERE cp.user_id = ? AND fa.application_status = 'accepted'";
$stmt = $mysqli2->prepare($freelancers_query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$freelancer_count = $stmt->get_result()->fetch_assoc()['freelancer_count'];

// Count total applications
$applications_query = "SELECT COUNT(*) as application_count 
                      FROM freelancer_applications fa
                      JOIN client_projects cp ON fa.project_id = cp.project_id
                      WHERE cp.user_id = ? AND fa.application_status = 'pending'";
$stmt = $mysqli3->prepare($applications_query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$application_count = $stmt->get_result()->fetch_assoc()['application_count'];

//skills query
$skills_query = "CALL sp_get_skills";
$skills_result = mysqli_query($mysqli4, $skills_query);

$skills_by_category = [];
while ($row = mysqli_fetch_assoc($skills_result)) {
    $skills_by_category[$row['skill_category']][] = $row;
}
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
            <div class="row mt-4">
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
                        <div class="px-3 pb-3 pt-2 rounded-2 bg-light shadow d-flex align-items-center">
                            <div class="col-7 d-flex flex-column align-items-start mt-1">
                                <div class="fw-bold fs-2 ps-2"><?php echo htmlspecialchars($freelancer_count ?? 0); ?></div>
                                <div class="fs-6 ps-2">Freelancers</div>
                            </div>
                            <div class="col-5 d-flex justify-content-center align-items-center mt-2">
                                <i class="fas fa-briefcase fa-4x text-green-50"></i>
                            </div>
                        </div>
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
                                                // Echo option for each category
                                                echo "<option value=\"$category\">$category</option>";
                                            }
                                        ?>
                                    </select>
                                </div>
                                <!-- /filter -->
                                <!-- sort -->
                                <div class="col-md-5 d-flex align-items-center bg- p-2">
                                    <select class="form-select no-outline-green-focus me-2 bg-light" aria-label="Sort Projects">
                                        <option selected disabled>Sort Projects:</option>
                                        <option value="">Project Title</option>
                                        <option value="">Time Posted</option>
                                    </select>
                                    <button class="btn btn-light border me-1">
                                        <i class="fas fa-arrow-up"></i>
                                    </button>
                                    <button class="btn btn-light border me-1">
                                        <i class="fas fa-arrow-down"></i>
                                    </button>
                                </div>
                                <!-- /sort -->
                            </div>
                        </div>
                        <!-- /filter and sort -->
                        <!-- search -->
                        <div class="col-lg-3 col-12">
                            <div class="input-group">
                                <input type="text" name="search" class="form-control no-outline-green-focus border-end-0" placeholder="Search">
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

                        </div>
                    </div>
                </div>
            </div>
            <!-- /projects -->
        </div>
    </section>
</body>
</html>