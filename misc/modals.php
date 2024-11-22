<?php

require ('../../connection.php');

?>

<!DOCTYPE html>
<html lang="en">
<head>

    <!-- browser icon -->
    <link rel="icon" type="image/png" sizes="64x64" href="../../img/WorkWaveLogo.png">

    <!-- Bootstrap CSS from CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="../../dist/css/custom.css">

</head>
<body>

    <!-- logout confirmation modal -->
    <div class="modal fade poppins" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-green-40">
                    <h5 class="modal-title text-white" id="logoutModalLabel">Confirm Logout</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body m-3">Are you sure you want to logout?</div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="#" class="btn btn-danger">Logout</a>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
