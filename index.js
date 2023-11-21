 document.addEventListener('DOMContentLoaded', () => {
          const registrationForm = document.getElementById('registrationForm');
          const dataTableBody = document.querySelector('#dataTable tbody');
      
          registrationForm.addEventListener('submit', function (event) {
            event.preventDefault();
      
            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const dob = document.getElementById('dob').value;
            const acceptedTerms = document.getElementById('terms').checked;
      
            // Validate date of birth (simple age check)
            const dobDate = new Date(dob);
            const today = new Date();
            const age = today.getFullYear() - dobDate.getFullYear();
      
            if (age < 18 || age > 55) {
              alert('Age must be between 18 and 55.');
              return;
            }
      
            // Save data to localStorage
            const userData = {
              name,
              email,
              password,
              dob,
              acceptedTerms
            };
      
            let storedData = JSON.parse(localStorage.getItem('userData')) || [];
      
            if (!Array.isArray(storedData)) {
              storedData = [];
            }
      
            storedData.push(userData);
            localStorage.setItem('userData', JSON.stringify(storedData));
      
            // Display data in table
            const newRow = dataTableBody.insertRow();
            newRow.innerHTML = `<td>${name}</td><td>${email}</td><td>${password}</td><td>${dob}</td><td>${acceptedTerms ? 'Yes' : 'No'}</td>`;
      
            // Clear form fields
            registrationForm.reset();
          });
      
          // Load saved data from localStorage
          let savedData = JSON.parse(localStorage.getItem('userData')) || [];
          
          if (!Array.isArray(savedData)) {
            savedData = [];
          }
      
          savedData.forEach(data => {
            const newRow = dataTableBody.insertRow();
            newRow.innerHTML = `<td>${data.name}</td><td>${data.email}</td><td>${data.password}</td><td>${data.dob}</td><td>${data.acceptedTerms ? 'Yes' : 'No'}</td>`;
          });
      
          // Make the table visible
          document.getElementById('dataTable').classList.remove('hidden');
        });
