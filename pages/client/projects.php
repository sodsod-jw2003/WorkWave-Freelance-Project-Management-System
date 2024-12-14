<?php 

require ('../../connection.php');
if (!isset($_SESSION['user_id'])) {
    header("Location: ../../dist/php/login.php");; //to be updated to landing page if done(index.php)
    exit;
}
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

$query = "SELECT * FROM v_project_details
          WHERE v_project_details.project_owner = ?
          ORDER BY created_at DESC;";

$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$projects = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

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
    'Advertising' => 'fa-solid fa-megaphone',
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
    'Monetization & Coaching' => 'fa-solid fa-chalkboard-user'
];

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
            <!-- add project -->
            <div class="col-12 my-3">
                <button class="btn btn-dark-green">
                    <i class="fas fa-plus me-2"></i>New Project
                </button>
                <div class="col-12 mt-3">
                    <form id="addProjectForm" class="needs-validation" novalidate>
                        <div class="card p-4 pb-3 mb-3 bg-light shadow-sm">
                            <div class="row">
                                <div class="col-md-5 mb-1">
                                    <label for="project_title" class="text-muted small mb-2 ms-1">Project Title</label>
                                    <input type="text" 
                                        name="project_title" 
                                        id="project_title" 
                                        class="form-control bg-white-100 no-outline-green-focus border-1" 
                                        required>
                                    <div class="invalid-feedback">Enter a project title.</div>
                                </div>
                                <div class="col-md-4 mb-1">
                                    <label for="project_category" class="text-muted small mb-2 ms-1">Category</label>
                                    <select 
                                        name="project_category" 
                                        id="project_category" 
                                        class="form-select bg-white-100 no-outline-green-focus border-1 w-100 project_category"
                                        required>
                                        <option value="" disabled selected>Select Category</option>
                                    </select>
                                    <div class="invalid-feedback">Select a category.</div>
                                </div>
                                <div class="col-md-3 mb-1">
                                    <label for="status" class="text-muted small mb-2 ms-1">Status</label>
                                    <select 
                                        name="status" 
                                        id="status" 
                                        class="form-select bg-white-100 no-outline-green-focus border-1 w-100"
                                        required>
                                        <option value="" disabled selected>Select Status</option>
                                        <option value="1">Hiring</option>
                                        <option value="2">In Progress</option>
                                        <option value="3">Completed</option>
                                    </select>
                                    <div class="invalid-feedback">Select a status.</div>
                                </div>
                            </div>
                            <div class="row mt-1">
                                <div class="col-md-12 mb-1">
                                    <label for="project_description" class="text-muted small mb-2 ms-1">Project Description</label>
                                    <textarea 
                                        name="project_description" 
                                        id="project_description" 
                                        class="form-control bg-white-100 no-outline-green-focus border-1"
                                        required></textarea>
                                    <div class="invalid-feedback">Enter a project description.</div>
                                </div>
                            </div>
                            <!-- newly added project objective -->
                            <div class="row mt-1">
                                <div class="col-md-12 mb-1">
                                    <label for="project_objective" class="text-muted small mb-2 ms-1">Project Objective</label>
                                    <textarea 
                                        name="project_objective" 
                                        id="project_objective" 
                                        class="form-control bg-white-100 no-outline-green-focus border-1"
                                        required></textarea>
                                    <div class="invalid-feedback">Enter a project objective.</div>
                                </div>
                            </div>
                            <!-- /newly added project objective -->
                            <div class="row mt-1">
                                <div class="col-md-6 mb-1">
                                    <label for="connect_cost" class="text-muted small mb-2 ms-1">Connect Cost</label>
                                    <input type="number" 
                                        name="connect_cost" 
                                        id="connect_cost" 
                                        class="form-control bg-white-100 no-outline-green-focus border-1" 
                                        min="5"
                                        max="10" 
                                        required>
                                    <div class="invalid-feedback">Enter a connect cost between 5 and 10.</div>
                                </div>
                                <div class="col-md-6 mb-1">
                                    <label for="merit_worth" class="text-muted small mb-2 ms-1">Merit</label>
                                    <input type="number" 
                                        name="merit_worth" 
                                        id="merit_worth" 
                                        class="form-control bg-white-100 no-outline-green-focus border-1" 
                                        min="10"
                                        max="50" 
                                        required>
                                    <div class="invalid-feedback">Enter a merit worth between 10 and 50.</div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="container pt-3 mb-3">
                                    <button type="submit" class="btn btn-dark-green">Save Project</button>
                                    <button type="button" class="btn btn-secondary" id="cancelAddProject">Cancel</button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <!-- add project -->
            <!-- projects -->
            <div class="row mt-4">
                <div class="container px-3">
                    <div class="card mb-4 shadow border-0 rounded-3">
                        <div class="card-body">
                            <div class="row my-3 mx-1 border-0">
                                <h3>Your Projects</h3>
                            </div>
                            <div class="row px-4">
                                <?php if ($projects): ?>
                                    <?php foreach($projects as $project): ?>
                                        <div class="col-12 d-flex justify-content-center align-items-center p-4 rounded shadow-sm border mb-3 bg-light">
                                            <div class="col-12">
                                                <div class="row align-items-center px-3 py-2 rounded-top">
                                                    <div class="col-md-6 d-flex align-items-center ps-0">
                                                        <h5 class="mb-0">
                                                            <a href="project_details.php?id=<?php echo htmlspecialchars($project['id']); ?>" class="text-green-50 fs-4 text-decoration-none fw-semibold">
                                                                <?php echo htmlspecialchars($project['project_title']); ?>
                                                            </a>
                                                            <span class="badge bg-secondary text-white ms-2 small">
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
                                                <div class="row align-items-center px-3 py-2 rounded-bottom">
                                                    <div class="col-md-6 d-flex align-items-center ms-0 ps-0">
                                                        <i class="<?php echo $category_icons[$project['project_category']] ?? 'fas fa-folder'; ?> me-3 text-green-50 fa-2x"></i>
                                                        <span class="fs-5">
                                                            <?php echo htmlspecialchars($project['project_category']); ?>
                                                        </span>
                                                    </div>
                                                    <div class="col-md-6 d-flex justify-content-end pe-0 ">
                                                        <a href="project_details.php?id=<?php echo htmlspecialchars($project['id']); ?>" 
                                                            class="btn btn-secondary me-2">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <button class="btn btn-primary me-2">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <button class="btn btn-danger">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
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
            <!-- /projects -->
        </div>
    </section>
</body>
</html>