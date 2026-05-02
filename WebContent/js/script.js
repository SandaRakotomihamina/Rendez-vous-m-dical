// Scripts JavaScript personnalisés
document.addEventListener('DOMContentLoaded', function() {
    // Validation des formulaires
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            // Ajouter des validations personnalisées si nécessaire
        });
    });

    // Format de la date pour les champs datetime-local
    const dateInputs = document.querySelectorAll('input[type="datetime-local"]');
    dateInputs.forEach(input => {
        input.addEventListener('change', function() {
            // Vérifier que la date n'est pas dans le passé
            const selectedDate = new Date(this.value);
            const now = new Date();
            
            // Ajouter 30 minutes à l'heure actuelle pour plus de flexibilité
            now.setMinutes(now.getMinutes() + 30);
            
            if (selectedDate < now) {
                alert('Veuillez sélectionner une date et heure futurs');
                this.value = '';
            }
        });
    });

    // Confirmation avant annulation
    const cancelButtons = document.querySelectorAll('button[data-action="cancel"]');
    cancelButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            if (!confirm('Êtes-vous sûr de vouloir annuler ce rendez-vous?')) {
                e.preventDefault();
            }
        });
    });
});

// Fonction pour afficher les heures disponibles
function loadAvailableTimeslots(medecinId, date) {
    if (!date) return;
    
    const xhr = new XMLHttpRequest();
    xhr.open('GET', `get-timeslots.jsp?medecin_id=${medecinId}&date=${date}`, true);
    xhr.onload = function() {
        if (xhr.status === 200) {
            const timeslots = JSON.parse(xhr.responseText);
            const select = document.getElementById('timeslot_select');
            
            if (select) {
                select.innerHTML = '';
                timeslots.forEach(slot => {
                    const option = document.createElement('option');
                    option.value = slot;
                    option.textContent = slot;
                    select.appendChild(option);
                });
            }
        }
    };
    xhr.send();
}

// Fonction pour formater la date au format ISO
function formatDateToISO(dateString) {
    const date = new Date(dateString);
    return date.toISOString().slice(0, 16);
}

// Afficher/masquer les sections
function toggleSection(sectionId) {
    const section = document.getElementById(sectionId);
    if (section) {
        section.style.display = section.style.display === 'none' ? 'block' : 'none';
    }
}
