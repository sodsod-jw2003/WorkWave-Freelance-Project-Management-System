document.addEventListener('DOMContentLoaded', function() {
    // Handle hire button clicks
    document.querySelectorAll('.hire-btn').forEach(button => {
        button.addEventListener('click', function() {
            const applicationId = this.dataset.applicationId;

            const formData = new FormData();
            formData.append('application_id', applicationId);
            formData.append('status', '2');

            updateStatus(formData, this);
        });
    });

    // Handle remove button clicks
    document.querySelectorAll('.remove-btn').forEach(button => {
        button.addEventListener('click', function() {
            Swal.fire({
                title: 'Are you sure?',
                text: 'Do you want to reject this application?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, reject it',
                cancelButtonText: 'No, cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    const applicationId = this.dataset.applicationId;
                    const formData = new FormData();
                    formData.append('application_id', applicationId);
                    formData.append('status', '3');

                    updateStatus(formData, this);
                }
            });
        });
    });

    function updateStatus(formData, buttonElement) {
        fetch('../../dist/php/process/proc_update_application_status.php', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
                const applicationCard = buttonElement.closest('.col-12');
                applicationCard.remove();
                
                Swal.fire({
                    icon: 'success',
                    title: 'Status Updated',
                    text: 'Application status has been updated successfully'
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Update Failed',
                    text: data.message || 'Failed to update application status'
                });
            }
        })
        .catch(error => {
            console.error('Error:', error);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'An error occurred while updating the application'
            });
        });
    }
});
