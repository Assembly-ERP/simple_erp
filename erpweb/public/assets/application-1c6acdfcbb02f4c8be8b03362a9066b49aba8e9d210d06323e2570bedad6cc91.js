// app/javascript/application.js
import { Turbo } from "@hotwired/turbo-rails";
import * as ActiveStorage from "@rails/activestorage";
import "controllers";
 
import axiosHelper from './axiosHelper';
import "./customer_search";
import { openModal, closeModal, previewFile, closeFileModal } from './preview';


ActiveStorage.start();
Turbo.start();

// Dispatch axios:loaded event
document.addEventListener('DOMContentLoaded', () => {
    if (typeof axios !== 'undefined') {
      document.dispatchEvent(new Event('axios:loaded'));
    }
  
    console.log('application.js loaded');
    window.openModal = openModal;
    window.closeModal = closeModal;
    window.previewFile = previewFile;
    window.closeFileModal = closeFileModal;

  const customerSearchInput = document.getElementById('customer-search-input');
  const customerList = document.getElementById('customer-list');
  const customerSelect = document.getElementById('user_customer_id');
  const newCustomerModal = document.getElementById('new-customer-modal');
  const closeModalButton = document.getElementById('close-modal');
  const newCustomerForm = document.getElementById('new-customer-form');

  if (customerSearchInput) {
    const jwsToken = localStorage.getItem('jwt'); // Assuming JWT is stored in localStorage
    axios.defaults.headers.common['Authorization'] = `Bearer ${jwsToken}`;
    axios.defaults.headers.common['Content-Type'] = 'application/json';

    customerSearchInput.addEventListener('input', function() {
      if (customerSearchInput.value.length > 0) {
        axiosHelper.get('/operational_portal/customers/search', {
          params: { query: customerSearchInput.value }
        })
        .then(response => {
          const data = response.data;
          customerList.innerHTML = '';
          data.forEach(customer => {
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
        if (customerSelect) {
          const option = new Option(customerName, customerId, true, true);
          customerSelect.add(option);
          customerSelect.value = customerId;
        }
        customerList.innerHTML = '';
        customerSearchInput.value = customerName;
      } else if (event.target && event.target.id === 'add-new-customer') {
        if (newCustomerModal) {
          newCustomerModal.style.display = 'block';
        }
      }
    });

    if (closeModalButton) {
      closeModalButton.addEventListener('click', function() {
        if (newCustomerModal) {
          newCustomerModal.style.display = 'none';
        }
      });
    }

    if (newCustomerForm) {
      newCustomerForm.addEventListener('submit', function(event) {
        event.preventDefault();
        const formData = new FormData(newCustomerForm);
        axiosHelper.post(newCustomerForm.action, formData, {
          headers: { 'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content') }
        })
        .then(response => {
          const data = response.data;
          if (customerSelect) {
            const option = new Option(data.name, data.id, true, true);
            customerSelect.add(option);
            customerSelect.value = data.id;
          }
          if (newCustomerModal) {
            newCustomerModal.style.display = 'none';
          }
          customerSearchInput.value = data.name;
          customerList.innerHTML = '';
        })
        .catch(error => {
          console.error('Error creating new customer:', error);
        });
      });
    }
  }
});

