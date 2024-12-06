document.addEventListener('DOMContentLoaded', function() {
    const proposalForm = document.getElementById('proposalForm');
    const submitBtn = document.getElementById('submitProposal');
    const cancelBtn = document.getElementById('cancelProposal');

    proposalForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
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
                
                alert('Proposal submitted successfully!');
            } else {
                alert(data.message);
                submitBtn.disabled = false;
            }
        })        
        .catch(error => {
            console.error('Error:', error);
            console.log('Response:', error.response);
            submitBtn.disabled = false;
        });
    });

    cancelBtn.addEventListener('click', function() {
        if (this.classList.contains('btn-danger')) {
            // Withdraw application
            if (confirm('Are you sure you want to withdraw your application?')) {
                fetch('../../dist/php/process/proc_withdraw_application.php', {
                    method: 'POST',
                    body: JSON.stringify({ project_id: projectId })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                });
            }
        } else {
            window.location.href = 'dashboard.php';
        }
    });
});
