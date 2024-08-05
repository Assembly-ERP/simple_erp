// app/javascripts/customer_user_form.js
document.addEventListener('DOMContentLoaded', function() {
  const roleSelect = document.querySelector('#user_role');
  const customerField = document.querySelector('.customer-field');

  if (roleSelect && customerField) {
    roleSelect.addEventListener('change', function() {
      if (roleSelect.value === 'customer_user_admin' || roleSelect.value === 'customer_user_regular') {
        customerField.style.display = 'block';
        customerField.querySelector('select').required = true;
      } else {
        customerField.style.display = 'none';
        customerField.querySelector('select').required = false;
      }
    });
  }
});
