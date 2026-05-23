// Scripts JavaScript personnalisés
function initConfirmations() {
    const confirmElements = document.querySelectorAll('form[data-confirm], button[data-confirm], a[data-confirm]');
    confirmElements.forEach(element => {
        if (element.tagName === 'FORM') {
            element.addEventListener('submit', function(e) {
                if (!confirm(this.dataset.confirm)) {
                    e.preventDefault();
                }
            });
        } else {
            element.addEventListener('click', function(e) {
                if (!confirm(this.dataset.confirm)) {
                    e.preventDefault();
                }
            });
        }
    });
}

document.addEventListener('DOMContentLoaded', function() {
    initConfirmations();
    initAvailabilitySelectors();

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

function updateAvailabilityHiddenFields(form) {
    if (!form) return true;
    const startInput = form.querySelector('input[name="horaire_debut"]');
    const endInput = form.querySelector('input[name="horaire_fin"]');
    const hiddenHoraire = form.querySelector('input[name="horaire_journalier"]');
    const hiddenDays = form.querySelector('input[name="jours_travail"]');

    if (startInput && endInput && hiddenHoraire) {
        const start = startInput.value;
        const end = endInput.value;
        if ((start && !end) || (!start && end)) {
            alert('Veuillez remplir à la fois le début et la fin de l\'horaire.');
            return false;
        }
        if (start && end) {
            if (end <= start) {
                alert('L\'heure de fin ne peut pas être inférieure ou égale à l\'heure de début.');
                return false;
            }
            hiddenHoraire.value = `${start}-${end}`;
        } else {
            hiddenHoraire.value = '';
        }
    }

    if (hiddenDays) {
        const selectedDays = Array.from(form.querySelectorAll('.day-chip.selected')).map(chip => chip.dataset.day);
        hiddenDays.value = selectedDays.join(',');
    }

    return true;
}

function initAvailabilitySelectors() {
    const forms = document.querySelectorAll('form.availability-form');
    forms.forEach(form => {
        const chips = form.querySelectorAll('.day-chip');
        chips.forEach(chip => {
            chip.addEventListener('click', function(event) {
                event.preventDefault();
                this.classList.toggle('selected');
            });
        });

        form.addEventListener('submit', function(event) {
            if (!updateAvailabilityHiddenFields(form)) {
                event.preventDefault();
            }
        });
    });
}
