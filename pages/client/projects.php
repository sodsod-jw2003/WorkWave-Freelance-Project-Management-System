<?php 

require ('../../connection.php');
if (!isset($_SESSION['user_id'])) {
    header("Location: /WorkWave/index.php");
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
    
    <!-- SWAL -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
                <button class="btn btn-dark-green" id="addProject">
                    <i class="fas fa-plus me-2"></i>New Project
                </button>
            </div>

            <div id="projectFormContainer"></div>

            <!-- add project -->
            <!-- projects -->
            <div class="row mt-4">
                <div class="container px-3">
                    <div class="card mb-4 shadow border-0 rounded-3">
                        <div class="card-body">
                            <div class="row my-3 mx-1 border-0">
                                <h3>Your Projects</h3>
                            </div>
                            <!-- This is where projects will be loaded dynamically -->
                            <div class="row px-4">
                                <!-- Projects will be inserted here by loadProjects() -->
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