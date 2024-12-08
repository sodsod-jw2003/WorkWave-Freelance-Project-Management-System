document.addEventListener('DOMContentLoaded', function() {
    const proposalForm = document.getElementById('proposalForm');
    const submitBtn = document.getElementById('submitProposal');
    const cancelBtn = document.getElementById('cancelProposal');

    proposalForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // check form validity
        if (!proposalForm.checkValidity()) {
            // add client side validation if invalid
            proposalForm.classList.add('was-validated');
            return;
        }

        const formData = new FormData(this);
        formData.append('project_id', projectId); // projectId should be set in your PHP file

        submitBtn.disabled = true;
        
        fetch('../../dist/php/process/proc_submit_proposal.php', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
                // Update submit button to show status
                submitBtn.textContent = 'Status: Pending';
                submitBtn.disabled = true;
                
                // Change cancel button to withdraw
                cancelBtn.textContent = 'Withdraw Application';
                cancelBtn.classList.remove('btn-secondary');
                cancelBtn.classList.add('btn-danger');
                
                // swal success submission
                Swal.fire({
                    icon: 'success',
                    title: 'Proposal Submitted!',
                    text: 'Your proposal has been submitted successfully!',
                    confirmButtonText: 'Ok',
                    timer: 3000,
                    timerProgressBar: true
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Error!',
                    text: data.message,
                    confirmButtonText: 'Ok'
                });
                submitBtn.disabled = false;
            }
        })        
        .catch(error => {
            console.error('Error:', error);
            submitBtn.disabled = false;
        });
    });

    cancelBtn.addEventListener('click', function() {
        if (this.classList.contains('btn-danger')) {
            // confirmation before withdrawing applciation
            Swal.fire({
                title: 'Are you sure?',
                text: 'Do you really want to withdraw your application? This action cannot be undone.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, withdraw it!',
                cancelButtonText: 'No, keep it',
                reverseButtons: true
            }).then((result) => {
                if (result.isConfirmed) {
                    // Proceed with withdrawal if confirmed
                    fetch('../../dist/php/process/proc_withdraw_application.php', {
                        method: 'POST',
                        body: JSON.stringify({ project_id: projectId })
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // swal success withdrawal
                            Swal.fire({
                                icon: 'success',
                                title: 'Application Withdrawn!',
                                text: 'Your application has been successfully withdrawn.',
                                confirmButtonText: 'Ok',
                                timer: 3000, 
                                timerProgressBar: true
                            }).then(() => {
                                location.reload();
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error!',
                                text: data.message,
                                confirmButtonText: 'Ok'
                            });
                        }
                    });
                } else {
                    // swal cancel withdrwal
                    Swal.fire('Cancelled', 'Your application was not withdrawn.', 'info');
                }
            });
        } else {
            window.location.href = 'dashboard.php';
        }
    });
});
