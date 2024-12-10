
<?php foreach($projects as $project): ?>
    <div class="col-12 d-flex justify-content-center align-items-center p-4 rounded shadow-sm border mb-3 bg-light">
        <div class="col-12">
            <div class="row align-items-center px-3 py-2 rounded-top">
                <div class="col-md-6 d-flex align-items-center ps-0">
                    <h5 class="mb-0">
                        <a href="project_details.php?id=<?php echo htmlspecialchars($project['id']); ?>" class="text-muted text-decoration-none">
                            <?php echo htmlspecialchars($project['project_title']); ?>
                        </a>
                        <small class="text-muted ms-2">
                            • Posted <?php echo date('M j, Y', strtotime($project['created_at'])); ?>
                        </small>
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
                    <i class="<?php echo $category_icons[$project['project_category']] ?? 'fas fa-folder'; ?> me-2 text-green-50"></i>
                    <span class="fs-6">
                        <?php echo htmlspecialchars($project['project_category']); ?>
                    </span>
                </div>
                <div class="col-md-6 d-flex justify-content-end pe-0">
                    <a href="project_details.php?id=<?php echo htmlspecialchars($project['id']); ?>" 
                    class="btn btn-outline-secondary me-0">
                        <i class="fas fa-eye"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
<?php endforeach; ?>
