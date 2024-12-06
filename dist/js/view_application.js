document.addEventListener('DOMContentLoaded', function() {
    // Handle hire button click
    document.querySelector('.hire-btn').addEventListener('click', function() {
        const applicationId = this.dataset.applicationId;
        
        const formData = new FormData();
        formData.append('application_id', applicationId);
        formData.append('status', 'accepted');

        fetch('../../dist/php/process/proc_view_application_hiring.php', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
                window.location.href = 'applications.php';
            } else {
                alert('An application is already accepted for this project');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('An error occurred');
        });
    });
});
