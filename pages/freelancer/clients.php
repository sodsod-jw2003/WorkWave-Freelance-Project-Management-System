<?php 

require ('../../connection.php');
if (!isset($_SESSION['user_id'])) {
    header("Location: /WorkWave/index.php");
}
include ('../../misc/modals.php');
include ('../../dist/php/process/proc_profile.php');
include ('header.php');

$query = "SELECT 
    v_project_details.*, 
    v_user_profile.*, 
    v_freelancer_submissions.*
FROM 
    v_project_details
LEFT JOIN 
    v_user_profile 
    ON v_project_details.project_owner = v_user_profile.id
LEFT JOIN 
    v_freelancer_submissions 
    ON v_freelancer_submissions.project_id = v_project_details.id
WHERE 
    v_freelancer_submissions.created_at = (
        SELECT MAX(sub.created_at)
        FROM v_freelancer_submissions AS sub
        JOIN v_project_details AS pd ON sub.project_id = pd.id
        WHERE pd.project_owner = v_project_details.project_owner
    )
AND 
    v_freelancer_submissions.user_id = ?
ORDER BY 
    v_freelancer_submissions.created_at DESC;
";

$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $_SESSION['user_id']);
$stmt->execute();
$clients = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);


?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WorkWave | Clients</title>
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Bootstrap JS from CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

    <script src="../../dist/js/clients.js" defer></script>
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
                    <h2 class="text-start">Clients</h2>
                </div>
                <!-- Breadcrumb Navigation -->
                <div class="col-12 col-md-6 d-flex justify-content-md-end mt-3 mt-md-0">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item"><a href="dashboard.php"><?php echo htmlspecialchars($user['first_name']); ?>'s Dashboard</a></li>
                            <li class="breadcrumb-item active" aria-current="page">All Clients</li>
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
                                <h3>Your Clients</h3>
                            </div>
                            <div class="row px-4">
                                    <!-- Loop through clients -->
                                    <?php if (!empty($clients)) : ?>
                                        <?php foreach ($clients as $client) : ?>
                                            <div class="p-4 mb-3 rounded shadow-sm border bg-light">
                                                <div class="col-12 d-flex align-items-center">
                                                    <div class="col-md-1">
                                                        <img src="<?php echo !empty($client['profile_picture_url']) ? $client['profile_picture_url'] : '../../img/default-profile.png'; ?>" 
                                                            alt="<?php echo htmlspecialchars($client['first_name']); ?>'s profile picture" 
                                                            class="rounded-circle" 
                                                            style="width: 80px; height: 80px;"
                                                            onerror="this.onerror=null; this.src='../../img/default-profile.png';">
                                                    </div>
                                                    <div class="col-md-4">
                                                        <h5 class="fw-semibold"><?php echo htmlspecialchars($client['first_name'] . ' ' . $client['last_name']); ?></h5>
                                                        <h6 class="text-muted"><?php echo htmlspecialchars($client['job_title'] ?? 'Job Title Unavailable'); ?></h6>
                                                    </div>
                                                    <div class="col-md-7 d-flex justify-content-end">
                                                        <a href="view_client.php?id=<?php echo htmlspecialchars($client['project_owner']); ?>" 
                                                        class="btn btn-outline-secondary me-0">
                                                            View Client
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        <?php endforeach; ?>
                                    <?php else : ?>
                                        <!-- No clients found -->
                                        <div class="col-12 text-center py-4">
                                            <p>No clients found.</p>
                                        </div>
                                    <?php endif; ?>
                                </div>
                                <!-- /client card -->

                            </div>
                        </div>
                    </div>
            </div>
            <!-- /projects -->
        </div>
    </section>
</body>
</html>