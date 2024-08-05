// app/javascripts/customer_search.js

document.addEventListener('DOMContentLoaded', function() {
  const customerSearchInput = document.getElementById('customer-search-input');
  const customerList = document.getElementById('customer-list');
  const customerSelect = document.getElementById('user_customer_id');
  const newCustomerModal = document.getElementById('new-customer-modal');
  const closeModalButton = document.getElementById('close-modal');
  const newCustomerForm = document.getElementById('new-customer-form');

  if (customerSearchInput) {
    customerSearchInput.addEventListener('input', function() {
      if (customerSearchInput.value.length > 0) {
        axios.get(`/operational_portal/customers/search`, {
          params: { query: customerSearchInput.value },
          headers: { 'Accept': 'application/json' }
        })
        .then(response => {
          customerList.innerHTML = '';
          response.data.forEach(customer => {
            const li = document.createElement('li');
            li.textContent = customer.name;
            li.setAttribute('data-id', customer.id);
            li.classList.add('customer-item');
            customerList.appendChild(li);
          });
          const li = document.createElement('li');
          li.textContent = 'Add New';
          li.setAttribute('id', 'add-new-customer');
          customerList.appendChild(li);
        })
        .catch(error => {
          console.error('Error fetching customer data:', error);
        });
      } else {
        customerList.innerHTML = '';
      }
    });

    customerList.addEventListener('click', function(event) {
      if (event.target && event.target.classList.contains('customer-item')) {
        const customerId = event.target.getAttribute('data-id');
        const customerName = event.target.textContent;
        const option = new Option(customerName, customerId, true, true);
        customerSelect.add(option);
        customerSelect.value = customerId;
        customerList.innerHTML = '';
        customerSearchInput.value = customerName;
      } else if (event.target && event.target.id === 'add-new-customer') {
        newCustomerModal.style.display = 'block';
      }
    });

    closeModalButton.addEventListener('click', function() {
      newCustomerModal.style.display = 'none';
    });

    newCustomerForm.addEventListener('submit', function(event) {
      event.preventDefault();
      const formData = new FormData(newCustomerForm);
      axios.post(newCustomerForm.action, formData, {
        headers: { 'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content') }
      })
      .then(response => {
        const data = response.data;
        if (customerSelect) {
          const option = new Option(data.name, data.id, true, true);
          customerSelect.add(option);
          customerSelect.value = data.id;
        }
        newCustomerModal.style.display = 'none';
        customerSearchInput.value = data.name;
        customerList.innerHTML = '';
      })
      .catch(error => {
        console.error('Error creating new customer:', error);
      });
    });
  }
});