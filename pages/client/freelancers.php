<?php 

require ('../../connection.php');
if (!isset($_SESSION['user_id'])) {
    header("Location: ../../dist/php/login.php");; //to be updated to landing page if done(index.php)
    exit;
}
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

//freelancers query
$freelancers_query = "SELECT * FROM v_applications
                      JOIN v_applications_ids ON v_applications.id = v_applications_ids.id
                      LEFT JOIN v_project_details ON v_project_details.id = v_applications_ids.project_id
                      LEFT JOIN v_user_profile ON v_user_profile.id = v_applications_ids.user_id
                      LEFT JOIN v_freelancer_connects_and_merits ON v_applications_ids.user_id = v_freelancer_connects_and_merits.id
                      WHERE v_project_details.project_owner = ? AND v_applications.status = 'accepted'";
                     
$stmt = $mysqli->prepare($freelancers_query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$freelancers = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | All Freelancers</title>
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

    <!-- freelancer.js JS -->
    <script src="../../dist/js/freelancers.js"></script>

</head>
<body>
    <section class="container-fluid poppins">
        <div class="container">
            <!-- Profile Header -->
            <div class="row mt-4 align-items-center">
                <!-- Profile Title -->
                <div class="col-12 col-md-6">
                    <h2 class="text-start">Freelancers</h2>
                </div>
                <!-- Breadcrumb Navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="dashboard.php"><?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">All Freelancers</li>
                        </ol>
                    </nav>
                </div>
            </div>
             
            <!-- freelancers -->
            <div class="row mt-4">
                <div class="container px-3">
                    <div class="card mb-4 shadow border-0 rounded-3">
                        <div class="card-body">
                            <div class="row my-3 mx-1 border-0">
                                <h3>Your Freelancers</h3>
                            </div>
                            <div class="row px-4">
                                <?php if (empty($freelancers)): ?>
                                    <div class="col-12 text-center py-4">
                                        <h5 class="text-muted">No freelancers found</h5>
                                    </div>
                                <?php else: ?>
                                    <?php foreach ($freelancers as $freelancer): ?>
                                        <!-- freelancer card -->
                                        <div class="col-12 p-4 rounded shadow-sm border mb-3 bg-light">
                                            <div class="col-12 d-flex">
                                                <div class="col-md-1">
                                                    <img src="<?php echo !empty($freelancer['profile_picture_url']) ? $freelancer['profile_picture_url'] : '../../img/default-profile.png'; ?>" 
                                                        alt="<?php echo htmlspecialchars($freelancer['first_name']); ?>'s profile picture" 
                                                        class="rounded-circle" 
                                                        style="width: 80px; height: 80px;"
                                                        onerror="this.onerror=null; this.src='../../img/default-profile.png';">
                                                </div>
                                                <div class="col-md-4">
                                                    <h6 class="text-muted"><?php echo htmlspecialchars($freelancer['job_title']); ?></h6>
                                                    <h5 class="fw-semibold"><?php echo htmlspecialchars($freelancer['first_name'] . ' ' . $freelancer['last_name']); ?></h5>
                                                    <h6 class="small text-muted"><?php echo htmlspecialchars($freelancer['project_title']); ?></h6>
                                                </div>
                                                <div class="col-md-3 d-flex flex-column">
                                                    <p class="mb-2 text-muted d-flex align-items-center">
                                                        <i class="fas fa-star me-2"></i>
                                                        <span class="small"><?php echo htmlspecialchars($freelancer['merits']); ?> Merits</span>
                                                    </p>
                                                    <p class="mb-2 text-muted d-flex align-items-center">
                                                        <i class="fas fa-envelope me-2"></i>
                                                        <span class="small"><?php echo htmlspecialchars($freelancer['email']); ?></span>
                                                    </p>
                                                    <p class="mb-2 text-muted d-flex align-items-center">
                                                        <i class="fas fa-phone me-2"></i>
                                                        <span class="small"><?php echo htmlspecialchars($freelancer['mobile_number']); ?></span>
                                                    </p>
                                                </div>
                                                <div class="col-md-4 d-flex justify-content-end align-items-center">
                                                    <a href="view_freelancer.php?id=<?php echo $freelancer['user_id']; ?>" 
                                                        class="btn btn-outline-secondary me-2">
                                                        View Freelancer
                                                    </a>
                                                    <button class="btn btn-danger remove-btn"
                                                        data-freelancer-id="<?php echo $freelancer['user_id']; ?>"
                                                        data-project-id="<?php echo $freelancer['project_id']; ?>">
                                                        Terminate
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- /freelancer card -->
                                    <?php endforeach; ?>
                                <?php endif; ?>
                            </div>
                        </div>
                    </div>
                </div>
            </div>   
            <!-- freelancers -->

        </div>
    </section>
</body>
</html>
