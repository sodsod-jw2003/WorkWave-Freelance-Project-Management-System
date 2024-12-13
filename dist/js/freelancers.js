document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.remove-btn').forEach(button => {
        button.addEventListener('click', function() {
            console.log('Freelancer ID:', this.dataset.freelancerId);
            console.log('Project ID:', this.dataset.projectId);
            terminateFreelancer(this.dataset.freelancerId, this.dataset.projectId);
        });
    });
});

function terminateFreelancer(freelancerId, projectId) {
    if (!freelancerId || !projectId) {
        Swal.fire('Error!', 'Missing required information', 'error');
        return;
    }

    Swal.fire({
        title: 'Are you sure?',
        text: "This will terminate the freelancer from your project",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Yes, terminate'
    }).then((result) => {
        if (result.isConfirmed) {
            fetch('../../dist/php/process/proc_terminate_freelancer.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `freelancer_id=${encodeURIComponent(freelancerId)}&project_id=${encodeURIComponent(projectId)}`
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response failed');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    const button = document.querySelector(`[data-freelancer-id="${freelancerId}"][data-project-id="${projectId}"]`);
                    const card = button.closest('.col-12.p-4.rounded.shadow-sm.border.mb-3.bg-light');
                    card.remove();
                    
                    Swal.fire(
                        'Terminated!',
                        'Freelancer has been terminated.',
                        'success'
                    );

                    // Check if no more freelancers
                    const remainingCards = document.querySelectorAll('.col-12.p-4.rounded.shadow-sm.border.mb-3.bg-light');
                    if (remainingCards.length === 0) {
                        const container = document.querySelector('.row.px-4');
                        container.innerHTML = `
                            <div class="col-12 text-center py-4">
                                <h5 class="text-muted">No freelancers found</h5>
                            </div>`;
                    }
                } else {
                    throw new Error(data.message || 'Operation failed');
                }
            })
            .catch(error => {
                Swal.fire(
                    'Error!',
                    error.message || 'Something went wrong.',
                    'error'
                );
            });
        }
    });
}


