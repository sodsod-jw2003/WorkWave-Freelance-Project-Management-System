document.addEventListener('DOMContentLoaded', function() {
    // Handle hire button clicks
    document.querySelectorAll('.hire-btn').forEach(button => {
        button.addEventListener('click', function() {
            updateApplicationStatus(this.dataset.applicationId, 'accepted', this);
        });
    });

    // Handle remove button clicks
    document.querySelectorAll('.remove-btn').forEach(button => {
        button.addEventListener('click', function() {
            if(confirm('Are you sure you want to reject this application?')) {
                updateApplicationStatus(this.dataset.applicationId, 'rejected', this);
            }
        });
    });

    function updateApplicationStatus(applicationId, status, buttonElement) {
        const formData = new FormData();
        formData.append('application_id', applicationId);
        formData.append('status', status);
    
        fetch('../../dist/php/process/proc_update_application_status.php', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
                
                const applicationCard = buttonElement.closest('.col-12');
                applicationCard.remove();
            } else {
                alert('An application is already accepted for this project');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('An error occurred while updating the application');
        });
    }
});
