document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const projectId = urlParams.get('id');
    window.projectId = projectId;
    // Accept submission
    document.querySelectorAll('.accept-submission').forEach(button => {
        button.addEventListener('click', function() {
            const submissionId = this.dataset.submissionId;
            updateSubmissionStatus(submissionId, 3);
        });
    });

    // Reject submission
    document.querySelectorAll('.reject-submission').forEach(button => {
        button.addEventListener('click', function() {
            const submissionId = this.dataset.submissionId;
            
            Swal.fire({
                title: 'Reject Submission',
                html: `
                    <textarea id="rejectionComment" class="form-control" 
                    placeholder="Enter rejection reason"></textarea>
                `,
                showCancelButton: true,
                confirmButtonText: 'Reject',
                cancelButtonText: 'Cancel',
                preConfirm: () => {
                    return document.getElementById('rejectionComment').value;
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    updateSubmissionStatus(submissionId, 4, result.value);
                }
            });
        });
    });
});

function updateSubmissionStatus(submissionId, status, comment = null) {
    fetch('../../dist/php/process/proc_update_submission_status.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            submission_id: submissionId,
            project_id: projectId,
            status: status,
            comment: comment
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            const projectStatusBadge = document.querySelector('.badge.bg-success.mb-2');
            if (projectStatusBadge && status === 3) {
                projectStatusBadge.textContent = 'Completed'; // Update project status if needed
            }

            const statusBadge = document.querySelector(`.submission-status[data-submission-id="${submissionId}"]`);
            if (statusBadge) {
                const statusText = status === 3 ? 'Accepted' : 'Rejected';
                statusBadge.textContent = statusText; // Update individual submission status
            }

            const acceptButton = document.querySelector(`.accept-submission[data-submission-id="${submissionId}"]`);
            const rejectButton = document.querySelector(`.reject-submission[data-submission-id="${submissionId}"]`);
            if (acceptButton) acceptButton.remove(); // Remove accept button after action
            if (rejectButton) rejectButton.remove(); // Remove reject button after action

            // Dynamically update the main submissions status
            const submissionsBadge = document.querySelector('.badge.bg-success.mb-2.extra-class');
            if (submissionsBadge) {
                submissionsBadge.textContent = status === 3 ? 'Accepted' : 'Rejected'; // Update the status badge
            }

            Swal.fire({
                icon: 'success',
                title: 'Status Updated',
                text: 'The submission status has been updated successfully'
            });
        }
    });
}






